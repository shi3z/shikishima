#!/usr/bin/env bash
here=/home/shi3z/shikishima/xeinkling; out=/data/inkling/isa_attn
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
L=/opt/intel/oneapi/compiler/latest/bin/compiler
mkdir -p $out; cd $out
if [ ! -f out.table ]; then icpx -fsycl -O2 -std=c++20 -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations -fsycl-targets=spir64 -fsycl-device-code-split=per_kernel -save-temps -c $here/kernels/xik.cpp -o x.o >/dev/null 2>&1
$L/sycl-post-link -split=kernel -O2 -symbols -o out.table xik-sycl-spir64-unknown-unknown.bc >/dev/null; fi
for W in 0 1 8 32; do
  b=""; for s in out_*.sym; do if c++filt < $s | grep -q "typeinfo name for (anonymous namespace)::k_attn_w<$W>("; then b=${s%.sym}; break; fi; done
  [ -z "$b" ] && { echo "W$W not found"; continue; }
  d=$out/w$W; mkdir -p $d; cd $d
  $L/llvm-spirv -spirv-max-version=1.5 -spirv-ext=-all,+SPV_KHR_no_integer_wrap_decoration,+SPV_KHR_bit_instructions,+SPV_INTEL_subgroups,+SPV_INTEL_vector_compute,+SPV_KHR_float_controls,+SPV_INTEL_fp_fast_math_mode,+SPV_KHR_expect_assume $out/${b}.bc -o k.spv 2>&1 | tail -2
  ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc >/dev/null 2>&1
  mkdir -p dump; ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump >/dev/null 2>&1
  a=$(ls dump/.text*asm 2>/dev/null | head -1)
  echo "W$W: lines $(wc -l < $a) binary $(stat -c %s oc/k_bmg.bin) dpas $(grep -c ' dpas' $a) send $(grep -c ' send' $a) ss $(grep -c '\.ss' $a) jmpi $(grep -c jmpi $a) barrier $(grep -c barrier $a)"
  cd $out
done
echo ISADONE
