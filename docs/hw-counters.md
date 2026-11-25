# GPU resource utilisation of K0 / K1 / K3 (VTune hardware counters, Xe2 B60)

Method: `docs/bench/hw/hwmeas.sh` runs `xi-run --bench-prefill` for one pass width T (1, 8, 16; 13 passes after the first warm-up) under `vtune -collect gpu-hotspots` in three characterization modes
(`overview`: EU array active/stalled/idle, occupancy, pipeline activity, stall reasons; `global-memory-accesses`: L3 / load-store-cache miss ratio, DRAM read/write bandwidth; `compute-extended`: instruction counts by type).
`hwan.py` / `hwreport.py` aggregate the per-kernel CSV (weight upload copies and one-time packing kernels excluded; whole-inference numbers are kernel-duration weighted means, so GPU idle gaps between kernels are NOT included).
Configs: K0 = FP8 dense + int4 head; K1 = + attention q/k/r/gate int4 + W3 on 8 layers; K3 = all six attention matrices int4 + W3 on layers 0-19 (build with tile-major layouts, `XIK_CHAIN` off).
The whole-model dynamic instruction instrumentation (`instruction-count` mode) was NOT used (suspended on request); instruction counts below come from the hardware counters of `compute-extended`.

## Counters that could not be obtained (not estimated)

* SIMD lane utilisation: no VTune mode of this version exposes it for ESIMD kernels (SIMD width of the task is reported, e.g. 16 / 32, but not the active-lane ratio) - not available.
* Number of simultaneously outstanding loads: there is no hardware counter; the only figure given is the **static** count of SBID-tracked loads in flight at each DPAS in the native ISA (section ISA below), labelled as static.
* "L2 hit rate": VTune reports `GPU L3 miss ratio` and `Load Store Cache miss ratio` (naming of the tool); the hit rate is 100 - miss. For streaming weights with L2-uncached policy the L3-miss figure is dominated by the policy, not by capacity.
* Bandwidth per very short kernel (< the sampling interval) is unreliable; the whole-pass DRAM read bandwidth is below the 456 GB/s peak because ~55 % of the pass time is XVE idle / launch latency inside small kernels.
* GRF "occupancy": per task VTune gives `General Register File Size` (128 for every kernel here, i.e. no large-GRF mode) and thread occupancy (%), not the register file fill.

## ISA and overlap findings (JIT dump of the shipped kernels, `docs/bench/hw/isaan.py`)

| kernel | ISA lines | SENDs (loads) | DPAS | spill SENDs | loads in flight at a DPAS (static) | ALU instr between consecutive DPAS | `sync.allwr` |
|---|---|---|---|---|---|---|---|
| `moe_w3g_t<R1=true,KSD=1,NB=2>` (T = 1, W3) | 782 | 21 (19) | 16 | 0 | avg 6.7, max 10 | 24.5 | 2 |
| `moe_w3g_t<R1=false,...>` (T > 1, W3) | 3591 | 324 (286) | 64 | 51 | avg 3.8, max 12 | 36.6 | 18 |
| `w4z_r<1>` (attention int4, T = 1) | 622 | 52 (40) | 4 per group | 0 | avg 4.2, max 8 | 3.3 | 2 |
| `w4z_r<8>` (T = 8) | 958 | 87 (68) | 4 per group | 0 | avg 5.2, max 9 | 35.0 | 2 |

* W3 T = 1: the DPAS of one 32-K group are separated by 16-25 INT3-expansion ALU instructions (`shr` / `bfn` / half subtract) of the next operand, and about 7 loads (the next tiles) are in flight: ALU, XMX and SEND are interleaved in the instruction stream inside one hardware thread. The DPAS accumulation chain is dependent (one accumulator), so the XMX latency of one group is only hidden by the following unpack ALU, not by other DPAS.
* `w4z_r<1>` (attention int4): the unpack (about 60 ALU instructions) comes first, then four back-to-back DPAS (3.3 ALU instructions between them), then the scale epilogue: ALU and XMX are serialised inside a thread; the overlap is only across threads. The next group's loads are in flight (4-8 SENDs) during this.
* No `sync.allwr` inside the loops (2 per kernel, prologue / epilogue): the SBID tokens are cycled by the compiler; no blanket waits.
* The T > 1 W3 kernel still has 51 spill SENDs (scratch traffic); `moe_fp8g_t` with R > 1 had 531 spill instructions in the earlier offline dump (MXFP8 layers 20-23 at T > 1).

## Answers to the specific questions

* **Is XMX idle during INT3 expansion?** Yes, almost always: XMX pipe active is 0.4-0.5 % of the XVE time at T = 1 (all configs) and 2.2-3.4 % at T = 8 / 16, ALU0 and XMX are active in the same cycle 0.0-0.2 % of the time, and the XMX / SEND instruction ratio is 0.2-0.4 at T = 1 (0.6-0.9 at T = 8 / 16). Each DPAS (8 x 16 x 16 MAC per row) needs 50-75 ALU instructions of weight expansion at T = 1 (ALU / XMX instruction ratio 53-76 for W3 / MXFP8, 20-26 at T = 8 / 16). The decode is a memory-latency / ALU bound kernel set, not an XMX-bound one.
* **Are ALU and SEND running while DPAS executes?** In the instruction stream yes (W3: 24.5 ALU instructions and 6.7 loads in flight per DPAS, static). In time: XVE Array active 15-18 % at T = 1 (31-39 % at T = 16), stalled 25-29 % (SBID 23-27 %, Send 9-11 %, Pipe about 1 %), idle 54-57 % at T = 1: the dominating state is idle / waiting for the next dependent kernel, then SBID stalls (waiting for load data), not pipe contention.
* **Occupancy:** XVE thread occupancy 35-37 % at T = 1, 53-62 % at T = 8 / 16 (work-size limited: the T = 1 expert kernels launch only 1152 threads for 160 EUs x 8 threads).
* **DRAM:** kernel-averaged read bandwidth 120-152 GB/s at T = 1 (K3 120), 168-216 at T = 8 / 16; writes 2-10 GB/s. The large weight kernels reach 108-240 GB/s averaged over their duration including ramp-up; the head GEMV is the highest (219 GB/s average at 555 us).
* **New finding for T > 1:** `gemv_bf16_t<4,8>` (the bf16 router GEMV, 128 x 2304, 0.6 MB of weights) takes 57 us per call at T = 8 and 50 us at T = 16 and is 10-11 % of the whole verify pass (about 2.7 ms of 27.8 ms at T = 8). It is a latency-bound kernel with 512 threads; fusing / restructuring it is the cheapest verify-width gain found so far.

