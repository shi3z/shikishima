# Attention V accumulation (k_attn): why 21.0 -> 15.6 ms, and what was adopted

Default is now VW=8 with the outer loop unrolled x4 (`XIK_ATTN` / `XIK_ATTN_UNR`; `XIK_ATTN=0` = original loop). Arithmetic order unchanged:
per key one rounded multiply and one rounded add, j ascending; logits and tokens are bit-identical to the original (64 steps at ctx 512..576, plain
and hybrid 256-token outputs 12/12 identical).

## Step wall, T=1 (bench-submit, 5 interleaved reps at ctx 256, 3 at 1024/4000; spread <= 0.1 ms)
| config | ctx 256 | ctx 1024 | ctx 4000 |
|---|---|---|---|
| A original (VW0) | 21.02 | 37.15 | 47.86 |
| B VW0 + forced unroll x4 (= compiler-unrolled VW1) | 16.62 | 21.84 | 25.14 |
| VW8 | 15.95 | 19.32 | 21.43 |
| VW12 / VW16 / VW32 | 15.74 / 15.68 / 16.05 | 18.48 / 18.02 / 18.90 | 20.18 / 19.51 / 20.77 |
| two-stage ring RB=6 / 8 | 15.66 / 15.72 | 18.28 / 18.48 | 19.91 / 20.19 |
| **D: VW8 + unroll x4** | **15.56** | **17.84** | **19.23** |
Timing-only ablations (wrong numbers) at ctx 256: removing the V global load takes A from 21.02 to 15.58 (-5.44 ms) but VW8 only from 15.95 to 15.10;
removing the SLM read changes nothing (<= 0.1 ms).  Attribution of A -> D at ctx 256 (-5.46 ms): unroll x4 alone -4.40 (81%), 8 loads in flight -0.67 (12%),
loop/address overhead -0.39 (7%); SLM message merging ~0.
Not explained: in the ISA of B only one V load is outstanding per thread (consumer within 3-4 instructions), yet the exposed latency per key falls ~3.7x.

## ISA of D (docs/isa/k_attn_cfg_c8_4_0.asm, loads: docs/bench/attention/D_loads.txt)
32 global V loads per loop iteration in 4 groups of 8 (16 instructions apart); max 7 outstanding (issue -> first wait on its SBID); only 8 SBIDs used
($0,2,8,9,10,11,12,14), no SBID reuse stall; GRF 128, no scratch.  Width 32 uses all 16 SBIDs (31 loads, 16 SBIDs reused while outstanding) and is slower.

## End to end, D vs original, 6 tasks x 5 interleaved reps (docs/bench/attention/D_vs_orig_6x5.log)
plain +19.3% geo-mean (+16.6..+23.2%, 30/30 wins), Hybrid +8.6% (+5.5..+14.7%, 30/30), tok/s decode-only.
