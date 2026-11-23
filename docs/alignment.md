# Memory alignment of the NVFP4 / MXFP8 expert streams (B60, measured)

Three different things; this note is only about the first:
1. **Memory address alignment of a load** relative to cache lines / 256 B regions (this note).
2. ESIMD `alignment<N>` promise on a block load (a correctness contract: the address must really be N-byte aligned).
3. DPAS operand GRF alignment (register file layout, set by the compiler; see docs/isa/nvfp4_R1_send_table.md).

## Real addresses (`xi-run <model> x 1 --layout`, all 24 layers, `docs/bench/alignment/lay_default.log`)
Every expert tensor base (208 of 208) is 4096-aligned (the driver returns 2 MiB-aligned blocks); activations and dense tiles are 256-aligned.
Enumerating every load address of one launch (all experts x row blocks x supertiles):

| stream | load | count (w13 / w2) | common alignment | notes |
|---|---|---|---|---|
| NVFP4 weights, tile bytes 0..255 | 256 B | 663,552 / 331,776 | 512 B | |
| NVFP4 weights, tile bytes 256..511 | 256 B | same | 256 B | |
| NVFP4 scales | 64 B | same | 64 B | one cache line each |
| x row stream | 128 B | 288 / 144 | 128 B | row pitch 4608 / 2304 B |
| MXFP8 weights (4 x 256 B per supertile) | 256 B | | 256..1024 B | |
| MXFP8 scales | 32 B | | 32 B | |
No load is split across a 64 B line; none is misaligned for `alignment<16>`.

## ISA (R=1 kernel, docs/isa/nvfp4_moe_fp4g_t_1_2_5_0_R1only.asm, table docs/isa/nvfp4_R1_send_table.md)
Per supertile 4 SENDs, each a single-lane block message, 1:1 with the source loads, no split / gather expansion:
`load.ugm.d32x64t.a64.st.uc` x2 (256 B each -> 4 GRFs, e.g. r111..r114 and r44..r47), `load.ugm.d32x16t.a64` (scale, 64 B -> 1 GRF),
`load.ugm.d32x32t.a64` (x, 128 B -> 2 GRFs r48..r49).  The A operand of DPAS is read straight from the x destination GRFs
(`dpas.8x1 r5:f null:f r7:hf r48.0:hf`, `.. r48.16`, `r49.0`, `r49.16`); B (r7/r11/r22, 8 GRFs each) is produced by the unpack ALU ops.
SBIDs $0..$15 are all in use (two buffers x 4 loads + DPAS results).  Scratch (`.ss`) accesses: 0 (the R=1 kernel; the old
multi-R kernel had 59).  `alignment<16>` is only promised for tensors proven 16 B aligned (checks added, see below).

## Effect of the base offset (XIK_WOFF), cold, GPU event time, 3 reps x 3 layers (`woff_prof.log`)
| offset | w13 T=1 | w13 T=8 | w2 T=1 | w2 T=8 | DRAM read / launch (VTune, w13 T=1) | LSC miss |
|---|---|---|---|---|---|---|
| 0 | 61.3 us | 415.9 | 31.5 | 206.6 | 21.9 MB | 27.3% |
| 64 | 165.5 | 1067.6 | 77.0 | 528.9 | 59.7 MB (2.7x) | 59.2% |
| 128 | 114.2 | 782.4 | 55.0 | 387.0 | 42.9 MB (2.0x) | 45.3% |
| 192 | 65.8 | 494.8 | 34.4 | 245.5 | 24.1 MB (1.1x) | 29.4% |
| 256 | 60.8 | 414.6 | 31.1 | 205.5 | 21.6 MB | 27.3% |
| aligned_alloc_device(4096), offset 0 | 61.3 | 416.0 | 31.5 | 206.6 | (same addresses as default) | |

VTune stall shares (w13 T=1): SBID 48.1 / 68.6 / 64.7 / 51.5 / 48.8 %, Send 35.8 / 42.7 / 42.0 / 35.1 / 36.0 % for offsets 0/64/128/192/256.
The slowdown is real extra DRAM traffic (the weights are loaded with L1 streaming + L2 uncached, so a second load touching the same
region is not served from L2), not an ISA change.  Offsets 0 and 256 are equal: 256 B alignment is what matters; 16 B alignment is not enough.

## What changed in the code
* `alloc_expert()` -> `aligned_alloc_device(4096)` (default; `XIK_ALLOC=plain` restores `malloc_device`).  Addresses and speed are unchanged today
  (output byte-identical, w13 61.4 us, w2 31.5 us); the 256 B base alignment is now guaranteed by the API instead of observed.
* `require_aligned()` checks: expert weights/scales and dense repacked tiles 256 B (unless XIK_WOFF is used), x16_in/x16_act 256 B, all stream
  bases 16 B (the `alignment<16>` promise); a violation throws instead of silently running.
* `XIK_WOFF` range check: multiple of 16 in [0, 4096] (8 and 5000 are rejected).