## Tables

### 1. Whole inference (kernel-time weighted mean over all decode/verify kernels of one forward pass; weight upload / one-time packing kernels excluded)

| cfg | T | kernel time/pass ms | XVE Active % | Stalled % | Idle % | thread occupancy % | ALU0 active % | ALU1 active % | XMX active % | ALU0&XMX both % | multi-pipe % | stall SBID % | stall Send % | stall Pipe % | DRAM read GB/s | DRAM write GB/s | L3 miss % | LSC miss % |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| K0 | 1 | 12.93 | 15.5 | 30.8 | 53.6 | 37.2 | 1.7 | 13.4 | 0.5 | 0.0 | 0.5 | 28.2 | 10.3 | 0.6 | 163 | 1.7 | 73.8 | 29.3 |
| K0 | 8 | 29.68 | 26.0 | 38.9 | 35.1 | 54.1 | 3.5 | 21.6 | 2.3 | 0.1 | 1.2 | 35.9 | 6.3 | 1.1 | 213 | 5.8 | 73.6 | 23.5 |
| K0 | 16 | 47.57 | 31.3 | 40.6 | 28.1 | 60.5 | 4.6 | 25.6 | 3.1 | 0.1 | 1.6 | 37.8 | 6.3 | 1.5 | 222 | 7.8 | 70.9 | 22.5 |
| K1 | 1 | 11.93 | 15.4 | 29.3 | 55.2 | 35.4 | 2.7 | 12.6 | 0.5 | 0.0 | 0.7 | 25.8 | 11.0 | 0.6 | 152 | 3.1 | 74.1 | 28.2 |
| K1 | 8 | 28.28 | 30.0 | 37.6 | 32.4 | 56.9 | 4.9 | 24.4 | 2.5 | 0.1 | 1.6 | 33.5 | 9.9 | 1.3 | 205 | 8.7 | 73.0 | 20.7 |
| K1 | 16 | 45.69 | 36.5 | 37.6 | 26.0 | 63.0 | 6.1 | 29.5 | 3.3 | 0.2 | 2.2 | 33.8 | 7.8 | 1.7 | 201 | 10.5 | 66.4 | 20.1 |
| K3 | 1 | 10.71 | 14.2 | 25.5 | 60.2 | 30.3 | 3.3 | 10.9 | 0.5 | 0.0 | 0.8 | 22.0 | 9.8 | 0.5 | 129 | 1.4 | 74.6 | 29.1 |
| K3 | 8 | 26.71 | 30.3 | 31.0 | 38.7 | 52.6 | 5.7 | 24.2 | 2.5 | 0.2 | 1.8 | 26.8 | 11.1 | 1.2 | 177 | 7.1 | 70.8 | 18.5 |
| K3 | 16 | 43.81 | 39.3 | 32.5 | 28.2 | 62.5 | 7.0 | 31.6 | 3.4 | 0.2 | 2.5 | 28.4 | 9.3 | 1.8 | 172 | 9.5 | 63.7 | 17.2 |

(Averages are over kernel durations only; the GPU idle time between kernels is not part of these percentages. DRAM bandwidth is the VTune average over each kernel; for kernels shorter than the sampling interval it is unreliable.)

### 2. Instruction counts per pass (compute-extended mode; one pass = sum over kernels / 13 passes)

| cfg | T | SEND | ALU0 | ALU1 | XMX (DPAS) | bit-manip | control | ext-math | XMX per SEND | ALU(0+1) per XMX |
|---|---|---|---|---|---|---|---|---|---|---|
| K0 | 1 | 44.0 M | 89.2 M | 736.2 M | 12.96 M | 236.5 M | 11.8 M | 2.2 M | 0.295 | 64 |
| K0 | 8 | 180.3 M | 410.7 M | 2551.1 M | 136.06 M | 740.7 M | 42.2 M | 19.0 M | 0.755 | 22 |
| K0 | 16 | 376.8 M | 857.1 M | 4740.6 M | 284.31 M | 1280.3 M | 86.6 M | 39.0 M | 0.755 | 20 |
| K1 | 1 | 35.5 M | 120.2 M | 578.1 M | 11.75 M | 175.0 M | 11.1 M | 3.2 M | 0.331 | 59 |
| K1 | 8 | 205.6 M | 529.6 M | 2624.2 M | 137.70 M | 663.0 M | 62.4 M | 20.4 M | 0.670 | 23 |
| K1 | 16 | 453.3 M | 1090.8 M | 5237.5 M | 300.42 M | 1229.7 M | 131.2 M | 43.4 M | 0.663 | 21 |
| K3 | 1 | 30.0 M | 145.6 M | 480.5 M | 11.30 M | 136.9 M | 12.2 M | 3.6 M | 0.377 | 55 |
| K3 | 8 | 204.3 M | 579.9 M | 2522.2 M | 128.22 M | 561.8 M | 76.7 M | 18.0 M | 0.628 | 24 |
| K3 | 16 | 492.7 M | 1203.4 M | 5367.1 M | 291.37 M | 1095.5 M | 171.0 M | 41.9 M | 0.591 | 23 |

### 3. Main kernels (time share of the pass; instance-averaged metrics)


