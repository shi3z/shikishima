// Operand-layout check of the mixed-precision DPAS  s4 (B, weights) x s8 (A, activations)  on Xe2: which K each dword/nibble/byte carries.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <cstdio>
#include <cstdlib>
using namespace sycl; using namespace sycl::ext::intel::esimd; namespace xmx = sycl::ext::intel::esimd::xmx; using AT = xmx::dpas_argument_type;
int main() {
  queue q{gpu_selector_v};
  const int RC = 4;
  int32_t *B = malloc_shared<int32_t>(64, q), *A = malloc_shared<int32_t>(8 * RC, q), *O = malloc_shared<int32_t>(16 * RC, q);
  srand(1);
  int bq[32][16]; int8_t av[RC][32];
  for (int i = 0; i < 64; i++) B[i] = 0;
  // hypothesis H1: B dword (kd * 16 + n) holds K = 8 kd .. 8 kd + 7 (nibble j = K 8 kd + j); A row m dword d holds K = 4 d .. 4 d + 3 (byte j)
  for (int k = 0; k < 32; k++) for (int n = 0; n < 16; n++) { int v = rand() % 16 - 8; bq[k][n] = v; B[(k / 8) * 16 + n] |= (int32_t)((uint32_t)(v & 15) << (4 * (k % 8))); }
  for (int m = 0; m < RC; m++) { for (int k = 0; k < 32; k++) av[m][k] = (int8_t)(rand() % 41 - 20); for (int d = 0; d < 8; d++) { uint32_t w = 0; for (int j = 0; j < 4; j++) w |= (uint32_t)(uint8_t)av[m][4 * d + j] << (8 * j); A[m * 8 + d] = (int32_t)w; } }
  q.parallel_for(nd_range<1>(1, 1), [=](nd_item<1>) SYCL_ESIMD_KERNEL {
    simd<int32_t, 64> b; b.copy_from(B);
    simd<int32_t, 8 * RC> a; a.copy_from(A);
    simd<int32_t, 16 * RC> acc = 0;
    acc = xmx::dpas<8, RC, int32_t, int32_t, int32_t, int32_t, AT::s4, AT::s8>(acc, b, a);
    acc.copy_to(O);
  }).wait();
  int bad = 0;
  for (int m = 0; m < RC; m++) for (int n = 0; n < 16; n++) { int ref = 0; for (int k = 0; k < 32; k++) ref += av[m][k] * bq[k][n]; if (ref != O[m * 16 + n]) bad++; }
  printf("s4(B) x s8(A) K=32 layout H1: %d / %d mismatches (signed nibble two's complement)\n", bad, RC * 16);
  if (bad) for (int m = 0; m < 1; m++) for (int n = 0; n < 4; n++) printf("  m=%d n=%d got %d\n", m, n, O[m * 16 + n]);
  return 0;
}
