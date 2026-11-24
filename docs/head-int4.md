# LM head in int4 (W4A16), default in the approximate mode (`XIK_HEAD_FP8=1`; `XIK_HEAD_W4=0` keeps the FP8 head)

Weights: group 64, symmetric, (nibble - 8) * fp16 scale, scale from a squared-error search (12 clipping candidates), quantised at load from the checkpoint's bf16
unembedding (`XIK_HEAD_W4_OBJ=2` + `XIK_ACT_STATS_FILE` = activation-weighted).  Layout: 16-row blocks x 32 K = 256 B per load (256 B aligned), fp16 scales per
(row block, 64-K group, 16 rows).  Compute: fp16 DPAS (nibble -> half by one shift/and/or and a half subtraction), fp32 accumulate per group, scale after the group sum.
Memory: 246 MB instead of 464 MB (FP8).  T = 1 .. 8 rows per launch (larger T in chunks of 8); the drafter's base head uses the same weights.

Measured:
* kernel (cold, T=1): 1030 us (FP8) -> 546 us, 450 GB/s; other shapes 2.0-2.3x faster than FP8 (q 22.7->9.9, wo 22.2->10.0 us);
* quality against the BF16-dense reference, 6 tasks x 256 tokens (FP8 dense in all candidates): KL 0.0021 (FP8 head) -> 0.0048 (int4, MSE) / 0.0043 (activation-weighted); top-1 98.8 -> 98.5 / 98.7%;
* tasks (GSM8K 60 q 4-shot, MMLU 120 q 5-shot, 16 executed code tests): 85.0/85.8/100 (FP8 head), 85.0/85.8/100 (int4 MSE), 90.0/85.8/100 (int4 act-weighted); resolution of these sets is about +-4.6 points;
* E2E decode tok/s, 6 tasks x 5: plain +3.3% (30/30); Hybrid +1.0% geo-mean (code +3.0, prose +3.1, repeat +7.0, edit_py +1.5, jsonl +3.2, history -10.9%:
  the generated text of that task changes (greedy divergence), which changes drafter acceptance; kernel time is not the cause).
Logs: docs/bench/head/.