### K3, T = 1

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_w3g_t<(bool)1, (int)1, (int)2> (1152) | 29.6 | 36.1 | 128 | 0 | 12.7 | 22.3 | 64.9 | 25.7 | 3.1 | 9.6 | 0.50 | 18.8 | 8.0 | 108 | 1.2 | 75 | 30 | 0.38 | 53 |
| w4z_r<(int)1> (6432) | 13.5 | 30.2 | 128 | 0 | 14.4 | 25.8 | 59.8 | 29.1 | 3.5 | 10.9 | 0.60 | 21.7 | 9.8 | 70 | 0.6 | 76 | 30 | 0.45 | 53 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (2304) | 7.1 | 95.4 | 128 | 0 | 17.5 | 31.6 | 50.9 | 42.6 | 2.2 | 15.1 | 0.50 | 29.3 | 19.3 | 178 | 2.5 | 87 | 28 | 0.36 | 76 |
| w4z_r<(int)1> (1728) | 6.0 | 13.3 | 128 | 0 | 15.1 | 25.7 | 59.2 | 30.5 | 3.8 | 11.4 | 0.60 | 21.7 | 9.4 | 180 | 1.7 | 75 | 31 | 0.38 | 52 |
| w4_gemv_r<(int)12, (int)1> (150768) | 5.2 | 555.5 | 128 | 0 | 22.6 | 45.3 | 32.1 | 61.0 | 4.2 | 18.1 | 0.80 | 43.4 | 18.9 | 219 | 2.2 | 94 | 22 | 0.39 | 57 |
| gemv_bf16_t<(int)4, (int)1> (512) | 4.9 | 10.8 | 128 | 0 | 14.0 | 26.2 | 59.8 | 28.4 | 3.5 | 10.5 | 0.50 | 21.7 | 7.9 | 111 | 1.4 | 72 | 32 | 0.34 | 53 |
| k_ctl_fused<(int)0, (bool)1> (216) | 4.7 | 21.1 | 128 | 0 | 15.1 | 27.7 | 57.2 | 30.7 | 3.7 | 11.4 | 0.60 | 23.1 | 10.6 | 123 | 1.2 | 76 | 30 | 0.47 | 51 |
| k_ctl_fused<(int)0, (bool)1> (72) | 4.1 | 18.1 | 128 | 0 | 12.8 | 25.0 | 62.2 | 26.0 | 3.2 | 9.5 | 0.50 | 20.6 | 7.2 | 122 | 1.6 | 70 | 33 | 0.33 | 53 |
| k_router (128) | 2.6 | 5.8 | 128 | 0 | 14.7 | 27.8 | 57.5 | 29.8 | 3.7 | 10.9 | 0.60 | 23.1 | 8.6 | 124 | 1.4 | 72 | 30 | 0.35 | 53 |
| dgemm_t<(int)1, (int)16, (int)0, (int)5> (32) | 2.2 | 5.9 | 128 | 0 | 14.7 | 27.8 | 57.5 | 29.8 | 3.6 | 11.1 | 0.60 | 23.0 | 10.2 | 77 | 0.7 | 76 | 29 | 0.43 | 60 |
| k_conv (9216) | 2.2 | 2.4 | 128 | 0 | 14.6 | 26.1 | 59.3 | 29.6 | 3.6 | 11.0 | 0.60 | 21.9 | 9.7 | 149 | 1.4 | 76 | 31 | 0.37 | 59 |
| k_kv (4096) | 2.0 | 4.4 | 128 | 0 | 16.4 | 28.2 | 55.4 | 33.2 | 4.0 | 12.4 | 0.60 | 23.9 | 10.8 | 138 | 1.3 | 76 | 30 | 0.39 | 52 |

### K3, T = 8

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_w3g_t<(bool)0, (int)1, (int)2> (9216) | 42.6 | 129.2 | 128 | 0 | 29.8 | 30.9 | 39.3 | 51.7 | 6.2 | 23.1 | 2.60 | 26.6 | 9.1 | 169 | 6.5 | 74 | 18 | 0.63 | 23 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (18432) | 11.5 | 385.5 | 128 | 0 | 35.4 | 40.9 | 23.6 | 70.4 | 3.2 | 31.9 | 1.60 | 37.9 | 29.3 | 235 | 4.9 | 89 | 22 | 0.81 | 43 |
| gemv_bf16_t<(int)4, (int)8> (512) | 10.3 | 57.4 | 128 | 0 | 28.6 | 29.4 | 42.0 | 48.0 | 5.5 | 22.5 | 2.40 | 24.6 | 8.4 | 191 | 11.3 | 67 | 20 | 0.59 | 23 |
| w4z_r<(int)8> (6432) | 7.4 | 41.4 | 128 | 0 | 32.0 | 30.6 | 37.4 | 52.8 | 5.9 | 25.6 | 2.50 | 25.9 | 8.8 | 205 | 8.7 | 69 | 18 | 0.60 | 25 |
| w4z_r<(int)8> (1728) | 3.4 | 18.9 | 128 | 0 | 33.2 | 32.2 | 34.6 | 55.3 | 6.2 | 26.4 | 2.70 | 27.2 | 9.2 | 158 | 7.7 | 69 | 19 | 0.50 | 23 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 2.9 | 32.8 | 128 | 0 | 32.6 | 28.9 | 38.5 | 51.3 | 6.0 | 26.1 | 2.60 | 23.9 | 5.8 | 128 | 7.3 | 65 | 19 | 0.56 | 24 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.2 | 600.2 | 128 | 0 | 51.1 | 42.3 | 6.6 | 86.4 | 10.3 | 40.2 | 6.80 | 39.9 | 23.1 | 240 | 6.0 | 88 | 12 | 0.82 | 20 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (32) | 2.0 | 13.2 | 128 | 0 | 28.4 | 27.6 | 44.0 | 46.9 | 4.9 | 23.1 | 1.90 | 23.1 | 8.8 | 180 | 8.6 | 68 | 17 | 0.69 | 26 |
| k_attn_w<(int)8, (int)4, (int)0> (24576) | 1.3 | 7.2 | 128 | 0 | 33.8 | 33.1 | 33.2 | 57.6 | 7.2 | 26.3 | 2.70 | 28.8 | 12.0 | 224 | 7.9 | 74 | 18 | 0.61 | 22 |
| k_blend_t<(int)3> (6144) | 1.3 | 14.1 | 128 | 0 | 30.0 | 28.7 | 41.2 | 47.6 | 5.7 | 23.8 | 2.30 | 23.6 | 5.6 | 76 | 4.7 | 61 | 20 | 0.49 | 25 |
| k_group (128) | 1.2 | 6.8 | 128 | 0 | 28.3 | 30.7 | 41.0 | 48.6 | 5.4 | 22.4 | 2.20 | 25.9 | 9.6 | 278 | 14.2 | 70 | 21 | 0.63 | 23 |
| k_router (1024) | 1.2 | 6.7 | 128 | 0 | 24.0 | 25.7 | 50.3 | 40.8 | 5.1 | 18.5 | 2.10 | 21.6 | 7.1 | 156 | 9.0 | 68 | 20 | 0.62 | 22 |

