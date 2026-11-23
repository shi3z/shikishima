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
