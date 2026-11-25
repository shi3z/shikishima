// Streaming W4 GEMM micro-benchmark (MoE-like shape: 8 experts x 2304 rows x K = 2304, 16-row block per hardware thread, T tokens):
//   native : weights stay int4 (s4 B operand, offline DPAS layout), activations int8 (per token and 64-K group scale), mixed-precision s4 x s8 DPAS, K = 32 per DPAS
//   expand : current engine approach: nibbles expanded to fp16 operands with ALU instructions, fp16 x fp16 DPAS (K = 16), fp16 activations
// Weights are cycled over 8 copies (170 MB) so every launch streams from DRAM.  Output is a checksum only; correctness of the native layout: w4a8_check.cpp.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
#include <cstdlib>
using namespace sycl; using namespace sycl::ext::intel::esimd; namespace xmx = sycl::ext::intel::esimd::xmx; using AT = xmx::dpas_argument_type;
static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
constexpr int NTH = 1152, K = 2304, NCH = K / 32, NG = K / 64;  // threads, K, 32-K chunks, 64-K groups

template <int T>
void k_native(queue &q, const int32_t *W, const sycl::half *S, const int32_t *A8, const float *AS, float *out) {
  constexpr int RC = T < 8 ? T : 8, NP = T / RC;
  q.parallel_for(range<1>(NTH), [=](id<1> id) SYCL_ESIMD_KERNEL {
    const int th = (int)id[0];
    simd<float, 16 * RC> facc[NP];
    for (int p = 0; p < NP; p++) facc[p] = 0.f;
    simd<int32_t, 64> bn[2];
    bn[0] = block_load<int32_t, 64>(W + ((size_t)0 * NTH + th) * 64);
    bn[1] = block_load<int32_t, 64>(W + ((size_t)1 * NTH + th) * 64);
    for (int g = 0; g < NG; g++) {
      simd<int32_t, 64> b0 = bn[0], b1 = bn[1];
      if (g + 1 < NG) {
        bn[0] = block_load<int32_t, 64>(W + ((size_t)(2 * g + 2) * NTH + th) * 64);
        bn[1] = block_load<int32_t, 64>(W + ((size_t)(2 * g + 3) * NTH + th) * 64);
      }
      simd<sycl::half, 16> sh = block_load<sycl::half, 16>(S + ((size_t)g * NTH + th) * 16);
      simd<float, 16> ws = sh;
#pragma unroll
      for (int p = 0; p < NP; p++) {
        simd<int32_t, 8 * RC> a0, a1;
#pragma unroll
        for (int r = 0; r < RC; r++) {
          a0.template select<8, 1>(8 * r) = block_load<int32_t, 8>(A8 + (size_t)(p * RC + r) * (K / 4) + (2 * g) * 8);
          a1.template select<8, 1>(8 * r) = block_load<int32_t, 8>(A8 + (size_t)(p * RC + r) * (K / 4) + (2 * g + 1) * 8);
        }
        simd<int32_t, 16 * RC> ia = 0;
        ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::s4, AT::s8>(ia, b0, a0);
        ia = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::s4, AT::s8>(ia, b1, a1);
        simd<float, 16 * RC> fa = convert<float>(ia);
#pragma unroll
        for (int r = 0; r < RC; r++) facc[p].template select<16, 1>(16 * r) += fa.template select<16, 1>(16 * r) * (ws * AS[(size_t)(p * RC + r) * NG + g]);
      }
    }
    simd<float, 16> s = 0;
    for (int p = 0; p < NP; p++) s += facc[p].template select<16, 1>(0);
    s.copy_to(out + th * 16);
  });
}

