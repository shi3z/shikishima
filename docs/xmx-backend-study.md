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
