// Native u4 x s8 DPAS projection (attention q/k/v/r/gate/wo path for T > 16): baseline kernel of the engine (w4n_r) vs a software-pipelined variant
//   * activations pre-tiled per (64-K group, RC-token tile): [a0: 8 RC dwords][a1: 8 RC dwords][scale, sum: 2 RC dwords] = three contiguous block loads per pass (baseline: 4 RC + 2 RC scalar loads)
//   * all groups / passes fully unrolled (PER = groups per thread is a compile-time constant), weight prefetch depth WD (groups) and activation prefetch depth AD (passes)
//   * per-group zero-point term folded:  acc += fa * (ws * as) - (zp * ws) * (as * sum)
// Weights are rotated over 24 copies so each launch streams from DRAM.  Usage: w4n_bench [rows K-unused T]
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <random>
using namespace sycl; using namespace sycl::ext::intel::esimd; namespace xmx = sycl::ext::intel::esimd::xmx; using AT = xmx::dpas_argument_type;
#ifndef KCONST
#define KCONST 2304
#endif
constexpr int K = KCONST, NGRP = K / 64;
static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }

template <int RC, int NP, int KSD>
void k_base(queue &q, int nrb, const uint32_t *W, const uint32_t *SZ, const int32_t *aq, const float *as, const int32_t *asum, float *Y, int rows) {
  q.parallel_for(nd_range<1>((size_t)nrb * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    slm_init<KSD * 16 * RC * NP * 4>();
    const int rb = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    const int per = NGRP / KSD, g0 = tid * per;
    const uint32_t *wp = W + ((size_t)rb * (K / 32) + (size_t)g0 * 2) * 64;
    const uint32_t *sp = SZ + ((size_t)rb * NGRP + g0) * 16;
    simd<float, 16 * RC> acc[NP];
#pragma unroll
    for (int p = 0; p < NP; p++) acc[p] = 0.f;
    simd<int32_t, 128> cur, nxt;
    cur.template select<64, 1>(0) = block_load<int32_t, 64>(reinterpret_cast<const int32_t *>(wp));
    cur.template select<64, 1>(64) = block_load<int32_t, 64>(reinterpret_cast<const int32_t *>(wp) + 64);
    simd<uint32_t, 16> scur = block_load<uint32_t, 16>(sp);
    for (int g = 0; g < per; g++) {
      simd<uint32_t, 16> snx;
      if (g + 1 < per) {
        nxt.template select<64, 1>(0) = block_load<int32_t, 64>(reinterpret_cast<const int32_t *>(wp) + (size_t)(g + 1) * 128);
        nxt.template select<64, 1>(64) = block_load<int32_t, 64>(reinterpret_cast<const int32_t *>(wp) + (size_t)(g + 1) * 128 + 64);
        snx = block_load<uint32_t, 16>(sp + (size_t)(g + 1) * 16);
      }
      const int gg = g0 + g;
      simd<uint16_t, 32> sv16 = scur.template bit_cast_view<uint16_t>();
      simd<sycl::half, 16> shs = sv16.template select<16, 2>(0).template bit_cast_view<sycl::half>();
      simd<sycl::half, 16> shz = sv16.template select<16, 2>(1).template bit_cast_view<sycl::half>();
      simd<float, 16> ws = shs, zp = shz; zp -= 1024.f;
      simd<int32_t, 64> b0 = cur.template select<64, 1>(0), b1 = cur.template select<64, 1>(64);
#pragma unroll
      for (int p = 0; p < NP; p++) {
        simd<int32_t, 8 * RC> a0, a1;
#pragma unroll
        for (int r = 0; r < RC; r++) {
          const int tr = p * RC + r;
          a0.template select<8, 1>(8 * r) = block_load<int32_t, 8>(aq + ((size_t)tr * NGRP + gg) * 16);
          a1.template select<8, 1>(8 * r) = block_load<int32_t, 8>(aq + ((size_t)tr * NGRP + gg) * 16 + 8);
        }
        simd<int32_t, 16 * RC> ia = 0;
        ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u4, AT::s8>(ia, b0, a0);
        ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u4, AT::s8>(ia, b1, a1);
        simd<float, 16 * RC> fa = convert<float>(ia);
#pragma unroll
        for (int r = 0; r < RC; r++) {
          const int tr = p * RC + r;
          const float asr = as[tr * NGRP + gg], sm = (float)asum[tr * NGRP + gg];
          acc[p].template select<16, 1>(16 * r) += (fa.template select<16, 1>(16 * r) - zp * sm) * ws * asr;
        }
      }
      if (g + 1 < per) { cur = nxt; scur = snx; }
    }
#pragma unroll
    for (int p = 0; p < NP; p++) slm_block_store<float, 16 * RC>((p * KSD + tid) * 16 * RC * 4, acc[p]);
    barrier();
    if (tid == 0) {
#pragma unroll
      for (int p = 0; p < NP; p++) {
        simd<float, 16 * RC> sum = slm_block_load<float, 16 * RC>(p * KSD * 16 * RC * 4);
        for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16 * RC>((p * KSD + j) * 16 * RC * 4);
#pragma unroll
        for (int r = 0; r < RC; r++) { simd<float, 16> o = sum.template select<16, 1>(16 * r); o.copy_to(Y + (size_t)(p * RC + r) * rows + rb * 16); }
      }
    }
  });
}