### K3, T = 16

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_w3g_t<(bool)0, (int)1, (int)2> (18432) | 42.9 | 213.8 | 128 | 0 | 37.1 | 31.6 | 31.3 | 58.5 | 7.4 | 29.0 | 3.40 | 27.2 | 6.2 | 152 | 10.0 | 60 | 18 | 0.56 | 21 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (36864) | 11.3 | 618.5 | 128 | 0 | 42.1 | 42.8 | 15.1 | 78.6 | 3.6 | 38.1 | 2.20 | 39.7 | 30.7 | 229 | 5.8 | 82 | 21 | 0.88 | 39 |
| gemv_bf16_t<(int)4, (int)8> (512) | 11.0 | 50.0 | 128 | 0 | 40.1 | 30.5 | 29.4 | 60.8 | 7.2 | 32.2 | 3.40 | 26.3 | 6.0 | 132 | 9.3 | 58 | 17 | 0.55 | 22 |
| w4z_r<(int)8> (6432) | 8.3 | 37.9 | 128 | 0 | 40.9 | 30.6 | 28.5 | 62.4 | 7.0 | 33.4 | 3.20 | 26.4 | 7.0 | 196 | 9.6 | 67 | 16 | 0.57 | 26 |
| w4z_r<(int)8> (1728) | 3.6 | 16.3 | 128 | 0 | 42.1 | 31.9 | 26.0 | 64.7 | 7.6 | 33.9 | 3.50 | 27.7 | 7.4 | 235 | 13.4 | 64 | 16 | 0.58 | 24 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 3.4 | 31.0 | 128 | 0 | 38.3 | 30.3 | 31.4 | 58.6 | 7.1 | 30.4 | 3.50 | 25.7 | 4.6 | 161 | 11.1 | 60 | 16 | 0.55 | 21 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.7 | 601.7 | 128 | 0 | 57.3 | 39.4 | 3.3 | 89.3 | 12.0 | 44.6 | 8.00 | 36.8 | 17.7 | 297 | 8.7 | 86 | 10 | 0.79 | 15 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (32) | 2.3 | 12.7 | 128 | 0 | 38.5 | 31.1 | 30.4 | 60.2 | 7.3 | 30.7 | 3.20 | 26.8 | 6.9 | 196 | 7.6 | 68 | 16 | 0.58 | 23 |
| k_attn_w<(int)8, (int)4, (int)0> (49152) | 1.4 | 12.4 | 128 | 0 | 38.1 | 30.5 | 31.5 | 60.0 | 7.6 | 29.8 | 3.70 | 27.0 | 6.8 | 185 | 11.7 | 63 | 17 | 0.55 | 21 |
| k_group (128) | 1.3 | 11.9 | 128 | 0 | 38.2 | 30.1 | 31.8 | 56.4 | 7.3 | 30.2 | 3.30 | 25.1 | 4.1 | 90 | 8.5 | 52 | 19 | 0.50 | 23 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (4608) | 1.2 | 10.9 | 128 | 0 | 41.4 | 31.5 | 27.1 | 62.9 | 7.8 | 32.7 | 3.80 | 27.2 | 4.8 | 129 | 11.7 | 54 | 18 | 0.51 | 21 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (192) | 1.0 | 9.2 | 128 | 0 | 39.0 | 31.1 | 29.9 | 60.2 | 7.4 | 30.8 | 3.70 | 26.4 | 5.4 | 134 | 10.7 | 60 | 15 | 0.57 | 20 |

