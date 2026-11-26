// Grid-wide barrier latency of a persistent ESIMD kernel (SAFE version: guaranteed termination).
//   * every leader has a TOTAL spin budget for the whole kernel (BUDGET polls, ~1 us each -> < 1 s worst case, below the 5 s xe job timeout);
//     once exhausted it sets err and stops waiting in all later barriers, so the kernel always finishes
//   * the host refuses configurations above half of the resident thread capacity (co-residency by construction)
// usage: gridbar NWG TPW NBAR     (TPW in {1, 4, 8}; NBAR <= 500)
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
#include <cstdlib>
using namespace sycl; using namespace sycl::ext::intel::esimd;
static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
constexpr uint32_t BUDGET = 500000;
template <int TPW>
double run(queue &q, uint32_t *cnt, uint32_t *err, int nwg, int nbar) {
  q.memset(cnt, 0, 64).wait(); q.memset(err, 0, 4).wait();
  double t0 = now();
  q.parallel_for(nd_range<1>((size_t)nwg * TPW, TPW), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    const int tid = (int)it.get_local_id(0);
    uint32_t left = BUDGET; bool failed = false;
    for (int b = 0; b < nbar; b++) {
      fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();
      barrier();
      if (tid == 0) {
        atomic_update<atomic_op::inc, uint32_t, 1>(cnt, simd<uint32_t, 1>(0));
        const uint32_t target = (uint32_t)(b + 1) * (uint32_t)nwg;
        while (!failed) {
          if (atomic_update<atomic_op::add, uint32_t, 1>(cnt, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0] >= target) break;
          if (--left == 0) { failed = true; atomic_update<atomic_op::inc, uint32_t, 1>(err, simd<uint32_t, 1>(0)); }
        }
      }
      barrier();
      fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();
    }
  }).wait();
  return (now() - t0) / nbar * 1e6;
}
int main(int argc, char **argv) {
  if (argc < 4) return 1;
  const int nwg = atoi(argv[1]), tpw = atoi(argv[2]), nbar = atoi(argv[3]);
  queue q{gpu_selector_v, property::queue::in_order{}};
  const int cus = (int)q.get_device().get_info<sycl::info::device::max_compute_units>();  // XVE count reported by the runtime
  const int cap = cus * 8 / 2;  // half of the 8 threads per XVE at 128 GRF
  if (nwg * tpw > cap || nbar > 500 || nbar < 1 || (tpw != 1 && tpw != 4 && tpw != 8)) { printf("refused: nwg*tpw %d > %d (or bad nbar/tpw)\n", nwg * tpw, cap); return 2; }
  uint32_t *cnt = malloc_device<uint32_t>(16, q), *err = malloc_device<uint32_t>(1, q);
  auto go = [&](int n) { return tpw == 1 ? run<1>(q, cnt, err, nwg, n) : tpw == 4 ? run<4>(q, cnt, err, nwg, n) : run<8>(q, cnt, err, nwg, n); };
  go(5);
  uint32_t e0 = 0; q.memcpy(&e0, err, 4).wait();
  double us = go(nbar); uint32_t e = 0; q.memcpy(&e, err, 4).wait();
  const double us1 = go(1);
  printf("NWG %4d TPW %d (cap %d): %.2f us per grid barrier (single-barrier launch %.1f us)  budget-exhausted leaders: warmup %u run %u\n", nwg, tpw, cap, us, us1, e0, e);
  return 0;
}
