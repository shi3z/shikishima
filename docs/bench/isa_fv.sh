#!/usr/bin/env bash
set -u
here=/home/shi3z/shikishima/xeinkling; out=/data/inkling/isa_fv
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
L=/opt/intel/oneapi/compiler/latest/bin/compiler
mkdir -p $out; cd $out
if [ ! -f out.table ]; then icpx -fsycl -O2 -std=c++20 -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations -fsycl-targets=spir64 -fsycl-device-code-split=per_kernel -save-temps -c $here/kernels/xik.cpp -o x.o >/dev/null 2>&1
$L/sycl-post-link -split=kernel -split-esimd -lower-esimd -O2 -symbols -o out.table xik-sycl-spir64-unknown-unknown.bc >/dev/null; fi
for V in 0 1 2 3; do for N in 1 2 4 8; do
  b=""; for s in out_*.sym; do if c++filt < $s | grep -q "typeinfo name for fp4v_t<$V, $N>"; then b=${s%.sym}; break; fi; done
  [ -z "$b" ] && { echo "V$V N$N not found"; continue; }
  d=$out/v${V}n${N}; mkdir -p $d; cd $d
  f=/data/inkling/isa_fv/${b}.bc; [ -f $f ] || f=/data/inkling/isa_fv/${b}.esimd.bc
  $L/llvm-spirv -spirv-max-version=1.5 -spirv-allow-unknown-intrinsics=llvm.genx. -spirv-ext=-all,+SPV_KHR_no_integer_wrap_decoration,+SPV_KHR_bit_instructions,+SPV_INTEL_subgroups,+SPV_INTEL_vector_compute,+SPV_KHR_float_controls,+SPV_INTEL_fp_fast_math_mode,+SPV_KHR_expect_assume,+SPV_KHR_shader_clock $f -o k.spv
  ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc -options '-vc-codegen' >/dev/null 2>&1 || ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc >/dev/null 2>&1
  mkdir -p dump; ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump >/dev/null 2>&1
  a=$(ls dump/.text*asm 2>/dev/null | head -1)
  echo "V$V N$N: lines $(wc -l < $a) dpas $(grep -c ' dpas' $a) send $(grep -c ' send' $a) spill-ss $(grep -c '\.ss' $a) jmpi $(grep -c jmpi $a)"
  cd $out
done; done
echo ISADONE