### K1, T = 1

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (1152) | 18.0 | 48.8 | 128 | 0 | 13.8 | 26.4 | 59.8 | 30.9 | 2.3 | 11.3 | 0.50 | 22.9 | 9.5 | 169 | 3.1 | 76 | 30 | 0.33 | 57 |
| moe_w3g_t<(bool)1, (int)1, (int)2> (1152) | 13.6 | 36.9 | 128 | 0 | 15.1 | 27.9 | 57.1 | 33.2 | 2.6 | 12.2 | 0.50 | 24.2 | 9.9 | 100 | 1.8 | 76 | 30 | 0.34 | 57 |
| w4z_r<(int)1> (5664) | 11.6 | 28.8 | 128 | 0 | 16.4 | 30.1 | 53.5 | 35.8 | 3.2 | 13.1 | 0.60 | 26.1 | 11.6 | 118 | 1.9 | 77 | 30 | 0.37 | 55 |
| dgemm_t<(int)1, (int)32, (int)0, (int)5> (4608) | 9.1 | 22.7 | 128 | 0 | 16.2 | 30.3 | 53.5 | 36.7 | 2.5 | 13.4 | 0.50 | 26.7 | 12.0 | 191 | 4.2 | 77 | 31 | 0.30 | 60 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (2304) | 6.6 | 98.3 | 128 | 0 | 17.9 | 33.9 | 48.2 | 44.8 | 1.7 | 15.9 | 0.50 | 31.3 | 18.8 | 182 | 4.8 | 85 | 28 | 0.31 | 81 |
| w4_gemv_r<(int)12, (int)1> (150768) | 4.7 | 555.5 | 128 | 0 | 23.9 | 49.5 | 26.6 | 66.1 | 4.7 | 18.8 | 0.90 | 47.2 | 18.8 | 339 | 5.5 | 94 | 21 | 0.37 | 57 |
| gemv_bf16_t<(int)4, (int)1> (512) | 4.3 | 10.8 | 128 | 0 | 13.8 | 26.5 | 59.6 | 30.7 | 2.3 | 11.3 | 0.50 | 22.8 | 8.2 | 116 | 2.6 | 73 | 31 | 0.29 | 59 |
| k_ctl_fused<(int)0, (bool)1> (216) | 4.3 | 21.4 | 128 | 0 | 16.3 | 32.6 | 51.1 | 35.7 | 3.1 | 13.0 | 0.60 | 27.7 | 11.8 | 160 | 3.1 | 76 | 30 | 0.38 | 55 |
| k_ctl_fused<(int)0, (bool)1> (72) | 3.6 | 18.1 | 128 | 0 | 15.7 | 33.7 | 50.6 | 34.8 | 3.1 | 12.4 | 0.50 | 28.0 | 8.6 | 202 | 5.0 | 70 | 32 | 0.28 | 59 |
| dgemm_t<(int)1, (int)16, (int)0, (int)5> (1056) | 3.0 | 8.9 | 128 | 0 | 14.6 | 27.1 | 58.3 | 33.8 | 2.0 | 12.4 | 0.50 | 24.2 | 12.5 | 148 | 3.7 | 81 | 29 | 0.42 | 54 |
| k_router (128) | 2.3 | 5.7 | 128 | 0 | 15.6 | 34.5 | 49.9 | 34.6 | 2.8 | 12.5 | 0.50 | 28.7 | 8.5 | 36 | 0.9 | 70 | 30 | 0.29 | 59 |
| k_conv (9216) | 2.0 | 2.5 | 128 | 0 | 15.8 | 27.7 | 56.5 | 35.4 | 2.5 | 13.2 | 0.50 | 24.7 | 11.9 | 254 | 4.4 | 79 | 30 | 0.35 | 69 |

### K1, T = 8

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (9216) | 23.8 | 152.9 | 128 | 0 | 26.5 | 39.0 | 34.4 | 54.5 | 4.3 | 21.4 | 2.50 | 35.5 | 5.3 | 208 | 8.2 | 76 | 22 | 0.76 | 21 |
| moe_w3g_t<(bool)0, (int)1, (int)2> (9216) | 20.1 | 129.4 | 128 | 0 | 30.0 | 36.6 | 33.4 | 55.6 | 5.7 | 23.5 | 2.70 | 32.0 | 8.2 | 218 | 9.6 | 73 | 20 | 0.64 | 22 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (18432) | 11.1 | 392.8 | 128 | 0 | 37.2 | 44.9 | 17.9 | 75.1 | 2.9 | 33.8 | 1.60 | 41.5 | 29.6 | 265 | 6.5 | 88 | 23 | 0.78 | 44 |
| gemv_bf16_t<(int)4, (int)8> (512) | 9.7 | 57.3 | 128 | 0 | 27.4 | 35.9 | 36.8 | 50.1 | 5.1 | 21.4 | 2.50 | 30.4 | 5.9 | 157 | 9.9 | 65 | 23 | 0.61 | 23 |
| w4z_r<(int)8> (5664) | 6.4 | 38.0 | 128 | 0 | 32.3 | 38.7 | 29.0 | 61.0 | 4.8 | 26.9 | 2.30 | 34.9 | 12.5 | 215 | 7.9 | 76 | 21 | 0.60 | 24 |
| dgemm_t<(int)8, (int)32, (int)0, (int)5> (4608) | 4.7 | 27.5 | 128 | 0 | 31.3 | 37.1 | 31.6 | 55.4 | 5.9 | 24.5 | 2.90 | 31.8 | 6.3 | 197 | 12.1 | 66 | 22 | 0.62 | 22 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 2.8 | 32.9 | 128 | 0 | 29.9 | 34.0 | 36.2 | 51.5 | 5.5 | 23.7 | 2.70 | 29.1 | 5.6 | 181 | 10.7 | 67 | 21 | 0.61 | 22 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (1056) | 2.3 | 16.4 | 128 | 0 | 32.8 | 38.0 | 29.3 | 61.1 | 5.1 | 27.1 | 2.80 | 34.7 | 10.3 | 210 | 6.9 | 79 | 21 | 0.56 | 23 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.1 | 599.8 | 128 | 0 | 50.8 | 42.8 | 6.5 | 87.1 | 8.2 | 42.1 | 5.40 | 40.3 | 26.0 | 335 | 8.1 | 90 | 12 | 0.83 | 21 |
| k_attn_w<(int)8, (int)4, (int)0> (24576) | 1.2 | 7.2 | 128 | 0 | 29.9 | 41.2 | 29.0 | 59.1 | 4.8 | 24.2 | 2.80 | 37.7 | 5.3 | 297 | 12.2 | 74 | 23 | 0.67 | 20 |
| k_blend_t<(int)3> (6144) | 1.2 | 14.2 | 128 | 0 | 33.8 | 34.3 | 31.8 | 56.1 | 6.2 | 27.0 | 2.80 | 29.1 | 6.5 | 259 | 15.8 | 65 | 22 | 0.63 | 20 |
| k_group (128) | 1.1 | 6.8 | 128 | 0 | 24.1 | 32.0 | 43.9 | 45.2 | 3.7 | 19.7 | 1.90 | 27.6 | 8.0 | 186 | 9.9 | 70 | 23 | 0.75 | 18 |