// current approach: tile = 16 rows x 32 K = 64 dwords [q][n] (8 nibbles per dword, pair order as in w4z); two tiles per 64-K group give four 16-K fp16 DPAS
template <int T>
void k_expand(queue &q, const uint32_t *W, const sycl::half *S, const sycl::half *AH, float *out) {
  constexpr int RC = T < 8 ? T : 8, NP = T / RC;
  q.parallel_for(range<1>(NTH), [=](id<1> id) SYCL_ESIMD_KERNEL {
    const int th = (int)id[0];
    simd<float, 16 * RC> facc[NP];
    for (int p = 0; p < NP; p++) facc[p] = 0.f;
    simd<uint32_t, 128> cur, nxt;
    cur.template select<64, 1>(0) = block_load<uint32_t, 64>(W + ((size_t)0 * NTH + th) * 64);
    cur.template select<64, 1>(64) = block_load<uint32_t, 64>(W + ((size_t)1 * NTH + th) * 64);
    for (int g = 0; g < NG; g++) {
      if (g + 1 < NG) {
        nxt.template select<64, 1>(0) = block_load<uint32_t, 64>(W + ((size_t)(2 * g + 2) * NTH + th) * 64);
        nxt.template select<64, 1>(64) = block_load<uint32_t, 64>(W + ((size_t)(2 * g + 3) * NTH + th) * 64);
      }
      simd<sycl::half, 16> sh = block_load<sycl::half, 16>(S + ((size_t)g * NTH + th) * 16);
      simd<float, 16> ws = sh;
      simd<float, 16 * RC> ag[NP];
#pragma unroll
      for (int t = 0; t < 4; t++) {
        simd<uint32_t, 128> B;
#pragma unroll
        for (int h = 0; h < 2; h++) {
          simd<uint32_t, 16> x = cur.template select<16, 1>(64 * (t / 2) + 16 * (2 * (t % 2) + h));
#pragma unroll
          for (int pp = 0; pp < 4; pp++) { simd<uint32_t, 16> v = (pp == 0 ? x : (x >> (4 * pp))) & 0x000F000Fu; B.template select<16, 1>(16 * (4 * h + pp)) = v | 0x64006400u; }
        }
        simd<sycl::half, 256> bh = B.template bit_cast_view<sycl::half>();
        bh -= (sycl::half)1032.0f;
        simd<int32_t, 128> bi = bh.template bit_cast_view<int32_t>();
#pragma unroll
        for (int p = 0; p < NP; p++) {
          simd<int32_t, 8 * RC> av;
#pragma unroll
          for (int r = 0; r < RC; r++) av.template select<8, 1>(8 * r) = block_load<int32_t, 8>(reinterpret_cast<const int32_t *>(AH) + (size_t)(p * RC + r) * (K / 2) + (g * 4 + t) * 8);
          simd<float, 16 * RC> z = 0.f;
          ag[p] = xmx::dpas<8, RC, float, float, int32_t, int32_t, AT::fp16, AT::fp16>(t == 0 ? z : ag[p], bi, av);
        }
      }
#pragma unroll
      for (int p = 0; p < NP; p++)
#pragma unroll
        for (int r = 0; r < RC; r++) facc[p].template select<16, 1>(16 * r) += ag[p].template select<16, 1>(16 * r) * ws;
      if (g + 1 < NG) cur = nxt;
    }
    simd<float, 16> s = 0;
    for (int p = 0; p < NP; p++) s += facc[p].template select<16, 1>(0);
    s.copy_to(out + th * 16);
  });
}


