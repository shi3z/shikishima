# Xe2 mixed quantisation: LM head int4, attention int4, MoE experts int3 (W3A16)

All formats are **approximate modes** (they requantise the official checkpoint: dense weights BF16, experts NVFP4 / MXFP8), switchable by environment variables, and
evaluated against the BF16-dense reference of this engine.  Memory format and XMX compute format are independent: every format is decoded to fp16 operands and
multiplied by the fp16 DPAS, fp32 accumulation.  Native INT3 / INT4 DPAS is not used.

## Switches

| switch | meaning |
|---|---|
| `XIK_HEAD_FP8=1` (default in the approximate mode) | LM head int4 (group 64, symmetric); `XIK_HEAD_W4=0` keeps the FP8 head |
| `XIK_AW4="wq_du=0-23;wk_dv=0-23;wo_ud=0-5,18-23"` | attention matrices (name substring = layer ranges) that get an int4 copy (group 64, asymmetric, activation-weighted scale search with `XIK_ACT_STATS_FILE`); T <= 16 uses it, prefill keeps FP8 |
| `XIK_W3=1`, `XIK_W3L="2,6-9,11"`, `XIK_W3W=1/2/3` | MoE experts of the listed NVFP4 layers (w13 / w2 / both) stored as W3A16 |
| `XIK_E3SIM=3|2` (+`XIK_E3G`, `XIK_E3L`, `XIK_E3W`, `XIK_E3MAP`) | quality simulation of int3 / int2 experts in NVFP4 form (no speed) |
| `XIK_W4SIM`, `XIK_W4SEL`, `XIK_W4LAYERS` | quality simulation of int4 dense matrices (per matrix / layer) |

## W3A16 expert format (per 16-row block, 128 K = one 768 B super-tile = 3 x 256 B)

* dword (d, lane) d = 0..11, lane = row; each group of 32 K uses three dwords (a, b, c) and yields 16 fp16-pair registers = two 16-K DPAS B operands.
* pre-permuted ("DPAS-order") layout: pair rho (K = 2 rho, 2 rho + 1 in the low / high 16-bit half) sits at bits 3j..3j+2 (low half) and 16 + 3j.. (high half) of dword i, rho = 5 i + j (15 pairs);
  pair 15 uses bit 15 / 31 of a, b, c.  Unpack of one register = `shr` + `bfn.0xEA` (s0 | s1 & s2, fused and-or) with the fp16 magic 0x6400; the offset (1024 + 4) is removed by one half subtraction per two registers.
* scales: fp16 per (row, 64 K), 32 B per (16-row block, group), 64 B per super-tile, stream separate from the weights (outer NVFP4 scale amax / den folded in).
* bytes per 2048 weights: 768 + 64 = 832 B = 3.25 bit/weight (NVFP4 incl. scales: 4.5), i.e. -27.8 %.  Super-tiles are 3 x 256 B aligned, the per-row-block weight stream is a multiple of 256 B
  (w13: 18 x 768 = 54 x 256, w2: 9 x 768 = 27 x 256); the scale stream is 64 B-line aligned only (1152 B per row block for w13).

### Format comparison (microbenchmark `--bench-w3`, 8 experts of w13 2304 x 2304 / w2 2304 x 1152, cold weights, group 64, relative error vs host reference 1e-7 in all formats)

| format | w13 us | w2 us | GB/s (true bytes) | ISA lines (R=1 kernel) |
|---|---|---|---|---|
| plain 3-bit stream (elements straddle dwords) | 53.0 | 26.9 | 325 | 809 |
| 2-bit planes + 1-bit plane | 40.7 | 21.5 | 424 | 592 |
| three 1-bit planes | 43.0 | 24.1 | 401 | 721 |
| **DPAS-order pre-permuted** | **39.7** | **20.3** | **435** | **424** |
| NVFP4 (production, best config) | 57.3 | 29.2 | 417 | |

## Findings on the in-situ gap (0.73 ms measured vs 1.2 ms expected)

* In the real decode kernels (cold layers rotating) W3 is 49.5 / 26.8 us (w13 / w2) vs NVFP4 57.3 / 29.2: -14 % / -8 %, bytes -28 %: effective bandwidth 349 / 321 GB/s (micro: 434).
* VTune (gpu-hotspots overview, T=1, w13): W3 executes **fewer** dynamic ALU instructions than NVFP4 (60.2 G vs 69.0 G per 3000 launches), identical XMX instructions (1.48 G); ALU1 active 26 % vs 30 %.
  The dominant stall is SBID (waiting for SEND data): 40 % vs 50 %.  The unpack is not the limit; the W3 kernel is as memory-latency bound as NVFP4 and reaches about 87 % of its bandwidth efficiency.