### K1, T = 16

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (18432) | 22.5 | 233.6 | 128 | 0 | 31.5 | 39.9 | 28.6 | 58.8 | 5.5 | 25.1 | 3.30 | 36.4 | 4.2 | 210 | 11.7 | 66 | 22 | 0.71 | 19 |
| moe_w3g_t<(bool)0, (int)1, (int)2> (18432) | 20.8 | 216.2 | 128 | 0 | 35.9 | 36.1 | 28.0 | 60.2 | 7.0 | 27.9 | 3.40 | 31.6 | 5.8 | 168 | 10.9 | 62 | 19 | 0.58 | 20 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (36864) | 10.8 | 617.1 | 128 | 0 | 45.7 | 42.0 | 12.4 | 80.7 | 3.8 | 41.5 | 2.20 | 38.5 | 26.9 | 280 | 7.8 | 82 | 22 | 0.91 | 38 |
| gemv_bf16_t<(int)4, (int)8> (512) | 10.5 | 50.0 | 128 | 0 | 37.8 | 38.1 | 24.2 | 63.5 | 6.8 | 29.9 | 3.60 | 34.1 | 4.9 | 157 | 9.5 | 63 | 21 | 0.64 | 20 |
| w4z_r<(int)8> (5664) | 7.0 | 33.2 | 128 | 0 | 37.8 | 36.4 | 25.8 | 63.6 | 5.9 | 31.2 | 3.10 | 32.9 | 6.2 | 179 | 8.8 | 70 | 19 | 0.66 | 22 |
| dgemm_t<(int)8, (int)32, (int)0, (int)5> (4608) | 5.6 | 26.9 | 128 | 0 | 37.6 | 39.4 | 23.0 | 65.2 | 6.6 | 30.1 | 3.60 | 35.8 | 5.5 | 240 | 13.8 | 66 | 20 | 0.67 | 20 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 3.2 | 30.9 | 128 | 0 | 33.8 | 35.3 | 30.9 | 57.2 | 6.1 | 26.8 | 3.30 | 31.0 | 4.6 | 198 | 11.5 | 65 | 18 | 0.58 | 22 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (1056) | 2.8 | 16.0 | 128 | 0 | 35.1 | 34.0 | 30.9 | 58.1 | 6.2 | 28.1 | 3.20 | 30.1 | 4.1 | 144 | 6.7 | 67 | 18 | 0.64 | 27 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.6 | 601.3 | 128 | 0 | 56.0 | 40.8 | 3.2 | 89.2 | 12.7 | 42.6 | 8.50 | 38.3 | 18.1 | 361 | 10.3 | 86 | 10 | 0.79 | 14 |
| k_attn_w<(int)8, (int)4, (int)0> (49152) | 1.3 | 12.3 | 128 | 0 | 33.8 | 39.6 | 26.6 | 61.0 | 6.3 | 26.6 | 3.70 | 36.6 | 5.0 | 258 | 14.5 | 66 | 21 | 0.68 | 18 |
| k_group (128) | 1.2 | 11.8 | 128 | 0 | 33.8 | 36.0 | 30.2 | 57.1 | 6.2 | 26.7 | 3.40 | 31.9 | 3.7 | 207 | 11.8 | 63 | 22 | 0.61 | 24 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (4608) | 1.1 | 10.9 | 128 | 0 | 39.2 | 36.8 | 24.0 | 64.1 | 7.3 | 31.0 | 3.70 | 32.5 | 5.3 | 70 | 5.4 | 59 | 21 | 0.61 | 20 |

### K0, T = 1

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (1152) | 32.5 | 47.7 | 128 | 0 | 15.3 | 30.0 | 54.7 | 35.8 | 1.5 | 13.3 | 0.50 | 27.4 | 10.2 | 139 | 0.5 | 77 | 31 | 0.31 | 61 |
| dgemm_t<(int)1, (int)16, (int)0, (int)5> (8608) | 16.3 | 52.6 | 128 | 0 | 15.5 | 31.3 | 53.1 | 36.5 | 1.5 | 13.6 | 0.50 | 28.4 | 10.3 | 185 | 1.3 | 77 | 31 | 0.32 | 61 |
| dgemm_t<(int)1, (int)32, (int)0, (int)5> (4608) | 8.3 | 22.3 | 128 | 0 | 15.9 | 32.0 | 52.1 | 37.5 | 1.6 | 13.8 | 0.50 | 29.0 | 8.7 | 189 | 0.7 | 75 | 31 | 0.26 | 65 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (2304) | 6.1 | 97.8 | 128 | 0 | 18.3 | 35.9 | 45.8 | 47.9 | 1.4 | 16.5 | 0.40 | 33.9 | 18.3 | 289 | 5.6 | 86 | 28 | 0.28 | 90 |
| w4_gemv_r<(int)12, (int)1> (150768) | 4.3 | 555.6 | 128 | 0 | 23.1 | 47.6 | 29.3 | 63.8 | 3.9 | 18.8 | 0.80 | 45.7 | 19.5 | 194 | 2.9 | 93 | 22 | 0.38 | 51 |
| gemv_bf16_t<(int)4, (int)1> (512) | 3.9 | 10.6 | 128 | 0 | 16.8 | 32.8 | 50.4 | 40.2 | 1.7 | 14.7 | 0.50 | 30.1 | 10.2 | 208 | 1.3 | 77 | 31 | 0.24 | 66 |
| k_ctl_fused<(int)0, (bool)1> (216) | 3.9 | 21.1 | 128 | 0 | 16.1 | 33.2 | 50.7 | 36.8 | 1.6 | 14.0 | 0.50 | 29.5 | 10.4 | 158 | 0.7 | 75 | 31 | 0.32 | 60 |
| dgemm_t<(int)1, (int)16, (int)0, (int)5> (8672) | 3.3 | 53.1 | 128 | 0 | 15.4 | 33.7 | 50.9 | 35.5 | 1.6 | 13.4 | 0.50 | 29.6 | 9.4 | 51 | 0.3 | 74 | 31 | 0.31 | 64 |
| k_ctl_fused<(int)0, (bool)1> (72) | 3.2 | 17.5 | 128 | 0 | 15.7 | 33.3 | 50.9 | 36.8 | 1.6 | 13.6 | 0.50 | 29.6 | 8.5 | 26 | 0.1 | 73 | 32 | 0.25 | 65 |
| k_router (128) | 2.0 | 5.5 | 128 | 0 | 15.2 | 33.0 | 51.8 | 35.5 | 1.6 | 13.1 | 0.50 | 29.1 | 8.6 | 121 | 0.5 | 73 | 30 | 0.26 | 67 |
| k_conv (9216) | 1.7 | 2.3 | 128 | 0 | 16.6 | 32.7 | 50.7 | 39.1 | 1.7 | 14.5 | 0.50 | 29.8 | 10.0 | 163 | 0.5 | 76 | 31 | 0.26 | 65 |
| k_kv (4096) | 1.6 | 4.2 | 128 | 0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 0.0 | 0.00 | 0.0 | 0.0 | 0 | 0.0 | 0 | 30 | 0.26 | 64 |

