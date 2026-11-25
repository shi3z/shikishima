// L0 harness for the engine kernel w4np_r<2304, NP, KSD, ...> (native u4 x s8 attention GEMM): runs a zebin (original or hand-patched ISA) on random data,
// prints the mean launch time over cold weight copies and a checksum / copy of the output so that two binaries can be compared bit by bit.
//   l0w4np file.zebin kernel_name NP KSD [dump_out.bin]
#include <level_zero/ze_api.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <random>
#include <vector>
#include <chrono>
#define CK(x) do { auto r_ = (x); if (r_) { printf("%s -> 0x%x\n", #x, (unsigned)r_); exit(1);} } while (0)
struct W4Seg { const uint32_t *W, *SZ; const float *X; float *Y; int rows, K, ldx, ldy, rnd, wg0; };
struct W4Aux { const int32_t *aq = nullptr; const float *as = nullptr; const int32_t *asum = nullptr; };
struct W4Args { W4Seg s[8]; int n = 0, total_wg = 0; };
struct W4AuxArr { W4Aux v[8]; };
static_assert(sizeof(W4Args) == 456 && sizeof(W4AuxArr) == 192, "layout");
int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb"); fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET); std::vector<unsigned char> bin(n); if (fread(bin.data(), 1, n, f) != (size_t)n) return 1; fclose(f);
  const int NP = atoi(argv[3]), KSD = atoi(argv[4]), K = 2304, rows = 3072, nrb = rows / 16, NGRP = K / 64, T = NP * 8, ntile = NP, TS = 144, NCP = 24;
  CK(zeInit(0)); uint32_t nd = 1; ze_driver_handle_t drv; CK(zeDriverGet(&nd, &drv));
  uint32_t ndev = 0; CK(zeDeviceGet(drv, &ndev, nullptr)); std::vector<ze_device_handle_t> devs(ndev); CK(zeDeviceGet(drv, &ndev, devs.data()));
  ze_device_handle_t dev = devs[getenv("DEV") ? atoi(getenv("DEV")) : 0];
  ze_context_desc_t cd = {ZE_STRUCTURE_TYPE_CONTEXT_DESC}; ze_context_handle_t ctx; CK(zeContextCreate(drv, &cd, &ctx));
  ze_module_desc_t md = {ZE_STRUCTURE_TYPE_MODULE_DESC}; md.format = ZE_MODULE_FORMAT_NATIVE; md.inputSize = n; md.pInputModule = bin.data();
  ze_module_handle_t mod; auto r = zeModuleCreate(ctx, dev, &md, &mod, nullptr); if (r) { printf("module create fail 0x%x\n", r); return 1; }
  ze_kernel_desc_t kd = {ZE_STRUCTURE_TYPE_KERNEL_DESC}; kd.pKernelName = argv[2]; ze_kernel_handle_t k; CK(zeKernelCreate(mod, &kd, &k));
  ze_device_mem_alloc_desc_t dd = {ZE_STRUCTURE_TYPE_DEVICE_MEM_ALLOC_DESC}; ze_host_mem_alloc_desc_t hd = {ZE_STRUCTURE_TYPE_HOST_MEM_ALLOC_DESC};
  auto dalloc = [&](size_t b) { void* p; CK(zeMemAllocShared(ctx, &dd, &hd, b, 64, dev, &p)); return p; };
  std::mt19937 rng(5);
  const size_t wdw = (size_t)nrb * (K / 32) * 64, sdw = (size_t)nrb * NGRP * 16;
  std::vector<uint32_t*> W(NCP), S(NCP);
  uint32_t* w0 = (uint32_t*)dalloc(wdw * 4); uint32_t* s0 = (uint32_t*)dalloc(sdw * 4);
  for (size_t i = 0; i < wdw; i++) w0[i] = rng();
  for (size_t i = 0; i < sdw; i++) { uint16_t sc = 0x2400 + (rng() % 0x100), zp = 0x6400 + (rng() % 16) * 0x0004; s0[i] = sc | ((uint32_t)zp << 16); }   // fp16 scale ~0.0x, zero 1024+small
  for (int i = 0; i < NCP; i++) { W[i] = i ? (uint32_t*)dalloc(wdw * 4) : w0; S[i] = i ? (uint32_t*)dalloc(sdw * 4) : s0; if (i) { memcpy(W[i], w0, wdw * 4); memcpy(S[i], s0, sdw * 4); } }
  size_t actdw = (size_t)NGRP * ntile * TS; int32_t* act = (int32_t*)dalloc(actdw * 4);
  for (size_t i = 0; i < actdw; i++) act[i] = rng();
  for (int g = 0; g < NGRP; g++) for (int tp = 0; tp < ntile; tp++) { int32_t* d = act + ((size_t)g * ntile + tp) * TS; for (int r = 0; r < 8; r++) { float a = 0.001f + 0.00001f * (rng() % 100); memcpy(&d[128 + 2 * r], &a, 4); d[128 + 2 * r + 1] = (int)(rng() % 400) - 200; } }
  const size_t YPAD = 1 << 22; float* Y = (float*)dalloc((size_t)T * rows * 4 + 2 * YPAD * 4); memset(Y, 0, (size_t)T * rows * 4 + 2 * YPAD * 4); float* Yb = Y; Y += YPAD;
  W4Args a; memset(&a, 0, sizeof(a)); W4AuxArr aux; memset(&aux, 0, sizeof(aux));
  a.n = 1; a.total_wg = nrb; a.s[0] = W4Seg{W[0], S[0], nullptr, Y, rows, K, 0, rows, 0, 0}; aux.v[0].aq = act;
  if (getenv("PRADDR")) printf("W %p..%p S %p..%p act %p..%p Y %p..%p\n", (void*)w0, (void*)(w0 + wdw), (void*)s0, (void*)(s0 + sdw), (void*)act, (void*)(act + actdw), (void*)Y, (void*)(Y + (size_t)T * rows));
  int t0 = 0, nt = T, nti = ntile;
  ze_command_queue_desc_t qd = {ZE_STRUCTURE_TYPE_COMMAND_QUEUE_DESC}; ze_command_list_handle_t cl; CK(zeCommandListCreateImmediate(ctx, dev, &qd, &cl));
  CK(zeKernelSetIndirectAccess(k, ZE_KERNEL_INDIRECT_ACCESS_FLAG_DEVICE | ZE_KERNEL_INDIRECT_ACCESS_FLAG_SHARED)); CK(zeKernelSetGroupSize(k, KSD, 1, 1)); ze_group_count_t g = {(uint32_t)nrb, 1, 1};
  ze_event_handle_t* evs = nullptr; ze_event_pool_handle_t pool; { ze_event_pool_desc_t pd = {ZE_STRUCTURE_TYPE_EVENT_POOL_DESC}; pd.flags = ZE_EVENT_POOL_FLAG_KERNEL_TIMESTAMP | ZE_EVENT_POOL_FLAG_HOST_VISIBLE; pd.count = 400; CK(zeEventPoolCreate(ctx, &pd, 1, &dev, &pool)); evs = new ze_event_handle_t[400]; for (int i = 0; i < 400; i++) { ze_event_desc_t ed = {ZE_STRUCTURE_TYPE_EVENT_DESC}; ed.index = i; ed.signal = ZE_EVENT_SCOPE_FLAG_HOST; ed.wait = ZE_EVENT_SCOPE_FLAG_HOST; CK(zeEventCreate(pool, &ed, &evs[i])); } }
  auto launch = [&](int i) { a.s[0].W = W[i % NCP]; a.s[0].SZ = S[i % NCP];
    CK(zeKernelSetArgumentValue(k, 0, sizeof(a), &a)); CK(zeKernelSetArgumentValue(k, 1, sizeof(aux), &aux)); CK(zeKernelSetArgumentValue(k, 2, 4, &nti)); CK(zeKernelSetArgumentValue(k, 3, 4, &t0)); CK(zeKernelSetArgumentValue(k, 4, 4, &nt));
    CK(zeCommandListAppendLaunchKernel(cl, k, &g, evs ? evs[i % 400] : nullptr, 0, nullptr)); };
  ze_event_handle_t* save = evs; evs = nullptr; launch(0); CK(zeCommandListHostSynchronize(cl, ~0ull)); evs = save;
  { size_t first=~0ull,last=0,cnt=0; for (size_t i = 0; i < (size_t)T * rows + 2 * YPAD; i++) if (Yb[i] != 0.f) { if (first==~0ull) first=i; last=i; cnt++; } printf("nonzero outputs: %zu, first %lld last %lld (valid region starts at %zu)\n", cnt, (long long)first, (long long)last, YPAD); }
  uint64_t cs = 0; for (size_t i = 0; i < (size_t)T * rows; i++) { uint32_t u; memcpy(&u, &Y[i], 4); cs = cs * 1000003 + u; }
  if (argc > 5) { FILE* o = fopen(argv[5], "wb"); fwrite(Y, 4, (size_t)T * rows, o); fclose(o); }
  const int iters = 400; auto t = std::chrono::steady_clock::now();
  for (int i = 0; i < iters; i++) launch(i);
  CK(zeCommandListHostSynchronize(cl, ~0ull));
  double us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t).count() / iters; double host_us = us;
  { ze_device_properties_t dp = {ZE_STRUCTURE_TYPE_DEVICE_PROPERTIES}; CK(zeDeviceGetProperties(dev, &dp)); double sum = 0; for (int i = 0; i < 400; i++) { ze_kernel_timestamp_result_t ts; CK(zeEventQueryKernelTimestamp(evs[i], &ts)); uint64_t d = (ts.global.kernelEnd - ts.global.kernelStart) & ((dp.kernelTimestampValidBits >= 64) ? ~0ull : ((1ull << dp.kernelTimestampValidBits) - 1)); sum += d * (double)dp.timerResolution * 1e-3; } us = sum / 400; }
  printf("host-side %.1f us/launch\n", host_us);
  double by = (wdw + sdw) * 4.0;
  printf("%s NP=%d KSD=%d: %.1f us  %.1f GB/s  checksum %016llx\n", "kernel", NP, KSD, us, by / us / 1e3, (unsigned long long)cs);
  return 0;
}