* The T > 1 W3 kernel (R = 2/4/8 bodies in one kernel) spilled 1300+ GRF slots (ISA 5400 lines, 1455 SENDs) because activations for all R rows were prefetched per tile: T=8 was slower than NVFP4 (w13 429 vs 404 us).
  Loading activations per 32-K group for R >= 4 removes the spill (55-72 slots left): T=8 w13 310 us, w2 160 us (NVFP4 404 / 194).
* Splitting K over 3 or 9 threads per row block (work-group + SLM reduction) made things worse in situ (E2E 78.0 -> 75.6 / 66.1 tok/s); deeper weight prefetch (NB = 2/3/4) did not change the w2 time.
* ISA of the R=1 loop: the SENDs of tile t + 2 were issued at the END of tile t (prefetch distance one tile of ALU work).  The kernel now issues them at the start of the tile before the one that consumes them (early issue); NB = 3 gives two tiles of ALU work under the SENDs.

## Quality (BF16-dense reference, 6 tasks x 256 teacher-forced tokens; KL in nats/token)

Attention int4 (asymmetric, group 64, activation-weighted), one matrix or layer band at a time (FP8 reference 0.0020):

| quantised | KL |
|---|---|
| wr 0.0013, wk 0.0017, wq 0.0019, gate 0.0022 | = FP8 level |
| wv 0.0035, wo 0.0046 | sensitive |
| layers 0-5 / 6-17 (visited 3x) / 18-23, all six matrices | 0.0024 / **0.0054** / 0.0010 |

Group size / objective matrix (attention + wo int4, 18 configs): asymmetric g64 activation-weighted 0.0061 (best), asymmetric g32 0.0064, symmetric g256 MSE 0.0136 (worst); asymmetric beats symmetric by ~20 %.

Experts requantised from NVFP4 (all weights have the same relative error 3.7 %: 3.66-3.8 % for every expert and matrix, so weight error cannot rank experts):

| quantised | KL (base 0.0048 incl. int4 head) |
|---|---|
| int3 g64 all NVFP4 layers (g32 / g128) | 0.0241 (0.0219 / 0.0273) |
| int3 w13 only / w2 only | 0.0168 / 0.0129 |
| int3 layers 0-5 / 6-17 / 18-19 | 0.0071 / 0.0197 / 0.0069 |
| int2 g64 w13 only / w2 only; int2 g32 all | 0.115 / 0.051; 2.52 (collapse) |

Per-layer int3 (3 sensitive tasks, delta KL x 1e-4): L0-5 10 8 6 8 9 7; L6-17 13 12 17 19 26 19 **55** 20 14 20 21 20; L18-19 17 13.  Layer 12 is an outlier (3x its neighbours); not investigated further.
Layers 6-17 are visited three times per token but cost less KL per visit than the others, so they are the best place for int3 per byte saved.

Routing: top-8 experts of a layer carry 16-29 % of the selections, top-32 46-63 %, entropy 6.3-6.75 of 7 bits (61k visits, 1272 tokens); damage and saving both scale with usage, so frequency alone does not separate experts.

## Combined configurations (see the table of results at the end of the file)

## Combined configurations: measured results

Decode-only tok/s, median of 5 interleaved repeats, XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 (int4 head) in all rows. Task order: code, history, prose, repeat, edit_py, jsonl.

| config | attention int4 | MoE int3 layers | plain tok/s (geo-mean) | Hybrid geo-mean | KL | GSM8K | MMLU | code exec |
|---|---|---|---|---|---|---|---|---|
| K0 base | - | - | 73.7 | 125.4 | ref | 85.0 | 85.8 | 100 |
| K1 | wq wk wr gate, all layers | 2,6-9,11,13-14 | 78.6 | 137.5 | - | 86.7 | 84.2 | 100 |
| K2 | K1 + wv/wo layers 0-5,18-23 | 1-2,5-9,11,13-17 | 80.9 | 113.8 | - | 85.0 | 85.0 | 93.8 |
| K3 | all six matrices, all layers | 0-19 | 85.4 | 150.4 | - | 86.7 | 83.3 | 93.8 |

Plain per-task medians: K0 73.9/74.0/73.7/73.8/73.5/73.2, K3 85.7/85.8/85.6/85.6/85.0/84.7. Plain is stable across tasks (+/-1 %); Hybrid depends on the accepted draft length, so its geo-mean is noisy (K2 is lower because its drafts diverge on repeat/jsonl).
Plain stays at 85.4 tok/s (11.7 ms/token); 100 tok/s is not reached.

## ISA / memory-system optimisation round (K3, plain T=1)

Per-step kernel table of the K3 decode (VTune gpu-hotspots, global-memory-accesses, 63 decode steps, `/data/inkling/ktab.py`), before this round, ms per step:

