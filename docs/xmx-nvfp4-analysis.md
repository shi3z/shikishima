# NVFP4 expert: XMX utilisation (VTune gpu-hotspots overview, bench loops, 3000 launches each)
Script `docs/bench/xm.sh`; raw per-run tables `docs/bench/xm_k{kind}_T{T}_r{rot}_tasks.tsv` (kind 0 = w13, 1 = w2; r20 = cold layers, r1 = same layer = warm).
Counters are VTune's per-kernel aggregates (percent of XVE-array time over the kernel's duration; stall reasons overlap, so they do not sum to 100).

| run | us/launch | XMX active | ALU1 active | XVE active | XVE stalled | XVE idle | occupancy | SBID | Dist/Acc | Send | DPAS/launch | ALU instr/launch |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| w13 T1 warm | 61.4 | 1.4% | 29.6% | 33.0% | 52.6% | 14.5% | 76.8% | 51.5 | 31.7 | 23.6 | 163,708 | 7.38 M |
| w13 T1 cold | 64.1 | 1.3% | 28.2% | 31.4% | 51.9% | 16.7% | 72.2% | 48.8 | 30.4 | 18.2 | 162,969 | 7.35 M |
| w2 T1 warm | 29.9 | 1.4% | 31.0% | 34.4% | 48.1% | 17.4% | 73.1% | 46.1 | 29.0 | 19.5 | 79,678 | 3.70 M |
| w2 T1 cold | 35.1 | 1.2% | 26.6% | 29.6% | 45.3% | 25.1% | 62.9% | 40.7 | 26.3 | 14.4 | 80,448 | 3.73 M |
| w13 T8 warm | 403 | 1.7% | 34.3% | 38.4% | 57.3% | 4.3% | 85.6% | 55.8 | 37.1 | 17.3 | 1.32 M | 57.1 M |
| w13 T8 cold | 417 | 1.7% | 33.1% | 37.1% | 58.7% | 4.1% | 85.8% | 57.2 | 37.2 | 18.3 | 1.32 M | 57.1 M |
| w2 T8 warm | 192 | 1.8% | 37.0% | 41.4% | 53.9% | 4.7% | 82.8% | 52.0 | 36.1 | 11.6 | 0.66 M | 29.4 M |
| w2 T8 cold | 207 | 1.7% | 34.2% | 38.4% | 57.2% | 4.4% | 82.8% | 55.4 | 36.5 | 14.0 | 0.66 M | 29.4 M |

GRF 128, spill 0 B in all runs (VTune). DPAS count = 1152 threads x 36 (w13) or 18 (w2) supertiles x 4 = matches.
Effective bytes/s (bench routing: T=1 -> 8 distinct experts, T=8 -> 61): w13 T1 23.9 MB -> 389 (warm) / 373 (cold) GB/s;
w2 T1 11.9 MB -> 400 / 340; w13 T8 182 MB -> 444; w2 T8 91 MB -> 455 GB/s (floor used here: 456 GB/s).
