# XMX (DPAS) study on Xe2 / Arc Pro B60: peak, operand paths, roofline bound, native int4 x int8 backend experiment

All numbers measured on the B60 with the stand-alone programs in `tools/xmx/` (`xmxbench.cpp`, `w4a8_check.cpp`, `w4gemm.cpp`; build with `tools/xmx/build.sh`, run under the GPU lock). Nothing here touches the engine library or XeFlash.

## 1. DPAS micro-benchmark (`xmxbench`, 1280 hardware threads = 8 per EU, ESIMD `xmx::dpas`, B operand 512 B, effective TOPS = 2 x MAC / time)

Register-resident operands (no memory traffic):

| type (B x A) | repeat count RC (tokens) | independent accumulators | TOPS |
|---|---|---|---|
| fp16 | 1 | 1 / 2 / 4 / 8 | 7.7 / 24.1 / 24.2 / 24.3 |
| fp16 | 2 | 1 / 2 / 4 / 8 | 28.7 / 48.4 / 48.6 / 48.7 |
| fp16 | 4 | 1 / 2 / 4 / 8 | 56.2 / 96.7 / 97.1 / 97.3 |
| fp16 | 8 | 1 / 2 / 4 / 8 | 74.9 / 90.0 / **97.6** / 71.0 (8 accumulators spill: 8 x 8 + 8 x 8 GRF > 128) |
| bf16 | 8 | 1 / 4 / 8 | 74.9 / 97.6 / 71.1 |
| s8 x s8 (K = 32) | 8 | 1 / 4 / 8 | 149.9 / **195.2** / 142.1 |
| s4 x s4 (K = 64) | 8 | 1 / 4 / 8 | 299.4 / **390.7** / 284.4 |
| s4 (B) x s8 (A), K = 32, B only 256 B | 8 / 4 | 8 | 158.8 / 166.1 (mixed rate is below s8 x s8) |
| hf8 x hf8, bf8 x bf8 (native FP8 DPAS, K = 32) | 8 | 8 | 142.1 / 142.3 |
| tf32 | 8 | 8 | 35.5 |
| s2 | - | - | not accepted by the compiler (operand-size static assertion) |

Findings:
* **Issue interval**: fp16 DPAS peak (97.6 TOPS) is reached with RC >= 4; RC = 1, 2 give 1/4, 1/2 of it. A DPAS instruction occupies the XMX pipe for the same time for RC <= 4, i.e. **up to 4 tokens (query rows) cost no extra XMX time**; only RC = 8 doubles the time.
* **Dependent chain**: one accumulator reaches 77 % (RC = 8) / 31 % (RC = 1) of peak; two to four independent accumulators per thread reach peak when 8 threads per EU are resident; 8 accumulators spill the 128-GRF file (no large-GRF mode is used).
* int8 doubles and int4 quadruples the fp16 peak; FP8 DPAS is accepted and runs (142 TOPS) on this device.

B operand fed from different levels (RC = 8, 4 accumulators, TOPS / B-operand bandwidth):

| source of B (512 B per DPAS) | fp16 | s8 | s4 | limit |
|---|---|---|---|---|
| registers | 97.6 | 195 | 391 | XMX |
| SLM (`slm_block_load`) | 97.4 (12.2 TB/s) | 194.7 | 389.7 | XMX (SLM not limiting at RC = 8; with RC = 1..4 SLM supplies 14-24 TB/s) |
| 4 MB region shared by all threads (L1/L2 resident) | 30.9 (3.9 TB/s) | 60.8 | 123.7 | load path |
| 2 GB random data (DRAM, thread-contiguous stream like the tile-major weight layout) | 3.62 (452 GB/s) | 7.2 | 14.5 | DRAM |

The DRAM-fed rows reach 452 GB/s (99 % of the 456 GB/s peak) with a plain contiguous stream: the tile-major layout behaviour measured in the engine. (A first run with constant data gave 1.2 TB/s: constant data is compressed by the memory system; all numbers above use incompressible data.)

## 2. Roofline bound on XMX Active for weight-streaming kernels

Every weight is used for 2 x T operations (T tokens sharing the weight). With 4-bit weights at the 456 GB/s DRAM peak, 0.9 x 10^12 weights/s: effective ops = 1.8 TOPS x T. XMX Active of the fp16 pipe is therefore bounded by:

| T | 1 | 2 | 4 | 8 | 16 | 32 |
|---|---|---|---|---|---|---|
| bound (fp16 DPAS, peak 97.6 TOPS) | 1.9 % | 3.7 % | 7.4 % | 14.8 % | 29.6 % | 59 % |
| bound (s4 x s8 DPAS, peak ~160) | 1.1 % | 2.3 % | 4.5 % | 9 % | 18 % | 36 % |

Measured (VTune, whole forward, `docs/hw-counters.md`): 0.4-0.5 % at T = 1, 2.2-3.4 % at T = 8 / 16. The T = 1 value is within 4x of its bound, and about half of the step time is not weight streaming at all (small latency-bound kernels). At T = 8 / 16 the MoE kernels see only about 1.3-2 tokens per expert (64-128 (token, expert) pairs spread over ~50-80 distinct experts), so the weight-sharing factor is far below T and the bound for MoE kernels is correspondingly lower (about 2-4 % at T = 8); dense kernels (attention, LM head) share the weights across all T tokens and can reach the bound above. **XMX Active >= 30 % at T = 16 is only possible for kernels whose weights are shared by all 16 tokens (LM head: bound 29.6 %), not for the MoE experts.**

## 3. Native int4 x int8 DPAS: operand layout (verified) and streaming GEMM experiment

