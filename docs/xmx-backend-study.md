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
