// SYCL command graph vs eager submission on the B60: N small dependent kernels, replayed.
#include <sycl/sycl.hpp>
#include <chrono>
#include <cstdio>
using namespace sycl;
namespace ex = sycl::ext::oneapi::experimental;
static double now() { return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
int main() {
  queue q{gpu_selector_v, property::queue::in_order{}};
  std::printf("device: %s | graph aspect: %d\n", q.get_device().get_info<info::device::name>().c_str(),
              (int)q.get_device().has(aspect::ext_oneapi_graph));
  float *a = malloc_device<float>(1 << 20, q);
  q.memset(a, 0, 4 << 20).wait();
  auto kern = [&](queue &qq, int i) {
    qq.parallel_for(nd_range<1>(4096, 128), [=](nd_item<1> it) { size_t k = it.get_global_id(0); a[k] = a[k] * 0.5f + (float)(i & 3); });
  };
  for (int N : {10, 100, 1000}) {
    for (int w = 0; w < 3; w++) { for (int i = 0; i < N; i++) kern(q, i); q.wait(); }
    int R = 200 / (N / 10 > 0 ? N / 10 : 1) + 5;
    double t0 = now();
    for (int r = 0; r < R; r++) { for (int i = 0; i < N; i++) kern(q, i); }
    double t_submit = now() - t0;
    q.wait();
    double t_eager = now() - t0;
    std::printf("N=%4d eager : submit %.1f us/graph, total %.1f us/graph (%.2f us/kernel)\n", N, t_submit / R, t_eager / R, t_eager / R / N);
    try {
      ex::command_graph<ex::graph_state::modifiable> g(q.get_context(), q.get_device());
      g.begin_recording(q);
      for (int i = 0; i < N; i++) kern(q, i);
      g.end_recording();
      auto ex_g = g.finalize();
      for (int w = 0; w < 3; w++) { q.ext_oneapi_graph(ex_g); q.wait(); }
      t0 = now();
      for (int r = 0; r < R; r++) q.ext_oneapi_graph(ex_g);
      double ts = now() - t0;
      q.wait();
      double tt = now() - t0;
      std::printf("N=%4d graph : submit %.1f us/graph, total %.1f us/graph (%.2f us/kernel)\n", N, ts / R, tt / R, tt / R / N);
    } catch (std::exception &e) { std::printf("N=%4d graph FAILED: %s\n", N, e.what()); }
  }
  return 0;
}
