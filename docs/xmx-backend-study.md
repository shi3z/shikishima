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

## 9. Batched native u4 x s8 kernel and the DSpark controller (end of the two-card session)

**Native kernel redesign** (`w4n_r<RC, NP>`): one launch handles up to 64 tokens; for each 32-K chunk the B tile (weights, 256 B) is loaded once and used by NP passes of RC = 8 tokens (K outermost, tokens innermost, NP independent accumulator sets, scale and zero-point correction per 64-K group). The activation quantiser permutes the int8 bytes inside every 8 values so that the existing pair-order int4 layout of the fp16-expansion kernel can be consumed unchanged (one weight copy serves both kernels). `XIK_W4N=1` (default): native kernel for T = 17..64 (prefill-sized passes); decode / verify (T <= 16) keep the fp16-expansion kernel and are unchanged. Pass times, K3x on one B60 (FP8 path before -> native after): T = 16 39.2 -> 37.9 ms, T = 32 68.8 -> 59.5 ms (-13.5 %), T = 64 122.0 -> 117.2 ms (-4 %); T = 1 / 8 unchanged. Output of a 62-token prefill + 24 tokens is bit-identical to the FP8 prefill path; GSM8K 0.900 / 0.900, MMLU 0.825 / 0.833, code 0.9375 / 1.000 (FP8 prefill / native prefill, 60 / 120 / 16 problems).
Not done: ISA-level scheduling of this kernel, the Grouped-GEMM MoE (the engine's pass width is 64 tokens, so MoE experts see 4 tokens each at T = 64), T = 128 (limited by `max_tokens` = 64).

**DSpark controller** (`src/spec.rs`, `XIK_CTL_OLD=1` restores the old model): the acceptance estimate is a decayed Beta posterior with an optimistic prior plus a vanishing exploration bonus (instead of an EMA from a pessimistic prior and a fixed 0.85 discount), the verification cost is a measured table over the widths 1..64 (ratio to a plain step, updated from every verification), the first plain steps move `t_plain` quickly (the first step includes warm-up: 19 ms instead of 10 ms), predicted DSpark / copy speeds are multiplied by a calibration factor (EMA of realised / predicted speed of that kind of round), copy proposals are explored every 5 rounds when long, and the cooldown after two lost DSpark rounds backs off 6 / 12 / 24 rounds instead of a fixed 24.
Hybrid decode-only tok/s (K3x, one card each, 5 repeats, mean of two runs for the new controller): code 115.1 -> 137.0 (+19 %), history 100.3 -> 100.5, prose 91.7 -> 91.4, repeat 115.8 -> 115.9, edit_py 298.7 -> 306.9, jsonl 189.6 -> 191.5; geometric mean 138.1 -> 143.1 (+3.6 %). Plain decode is unaffected.

## 10. Grouped-GEMM MoE, wider passes, counters (K3x, one B60; this is the state at the end of the session)

* `XI_MAX_TOKENS` (default 64, up to 1024) sets the widest forward pass; `--bench-prefill` measures T = 128 / 256.
* **Grouped-GEMM W3 MoE** (`moe_w3g_grp<2>`, `XIK_W3GRP=2`, used when a pass is >= 40 tokens wide, `XIK_W3GMIN`): for experts with more than 8 tokens the INT3 expansion of every weight tile is done once and applied to 16 tokens (two independent DPAS accumulator sets of 8 tokens). Bit-identical to the 8-token-chunk kernel (md5 of a generation after a 100+ token prefill equal). NP = 3 / 4 are slower (register pressure), and below T = 40 the extra launch costs more than it saves (T = 16: +14 %).
* Router GEMV `gemv_bf16_rs` now for every pass width (the old kernel was used above T = 64: 15 % of a T = 256 pass).
* Prefill pass times (ms, per pass; tok/s): T = 64 117.7 -> 108.7 (544 -> 589), T = 128 255.4 -> 195.0 (501 -> 656), T = 256 513.5 -> 378.7 (499 -> 676).
* Hardware counters (VTune, T = 256, K3x): `moe_w3g_grp<2>`: **XMX Active 12.8 %**, ALU0 12 % / ALU1 32 %, XVE Active 46 % / Stalled 35 %, SBID 35 %, 128 GRF, spill 0, ALU : DPAS = 7 : 1, SEND : DPAS = 0.6, DRAM read 203 GB/s (21 % of the pass). LM head `w4_gemv_r<12,8>`: XMX Active 12.3 %, DRAM 401 GB/s. Native attention `w4n_r<8,8>` (qkv): XMX 3.5 %, SBID 54 %, ALU : DPAS = 13 : 1 (latency-bound: only 3-4 groups of 64 K per thread). Before the grouped kernel the 8-token-chunk kernel had XMX Active 3.7-5.6 % and ALU : DPAS = 10-18 : 1.
* T = 1 side: `qr_clip` fused into the kv launch (+0.8 tok/s), router launch also converts the MLP input and builds the expert groups (+0.4 tok/s), and **kernel-argument size**: the native path's int8 activation pointers (24 B x 8 segments) were part of the arguments of the decode attention kernels; moving them into a separate struct took the plain decode from 98.4 to 99.3-100.3 tok/s on the same prompt (the same change in the opposite direction, adding 40 B of conv pointers to the argument struct, cost 1 % and was reverted together with the wo + conv epilogue it served, which also did not pay off: 97.4 vs 98.4 tok/s).

Targets not reached in this session: XMX Active >= 30 % (best 12.8 % in a real-model kernel; the roofline bound for weight-streaming kernels is derived in section 2), 200 tok/s code generation / 150 tok/s prose (plain 99-100, Hybrid 137 on code and 91 on prose), ISA-level hand scheduling (the kernels above are ESIMD intrinsics; ISA was inspected through the counters and the JIT dump, not hand-written).

## 11. Why the grouped MoE kernel reaches 198 GB/s: ablation (T = 256 pass, K3x, one B60)

`XIK_W3GABL` (timing only, wrong numbers): 1 = no INT3 expansion (the loaded dwords feed the DPAS directly), 2 = no DPAS.

| variant | pass time | grouped kernel per call | bytes / time (all 128 experts, 208 MB per call on average) |
|---|---|---|---|
| full | 378.5 ms (354.0 ms after the register restructuring below) | 1048 us | 198 GB/s |
| no expansion | 295.3 ms | 506 us | **411 GB/s = 90 % of the 456 GB/s peak** (the ceiling of exactly this access pattern) |
| no DPAS | 371.0 ms | - | - |

The DRAM access pattern (tile-major, contiguous per expert, 5k-18k threads) can run at 411 GB/s; the kernel reaches half of it because **the INT3 expansion ALU work is the limit** (about 192 ALU instructions per 16 x 128 weight tile, ALU1 32 % busy, ALU : DPAS = 7 : 1), not DRAM and not the DPAS (removing the DPAS saves 2 %). VTune's "DRAM read" column of the no-expansion run (163 GB/s) disagrees with bytes / time and should not be used for this kernel.
Changes made from this: the activations of one 32-K group are loaded one pass (8 tokens) at a time instead of all NP passes at once (live registers -8 x (NP - 1) GRF): T = 256 pass 378.7 -> 354.0 ms (723 tok/s), T = 64 108.7 -> 105.1 ms. NP = 3 / 4 stay slower in the exact kernel (spills); with the group scale folded into the fp16 operand (`XIK_W3GSF=1`, approximate, 5e-4 relative rounding of code x scale; no `ag` accumulator set) NP = 3 / 4 no longer spill but are only marginally faster (T = 256: 349 / 352 ms vs 356 ms for NP = 2), because the average expert holds about 16 tokens at T = 256 (NP = 2 already covers it). The remaining lever is the expansion cost per weight (about 0.1 ALU instruction per weight with the fp16 magic-number scheme), i.e. a cheaper 3-bit container or expansion shared across threads through SLM, not the DPAS / memory pipeline.

## 12. Kernel arguments (plain decode)

Sizes (`XIK_ARGSZ=1`): W4Args 456 B, DArgs 464 B, GArgs 464 B, CtlFArgs 392 B, MixArgs 120 B, NormArgs / ConvArgs / PairArgs 80 B, BlendArgs 152 B. Launch cost depends on the argument size: W4Args at 648 B (native-path activations in the segments) was 15 % slower than 456 B when the wo conv fields were added on top, DSeg shrunk from 592 to 464 B gave K1 +0.8 %. A compile-time segment count (one segment for wo: 64 B arguments) was slower (99.5 vs 100.3 tok/s), so it was reverted: the cost is not simply linear in the bytes.
6 tasks x 5 repeats (plain decode-only median, current build): K3x 100.25 / 100.38 / 100.21 / 100.08 / 99.51 / 99.44 (code / history / prose / repeat / edit_py / jsonl, geo-mean 100.0), K1 88.03 / 87.73 / 88.00 / 88.31 / 87.99 / 87.52 (geo-mean 87.9).

## 13. Planar INT3 experts on native u2 x s8 DPAS (`XIK_W3P`, default on): no weight expansion

Design (physical layout only; the quantised codes and the fp16 group scales are exactly those of the pre-permuted W3 format): per 32-K chunk and row three dwords: two dwords with bits 0-1 of the 32 codes (the u2 B operand, field j of dword kd = K 16 kd + j), and one dword with bit 2 of K 0..15 at the even and of K 16..31 at the odd bit positions; plane 3 operand = { Z & 0x55555555, (Z >> 1) & 0x55555555 } (3 ALU instructions per chunk instead of about 48 of the shift / bfn / subtract expansion); code = plane12 + 4 plane3, out = scale_w x scale_a x (sum a x code - 4 sum a), two u2 x s8 DPAS (K = 32) per chunk. Operand layout of u2 x s8 verified against an integer reference (0 of 64 mismatches, `tools/xmx/u2check.cpp`). Activations are int8 per token and 32-K chunk (records of 8 dwords + scale + sum, one 128 B load per group and row), produced by the router launch (T = 1) / by `k_aq` (T > 1) for the w13 input and by `k_act_q` (activation + quantisation in one launch) for the w2 input: the launch count at T = 1 is unchanged.

* Streaming harness (`tools/xmx/w4gemm.cpp`, 17 MB of 3.25 bit/weight data, T tokens share the weights): T = 1..16 at 39-46 us = 400-440 GB/s (DRAM roofline), while int4 expansion needs 52-68 us for 30 % more bytes; T = 16: 31.5 TOPS.
* Real model, pass time (ms, K3x, one B60; pre-permuted -> planar): T = 1 9.7 -> 9.7, T = 4 18.1 -> 18.1, T = 8 23.9 -> 23.3, T = 16 38.9 -> 37.3, T = 32 59.9 -> 53.5 (-10.7 %), T = 64 106.3 -> 99.4 (-6.5 %), T = 128 186.3 -> 180.5, T = 256 355.9 -> 354.4. Tile shape by pass width (`XIK_P3CLS`): 1 x 1 at T = 1, 2 x 4 up to 8 tokens, 4 x 4 above.
* Counters (T = 16, one MoE kernel call): ALU instructions 38.1 M -> 31.6 M, SEND 3.17 M -> 1.87 M, XMX instructions 1.75 M -> 2.02 M, XMX Active 4.0 -> 5.5 %, time 214 -> 197 us; T = 1: ALU 2.40 M -> 1.70 M, time 36.1 -> 35.1 us (latency-bound, SBID 27 %).
* Quality (6 tasks, KL vs BF16-dense reference): 0.0271 (pre-permuted) vs 0.0275 (planar, 64-K activation scale), GSM8K 0.900 -> 0.883, MMLU 0.825 -> 0.833, code 0.9375 -> 1.000 with the 32-K activation scale. With the 64-K activation scale GSM8K fell to 0.817 although KL was unchanged, hence the finer scale.
* Plain decode 6 tasks x 5 repeats: K3x 100.07 / 99.96 / 100.11 / 99.99 / 99.41 / 99.39 (geo-mean 99.8), K1 87.94 / 87.95 / 87.99 / 87.69 / 87.09 / 87.42. Hybrid (new controller, K3x): code 144.9, history 101.9, prose 95.9, repeat 118.2, edit_py 347.8, jsonl 198.0 (geo-mean 150.3; 143.1 before this change).

## 14. Hand-written ISA toolchain and the software-pipelined native attention GEMM (`XIK_W4NP`, default on)

**ISA toolchain (works, `tools/isa/`).** `ocloc asm` is silent and writes nothing on this driver (26.40), so the assembler is called directly: `isa_patch` links `libiga64` (platform `IGA_XE2`), assembles the text of a kernel (explicit SWSB `{$n}` / `{I@n}` / `{A@n}` annotations as printed by the disassembler) and splices the binary into the `.text.<kernel>` section of a zebin (`isa_patch -d` disassembles); `l0run` loads the patched zebin with Level Zero (`ZE_MODULE_FORMAT_NATIVE`) and launches it. Verified end to end on a kernel whose `add 1` was edited to `add 5` (output 5 6 7 8...). Offline ISA of an engine kernel: `scripts/isa.sh <name>`; add `-options '-vc-codegen -doubleGRF'` to the final `ocloc compile` to get the 256-GRF code the runtime JIT produces for `grf_size<256>` (the default offline script produces the 128-GRF code with spills, which is not what runs).

**What the ISA showed in `w4n_r` (native u4 x s8 attention GEMM, T > 16).** Per 64-K group and pass each thread issued 16 block loads of 32 B + 16 scalar loads (activation records, scale, sum) and then waited for them: SBID 54 %. With T = 64 that is ~256 SENDs per group. The loop could not be unrolled across groups (runtime `per`), so there was no register ring to prefetch into.

**Rewrite (`w4np_r`, micro-benchmark `tools/xmx/w4n_bench.cpp`, 3072 x 2304, cold weights, ms-level correct vs baseline, max |diff| / max = 2e-7):**
* activations pre-tiled per (64-K group, 8-token tile) = `[a0: 8x8 dwords][a1: 8x8 dwords][scale, sum: 8x2]`: three contiguous block loads per pass (`k_aqt`),
* `PER` (groups per thread) is a template constant, group x pass loop fully unrolled; static register rings: weights WD groups ahead, activations AD passes ahead; the wait is placed by the compiler directly in front of the first use,
* zero-point folded once per group: `acc += fa * (ws * as) - (zp * ws) * (as * sum)`,
* `grf_size<256>`,
* segment selection by constant indices (a dynamic `a.s[si]` index moved the 456 B argument struct to scratch: 324 flat loads in the ISA),
* the reduction over the KSD threads and the output stores are spread over the work-group (pass p belongs to thread p % KSD) instead of one thread doing all passes.

Micro-benchmark, us per call (baseline KSD = 12, 128 GRF): T = 16 17.2 -> 11.7-12.0, T = 32 23.0 -> 12.2, T = 64 66.9 -> 16.6 (K = 3072: 74.3 -> 18.4). Depth sweep (T = 64, KSD = 6): WD/AD = 1/2 16.6, 2/2 17.2, 2/3 16.9, 3/4 18.3, 4/6 19.9 us, deeper rings only add registers. GRF: at T = 64 the 128-GRF build spills for most configurations (21.9 us best, 144-404 us for KSD <= 4 or deep rings), 256-GRF 16.6 us; at T <= 32 128 GRF is as good (12.4 vs 12.2) because fewer registers are live and 4 more threads/EU fit. KSD = 6 gives 36/6 = 6 (K = 2304) or 8 (K = 3072) groups per thread; fewer threads than 12 per row block are better because per-thread streams become longer.

Real model (K3x, planar INT3, one B60; ms per pass, tok/s): T = 17 41.3 -> 38.4, T = 32 53.5 -> 49.4, T = 48 72.8 -> 62.0, T = 64 99.7 -> 75.2 (-25 %), T = 128 180.8 -> 130.6 (-28 %, 708 -> 980 tok/s), T = 256 354.5 -> 253.2 (-29 %, 722 -> 1011 tok/s). Quality: teacher-forced KL against the previous kernel 0.0003 nats/token, top-1 agreement 1.000 (bf16 rounding boundaries flip with the changed operation order); GSM8K 0.883, MMLU 0.842, code 15/16 (planar: 0.883 / 0.833 / 16/16).
Hybrid (6 tasks, geo-mean, 3 repeats): 150.5 -> 170.3 tok/s, but the per-task numbers move with the generated text, which changes with the last-bit differences (repeat 118 -> 304, jsonl 200 -> 154, code 144.8 -> 139, edit_py 346 -> 373): this is a different trajectory, not a kernel effect, and the geo-mean should not be read as a controlled speed-up.

**T=1 planar MoE with unrolled tile loop and deeper prefetch (`XIK_P3PD`, default off, negative result).** `moe_p3_t1<NT, PD, GRF>`: tile loop fully unrolled, weight tiles and activation records PD tiles ahead in static register rings. Plain decode (K3x, history / code, tok/s): current kernel 100.03 / 100.06; PD = 1 98.75 / 99.14, PD = 2 99.34 / 99.18, PD = 3 99.38 / 99.33, PD = 4 99.09 / 98.42, PD = 6 96.89 / 97.16; with 256 GRF PD = 2 90.23 / 90.15, PD = 4 89.57 / 89.29 (half the threads per EU). The T=1 expert stream (~370 GB/s, 81 % of DRAM peak) is not limited by prefetch depth; next candidates are K-split across threads and the attention int4 GEMV `w4z_r` (~2.1 ms/step, ~80 % of peak).

## 15. Split-K for the T=1 expert kernel, hand-written ISA on a real engine kernel, launch census

**Was ISA written by hand? Only in this section, and only as a patch of compiler output.** Everything in sections 13-14 (unrolled loops, register rings, `grf_size<256>`, record layouts) is ESIMD source restructuring, not hand-written ISA. Hand-written ISA exists in two forms: (1) `add 1 -> add 5` on a toy kernel (section 14), (2) an ISA-level rewrite of the engine kernel `w4np_r<2304, 8, 6, 1, 2>` (256 GRF): disassemble -> `swsb_strip.py` -> `epi_rewrite.py` (text transformation of 148 token blocks) -> `isa_patch -a` (IGA assembles and regenerates SWSB) -> zebin `.text` splice -> `l0w4np` (Level Zero harness, event timestamps, same arguments as the engine launch). The patched ISA is **not** loaded by the engine (no L0 / SYCL interop path was built); it exists as an experiment on the standalone harness.
* Rewrite: per (token, 64-K group) the compiler emitted `A: Y = as*ws, B: X = zw*(as*sm), C: S = as*sm (1 lane), D: X = f*Y - X, E: acc += X` (4 vector + 1 scalar instruction); rewritten to `X = zw*sm, X = f*ws - X, acc = acc + X*as` (3 vector instructions). 148 of 384 blocks rewritten (the others need register renaming because the scale registers are reloaded in between; the dependency analysis includes `send` destinations of `rd:N` registers - a first version without it produced a wrong token).
* Result (T = 64, 3072 x 2304, cold weights, L0 event time): 25.8 us -> 25.4 us (-1.5 %) for -296 instructions of 6319 (-4.7 %); output differs from the original by 1.6e-7 (max / max), no NaN. IGA auto-dependency regeneration alone (no edit) reproduces the original bit for bit at 26.3 vs 25.8 us. The kernel has ~6300 instructions per thread of which 96 are DPAS (ALU : DPAS = 65 : 1): the ALU issue rate is the limit, so an instruction-count reduction pays about one third of its share; larger gains need fewer lane operations per (token, group), not a better schedule.

**Split-K for the T=1 planar expert kernel (`XIK_P3KS`, default off, negative).** `moe_p3_t1s<KS>`: one work-group of KS threads per (expert slot, 16-row block), tiles [k NT / KS, (k+1) NT / KS) per thread, partial sums reduced in SLM, no extra launch. Plain decode (K3x, history / code, tok/s, GPU 0): KS = 1 99.74 / 99.52, 2 95.52 / 95.52, 3 91.86 / 91.65, 4 89.50 / 89.29, 6 82.28 / 82.29, 8 79.79 / 79.68, 16 63.65 / 63.62 (standard kernel: 100.0). More threads per row block only add barriers and shorten the per-thread stream; the 1152-thread grid already issues enough requests (the expert stream is ~370 GB/s).

**Launch census of one decode step (VTune, K3x, T = 1, 63 steps):** 746 launches/step. moe_p3 88 (35.1 us each, 3.09 ms), w4z_r 96 in three variants (30.6 us x 40, 13.4 x 48, 31 x 8; 2.1 ms), k_ctl_fused 48 (21.0 / 18.4 us, 0.95 ms), router_fused 48 (8.4 us), k_attn_p 48 (7.4), k_kv 48 (5.0), k_wnorm 45 (4.4), k_act_q 44 (4.0), k_conv 48 (3.1), k_combine_conv 48 (3.0), k_mix_t ~112 (2.3-5.3). Launches below ~8 us each add up to ~2.3 ms/step including their inter-kernel gaps; a persistent kernel would have to replace the grid-wide barriers that `k_ctl_fused` already uses (54 work-groups) and is the open item.

## 16. Persistent-kernel feasibility: grid-barrier and launch costs (one B60, GPU 0)

**Safety.** The first grid-barrier micro-benchmark used an unbounded spin and froze the host twice (physical reboot needed). `tools/xmx/gridbar.cpp` is now terminating by construction: each work-group leader has a total poll budget of 500 000 for the whole kernel (< 1 s, below the 5 s xe job timeout); after it is spent the leader records an error and stops waiting in all later barriers; the host refuses grids above half of the resident thread capacity (640 threads). All runs below finished with zero exhausted budgets. Any persistent kernel in the engine must follow the same rules (bounded total wait, co-residency by construction).

Grid barrier (one counter, leader polls with an atomic; per barrier, 200 barriers per launch): 2-40 work-groups x 1 thread 0.69-0.81 us, 80 x 1 1.03 us, 40 x 8 1.05 us, 80 x 4 1.50 us, 160 x 1 and 80 x 8 1.64 us, 320 x 1 4.43 us (counter contention).
Empty kernel (`tools/xmx/emptyk.cpp`): GPU duration 0.5-1.5 us, back-to-back dependent launches 2.4-2.6 us each on the in-order queue.
Engine (K3x, T = 1, `--step-timeline` under profiling): 710 kernels per step, sum of kernel durations 9.59 ms against a 10.0 ms step without profiling, i.e. about 0.4 ms of inter-kernel idle per step (the profiling run itself shows 18.7 ms wall, its idle figure is not usable).

Consequence: replacing a launch boundary by a grid barrier saves at most ~1.5 us when the phase runs on <= 80 work-groups, nothing at 160 work-groups and loses at 320. The kernels that carry the time (planar MoE 1152 threads, attention projections 6456 threads) need more threads than a co-resident persistent grid may safely use, and the small kernels sit between them in runs of 2-3 (`k_kv -> k_attn_p`, `k_combine_conv -> mix + norm`, `k_act_q` between the two expert GEMMs). Upper bound for a whole-step persistent kernel: the ~0.4 ms idle plus part of the ~1 us start-up inside ~460 small-kernel durations, about 0.5-0.8 ms of 10.0 ms (5-8 %, i.e. ~105-108 tok/s) before barrier costs and before any loss from running the large kernels at reduced occupancy. Not enough alone for 120 tok/s (8.33 ms/step).

## 17. Small-kernel fusion without grid barriers, routing correlation, real-routing prefill (one B60; GPU 0: T = 1, GPU 1: T > 1)

**`k_kv` + q / r clipping fused into the key-split attention (`k_attn_kv<4>`, `XIK_FUSE_KVA`, default off).** No inter-work-group waiting: each of the 24 head work-groups computes the new k / v of its kv head itself (the 3 heads of a kv group compute it redundantly, head hh % 3 == 0 writes the cache), clips its own q / r, uses the new k / v from SLM for the current position; extra work-groups of the same launch write the conv state. Removes one launch per visit (48 per step).
Plain decode (K3x, history / code, tok/s, GPU 0): first version 95.7 / 95.3 (4 group-wide reductions over 512 threads, and a per-key select that broke the 8-wide V prefetch), second (one barrier for the 4 sums) 95.9 / 95.8, third (new key handled outside the cache loops) 100.82 / 100.58 and 100.48 / 100.36 against 100.19 / 100.20 and 100.56 / 100.37 unfused: within noise. Greedy output identical on `code`, diverges on `history` at the ~10th token (sums over 512 instead of 128 threads change the last bit). Removing the launch does not shorten the dependent chain (conv -> norm -> attention), as already seen with the controller fusion; kept off.

**Routing correlation (6 tasks x 256 tokens, 1365 decode steps x 48 visits, recorded with `XIK_ROUTE_REC`, `tools/route_corr.py`).** Consecutive tokens share 41 % of their 8 experts at the same visit (random 6 %); the re-visits of the looped layers 6-17 share 59 % (pass 0 -> 1), 56 % (1 -> 2), 46 % (0 -> 2) within one token. The hottest 4 / 8 / 16 experts of a layer take 13.7 / 22.8 / 36.7 % of its uses (uniform 3.1 / 6.2 / 12.5 %). Reuse distances: a re-visit is 12 visits later (~300 MB of other weights streamed), the next token one full step (~1.2 GB); L2 holds ~5 experts (3.24 MB each, planar INT3 w13 + w2). Pinning the most used (layer, expert) pairs in 13 MB of L2 covers 1.65 % of the expert bytes per step. The correlation is real but the reuse distance is two orders of magnitude above the cache; it is usable only where tokens are processed together (verification passes), not for T = 1.

**Real-text prefill (409 tokens of GSM8K text in 256 + 153 chunks, real routing, GPU 1).** Pipelined native attention off / on: 592 / 446 ms (-25 %, 917 tok/s). Planar expert tile class at T > 1 (`XIK_P3CLS`): default (4 x 4 for wide passes) 446 ms = 4 x 4 forced 446 = 8 x 2 446, 4 x 2 494, 2 x 4 509, 4 x 1 603 ms: the default is the best of the measured classes on real routing.

## 18. Toward 120 tok/s without any quality change (K3x reference; one B60 per run; all waits bounded)

Every change below keeps the arithmetic of the reference: greedy output was compared token for token with the previous kernel (`cmp` of the generated text, 2-3 prompts x 200 tokens) and was identical in every row marked "identical". Plain decode in tok/s on the `history` / `code` prompts (decode-only median of 3 runs x 256 tokens; two rounds; GPU 0 or GPU 1, never both for one inference).

| change | kernel effect | E2E (history / code) | step time saved | output |
|---|---|---|---|---|
| reference (before this round) | | 100.2-100.6 / 100.2-100.4 | | |
| `k_ctl_fused`: gain / forget fp8 tiles, row scales and dest / msg rows loaded early (`XIK_CTL_PRE`, default on), issued right after grid barrier 1 (before it, the barrier's fence waited for them) | per call 17.6 -> 12.0 us (1 stream), 19.9 -> 17.0 us (3 streams); gain/forget units 3.85 / 3.45 -> 0.57 / 0.59 us | 102.2-102.6 / 102.2-102.5 (PRE=0 in the same build: 100.6-100.8) | ~0.17-0.2 ms | identical |
| same with 256 GRF and loads at kernel start | units 0.6 us, but 256 GRF made the whole kernel slower | 100.8-101.0 (PRE=0 with 256 GRF: 98.5-98.8) | | identical; not kept |
| `k_ctl_fused` phase 0: the 8 threads of a work-group share the norm of their segment (thread i computes partial i of the 8-partial tree, SLM exchange) | 1 stream 12.0 -> 11.3 us, 3 streams 17.0 -> 16.4 us | 102.6-102.85 vs 102.5-102.6 (noise) | ~0.02 ms | identical |
| phase 0: all 18 down-projection tiles issued before the norm (`XIK_CTL_P0ALL`, default off) | 11.3 / 17.0 us | 102.5-102.8 | 0 | identical; not kept |
| attention int4 GEMV (`w4z_r`) and fp8 `dgemm_t`: segment chosen by constant indices instead of a dependent search loop through the argument struct in scratch | removes the per-work-group chain of dependent scratch loads and the struct copy at start | 102.7-102.8 vs 102.0-102.2 | ~0.07 ms | identical |
| wo projection threads per row block (`XIK_W4WO_KSD` 6 / 8 / 12 / 16 / 24 / 48) | | 100.1 / 100.4 / 101.7 / 100.5 / 99.4 / 96.8 | 12 (current) is best | |
| router: L2 prefetch of the first 1 / 2 / 4 w13 tiles of the 8 chosen experts from the router's last work-group (`XIK_RPF`, default off) | the last work-group issues 108-430 prefetches per thread and ends later | 98.8 / 96.6 / 92.1 (vs 102.2) | negative | identical |
| GQA attention: one work-group per kv head, every K row / V element loaded once for its 3 query heads (`XIK_ATTN_GQA`, default off) | 24 -> 8 work-groups | 101.5 vs 102.9 | negative (less parallelism at T = 1) | identical |
| hand-edited Xe2 ISA of `w4z_r<1, 12>` loaded by the engine (`XIK_ISA_W4Z1=<zebin>`) | see below | see below | 0 | identical |

Accumulated: about 0.24 ms per step (100.4 -> ~102.9 tok/s, 9.96 -> 9.72 ms). Budget left for 120 tok/s (8.33 ms): about 1.39 ms.

**Hand-written / hand-edited ISA inside the engine.** `XIK_ISA_W4Z1=<zebin>` loads a zebin into the queue's Level Zero context (`zeModuleCreate` native, `zeKernelSetIndirectAccess`, `make_kernel_bundle` / `make_kernel`) and launches it instead of the JIT `w4z_r<1, 12>` (every T = 1 attention projection: 96 launches per step) with the same arguments (W4Args by value, bool tm, int t0, int nt). Variants, all with identical greedy output:
* offline compile of the same source, unmodified: 103.1 / 102.3, 102.9 / 102.6 (JIT 103.2 / 103.0, 102.7 / 102.8): the path itself costs nothing;
* SWSB regenerated by IGA (`isa_patch -a`) without edits: 101.9 / 101.8, 102.1 / 101.9: IGA's automatic dependency placement is ~1 % slower than the compiler's;
* edit (SBID-preserving, `w4z2/edit2.asm`): the fourth activation load of each 64-K group was issued after the first DPAS because its destination register r26 was still being written by the fp16 expansion; it was renamed to the free register r110 and moved up behind the third load (its SBID $0 is not used in between, the consumer `mov` reads r110): 102.9 / 102.9, 103.0 / 103.1 vs JIT 103.2 / 103.0, 102.7 / 102.9 - no measurable change. The same edit with IGA-generated SWSB: +0.4 % over the IGA round trip.
The kernel is not limited by that load's position: its remaining time is the DRAM stream (80 % of the peak for the 6-matrix launch) and the fixed start-up of each work-group.

**Counters.** VTune per-kernel counters for T = 1 decode (`tools/hwkern.py`, `hwt1.sh`) give the same XMX active (0.7-0.8 %), SBID stall (~33 %) and occupancy (~40 %) for every kernel: kernels of a few microseconds are shorter than the sampling interval and receive the interval average. Per-call times from the instrumentation are valid (moe_p3 35.1 us, attention projections 30.7 us, wo 13.4 us, ctl 18.2 / 13.3 us under VTune, router 8.4 us, attention 7.2 us, k_kv 5.2 us); per-kernel counters at T = 1 need a different method (repeating one kernel in a loop).

**T = 1 attention GEMV with all loads issued up front (`w4z_r1p<PER>`, `XIK_W4Z1P`, default on).** Each thread requests its whole stream (PER = 3 or 4 groups of 512 B weights, scales and activations) before the first expansion; arithmetic and order as `w4z_r<1, 12>`. A first version wrote the per-group update as `acc += ag * sf`; for PER = 3 the compiler emitted an accumulator-register `mul` / `mac` chain that produced wrong results (generated text degenerated; `XIK_W4Z1P=2` runs both kernels and compares: 8596 of 8600 outputs differed) while PER = 4 was exact. With an explicit fused multiply-add (`experimental::esimd::fma`, the operation the compiled `w4z_r` uses), 0 of 8600 / 0 of 2304 outputs differ and greedy text is identical. E2E: 103.65 / 103.65, 103.42 / 103.29 vs 102.98 / 102.88, 103.03 / 102.99 (+0.5 %, ~0.05 ms). Accumulated this round: ~0.29 ms (100.4 -> ~103.5 tok/s); left for 120 tok/s: ~1.33 ms.

`k_act_q` was not fused into the w13 epilogue: the activation uses `sycl::tanh` / `sycl::exp`, which are not available inside ESIMD kernels; the ESIMD versions differ in the last bits, so the result would not be identical.

**Planar MoE at T = 1 in isolation (`--bench-moe`, `XIK_BENCH_KINDS=2,3`, cold weights, GPU timestamps).** w13: 43.5 us for 17.3 MB = 397 GB/s (87 % of 456 GB/s, floor 37.9 us); w2: 23.8 us for 8.6 MB = 362 GB/s (79 %, floor 18.9 us). Both sit ~5 us above the DRAM floor; with 44 planar visits per step that is ~0.46 ms per step. Deeper prefetch (section 15), Split-K (15) and early L2 prefetch from the router (18) did not reduce it; the remaining part is the ramp-up and drain of a 1152-thread grid in which every thread streams the same amount and all finish together.
Two 16-row blocks per thread (`moe_p3_t1rb2`, `XIK_P3RB2`, default off; 576 threads, two streams each, identical output): w13 43.9 us, w2 24.2-24.4 us against 43.5-45.9 / 23.8-25.2 us for the standard kernel in the same session (run-to-run spread ~5 %): no gain, the stream length per thread is not the limit either.

## 19. Persistent per-slot MoE chain at T = 1 (`moe_chain`, `XIK_MOECHAIN`, default off; timing prototype, negative)

One launch replaces w13 -> `k_act_q` -> w2 for the planar layers. 576 threads (half the resident capacity), thread = (expert slot, pair of 16-row blocks); per slot: w13 rows -> store, fence, atomic count; the slot's activation records after its 72 w13 threads; w2 rows after its 36 records. Only per-slot waiting, never global. Safety: every wait has a hard per-thread poll budget with an error counter (then the thread continues: wrong numbers, guaranteed termination); co-residency by construction; data written by other cores read with L1-uncached loads. The activation in the prototype uses ESIMD exp (not identical to `k_act_q`); it was only built to measure the upside before reproducing `sycl::tanh` / `sycl::exp` bit-exactly in ESIMD (IGC's implementations were read from the ISA: range-reduced polynomial + `math.exp` + IEEE division with `math.inv` refinement).

* v1: the polling `block_load` was hoisted out of the loop by the compiler (it spun on a register; every wait ran out of budget; the run still terminated): fixed with an atomic load.
* v1 with atomic-load polling: 77.4 tok/s (all 108 threads of a slot polling one address).
* v2: work-groups of 8 aligned to slots, one poller per work-group, the others wait at the work-group barrier: 101.90 / 101.77, 101.72 / 101.79 against 103.48 / 103.52, 103.50 / 103.04 without the chain (same GPU, interleaved): -1.6 %. Zero exhausted waits.
* v3: w2 tile 0 requested before the wait: 100.1 / 100.0 (the fence after the wait also waits for those loads).

The separate launches have only ~0.15 us of GPU idle between them (`--bench-moe` PROF); the per-slot synchronisation and the 36-thread activation step cost more than the launch boundaries and the ramp they remove, even with the cheaper activation. The exact-activation version was therefore not built.

## 20. Step-level DRAM use and cross-kernel L2 prefetch (T = 1, K3x, one B60)

**Timeline of one decode step** (`XIK_PROFILE=1 XIK_TL_DUMP=<file> xi-run ... --step-timeline`: every kernel's start / end with the launching function's name; the idle between kernels is inflated by profiling and is not used): 710 kernels, 9.36 ms of kernel time against a 9.66 ms step (103.5 tok/s). Weight-streaming kernels (planar experts 88 x 35.1 us = 3.09 ms, attention int4 GEMV 96 x 20.9 us = 2.01 ms, MXFP8 experts 0.75 ms, LM head 0.56 ms): 6.40 ms for 2.35 GB = 367 GB/s (80 % of the peak while they run). All other kernels: 2.96 ms with DRAM idle (controller 0.74, mix 0.44, router 0.41, attention 0.40, k_kv 0.26, norm 0.22, act_q 0.17, combine 0.15, conv 0.14 ms). Step average 2.35 GB / 9.66 ms = 243 GB/s (53 %). 120 tok/s needs 282 GB/s (62 %).

**Cross-kernel L2 prefetch (`XIK_PFX`, default off).** The int4 attention weights of each layer are relocated into one contiguous block in use order (15.15 MB per layer: projections, then wo); kernels that do not use DRAM issue L2 prefetches (`sycl::ext::oneapi::experimental::prefetch`, fire-and-forget) of a slice of the weights the next big kernel will read: the current layer's wo from `k_kv` / `k_attn_p`, the next visit's projections from `router_fused`, `k_act_q`, `k_combine_conv` (the expert streams use L2-uncached loads, so the prefetched lines survive the MoE). Output identical.
* The prefetched data is used: next-visit projections 29.3 -> 21.0 us with 5.5 MB prefetched (VTune per-kernel time); wo 12.6 -> 5.8 us when its 4 MB were prefetched by the attention kernel.
* But a kernel does not finish before its prefetches have arrived: attention 7.4 -> 16.4 us (+4 MB), router 8.8 -> 15.8 / 14.4 us (+3 MB, prefetches issued at the start / at the end of each work-item), act_q 4.0 -> 7.5 us (+1.5 MB), combine 3.1 -> 5.2-5.7 us (+1 MB). The added time equals the transfer at ~470 GB/s, wherever the prefetches are issued: on one in-order queue the prefetch moves the transfer time from the consumer to the issuer and adds the issuer's extension.
* E2E (history / code): no prefetch 103.25 / 103.11, 103.58 / 103.47; wo only 102.3-102.9; next-visit projections 2 / 4.5 / 7.5 MB 102.0 / 101.2 / 100.4; both 100.6. Every configuration is slower.
Using the 2.96 ms of idle DRAM therefore needs the weight transfer to run concurrently with the small kernels (a second queue), not inside them.

**Concurrent prefetch on a second queue (`XIK_AWPF=2` with `ZEX_NUMBER_OF_CCS=4`).** The multi-CCS mode alone costs nothing (103.54 / 103.12, 103.29 / 103.16 vs 103.22 / 103.33, 103.40 / 103.44). Prefetching the whole next-visit attention block (15 MB) from a side queue after the MoE: 94.9 tok/s (-8 %: the transfer runs into the next projections and competes with them). Limited to the first 2 / 4 / 7 MB of the block with 256 issuing threads (`XIK_AWPF_KB`, `XIK_AWPF_THR`): 103.2 / 103.0 / 102.3 against 103.3: no gain.

## 21. T = 1 expert kernel with one struct argument (`moe_p3_isa`, `XIK_P3ISA`, default 1) and the hand-written ISA path

Built as the carrier for a hand-written ISA replacement (stable argument layout: one struct), the kernel has the arithmetic of `moe_p3_t<1, 1>` for one token per slot without the generic token loop (`for g0 < cnt`, `elist` loads, chunk arrays). Kernel time (`--bench-moe`, cold weights, GPU timestamps): w13 43.5 -> 39.3 us (397 -> 440 GB/s, 96 % of the DRAM peak), w2 23.7 -> 19.6 us (362 -> 439 GB/s, 96 %). Greedy output identical (2 prompts x 150 tokens). Plain decode (GPU 1, history / code): 107.31 / 107.31, 106.95 / 107.30 against 103.02 / 103.06, 103.01 / 103.06: +4.2 % (~0.39 ms per step). Made the default.
The same single-struct T = 1 form for the MXFP8 experts (`moe_fp8_t1`, `XIK_F8T1`, default off): identical output, 107.0-107.25 vs 107.2-107.4: no gain.

**Hand-written ISA inside the engine (`XIK_P3ISA=2 XIK_ISA_P3=<zebin>`).** The offline ISA of `moe_p3_isa` is edited and loaded instead of the JIT kernel for every T = 1 planar expert GEMM (88 launches per step): `tools/isa/moe_p3/p3_edit.py` loads each tile's two 128-B activation records one tile ahead into a second register set (r60-r63 / r64-r67, tile 0 before the loop, address = record base + t * 256), so the first DPAS of a tile no longer waits for a load issued at the start of that tile; the records buffer got 4 KB of slack for the reads past the last tile. Output identical to the JIT kernel in the full model. Kernel time: w13 / w2 = 39.3 / 19.6 us (ESIMD), 40.0 / 20.0 us (ISA round trip with IGA-generated SWSB), 40.0 / 19.9 us (hand edit, IGA SWSB). The edit is neutral against its own round trip; the IGA dependency placement costs ~0.6 us per call against the compiler's, so the ESIMD carrier stays the default. The record loads hit L1 / L2 and are hidden by the other threads of the EU.
Compact 268-B argument struct for the T = 1 attention GEMV (`w4z_r1c`, `XIK_W4C`, default off; W4Args is 456 B): identical output, 105.1 / 105.7, 105.9 / 105.6 vs 107.6 / 107.4, 107.2 / 107.3: slower (the segment fields are then selected from per-field arrays).

**Official numbers after this round (6 tasks x 5, decode-only, one B60, GPU 0, `build_exp100`):** K3x 107.49 / 107.22 / 107.31 / 107.43 / 106.96 / 106.73, geo-mean **107.19 tok/s** (9.33 ms per step; was 99.8 at the start of the T = 1 work); K1 93.27 / 93.42 / 93.22 / 93.02 / 92.82 / 92.69, geo-mean 93.07. Hybrid (K3x, GPU 1): code 145.2, history 109.4, prose 99.3, repeat 306.1, edit_py 356.6, jsonl 161.4, geo-mean 174.0 (per-task values move with the generated text; see section 14). All changes of this round are output-identical to the reference kernels. Left for 120 tok/s: 9.33 -> 8.33 ms = 1.00 ms.
