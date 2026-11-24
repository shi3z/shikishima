#!/usr/bin/env bash
# ISA of the hot kernels (default build): call/spill/instruction audit
here=/home/shi3z/shikishima/xeinkling; out=/data/inkling/isa_all
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
L=/opt/intel/oneapi/compiler/latest/bin/compiler
mkdir -p $out; cd $out
if [ ! -f out.table ]; then
icpx -fsycl -O2 -std=c++20 -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations -fsycl-targets=spir64 -fsycl-device-code-split=per_kernel -save-temps -c $here/kernels/xik.cpp -o x.o >/dev/null 2>&1
$L/sycl-post-link -split=kernel -split-esimd -lower-esimd -O2 -symbols -o out.table xik-sycl-spir64-unknown-unknown.bc >/dev/null
fi
i=0
for s in out_*.sym; do
  nm=$(c++filt < $s | head -1)
  case "$nm" in *dgemm_t*|*moe_fp8g_t*|*gemv_bf16_t*|*k_blend_t*|*k_mix_t*|*k_conv*|*k_wnorm_t*|*k_pairnorm_t*|*k_router*|*k_group*|*k_act*|*k_moe_combine*|*k_cvt_f16*|*k_kv*|*k_qr_clip*|*moe_fp4g_t\<1,\ 2,\ 5,\ 0,\ true,\ true*) ;; *) continue;; esac
  b=${s%.sym}; f=$out/$b.bc; [ -f $f ] || f=$out/$b.esimd.bc; [ -f $f ] || continue
  d=$out/k_$b; mkdir -p $d; cd $d
  $L/llvm-spirv -spirv-max-version=1.5 -spirv-allow-unknown-intrinsics=llvm.genx. -spirv-ext=-all,+SPV_KHR_no_integer_wrap_decoration,+SPV_KHR_bit_instructions,+SPV_INTEL_subgroups,+SPV_INTEL_vector_compute,+SPV_KHR_float_controls,+SPV_INTEL_fp_fast_math_mode,+SPV_KHR_expect_assume,+SPV_KHR_shader_clock $f -o k.spv >/dev/null 2>&1
  ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc -options '-vc-codegen' >/dev/null 2>&1 || ocloc compile -spirv_input -file k.spv -device bmg -out_dir oc >/dev/null 2>&1
  mkdir -p dump; ocloc disasm -file oc/k_bmg.bin -device bmg -dump dump >/dev/null 2>&1
  a=$(ls dump/.text*asm 2>/dev/null | head -1)
  if [ -n "$a" ]; then
    echo "$(echo "$nm" | sed -E 's/typeinfo name for //; s/\(anonymous namespace\):://; s/\(xik_ctx.*//; s/\(sycl.*//; s/\(void.*//' | cut -c1-70) | lines $(wc -l < $a) | calls $(grep -c -E ' call | calla ' $a) | send $(grep -c ' send' $a) | spill.ss $(grep -c '\.ss' $a) | dpas $(grep -c ' dpas' $a) | grf $(grep -m1 grf_count dump/.ze_info | awk '{print $2}')"
  fi
  cd $out
done
echo ISAALLDONE
