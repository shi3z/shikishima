# Fused ESIMD controller (default for T = 1; `XIK_CTL_FUSED=0` restores the SYCL chain) -- APPROXIMATE

One launch with two software grid barriers replaces pairnorm, ctl_down GEMV, gain/forget GEMV and blend (4 launches per controller, 48 per token).
Phase 0: pairnorm (reduce order reproduced exactly, `--test-ctl`) + ctl_down partial sums; barrier; hid = sum of the 16 partials (dgemm_t order), scale, bf16;
phase 1: gain/forget GEMV, tanh (exp/inv sequence), blend, store; barrier; phase 2: sum of squares in reduce_over_group order, rms norm, bf16 store.
72 threads per stream (9 work-groups of 8), at most 3 streams; barrier spins are bounded (error counter).  FP8 and bf16 weight layouts are handled.

Not bit-identical to the SYCL chain (tanh sequence; one rare 1-ulp pairnorm difference, 7 of 2.36M outputs).  Measured:
* controller output: 99.996% of bf16 values identical (tail only), hid 0.036% 1-ulp flips (full fusion);
* 6 tasks x 256 tokens, teacher-forced: top-1 100%, KL <= 0.0003 nats/token; free-running greedy identical on 5 of 6 tasks (history diverges at token 78);
* speed (ctx 512, replayed routing, 5 interleaved reps): 16.07 -> 14.97 ms/token (tail only: 15.16);
* E2E 6 tasks x 5, decode tok/s: plain +7.4% geo-mean (30/30), Hybrid +2.3% (code -0.9%, jsonl -0.1%);
* in-kernel timeline (mean per work-group): attention controller 19.3 us (barrier waits 2.3 + 1.6), mlp controller 5.5 us (0.45 + 0.34);
  a 144-thread variant was slower (25 us) and not kept; the tanh sequence costs nothing measurable (cheapest stand-in: identical time).
Logs: docs/bench/controller/.
