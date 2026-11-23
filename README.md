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
Not done: DSpark drafter, log-scaling > 8192 ctx, vision, MXFP8 experts via DPAS, FP8 dense weights.