// 3-bit codes as a u2 plane pair + a bit plane, consumed by native u2 x s8 DPAS without any weight expansion (3 dwords per lane and 32-K chunk = 3 bits per weight):
//   dwords 0..1: bits 0..1 of the 32 codes (u2 B operand, field j of dword kd = K 16 kd + j);  dword 2: bit 2 of weights K 0..15 at the even bit positions and of K 16..31 at the odd ones
//   -> plane 3 operand = { Z & 0x55555555, (Z >> 1) & 0x55555555 }  (3 ALU instructions per chunk and lane);  code = plane12 + 4 plane3, weight = code - 4
template <int T>
void k_planar(queue &q, const int32_t *W, const sycl::half *S, const int32_t *A8, const float *AS, float *out) {
  constexpr int RC = T < 8 ? T : 8, NP = T / RC;
  q.parallel_for(range<1>(NTH), [=](id<1> id) SYCL_ESIMD_KERNEL {
    const int th = (int)id[0];
    simd<float, 16 * RC> facc[NP];
    for (int p = 0; p < NP; p++) facc[p] = 0.f;
    for (int g = 0; g < NG; g++) {
      simd<int32_t, 32> p0 = block_load<int32_t, 32>(W + (((size_t)(2 * g) * NTH + th) * 48));
      simd<int32_t, 16> z0 = block_load<int32_t, 16>(W + (((size_t)(2 * g) * NTH + th) * 48) + 32);
      simd<int32_t, 32> p1 = block_load<int32_t, 32>(W + (((size_t)(2 * g + 1) * NTH + th) * 48));
      simd<int32_t, 16> z1 = block_load<int32_t, 16>(W + (((size_t)(2 * g + 1) * NTH + th) * 48) + 32);
      simd<sycl::half, 16> sh = block_load<sycl::half, 16>(S + ((size_t)g * NTH + th) * 16);
      simd<float, 16> ws = sh;
      simd<int32_t, 32> q0, q1;
      q0.template select<16, 1>(0) = z0 & 0x55555555; q0.template select<16, 1>(16) = (z0 >> 1) & 0x55555555;
      q1.template select<16, 1>(0) = z1 & 0x55555555; q1.template select<16, 1>(16) = (z1 >> 1) & 0x55555555;
#pragma unroll
      for (int p = 0; p < NP; p++) {
        simd<int32_t, 8 * RC> a0, a1;
#pragma unroll
        for (int r = 0; r < RC; r++) {
          a0.template select<8, 1>(8 * r) = block_load<int32_t, 8>(A8 + (size_t)(p * RC + r) * (K / 4) + (2 * g) * 8);
          a1.template select<8, 1>(8 * r) = block_load<int32_t, 8>(A8 + (size_t)(p * RC + r) * (K / 4) + (2 * g + 1) * 8);
        }
        simd<int32_t, 16 * RC> i12 = 0, i3 = 0;
        i12 = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u2, AT::s8>(i12, p0, a0);
        i3 = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u2, AT::s8>(i3, q0, a0);
        i12 = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u2, AT::s8>(i12, p1, a1);
        i3 = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u2, AT::s8>(i3, q1, a1);
        simd<int32_t, 16 * RC> tot = i12 + (i3 << 2);  // code * activation sum; the centring (- 4 * sum of activations) is applied with the scales in the real kernel
        simd<float, 16 * RC> fa = convert<float>(tot);
#pragma unroll
        for (int r = 0; r < RC; r++) facc[p].template select<16, 1>(16 * r) += fa.template select<16, 1>(16 * r) * (ws * AS[(size_t)(p * RC + r) * NG + g]);
      }
    }
    simd<float, 16> s = 0;
    for (int p = 0; p < NP; p++) s += facc[p].template select<16, 1>(0);
    s.copy_to(out + th * 16);
  });
}
int main(int argc, char **argv) {
  queue q{gpu_selector_v};
  const int ncopy = 8, iters = argc > 1 ? atoi(argv[1]) : 60;
  const size_t wdw = (size_t)NCH * NTH * 64, sh = (size_t)NG * NTH * 16;  // 64 dwords per thread and chunk (4-bit); the planar 3-bit format uses the first 48
  int32_t *W = malloc_device<int32_t>(wdw * ncopy, q);
  sycl::half *S = malloc_device<sycl::half>(sh * ncopy, q);
  int32_t *A8 = malloc_device<int32_t>((size_t)64 * K / 4, q);
  sycl::half *AH = malloc_device<sycl::half>((size_t)64 * K, q);
  float *AS = malloc_device<float>(64 * NG, q), *out = malloc_device<float>(NTH * 16, q);
  q.parallel_for(range<1>(wdw * ncopy), [=](id<1> i) { uint32_t x = (uint32_t)i[0] * 2654435761u; x ^= x >> 15; x *= 2246822519u; x ^= x >> 13; W[i[0]] = (int32_t)x; }).wait();
  q.parallel_for(range<1>(sh * ncopy), [=](id<1> i) { S[i[0]] = (sycl::half)(0.001f * (1 + (i[0] % 7))); }).wait();
  q.parallel_for(range<1>((size_t)64 * K / 4), [=](id<1> i) { A8[i[0]] = (int32_t)(0x01020304u * (1 + i[0] % 5)); }).wait();
  q.parallel_for(range<1>((size_t)64 * K), [=](id<1> i) { AH[i[0]] = (sycl::half)(0.01f * (1 + i[0] % 9)); }).wait();
  q.parallel_for(range<1>(64 * NG), [=](id<1> i) { AS[i[0]] = 0.01f; }).wait();
  const double wbytes = (double)wdw * 4 + (double)sh * 2, wbytes3 = (double)NCH * NTH * 48 * 4 + (double)sh * 2;
  printf("weights per call: %.1f MB (4-bit + fp16 scale per 64 K), 1152 threads, K=%d, T tokens; roofline at 456 GB/s = %.1f us\n", wbytes / 1e6, K, wbytes / 456e9 * 1e6);
  auto bench = [&](const char *name, auto launch, int T) {
    for (int w = 0; w < 4; w++) { launch(w % ncopy); q.wait(); }
    double t0 = now();
    for (int i = 0; i < iters; i++) launch(i % ncopy);
    q.wait();
    double us = (now() - t0) / iters * 1e6;
    const double ops = 2.0 * T * 1152 * 16 * K;
    const double wb = name[0] == 'p' ? wbytes3 : wbytes; printf("T=%2d %-7s %7.1f us  %6.1f GB/s  %6.2f TOPS\n", T, name, us, wb / us / 1e3, ops / us / 1e6);
    fflush(stdout);
  };
#define RUN(TT) \
  bench("native", [&](int c) { k_native<TT>(q, W + wdw * c, S + sh * c, A8, AS, out); }, TT); \
  bench("expand", [&](int c) { k_expand<TT>(q, (const uint32_t *)(W + wdw * c), S + sh * c, AH, out); }, TT); \
  bench("planar3", [&](int c) { k_planar<TT>(q, W + wdw * c, S + sh * c, A8, AS, out); }, TT);
  RUN(1) RUN(2) RUN(4) RUN(8) RUN(16) RUN(32) RUN(64)
  return 0;
}
