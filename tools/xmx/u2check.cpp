// Operand layout of the mixed-precision DPAS  u2 (B, weights planes) x s8 (A, activations)  on Xe2.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <cstdio>
#include <cstdlib>
using namespace sycl; using namespace sycl::ext::intel::esimd; namespace xmx = sycl::ext::intel::esimd::xmx; using AT = xmx::dpas_argument_type;
int main() {
  queue q{gpu_selector_v};
  const int RC = 4;
  int32_t *B = malloc_shared<int32_t>(32, q), *A = malloc_shared<int32_t>(8 * RC, q), *O = malloc_shared<int32_t>(16 * RC, q);
  srand(2);
  int bq[32][16]; int8_t av[RC][32];
  for (int i = 0; i < 32; i++) B[i] = 0;
  // hypothesis: B dword (kd * 16 + n), kd = 0..1, holds K = 16 kd .. 16 kd + 15 as 2-bit fields (field j = K 16 kd + j)
  for (int k = 0; k < 32; k++) for (int n = 0; n < 16; n++) { int v = rand() % 4; bq[k][n] = v; B[(k / 16) * 16 + n] |= (int32_t)((uint32_t)v << (2 * (k % 16))); }
  for (int m = 0; m < RC; m++) { for (int k = 0; k < 32; k++) av[m][k] = (int8_t)(rand() % 41 - 20); for (int d = 0; d < 8; d++) { uint32_t w = 0; for (int j = 0; j < 4; j++) w |= (uint32_t)(uint8_t)av[m][4 * d + j] << (8 * j); A[m * 8 + d] = (int32_t)w; } }
  q.parallel_for(nd_range<1>(1, 1), [=](nd_item<1>) SYCL_ESIMD_KERNEL {
    simd<int32_t, 32> b; b.copy_from(B);
    simd<int32_t, 8 * RC> a; a.copy_from(A);
    simd<int32_t, 16 * RC> acc = 0;
    acc = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::u2, AT::s8>(acc, b, a);
    acc.copy_to(O);
  }).wait();
  int bad = 0;
  for (int m = 0; m < RC; m++) for (int n = 0; n < 16; n++) { int ref = 0; for (int k = 0; k < 32; k++) ref += av[m][k] * bq[k][n]; if (ref != O[m * 16 + n]) bad++; }
  printf("u2(B, 32 dwords) x s8(A) K=32 layout: %d / %d mismatches\n", bad, RC * 16);
  if (bad) for (int n = 0; n < 4; n++) printf("  n=%d got %d\n", n, O[n]);
  return 0;
}