constexpr int TSZ(int RC) { return ((18 * RC + 15) / 16) * 16; }
template <int RC, int NP, int KSD, int WD, int AD, int GRF = 128>
void k_pipe(queue &q, int nrb, const uint32_t *W, const uint32_t *SZ, const int32_t *act, float *Y, int rows, int ntile) {
  constexpr int PER = NGRP / KSD, NS = PER * NP, TS = TSZ(RC);
  sycl::ext::oneapi::experimental::properties pr{sycl::ext::intel::experimental::grf_size<GRF>};
  q.parallel_for(nd_range<1>((size_t)nrb * KSD, KSD), pr, [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    slm_init<KSD * 16 * RC * NP * 4>();
    const int rb = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    const int g0 = tid * PER;
    const int32_t *wp = reinterpret_cast<const int32_t *>(W) + ((size_t)rb * (K / 32) + (size_t)g0 * 2) * 64;
    const uint32_t *sp = SZ + ((size_t)rb * NGRP + g0) * 16;
    const int32_t *ap = act + (size_t)g0 * ntile * TS;
    simd<int32_t, 128> wb[PER]; simd<uint32_t, 16> sb[PER];
    simd<int32_t, 8 * RC> a0[NS], a1[NS]; simd<int32_t, 2 * RC> sc[NS];
    simd<float, 16 * RC> acc[NP];
#pragma unroll
    for (int p = 0; p < NP; p++) acc[p] = 0.f;
#define LDW(g) { wb[g].template select<64, 1>(0) = block_load<int32_t, 64>(wp + (size_t)(g) * 128); wb[g].template select<64, 1>(64) = block_load<int32_t, 64>(wp + (size_t)(g) * 128 + 64); sb[g] = block_load<uint32_t, 16>(sp + (size_t)(g) * 16); }
#define LDA(s) { const int32_t *t_ = ap + ((size_t)((s) / NP) * ntile + ((s) % NP)) * TS; a0[s] = block_load<int32_t, 8 * RC>(t_); a1[s] = block_load<int32_t, 8 * RC>(t_ + 8 * RC); sc[s] = block_load<int32_t, 2 * RC>(t_ + 16 * RC); }
#pragma unroll
    for (int g = 0; g < WD && g < PER; g++) LDW(g);
#pragma unroll
    for (int s = 0; s < AD && s < NS; s++) LDA(s);
    simd<float, 16> ws, zw;
#pragma unroll
    for (int s = 0; s < NS; s++) {
      const int g = s / NP, p = s % NP;
      if (p == 0 && g + WD < PER) LDW(g + WD);
      if (s + AD < NS) LDA(s + AD);
      if (p == 0) {
        simd<uint16_t, 32> sv16 = sb[g].template bit_cast_view<uint16_t>();
        simd<sycl::half, 16> shs = sv16.template select<16, 2>(0).template bit_cast_view<sycl::half>();
        simd<sycl::half, 16> shz = sv16.template select<16, 2>(1).template bit_cast_view<sycl::half>();
        ws = shs; simd<float, 16> zp = shz; zp -= 1024.f; zw = zp * ws;
      }
      simd<int32_t, 16 * RC> ia = 0;
      simd<int32_t, 64> bw0 = wb[g].template select<64, 1>(0), bw1 = wb[g].template select<64, 1>(64);
      ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u4, AT::s8>(ia, bw0, a0[s]);
      ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u4, AT::s8>(ia, bw1, a1[s]);
      simd<float, 16 * RC> fa = convert<float>(ia);
      simd<float, 2 * RC> scf = sc[s].template bit_cast_view<float>();
#pragma unroll
      for (int r = 0; r < RC; r++) {
        const float asr = scf[2 * r], sm = (float)sc[s][2 * r + 1];
        simd<float, 16> f = fa.template select<16, 1>(16 * r);
        acc[p].template select<16, 1>(16 * r) += f * (ws * asr) - zw * (asr * sm);
      }
    }
#undef LDW
#undef LDA
#pragma unroll
    for (int p = 0; p < NP; p++) slm_block_store<float, 16 * RC>((p * KSD + tid) * 16 * RC * 4, acc[p]);
    barrier();
    if (tid == 0) {
#pragma unroll
      for (int p = 0; p < NP; p++) {
        simd<float, 16 * RC> sum = slm_block_load<float, 16 * RC>(p * KSD * 16 * RC * 4);
        for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16 * RC>((p * KSD + j) * 16 * RC * 4);
#pragma unroll
        for (int r = 0; r < RC; r++) { simd<float, 16> o = sum.template select<16, 1>(16 * r); o.copy_to(Y + (size_t)(p * RC + r) * rows + rb * 16); }
      }
    }
  });
}

