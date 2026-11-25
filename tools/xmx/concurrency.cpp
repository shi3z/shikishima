// Do two SYCL queues (different in-order queues of one device) execute kernels concurrently on the B60?
// A: DRAM streaming read (uses all EUs), B: small latency-bound chain on a few EUs.  Time: A alone, B alone, A then B (one queue), A and B in two queues.
#include <sycl/sycl.hpp>
#include <chrono>
#include <cstdio>
using namespace sycl;
static double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
int main() {
  queue q1{gpu_selector_v, property::queue::in_order{}};
  queue q2{q1.get_context(), q1.get_device(), property::queue::in_order{}};
  const size_t n = (size_t)256 << 20;  // 1 GB of floats
  float *buf = malloc_device<float>(n, q1), *out = malloc_device<float>(1 << 16, q1);
  q1.parallel_for(range<1>(n), [=](id<1> i) { buf[i[0]] = (float)(i[0] & 1023); }).wait();
  auto A = [&](queue &q) { q.parallel_for(range<1>(1 << 20), [=](id<1> i) { float s = 0; for (size_t k = i[0]; k < n; k += 1 << 20) s += buf[k]; out[i[0] & 0xffff] = s; }); };
  auto B = [&](queue &q) { q.parallel_for(nd_range<1>(64, 64), [=](nd_item<1> it) { float x = it.get_global_id(0); for (int k = 0; k < 400000; k++) x = x * 0.999999f + 1.0f; out[it.get_global_id(0)] = x; }); };
  auto t = [&](auto f) { f(); q1.wait(); q2.wait(); double t0 = now(); f(); q1.wait(); q2.wait(); return (now() - t0) * 1e3; };
  double ta = t([&] { A(q1); }), tb = t([&] { B(q1); });
  double ts = t([&] { A(q1); B(q1); });
  double tc = t([&] { A(q1); B(q2); });
  printf("A (streaming, 1 GB) %.2f ms | B (64 threads latency chain) %.2f ms | A+B one queue %.2f ms | A||B two queues %.2f ms\n", ta, tb, ts, tc);
  return 0;
}