`w4a8_check`: mixed-precision `dpas<8, RC, int32, int32, int32, int32, s4, s8>` (K = 32): B operand = 64 dwords, dword `(k / 8) * 16 + n` holds nibbles `K = 8 (k/8) .. +7` of output column n (two's complement), A operand dword `d` of row m holds bytes `K = 4d .. 4d + 3`: 0 of 64 results differ from the integer reference.

`w4gemm` (MoE-like streaming GEMM: 1152 threads, each one 16-row block, K = 2304, 22.6 MB of 4-bit weights + fp16 group scales per call, rotating through 8 copies so every call streams from DRAM; all T tokens share the weights; roofline 49.5 us):

| T | native s4 x s8 (offline DPAS layout, int8 activations, int32 accumulate, scale per 64-K group) | expansion to fp16 (the engine's approach: shift / and / or / subtract, fp16 DPAS) |
|---|---|---|
| 1 | 51.6 us, 437 GB/s | 50.5 us, 447 GB/s |
| 2 | 50.3 us, 449 GB/s | 50.6 us, 446 GB/s |
| 4 | 50.3 us, 449 GB/s | 52.5 us, 430 GB/s |
| 8 | 50.8 us, 444 GB/s, 13.4 TOPS | 53.9 us, 419 GB/s, 12.6 TOPS |
| 16 | 52.1 us, 433 GB/s, 26.1 TOPS (16 % of the s4 x s8 peak) | 57.5 us, 393 GB/s, 23.7 TOPS (**24 % of the fp16 peak**) |

Conclusion of the experiment: with the weights streamed in a DPAS-friendly layout, **the ALU expansion is not what limits the engine's int4 kernels**: expansion reaches the DRAM roofline at T <= 8 and is only 10 % slower than the native int4 DPAS at T = 16. Native s4 x s8 would cost activation precision (int8 per 64-K group) and give at most about 10 % on the weight-GEMM part of a T = 16 pass and nothing at T = 1 .. 8; no native-format backend was merged. The engine's remaining gap to this harness (production MoE T = 8 runs at 37 % of the DRAM peak on average) comes from the routing structure (few tokens per expert, many distinct experts), launch / latency structure and the INT3 expansion, not from the DPAS operand format.

## 4. What this means for the engine

* T = 1: bound 1.9 %, measured 0.5 %: the step is limited by DRAM bytes (floor 4.8 ms of the 10.1 ms step) and by ~900 dependent small kernels; XMX throughput is irrelevant.
* T = 8 / 16: dense matrices (attention, head) share weights across the pass and run through DPAS at RC = 8 (two DPAS per B load for T = 16); the MoE expert kernels are limited by the number of distinct experts per pass.
* Free token axis: RC <= 4 costs the same XMX time as RC = 1; attention / controller streams that are processed with R = 1 today could be batched up to 4 rows at no XMX cost if the model had independent rows (the 3 GQA query heads per KV head are such rows; the 3 controller streams of the loop controller share the structure).

## 5. Native int4 x int8 DPAS integrated in the real model (attention, `XIK_W4N=1`, experimental, off by default)

`k_aq` quantises each projection input to int8 per token and 64-K group (scale amax / 127, plus the sum of the quantised values for the zero point); `w4n_r<R>` streams the asymmetric int4 weights as unsigned nibbles in the DPAS B layout (offline packed with `k_w4zpack`, `XIK_W4N` at load) and runs `dpas<u4, s8>` (`u4 x s8` layout verified against an integer reference: 0 / 64 mismatches); out = scale_w x scale_a x (acc - zero x sum_a). The same path is used for every T, so plain and verify passes stay numerically consistent.

| | K3x (fp16 expansion) | K3x + `XIK_W4N=1` |
|---|---|---|
| KL vs BF16-dense reference, 6 tasks mean (nats/token) | 0.0272 | 0.0268 |
| mean top-1 agreement | 0.958 | 0.957 |
| pass time T = 1 / 2 / 4 / 8 / 16 / 32 (ms) | 10.1 / 15.0 / 18.6 / 24.6 / 40.3 / 68.7 | 10.4 / 15.2 / 18.9 / 24.8 / 40.2 / 68.7 (T = 32 uses the FP8 path in both) |
| plain decode, 96 tokens | 96.7 tok/s | 93.8 tok/s |

Activation int8 quantisation does not change the quality (KL 0.0268 vs 0.0272) and the native instruction removes the weight-expansion ALU, but there is no end-to-end gain: T = 1 loses the extra quantisation launches (+0.3 ms), T = 8 / 16 are unchanged, as the streaming-GEMM experiment predicted (the attention GEMV is at 80 % of the DRAM roofline already). Larger T would profit (section 3, T = 64: native 127 us vs expansion 409 us), but those passes use the FP8 weights today.

## 6. Production MoE versus the streaming harness (distinct experts per pass)

`XIK_ROUTE_STATS=1` (host sync per call, diagnostic) on the `--bench-prefill` token ids (not natural text): T = 8: 26.0 distinct experts per MoE call, 2.47 tokens per used expert; T = 16: 34.7 distinct experts, 3.69 tokens per used expert (histogram of tokens per expert in the log of the run: 1: 4906, 2: 1968, 3: 1134, 4: 773, ... 8: 363 of 400 calls at T = 8). The production W3 MoE moves 26 x 3.24 MB = 84 MB per visit at T = 8 and 112 MB at T = 16 and takes about 260 us / 430 us per visit (w13 + w2): 326 GB/s (71 % of the DRAM peak) and 260 GB/s (57 %), against 360 GB/s (79 %) at T = 1. (An earlier statement of "37 %" in this file was derived from VTune's average read bandwidth, which under-counts; the bytes / time figure above is the one to use.)
The T > 1 W3 kernel split into one launch per tokens-per-expert class (`XIK_W3SPLIT=1`, with the activation prefetch enabled for R = 4) is slower (T = 8: 24.5 -> 30.0 ms, T = 16: 40.1 -> 51.2 ms), so neither the register spill nor the per-group activation loads of the R = 4 / 8 bodies are the limiting factor; the remaining distance to the roofline at T = 16 is ALU (ALU1 active 36 % on K3x, XVE stalled 34 %, SBID 30 %) and the number of distinct experts.

## 7. Concurrent kernel execution (`tools/xmx/concurrency.cpp`)

Two in-order queues of the B60 run kernels concurrently only when several compute command streamers are exposed (`ZEX_NUMBER_OF_CCS=4`): streaming kernel A 4.1 ms, latency-bound kernel B 1.0 ms, A then B in one queue 5.0 ms, A and B in two queues 3.5 ms (without the variable: 5.05 ms, serialised). The engine's L2-prefetch of the next visit's attention weights on a side queue (`XIK_AWPF=2`) is still slower with concurrency enabled (K3x plain 87.3 vs 98.9 tok/s), so it stays off.

## 8. Status of the requested work items (end of this session)

Done and measured: micro-benchmarks (DPAS peak per type / repeat count / accumulators, register / SLM / L2 / DRAM operand sources, mixed int4 x int8), roofline bound, T = 1..64 reuse-versus-effective-TOPS sweep (`w4gemm`), native u4 x s8 DPAS in the real model (`XIK_W4N`), routing statistics and MoE bandwidth decomposition (`XIK_ROUTE_STATS`), K3x hardware counters.
Not done: ISA-level hand-written software pipeline (the DPAS micro-benchmarks use the ESIMD intrinsics, not hand-written ISA), GQA query-head batching of attention, controller stream batching (the three streams use different weights per stream), expert-centric MoE rescheduling.
