// XMX (DPAS) micro-benchmark for Xe2 (Arc Pro B60): register-resident, SLM, L2-resident and DRAM-streamed B operand.
// Build: tools/xmx/build.sh ; run under the GPU lock.  Standalone (does not touch the engine library).
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <vector>
#include <string>
using namespace sycl;
using namespace sycl::ext::intel::esimd;
namespace xmx = sycl::ext::intel::esimd::xmx;
using AT = xmx::dpas_argument_type;

template <AT T> struct Info;  // acc type, elements per dword, name
template <> struct Info<AT::fp16> { using Acc = float; static constexpr int EPD = 2; static constexpr const char *n = "fp16"; };
template <> struct Info<AT::bf16> { using Acc = float; static constexpr int EPD = 2; static constexpr const char *n = "bf16"; };
template <> struct Info<AT::tf32> { using Acc = float; static constexpr int EPD = 1; static constexpr const char *n = "tf32"; };
template <> struct Info<AT::s8> { using Acc = int32_t; static constexpr int EPD = 4; static constexpr const char *n = "s8"; };
template <> struct Info<AT::s4> { using Acc = int32_t; static constexpr int EPD = 8; static constexpr const char *n = "s4"; };
template <> struct Info<AT::s2> { using Acc = int32_t; static constexpr int EPD = 16; static constexpr const char *n = "s2"; };
template <> struct Info<AT::hf8> { using Acc = float; static constexpr int EPD = 4; static constexpr const char *n = "hf8"; };
template <> struct Info<AT::bf8> { using Acc = float; static constexpr int EPD = 4; static constexpr const char *n = "bf8"; };

static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }

// mode 0: B in registers; 1: B from SLM; 2: B from a 4 MB global region shared by all threads (L2 resident); 3: B streamed from a large buffer (DRAM)
template <AT TY, int RC, int NACC, int MODE, AT TYA = TY, int BDW = 128>
double run(queue &q, int nthr, int iters, int32_t *buf, size_t bufdw, double &gbs) {
  using Acc = typename Info<TY>::Acc;
  int32_t *out = malloc_device<int32_t>(nthr * 16, q);
  auto kern = [&]() {
    q.submit([&](handler &h) {
      h.parallel_for(nd_range<1>(nthr, MODE == 1 ? 1 : 1), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
        const int tid = (int)it.get_global_id(0);
        if constexpr (MODE == 1) slm_init<NACC * 512>();
        simd<Acc, 16 * RC> acc[NACC];
        simd<int32_t, BDW> b[NACC];
        simd<int32_t, 8 * RC> a;
        for (int i = 0; i < 8 * RC; i++) a[i] = 0x3c003c00 ^ (i * 0x00010001) ^ tid;
        for (int k = 0; k < NACC; k++) {
          acc[k] = 0;
          for (int i = 0; i < BDW; i++) b[k][i] = 0x3c003c00 ^ (i * 0x01010101) ^ (k + tid);
          if constexpr (MODE == 1) slm_block_store<int32_t, BDW>(k * 512, b[k]);
        }
        const size_t span = MODE == 2 ? (1u << 20) : bufdw;  // dwords
        size_t off = ((size_t)tid * 128 * NACC) % (span - 128 * NACC);
        for (int i = 0; i < iters; i++) {
#pragma unroll
          for (int k = 0; k < NACC; k++) {
            if constexpr (MODE == 1) b[k] = slm_block_load<int32_t, BDW>(k * 512);
            if constexpr (MODE >= 2) {
              b[k].template select<64, 1>(0) = block_load<int32_t, 64>(buf + off + k * 128);
              if constexpr (BDW == 128) b[k].template select<64, 1>(64) = block_load<int32_t, 64>(buf + off + k * 128 + 64);
            }
            acc[k] = xmx::dpas<8, RC, Acc, Acc, int32_t, int32_t, TY, TYA>(acc[k], b[k], a);
          }
          if constexpr (MODE >= 2) { off += 128 * NACC * (MODE == 3 ? (size_t)nthr : 1); if (off + 128 * NACC >= span) off = (size_t)tid * 128 * NACC % (span - 128 * NACC); }
        }
        simd<Acc, 16> s = 0;
        for (int k = 0; k < NACC; k++) s += acc[k].template select<16, 1>(0);
        simd<int32_t, 16> si = s.template bit_cast_view<int32_t>();
        si.copy_to(out + tid * 16);
      });
    }).wait();
  };
  kern();
  double t0 = now(); kern(); double t = now() - t0;
  free(out, q);
  const double macs = (double)nthr * iters * NACC * (double)RC * 16 * 8 * Info<TYA>::EPD;
  gbs = (MODE == 0) ? 0.0 : (double)nthr * iters * NACC * (BDW * 4.0) / t / 1e9;
  return 2.0 * macs / t / 1e12;  // TOPS (2 ops per MAC)
}

