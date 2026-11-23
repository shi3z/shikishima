# Where one token goes (Inkling-2-Mini, B60, BF16 standard mode)

Generated with `tools/bytes_report.py` (exact bytes) and `tools/time_table.py` (VTune gpu-hotspots, overview +
global-memory-accesses).  Plain decode, 47 steps, 20.79 ms GPU kernel time per token (wall 21.0 ms, 47.6 tok/s).

| category | ms/token | launches | logical MB | eff GB/s | floor ms @456 | excess ms |
|---|---|---|---|---|---|---|
| attention dense (q,k,v,r,gate,sink,o) | 7.00 | 123 | 2586 | 370 | 5.67 | 1.33 |
| experts NVFP4 | 5.47 | 90 | 1577 | 288 | 3.46 | 2.01 |
| output head | 2.13 | 1 | 926 | 435 | 2.03 | 0.10 |
| loop controllers | 1.72 | 172 | 113 | 66 | 0.25 | 1.47 |
| attention core | 1.14 | 147 | - | - | - | 1.14 |
| experts MXFP8 | 0.86 | 8 | 263 | 304 | 0.58 | 0.29 |
| MoE glue | 0.73 | 245 | - | - | - | 0.73 |
| norm / residual mix | 0.72 | 178 | - | - | - | 0.72 |
| router | 0.55 | 49 | 28 | 51 | 0.06 | 0.49 |
| short convs | 0.31 | 98 | - | - | - | 0.31 |
| total | 20.79 | 1111 | 5493 | 264 | 12.05 | 8.74 |

* spill 0 and GRF 128 in every kernel; XMX active 0.4-0.5 %; host->GPU 0.019 GB/s (no offload, no migration).
* 19.5 GiB allocated of 23.9 GiB; no duplicate weight buffers (raw tensors are freed after repacking).
* NVFP4 weights stay 4-bit in VRAM and are unpacked to fp16 in registers for DPAS (no fp4/s4 operand type is used).
  Re-quantising e2m1 to s4: 9.9 % RMS extra error (naive reinterpretation: 119 %) -> not done.
* Same bytes at 8 bit (MXFP8, 304 GB/s) and 4 bit (NVFP4, 288 GB/s) reach the same bandwidth: the limit is the thread's
  own load latency (VTune: SBID 50-57 %, Send 45-49 %, L3 stall 0.4 %), not unpack ALU work (INT8 DPAS experiment: -45 %
  instructions, +/-0 % speed).
* XeFlash Qwen3.8-27B (docs, not re-measured): 42.4 ms/pass for ~14 GB = ~330 GB/s sustained whole-model.