### K0, T = 8

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (9216) | 45.9 | 154.7 | 128 | 0 | 24.5 | 40.1 | 35.4 | 53.1 | 3.5 | 20.1 | 2.40 | 37.2 | 3.0 | 205 | 5.5 | 75 | 24 | 0.80 | 20 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (18432) | 10.4 | 385.7 | 128 | 0 | 36.4 | 43.9 | 19.7 | 73.8 | 2.6 | 33.2 | 1.60 | 40.9 | 28.5 | 277 | 6.3 | 89 | 22 | 0.79 | 44 |
| gemv_bf16_t<(int)4, (int)8> (512) | 9.3 | 57.4 | 128 | 0 | 25.2 | 38.6 | 36.1 | 51.8 | 3.5 | 20.7 | 2.30 | 35.0 | 4.0 | 221 | 5.0 | 73 | 24 | 0.68 | 21 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (8608) | 8.2 | 60.7 | 128 | 0 | 25.1 | 39.3 | 35.6 | 52.1 | 3.6 | 20.6 | 2.30 | 35.9 | 3.2 | 243 | 7.4 | 71 | 25 | 0.73 | 20 |
| dgemm_t<(int)8, (int)32, (int)0, (int)5> (4608) | 4.4 | 27.0 | 128 | 0 | 26.1 | 40.8 | 33.1 | 53.8 | 3.9 | 21.0 | 2.60 | 37.1 | 2.7 | 193 | 5.0 | 71 | 24 | 0.68 | 20 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 2.7 | 32.8 | 128 | 0 | 24.0 | 37.9 | 38.1 | 48.7 | 3.6 | 19.4 | 2.30 | 34.2 | 2.4 | 189 | 7.3 | 69 | 26 | 0.74 | 19 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.0 | 600.7 | 128 | 0 | 50.9 | 42.2 | 6.9 | 87.0 | 7.3 | 43.1 | 4.70 | 39.6 | 26.3 | 361 | 8.1 | 90 | 12 | 0.82 | 20 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (8672) | 1.7 | 61.6 | 128 | 0 | 26.9 | 36.8 | 36.2 | 54.7 | 2.7 | 23.6 | 1.70 | 34.2 | 10.8 | 110 | 4.3 | 81 | 25 | 0.79 | 28 |
| k_blend_t<(int)3> (6144) | 1.1 | 14.0 | 128 | 0 | 24.5 | 38.4 | 37.1 | 49.9 | 3.6 | 19.8 | 2.10 | 34.4 | 2.4 | 253 | 10.4 | 66 | 28 | 0.61 | 21 |
| k_group (128) | 1.1 | 6.8 | 128 | 0 | 13.4 | 22.5 | 64.1 | 26.6 | 2.3 | 10.4 | 1.30 | 19.2 | 0.9 | 39 | 1.6 | 62 | 24 | 0.69 | 23 |
| k_router (1024) | 1.1 | 6.8 | 128 | 0 | 21.8 | 35.0 | 43.2 | 42.8 | 3.7 | 17.1 | 2.10 | 30.3 | 2.0 | 94 | 3.7 | 63 | 26 | 0.70 | 20 |
| k_attn_w<(int)8, (int)4, (int)0> (24576) | 1.1 | 6.7 | 128 | 0 | 26.4 | 41.7 | 31.8 | 55.0 | 3.9 | 21.4 | 2.50 | 38.1 | 2.0 | 131 | 3.8 | 70 | 24 | 0.62 | 26 |

### K0, T = 16

| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| moe_fp4g_t<(int)1, (int)2, (int)5, (int)0, (bool (18432) | 43.3 | 234.0 | 128 | 0 | 28.1 | 40.9 | 31.0 | 56.5 | 4.5 | 22.3 | 3.00 | 37.9 | 2.8 | 226 | 7.8 | 69 | 24 | 0.70 | 18 |
| moe_fp8g_t<(int)1, (bool)0, (int)0, (int)0, (int (36864) | 10.5 | 623.3 | 128 | 0 | 43.1 | 43.8 | 13.0 | 80.4 | 3.3 | 39.2 | 2.10 | 40.7 | 28.4 | 246 | 6.2 | 84 | 21 | 0.88 | 40 |
| gemv_bf16_t<(int)4, (int)8> (512) | 10.1 | 50.0 | 128 | 0 | 31.1 | 39.6 | 29.3 | 58.2 | 4.8 | 25.1 | 3.10 | 36.7 | 3.5 | 204 | 7.1 | 69 | 24 | 0.69 | 19 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (8608) | 10.1 | 59.8 | 128 | 0 | 31.1 | 40.9 | 28.0 | 60.5 | 4.5 | 25.6 | 3.00 | 38.8 | 4.2 | 218 | 8.4 | 74 | 22 | 0.88 | 18 |
| dgemm_t<(int)8, (int)32, (int)0, (int)5> (4608) | 5.4 | 26.6 | 128 | 0 | 32.6 | 45.7 | 21.7 | 65.6 | 5.1 | 26.2 | 3.60 | 43.4 | 3.1 | 152 | 5.8 | 72 | 23 | 0.79 | 19 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (13824) | 3.1 | 31.0 | 128 | 0 | 26.6 | 38.8 | 34.6 | 52.8 | 4.3 | 21.4 | 3.00 | 35.9 | 2.9 | 169 | 9.6 | 71 | 23 | 0.89 | 17 |
| w4_gemv_r<(int)12, (int)8> (150768) | 2.5 | 601.7 | 128 | 0 | 56.4 | 39.0 | 4.6 | 88.1 | 12.1 | 43.6 | 8.00 | 36.5 | 17.1 | 309 | 8.9 | 86 | 10 | 0.79 | 14 |
| dgemm_t<(int)8, (int)16, (int)0, (int)5> (8672) | 2.0 | 60.5 | 128 | 0 | 34.9 | 39.3 | 25.8 | 62.5 | 4.6 | 29.4 | 2.90 | 36.3 | 4.8 | 189 | 8.2 | 72 | 23 | 0.83 | 25 |
| k_attn_w<(int)8, (int)4, (int)0> (49152) | 1.2 | 12.0 | 128 | 0 | 32.5 | 45.3 | 22.2 | 65.0 | 5.1 | 26.1 | 3.50 | 43.3 | 3.3 | 202 | 8.7 | 71 | 23 | 0.81 | 19 |
| k_group (128) | 1.2 | 11.9 | 128 | 0 | 30.1 | 37.5 | 32.4 | 55.4 | 4.3 | 24.7 | 2.70 | 34.2 | 4.0 | 281 | 8.3 | 70 | 23 | 0.69 | 19 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (4608) | 1.1 | 10.9 | 128 | 0 | 32.9 | 42.4 | 24.7 | 62.3 | 5.6 | 25.8 | 3.70 | 39.8 | 2.7 | 171 | 8.9 | 64 | 25 | 0.68 | 18 |
| dgemm_t<(int)8, (int)16, (int)0, (int)0> (192) | 0.9 | 9.3 | 128 | 0 | 26.6 | 38.5 | 34.9 | 52.9 | 4.4 | 21.1 | 3.20 | 35.7 | 2.7 | 275 | 13.8 | 73 | 22 | 0.98 | 16 |

## K3x (current default configuration of the speed work: K3 + int4 sink / dynamic-weight projections, all later kernel changes)

| cfg | T | kernel time/pass ms | XVE Active % | Stalled % | Idle % | thread occupancy % | ALU0 active % | ALU1 active % | XMX active % | ALU0&XMX both % | multi-pipe % | stall SBID % | stall Send % | stall Pipe % | DRAM read GB/s | DRAM write GB/s | L3 miss % | LSC miss % |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| K3 | 1 | 10.71 | 14.2 | 25.5 | 60.2 | 30.3 | 3.3 | 10.9 | 0.5 | 0.0 | 0.8 | 22.0 | 9.8 | 0.5 | 129 | 1.4 | 74.6 | 29.1 |
| K3 | 8 | 26.71 | 30.3 | 31.0 | 38.7 | 52.6 | 5.7 | 24.2 | 2.5 | 0.2 | 1.8 | 26.8 | 11.1 | 1.2 | 177 | 7.1 | 70.8 | 18.5 |
| K3 | 16 | 43.81 | 39.3 | 32.5 | 28.2 | 62.5 | 7.0 | 31.6 | 3.4 | 0.2 | 2.5 | 28.4 | 9.3 | 1.8 | 172 | 9.5 | 63.7 | 17.2 |
| K3x | 1 | 9.69 | 16.8 | 29.9 | 53.2 | 36.1 | 3.8 | 12.9 | 0.6 | 0.0 | 0.9 | 25.7 | 11.5 | 0.7 | 171 | 1.7 | 72.7 | 28.1 |
| K3x | 8 | 23.71 | 34.0 | 33.5 | 32.5 | 59.7 | 6.3 | 27.2 | 2.7 | 0.2 | 2.1 | 29.4 | 12.6 | 1.4 | 193 | 7.7 | 72.4 | 17.7 |
| K3x | 16 | 38.59 | 44.0 | 34.2 | 21.7 | 70.5 | 7.7 | 35.6 | 3.7 | 0.3 | 2.8 | 30.5 | 10.3 | 2.0 | 193 | 10.6 | 63.5 | 16.5 |

| cfg | T | SEND | ALU0 | ALU1 | XMX (DPAS) | bit-manip | control | ext-math | XMX per SEND | ALU(0+1) per XMX |
|---|---|---|---|---|---|---|---|---|---|---|
| K3 | 1 | 30.0 M | 145.6 M | 480.5 M | 11.30 M | 136.9 M | 12.2 M | 3.6 M | 0.377 | 55 |
| K3 | 8 | 204.3 M | 579.9 M | 2522.2 M | 128.22 M | 561.8 M | 76.7 M | 18.0 M | 0.628 | 24 |
| K3 | 16 | 492.7 M | 1203.4 M | 5367.1 M | 291.37 M | 1095.5 M | 171.0 M | 41.9 M | 0.591 | 23 |
| K3x | 1 | 33.2 M | 155.3 M | 494.0 M | 11.27 M | 138.2 M | 14.2 M | 5.6 M | 0.340 | 58 |
| K3x | 8 | 205.5 M | 565.1 M | 2529.9 M | 121.65 M | 553.4 M | 81.1 M | 20.0 M | 0.592 | 25 |
| K3x | 16 | 475.4 M | 1141.2 M | 5203.4 M | 271.86 M | 1053.9 M | 172.5 M | 41.8 M | 0.572 | 23 |

