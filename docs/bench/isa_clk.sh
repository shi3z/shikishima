#!/usr/bin/env bash
# Static ISA of one SYCL kernel without the GPU:  scripts/isa.sh <kernel-name-substring> [outdir]
# (bc -> sycl-post-link split per kernel -> llvm-spirv -> ocloc compile for bmg -> ocloc disasm)
set -euo pipefail
pat=$1; out=${2:-/tmp/xik_isa}; here=/home/shi3z/shikishima/xeinkling
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
L=/opt/intel/oneapi/compiler/latest/bin/compiler
rm -rf "$out"; mkdir -p "$out"; cd "$out"
icpx -fsycl -O2 -std=c++20 -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations -fsycl-targets=spir64 \
  -fsycl-device-code-split=per_kernel -save-temps -c "$here/kernels/xik.cpp" -o x.o >/dev/null 2>&1
$L/sycl-post-link -split=kernel -split-esimd -lower-esimd -O2 -symbols -o out.table xik-sycl-spir64-unknown-unknown.bc >/dev/null
for s in out_*.sym; do
  if c++filt < "$s" | grep -q -- "$pat"; then b=${s%.sym}; break; fi
done
$L/llvm-spirv -spirv-max-version=1.5 -spirv-allow-unknown-intrinsics=llvm.genx. -spirv-ext=-all,+SPV_KHR_no_integer_wrap_decoration,+SPV_KHR_bit_instructions,+SPV_INTEL_subgroups,+SPV_INTEL_vector_compute,+SPV_KHR_float_controls,+SPV_INTEL_fp_fast_math_mode,+SPV_KHR_expect_assume,+SPV_KHR_shader_clock "${b}.bc" -o k.spv
ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc -options '-vc-codegen' >/dev/null 2>&1 || ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc
mkdir -p dump; ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump >/dev/null 2>&1 || ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump
ls dump | head
