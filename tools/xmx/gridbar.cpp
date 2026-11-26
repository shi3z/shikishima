// SAFETY: every spin is bounded (200000 polls, then the work-group leaves the loop and counts an error at cnt[1000]); never remove the bound -
// an unbounded version of this file hung the host twice (2026-11-25/26).
// Grid-wide barrier latency of a persistent ESIMD kernel: NWG work-groups of TPW threads, N barriers back to back.
//   flat : every work-group leader increments one counter and spins on it
//   tree : leaders increment a per-cluster counter (CL work-groups), cluster leaders increment the root counter; release through a generation word
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
#include <cstdlib>
using namespace sycl; using namespace sycl::ext::intel::esimd;
static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
template <int TPW>
double run(queue &q, uint32_t *cnt, int nwg, int nbar, int mode) {
  q.memset(cnt, 0, 4096).wait();
  double t0 = now();
  q.parallel_for(nd_range<1>((size_t)nwg * TPW, TPW), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    const int tid = (int)it.get_local_id(0), wg = (int)it.get_group(0);
    for (int b = 0; b < nbar; b++) {
      // (abort is checked inside the bounded spin; after an abort every spin exits on its first check)
      fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();
      barrier();
      if (tid == 0) {
        const uint32_t target = (uint32_t)(b + 1) * nwg;
        if (mode == 0) {
          atomic_update<atomic_op::inc, uint32_t, 1>(cnt, simd<uint32_t, 1>(0));
          uint32_t sp = 0;
          while (sp < 200000u && atomic_update<atomic_op::add, uint32_t, 1>(cnt, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0] < target) {
            if ((sp & 1023u) == 0 && atomic_update<atomic_op::add, uint32_t, 1>(cnt + 1000, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0] != 0) break;  // global abort
            sp++;
          }
          if (sp >= 200000u) atomic_update<atomic_op::inc, uint32_t, 1>(cnt + 1000, simd<uint32_t, 1>(0));  // set abort, never leave the work-group barrier
        } else {
          // two level: 8 clusters; counters at cnt + 16 * (1 + cluster) (separate cache lines), root at cnt
          const int ncl = 8, per = (nwg + ncl - 1) / ncl, cl = wg / per, csz = (cl == ncl - 1) ? nwg - per * (ncl - 1) : per;
          uint32_t *cc = cnt + 16 * (1 + cl);
          const uint32_t old = atomic_update<atomic_op::add, uint32_t, 1>(cc, simd<uint32_t, 1>(0), simd<uint32_t, 1>(1))[0];
          if (old + 1 == (uint32_t)(b + 1) * csz) atomic_update<atomic_op::inc, uint32_t, 1>(cnt, simd<uint32_t, 1>(0));
          uint32_t sp = 0;
          while (sp < 200000u && atomic_update<atomic_op::add, uint32_t, 1>(cnt, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0] < (uint32_t)(b + 1) * ncl) {
            if ((sp & 1023u) == 0 && atomic_update<atomic_op::add, uint32_t, 1>(cnt + 1000, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0] != 0) break;
            sp++;
          }
          if (sp >= 200000u) atomic_update<atomic_op::inc, uint32_t, 1>(cnt + 1000, simd<uint32_t, 1>(0));
        }
      }
      barrier();
      fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();
    }
  }).wait();
  return (now() - t0) / nbar * 1e6;
}
int main(int argc, char **argv) {
  // gridbar NWG TPW MODE NBAR
  queue q{gpu_selector_v, property::queue::in_order{}};
  uint32_t *cnt = malloc_device<uint32_t>(2048, q);
  const int nwg = atoi(argv[1]), tpw = atoi(argv[2]), mode = atoi(argv[3]), nbar = atoi(argv[4]);
  auto go = [&](int n) { return tpw == 1 ? run<1>(q, cnt, nwg, n, mode) : tpw == 4 ? run<4>(q, cnt, nwg, n, mode) : tpw == 6 ? run<6>(q, cnt, nwg, n, mode) : run<8>(q, cnt, nwg, n, mode); };
  go(10);
  double us = go(nbar); uint32_t ab = 0; q.memcpy(&ab, cnt + 1000, 4).wait();
  printf("NWG %4d TPW %d %s: %.2f us per grid barrier%s\n", nwg, tpw, mode ? "tree" : "flat", us, ab ? "  (ABORTED: barrier not reached within the spin bound)" : "");
  return 0;
}
