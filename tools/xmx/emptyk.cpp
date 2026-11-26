// Fixed cost of a kernel launch on the in-order queue: GPU duration (profiling) and back-to-back throughput of an almost empty ESIMD kernel
// for several grid sizes. No inter-work-group waiting: always terminates.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <chrono>
#include <cstdio>
using namespace sycl; using namespace sycl::ext::intel::esimd;
int main() {
  queue q{gpu_selector_v, property_list{property::queue::in_order{}, property::queue::enable_profiling{}}};
  queue qn{q.get_context(), q.get_device(), property_list{property::queue::in_order{}}};
  float *y = malloc_device<float>(1 << 20, q);
  for (int nwg : {1, 16, 64, 256, 1152}) {
    auto k = [&](queue &qq) { return qq.parallel_for(nd_range<1>((size_t)nwg * 8, 8), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
      simd<float, 16> v = (float)it.get_global_id(0); if (it.get_local_id(0) == 0) v.copy_to(y + (it.get_group(0) % 4096) * 16); }); };
    for (int i = 0; i < 50; i++) k(q); q.wait();
    double dsum = 0; const int n = 400;
    for (int i = 0; i < n; i++) { auto e = k(q); e.wait(); dsum += (e.get_profiling_info<sycl::info::event_profiling::command_end>() - e.get_profiling_info<sycl::info::event_profiling::command_start>()) * 1e-3; }
    for (int i = 0; i < 50; i++) k(qn); qn.wait();
    auto t0 = std::chrono::steady_clock::now(); for (int i = 0; i < 2000; i++) k(qn); qn.wait();
    double per = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / 2000;
    printf("grid %4d x 8 threads: GPU duration %.2f us, back-to-back (no profiling) %.2f us per launch\n", nwg, dsum / n, per);
  }
  return 0;
}
