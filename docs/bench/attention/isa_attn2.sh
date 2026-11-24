#!/usr/bin/env bash
here=/home/shi3z/shikishima/xeinkling; out=/data/inkling/isa_attn2
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
L=/opt/intel/oneapi/compiler/latest/bin/compiler
mkdir -p $out; cd $out
if [ ! -f out.table ]; then icpx -fsycl -O2 -std=c++20 -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations -fsycl-targets=spir64 -fsycl-device-code-split=per_kernel -save-temps -c $here/kernels/xik.cpp -o x.o >/dev/null 2>&1
$L/sycl-post-link -split=kernel -O2 -symbols -o out.table xik-sycl-spir64-unknown-unknown.bc >/dev/null; fi
for cfg in "4, 9, 0" "6, 9, 0" "8, 9, 0" "12, 9, 0" "0, -1, 0" "0, 4, 0" "0, 0, 0" "1, -1, 0" "1, 0, 0" "8, -1, 0" "8, 0, 0" "8, 4, 0" "12, -1, 0" "16, -1, 0" "32, -1, 0" "0, -1, 1" "0, -1, 2" "0, -1, 3" "1, -1, 1" "1, -1, 2" "8, 0, 1" "8, 0, 2" "8, 0, 3"; do
  tag=$(echo "$cfg" | tr -d ' ' | tr ',' '_' | tr '-' 'm')
  b=""; for s in out_*.sym; do if c++filt < $s | grep -q "typeinfo name for (anonymous namespace)::k_attn_w<$cfg>("; then b=${s%.sym}; break; fi; done
  [ -z "$b" ] && { echo "<$cfg> not found"; continue; }
  d=$out/c$tag; mkdir -p $d; cd $d
  $L/llvm-spirv -spirv-max-version=1.5 -spirv-ext=-all,+SPV_KHR_no_integer_wrap_decoration,+SPV_KHR_bit_instructions,+SPV_INTEL_subgroups,+SPV_INTEL_vector_compute,+SPV_KHR_float_controls,+SPV_INTEL_fp_fast_math_mode,+SPV_KHR_expect_assume $out/${b}.bc -o k.spv 2>&1 | tail -1
  ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc >/dev/null 2>&1
  mkdir -p dump; ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump >/dev/null 2>&1
  echo "<$cfg> -> c$tag"
  cd $out
done
echo ISADONE