int main(int argc, char **argv) {
  const int rows = argc > 1 ? atoi(argv[1]) : 3072, nrb = rows / 16, NCP = 24, iters = 200;
  queue q{gpu_selector_v, property::queue::in_order{}};
  std::mt19937 rng(5);
  const size_t wdw = (size_t)nrb * (K / 32) * 64, sdw = (size_t)nrb * NGRP * 16;
  std::vector<uint32_t> hw(wdw), hs(sdw);
  for (auto &v : hw) v = rng();
  for (auto &v : hs) { sycl::half s = (sycl::half)(0.01f + 0.0001f * (float)(rng() % 100)), z = (sycl::half)(1024.f + (float)(rng() % 16)); hs[&v - hs.data()] = (uint32_t)sycl::bit_cast<uint16_t>(s) | ((uint32_t)sycl::bit_cast<uint16_t>(z) << 16); }
  std::vector<uint32_t *> W(NCP), S(NCP);
  for (int i = 0; i < NCP; i++) { W[i] = malloc_device<uint32_t>(wdw, q); S[i] = malloc_device<uint32_t>(sdw, q); q.memcpy(W[i], hw.data(), wdw * 4); q.memcpy(S[i], hs.data(), sdw * 4); }
  q.wait();
  printf("rows %d K %d  weights %.1f MB/launch (+scales %.2f MB)\n", rows, K, wdw * 4 / 1e6, sdw * 4 / 1e6);
  const int Ts[] = {16, 32, 64};
  for (int T : Ts) {
    // activation data: int8 dwords, scale, sum
    std::vector<int32_t> aq((size_t)T * NGRP * 16); std::vector<float> as((size_t)T * NGRP); std::vector<int32_t> asum((size_t)T * NGRP);
    for (int t = 0; t < T; t++) for (int g = 0; g < NGRP; g++) {
      int sm = 0; for (int d = 0; d < 16; d++) { uint32_t w = 0; for (int b = 0; b < 4; b++) { int v = (int)(rng() % 255) - 127; sm += v; w |= (uint32_t)(uint8_t)(int8_t)v << (8 * b); } aq[((size_t)t * NGRP + g) * 16 + d] = (int32_t)w; }
      as[(size_t)t * NGRP + g] = 0.001f + 0.00001f * (rng() % 100); asum[(size_t)t * NGRP + g] = sm;
    }
    int32_t *daq = malloc_device<int32_t>(aq.size(), q), *dasum = malloc_device<int32_t>(asum.size(), q); float *das = malloc_device<float>(as.size(), q);
    q.memcpy(daq, aq.data(), aq.size() * 4); q.memcpy(das, as.data(), as.size() * 4); q.memcpy(dasum, asum.data(), asum.size() * 4);
    float *Y0 = malloc_shared<float>((size_t)T * rows, q), *Y1 = malloc_shared<float>((size_t)T * rows, q);
    auto timeit = [&](auto &&launch) { launch(0); q.wait(); double t0 = now(); for (int i = 0; i < iters; i++) launch(i % NCP); q.wait(); return (now() - t0) / iters * 1e6; };
    auto run_base = [&](int i) {
      if (T == 16) k_base<8, 2, 12>(q, nrb, W[i], S[i], daq, das, dasum, Y0, rows); else if (T == 32) k_base<8, 4, 12>(q, nrb, W[i], S[i], daq, das, dasum, Y0, rows); else k_base<8, 8, 12>(q, nrb, W[i], S[i], daq, das, dasum, Y0, rows);
    };
    double tb = timeit(run_base);
    const double bytes = (wdw + sdw) * 4.0;
    printf("T=%2d baseline KSD=12             %7.1f us  %6.1f GB/s\n", T, tb, bytes / tb / 1e3);
    // tiled activations for the pipelined kernel (RC = 8)
    constexpr int RC = 8, TS = TSZ(RC); const int ntile = T / RC;
    std::vector<int32_t> act((size_t)NGRP * ntile * TS, 0);
    for (int g = 0; g < NGRP; g++) for (int tp = 0; tp < ntile; tp++) { int32_t *d = &act[((size_t)g * ntile + tp) * TS];
      for (int r = 0; r < RC; r++) { int t = tp * RC + r; for (int k = 0; k < 8; k++) { d[8 * r + k] = aq[((size_t)t * NGRP + g) * 16 + k]; d[8 * RC + 8 * r + k] = aq[((size_t)t * NGRP + g) * 16 + 8 + k]; }
        float a = as[(size_t)t * NGRP + g]; memcpy(&d[16 * RC + 2 * r], &a, 4); d[16 * RC + 2 * r + 1] = asum[(size_t)t * NGRP + g]; } }
    int32_t *dact = malloc_device<int32_t>(act.size(), q); q.memcpy(dact, act.data(), act.size() * 4); q.wait();
    double ref_max = 0; for (size_t i = 0; i < (size_t)T * rows; i++) ref_max = std::max(ref_max, (double)std::fabs(Y0[i]));
    auto test = [&](const char *name, auto &&launch, double tbase) {
      for (size_t i = 0; i < (size_t)T * rows; i++) Y1[i] = 0; launch(0); q.wait();
      // correctness vs baseline (same weights copy 0)
      for (size_t i = 0; i < (size_t)T * rows; i++) Y0[i] = 0; run_base(0); q.wait();
      double me = 0; for (size_t i = 0; i < (size_t)T * rows; i++) me = std::max(me, (double)std::fabs(Y0[i] - Y1[i]));
      double t = timeit(launch);
      printf("T=%2d %-26s %7.1f us  %6.1f GB/s  (%+5.1f%%)  max|diff|/max %.1e\n", T, name, t, bytes / t / 1e3, (t / tbase - 1) * 100, me / (ref_max + 1e-30));
    };
#define PIPE(NPv, KSDv, WDv, ADv, G) \
    if (T == 8 * NPv) { char nm[64]; snprintf(nm, 64, "pipe KSD=%d WD=%d AD=%d GRF=%d", KSDv, WDv, ADv, G); \
      test(nm, [&](int i) { k_pipe<8, NPv, KSDv, WDv, ADv, G>(q, nrb, W[i], S[i], dact, Y1, rows, ntile); }, tb); }
#define SWEEP(NPv) \
    PIPE(NPv, 8, 1, 2, 256) PIPE(NPv, 8, 2, 2, 256) PIPE(NPv, 8, 2, 3, 256) PIPE(NPv, 6, 1, 2, 256) PIPE(NPv, 6, 2, 2, 256) \
    PIPE(NPv, 12, 2, 2, 256) PIPE(NPv, 12, 3, 4, 256) PIPE(NPv, 16, 2, 2, 256) PIPE(NPv, 16, 3, 4, 256) PIPE(NPv, 4, 2, 2, 256) PIPE(NPv, 4, 3, 3, 256) PIPE(NPv, 12, 1, 2, 256)
    SWEEP(2) SWEEP(4) SWEEP(8)
  }
  return 0;
}
