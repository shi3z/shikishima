# XeInkling

Inference engine for Inkling-2-Mini(-Uncensored) (looped MoE, NVFP4/MXFP8 experts) on one
Intel Arc Pro B60. Rust host + SYCL/ESIMD kernels, following the XeFlash approach
(C ABI, `scripts/b60run` GPU lock). Apache-2.0 (LICENSE/NOTICE).

- `kernels/xik.cpp`   kernels + forward pass (`kernels/build.sh` -> `build/libxik.so`)
- `src/`              Rust: FFI, safetensors loader, engine wrapper, speculative loop (`spec.rs`)
- `src/bin/xi-run.rs` CLI: `xi-run <model_dir> <prompt|ids:1,2,3> <n> [--spec]`
- `tools/oracle.py`   CPU oracle (lazy dequant) for layer-by-layer parity; `ref/reference.py` torch reference
- `scripts/`          `b60run` (GPU lock), `vtune_run.sh` (gpu-hotspots), `isa.sh` (static ISA without GPU)

Run: `cargo build --release && scripts/b60run target/release/xi-run /data/inkling/model "text" 64`

Status (B60, greedy, batch 1):
- parity vs CPU oracle: logit corr 0.99995, same top-5 (5-token prompt)
- decode 45.6 tok/s (fused kernels, NVFP4 experts via fp16-DPAS with a repacked layout)
- speculative decode is lossless (identical output) with a prompt-lookup drafter: 77 tok/s on repetitive text
(Status lines above are the original exact-mode baseline; the approximate-mode results are below.)

Not done: DSpark drafter, log-scaling > 8192 ctx, vision, MXFP8 experts via DPAS, FP8 dense weights.

## Decode benchmarks (approximate modes, B60, greedy, T = 1)

All numbers are decode-only tok/s, median of 5 interleaved repeats per task, 6 tasks (code, history, prose, repeat, edit_py, jsonl), geo-mean over the tasks;
`XIK_DENSE_FP8=1 XIK_HEAD_FP8=1` (FP8 dense weights, int4 LM head) in every row. These modes requantise the checkpoint and are **not** lossless; every switch below is an environment variable
(details: `docs/mixed-quant.md`, `docs/head-int4.md`, `docs/hw-counters.md`).

| config | what changes | plain tok/s | Hybrid (prompt-lookup + drafter) tok/s | quality (KL nats/tok vs BF16-dense ref; GSM8K / MMLU / code exec) |
|---|---|---|---|---|
| exact baseline | NVFP4/MXFP8 experts, bf16 dense | 45.6 | 77 on repetitive text | lossless |
| K0 | FP8 dense + int4 head | 73.7 | 125.4 | 0.0048 / 85.0 / 85.8 / 100 |
| K1 | + attention q/k/r/gate int4 (`XIK_AW4`), W3 experts on 8 layers (`XIK_W3L=2,6-9,11,13-14`) | 79.6 | 138.9 | 86.7 / 84.2 / 100 (GSM8K / MMLU / code) |
| K3 | + all six attention matrices int4, W3 (INT3, group 64) on all NVFP4 layers 0-19 | **87.9** (88.6 on history/repeat prompts) | 150.0 | 86.7 / 83.3 / 93.8 |

Gains of the last optimisation round (K3 plain): early-issue loads of the W3 kernel +1.1 tok/s, tile-major weight layout (adjacent threads read adjacent addresses, `XIK_W3TM`) +1.4, MXFP8 layers in the same layout (`XIK_F8TM`) +0.3; layout changes are bit-identical.
Verification passes (`xi-run --bench-prefill`, K0 -> K3, ms per pass): T=1 13.0 -> 10.8, T=2 18.2 -> 15.5, T=4 23.2 -> 19.5, T=8 29.9 -> 26.9, T=16 47.8 -> 44.1.
Not reached yet: 100 tok/s plain (K3 is 11.3 ms/token; the remaining time is dominated by about 900 small latency-bound kernels per token, see `docs/mixed-quant.md` and `docs/hw-counters.md`).

Reproduce: `/data/inkling`-style 6 x 5 matrix = `xi-run <model> "<prompt>" 256 --bench 2 [--hybrid]` with `XIK_AW4="wq_du=0-23;wk_dv=0-23;wr_du=0-23;gate_attn=0-23;wv_dv=0-23;wo_ud=0-23" XIK_W3=1 XIK_W3L=0-19` for K3 (`XIK_ACT_STATS_FILE` for the activation-weighted int4 scale search).
