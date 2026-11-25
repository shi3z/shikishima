// Minimal Level Zero launcher for a native zebin: l0run file.zebin kernel N   (kernel(int* a), a[i] initialised to i)
#include <level_zero/ze_api.h>
#include <cstdio>
#include <cstdlib>
#include <vector>
#define CK(x) do { auto r_ = (x); if (r_) { printf("%s -> 0x%x\n", #x, (unsigned)r_); exit(1);} } while (0)
int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb"); fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET); std::vector<unsigned char> bin(n); fread(bin.data(), 1, n, f); fclose(f);
  int N = atoi(argv[3]);
  CK(zeInit(0)); uint32_t nd = 1; ze_driver_handle_t drv; CK(zeDriverGet(&nd, &drv));
  uint32_t ndev = 0; CK(zeDeviceGet(drv, &ndev, nullptr)); std::vector<ze_device_handle_t> devs(ndev); CK(zeDeviceGet(drv, &ndev, devs.data()));
  ze_device_handle_t dev = devs[0];
  ze_context_desc_t cd = {ZE_STRUCTURE_TYPE_CONTEXT_DESC}; ze_context_handle_t ctx; CK(zeContextCreate(drv, &cd, &ctx));
  ze_module_desc_t md = {ZE_STRUCTURE_TYPE_MODULE_DESC}; md.format = ZE_MODULE_FORMAT_NATIVE; md.inputSize = n; md.pInputModule = bin.data();
  ze_module_handle_t mod; ze_module_build_log_handle_t log; auto r = zeModuleCreate(ctx, dev, &md, &mod, &log);
  if (r) { size_t sz = 0; zeModuleBuildLogGetString(log, &sz, nullptr); std::vector<char> s(sz + 1); zeModuleBuildLogGetString(log, &sz, s.data()); printf("module create fail 0x%x: %s\n", r, s.data()); return 1; }
  ze_kernel_desc_t kd = {ZE_STRUCTURE_TYPE_KERNEL_DESC}; kd.pKernelName = argv[2]; ze_kernel_handle_t k; CK(zeKernelCreate(mod, &kd, &k));
  ze_device_mem_alloc_desc_t dd = {ZE_STRUCTURE_TYPE_DEVICE_MEM_ALLOC_DESC}; ze_host_mem_alloc_desc_t hd = {ZE_STRUCTURE_TYPE_HOST_MEM_ALLOC_DESC};
  int* a; CK(zeMemAllocShared(ctx, &dd, &hd, N * 4, 64, dev, (void**)&a)); for (int i = 0; i < N; i++) a[i] = i;
  CK(zeKernelSetArgumentValue(k, 0, sizeof(a), &a)); CK(zeKernelSetGroupSize(k, 32, 1, 1));
  ze_command_queue_desc_t qd = {ZE_STRUCTURE_TYPE_COMMAND_QUEUE_DESC}; ze_command_list_handle_t cl; CK(zeCommandListCreateImmediate(ctx, dev, &qd, &cl));
  ze_group_count_t g = {(uint32_t)(N / 32), 1, 1}; CK(zeCommandListAppendLaunchKernel(cl, k, &g, nullptr, 0, nullptr)); CK(zeCommandListHostSynchronize(cl, ~0ull));
  printf("a[0..3] = %d %d %d %d, a[N-1]=%d\n", a[0], a[1], a[2], a[3], a[N - 1]); return 0;
}