template <AT TY, int RC, int NACC, int MODE, AT TYA = TY, int BDW = 128>
void one(queue &q, int nthr, int iters, int32_t *buf, size_t bufdw) {
  try {
    double gbs = 0;
    double tops = run<TY, RC, NACC, MODE, TYA, BDW>(q, nthr, iters, buf, bufdw, gbs);
    printf("%-4sx%-4s RC=%d NACC=%d mode=%d thr=%d : %8.2f TOPS  B-operand %8.1f GB/s\n", Info<TY>::n, Info<TYA>::n, RC, NACC, MODE, nthr, tops, gbs);
  } catch (std::exception &e) {
    printf("%-5s RC=%d NACC=%d mode=%d : FAILED (%s)\n", Info<TY>::n, RC, NACC, MODE, std::string(e.what()).substr(0, 80).c_str());
  }
  fflush(stdout);
}
#define SWEEP_NACC(TY, RC, MODE) one<TY, RC, 1, MODE>(q, nthr, iters, buf, bufdw); one<TY, RC, 2, MODE>(q, nthr, iters, buf, bufdw); one<TY, RC, 4, MODE>(q, nthr, iters, buf, bufdw); one<TY, RC, 8, MODE>(q, nthr, iters, buf, bufdw);
#define SWEEP_RC(TY, MODE) SWEEP_NACC(TY, 1, MODE) SWEEP_NACC(TY, 2, MODE) SWEEP_NACC(TY, 4, MODE) SWEEP_NACC(TY, 8, MODE)

int main(int argc, char **argv) {
  queue q{gpu_selector_v};
  printf("device: %s\n", q.get_device().get_info<sycl::info::device::name>().c_str());
  const int nthr = argc > 1 ? atoi(argv[1]) : 1280;
  const int iters = argc > 2 ? atoi(argv[2]) : 20000;
  const int mode = argc > 3 ? atoi(argv[3]) : 0;
  const char *only = argc > 4 ? argv[4] : "all";
  const size_t bufdw = (size_t)512 << 20;  // 2 GB of dwords
  int32_t *buf = malloc_device<int32_t>(bufdw, q);
  q.parallel_for(range<1>(bufdw), [=](id<1> i) { uint32_t x = (uint32_t)i[0] * 2654435761u; x ^= x >> 15; x *= 2246822519u; x ^= x >> 13; buf[i[0]] = (int32_t)x; }).wait();  // incompressible data (constant data is compressed and gives > peak DRAM bandwidth)
  auto want = [&](const char *n) { return !strcmp(only, "all") || !strcmp(only, n); };
  if (mode == 0) {
    if (want("fp16")) { SWEEP_RC(AT::fp16, 0) }
    if (want("bf16")) { one<AT::bf16, 8, 1, 0>(q, nthr, iters, buf, bufdw); one<AT::bf16, 8, 4, 0>(q, nthr, iters, buf, bufdw); one<AT::bf16, 8, 8, 0>(q, nthr, iters, buf, bufdw); }
    if (want("s8")) { one<AT::s8, 8, 1, 0>(q, nthr, iters, buf, bufdw); one<AT::s8, 8, 4, 0>(q, nthr, iters, buf, bufdw); one<AT::s8, 8, 8, 0>(q, nthr, iters, buf, bufdw); one<AT::s8, 1, 8, 0>(q, nthr, iters, buf, bufdw); }
    if (want("s4")) { one<AT::s4, 8, 1, 0>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 4, 0>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 8, 0>(q, nthr, iters, buf, bufdw); one<AT::s4, 1, 8, 0>(q, nthr, iters, buf, bufdw); }
    if (want("tf32")) { one<AT::tf32, 8, 8, 0>(q, nthr, iters, buf, bufdw); }
    if (want("hf8")) { one<AT::hf8, 8, 8, 0>(q, nthr, iters, buf, bufdw); }
    if (want("bf8")) { one<AT::bf8, 8, 8, 0>(q, nthr, iters, buf, bufdw); }
  } else if (mode == 4) {  // mixed precision: B (weights) s4 / s8, A (activations) s8 ; B-operand only 64 dwords for s4 x s8
    one<AT::s4, 8, 4, 0, AT::s8, 64>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 8, 0, AT::s8, 64>(q, nthr, iters, buf, bufdw); one<AT::s4, 4, 4, 0, AT::s8, 64>(q, nthr, iters, buf, bufdw); one<AT::s4, 1, 8, 0, AT::s8, 64>(q, nthr, iters, buf, bufdw);
    one<AT::s4, 8, 4, 3, AT::s8, 64>(q, nthr, iters / 10, buf, bufdw); one<AT::s4, 8, 4, 3, AT::s4, 128>(q, nthr, iters / 10, buf, bufdw);
    one<AT::s8, 8, 4, 0, AT::s8, 128>(q, nthr, iters, buf, bufdw);
  } else if (mode == 1) { SWEEP_RC(AT::fp16, 1) one<AT::s8, 8, 4, 1>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 4, 1>(q, nthr, iters, buf, bufdw);
  } else if (mode == 2) { SWEEP_RC(AT::fp16, 2) one<AT::s8, 8, 4, 2>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 4, 2>(q, nthr, iters, buf, bufdw);
  } else { SWEEP_RC(AT::fp16, 3) one<AT::s8, 8, 4, 3>(q, nthr, iters, buf, bufdw); one<AT::s4, 8, 4, 3>(q, nthr, iters, buf, bufdw); }
  return 0;
}
