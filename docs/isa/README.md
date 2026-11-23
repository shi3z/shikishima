# Native ISA dumps (bmg, ocloc disasm of the SPIR-V-compiled kernels)
Produced with `scripts/isa.sh` style flow (see `/data/inkling/isa_clk.sh`, `isa_fv.sh`, `isa_attn.sh` copies in docs/bench).

| file | kernel | notes |
|---|---|---|
| nvfp4_moe_fp4g_t_1_2_5_0_production_diag.asm | moe_fp4g_t<1,2,5,0> (diagnostic-capable) | 4413 lines, 32 DPAS (R=1,2,4,8 bodies), 59 `.ss` scratch accesses, 38 inside the R=1 loop |
| nvfp4_moe_fp4g_t_1_2_5_0_lean_R1R248.asm | moe_fp4g_t<1,2,5,0,LEAN> | diagnostics compiled out, still R=1/2/4/8 bodies |
| nvfp4_micro_var{0..3}_NA1.asm | microbench A (DPAS only), B (+load), C (+unpack), D (+scale) | 8 DPAS per 2-supertile loop iteration, 8 sends, 0 spill |
| k_attn_w{0,1,8,32}.asm | attention kernel, V-prefetch width 0 (original), 1, 8, 32 | W8 V loop: 116 instr, 8 loads in flight; K loop fully unrolled (65 sends) |
