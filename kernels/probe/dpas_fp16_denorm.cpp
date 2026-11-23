// Does DPAS fp16 x fp16 -> fp32 accept e2m1-as-fp16 weights (nibble payload at bits 11..9, sign at 15,
// i.e. value * 2^-14, subnormal for e=0)?  Expected: exact.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <cstdio>
#include <cmath>
using namespace sycl; using namespace sycl::ext::intel::esimd;
using PT = xmx::dpas_argument_type;
static float e2m1(int n){ static const float m[8]={0,.5f,1,1.5f,2,3,4,6}; return (n&8)? -m[n&7] : m[n&7]; }
static uint16_t f16bits(float f){ _Float16 h=(_Float16)f; uint16_t u; memcpy(&u,&h,2); return u; }
int main(){
  queue q{gpu_selector_v};
  uint32_t *w=malloc_shared<uint32_t>(8*16,q); uint32_t *a=malloc_shared<uint32_t>(8,q); float *o=malloc_shared<float>(16,q);
  int nib[16][16]; float x[16];
  for(int k=0;k<16;k++) x[k]=(k+1)*0.25f;
  for(int n=0;n<16;n++) for(int k=0;k<16;k++) nib[n][k]=(n*7+k*3+n/3)&15;
  auto enc=[&](int c)->uint16_t{ return (uint16_t)(((c&7)<<9)|((c&8)<<12)); };
  for(int r=0;r<8;r++) for(int n=0;n<16;n++) w[r*16+n]=enc(nib[n][2*r])|((uint32_t)enc(nib[n][2*r+1])<<16);
  for(int r=0;r<8;r++) a[r]=f16bits(x[2*r])|((uint32_t)f16bits(x[2*r+1])<<16);
  q.submit([&](handler&h){ h.parallel_for(nd_range<1>(1,1),[=](nd_item<1>) SYCL_ESIMD_KERNEL {
    simd<int32_t,128> wv; wv.copy_from((int32_t*)w);
    simd<int32_t,8> av; av.copy_from((int32_t*)a);
    simd<float,16> acc=0.f;
    acc=xmx::dpas<8,1,float,float,int32_t,int32_t,PT::fp16,PT::fp16>(acc,wv,av);
    acc.copy_to(o);
  });}).wait();
  int bad=0; for(int n=0;n<16;n++){ double e=0; for(int k=0;k<16;k++) e+=(double)e2m1(nib[n][k])*x[k]*std::ldexp(1.0,-14);
    double g=o[n]; if(std::fabs(g-e)>1e-6*std::fabs(e)+1e-12){bad++; printf("n=%d got %g expect %g\n",n,g,e);} }
  printf(bad? "DENORM/format FAIL (%d)\n":"fp16 e2m1-as-subnormal OK\n",bad);
}