| group | kernel | ms/step | true bytes/step | GB/s | floor at 456 GB/s | gap |
|---|---|---|---|---|---|---|
| MoE NVFP4 layers as W3 (44 visits x w13+w2, 8 experts) | `moe_w3g_t<1,1,2>` | 3.39 (+0.23 w2 tail) | 1140 MB | 336 | 2.50 | 0.9 |
| MoE MXFP8 layers 20-23 (4 visits) | `moe_fp8g_t` | 0.81 | 262 MB | 325 | 0.57 | 0.24 |
| attention int4, q/k/v + router/gate (48 visits) | `w4z_r<1>` | 1.45 | 509 MB (all attention) | 245 | 1.12 (all) | ~0.9 |
| attention wo int4 | `w4z_r<1>` | 0.63 | | | | |
| head int4 | `w4_gemv_r<12,1>` | 0.56 | 260 MB | 468 | 0.57 | 0 |
| controller / norms / mixers / conv / kv / router / small (about 800 kernels) | `k_ctl_fused`, `k_router`, `k_conv`, `k_kv`, ... | about 4.5 | small | | | about 4.5 |

Sum of kernel durations 9.97 ms (901 kernels per step, `--step-timeline`), step 11.3 ms: about 1.4 ms is the idle gap between kernels.  Bytes that must stream: about 2.17 GB, floor 4.76 ms; the 6.5 ms above the floor is about 1 ms in weight kernels (below 456 GB/s), about 4.5 ms in several hundred small kernels and about 1.4 ms in launch gaps.

Results of the experiments (history / repeat prompt, plain decode tok/s, K3):

| change | tok/s | verdict |
|---|---|---|
| baseline (build_exp29) | 85.7 | |
| W3 early issue of the tile loads, NB = 2 | 86.8 (+1.1) | kept |
| NB = 3 / 4 | 84.7 / 84.9 | slower |
| NB = 6 / 8 | 71.5 / 66.4 | slower (register pressure) |
| attention int4: all 3-4 groups of a thread requested up front (`XIK_W4ZUP`, removed) | 85.5 | slower |
| W3 tile-major layout [expert][tile][row block] (`XIK_W3TM`, default on) | **88.1** (+1.4) | kept, bit-identical output |
| attention int4 group-major layout (`XIK_W4TM`) | 87.8 (no gain) | off |

The tile-major layout puts the tile t of neighbouring threads next to each other, so that the 1152 concurrent streams of the T = 1 launch read a moving contiguous window instead of 1152 separate 768 B pieces: this is a DRAM page locality effect, not an ALU effect.

MXFP8 experts (layers 20-23) in the same tile-major layout (`XIK_F8TM`, default on): 88.4 -> 88.6 tok/s, output bit-identical (md5 of 128 greedy tokens equal).

### 6 tasks x 5 repeats after this round (decode-only tok/s, median, build with tile-major W3 default)

| config | plain (code/history/prose/repeat/edit_py/jsonl) | plain geo-mean | Hybrid geo-mean |
|---|---|---|---|
| K0 | 73.8 74.0 73.9 73.8 73.4 73.3 | 73.7 | 125.4 |
| K1 | 79.9 80.0 79.7 79.8 79.3 79.0 | 79.6 (was 78.6) | 138.9 |
| K3 | 88.1 88.2 88.0 88.1 87.5 87.2 | **87.9** (was 85.4) | 150.0 |

Layout changes do not alter arithmetic: quality of K1/K3 is unchanged (same KL / GSM8K / MMLU / code numbers as above; output identical to the previous layout). The MXFP8 tile-major build adds a further +0.3 tok/s (88.6 on the history/repeat prompts).

### Further experiments of this round (K3 plain, history/repeat prompts)

| experiment | tok/s | verdict |
|---|---|---|
| NB = 3 / 4 with the tile-major layout | 88.0 / 87.3 (NB = 2: 88.6) | NB = 2 stays |
| `UR_L0_USE_IMMEDIATE_COMMANDLISTS` 0/1/2, `SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1` | 88.5-88.8 | no effect (launches are already pipelined) |
| L2 prefetch of the next visit's int4 attention weights in a prefetch kernel of the main queue (`XIK_AWPF=1`) | 78.5 | **-10 tok/s**: the kernel lasts as long as the memory transfer (prefetch issue blocks), the gain does not pay it back |
| same kernel in a second in-order queue (`XIK_AWPF=2`, also `ZEX_NUMBER_OF_CCS=4`) | 80.0 | still serialised on the compute engine |

Verification-width passes (`--bench-prefill`, ms per pass, K0 -> K3): T=2 18.2 -> 15.5, T=4 23.2 -> 19.5, T=8 29.9 -> 26.9, T=16 47.8 -> 44.1.

State after this round: K3 plain 88.6 tok/s (11.3 ms/token), 1.3 ms above the 100 tok/s target.  Remaining: weight kernels about 1.6 ms above the 456 GB/s floor (W3 0.9, attention int4 0.5, MXFP8 0.2), about 4.4 ms in ~800 small kernels and about 1.4 ms of inter-kernel idle gaps.  The next lever is kernel fusion (router GEMV + routing, cvt/group, norm + mixer chains), not the INT3/INT4 weight loops.
