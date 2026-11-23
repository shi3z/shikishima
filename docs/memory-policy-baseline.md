# Memory-policy baseline (fastdiv + NVFP4 policy + Dense policy)

All three are output-identical to the all-off build (plain + Hybrid, 6 tasks, 12/12 parity). No arithmetic, quantisation or model change.

| Item | Default | Switch to revert |
|---|---|---|
| NVFP4 expert weights | L1 streaming + L2 uncached (`.st.uc`) | `XIK_LSC_POL=0,0` |
| NVFP4 scales | default (L2 cached) | — |
| MXFP8 experts | default (11 policies tried, no reproducible gain) | `XIK_FP8E_POL` |
| Attention fused launch (q,r,sink,gate,k,v), O, head | L1 streaming + L2 uncached | `XIK_DENSE_POL=0` / `XIK_POL_ATT|O|HEAD` |
| Loop controller | default (policy 3/5 both -0.7%) | `XIK_POL_CTL` |
| NVFP4 gid decode | constant-divisor fast path | `XIK_NO_FASTDIV=1` |

## Cumulative (all off vs defaults), 256 tokens, 6 tasks x 3 interleaved, decode-only tok/s
Reproduce: `docs/bench/cum.sh` (log: `docs/bench/cum_all_off_vs_default.log`).

| task | plain | | Hybrid | |
|---|---|---|---|---|
| code | 52.34 -> 56.13 | +7.2% | 81.73 -> 82.81 | +1.3% |
| history | 52.80 -> 56.63 | +7.3% | 71.76 -> 76.30 | +6.3% |
| prose | 52.26 -> 56.06 | +7.3% | 52.24 -> 58.75 | +12.5% |
| repeat | 51.77 -> 55.50 | +7.2% | 141.83 -> 150.03 | +5.8% |
| edit_py | 50.23 -> 53.79 | +7.1% | 208.29 -> 221.78 | +6.5% |
| jsonl | 49.77 -> 53.20 | +6.9% | 140.60 -> 149.32 | +6.2% |
| geo-mean | | +7.2% | | +6.4% |

Plain is ~56 tok/s (~17.9 ms/token); 75 tok/s (13.33 ms) is NOT reached.

## Counter / per-kernel breakdown (VTune, 48 decode steps, one run per config)
Configs: A all off; B NVFP4 policy only; C Dense policy only; D both; E both + fastdiv (= defaults).
Reproduce: `docs/bench/ph.sh`, tables: `docs/bench/ph_kernel_time.txt`, `docs/bench/ph_counters.txt`.

GPU kernel time/token: A 16.61, B 16.16, C 16.37, D 15.63, E 15.29 ms (-1.32 ms; wall-clock 19.1 -> 17.8 ms/token agrees).
Largest drops: NVFP4 expert -0.80, Dense attention -0.25. Controller / attention core unchanged (no measurable cross-kernel pollution).
DRAM read per token A 2651 MB vs E 2621 MB; LSC miss 31.6% vs 31.8%: policy changes neither bytes nor hit rate.
Caveat: per-kernel DRAM counters under-count in E2E sampling (~70% of logical bytes); L1 hit rate and SEND counts unavailable.
Mechanism for the speed-up is NOT established by counters. Single run per config: the ~0.3 ms interaction in small kernels is unconfirmed.
