// xik.cpp — XeInkling: Inkling-2-Mini inference kernels for the Intel Arc Pro B60.
//
// Semantics follow the validated pure-torch reference (ref/reference.py):
// every place where the reference rounds to bf16 is rounded here too, so the
// engine can be compared against it layer by layer.
//
// All activations are fp32 buffers; "bf16-valued" means the value was rounded
// to bf16 precision (rbf) exactly where the reference casts to bfloat16.
#include <sycl/sycl.hpp>
#include <sycl/ext/intel/esimd.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <chrono>
#include <array>
#include <map>
#include <memory>
#include <string>
#include <vector>
#include <random>
#include <sycl/ext/intel/math.hpp>
#include "xik.h"

using namespace sycl;
namespace es = sycl::ext::intel::esimd;

namespace {

// In-order queue wrapper: optionally keeps every kernel's event (GPU timestamps) under a phase tag.
struct QW {
  queue q{gpu_selector_v, getenv("XIK_PROFILE") ? property_list{property::queue::in_order{}, property::queue::enable_profiling{}} : property_list{property::queue::in_order{}}};
  bool rec = false;
  int tag = 0;
  std::vector<std::pair<int, event>> evs;
  operator queue &() { return q; }
  template <class... A> event parallel_for(A &&...a) { event e = q.parallel_for(std::forward<A>(a)...); if (rec) evs.push_back({tag, e}); return e; }
  template <class... A> event submit(A &&...a) { event e = q.submit(std::forward<A>(a)...); if (rec) evs.push_back({tag, e}); return e; }
  template <class... A> event single_task(A &&...a) { event e = q.single_task(std::forward<A>(a)...); if (rec) evs.push_back({tag, e}); return e; }
  template <class... A> event memcpy(A &&...a) { event e = q.memcpy(std::forward<A>(a)...); if (rec) evs.push_back({tag, e}); return e; }
  template <class... A> event memset(A &&...a) { event e = q.memset(std::forward<A>(a)...); if (rec) evs.push_back({tag, e}); return e; }
  void wait() { q.wait(); }
  device get_device() { return q.get_device(); }
};

// ---------------------------------------------------------------- constants
constexpr int D = 2304, NLAYER = 24, NH = 24, NKV = 8, HD = 128, DREL = 16;
constexpr int EXT = 1024, WIN = 1024, KC = 4, NE = 128, TOPK = 8, FI = 1152;
constexpr int VOCAB = 201024, VOCAB_U = 200058;
constexpr int QD = NH * HD, KVD = NKV * HD, RD = NH * DREL;
constexpr int CORE0 = 6, CORE1 = 18, NCORE = 12, NPASS = 3, BLK = 6, RANK = 64;
constexpr int NSLOT = NLAYER + (NPASS - 1) * NCORE;  // 48
constexpr int RING = 2048;                           // local KV ring (>= WIN + max_tokens)
constexpr int CAPR = 256;
constexpr int KSMAX = 8, KS_FP4 = 2, DFF_ = 9216;
constexpr float EPS = 1e-6f, QK_CLIP = 22.627416997969522f, REL_CLIP = 8.0f;
constexpr float GATE_CAP = 4.0f, UP_CAP = 25.0f, FINAL_CAP = 30.0f, ROUTE_SCALE = 8.0f;

thread_local std::string g_err;
size_t g_alloc_total = 0;
bool is_local(int l) { return !(l == 5 || l == 11 || l == 17 || l == 23); }
bool is_mxfp8(int l) { return l >= 20; }
int slot_of(int layer, int pass) { return pass == 0 ? layer : NLAYER + (pass - 1) * NCORE + (layer - CORE0); }

// ------------------------------------------------------------ device helpers
inline float bf2f(uint16_t b) { return sycl::bit_cast<float>((uint32_t)b << 16); }
inline float rbf(float x) {  // round-to-nearest-even to bf16 precision, kept as float
  uint32_t u = sycl::bit_cast<uint32_t>(x);
  u += 0x7FFFu + ((u >> 16) & 1u);
  return sycl::bit_cast<float>(u & 0xFFFF0000u);
}
inline float e4m3(uint32_t b) {  // fp8 e4m3fn -> float
  uint32_t s = (b >> 7) & 1, e = (b >> 3) & 0xF, m = b & 7;
  float v = e ? sycl::bit_cast<float>(((e + 120u) << 23) | (m << 20)) : (float)m * (1.0f / 512.0f);
  return s ? -v : v;
}
inline float e2m1(uint32_t n) {  // fp4 e2m1 -> float
  uint32_t s = (n >> 3) & 1, e = (n >> 1) & 3, m = n & 1;
  float v = e ? sycl::bit_cast<float>(((e + 126u) << 23) | (m << 22)) : (float)m * 0.5f;
  return s ? -v : v;
}
inline float softcap(float x, float c) { return sycl::tanh(x / c) * c; }
inline float sigmoidf(float x) { return 1.0f / (1.0f + sycl::exp(-x)); }

struct Buf {
  void *base = nullptr;  // allocation start when p was shifted (XIK_WOFF), else null
  void *p = nullptr;
  size_t bytes = 0;
  int dtype = 0;
};

struct LayerW {
  const uint16_t *wq, *wk, *wv, *wr, *sink, *gate_attn, *wo, *q_clip, *rel_clip, *rel_proj;
  const uint16_t *k_conv, *v_conv;                // local: [C,1,4]
  const uint16_t *k_static, *k_dynw, *v_static, *v_dynw;  // global
  const uint16_t *attn_conv, *mlp_conv;
  const uint16_t *attn_norm, *q_norm, *k_norm, *v_norm, *mlp_norm;
  const uint16_t *router;
  const float *router_bias;
  const uint16_t *ctl_down[4], *ctl_gain[4], *ctl_forget[4];  // attn,k,v,mlp
  const uint8_t *w13, *w13_s, *w2, *w2_s;
  const float *w13_amax, *w2_amax, *w13_den, *w2_den;
  bool w3_13 = false, w3_2 = false;  // experts stored as W3A16 (XIK_W3)
};

}  // namespace

struct xik_ctx {
  QW q;
  int max_ctx = 0, max_tokens = 0;
  std::map<std::string, Buf> tensors;
  LayerW L[NLAYER];
  const uint16_t *embed = nullptr, *embed_norm = nullptr, *unembed = nullptr, *final_norm = nullptr;
  uint32_t *head_w4 = nullptr; uint16_t *head_s4 = nullptr;  // int4 output head (XIK_HEAD_W4): packed nibbles + fp16 group scales (see w4_gemv)
  const float *attnres_q[NLAYER - 1], *attnres_mlp[NLAYER], *attnres_out = nullptr, *xpass_q = nullptr, *xpass_kvq = nullptr;
  // state
  float *kcache[NSLOT], *vcache[NSLOT];
  bool kbf16 = false;  // K cache stored as bf16 bits (2 B) instead of fp32; lossless because every K value is already rounded to bf16 (rbf) before it is stored
  float *convst[NSLOT][2];  // ping-pong; each [3][KVD] k, [3][KVD] v, [3][D] attn, [3][D] mlp
  int cpar[NSLOT] = {0};
  bool defer = false;
  std::vector<int> seg_tag;
  float *sv_k[NSLOT], *sv_v[NSLOT], *sv_a[NSLOT], *sv_m[NSLOT];
  float *cap = nullptr;
  int cap_pos = 0, ing_pos = 0;  // hidden-state ring: rows written / rows already fed to the drafter
  int32_t *ecnt = nullptr, *elist = nullptr, *act_e = nullptr, *nact = nullptr, *desc = nullptr;
  int8_t *ahi = nullptr; uint8_t *alo = nullptr; float *asx = nullptr;  // INT8 path: activation planes + per-row scales
  int moe_cfg = -1;
  // ---- DSpark drafter
  bool has_dr = false;
  struct DL { const uint16_t *inln, *postln, *dfl, *qp, *kp, *vp, *kpc, *vpc, *op, *qn, *kn, *knc, *gp, *up, *dp; } dl[3];
  const uint16_t *d_fuse = nullptr, *d_norm = nullptr, *d_mask = nullptr, *mk_dfl = nullptr, *mk_hw = nullptr, *mk_hb = nullptr,
                 *mk_w1 = nullptr, *mk_rw = nullptr, *mk_rb = nullptr;
  uint16_t *foldW = nullptr, *foldB = nullptr;
  float *d_alpha = nullptr;  // [4][4]
  float *dkc[3], *dvc[3];
  int dpos = 0;
  float *dx, *dres, *dsum, *dnorm, *dq, *dk, *dv, *dat, *dtmp, *dg, *du, *dact, *dctxn, *dkctx, *dvctx, *dbase, *dxf,
      *dmkin, *dmkctx, *dmkst, *dmkraw, *dmklat, *dlg, *dfrnn;
  int32_t *dtok;
  int pend_T = 0;
  float *pool[10];
  float *pairb3[3], *hid3[3], *cg3[3], *cf3[3];
  int pos = 0;
  // workspace (all [max_tokens, ...])
  float *stream, *mix[3], *msg[4], *in[3], *tmp0, *tmp1;
  float *qb, *kb, *vb, *rb, *sinkb, *gateb, *dynk, *dynv, *attn_o, *ao2, *hid, *pairb;
  float *gu, *act, *ypair, *gu_part, *yp_part; sycl::half *x16_in, *x16_act; int nks = 1; float *rep_dummy, *rwt, *logits, *moe_o, *convout, *scr;
  int32_t *ridx, *ids_d, *am_d, *dparams = nullptr;
  std::map<std::array<int, 4>, std::shared_ptr<sycl::ext::oneapi::experimental::command_graph<sycl::ext::oneapi::experimental::graph_state::executable>>> graphs;
  bool graph_failed = false;
  float *trace_dev = nullptr, *trace_host = nullptr;
  bool prof = false;
  double prof_us[16] = {0};
  std::chrono::steady_clock::time_point tprev;
};

namespace {

#define SUBGROUP16 [[sycl::reqd_sub_group_size(16)]]

template <class T>
T *dalloc(xik_ctx *c, size_t n) {
  T *p = malloc_device<T>(n, c->q);
  if (!p) throw std::runtime_error("device alloc failed");
  g_alloc_total += n * sizeof(T);
  c->q.memset(p, 0, n * sizeof(T));
  return p;
}

void phase(xik_ctx *c, int id) {
  if (!c->prof) return;
  c->q.wait();
  auto now = std::chrono::steady_clock::now();
  c->prof_us[id] += std::chrono::duration<double, std::micro>(now - c->tprev).count();
  c->tprev = now;
}

static bool lat_on() { static const bool v = getenv("XIK_LAT") && atoi(getenv("XIK_LAT")); return v; }
// --------------------------------------------------------------- GEMV (bf16)
// Y[t][row] = sum_k W[row][k] * X[t][k]; one sub-group (16 lanes) handles R rows
// and TB tokens, so every x element is loaded once per R rows.
template <int R, int TB>
void gemv_bf16_t(queue &q, const uint16_t *W, const float *X, int ldx, float *Y, int ldy, int rows, int K,
                 int T, bool round_out) {
  int nsg = rows / R;
  int wg = 128;
  int nwg = (nsg * 16 + wg - 1) / wg;
  const bool lat = lat_on();
  q.parallel_for(nd_range<1>(nwg * wg, wg), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    int row0 = (int)(it.get_global_linear_id() / 16) * R;
    if (row0 >= rows) return;
    float acc[R][TB];
    for (int r = 0; r < R; r++)
      for (int t = 0; t < TB; t++) acc[r][t] = 0.f;
    if (lat && TB == 1 && R == 4) {
      // same per-lane accumulation order as the plain loop below; U iterations' loads are issued together
      constexpr int U = 3;
      for (int kb = lane; kb < K / 8; kb += 16 * U) {
        vec<float, 4> xa[U], xb[U];
        vec<uint32_t, 4> wv[U][R];
#pragma unroll
        for (int j = 0; j < U; j++) {
          int k8 = kb + 16 * j;
          if (k8 < K / 8) {
            xa[j] = *reinterpret_cast<const vec<float, 4> *>(X + k8 * 8);
            xb[j] = *reinterpret_cast<const vec<float, 4> *>(X + k8 * 8 + 4);
#pragma unroll
            for (int r = 0; r < R; r++) wv[j][r] = *reinterpret_cast<const vec<uint32_t, 4> *>(W + (size_t)(row0 + r) * K + k8 * 8);
          }
        }
#pragma unroll
        for (int j = 0; j < U; j++) {
          int k8 = kb + 16 * j;
          if (k8 < K / 8) {
            float xv0[8];
            for (int i = 0; i < 4; i++) { xv0[i] = xa[j][i]; xv0[4 + i] = xb[j][i]; }
#pragma unroll
            for (int r = 0; r < R; r++) {
              float wf[8];
              for (int i = 0; i < 4; i++) {
                wf[2 * i] = sycl::bit_cast<float>(wv[j][r][i] << 16);
                wf[2 * i + 1] = sycl::bit_cast<float>(wv[j][r][i] & 0xFFFF0000u);
              }
              for (int i = 0; i < 8; i++) acc[r][0] += wf[i] * xv0[i];
            }
          }
        }
      }
    }
    else
    for (int k8 = lane; k8 < K / 8; k8 += 16) {
      float xv[TB][8];
      for (int t = 0; t < TB; t++) {
        if (t < T) {
          vec<float, 4> a = *reinterpret_cast<const vec<float, 4> *>(X + (size_t)t * ldx + k8 * 8);
          vec<float, 4> b = *reinterpret_cast<const vec<float, 4> *>(X + (size_t)t * ldx + k8 * 8 + 4);
          for (int i = 0; i < 4; i++) { xv[t][i] = a[i]; xv[t][4 + i] = b[i]; }
        } else {
          for (int i = 0; i < 8; i++) xv[t][i] = 0.f;
        }
      }
      for (int r = 0; r < R; r++) {
        vec<uint32_t, 4> w = *reinterpret_cast<const vec<uint32_t, 4> *>(W + (size_t)(row0 + r) * K + k8 * 8);
        float wf[8];
        for (int i = 0; i < 4; i++) {
          wf[2 * i] = sycl::bit_cast<float>(w[i] << 16);
          wf[2 * i + 1] = sycl::bit_cast<float>(w[i] & 0xFFFF0000u);
        }
        for (int t = 0; t < TB; t++)
          for (int i = 0; i < 8; i++) acc[r][t] += wf[i] * xv[t][i];
      }
    }
    for (int r = 0; r < R; r++)
      for (int t = 0; t < TB; t++) {
        float s = reduce_over_group(sg, acc[r][t], plus<float>());
        if (lane == 0 && t < T) Y[(size_t)t * ldy + row0 + r] = round_out ? rbf(s) : s;
      }
  });
}

// Timing-only ablation (WRONG NUMBERS, benchmark only): XIK_ABL bitmask removes whole kernel groups so the remaining step time bounds what any
// fusion of that group could save.  1 loop controllers, 2 attention-residual mixes, 4 norms, 8 short convs, 16 MoE glue (cvt/act/combine; k_group stays so
// the expert descriptors are valid), 32 router gemv, 64 q/r clip + kv store, 128 synthetic routing (use it in EVERY ablation run so the expert access pattern is identical).
static int abl_mask() { static const int v = getenv("XIK_ABL") ? atoi(getenv("XIK_ABL")) : 0; return v; }
static int expert_lws() { static const int v = getenv("XIK_LWS") ? atoi(getenv("XIK_LWS")) : 16; return v; }  // work-group size of the expert kernels (16 = default); smaller groups spread 1152 threads more evenly over the Xe cores
void gemv_bf16_old(xik_ctx *c, const uint16_t *W, const float *X, int ldx, float *Y, int ldy, int rows, int K, int T,
               bool round_out) {
  if (abl_mask() & 32) return;
  for (int t0 = 0; t0 < T; t0 += 8) {
    int n = std::min(8, T - t0);
    const float *x = X + (size_t)t0 * ldx;
    float *y = Y + (size_t)t0 * ldy;
    if (n == 1) gemv_bf16_t<4, 1>(c->q, W, x, ldx, y, ldy, rows, K, n, round_out);
    else if (n == 2) gemv_bf16_t<4, 2>(c->q, W, x, ldx, y, ldy, rows, K, n, round_out);
    else if (n <= 4) gemv_bf16_t<4, 4>(c->q, W, x, ldx, y, ldy, rows, K, n, round_out);
    else gemv_bf16_t<4, 8>(c->q, W, x, ldx, y, ldy, rows, K, n, round_out);
  }
}

// ================================================================ dense bf16 DPAS path
// Dense weights are repacked once into DPAS B-operand tiles:  Wt[rb16][kt16][r=8][n=16] dwords,
// dword (r, n) = bf16 pair (row rb*16+n, k = kt*16 + 2r, 2r+1).  One DPAS (repeat R) multiplies one tile
// with R tokens, so all tokens of a pass share a single read of the weights.
constexpr int KSD_DEFAULT = 16;  // K-split threads per work-group (reduced through SLM); per call site, see DArgs::ksd

void k_repack_bf16(xik_ctx *c, const uint16_t *raw, uint32_t *dst, int rows, int rows_pad, int K) {
  int nkt = K / 16;
  size_t items = (size_t)rows_pad * K / 2;
  c->q.parallel_for(range<1>(items), [=](id<1> id) {
    size_t i = id[0];
    int row = (int)(i / (K / 2)), kp = (int)(i % (K / 2));
    int kt = kp / 8, r = kp % 8, rb = row / 16, n = row % 16;
    uint32_t v = row < rows ? *reinterpret_cast<const uint32_t *>(raw + (size_t)row * K + 2 * kp) : 0u;
    dst[(((size_t)rb * nkt + kt) * 8 + r) * 16 + n] = v;
  });
}

inline uint32_t f2e4m3(float v) {  // round to nearest even, saturating at 448
  uint32_t sgn = v < 0.f ? 0x80u : 0u;
  float x = sycl::fabs(v);
  if (x >= 448.f) return sgn | 0x7Eu;
  if (x < 0.015625f) {  // subnormal range: m * 2^-9
    float m = sycl::rint(x * 512.f);
    return sgn | (uint32_t)m;  // m == 8 is exactly the smallest normal (e=1, m=0)
  }
  uint32_t bits = sycl::bit_cast<uint32_t>(x);
  int e = (int)((bits >> 23) & 0xFF) - 127;
  float mant = x * sycl::bit_cast<float>((uint32_t)(127 - e) << 23);  // x / 2^e in [1, 2)
  int m = (int)sycl::rint((mant - 1.0f) * 8.0f);
  if (m == 8) { m = 0; e++; }
  int e4 = e + 7;
  if (e4 > 15 || (e4 == 15 && m > 6)) return sgn | 0x7Eu;
  return sgn | ((uint32_t)e4 << 3) | (uint32_t)m;
}
// per-row scale = max|w| / 448, then FP8 tiles: dst[(rb*nkt + kt)*4 + q][n]
void k_quant_fp8(xik_ctx *c, const uint16_t *raw, uint32_t *dst, float *scale, int rows, int rows_pad, int K) {
  c->q.parallel_for(nd_range<1>((size_t)rows_pad * 256, 256), [=](nd_item<1> it) {
    int row = it.get_group(0), l = it.get_local_id(0);
    float mx = 0.f;
    if (row < rows)
      for (int k = l; k < K; k += 256) mx = sycl::fmax(mx, sycl::fabs(bf2f(raw[(size_t)row * K + k])));
    mx = reduce_over_group(it.get_group(), mx, maximum<float>());
    if (l == 0) scale[row] = mx > 0.f ? mx / 448.0f : 1.0f;
  });
  int nkt = K / 16;
  c->q.parallel_for(range<1>((size_t)rows_pad * nkt * 4), [=](id<1> id) {
    size_t i = id[0];
    int q = (int)(i % 4);
    size_t t = i / 4;
    int kt = (int)(t % nkt), row = (int)(t / nkt);
    int rb = row / 16, n = row % 16;
    float inv = 1.0f / scale[row];
    uint32_t w = 0;
    if (row < rows) {
      const uint16_t *src = raw + (size_t)row * K + kt * 16 + 4 * q;
      uint32_t b0 = f2e4m3(bf2f(src[0]) * inv), b1 = f2e4m3(bf2f(src[1]) * inv), b2 = f2e4m3(bf2f(src[2]) * inv), b3 = f2e4m3(bf2f(src[3]) * inv);
      w = b0 | (b2 << 8) | (b1 << 16) | (b3 << 24);  // bytes: [k0, k2, k1, k3]
    }
    dst[(((size_t)rb * nkt + kt) * 4 + q) * 16 + n] = w;
  });
}

static std::map<const void *, const float *> g_fp8_scale;  // weight tile pointer -> per-row scales (FP8 mode)
// int4 (W4A16) copies of attention matrices (XIK_AW4): FP8 weight pointer -> {packed nibble tiles, per (16 rows, 64 K) group dword per lane: fp16 scale | fp16 (1024 + zero point) << 16}.
// Used for T <= 16 (decode, verify); prefill keeps the FP8 copy.
struct W4Alt { const uint32_t *w; const uint32_t *sz; size_t wb = 0, sb = 0; };
static std::map<const void *, W4Alt> g_w4alt;
struct W4Seg { const uint32_t *W, *SZ; const float *X; float *Y; int rows, K, ldx, ldy, rnd, wg0; };
struct W4Args {
  W4Seg s[8]; int n = 0, total_wg = 0;
  void add(const W4Alt &w, const float *X, int ldx, float *Y, int ldy, int rows, int K, bool rnd) { s[n] = W4Seg{w.w, w.sz, X, Y, rows, K, ldx, ldy, (int)rnd, total_wg}; total_wg += rows / 16; n++; }
};
static void w4z_run(xik_ctx *c, const W4Args &a, int T);
struct DSeg {
  const uint32_t *Wt;
  const float *X;
  float *Y;
  int rows, nrb, K, ldx, ldy, round, wg0;
  const float *scale;  // non-null: FP8 e4m3 tiles with this per-row scale
};
struct DArgs {
  DSeg s[8];
  int n = 0, total_wg = 0;
  int ksd = KSD_DEFAULT;
  int cls = 0;  // use class for the per-use cache policy: 0 attention q/k/v/r/gate/sink, 1 loop controller, 2 attention O, 3 head
  void add(const uint16_t *W, const float *X, int ldx, float *Y, int ldy, int rows, int K, bool round) {
    int nrb = (rows + 15) / 16;
    auto it = g_fp8_scale.find(W);
    s[n] = DSeg{reinterpret_cast<const uint32_t *>(W), X, Y, rows, nrb, K, ldx, ldy, (int)round, total_wg, it == g_fp8_scale.end() ? nullptr : it->second};
    total_wg += nrb;
    n++;
  }
};
// LSC cache-control variants of a block load (diagnostic; P = 0 keeps the default encoding).
// 1: L1 uncached/L2 cached  2: L1 streaming/L2 cached  3: L1 cached/L2 cached  4: L1 uncached/L2 uncached  5: L1 streaming/L2 uncached
// 6: L1 cached/L2 uncached  7: L1 read_invalidate/L2 cached  8: same as 7 (legal L1/L2 pairs on this API: {uc,ca,st}x{uc,ca}, ri+ca)
template <int P, int N>
ESIMD_INLINE es::simd<uint32_t, N> ldp(const uint32_t *p) {
  using namespace es;
  if constexpr (P == 0) return block_load<uint32_t, N>(p);
  else if constexpr (P == 1) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
  else if constexpr (P == 2) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::streaming>, cache_hint_L2<cache_hint::cached>, alignment<16>});
  else if constexpr (P == 3) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::cached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
  else if constexpr (P == 4) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::uncached>, alignment<16>});
  else if constexpr (P == 5) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::streaming>, cache_hint_L2<cache_hint::uncached>, alignment<16>});
  else if constexpr (P == 6) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::cached>, cache_hint_L2<cache_hint::uncached>, alignment<16>});
  else if constexpr (P == 7) return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::read_invalidate>, cache_hint_L2<cache_hint::cached>, alignment<16>});
  else return block_load<uint32_t, N>(p, properties{cache_hint_L1<cache_hint::read_invalidate>, cache_hint_L2<cache_hint::cached>, alignment<16>});
}
template <int R, int KSD, int AV, int PD = 0>
void dgemm_t(queue &q, const DArgs &a, int t0, int nt) {
  q.parallel_for(nd_range<1>((size_t)a.total_wg * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    slm_init<KSD * 16 * R * 4>();
    int wg = it.get_group(0), tid = it.get_local_id(0);
    int si = 0;
    while (si + 1 < a.n && wg >= a.s[si + 1].wg0) si++;
    const DSeg &sd = a.s[si];
    int rb = wg - sd.wg0;
    int nkt = sd.K / 16;
    int per = (nkt + KSD - 1) / KSD;
    int k0 = tid * per, k1 = k0 + per < nkt ? k0 + per : nkt;
    simd<float, 16 * R> acc = 0.f;
    const bool fp8 = sd.scale != nullptr;
    const uint32_t *wp = sd.Wt + (size_t)rb * nkt * (fp8 ? 64 : 128);
    const float *xr[R];
#pragma unroll
    for (int r = 0; r < R; r++) xr[r] = sd.X + (size_t)(t0 + (r < nt ? r : 0)) * sd.ldx;
    if (k0 < k1 && fp8 && AV == 3) {
      // synthetic ceiling: identical weight loads (one 256 B tile per step), no unpack, no DPAS, no x; a running sum keeps the loads alive
      const uint32_t *p = wp + (size_t)k0 * 64;
      simd<uint32_t, 64> sum = 0;
      for (int kt = k0; kt < k1; kt++, p += 64) {
        simd<uint32_t, 64> v;
        v.copy_from(p);
        sum ^= v;
      }
      simd<uint32_t, 16> g = sum.template select<16, 1>(0) ^ sum.template select<16, 1>(16) ^ sum.template select<16, 1>(32) ^ sum.template select<16, 1>(48);
      simd<float, 16> f = g.template bit_cast_view<float>();
      for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) = f;
    } else if (k0 < k1 && fp8 && (AV == 4 || AV == 5)) {
      // synthetic, same bytes as AV==3 but 4 tiles (1 KB) per step: AV==4 one 2D block load (64 B wide x 16 rows),
      // AV==5 one 1D block load of 1 KB (control for the bytes in flight); tail tiles by 1D loads
      const uint32_t *base = sd.Wt;
      simd<uint32_t, 256> sum = 0;
      simd<uint32_t, 64> sum1 = 0;
      size_t t_first = (size_t)rb * nkt + k0;      // first tile (256 B) of this thread in the whole weight array
      int kt = k0;
      for (; kt + 4 <= k1; kt += 4) {
        simd<uint32_t, 256> v;
        if (AV == 4) {
          // surface: all weights as rows of 64 B; row y = 4 consecutive dwords-of-16 -> tile t covers rows 4t..4t+3
          v = sycl::ext::intel::experimental::esimd::lsc_load_2d<uint32_t, 16, 16, 1, false, false>(
              base, 63u, (unsigned)(sd.nrb * nkt * 4 - 1), 63u, 0, (int)((t_first + (kt - k0)) * 4));
        } else {
          v.copy_from(base + (t_first + (kt - k0)) * 64);
        }
        sum ^= v;
      }
      for (; kt < k1; kt++) {
        simd<uint32_t, 64> v;
        v.copy_from(base + (t_first + (kt - k0)) * 64);
        sum1 ^= v;
      }
      // every lane of every loaded block must feed the result, else the compiler narrows the loads
      simd<uint32_t, 16> f16 = sum1.template select<16, 1>(0) ^ sum1.template select<16, 1>(16) ^ sum1.template select<16, 1>(32) ^ sum1.template select<16, 1>(48);
#pragma unroll
      for (int i = 0; i < 16; i++) f16 ^= sum.template select<16, 1>(16 * i);
      simd<float, 16> f = f16.template bit_cast_view<float>();
      for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) = f;
    } else if (k0 < k1 && fp8 && AV == 6) {
      // real kernel, U tiles loaded per step (one 1 KB block load = 4 x 256 B sends issued back to back), the next group is
      // issued before the current group is unpacked.  DPAS order and accumulator are unchanged (k ascending), so results are identical.
      constexpr int U = 4;
      const uint32_t *p = wp + (size_t)k0 * 64;
      const float *xp[R];
#pragma unroll
      for (int r = 0; r < R; r++) xp[r] = xr[r] + k0 * 16;
      simd<uint32_t, 64 * U> bq, bqn;
      int kt = k0;
      int nfull = (k1 - k0) / U * U;
      if (nfull > 0) bq.copy_from(p);
      for (; kt < k0 + nfull; kt += U) {
        if (kt + 2 * U <= k0 + nfull) bqn.copy_from(p + (size_t)(kt + U - k0) * 64);
#pragma unroll
        for (int u = 0; u < U; u++) {
          simd<int32_t, 8 * R> av;
#pragma unroll
          for (int r = 0; r < R; r++) {
            simd<float, 16> xv;
            xv.copy_from(xp[r] + (kt + u) * 16 - k0 * 16);
            simd<sycl::half, 16> xh = xv;
            av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
          }
          simd<uint32_t, 128> B;
#pragma unroll
          for (int q = 0; q < 4; q++) {
            simd<uint32_t, 16> xq = bq.template select<16, 1>(64 * u + 16 * q);
            simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
            B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
            B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
          }
          simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
          acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                          xmx::dpas_argument_type::fp16>(acc, bi, av);
        }
        bq = bqn;
      }
      for (; kt < k1; kt++) {  // tail tiles (fewer than U), one at a time
        simd<uint32_t, 64> bt;
        bt.copy_from(wp + (size_t)kt * 64);
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv;
          xv.copy_from(xr[r] + kt * 16);
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<uint32_t, 128> B;
#pragma unroll
        for (int q = 0; q < 4; q++) {
          simd<uint32_t, 16> xq = bt.template select<16, 1>(16 * q);
          simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
          B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
          B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
        }
        simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
        acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                        xmx::dpas_argument_type::fp16>(acc, bi, av);
      }
    } else if (k0 < k1 && fp8 && AV >= 1) {
      // B / C: base addresses fixed before the loop, the loop only adds constants
      const uint32_t *p = wp + (size_t)k0 * 64;
      const float *xp[R];
#pragma unroll
      for (int r = 0; r < R; r++) xp[r] = xr[r] + k0 * 16;
      simd<uint32_t, 64> bq, bqn;
      bq.copy_from(p);
      for (int kt = k0; kt < k1; kt++) {
        p += 64;
        if (kt + 1 < k1) bqn.copy_from(p);
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv;
          xv.copy_from(xp[r]);
          if (AV == 2) xp[r] += 16; else xp[r] = xr[r] + (kt + 1) * 16;
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<uint32_t, 128> B;
#pragma unroll
        for (int q = 0; q < 4; q++) {
          simd<uint32_t, 16> xq = bq.template select<16, 1>(16 * q);
          simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
          B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
          B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
        }
        simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
        acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                        xmx::dpas_argument_type::fp16>(acc, bi, av);
        bq = bqn;
      }
    } else if (k0 < k1 && fp8) {
      // FP8 e4m3 weights: 256 B per 16x16 tile; bytes of dword (q, n) = elements [4q, 4q+2, 4q+1, 4q+3] of row n.
      // (b & 0x7f) << 7 | (b & 0x80) << 8 is the fp16 bit pattern of value * 2^-8 (exact, also for subnormals).
      simd<uint32_t, 64> bq, bqn;
      bq = ldp<PD, 64>(wp + (size_t)k0 * 64);
      for (int kt = k0; kt < k1; kt++) {
        if (kt + 1 < k1) bqn = ldp<PD, 64>(wp + (size_t)(kt + 1) * 64);
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv;
          xv.copy_from(xr[r] + kt * 16);
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<uint32_t, 128> B;
#pragma unroll
        for (int q = 0; q < 4; q++) {
          simd<uint32_t, 16> xq = bq.template select<16, 1>(16 * q);
          simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
          B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
          B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
        }
        simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
        acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                        xmx::dpas_argument_type::fp16>(acc, bi, av);
        bq = bqn;
      }
    } else if (k0 < k1 && fp8) {
      // FP8 e4m3 weights: 256 B per 16x16 tile; bytes of dword (q, n) = elements [4q, 4q+2, 4q+1, 4q+3] of row n.
      // (b & 0x7f) << 7 | (b & 0x80) << 8 is the fp16 bit pattern of value * 2^-8 (exact, also for subnormals).
      simd<uint32_t, 64> bq, bqn;
      bq = ldp<PD, 64>(wp + (size_t)k0 * 64);
      for (int kt = k0; kt < k1; kt++) {
        if (kt + 1 < k1) bqn = ldp<PD, 64>(wp + (size_t)(kt + 1) * 64);
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv;
          xv.copy_from(xr[r] + kt * 16);
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<uint32_t, 128> B;
#pragma unroll
        for (int q = 0; q < 4; q++) {
          simd<uint32_t, 16> xq = bq.template select<16, 1>(16 * q);
          simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
          B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
          B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
        }
        simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
        acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                        xmx::dpas_argument_type::fp16>(acc, bi, av);
        bq = bqn;
      }
    } else if (k0 < k1) {
      simd<uint32_t, 128> bcur, bnext;
      {
        simd<uint32_t, 64> t0v, t1v;
        t0v.copy_from(wp + (size_t)k0 * 128);
        t1v.copy_from(wp + (size_t)k0 * 128 + 64);
        bcur.template select<64, 1>(0) = t0v;
        bcur.template select<64, 1>(64) = t1v;
      }
      for (int kt = k0; kt < k1; kt++) {
        if (kt + 1 < k1) {
          simd<uint32_t, 64> t0v, t1v;
          t0v.copy_from(wp + (size_t)(kt + 1) * 128);
          t1v.copy_from(wp + (size_t)(kt + 1) * 128 + 64);
          bnext.template select<64, 1>(0) = t0v;
          bnext.template select<64, 1>(64) = t1v;
        }
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv;
          xv.copy_from(xr[r] + kt * 16);
          simd<uint32_t, 16> xb = xv.template bit_cast_view<uint32_t>();
          simd<uint32_t, 8> ev = xb.template select<8, 2>(0), od = xb.template select<8, 2>(1);
          simd<uint32_t, 8> pk = (ev >> 16) | (od & 0xFFFF0000u);
          av.template select<8, 1>(8 * r) = pk.template bit_cast_view<int32_t>();
        }
        simd<int32_t, 128> bi = bcur.template bit_cast_view<int32_t>();
        acc = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::bf16,
                        xmx::dpas_argument_type::bf16>(acc, bi, av);
        bcur = bnext;
      }
    }
    slm_block_store<float, 16 * R>(tid * 16 * R * 4, acc);
    barrier();
    if (tid == 0) {
      simd<float, 16 * R> sum = slm_block_load<float, 16 * R>(0);
#pragma unroll
      for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16 * R>(j * 16 * R * 4);
      if (fp8) {
        simd<float, 16> sv;
        sv.copy_from(sd.scale + rb * 16);
        sv *= 256.0f;
#pragma unroll
        for (int r = 0; r < R; r++) sum.template select<16, 1>(16 * r) *= sv;
      }
      if (sd.round) {
        simd<uint32_t, 16 * R> u = sum.template bit_cast_view<uint32_t>();
        u += 0x7FFFu + ((u >> 16) & 1u);
        u &= 0xFFFF0000u;
        sum = u.template bit_cast_view<float>();
      }
#pragma unroll
      for (int r = 0; r < R; r++) {
        if (r < nt) {
          float *yp = sd.Y + (size_t)(t0 + r) * sd.ldy + rb * 16;
          simd<float, 16> o = sum.template select<16, 1>(16 * r);
          if (rb * 16 + 16 <= sd.rows) o.copy_to(yp);
          else
            for (int n = 0; n < 16; n++)
              if (rb * 16 + n < sd.rows) yp[n] = o[n];
        }
      }
    }
  });
}
static int dg_addr() { static const int v = getenv("XIK_ADDR") ? atoi(getenv("XIK_ADDR")) : 0; return v; }
template <int KSD, int AV, int PD = 0>
static void dgemm_k(xik_ctx *c, const DArgs &a, int T) {
  for (int t0 = 0; t0 < T; t0 += 8) {
    int n = std::min(8, T - t0);
    if (n == 1) dgemm_t<1, KSD, AV, PD>(c->q, a, t0, n);
    else if (n == 2) dgemm_t<2, KSD, AV, PD>(c->q, a, t0, n);
    else if (n <= 4) dgemm_t<4, KSD, AV, PD>(c->q, a, t0, n);
    else dgemm_t<8, KSD, AV, PD>(c->q, a, t0, n);
  }
}
template <int AV, int PD = 0>
static void dgemm_av(xik_ctx *c, const DArgs &a, int T) {
  if (a.ksd == 8) dgemm_k<8, AV, PD>(c, a, T);
  else if (a.ksd == 32) dgemm_k<32, AV, PD>(c, a, T);
  else dgemm_k<16, AV, PD>(c, a, T);
}
static int dg_pol(int cls) {
  // default: attention q/k/v/r/gate/sink, attention O and head use L1-streaming + L2-uncached weight loads (policy 5), the loop
  // controller keeps the default encoding; XIK_DENSE_POL=n sets every class, XIK_POL_ATT/CTL/O/HEAD one class
  static const bool have_all = getenv("XIK_DENSE_POL") != nullptr;
  static const int all = have_all ? atoi(getenv("XIK_DENSE_POL")) : 0;
  auto pick = [&](const char *name, int dflt) { return getenv(name) ? atoi(getenv(name)) : (have_all ? all : dflt); };
  static const int v[4] = {pick("XIK_POL_ATT", 5), pick("XIK_POL_CTL", 0), pick("XIK_POL_O", 5), pick("XIK_POL_HEAD", 5)};
  return v[cls & 3];
}
void dgemm(xik_ctx *c, const DArgs &a, int T) {
  switch (dg_addr()) {
    case 1: return dgemm_av<1>(c, a, T);
    case 2: return dgemm_av<2>(c, a, T);
    case 3: return dgemm_av<3>(c, a, T);
    case 4: return dgemm_av<4>(c, a, T);
    case 5: return dgemm_av<5>(c, a, T);
    case 6: return dgemm_av<6>(c, a, T);
    default:
      switch (dg_pol(a.cls)) {  // cache-control variants of the weight loads (FP8 path only; see ldp)
        case 1: return dgemm_av<0, 1>(c, a, T);
        case 2: return dgemm_av<0, 2>(c, a, T);
        case 3: return dgemm_av<0, 3>(c, a, T);
        case 5: return dgemm_av<0, 5>(c, a, T);
        case 6: return dgemm_av<0, 6>(c, a, T);
        default: return dgemm_av<0>(c, a, T);
      }
  }
}

// ------------------------------------------------- multi-matrix GEMV (one launch)
struct GSeg {
  const uint16_t *W;
  const float *X;
  float *Y;
  int rows, K, ldx, ldy, sg0, round, ldw;
};
struct GArgs {
  GSeg s[8];
  int n = 0, total_sg = 0;
  int cls = 0;  // per-use cache-policy class, see DArgs::cls
  void add(const uint16_t *W, const float *X, int ldx, float *Y, int ldy, int rows, int K, bool round, int ldw = 0) {
    s[n] = GSeg{W, X, Y, rows, K, ldx, ldy, total_sg, (int)round, ldw ? ldw : K};
    total_sg += rows / 4;
    n++;
  }
};
template <int TB>
void gemv_multi_t(queue &q, const GArgs &a, int t0, int nt) {
  int wg = 128;
  int nwg = (a.total_sg * 16 + wg - 1) / wg;
  q.parallel_for(nd_range<1>(nwg * wg, wg), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    int gsg = (int)(it.get_global_linear_id() / 16);
    if (gsg >= a.total_sg) return;
    int si = 0;
    while (si + 1 < a.n && gsg >= a.s[si + 1].sg0) si++;
    const GSeg &sd = a.s[si];
    int row0 = (gsg - sd.sg0) * 4;
    int K = sd.K;
    float acc[4][TB];
    for (int r = 0; r < 4; r++)
      for (int t = 0; t < TB; t++) acc[r][t] = 0.f;
    for (int k8 = lane; k8 < K / 8; k8 += 16) {
      float xv[TB][8];
      for (int t = 0; t < TB; t++) {
        if (t < nt) {
          const float *xp = sd.X + (size_t)(t0 + t) * sd.ldx + k8 * 8;
          vec<float, 4> x0 = *reinterpret_cast<const vec<float, 4> *>(xp);
          vec<float, 4> x1 = *reinterpret_cast<const vec<float, 4> *>(xp + 4);
          for (int i = 0; i < 4; i++) { xv[t][i] = x0[i]; xv[t][4 + i] = x1[i]; }
        } else {
          for (int i = 0; i < 8; i++) xv[t][i] = 0.f;
        }
      }
      for (int r = 0; r < 4; r++) {
        vec<uint32_t, 4> w = *reinterpret_cast<const vec<uint32_t, 4> *>(sd.W + (size_t)(row0 + r) * sd.ldw + k8 * 8);
        float wf[8];
        for (int i = 0; i < 4; i++) {
          wf[2 * i] = sycl::bit_cast<float>(w[i] << 16);
          wf[2 * i + 1] = sycl::bit_cast<float>(w[i] & 0xFFFF0000u);
        }
        for (int t = 0; t < TB; t++)
          for (int i = 0; i < 8; i++) acc[r][t] += wf[i] * xv[t][i];
      }
    }
    for (int r = 0; r < 4; r++)
      for (int t = 0; t < TB; t++) {
        float s = reduce_over_group(sg, acc[r][t], plus<float>());
        if (lane == 0 && t < nt) sd.Y[(size_t)(t0 + t) * sd.ldy + row0 + r] = sd.round ? rbf(s) : s;
      }
  });
}
void gemv_multi_old(xik_ctx *c, const GArgs &a, int T) {
  for (int t0 = 0; t0 < T; t0 += 8) {
    int n = std::min(8, T - t0);
    if (n == 1) gemv_multi_t<1>(c->q, a, t0, n);
    else if (n == 2) gemv_multi_t<2>(c->q, a, t0, n);
    else if (n <= 4) gemv_multi_t<4>(c->q, a, t0, n);
    else gemv_multi_t<8>(c->q, a, t0, n);
  }
}

void gemv_multi(xik_ctx *c, const GArgs &a, int T) {
  bool old = false;
  for (int i = 0; i < a.n; i++) old |= a.s[i].ldw != a.s[i].K;
  if (old) return gemv_multi_old(c, a, T);
  DArgs d;
  static const int ksd_proj = getenv("XIK_KSD_PROJ") ? atoi(getenv("XIK_KSD_PROJ")) : KSD_DEFAULT;
  d.ksd = ksd_proj;
  d.cls = a.cls;
  W4Args wa;
  for (int i = 0; i < a.n; i++) {
    auto alt = (T <= 16 && !g_w4alt.empty()) ? g_w4alt.find(a.s[i].W) : g_w4alt.end();
    if (alt != g_w4alt.end()) wa.add(alt->second, a.s[i].X, a.s[i].ldx, a.s[i].Y, a.s[i].ldy, a.s[i].rows, a.s[i].K, a.s[i].round);
    else d.add(a.s[i].W, a.s[i].X, a.s[i].ldx, a.s[i].Y, a.s[i].ldy, a.s[i].rows, a.s[i].K, a.s[i].round);
  }
  if (d.n) dgemm(c, d, T);
  if (wa.n) w4z_run(c, wa, T);
}
void gemv_bf16(xik_ctx *c, const uint16_t *W, const float *X, int ldx, float *Y, int ldy, int rows, int K, int T,
               bool round_out, int ksd = KSD_DEFAULT, int cls = 0) {
  if (T <= 16 && !g_w4alt.empty()) {
    auto alt = g_w4alt.find(W);
    if (alt != g_w4alt.end()) { W4Args wa; wa.add(alt->second, X, ldx, Y, ldy, rows, K, round_out); return w4z_run(c, wa, T); }
  }
  DArgs d;
  d.ksd = ksd;
  d.cls = cls;
  d.add(W, X, ldx, Y, ldy, rows, K, round_out);
  dgemm(c, d, T);
}


// ----------------------------------------------------------- expert GEMV
// pairs p = t*8+k.  w13: x row = p/8; w2: x row = p.  Output row p.
// FP4 (NVFP4): 16-element blocks, e4m3 scales, per-expert amax/den.
template <bool W13>
void expert_fp4(xik_ctx *c, const LayerW &lw, const float *X, int ldx, float *Y, int ldy, const int32_t *ridx,
                int npairs, int rows, int K) {
  constexpr int R = 4;
  const uint8_t *Wd = W13 ? lw.w13 : lw.w2;
  const uint8_t *Sc = W13 ? lw.w13_s : lw.w2_s;
  const float *amax = W13 ? lw.w13_amax : lw.w2_amax;
  const float *den = W13 ? lw.w13_den : lw.w2_den;
  int sgs_per_pair = rows / R;
  size_t total_sg = (size_t)npairs * sgs_per_pair;
  int wg = 128;
  size_t nwg = (total_sg * 16 + wg - 1) / wg;
  c->q.parallel_for(nd_range<1>(nwg * wg, wg), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    size_t gsg = it.get_global_linear_id() / 16;
    if (gsg >= total_sg) return;
    int p = (int)(gsg / sgs_per_pair);
    int row0 = (int)(gsg % sgs_per_pair) * R;
    int e = ridx[p];
    const float *x = X + (size_t)(W13 ? p / TOPK : p) * ldx;
    size_t wrow = (size_t)K / 2, srow = (size_t)K / 16;
    const uint8_t *wb = Wd + (size_t)e * rows * wrow;
    const uint8_t *sb = Sc + (size_t)e * rows * srow;
    float acc[R] = {0, 0, 0, 0};
    for (int ch = lane; ch < K / 32; ch += 16) {  // chunk = 32 elements = 16 bytes + 2 scales
      float xv[32];
      for (int i = 0; i < 8; i++) {
        vec<float, 4> a = *reinterpret_cast<const vec<float, 4> *>(x + ch * 32 + i * 4);
        for (int j = 0; j < 4; j++) xv[i * 4 + j] = a[j];
      }
      for (int r = 0; r < R; r++) {
        vec<uint32_t, 4> w = *reinterpret_cast<const vec<uint32_t, 4> *>(wb + (size_t)(row0 + r) * wrow + ch * 16);
        uint16_t s2 = *reinterpret_cast<const uint16_t *>(sb + (size_t)(row0 + r) * srow + ch * 2);
        float s0 = e4m3(s2 & 0xFF), s1 = e4m3(s2 >> 8);
        float a0 = 0.f, a1 = 0.f;
        for (int wi = 0; wi < 4; wi++) {
          uint32_t u = w[wi];
          for (int b = 0; b < 4; b++) {
            uint32_t byte = (u >> (8 * b)) & 0xFF;
            int el = wi * 8 + b * 2;
            float v = e2m1(byte & 0xF) * xv[el] + e2m1(byte >> 4) * xv[el + 1];
            if (wi < 2) a0 += v; else a1 += v;
          }
        }
        acc[r] += a0 * s0 + a1 * s1;
      }
    }
    float g = amax[e] / den[0];
    for (int r = 0; r < R; r++) {
      float s = reduce_over_group(sg, acc[r], plus<float>());
      if (lane == 0) {
        float o = s * g;
        Y[(size_t)p * ldy + row0 + r] = W13 ? o : rbf(o);
      }
    }
  });
}

// MXFP8: e4m3 elements, ue8m0 scale per 32.
template <bool W13>
void expert_fp8(xik_ctx *c, const LayerW &lw, const float *X, int ldx, float *Y, int ldy, const int32_t *ridx,
                int npairs, int rows, int K) {
  constexpr int R = 4;
  const uint8_t *Wd = W13 ? lw.w13 : lw.w2;
  const uint8_t *Sc = W13 ? lw.w13_s : lw.w2_s;
  int sgs_per_pair = rows / R;
  size_t total_sg = (size_t)npairs * sgs_per_pair;
  int wg = 128;
  size_t nwg = (total_sg * 16 + wg - 1) / wg;
  c->q.parallel_for(nd_range<1>(nwg * wg, wg), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    size_t gsg = it.get_global_linear_id() / 16;
    if (gsg >= total_sg) return;
    int p = (int)(gsg / sgs_per_pair);
    int row0 = (int)(gsg % sgs_per_pair) * R;
    int e = ridx[p];
    const float *x = X + (size_t)(W13 ? p / TOPK : p) * ldx;
    size_t wrow = (size_t)K, srow = (size_t)K / 32;
    const uint8_t *wb = Wd + (size_t)e * rows * wrow;
    const uint8_t *sb = Sc + (size_t)e * rows * srow;
    float acc[R] = {0, 0, 0, 0};
    for (int ch = lane; ch < K / 32; ch += 16) {  // 32 bytes + 1 scale
      float xv[32];
      for (int i = 0; i < 8; i++) {
        vec<float, 4> a = *reinterpret_cast<const vec<float, 4> *>(x + ch * 32 + i * 4);
        for (int j = 0; j < 4; j++) xv[i * 4 + j] = a[j];
      }
      for (int r = 0; r < R; r++) {
        const uint8_t *wp = wb + (size_t)(row0 + r) * wrow + ch * 32;
        vec<uint32_t, 4> w0 = *reinterpret_cast<const vec<uint32_t, 4> *>(wp);
        vec<uint32_t, 4> w1 = *reinterpret_cast<const vec<uint32_t, 4> *>(wp + 16);
        uint32_t sb8 = sb[(size_t)(row0 + r) * srow + ch];
        float sc = sycl::bit_cast<float>(sb8 << 23);
        float a = 0.f;
        for (int wi = 0; wi < 4; wi++)
          for (int b = 0; b < 4; b++) {
            a += e4m3((w0[wi] >> (8 * b)) & 0xFF) * xv[wi * 4 + b];
            a += e4m3((w1[wi] >> (8 * b)) & 0xFF) * xv[16 + wi * 4 + b];
          }
        acc[r] += a * sc;
      }
    }
    for (int r = 0; r < R; r++) {
      float s = reduce_over_group(sg, acc[r], plus<float>());
      if (lane == 0) Y[(size_t)p * ldy + row0 + r] = W13 ? s : rbf(s);
    }
  });
}

// ================================================================ NVFP4 DPAS path
// Weights are repacked once at load into the order the kernel consumes:
//   Wp[e][rb16][st64][j=8][lane=16] dwords: lane n = row rb*16+n, j = 2*b + h = 8 nibbles
//   (K = st*64 + 16*b + 8*h ..), nibble pairs rearranged so that R >> (4*j) exposes
//   (even element, odd element) in the low nibbles of the two 16-bit halves.
//   Sp[e][rb][st][b=4][lane=16] bytes: the e4m3 block scales.
// A fp16 DPAS then multiplies  e2m1 * 2^-14  (payload bits 11:9, sign bit 15; exact,
// subnormal for e=0) with fp16 activations; the block scale is applied per 16 rows.
// Expert quality simulation (XIK_E3SIM): requantise an NVFP4 expert tensor (e2m1 x e4m3 group-16 scale) to INT3 / INT2 with group G (multiple of 16), writing the result back
// in NVFP4 form so the production kernels run it unchanged.  Integer levels -qmax-1..qmax (qmax = 3 for 3 bit, 1 for 2 bit) are all exact e2m1 values (0,1,2,3,4 -> codes 0,2,4,5,6), the
// group scale is rounded to e4m3 and replicated over the G/16 sub-groups.  Scale candidates: amax/qmax * (1 - 0.05 c), c = 0..NC-1 (squared-error search).  err[2*(e*rows+row)] = sum (w-q)^2, [+1] = sum w^2.
inline float e4m3_dec(uint32_t b) { uint32_t e = (b >> 3) & 15, m = b & 7; return e == 0 ? (float)m * (1.f / 512.f) : (1.f + (float)m * 0.125f) * sycl::ldexp(1.f, (int)e - 7); }
static void k_e3sim(xik_ctx *c, uint8_t *w, uint8_t *sc, int rows, int K, int G, int bits, int NC, float *err) {
  c->q.parallel_for(range<1>((size_t)NE * rows), [=](id<1> id) {
    const size_t row = id[0];
    uint8_t *wr = w + row * (K / 2); uint8_t *sr = sc + row * (K / 16);
    const float qm = bits == 3 ? 3.f : 1.f;
    static const float lv[8] = {0.f, 0.5f, 1.f, 1.5f, 2.f, 3.f, 4.f, 6.f};
    float eacc = 0.f, wacc = 0.f; float v[128];
    for (int g0 = 0; g0 < K; g0 += G) {
      float amax = 0.f;
      for (int i = 0; i < G; i++) {
        uint32_t byte = wr[(g0 + i) / 2]; uint32_t nib = (i & 1) ? (byte >> 4) : (byte & 15);
        float x = lv[nib & 7] * ((nib & 8) ? -1.f : 1.f) * e4m3_dec(sr[(g0 + i) / 16] & 0x7F);
        v[i] = x; amax = sycl::fmax(amax, sycl::fabs(x));
      }
      float best = 1e30f, bs = 0.f;
      for (int cd = 0; cd < NC; cd++) {
        float s = amax * (1.f - 0.05f * cd) / qm; if (s <= 0.f) break;
        uint32_t cb = 1; float bd = 1e30f;   // nearest e4m3 code (positive, 1..126)
        for (uint32_t k = 1; k < 127; k++) { float d = sycl::fabs(e4m3_dec(k) - s); if (d < bd) { bd = d; cb = k; } }
        float sq = e4m3_dec(cb), e2 = 0.f;
        for (int i = 0; i < G; i++) { float q = sycl::fmin(qm, sycl::fmax(-qm - 1.f, sycl::rint(v[i] / sq))); float d = v[i] - q * sq; e2 += d * d; }
        if (e2 < best) { best = e2; bs = sq; }
      }
      uint32_t sb = 0; if (bs > 0.f) { float bd = 1e30f; for (uint32_t k = 1; k < 127; k++) { float d = sycl::fabs(e4m3_dec(k) - bs); if (d < bd) { bd = d; sb = k; } } }
      for (int i = 0; i < G / 16; i++) sr[g0 / 16 + i] = (uint8_t)sb;
      for (int i = 0; i < G; i += 2) {
        uint32_t nb2[2];
        for (int j = 0; j < 2; j++) {
          float q = bs > 0.f ? sycl::fmin(qm, sycl::fmax(-qm - 1.f, sycl::rint(v[i + j] / bs))) : 0.f;
          float d = v[i + j] - q * bs; eacc += d * d; wacc += v[i + j] * v[i + j];
          int m = (int)sycl::fabs(q); uint32_t code = m == 0 ? 0u : m == 1 ? 2u : m == 2 ? 4u : m == 3 ? 5u : 6u;
          nb2[j] = code | (q < 0.f ? 8u : 0u);
        }
        wr[(g0 + i) / 2] = (uint8_t)(nb2[0] | (nb2[1] << 4));
      }
    }
    err[2 * row] = eacc; err[2 * row + 1] = wacc;
  });
}

void k_repack_fp4(xik_ctx *c, const uint8_t *raw, uint8_t *dst, const uint8_t *sraw, uint8_t *sdst, int rows, int K) {
  int nrb = rows / 16, nst = K / 64;
  size_t items = (size_t)NE * nrb * nst * 16;
  c->q.parallel_for(range<1>(items), [=](id<1> id) {
    size_t i = id[0];
    int n = (int)(i % 16);
    size_t t = i / 16;
    int st = (int)(t % nst);
    t /= nst;
    int rb = (int)(t % nrb);
    int e = (int)(t / nrb);
    size_t row = (size_t)e * rows + rb * 16 + n;
    uint32_t *wd = reinterpret_cast<uint32_t *>(dst) + (((size_t)e * nrb + rb) * nst + st) * 128;
    for (int j = 0; j < 8; j++) {
      int b = j / 2, h = j % 2;
      size_t kb = (size_t)st * 64 + b * 16 + h * 8;  // element index
      uint32_t w = *reinterpret_cast<const uint32_t *>(raw + row * (K / 2) + kb / 2);
      uint32_t R = 0;
      for (int q = 0; q < 4; q++) {
        uint32_t a = (w >> (8 * q)) & 0xF, bb = (w >> (8 * q + 4)) & 0xF;  // elements 2q, 2q+1
        R |= (a << (4 * q)) | (bb << (16 + 4 * q));
      }
      wd[j * 16 + n] = R;
    }
    uint8_t *sd = sdst + (((size_t)e * nrb + rb) * nst + st) * 64;
    for (int b = 0; b < 4; b++) sd[b * 16 + n] = sraw[row * (K / 16) + st * 4 + b];
  });
}

inline es::simd<uint32_t, 16> fp4_pair(es::simd<uint32_t, 16> y) {
  return ((y << 9) & 0x0E000E00u) | ((y << 12) & 0x80008000u);
}

// pairs p = t*8+k; W13: x row = p/8 (K = 2304), else x row = p (K = 1152).
// Each thread: (pair, 16-row block, K slice); partial sums go to Y[ks].
template <int KS>
void moe_fp4(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13,
             const float *amax, const float *den, const int32_t *ridx, int npairs, int rows, int K, float *Y,
             size_t ystride, int ldy) {
  int nrb = rows / 16, nst = K / 64, per = nst / KS;
  size_t nthreads = (size_t)npairs * nrb * KS;
  c->q.parallel_for(nd_range<1>(nthreads, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    size_t gid = it.get_global_id(0);
    int ks = (int)(gid % KS);
    size_t r1 = gid / KS;
    int rb = (int)(r1 % nrb);
    int p = (int)(r1 / nrb);
    int e = ridx[p];
    const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wp) + (((size_t)e * nrb + rb) * nst + ks * per) * 128;
    const uint8_t *sp = Sp + (((size_t)e * nrb + rb) * nst + ks * per) * 64;
    const sycl::half *xp = X16 + (size_t)(w13 ? p / TOPK : p) * ldx + (size_t)ks * per * 64;
    simd<float, 16> acc = 0.f;
    simd<uint32_t, 128> wcur, wnext;
    simd<uint8_t, 64> scur, snext;
    {
      simd<uint32_t, 64> t0, t1;
      t0.copy_from(wp);
      t1.copy_from(wp + 64);
      wcur.template select<64, 1>(0) = t0;
      wcur.template select<64, 1>(64) = t1;
    }
    scur.copy_from(sp);
    for (int s = 0; s < per; s++) {
      if (s + 1 < per) {
        simd<uint32_t, 64> t0, t1;
        t0.copy_from(wp + (s + 1) * 128);
        t1.copy_from(wp + (s + 1) * 128 + 64);
        wnext.template select<64, 1>(0) = t0;
        wnext.template select<64, 1>(64) = t1;
        snext.copy_from(sp + (s + 1) * 64);
      }
#pragma unroll
      for (int b = 0; b < 4; b++) {
        simd<uint32_t, 16> R0 = wcur.template select<16, 1>(32 * b), R1 = wcur.template select<16, 1>(32 * b + 16);
        simd<uint32_t, 128> B;
#pragma unroll
        for (int r = 0; r < 4; r++) {
          B.template select<16, 1>(16 * r) = fp4_pair(R0 >> (4 * r));
          B.template select<16, 1>(16 * (r + 4)) = fp4_pair(R1 >> (4 * r));
        }
        simd<int32_t, 8> a;
        a.copy_from(reinterpret_cast<const int32_t *>(xp + (size_t)s * 64 + b * 16));
        simd<float, 16> z = 0.f;
        simd<int32_t, 128> Bi = B.template bit_cast_view<int32_t>();
        simd<float, 16> res = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                                        xmx::dpas_argument_type::fp16>(z, Bi, a);
        simd<uint8_t, 16> s8 = scur.template select<16, 1>(16 * b);
        simd<uint32_t, 16> sb = convert<uint32_t>(s8);
        simd<uint32_t, 16> sbits = (sb & 0x7Fu) << 20;
        simd<float, 16> sc = sbits.template bit_cast_view<float>() * 1.329227995784916e36f;  // 2^120
        acc += res * sc;
      }
      wcur = wnext;
      scur = snext;
    }
    float g = amax[e] / den[0] * 16384.0f;  // undo the 2^-14 fp16 weight scale
    acc *= g;
    acc.copy_to(Y + (size_t)ks * ystride + (size_t)p * ldy + rb * 16);
  });
}

// group the (token, k) pairs by expert: ecnt[e], elist[e][..] = pair ids, act_e = compact list of active experts
void k_group(xik_ctx *c, int np, int maxper) {
  const int32_t *ridx = c->ridx;
  int32_t *ecnt = c->ecnt, *elist = c->elist, *act = c->act_e, *nact = c->nact, *desc = c->desc;
  int maxslots = std::min(NE, np);
  c->q.parallel_for(nd_range<1>(NE, NE), [=](nd_item<1> it) {
    int e = it.get_local_id(0);
    auto g = it.get_group();
    int cnt = 0;
    for (int p = 0; p < np; p++)
      if (ridx[p] == e) elist[(size_t)e * maxper + cnt++] = p;
    ecnt[e] = cnt;
    int flag = cnt > 0 ? 1 : 0;
    int pos = exclusive_scan_over_group(g, flag, plus<int>());
    if (flag) {
      act[pos] = e;
      int32_t *d = desc + pos * 16;
      d[0] = e;
      d[1] = cnt;
      for (int i = 0; i < 8; i++) d[2 + i] = elist[(size_t)e * maxper + (i < cnt ? i : 0)];
    }
    int tot = reduce_over_group(g, flag, plus<int>());
    if (e == 0) nact[0] = tot;
    for (int j = tot + e; j < maxslots; j += NE) desc[j * 16 + 1] = 0;
  });
}

// Expert-grouped NVFP4 GEMM: each thread streams one expert's 16-row block once and applies it to all
// tokens routed to that expert (DPAS repeat count R = number of tokens, <= 8 per pass).
// ---- v2: single descriptor load, aligned block loads for scales and x, NB-deep software pipeline.
//   per supertile (64 K x 16 rows): W 512 B (2 x 256 B), scales 64 B, x 128 B per token row.
template <int KS, int R, int NB, int PW = 0, int PS = 0, bool LEAN = false>
ESIMD_INLINE void moe_fp4_body(const uint32_t *wp, const uint32_t *sp, const sycl::half *X16, int ldx, bool w13,
                               const int32_t *ids, int cnt, int per, float g, float *Y, size_t ystride, int ldy, int rb,
                               int ks, int stage_in, uint64_t *tsq_in = nullptr) {
  using namespace es;
  // LEAN: production path with the benchmark-only stage switch and progress timestamps compiled out (identical arithmetic)
  const int stage = LEAN ? 4 : stage_in;
  uint64_t *const tsq = LEAN ? nullptr : tsq_in;
  simd<float, 16 * R> acc = 0.f;
  simd<uint32_t, 16> fold = 0;  // stage 1-3 (benchmark only): every loaded / unpacked lane feeds this
  const uint32_t *xr[R];
#pragma unroll
  for (int r = 0; r < R; r++) {
    int p = ids[r < cnt ? r : 0];
    xr[r] = reinterpret_cast<const uint32_t *>(X16 + (size_t)(w13 ? p / TOPK : p) * ldx + (size_t)ks * per * 64);
  }
  simd<uint32_t, 128> wb[NB];
  simd<uint32_t, 16> sb[NB];
  simd<uint32_t, 32 * R> xb[NB];
  auto load = [&](int u, int s) {
    simd<uint32_t, 64> t0 = ldp<PW, 64>(wp + (size_t)s * 128);
    simd<uint32_t, 64> t1 = ldp<PW, 64>(wp + (size_t)s * 128 + 64);
    wb[u].template select<64, 1>(0) = t0;
    wb[u].template select<64, 1>(64) = t1;
    sb[u] = ldp<PS, 16>(sp + (size_t)s * 16);
#pragma unroll
    for (int r = 0; r < R; r++) xb[u].template select<32, 1>(32 * r) = block_load<uint32_t, 32>(xr[r] + (size_t)s * 32);
  };
#pragma unroll
  for (int u = 0; u < NB; u++)
    if (u < per) load(u, u);
  for (int s0 = 0; s0 < per; s0 += NB) {
#pragma unroll
    for (int u = 0; u < NB; u++) {
      int s = s0 + u;
      if (s < per && stage == 1) {
        // load only: fold every dword that arrived
#pragma unroll
        for (int i = 0; i < 8; i++) fold ^= wb[u].template select<16, 1>(16 * i);
        fold ^= sb[u];
#pragma unroll
        for (int i = 0; i < 2 * R; i++) fold ^= xb[u].template select<16, 1>(16 * i);
        if (s + NB < per) load(u, s + NB);
      } else if (s < per) {
        simd<uint8_t, 64> s8 = sb[u].template bit_cast_view<uint8_t>();
#pragma unroll
        for (int b = 0; b < 4; b++) {
          simd<uint32_t, 16> R0 = wb[u].template select<16, 1>(32 * b), R1 = wb[u].template select<16, 1>(32 * b + 16);
          simd<uint32_t, 128> B;
#pragma unroll
          for (int r = 0; r < 4; r++) {
            B.template select<16, 1>(16 * r) = fp4_pair(R0 >> (4 * r));
            B.template select<16, 1>(16 * (r + 4)) = fp4_pair(R1 >> (4 * r));
          }
          if (stage == 2 || stage == 3) {
#pragma unroll
            for (int i = 0; i < 8; i++) fold ^= B.template select<16, 1>(16 * i);
            if (stage == 3) {
              simd<uint8_t, 16> sc8 = s8.template select<16, 1>(16 * b);
              simd<uint32_t, 16> sw = convert<uint32_t>(sc8);
              simd<uint32_t, 16> sbits = (sw & 0x7Fu) << 20;
              simd<float, 16> sc = sbits.template bit_cast_view<float>() * 1.329227995784916e36f;
              fold ^= sc.template bit_cast_view<uint32_t>();
            }
            continue;
          }
          simd<int32_t, 8 * R> a;
#pragma unroll
          for (int r = 0; r < R; r++) a.template select<8, 1>(8 * r) = xb[u].template select<8, 1>(32 * r + 8 * b).template bit_cast_view<int32_t>();
          simd<float, 16 * R> z = 0.f;
          simd<int32_t, 128> Bi = B.template bit_cast_view<int32_t>();
          simd<float, 16 * R> res = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                                              xmx::dpas_argument_type::fp16>(z, Bi, a);
          simd<uint8_t, 16> sc8 = s8.template select<16, 1>(16 * b);
          simd<uint32_t, 16> sw = convert<uint32_t>(sc8);
          simd<uint32_t, 16> sbits = (sw & 0x7Fu) << 20;
          simd<float, 16> sc = sbits.template bit_cast_view<float>() * 1.329227995784916e36f;  // 2^120
#pragma unroll
          for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += res.template select<16, 1>(16 * r) * sc;
        }
        if (tsq && (s == 0 || s == per / 4 || s == per / 2 || s == (3 * per) / 4) &&
            sycl::bit_cast<uint32_t>((float)acc[0]) != 0x7fc12345u) {  // diagnostic: progress timestamps, ordered after tile s's data
          simd<uint64_t, 1> tv = es::rdtsc();
          tv.copy_to(tsq + (s == 0 ? 0 : s == per / 4 ? 1 : s == per / 2 ? 2 : 3));
        }
        if (s + NB < per) load(u, s + NB);
      }
    }
  }
  if (stage != 4) {
#pragma unroll
    for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) = fold.template bit_cast_view<float>();
  }
#pragma unroll
  for (int r = 0; r < R; r++) {
    if (r < cnt) {
      simd<float, 16> o = acc.template select<16, 1>(16 * r) * g;
      o.copy_to(Y + (size_t)ks * ystride + (size_t)ids[r] * ldy + rb * 16);
    }
  }
}

uint64_t *g_ts = nullptr;  // diagnostic: per-thread start/end rdtsc of moe_fp4g (null = off)
template <int KS, int NB, int PW = 0, int PS = 0, bool LEAN = false, bool R1 = false>
void moe_fp4g_t(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13,
                const float *amax, const float *den, int maxper, int maxslots, int rows, int K, float *Y,
                size_t ystride, int ldy) {
  int nrb = rows / 16, nst = K / 64, per = nst / KS;
  const int32_t *desc = c->desc, *elist = c->elist;
  size_t nthreads = (size_t)maxslots * nrb * KS;
  static const int stage_s = getenv("XIK_FP4_STAGE") ? atoi(getenv("XIK_FP4_STAGE")) : 4;
  const int stage = LEAN ? 4 : stage_s;
  static const bool fastdiv_s = !getenv("XIK_NO_FASTDIV");
  const bool fastdiv = fastdiv_s;
  uint64_t *const ts = LEAN ? nullptr : g_ts;
  static const unsigned perm_m = getenv("XIK_PERM") ? (unsigned)atoi(getenv("XIK_PERM")) : 1;  // diagnostic: gid -> task bijection
  const unsigned pm = LEAN ? 1u : perm_m;
  c->q.parallel_for(nd_range<1>(nthreads, expert_lws()), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    size_t hw_gid = it.get_global_id(0);
    size_t gid = pm == 1 ? hw_gid : (hw_gid * pm) % (it.get_global_range(0));
    uint64_t t_start = ts ? es::rdtsc() : 0;
    uint64_t *const tsq = ts ? ts + 8 * hw_gid + 2 : nullptr;
    int ks = (int)(gid % KS);
    int rb, j;
    if (nrb == 144 && fastdiv) {  // constant divisor: multiply-shift instead of the emulated 64-bit division subroutine call
      uint32_t r1 = (uint32_t)gid / KS;
      rb = (int)(r1 % 144u);
      j = (int)(r1 / 144u);
    } else {
      size_t r1 = gid / KS;
      rb = (int)(r1 % nrb);
      j = (int)(r1 / nrb);
    }
    simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
    int cnt = d[1];
    if (tsq && cnt != 0x7fc12345) { simd<uint64_t, 1> tv = es::rdtsc(); tv.copy_to(tsq + 4); }  // diagnostic: descriptor arrived
    if (cnt <= 0) return;
    int e = d[0];
    const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wp) + (((size_t)e * nrb + rb) * nst + ks * per) * 128;
    const uint32_t *sp = reinterpret_cast<const uint32_t *>(Sp) + (((size_t)e * nrb + rb) * nst + ks * per) * 16;
    float g = amax[e] / den[0] * 16384.0f;
    if (tsq && sycl::bit_cast<uint32_t>(g) != 0x7fc12345u) { simd<uint64_t, 1> tv = es::rdtsc(); tv.copy_to(tsq + 5); }  // diagnostic: amax/den arrived
    for (int g0 = 0; g0 < cnt; g0 += 8) {
      int n = cnt - g0 < 8 ? cnt - g0 : 8;
      int32_t ids[8];
      if (g0 == 0) {
#pragma unroll
        for (int r = 0; r < 8; r++) ids[r] = d[2 + r];
      } else {
        for (int r = 0; r < 8; r++) ids[r] = elist[(size_t)e * maxper + g0 + (r < n ? r : 0)];
      }
      if constexpr (R1) {  // T=1: every expert serves exactly one pair; the R=2/4/8 bodies are not instantiated (register pressure, code size)
        moe_fp4_body<KS, 1, NB, PW, PS, LEAN>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, stage, tsq);
      } else {
        if (n <= 1) moe_fp4_body<KS, 1, NB, PW, PS, LEAN>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, stage, tsq);
      else if (n <= 2) moe_fp4_body<KS, 2, NB, PW, PS, LEAN>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, stage, tsq);
      else if (n <= 4) moe_fp4_body<KS, 4, NB, PW, PS, LEAN>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, stage, tsq);
      else moe_fp4_body<KS, 8, (NB > 2 ? 2 : NB), PW, PS, LEAN>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, stage, tsq);
      }
    }
    if (ts) {
      simd<uint64_t, 2> v;
      v[0] = t_start;
      v[1] = es::rdtsc();
      v.copy_to(ts + 8 * hw_gid);
    }
  });
}

// Dynamic-scheduling variant (XIK_DYN=P threads, default off): persistent threads pull (slot, row-block, K-chunk) tasks
// from an atomic counter, so a thread that runs slowly simply takes fewer tasks (the static kernel finishes at its
// slowest thread: per-thread end times spread 46..71 us for a 52 us ideal).  Numerics of each task are those of the
// static kernel with the same KS (fixed K-split, independent of which thread runs it).
uint32_t *g_dyn_cnt = nullptr;
template <int KS, int NB>
void moe_fp4g_dyn(xik_ctx *c, int P, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13,
                  const float *amax, const float *den, int maxper, int maxslots, int rows, int K, float *Y,
                  size_t ystride, int ldy) {
  int nrb = rows / 16, nst = K / 64, per = nst / KS;
  const int32_t *desc = c->desc, *elist = c->elist;
  const uint32_t ntasks = (uint32_t)((size_t)maxslots * nrb * KS);
  if (!g_dyn_cnt) { g_dyn_cnt = sycl::malloc_device<uint32_t>(16, c->q.q); c->q.memset(g_dyn_cnt, 0, 64).wait(); }
  uint32_t *const cnt_p = g_dyn_cnt;
  const uint32_t nthr = (uint32_t)P;
  c->q.parallel_for(nd_range<1>(nthr, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
#define XIK_FETCH() (atomic_update<atomic_op::inc, uint32_t, 1>(cnt_p, simd<uint32_t, 1>(0))[0])
    uint32_t next = XIK_FETCH();
    while (true) {
      uint32_t tk = next;
      if (tk >= ntasks) {
        if (tk == ntasks + nthr - 1) {  // last failing fetch of the last thread: reset for the next launch
          simd<uint32_t, 1> off = 0, z = 0;
          atomic_update<atomic_op::store, uint32_t, 1>(cnt_p, off, z);
        }
        break;
      }
      next = XIK_FETCH();
      int ks = (int)(tk % KS);
      size_t r1 = tk / KS;
      int rb = (int)(r1 % nrb);
      int j = (int)(r1 / nrb);
      simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
      int cnt = d[1];
      if (cnt <= 0) continue;
      int e = d[0];
      const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wp) + (((size_t)e * nrb + rb) * nst + ks * per) * 128;
      const uint32_t *sp = reinterpret_cast<const uint32_t *>(Sp) + (((size_t)e * nrb + rb) * nst + ks * per) * 16;
      float g = amax[e] / den[0] * 16384.0f;
      for (int g0 = 0; g0 < cnt; g0 += 8) {
        int n = cnt - g0 < 8 ? cnt - g0 : 8;
        int32_t ids[8];
        if (g0 == 0) {
#pragma unroll
          for (int r = 0; r < 8; r++) ids[r] = d[2 + r];
        } else {
          for (int r = 0; r < 8; r++) ids[r] = elist[(size_t)e * maxper + g0 + (r < n ? r : 0)];
        }
        if (n <= 1) moe_fp4_body<KS, 1, NB>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, 4);
        else if (n <= 2) moe_fp4_body<KS, 2, NB>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, 4);
        else if (n <= 4) moe_fp4_body<KS, 4, NB>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, 4);
        else moe_fp4_body<KS, 8, (NB > 2 ? 2 : NB)>(wp, sp, X16, ldx, w13, ids, n, per, g, Y, ystride, ldy, rb, ks, 4);
      }
    }
  });
}
int dyn_threads() { static const int v = getenv("XIK_DYN") ? atoi(getenv("XIK_DYN")) : 0; return v; }

// configurations: index -> (K split, pipeline depth). nks = K split (partial-sum buffers).
struct MoeCfg { int ks, nb; };
constexpr MoeCfg MOE_CFGS[] = {{2, 2}, {1, 2}, {4, 2}, {8, 2}, {2, 3}, {2, 4}, {4, 3}, {4, 4}};
constexpr int NMOE_CFG = 8;
// ---------------------------------------------------------------------------------------------------------------------------------
// W3A16 experts (XIK_W3=1): 3-bit codes (q - 4) with fp16 group-64 scales, pre-permuted DPAS layout (see w3_gemv / "FMT 3"): per 16-row block and 128 K one 768 B super-tile = 12 dwords x 16 lanes
// (3 x 256 B), 2 x 32 B... scales [e][rb][K/64][16] fp16.  The outer NVFP4 scale (amax / den) is folded into the fp16 scales, so outputs are natural dot products.
namespace w3m {
using namespace es;
ESIMD_INLINE simd<uint32_t, 16> pair_reg(int rho, const simd<uint32_t, 16> &a, const simd<uint32_t, 16> &b, const simd<uint32_t, 16> &c) {
  const uint32_t M = 0x64006400u;
  if (rho < 15) { const int i = rho / 5, j = rho % 5; const simd<uint32_t, 16> &d = i == 0 ? a : i == 1 ? b : c; return ((j == 0 ? d : (d >> (3 * j))) & 0x00070007u) | M; }
  return (((a >> 15) & 0x00010001u) | ((b >> 14) & 0x00020002u) | ((c >> 13) & 0x00040004u)) | M;
}
}  // namespace w3m
template <int R, int PW, int NB = 2>
ESIMD_INLINE es::simd<float, 16 * R> moe_w3_body(const uint32_t *wp, const uint32_t *sp, const sycl::half *X16, int ldx, bool w13, const int32_t *ids, int cnt, int per, int kofs, size_t wst, size_t sst) {
  using namespace es;
  simd<float, 16 * R> acc = 0.f;
  const uint32_t *xr[R];
#pragma unroll
  for (int r = 0; r < R; r++) { int pp = ids[r < cnt ? r : 0]; xr[r] = reinterpret_cast<const uint32_t *>(X16 + (size_t)(w13 ? pp / TOPK : pp) * ldx + (size_t)kofs * 128); }
  constexpr bool XPRE = R <= 2;  // R >= 4: activations are loaded per 32-K group (register pressure: the T > 1 kernel holds all R bodies)
  simd<uint32_t, 192> wb[NB]; simd<uint32_t, 16> sb[NB]; simd<uint32_t, (XPRE ? 64 * R : 16)> xb[NB];
  auto load = [&](int u, int t) {
    simd<uint32_t, 64> t0 = ldp<PW, 64>(wp + (size_t)t * wst), t1 = ldp<PW, 64>(wp + (size_t)t * wst + 64), t2 = ldp<PW, 64>(wp + (size_t)t * wst + 128);
    wb[u].template select<64, 1>(0) = t0; wb[u].template select<64, 1>(64) = t1; wb[u].template select<64, 1>(128) = t2;
    sb[u] = ldp<0, 16>(sp + (size_t)t * sst);
    if constexpr (XPRE) {
#pragma unroll
      for (int r = 0; r < R; r++) xb[u].template select<64, 1>(64 * r) = block_load<uint32_t, 64>(xr[r] + (size_t)t * 64);
    }
  };
  // loads are issued at the START of the tile that precedes their use by NB - 1 tiles (early issue: the unpack ALU work of tiles t .. t+NB-2 runs under the SENDs in flight)
#pragma unroll
  for (int u = 0; u < NB - 1; u++) if (u < per) load(u, u);
  for (int t0 = 0; t0 < per; t0 += NB) {
#pragma unroll
    for (int u = 0; u < NB; u++) {
      const int t = t0 + u;
      if (t + NB - 1 < per) load((u + NB - 1) % NB, t + NB - 1);
      if (t < per) {
        simd<float, 16 * R> ag = 0.f;
#pragma unroll
        for (int g = 0; g < 4; g++) {
          simd<uint32_t, 16> a = wb[u].template select<16, 1>(48 * g), b = wb[u].template select<16, 1>(48 * g + 16), cc = wb[u].template select<16, 1>(48 * g + 32);
          simd<uint32_t, 256> B;
#pragma unroll
          for (int rho = 0; rho < 16; rho++) B.template select<16, 1>(16 * rho) = w3m::pair_reg(rho, a, b, cc);
          simd<sycl::half, 512> bh = B.template bit_cast_view<sycl::half>();
          bh -= (sycl::half)1028.0f;
          simd<int32_t, 256> bi = bh.template bit_cast_view<int32_t>();
#pragma unroll
          for (int s2 = 0; s2 < 2; s2++) {
            simd<int32_t, 8 * R> av;
            if constexpr (XPRE) {
#pragma unroll
              for (int r = 0; r < R; r++) av.template select<8, 1>(8 * r) = xb[u].template select<8, 1>(64 * r + 16 * g + 8 * s2).template bit_cast_view<int32_t>();
            } else {
#pragma unroll
              for (int r = 0; r < R; r++) av.template select<8, 1>(8 * r) = block_load<int32_t, 8>(reinterpret_cast<const int32_t *>(xr[r]) + (size_t)t * 64 + 16 * g + 8 * s2);
            }
            simd<float, 16 * R> z = 0.f;
            simd<int32_t, 128> bs = bi.template select<128, 1>(128 * s2);
            ag = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(((g & 1) == 0 && s2 == 0) ? z : ag, bs, av);
          }
          if (g & 1) {
            simd<sycl::half, 16> sh = sb[u].template select<8, 1>(8 * (g >> 1)).template bit_cast_view<sycl::half>();
            simd<float, 16> sf = sh;
#pragma unroll
            for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += ag.template select<16, 1>(16 * r) * sf;
          }
        }
      }
    }
  }
  return acc;
}
// reduce the KSD partial accumulators of a work-group (fixed order, thread 0 writes)
template <int R, int KSD>
ESIMD_INLINE void moe_w3_store(es::simd<float, 16 * R> acc, int tid, const int32_t *ids, int cnt, float *Y, size_t ystride, int ldy, int rb) {
  using namespace es;
  if constexpr (KSD > 1) {
    slm_block_store<float, 16 * R>(tid * 16 * R * 4, acc);
    barrier();
    if (tid != 0) { barrier(); return; }
    acc = slm_block_load<float, 16 * R>(0);
    for (int j = 1; j < KSD; j++) acc += slm_block_load<float, 16 * R>(j * 16 * R * 4);
    barrier();
  }
#pragma unroll
  for (int r = 0; r < R; r++)
    if (r < cnt) { simd<float, 16> o = acc.template select<16, 1>(16 * r); o.copy_to(Y + (size_t)ids[r] * ldy + rb * 16); }
}
// one work-group of KSD threads per (slot, 16-row block); each thread streams K/128/KSD tiles; K = 1 partial for the downstream kernels
template <bool R1, int KSD, int NB = 2>
void moe_w3g_t(xik_ctx *c, const uint32_t *Wp, const uint32_t *Sp, const sycl::half *X16, int ldx, bool w13, int maxper, int maxslots, int rows, int K, float *Y, size_t ystride, int ldy) {
  const int nrb = rows / 16, ntile = K / 128, per = ntile / KSD;
  const bool tm = !getenv("XIK_W3TM") || atoi(getenv("XIK_W3TM")) != 0;  // tile-major weight layout: [expert][tile][row block]
  const int32_t *desc = c->desc, *elist = c->elist;
  const size_t nthreads = (size_t)maxslots * nrb * KSD;
  c->q.parallel_for(nd_range<1>(nthreads, KSD == 1 ? expert_lws() : KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    if constexpr (KSD > 1) slm_init<KSD * 16 * 8 * 4>();
    const size_t gid = it.get_global_id(0);
    const int tid = (int)(gid % KSD); const size_t wg = gid / KSD;
    const int rb = (int)(wg % nrb), j = (int)(wg / nrb);
    simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
    const int cnt = d[1];
    if (cnt <= 0) return;
    const int e = d[0];
    const size_t wst = tm ? (size_t)nrb * 192 : 192, sst = tm ? (size_t)nrb * 16 : 16;
    const uint32_t *wp = tm ? Wp + (((size_t)e * ntile + (size_t)tid * per) * nrb + rb) * 192 : Wp + (((size_t)e * nrb + rb) * ntile + (size_t)tid * per) * 192;
    const uint32_t *sp = tm ? Sp + (((size_t)e * ntile + (size_t)tid * per) * nrb + rb) * 16 : Sp + (((size_t)e * nrb + rb) * ntile + (size_t)tid * per) * 16;
    const int kofs = tid * per;
    for (int g0 = 0; g0 < cnt; g0 += 8) {
      const int n = cnt - g0 < 8 ? cnt - g0 : 8;
      int32_t ids[8];
      if (g0 == 0) {
#pragma unroll
        for (int r = 0; r < 8; r++) ids[r] = d[2 + r];
      } else {
        for (int r = 0; r < 8; r++) ids[r] = elist[(size_t)e * maxper + g0 + (r < n ? r : 0)];
      }
      if constexpr (R1) moe_w3_store<1, KSD>(moe_w3_body<1, 5, NB>(wp, sp, X16, ldx, w13, ids, n, per, kofs, wst, sst), tid, ids, n, Y, ystride, ldy, rb);
      else {
        if (n <= 1) moe_w3_store<1, KSD>(moe_w3_body<1, 5, NB>(wp, sp, X16, ldx, w13, ids, n, per, kofs, wst, sst), tid, ids, n, Y, ystride, ldy, rb);
        else if (n <= 2) moe_w3_store<2, KSD>(moe_w3_body<2, 5>(wp, sp, X16, ldx, w13, ids, n, per, kofs, wst, sst), tid, ids, n, Y, ystride, ldy, rb);
        else if (n <= 4) moe_w3_store<4, KSD>(moe_w3_body<4, 5>(wp, sp, X16, ldx, w13, ids, n, per, kofs, wst, sst), tid, ids, n, Y, ystride, ldy, rb);
        else moe_w3_store<8, KSD>(moe_w3_body<8, 5>(wp, sp, X16, ldx, w13, ids, n, per, kofs, wst, sst), tid, ids, n, Y, ystride, ldy, rb);
      }
    }
  });
}
void moe_w3g(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13, int maxper, int maxslots, int rows, int K, float *Y, size_t ystride, int ldy) {
  static const int ksd_env = getenv("XIK_W3KSD") ? atoi(getenv("XIK_W3KSD")) : 1;  // threads per (slot, row block): 1, 3 or 9 (must divide K/128: 18 or 9)
  const uint32_t *W = (const uint32_t *)Wp, *S = (const uint32_t *)Sp;
  const int ntile = K / 128; const int ksd = (ntile % ksd_env == 0) ? ksd_env : 1;
  static const int nb_env = getenv("XIK_W3NB") ? atoi(getenv("XIK_W3NB")) : 2;
#define W3G(KS) if (ksd == KS) { if (maxper <= 1) { if (nb_env == 3) return moe_w3g_t<true, KS, 3>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); if (nb_env == 6) return moe_w3g_t<true, KS, 6>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); if (nb_env == 8) return moe_w3g_t<true, KS, 8>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); if (nb_env == 4) return moe_w3g_t<true, KS, 4>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); return moe_w3g_t<true, KS, 2>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); } return moe_w3g_t<false, KS, 2>(c, W, S, X16, ldx, w13, maxper, maxslots, rows, K, Y, ystride, ldy); }
  W3G(3) W3G(9) W3G(1)
#undef W3G
}

// Quantise one NVFP4 expert tensor into the W3 layout (group 64, symmetric codes q = round(w / s) + 4 in 0..7, fp16 scale from a squared-error clipping search).
// raw nibbles [e][row][K/2], raw e4m3 scales [e][row][K/16], outer scale amax[e] / den[0] (natural weight = e2m1 * e4m3 * amax / den).
static void k_w3pack(xik_ctx *c, const uint8_t *raw, const uint8_t *sraw, const float *amax, const float *den, int rows, int K, uint32_t *W, uint16_t *S, int NC) {
  const bool tm = !getenv("XIK_W3TM") || atoi(getenv("XIK_W3TM")) != 0;
  const int nrb = rows / 16, ntile = K / 128;
  c->q.parallel_for(range<1>((size_t)NE * nrb * ntile * 16), [=](id<1> id) {
    size_t i = id[0];
    const int n = (int)(i % 16); size_t t = i / 16;
    const int tt = (int)(t % ntile); t /= ntile;
    const int rb = (int)(t % nrb); const int e = (int)(t / nrb);
    const size_t row = (size_t)e * rows + rb * 16 + n;
    const float outer = amax[e] / den[0];
    static const float lv[8] = {0.f, 0.5f, 1.f, 1.5f, 2.f, 3.f, 4.f, 6.f};
    uint32_t d[12] = {0};
    for (int gi = 0; gi < 2; gi++) {
      float v[64]; float amx = 0.f;
      for (int k = 0; k < 64; k++) {
        const int kk = tt * 128 + gi * 64 + k;
        uint32_t byte = raw[row * (K / 2) + kk / 2]; uint32_t nib = (kk & 1) ? (byte >> 4) : (byte & 15);
        float x = lv[nib & 7] * ((nib & 8) ? -1.f : 1.f) * e4m3_dec(sraw[row * (K / 16) + kk / 16] & 0x7F) * outer;
        v[k] = x; amx = sycl::fmax(amx, sycl::fabs(x));
      }
      float best = 1e30f, bs = amx / 3.f;
      for (int cd = 0; cd < NC; cd++) {
        float s2 = (float)(sycl::half)(amx * (1.f - 0.05f * cd) / 3.f); if (s2 <= 0.f) break;
        float e2 = 0.f;
        for (int k = 0; k < 64; k++) { float q = sycl::fmin(3.f, sycl::fmax(-4.f, sycl::rint(v[k] / s2))); float dd = v[k] - q * s2; e2 += dd * dd; }
        if (e2 < best) { best = e2; bs = s2; }
      }
      S[(tm ? ((((size_t)e * ntile + tt) * nrb + rb) * 2 + gi) : ((size_t)(e * nrb + rb) * (K / 64) + tt * 2 + gi)) * 16 + n] = sycl::bit_cast<uint16_t>((sycl::half)bs);
      for (int h2 = 0; h2 < 2; h2++) {
        uint32_t *w = d + 3 * (gi * 2 + h2);
        for (int rho = 0; rho < 16; rho++)
          for (int h = 0; h < 2; h++) {
            const int k = h2 * 32 + 2 * rho + h;
            uint32_t qv = bs > 0.f ? (uint32_t)(sycl::fmin(3.f, sycl::fmax(-4.f, sycl::rint(v[k] / bs))) + 4.f) : 4u;
            if (rho < 15) w[rho / 5] |= qv << (3 * (rho % 5) + 16 * h);
            else for (int b = 0; b < 3; b++) w[b] |= ((qv >> b) & 1u) << (15 + 16 * h);
          }
      }
    }
    for (int dd = 0; dd < 12; dd++) W[(tm ? (((size_t)e * ntile + tt) * nrb + rb) : (((size_t)e * nrb + rb) * ntile + tt)) * 192 + dd * 16 + n] = d[dd];
  });
}

void moe_fp4g(xik_ctx *c, int cfg, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13,
              const float *amax, const float *den, int maxper, int maxslots, int rows, int K, float *Y, size_t ystride,
              int ldy) {
  {
    static const int pol_all = [] { const char *e = getenv("XIK_LSC_POL"); if (!e) return 5 * 16 + 0; /* default: weights L1-streaming + L2-uncached */ int w = 0, sc = 0; sscanf(e, "%d,%d", &w, &sc); return w * 16 + sc; }();
    static const int pol13 = [] { const char *e = getenv("XIK_LSC_POL13"); if (!e) return -1; int w = 0, sc = 0; sscanf(e, "%d,%d", &w, &sc); return w * 16 + sc; }();
    static const int pol2 = [] { const char *e = getenv("XIK_LSC_POL2"); if (!e) return -1; int w = 0, sc = 0; sscanf(e, "%d,%d", &w, &sc); return w * 16 + sc; }();
    const int pol = (w13 ? pol13 : pol2) >= 0 ? (w13 ? pol13 : pol2) : pol_all;
    static const bool lean_on = !getenv("XIK_FP4_LEAN") || atoi(getenv("XIK_FP4_LEAN")) != 0;  // XIK_FP4_LEAN=0: diagnostic-capable kernel
    static const bool diag_env = getenv("XIK_FP4_STAGE") || getenv("XIK_PERM");  // diagnostic switches need the full kernel
    if (lean_on && !diag_env && !g_ts && cfg == 1 && !dyn_threads()) {
      if (maxper <= 1) {  // T=1: an expert serves at most one pair, so only the R=1 body is needed
        if (pol == 5 * 16) return moe_fp4g_t<1, 2, 5, 0, true, true>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
        if (pol == 0) return moe_fp4g_t<1, 2, 0, 0, true, true>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
      }
      if (pol == 5 * 16) return moe_fp4g_t<1, 2, 5, 0, true>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
      if (pol == 0) return moe_fp4g_t<1, 2, 0, 0, true>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
    }
    if (pol != 0 && cfg == 1) {
#define PC(W, S) case (W) * 16 + (S): return moe_fp4g_t<1, 2, W, S>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
      switch (pol) {
        PC(1, 0) PC(2, 0) PC(3, 0) PC(4, 0) PC(5, 0) PC(0, 1) PC(0, 2) PC(0, 3) PC(1, 1) PC(2, 2) PC(2, 3) PC(1, 3) PC(4, 4) PC(5, 1) PC(5, 2) PC(5, 3) PC(5, 5) PC(1, 5) PC(1, 2) PC(0, 5) PC(6, 0) PC(7, 0) PC(8, 0) PC(6, 1) PC(7, 1) PC(7, 2) PC(5, 6) PC(2, 1)
        default: break;
      }
#undef PC
    }
  }
  if (dyn_threads() > 0) {
    if (cfg == 1) return moe_fp4g_dyn<1, 2>(c, dyn_threads(), Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
    if (cfg == 0) return moe_fp4g_dyn<2, 2>(c, dyn_threads(), Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
    if (cfg == 2) return moe_fp4g_dyn<4, 2>(c, dyn_threads(), Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
    if (cfg == 3) return moe_fp4g_dyn<8, 2>(c, dyn_threads(), Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
  }
#define MC(I, KS, NB) if (cfg == I) return moe_fp4g_t<KS, NB>(c, Wp, Sp, X16, ldx, w13, amax, den, maxper, maxslots, rows, K, Y, ystride, ldy);
  MC(0, 2, 2) MC(1, 1, 2) MC(2, 4, 2) MC(3, 8, 2) MC(4, 2, 3) MC(5, 2, 4) MC(6, 4, 3) MC(7, 4, 4)
#undef MC
  throw std::runtime_error("bad moe cfg");
}

// ================================================================ MXFP8 DPAS path (layers 20-23)
// Raw: W[e][row][K] e4m3 bytes, scale S[e][row][K/32] ue8m0.  Repacked once into DPAS tiles:
//   Wt[e][rb16][st64][t=4][q=4][lane=16] dwords: bytes [k0,k2,k1,k3] of elements 4q..4q+3 of tile t (K = st*64 + 16*t)
//   St[e][rb][st][blk=2][lane=16] bytes: scale of K block 32*blk.
// A 32-element block spans two 16-wide tiles: both DPAS accumulate into the same register, then the block scale
// 2^(s-127) (times 2^8, undoing the fp16 bit trick) is applied once.
void k_repack_mxfp8(xik_ctx *c, const uint8_t *raw, uint32_t *dst, const uint8_t *sraw, uint8_t *sdst, int rows, int K) {
  int nrb = rows / 16, nst = K / 64;
  const bool tm = !getenv("XIK_F8TM") || atoi(getenv("XIK_F8TM")) != 0;
  size_t items = (size_t)NE * nrb * nst * 16;
  c->q.parallel_for(range<1>(items), [=](id<1> id) {
    size_t i = id[0];
    int n = (int)(i % 16);
    size_t t = i / 16;
    int st = (int)(t % nst);
    t /= nst;
    int rb = (int)(t % nrb);
    int e = (int)(t / nrb);
    size_t row = (size_t)e * rows + rb * 16 + n;
    uint32_t *wd = dst + (tm ? (((size_t)e * nst + st) * nrb + rb) : (((size_t)e * nrb + rb) * nst + st)) * 256;
    for (int tl = 0; tl < 4; tl++)
      for (int q = 0; q < 4; q++) {
        uint32_t w = *reinterpret_cast<const uint32_t *>(raw + row * K + (size_t)st * 64 + tl * 16 + 4 * q);
        uint32_t e0 = w & 0xFF, e1 = (w >> 8) & 0xFF, e2 = (w >> 16) & 0xFF, e3 = w >> 24;
        wd[(tl * 4 + q) * 16 + n] = e0 | (e2 << 8) | (e1 << 16) | (e3 << 24);
      }
    uint8_t *sd = sdst + (tm ? (((size_t)e * nst + st) * nrb + rb) : (((size_t)e * nrb + rb) * nst + st)) * 32;
    for (int b = 0; b < 2; b++) sd[b * 16 + n] = sraw[row * (K / 32) + st * 2 + b];
  });
}

inline es::simd<uint32_t, 16> fp8_pair(es::simd<uint32_t, 16> m) {
  return ((m & 0x007F007Fu) << 7) | ((m & 0x00800080u) << 8);
}

template <int R, int NB, int PF, int PW = 0, int PS = 0>
ESIMD_INLINE void moe_fp8_body(const uint32_t *wp, const uint32_t *sp, const sycl::half *X16, int ldx, bool w13,
                               const int32_t *ids, int cnt, int nst, float *Y, int ldy, int rb, size_t wst = 256, size_t sst = 8) {
  using namespace es;
  simd<float, 16 * R> acc = 0.f;
  const uint32_t *xr[R];
#pragma unroll
  for (int r = 0; r < R; r++) {
    int p = ids[r < cnt ? r : 0];
    xr[r] = reinterpret_cast<const uint32_t *>(X16 + (size_t)(w13 ? p / TOPK : p) * ldx);
  }
  simd<uint32_t, 256> wb[NB];
  simd<uint32_t, 8> sb[NB];
  simd<uint32_t, 32 * R> xb[NB];
  auto load = [&](int u, int s) {
#pragma unroll
    for (int h = 0; h < 4; h++) {
      simd<uint32_t, 64> t0 = ldp<PW, 64>(wp + (size_t)s * wst + h * 64);
      wb[u].template select<64, 1>(64 * h) = t0;
    }
    sb[u] = ldp<PS, 8>(sp + (size_t)s * sst);
#pragma unroll
    for (int r = 0; r < R; r++) xb[u].template select<32, 1>(32 * r) = block_load<uint32_t, 32>(xr[r] + (size_t)s * 32);
  };
#pragma unroll
  for (int u = 0; u < NB; u++)
    if (u < nst) load(u, u);
  if constexpr (PF > 0) {
#pragma unroll
    for (int d = 0; d < PF; d++)
      if (d < nst) {
        for (int h = 0; h < 4; h++) prefetch<uint32_t, 64>(wp + (size_t)(d + NB) * wst + h * 64, sycl::ext::oneapi::experimental::properties{es::cache_hint_L1<es::cache_hint::cached>, es::cache_hint_L2<es::cache_hint::cached>});
      }
  }
  for (int s0 = 0; s0 < nst; s0 += NB) {
#pragma unroll
    for (int u = 0; u < NB; u++) {
      int s = s0 + u;
      if (s < nst) {
        simd<uint8_t, 32> s8 = sb[u].template bit_cast_view<uint8_t>();
#pragma unroll
        for (int blk = 0; blk < 2; blk++) {
          simd<float, 16 * R> res = 0.f;
#pragma unroll
          for (int th = 0; th < 2; th++) {
            int t = blk * 2 + th;
            simd<uint32_t, 128> B;
#pragma unroll
            for (int q = 0; q < 4; q++) {
              simd<uint32_t, 16> xq = wb[u].template select<16, 1>(64 * t + 16 * q);
              simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
              B.template select<16, 1>(16 * (2 * q)) = fp8_pair(m0);
              B.template select<16, 1>(16 * (2 * q + 1)) = fp8_pair(m1);
            }
            simd<int32_t, 8 * R> a;
#pragma unroll
            for (int r = 0; r < R; r++) a.template select<8, 1>(8 * r) = xb[u].template select<8, 1>(32 * r + 8 * t).template bit_cast_view<int32_t>();
            simd<int32_t, 128> Bi = B.template bit_cast_view<int32_t>();
            res = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                            xmx::dpas_argument_type::fp16>(res, Bi, a);
          }
          simd<uint8_t, 16> sc8 = s8.template select<16, 1>(16 * blk);
          simd<uint32_t, 16> sw = convert<uint32_t>(sc8);
          simd<uint32_t, 16> sbits = (sw + 8u) << 23;  // 2^(s - 127) * 2^8
          simd<float, 16> sc = sbits.template bit_cast_view<float>();
#pragma unroll
          for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += res.template select<16, 1>(16 * r) * sc;
        }
        if constexpr (PF > 0) {
          if (s + NB + PF < nst) {
#pragma unroll
            for (int h = 0; h < 4; h++) prefetch<uint32_t, 64>(wp + (size_t)(s + NB + PF) * wst + h * 64, sycl::ext::oneapi::experimental::properties{es::cache_hint_L1<es::cache_hint::cached>, es::cache_hint_L2<es::cache_hint::cached>});
          }
        }
        if (s + NB < nst) load(u, s + NB);
      }
    }
  }
#pragma unroll
  for (int r = 0; r < R; r++)
    if (r < cnt) {
      simd<float, 16> o = acc.template select<16, 1>(16 * r);
      o.copy_to(Y + (size_t)ids[r] * ldy + rb * 16);
    }
}


// Split variant: the 1 KB supertile is loaded as two 512 B halves (tiles 0-1 = scale block 0, tiles 2-3 = block 1).
// Block 0 is unpacked and multiplied while block 1 is still arriving; no extra register buffer (same 1 KB as NB=1).
template <int R>
ESIMD_INLINE void moe_fp8_body_split(const uint32_t *wp, const uint32_t *sp, const sycl::half *X16, int ldx, bool w13,
                                     const int32_t *ids, int cnt, int nst, float *Y, int ldy, int rb, size_t wst = 256, size_t sst = 8) {
  using namespace es;
  simd<float, 16 * R> acc = 0.f;
  const uint32_t *xr[R];
#pragma unroll
  for (int r = 0; r < R; r++) {
    int p = ids[r < cnt ? r : 0];
    xr[r] = reinterpret_cast<const uint32_t *>(X16 + (size_t)(w13 ? p / TOPK : p) * ldx);
  }
  simd<uint32_t, 128> wh[2];       // wh[blk]: the two tiles of scale block blk
  simd<uint32_t, 8> sbuf;
  simd<uint32_t, 32 * R> xb;
  auto load_half = [&](int blk, int s) {
    wh[blk].template select<64, 1>(0) = block_load<uint32_t, 64>(wp + (size_t)s * wst + blk * 128);
    wh[blk].template select<64, 1>(64) = block_load<uint32_t, 64>(wp + (size_t)s * wst + blk * 128 + 64);
  };
  auto consume = [&](int blk) {
    simd<uint8_t, 32> s8 = sbuf.template bit_cast_view<uint8_t>();
    simd<float, 16 * R> res = 0.f;
#pragma unroll
    for (int th = 0; th < 2; th++) {
      simd<uint32_t, 128> B;
#pragma unroll
      for (int q = 0; q < 4; q++) {
        simd<uint32_t, 16> xq = wh[blk].template select<16, 1>(64 * th + 16 * q);
        simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
        B.template select<16, 1>(16 * (2 * q)) = fp8_pair(m0);
        B.template select<16, 1>(16 * (2 * q + 1)) = fp8_pair(m1);
      }
      simd<int32_t, 8 * R> a;
#pragma unroll
      for (int r = 0; r < R; r++) a.template select<8, 1>(8 * r) = xb.template select<8, 1>(32 * r + 8 * (blk * 2 + th)).template bit_cast_view<int32_t>();
      simd<int32_t, 128> Bi = B.template bit_cast_view<int32_t>();
      res = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(res, Bi, a);
    }
    simd<uint8_t, 16> sc8 = s8.template select<16, 1>(16 * blk);
    simd<uint32_t, 16> sw = convert<uint32_t>(sc8);
    simd<uint32_t, 16> sbits = (sw + 8u) << 23;
    simd<float, 16> sc = sbits.template bit_cast_view<float>();
#pragma unroll
    for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += res.template select<16, 1>(16 * r) * sc;
  };
  for (int s = 0; s < nst; s++) {
    load_half(0, s);
    sbuf = block_load<uint32_t, 8>(sp + (size_t)s * sst);
#pragma unroll
    for (int r = 0; r < R; r++) xb.template select<32, 1>(32 * r) = block_load<uint32_t, 32>(xr[r] + (size_t)s * 32);
    load_half(1, s);   // issued before block 0 is consumed: its latency overlaps the unpack + DPAS of block 0
    consume(0);
    consume(1);
  }
#pragma unroll
  for (int r = 0; r < R; r++)
    if (r < cnt) {
      simd<float, 16> o = acc.template select<16, 1>(16 * r);
      o.copy_to(Y + (size_t)ids[r] * ldy + rb * 16);
    }
}

// K split of the MXFP8 expert kernel: one value for every T (results are batch-invariant). Valid: 1,2,3,6 (18 and 36 supertiles).
static int fp8_ks() { static const int v = getenv("XIK_FP8_KS") ? atoi(getenv("XIK_FP8_KS")) : 2; return v; }
// Kernel variants that differ only in register/pipeline structure (identical arithmetic order => bit-identical results):
//   0: 128 GRF, NB=2   1: 128 GRF, NB=1   2: 256 GRF, NB=2   3: 256 GRF, NB=1
static int fp8_pf() { static const int v = getenv("XIK_FP8_PF") ? atoi(getenv("XIK_FP8_PF")) : 0; return v; }
static int fp8_cfg() { static const int v = getenv("XIK_FP8_CFG") ? atoi(getenv("XIK_FP8_CFG")) : 1; return v; }

template <int NB, bool G256, int PF = 0, int PW = 0, int PS = 0>
void moe_fp8g_t(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13, int maxper,
                int maxslots, int rows, int K, float *Y, int ldy, size_t ystride) {
  const int KSV = fp8_ks();
  int nrb = rows / 16, nst = K / 64, per = nst / KSV;
  const bool tm = !getenv("XIK_F8TM") || atoi(getenv("XIK_F8TM")) != 0;  // tile-major layout [expert][supertile][row block]
  const int32_t *desc = c->desc, *elist = c->elist;
  size_t nthreads = (size_t)maxslots * nrb * KSV;
  auto kernel = [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    size_t gid = it.get_global_id(0);
    int ks = (int)(gid % KSV);
    size_t r1 = gid / KSV;
    int rb = (int)(r1 % nrb);
    int j = (int)(r1 / nrb);
    simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
    int cnt = d[1];
    if (cnt <= 0) return;
    int e = d[0];
    const size_t wst = tm ? (size_t)nrb * 256 : 256, sst = tm ? (size_t)nrb * 8 : 8;
    const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wp) + (tm ? (((size_t)e * nst + ks * per) * nrb + rb) : (((size_t)e * nrb + rb) * nst + ks * per)) * 256;
    const uint32_t *sp = reinterpret_cast<const uint32_t *>(Sp) + (tm ? (((size_t)e * nst + ks * per) * nrb + rb) : (((size_t)e * nrb + rb) * nst + ks * per)) * 8;
    const sycl::half *xs = X16 + (size_t)ks * per * 64;
    float *Yk = Y + (size_t)ks * ystride;
    for (int g0 = 0; g0 < cnt; g0 += 8) {
      int n = cnt - g0 < 8 ? cnt - g0 : 8;
      int32_t ids[8];
      if (g0 == 0) {
#pragma unroll
        for (int r = 0; r < 8; r++) ids[r] = d[2 + r];
      } else {
        for (int r = 0; r < 8; r++) ids[r] = elist[(size_t)e * maxper + g0 + (r < n ? r : 0)];
      }
      if constexpr (NB == 0) {
        if (n <= 1) moe_fp8_body_split<1>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else if (n <= 2) moe_fp8_body_split<2>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else if (n <= 4) moe_fp8_body_split<4>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else moe_fp8_body_split<8>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
      } else {
        if (n <= 1) moe_fp8_body<1, NB, PF, PW, PS>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else if (n <= 2) moe_fp8_body<2, NB, PF, PW, PS>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else if (n <= 4) moe_fp8_body<4, NB, PF, PW, PS>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
        else moe_fp8_body<8, NB, PF, PW, PS>(wp, sp, xs, ldx, w13, ids, n, per, Yk, ldy, rb, wst, sst);
      }
    }
  };
  if constexpr (G256) {
    sycl::ext::oneapi::experimental::properties props{sycl::ext::intel::experimental::grf_size<256>};
    c->q.parallel_for(nd_range<1>(nthreads, expert_lws()), props, kernel);
  } else {
    c->q.parallel_for(nd_range<1>(nthreads, expert_lws()), kernel);
  }
}
void moe_fp8g(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, int ldx, bool w13, int maxper,
              int maxslots, int rows, int K, float *Y, int ldy, size_t ystride) {
  {
    static const int fpol = [] { const char *e = getenv("XIK_FP8E_POL"); if (!e) return 0; int w = 0, sc = 0; sscanf(e, "%d,%d", &w, &sc); return w * 16 + sc; }();
    if (fpol != 0 && fp8_cfg() == 1 && fp8_pf() == 0) {
#define FC(W, S) case (W) * 16 + (S): return moe_fp8g_t<1, false, 0, W, S>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
      switch (fpol) { FC(1, 0) FC(2, 0) FC(3, 0) FC(5, 0) FC(6, 0) FC(0, 1) FC(0, 2) FC(1, 1) FC(5, 1) FC(2, 2) default: break; }
#undef FC
    }
  }
  if (fp8_cfg() == 1 && fp8_pf() == 1) return moe_fp8g_t<1, false, 1>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
  if (fp8_cfg() == 1 && fp8_pf() == 2) return moe_fp8g_t<1, false, 2>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
  switch (fp8_cfg()) {
    case 1: return moe_fp8g_t<1, false>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
    case 2: return moe_fp8g_t<2, true>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
    case 3: return moe_fp8g_t<1, true>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
    case 4: return moe_fp8g_t<0, false>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);  // split halves
    default: return moe_fp8g_t<2, false>(c, Wp, Sp, X16, ldx, w13, maxper, maxslots, rows, K, Y, ldy, ystride);
  }
}

// ================================================================ INT8 DPAS path for MXFP8 layers (XIK_INT8=1, lossy)
// The MXFP8 weights are re-quantised once at load into signed 8-bit integers with one bf16 scale per (row, 32-element
// block):  q = clamp(rint(w / s), -127, 127),  s = bf16(max|w| / 127)  (measured error ~0.55% RMS, about 1/7 of the e4m3
// rounding itself).  The integers are DPAS B operands as they are (no unpacking at run time).
// Activations are quantised per token to int16 (scale max|x| / 32767) and split in a signed high and an unsigned low
// byte plane; both planes go through s8/u8 DPAS and  acc = hi * 256 + lo.
//   Wi[e][rb16][kb32][r=8][n=16] dwords: dword (r, n) = bytes q[n][32*kb + 4r .. 4r+3]
//   Si[e][rb16][kb32][n=16]      bf16 scales
void k_requant_int8(xik_ctx *c, const uint8_t *raw, const uint8_t *sraw, uint32_t *dst, uint16_t *sdst, int rows, int K) {
  int nrb = rows / 16, nkb = K / 32;
  size_t items = (size_t)NE * nrb * nkb * 16;
  c->q.parallel_for(range<1>(items), [=](id<1> id) {
    size_t i = id[0];
    int n = (int)(i % 16);
    size_t t = i / 16;
    int kb = (int)(t % nkb);
    t /= nkb;
    int rb = (int)(t % nrb);
    int e = (int)(t / nrb);
    size_t row = (size_t)e * rows + rb * 16 + n;
    float scl = sycl::bit_cast<float>((uint32_t)sraw[row * nkb + kb] << 23);  // 2^(s-127)
    float w[32], mx = 0.f;
    for (int k = 0; k < 32; k++) {
      uint32_t b = raw[row * K + (size_t)kb * 32 + k];
      w[k] = e4m3(b) * scl;
      mx = sycl::fmax(mx, sycl::fabs(w[k]));
    }
    float sc = rbf(mx / 127.0f);
    if (sc == 0.f) sc = 1.0f;
    float inv = 1.0f / sc;
    uint32_t *wd = dst + (((size_t)e * nrb + rb) * nkb + kb) * 128;
    for (int r = 0; r < 8; r++) {
      uint32_t word = 0;
      for (int j = 0; j < 4; j++) {
        int q = (int)sycl::rint(w[4 * r + j] * inv);
        q = sycl::clamp(q, -127, 127);
        word |= (uint32_t)(q & 0xFF) << (8 * j);
      }
      wd[r * 16 + n] = word;
    }
    sdst[(((size_t)e * nrb + rb) * nkb + kb) * 16 + n] = (uint16_t)(sycl::bit_cast<uint32_t>(sc) >> 16);
  });
}

// per token: int16 quantisation of x (bf16-valued fp32): hi (s8) and lo (u8) byte planes, scale sx = max|x| / 32767
void k_quant_act16(xik_ctx *c, const float *x, int ldx, int K, int rows, int8_t *hi, uint8_t *lo, float *sx) {
  c->q.parallel_for(nd_range<1>((size_t)rows * 256, 256), [=](nd_item<1> it) {
    int r = it.get_group(0), l = it.get_local_id(0);
    float mx = 0.f;
    for (int k = l; k < K; k += 256) mx = sycl::fmax(mx, sycl::fabs(x[(size_t)r * ldx + k]));
    mx = reduce_over_group(it.get_group(), mx, maximum<float>());
    float s = mx > 0.f ? mx / 32767.0f : 1.0f;
    float inv = 1.0f / s;
    if (l == 0) sx[r] = s;
    for (int k = l; k < K; k += 256) {
      int q = (int)sycl::rint(x[(size_t)r * ldx + k] * inv);
      q = sycl::clamp(q, -32767, 32767);
      hi[(size_t)r * K + k] = (int8_t)(q >> 8);  // arithmetic shift: floor(q / 256)
      lo[(size_t)r * K + k] = (uint8_t)(q & 0xFF);
    }
  });
}

template <int R>
ESIMD_INLINE void moe_i8_body(const uint32_t *wp, const uint16_t *sp, const int8_t *xhi, const uint8_t *xlo, const float *sxp,
                              int Kx, bool w13, const int32_t *ids, int cnt, int nkb, float *Y, int ldy, int rb) {
  using namespace es;
  simd<float, 16 * R> acc = 0.f;
  const uint32_t *hr[R], *lr[R];
  float sx[R];
#pragma unroll
  for (int r = 0; r < R; r++) {
    int p = ids[r < cnt ? r : 0];
    int row = w13 ? p / TOPK : p;
    hr[r] = reinterpret_cast<const uint32_t *>(xhi + (size_t)row * Kx);
    lr[r] = reinterpret_cast<const uint32_t *>(xlo + (size_t)row * Kx);
    sx[r] = sxp[row];
  }
  for (int kb = 0; kb < nkb; kb++) {
    simd<uint32_t, 128> B = block_load<uint32_t, 128>(wp + (size_t)kb * 128);
    simd<uint16_t, 16> sb16 = block_load<uint16_t, 16>(sp + (size_t)kb * 16);
    simd<uint32_t, 16> sbits = convert<uint32_t>(sb16) << 16;
    simd<float, 16> sc = sbits.template bit_cast_view<float>();
    simd<int32_t, 8 * R> ah, al;
#pragma unroll
    for (int r = 0; r < R; r++) {
      simd<uint32_t, 8> h8 = block_load<uint32_t, 8>(hr[r] + (size_t)kb * 8);
      simd<uint32_t, 8> l8 = block_load<uint32_t, 8>(lr[r] + (size_t)kb * 8);
      ah.template select<8, 1>(8 * r) = h8.template bit_cast_view<int32_t>();
      al.template select<8, 1>(8 * r) = l8.template bit_cast_view<int32_t>();
    }
    simd<int32_t, 128> Bi = B.template bit_cast_view<int32_t>();
    simd<int32_t, 16 * R> z = 0;
    simd<int32_t, 16 * R> rh = xmx::dpas<8, R, int32_t, int32_t, int32_t, int32_t, xmx::dpas_argument_type::s8, xmx::dpas_argument_type::s8>(z, Bi, ah);
    simd<int32_t, 16 * R> rl = xmx::dpas<8, R, int32_t, int32_t, int32_t, int32_t, xmx::dpas_argument_type::s8, xmx::dpas_argument_type::u8>(z, Bi, al);
    simd<float, 16 * R> f = convert<float>(rh) * 256.0f + convert<float>(rl);
#pragma unroll
    for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += f.template select<16, 1>(16 * r) * sc;
  }
#pragma unroll
  for (int r = 0; r < R; r++)
    if (r < cnt) {
      simd<float, 16> o = acc.template select<16, 1>(16 * r) * sx[r];
      o.copy_to(Y + (size_t)ids[r] * ldy + rb * 16);
    }
}

void moe_i8g(xik_ctx *c, const uint8_t *Wi, const uint8_t *Si, const int8_t *xhi, const uint8_t *xlo, const float *sx, int Kx,
             bool w13, int maxper, int maxslots, int rows, int K, float *Y, int ldy) {
  int nrb = rows / 16, nkb = K / 32;
  const int32_t *desc = c->desc, *elist = c->elist;
  size_t nthreads = (size_t)maxslots * nrb;
  c->q.parallel_for(nd_range<1>(nthreads, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    size_t gid = it.get_global_id(0);
    int rb = (int)(gid % nrb);
    int j = (int)(gid / nrb);
    simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
    int cnt = d[1];
    if (cnt <= 0) return;
    int e = d[0];
    const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wi) + ((size_t)e * nrb + rb) * nkb * 128;
    const uint16_t *sp = reinterpret_cast<const uint16_t *>(Si) + ((size_t)e * nrb + rb) * nkb * 16;
    for (int g0 = 0; g0 < cnt; g0 += 8) {
      int n = cnt - g0 < 8 ? cnt - g0 : 8;
      int32_t ids[8];
      if (g0 == 0) {
#pragma unroll
        for (int r = 0; r < 8; r++) ids[r] = d[2 + r];
      } else {
        for (int r = 0; r < 8; r++) ids[r] = elist[(size_t)e * maxper + g0 + (r < n ? r : 0)];
      }
      if (n <= 1) moe_i8_body<1>(wp, sp, xhi, xlo, sx, Kx, w13, ids, n, nkb, Y, ldy, rb);
      else if (n <= 2) moe_i8_body<2>(wp, sp, xhi, xlo, sx, Kx, w13, ids, n, nkb, Y, ldy, rb);
      else if (n <= 4) moe_i8_body<4>(wp, sp, xhi, xlo, sx, Kx, w13, ids, n, nkb, Y, ldy, rb);
      else moe_i8_body<8>(wp, sp, xhi, xlo, sx, Kx, w13, ids, n, nkb, Y, ldy, rb);
    }
  });
}
static bool use_int8() { static const bool v = getenv("XIK_INT8") != nullptr; return v; }

void k_cvt_f16(xik_ctx *c, const float *x, sycl::half *y, size_t n) {
  if (abl_mask() & 16) return;
  c->q.parallel_for(range<1>(n), [=](id<1> i) { y[i[0]] = (sycl::half)x[i[0]]; });
}

// ------------------------------------------------------------ elementwise
void k_embed(xik_ctx *c, int T) {
  const int32_t *ids = c->ids_d;
  const uint16_t *emb = c->embed, *nw = c->embed_norm;
  float *out = c->stream;
  c->q.parallel_for(nd_range<1>((size_t)T * 256, 256), [=](nd_item<1> it) {
    int t = it.get_group(0), l = it.get_local_id(0);
    const uint16_t *row = emb + (size_t)ids[t] * D;
    float v[9], ss = 0.f;
    for (int i = 0; i < 9; i++) { v[i] = bf2f(row[l + i * 256]); ss += v[i] * v[i]; }
    ss = reduce_over_group(it.get_group(), ss, plus<float>());
    float inv = sycl::rsqrt(ss / D + EPS);
    for (int i = 0; i < 9; i++) out[(size_t)t * D + l + i * 256] = v[i] * inv * bf2f(nw[l + i * 256]);
  });
}

struct MixArgs {
  const float *st[5];
  int ns;
  const float *qry[4];
  int nq;
  float *out[4];
};

// attention-residual mix: normalise each state, softmax over states of <query, state>.
// One work-group per token; all dot products are reduced together (one barrier).
template <int NS, int NQ>
void k_mix_t(xik_ctx *c, const MixArgs &a, int T) {
  const float qscale = 1.0f / sycl::sqrt((float)D);
  c->q.submit([&](handler &h) {
    local_accessor<float, 1> red(range<1>(16 * 32), h);
    h.parallel_for(nd_range<1>((size_t)T * 256, 256), [=](nd_item<1> it) SUBGROUP16 {
      int t = it.get_group(0), l = it.get_local_id(0);
      auto sg = it.get_sub_group();
      int sgid = l / 16, lane = l % 16;
      float xv[5][9];
      float qv[4][9];
      float part[25];
      for (int j = 0; j < NQ; j++)
        for (int i = 0; i < 9; i++) qv[j][i] = a.qry[j][l + i * 256] * qscale;
      for (int b = 0; b < NS; b++) {
        float ss = 0.f;
        for (int i = 0; i < 9; i++) { xv[b][i] = a.st[b][(size_t)t * D + l + i * 256]; ss += xv[b][i] * xv[b][i]; }
        part[b] = ss;
        for (int j = 0; j < NQ; j++) {
          float s = 0.f;
          for (int i = 0; i < 9; i++) s += qv[j][i] * xv[b][i];
          part[5 + b * NQ + j] = s;
        }
      }
      int nv = 5 + NS * NQ;
      for (int v = 0; v < nv; v++) {
        float r = reduce_over_group(sg, part[v], plus<float>());
        if (lane == 0) red[sgid * 32 + v] = r;
      }
      group_barrier(it.get_group());
      float tot[25];
      for (int v = 0; v < nv; v++) {
        float s = 0.f;
        for (int g = 0; g < 16; g++) s += red[g * 32 + v];
        tot[v] = s;
      }
      float inv[5];
      for (int b = 0; b < NS; b++) inv[b] = sycl::rsqrt(tot[b] / D + EPS);
      for (int j = 0; j < NQ; j++) {
        float sc[5], mx = -3.0e38f;
        for (int b = 0; b < NS; b++) { sc[b] = tot[5 + b * NQ + j] * inv[b]; mx = sycl::fmax(mx, sc[b]); }
        float den = 0.f;
        for (int b = 0; b < NS; b++) { sc[b] = sycl::exp(sc[b] - mx); den += sc[b]; }
        for (int b = 0; b < NS; b++) sc[b] = sc[b] / den * inv[b];
        for (int i = 0; i < 9; i++) {
          float o = 0.f;
          for (int b = 0; b < NS; b++) o += sc[b] * xv[b][i];
          a.out[j][(size_t)t * D + l + i * 256] = o;
        }
      }
    });
  });
}

void k_mix(xik_ctx *c, const MixArgs &a, int T) {
  if (abl_mask() & 2) return;
  if (abl_mask() & 2048) {  // ablation: same launch, trivial work (copy of the newest block to every output) -> separates launch/boundary cost from the mix work
    const float *src = a.st[a.ns - 1]; float *o0 = a.out[0], *o1 = a.out[1], *o2 = a.out[2], *o3 = a.out[3]; const int nq = a.nq;
    c->q.parallel_for(nd_range<1>((size_t)T * D, 256), [=](nd_item<1> it) {
      size_t i = it.get_global_id(0); float v = src[i]; o0[i] = v; if (nq > 1) o1[i] = v; if (nq > 2) o2[i] = v; if (nq > 3) o3[i] = v; });
    return;
  }
#define MIXCASE(S, Q) if (a.ns == S && a.nq == Q) return k_mix_t<S, Q>(c, a, T);
  MIXCASE(2, 1) MIXCASE(3, 1) MIXCASE(4, 1) MIXCASE(5, 1)
  MIXCASE(2, 3) MIXCASE(3, 3) MIXCASE(4, 3) MIXCASE(5, 3)
  MIXCASE(2, 4)
#undef MIXCASE
  throw std::runtime_error("unsupported mix shape");
}

struct NormArgs {
  const float *x[3];
  const uint16_t *w[3];
  float *out[3];
  int n;
};
// out = rbf(rms(x) * w) for up to 3 independent (x, w, out) triples
template <int N>
void k_wnorm_t(xik_ctx *c, const NormArgs &a, int T) {
  c->q.parallel_for(nd_range<1>((size_t)T * N * 256, 256), [=](nd_item<1> it) {
    int gi = it.get_group(0), l = it.get_local_id(0);
    int t = gi / N, k = gi % N;
    float v[9], ss = 0.f;
    for (int i = 0; i < 9; i++) { v[i] = a.x[k][(size_t)t * D + l + i * 256]; ss += v[i] * v[i]; }
    ss = reduce_over_group(it.get_group(), ss, plus<float>());
    float inv = sycl::rsqrt(ss / D + EPS);
    for (int i = 0; i < 9; i++) a.out[k][(size_t)t * D + l + i * 256] = rbf(v[i] * inv * bf2f(a.w[k][l + i * 256]));
  });
}
void k_wnorm(xik_ctx *c, const NormArgs &a, int T) { if (abl_mask() & 4) return; if (a.n == 1) k_wnorm_t<1>(c, a, T); else k_wnorm_t<3>(c, a, T); }

struct PairArgs {
  const float *dest[3];
  const float *msg[3];
  float *pair[3];
  int n;
};
template <int N>
void k_pairnorm_t(xik_ctx *c, const PairArgs &a, int T) {
  c->q.parallel_for(nd_range<1>((size_t)T * N * 2 * 256, 256), [=](nd_item<1> it) {
    int gi = it.get_group(0), l = it.get_local_id(0);
    int h = gi % 2, k = (gi / 2) % N, t = gi / (2 * N);
    const float *x = h ? a.msg[k] : a.dest[k];
    float v[9], ss = 0.f;
    for (int i = 0; i < 9; i++) { v[i] = x[(size_t)t * D + l + i * 256]; ss += v[i] * v[i]; }
    ss = reduce_over_group(it.get_group(), ss, plus<float>());
    float inv = sycl::rsqrt(ss / D + EPS);
    for (int i = 0; i < 9; i++) a.pair[k][(size_t)t * 2 * D + h * D + l + i * 256] = rbf(v[i] * inv);
  });
}
void k_pairnorm(xik_ctx *c, const PairArgs &a, int T) { if (a.n == 1) k_pairnorm_t<1>(c, a, T); else k_pairnorm_t<3>(c, a, T); }

struct BlendArgs {
  const float *dest[3], *msg[3], *g[3], *f[3];
  const uint16_t *nw[3];
  float *out[3];
  int n;
};
// out = rbf(rms((1 - tanh f) * dest + tanh g * msg) * w)
template <int N>
void k_blend_t(xik_ctx *c, const BlendArgs &a, int T) {
  const bool lat = lat_on();
  c->q.parallel_for(nd_range<1>((size_t)T * N * 256, 256), [=](nd_item<1> it) {
    int gi = it.get_group(0), l = it.get_local_id(0);
    int t = gi / N, k = gi % N;
    float v[9], ss = 0.f;
    if (lat) {
      // all 36 independent loads are issued before the first use (one latency instead of nine); arithmetic order unchanged
      float fv[9], gv[9], dv[9], mv[9];
#pragma unroll
      for (int i = 0; i < 9; i++) {
        size_t o = (size_t)t * D + l + i * 256;
        fv[i] = a.f[k][o]; gv[i] = a.g[k][o]; dv[i] = a.dest[k][o]; mv[i] = a.msg[k][o];
      }
#pragma unroll
      for (int i = 0; i < 9; i++) {
        v[i] = (1.f - sycl::tanh(fv[i])) * dv[i] + sycl::tanh(gv[i]) * mv[i];
        ss += v[i] * v[i];
      }
    } else {
      for (int i = 0; i < 9; i++) {
        size_t o = (size_t)t * D + l + i * 256;
        v[i] = (1.f - sycl::tanh(a.f[k][o])) * a.dest[k][o] + sycl::tanh(a.g[k][o]) * a.msg[k][o];
        ss += v[i] * v[i];
      }
    }
    ss = reduce_over_group(it.get_group(), ss, plus<float>());
    float inv = sycl::rsqrt(ss / D + EPS);
    for (int i = 0; i < 9; i++) a.out[k][(size_t)t * D + l + i * 256] = rbf(v[i] * inv * bf2f(a.nw[k][l + i * 256]));
  });
}
// ---- tanh-input statistics (XIK_TANH_HIST=1): histograms of the controller gate inputs f and g (the arguments of tanh in k_blend) over every
// logical visit of a run.  Observation only: the statistics kernel reads f and g after k_blend has been enqueued; results are unchanged.
// Layout per tensor (0 = f "forget", 1 = g "gain"): lin[2048] |x| in steps of 1/256 below 8, mid[64] steps of 1/4 in [8,24), expo[256] float exponent field,
// cnt[8] = {n, negative, zero, nonfinite, |x|>=19.06 (saturation), |x|<2^-12, min key, max key}; ord[48][4] = {n, sum|x| (x1e3 fixed), max|x| key, n(|x|>=19.06)}.
struct ThHist { uint32_t lin[2048], mid[64], expo[256], cnt[8], ord[48][4]; };
static ThHist *g_th = nullptr;   // device, [2]
static int g_th_ctr = 0;
static bool th_on() { static const bool v = getenv("XIK_TANH_HIST") && atoi(getenv("XIK_TANH_HIST")); return v; }
static inline uint32_t th_key(float x) { uint32_t b = sycl::bit_cast<uint32_t>(x); return (b & 0x80000000u) ? ~b : (b | 0x80000000u); }  // monotone float -> uint
static void th_record(xik_ctx *c, const BlendArgs &a, int T) {
  if (!g_th) { g_th = sycl::malloc_device<ThHist>(2, c->q.q); c->q.memset(g_th, 0, 2 * sizeof(ThHist)).wait(); uint32_t init[2] = {0xFFFFFFFFu, 0u}; for (int t = 0; t < 2; t++) { c->q.memcpy(&g_th[t].cnt[6], &init[0], 4).wait(); c->q.memcpy(&g_th[t].cnt[7], &init[1], 4).wait(); } }
  const int ord = g_th_ctr++ % 48;
  ThHist *H = g_th;
  for (int k = 0; k < a.n; k++)
    for (int tsr = 0; tsr < 2; tsr++) {
      const float *x = tsr ? a.g[k] : a.f[k];
      c->q.parallel_for(range<1>((size_t)T * D), [=](id<1> id) {
        float v = x[id[0]]; float av = sycl::fabs(v); uint32_t bits = sycl::bit_cast<uint32_t>(av);
        ThHist &h = H[tsr];
        using AR = sycl::atomic_ref<uint32_t, sycl::memory_order::relaxed, sycl::memory_scope::device, sycl::access::address_space::global_space>;
        AR(h.cnt[0]).fetch_add(1);
        if (v < 0.f) AR(h.cnt[1]).fetch_add(1);
        if (v == 0.f) AR(h.cnt[2]).fetch_add(1);
        if (!(av < 3.0e38f)) AR(h.cnt[3]).fetch_add(1);
        if (av >= 19.06f) AR(h.cnt[4]).fetch_add(1);
        if (av < 2.44140625e-4f) AR(h.cnt[5]).fetch_add(1);
        if (av < 8.0f) AR(h.lin[(int)(av * 256.f)]).fetch_add(1); else if (av < 24.f) AR(h.mid[(int)((av - 8.f) * 4.f)]).fetch_add(1);
        AR(h.expo[(bits >> 23) & 255]).fetch_add(1);
        uint32_t key = th_key(v);
        sycl::atomic_ref<uint32_t, sycl::memory_order::relaxed, sycl::memory_scope::device, sycl::access::address_space::global_space>(h.cnt[6]).fetch_min(key);
        sycl::atomic_ref<uint32_t, sycl::memory_order::relaxed, sycl::memory_scope::device, sycl::access::address_space::global_space>(h.cnt[7]).fetch_max(key);
        AR(h.ord[ord][0]).fetch_add(1);
        AR(h.ord[ord][1]).fetch_add((uint32_t)(sycl::fmin(av, 1000.f) * 1000.f));
        sycl::atomic_ref<uint32_t, sycl::memory_order::relaxed, sycl::memory_scope::device, sycl::access::address_space::global_space>(h.ord[ord][2]).fetch_max(bits);
        if (av >= 19.06f) AR(h.ord[ord][3]).fetch_add(1);
      });
    }
}
extern "C" int xik_tanh_dump(xik_ctx *c, const char *path) {
  try {
    c->q.wait();
    if (!g_th) return 0;
    std::vector<ThHist> h(2); c->q.memcpy(h.data(), g_th, 2 * sizeof(ThHist)).wait();
    FILE *f = fopen(path, "wb"); if (!f) throw std::runtime_error("cannot write tanh histogram");
    fwrite(h.data(), sizeof(ThHist), 2, f); fclose(f);
    fprintf(stderr, "tanh histogram: %u values per tensor written to %s\n", h[0].cnt[0], path);
    return 0;
  } catch (std::exception &e) { g_err = e.what(); return 1; }
}
void k_blend(xik_ctx *c, const BlendArgs &a, int T) {
  if (a.n == 1) k_blend_t<1>(c, a, T); else k_blend_t<3>(c, a, T);
  if (th_on()) th_record(c, a, T);
}

// ------------------------------------------------------------- short conv
// Depthwise causal conv over [3 state | T chunk], taps lag 0..3, fp32, bf16 output.
// Static weights (bf16 [C,1,4], tap j multiplies x[t-3+j]) or dynamic taps.
// The new 3-row history is written to `state_new` (ping-pong), so the kernel
// never overwrites what other work-items still read.
struct ConvArgs {
  const float *x;          // [T, C]
  const float *state;      // [3, C] oldest first (read)
  float *state_new;        // [3, C] (written)
  float *out;              // [T, C]
  const float *add_to;     // optional: out = add_to + conv
  int C, T;
  const uint16_t *wst;     // static weights [C,1,4]
  const uint16_t *sw;      // dynamic: static_w [4, C]
  const float *dyn;        // dynamic: [T, heads*4]
  int heads;
  float denom;
};
inline float conv_in(const ConvArgs &a, int t, int lag, int ch) {
  int s = t - lag;
  return s >= 0 ? a.x[(size_t)s * a.C + ch] : a.state[(size_t)(3 + s) * a.C + ch];
}
inline float conv_one(const ConvArgs &a, int t, int ch) {
  float acc = 0.f;
  if (a.wst) {
    for (int lag = 0; lag < 4; lag++) acc += bf2f(a.wst[(size_t)ch * 4 + (3 - lag)]) * conv_in(a, t, lag, ch);
  } else {
    int cph = a.C / a.heads, h = ch / cph;
    for (int lag = 0; lag < 4; lag++) {
      float w = bf2f(a.sw[(size_t)lag * a.C + ch]) + a.dyn[(size_t)t * a.heads * 4 + h * 4 + lag];
      acc += w * conv_in(a, t, lag, ch);
    }
  }
  return rbf((acc + a.x[(size_t)t * a.C + ch]) / a.denom);
}
inline void conv_state_write(const ConvArgs &a, int idx) {
  int s = idx / a.C, ch = idx % a.C;
  int src = a.T - 3 + s;
  a.state_new[idx] = src >= 0 ? a.x[(size_t)src * a.C + ch] : a.state[(size_t)(a.T + s) * a.C + ch];
}
void k_conv(xik_ctx *c, const ConvArgs &a) {
  if (abl_mask() & 8) return;
  size_t n = (size_t)a.T * a.C;
  size_t extra = a.state_new ? 3 * (size_t)a.C : 0;
  c->q.parallel_for(range<1>(n + extra), [=](id<1> i) {
    if (i[0] < n) {
      int t = (int)(i[0] / a.C), ch = (int)(i[0] % a.C);
      float v = conv_one(a, t, ch);
      a.out[i[0]] = a.add_to ? a.add_to[i[0]] + v : v;
    } else {
      conv_state_write(a, (int)(i[0] - n));
    }
  });
}

// ------------------------------------------------------------- attention
// per (t, head): q clip with scale; r clip with scale. One sub-group per (t,h).
void k_qr_clip(xik_ctx *c, const LayerW &lw, int T) {
  if (abl_mask() & 64) return;
  float *q = c->qb, *r = c->rb;
  const uint16_t *qs = lw.q_clip, *rs = lw.rel_clip;
  c->q.parallel_for(nd_range<1>((size_t)T * NH * 16, 16), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    int idx = it.get_group(0);
    int t = idx / NH, h = idx % NH;
    float *qp = q + (size_t)t * QD + h * HD;
    float v[8], ss = 0.f;
    for (int i = 0; i < 8; i++) { v[i] = qp[lane + i * 16] * bf2f(qs[h * HD + lane + i * 16]); ss += v[i] * v[i]; }
    ss = reduce_over_group(sg, ss, plus<float>());
    float f = sycl::fmin(QK_CLIP / (sycl::sqrt(ss) + 1e-6f), 1.0f);
    for (int i = 0; i < 8; i++) qp[lane + i * 16] = rbf(v[i] * f);
    float *rp = r + (size_t)t * RD + h * DREL;
    float rv = rp[lane] * bf2f(rs[h * DREL + lane]);
    float s2 = reduce_over_group(sg, rv * rv, plus<float>());
    float f2 = sycl::fmin(REL_CLIP / (sycl::sqrt(s2) + 1e-6f), 1.0f);
    rp[lane] = rbf(rv * f2);
  });
}

// K/V: conv (static or dynamic) -> clip(k)/rms(v) -> cache, plus the new conv histories.
// One group per (t, kv head); extra groups write the state.
void k_kv(xik_ctx *c, const LayerW &lw, int slot, bool local, int T, int pos0) {
  int par = c->cpar[slot];
  float *so = c->convst[slot][par], *sn = c->defer ? nullptr : c->convst[slot][1 - par];
  ConvArgs ak{c->kb, so, sn, nullptr, nullptr, KVD, T, local ? lw.k_conv : nullptr, lw.k_static, c->dynk, NKV,
              local ? 2.2360679775f : 3.0f};
  ConvArgs av{c->vb, so + 3 * KVD, sn ? sn + 3 * KVD : nullptr, nullptr, nullptr, KVD, T, local ? lw.v_conv : nullptr, lw.v_static,
              c->dynv, NKV, local ? 2.2360679775f : 3.0f};
  float *kc = c->kcache[slot], *vc = c->vcache[slot];
  const bool kbf = c->kbf16;
  const int32_t *dpp = c->dparams;
  int ngrp = T * NKV, nst = sn ? 3 * KVD / HD : 0;
  c->q.parallel_for(nd_range<1>((size_t)(ngrp + nst) * HD, HD), [=](nd_item<1> it) {
    int idx = it.get_group(0), d = it.get_local_id(0);
    if (idx >= ngrp) {
      int j = (idx - ngrp) * HD + d;
      conv_state_write(ak, j);
      conv_state_write(av, j);
      return;
    }
    int t = idx / NKV, h = idx % NKV;
    int ch = h * HD + d;
    float kv = conv_one(ak, t, ch);
    float vv = conv_one(av, t, ch);
    auto g = it.get_group();
    float ks = reduce_over_group(g, kv * kv, plus<float>());
    float vs = reduce_over_group(g, vv * vv, plus<float>());
    float f = sycl::fmin(QK_CLIP / (sycl::sqrt(ks) + 1e-6f), 1.0f);
    int pos = dpp[0] + t;
    size_t slotpos = local ? (pos % RING) : pos;
    if (kbf) reinterpret_cast<uint16_t *>(kc)[slotpos * KVD + ch] = (uint16_t)(sycl::bit_cast<uint32_t>(rbf(kv * f)) >> 16);  // exact: rbf() already cleared the low 16 bits
    else kc[slotpos * KVD + ch] = rbf(kv * f);
    vc[slotpos * KVD + ch] = vv * sycl::rsqrt(vs / HD + EPS);
  });
}

template <int VW, int UNR = -1, int ABL = 0>
void k_attn_w(xik_ctx *c, const LayerW &lw, int slot, bool local, int T, int pos0) {
  const float *q = c->qb, *r = c->rb, *sink = c->sinkb, *gate = c->gateb;
  const float *kc = c->kcache[slot], *vc = c->vcache[slot];
  const bool kbf = c->kbf16;
  const uint16_t *rp = lw.rel_proj;
  float *out = c->attn_o;
  const int32_t *dpp = c->dparams;
  int maxkeys = local ? WIN : c->max_ctx;
  const float scale = 1.0f / sycl::sqrt((float)HD);
  c->q.submit([&](handler &h) {
    local_accessor<float, 1> lg(range<1>(maxkeys), h);
    local_accessor<float, 1> qs(range<1>(HD), h);
    local_accessor<float, 1> red(range<1>(HD), h);
    h.parallel_for(nd_range<1>((size_t)T * NH * HD, HD), [=](nd_item<1> it) {
      int idx = it.get_group(0), tid = it.get_local_id(0);
      int t = idx / NH, hh = idx % NH, kvh = hh / (NH / NKV);
      auto g = it.get_group();
      int pos = dpp[0] + t;
      int lo = local ? sycl::max(0, pos - WIN + 1) : 0;
      int nk = pos - lo + 1;
      qs[tid] = q[(size_t)t * QD + hh * HD + tid];
      float rv[DREL];
      for (int e = 0; e < DREL; e++) rv[e] = r[(size_t)t * RD + hh * DREL + e];
      float sk = sink[(size_t)t * NH + hh];
      group_barrier(g);
      float mx = 0.f;  // the extra sink logit is 0
      for (int j = tid; j < nk; j += HD) {
        int kp = lo + j, dist = pos - kp;
        size_t slotpos = local ? (kp % RING) : kp;
        float s = 0.f;
        if (kbf) {  // bf16 K: 16 B (8 dims) per load; the dot product is accumulated in exactly the same order as the fp32 path (groups of 4 dims)
          const uint16_t *kb = reinterpret_cast<const uint16_t *>(kc) + slotpos * KVD + kvh * HD;
          for (int d = 0; d < HD; d += 8) {
            vec<uint16_t, 8> u = *reinterpret_cast<const vec<uint16_t, 8> *>(kb + d);
            float k0 = sycl::bit_cast<float>((uint32_t)u[0] << 16), k1 = sycl::bit_cast<float>((uint32_t)u[1] << 16),
                  k2 = sycl::bit_cast<float>((uint32_t)u[2] << 16), k3 = sycl::bit_cast<float>((uint32_t)u[3] << 16);
            s += qs[d] * k0 + qs[d + 1] * k1 + qs[d + 2] * k2 + qs[d + 3] * k3;
            float k4 = sycl::bit_cast<float>((uint32_t)u[4] << 16), k5 = sycl::bit_cast<float>((uint32_t)u[5] << 16),
                  k6 = sycl::bit_cast<float>((uint32_t)u[6] << 16), k7 = sycl::bit_cast<float>((uint32_t)u[7] << 16);
            s += qs[d + 4] * k4 + qs[d + 5] * k5 + qs[d + 6] * k6 + qs[d + 7] * k7;
          }
        } else {
          const float *kr = kc + slotpos * KVD + kvh * HD;
          for (int d = 0; d < HD; d += 4) {
            vec<float, 4> kk = *reinterpret_cast<const vec<float, 4> *>(kr + d);
            s += qs[d] * kk[0] + qs[d + 1] * kk[1] + qs[d + 2] * kk[2] + qs[d + 3] * kk[3];
          }
        }
        float bias = 0.f;
        if (dist < EXT)
          for (int e = 0; e < DREL; e++) bias += rv[e] * bf2f(rp[(size_t)e * EXT + dist]);
        float l = s * scale + bias - sk;
        lg[j] = l;
        mx = sycl::fmax(mx, l);
      }
      mx = reduce_over_group(g, mx, maximum<float>());
      float den = 0.f;
      for (int j = tid; j < nk; j += HD) {
        float e = sycl::exp(lg[j] - mx);
        lg[j] = e;
        den += e;
      }
      den = reduce_over_group(g, den, plus<float>()) + sycl::exp(-mx);
      group_barrier(g);
      float o = 0.f;
      // ABL (timing-only ablations, wrong numbers): bit0 = lg[] value from a register expression instead of the SLM read, bit1 = V value
      // from a register expression instead of the global load.  ABL=0 is the real kernel.
#define XA_LG(jj) ((ABL & 1) ? (float)((jj) & 7) * 0.125f : lg[jj])
#define XA_VV(kpp) ((ABL & 2) ? (float)((kpp) & 15) * 0.01f + (float)tid * 1e-3f : vc[(local ? ((kpp) % RING) : (kpp)) * KVD + kvh * HD + tid])
#define XA_SERIAL_BODY { int kp = lo + j; o += XA_LG(j) * XA_VV(kp); }
      // accumulation order is j ascending with one rounded multiply and one rounded add per key in every variant
      if constexpr (VW > 0) {
        int j = 0;
        if constexpr (UNR == 9) {  // two-stage ring: block k+1 is loaded into the second register set while block k is accumulated
          float va[VW], vb[VW];
          if (j + VW <= nk) {
#pragma unroll
            for (int u = 0; u < VW; u++) va[u] = XA_VV(lo + u);
          }
          for (; j + 2 * VW <= nk; j += 2 * VW) {
#pragma unroll
            for (int u = 0; u < VW; u++) vb[u] = XA_VV(lo + j + VW + u);
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + u) * va[u];
            if (j + 3 * VW <= nk) {
#pragma unroll
              for (int u = 0; u < VW; u++) va[u] = XA_VV(lo + j + 2 * VW + u);
            }
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + VW + u) * vb[u];
          }
          if (j + VW <= nk) {
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + u) * va[u];
            j += VW;
          }
        } else if constexpr (UNR == 0) {
#pragma nounroll
          for (; j + VW <= nk; j += VW) {
            float vv8[VW];
#pragma unroll
            for (int u = 0; u < VW; u++) vv8[u] = XA_VV(lo + j + u);
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + u) * vv8[u];
          }
        } else if constexpr (UNR == 4) {
#pragma unroll 4
          for (; j + VW <= nk; j += VW) {
            float vv8[VW];
#pragma unroll
            for (int u = 0; u < VW; u++) vv8[u] = XA_VV(lo + j + u);
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + u) * vv8[u];
          }
        } else {
          for (; j + VW <= nk; j += VW) {
            float vv8[VW];
#pragma unroll
            for (int u = 0; u < VW; u++) vv8[u] = XA_VV(lo + j + u);
#pragma unroll
            for (int u = 0; u < VW; u++) o += XA_LG(j + u) * vv8[u];
          }
        }
        for (; j < nk; j++) XA_SERIAL_BODY
      } else {
        if constexpr (UNR == 0) {
#pragma nounroll
          for (int j = 0; j < nk; j++) XA_SERIAL_BODY
        } else if constexpr (UNR == 4) {
#pragma unroll 4
          for (int j = 0; j < nk; j++) XA_SERIAL_BODY
        } else {
          for (int j = 0; j < nk; j++) XA_SERIAL_BODY
        }
      }
#undef XA_LG
#undef XA_VV
#undef XA_SERIAL_BODY
      o /= den;
      float gt = sigmoidf(gate[(size_t)t * QD + hh * HD + tid]);
      out[(size_t)t * QD + hh * HD + tid] = rbf(o * gt);
    });
  });
}

void k_attn(xik_ctx *c, const LayerW &lw, int slot, bool local, int T, int pos0) {
  // XIK_ATTN = V prefetch width VW (0 = original loop, default 8); XIK_ATTN_UNR = outer-loop unroll (-1 compiler default, 0 none, 4 forced x4);
  // XIK_ATTN_ABL = timing-only ablation bits (1 no SLM read, 2 no V load) -- wrong numbers, benchmark only.
  // Default (measured fastest at every context, output bit-identical): VW=8 loads issued ahead, outer loop unrolled x4.  XIK_ATTN=0 = original loop.
  static const int vw = getenv("XIK_ATTN") ? atoi(getenv("XIK_ATTN")) : 8;
  static const int unr = getenv("XIK_ATTN_UNR") ? atoi(getenv("XIK_ATTN_UNR")) : (getenv("XIK_ATTN") ? -1 : 4);
  static const int abl = getenv("XIK_ATTN_ABL") ? atoi(getenv("XIK_ATTN_ABL")) : 0;
#define KA(V, U, A) if (vw == V && unr == U && abl == A) return k_attn_w<V, U, A>(c, lw, slot, local, T, pos0);
#define KAU(V) KA(V, -1, 0) KA(V, 0, 0) KA(V, 4, 0)
  KAU(0) KAU(1) KAU(8)
  KA(2, -1, 0) KA(4, -1, 0) KA(12, -1, 0) KA(16, -1, 0) KA(24, -1, 0) KA(32, -1, 0) KA(12, 0, 0) KA(16, 0, 0) KA(32, 0, 0)
  KA(4, 9, 0) KA(6, 9, 0) KA(8, 9, 0) KA(12, 9, 0)
  KA(0, -1, 1) KA(0, -1, 2) KA(0, -1, 3) KA(1, -1, 1) KA(1, -1, 2) KA(1, -1, 3) KA(8, 0, 1) KA(8, 0, 2) KA(8, 0, 3)
#undef KAU
#undef KA
  throw std::runtime_error("unsupported XIK_ATTN / XIK_ATTN_UNR / XIK_ATTN_ABL combination");
}

// ------------------------------------------------------------------- MoE
// Routing record / replay (benchmark infrastructure; T == 1 router calls only, i.e. one entry per logical visit of a decode step).
//  XIK_ROUTE_REC=1      : record the expert ids and routing weights chosen by the real router (dump with xik_route_dump).
//  XIK_ROUTE_REPLAY=file: replace the router by a copy of the recorded entry (call counter modulo the table size), so every configuration of an
//                         ablation / dispatch experiment sees the identical expert sequence (same DRAM pattern, locality and cache reuse).
struct RouteTab { int32_t *ids = nullptr; float *w = nullptr; size_t n = 0, cap = 0; };
static RouteTab g_rec, g_rep;
static size_t g_rr_ctr = 0;
static void rr_load(xik_ctx *c, const char *path) {
  FILE *f = fopen(path, "rb");
  if (!f) throw std::runtime_error(std::string("XIK_ROUTE_REPLAY: cannot open ") + path);
  uint64_t n = 0;
  if (fread(&n, 8, 1, f) != 1 || n == 0) throw std::runtime_error("bad routing file");
  std::vector<int32_t> ids(n * TOPK); std::vector<float> w(n * TOPK);
  if (fread(ids.data(), 4, ids.size(), f) != ids.size() || fread(w.data(), 4, w.size(), f) != w.size()) throw std::runtime_error("short routing file");
  fclose(f);
  g_rep.ids = sycl::malloc_device<int32_t>(ids.size(), c->q.q); g_rep.w = sycl::malloc_device<float>(w.size(), c->q.q); g_rep.n = n;
  c->q.memcpy(g_rep.ids, ids.data(), ids.size() * 4).wait(); c->q.memcpy(g_rep.w, w.data(), w.size() * 4).wait();
  fprintf(stderr, "routing replay: %zu logical visits loaded from %s\n", (size_t)n, path);
}
extern "C" int xik_route_dump(xik_ctx *c, const char *path) {
  try {
    c->q.wait();
    if (!g_rec.n) return 0;
    std::vector<int32_t> ids(g_rec.n * TOPK); std::vector<float> w(g_rec.n * TOPK);
    c->q.memcpy(ids.data(), g_rec.ids, ids.size() * 4).wait(); c->q.memcpy(w.data(), g_rec.w, w.size() * 4).wait();
    FILE *f = fopen(path, "wb");
    if (!f) throw std::runtime_error("cannot write routing file");
    uint64_t n = g_rec.n; fwrite(&n, 8, 1, f); fwrite(ids.data(), 4, ids.size(), f); fwrite(w.data(), 4, w.size(), f); fclose(f);
    fprintf(stderr, "routing record: %zu logical visits -> %s\n", g_rec.n, path);
    return 0;
  } catch (std::exception &e) { g_err = e.what(); return 1; }
}
void k_router(xik_ctx *c, const LayerW &lw, int T) {
  static const char *rr_path = getenv("XIK_ROUTE_REPLAY");
  static const bool rec = getenv("XIK_ROUTE_REC") && atoi(getenv("XIK_ROUTE_REC"));
  if (T == 1 && rr_path) {
    if (!g_rep.ids) rr_load(c, rr_path);
    const size_t idx = g_rr_ctr++ % g_rep.n;
    int32_t *ri = c->ridx; float *rw = c->rwt; const int32_t *si = g_rep.ids + idx * TOPK; const float *sw = g_rep.w + idx * TOPK;
    c->q.single_task([=]() { for (int k = 0; k < TOPK; k++) { ri[k] = si[k]; rw[k] = sw[k]; } });
    return;
  }
  if (abl_mask() & 128) {  // no replay file: synthetic, realistic-spread routing (8 distinct experts per token, varies per call)
    static int ctr = 0;
    const int cc = ctr++;
    int32_t *ri = c->ridx; float *rw = c->rwt;
    c->q.single_task([=]() {
      for (int t = 0; t < T; t++)
        for (int k = 0; k < TOPK; k++) { ri[t * TOPK + k] = (k * 7 + 3 + 11 * cc + 5 * t) % NE; rw[t * TOPK + k] = 0.125f; }
    });
    return;
  }
  const float *logit = c->tmp1;  // [T, 128] router logits (fp32 gemv result)
  const float *bias = lw.router_bias;
  int32_t *ridx = c->ridx;
  float *rwt = c->rwt;
  c->q.parallel_for(nd_range<1>((size_t)T * NE, NE), [=](nd_item<1> it) {
    int t = it.get_group(0), e = it.get_local_id(0);
    auto g = it.get_group();
    float s = sigmoidf(logit[(size_t)t * NE + e]);
    float sel = s + bias[e];
    // top-8 by repeated arg-max (ties -> lower index)
    float chosen_w[TOPK];
    int chosen_i[TOPK];
    float cur = sel;
    for (int k = 0; k < TOPK; k++) {
      float m = reduce_over_group(g, cur, maximum<float>());
      int cand = (cur == m) ? e : NE;
      int idx = reduce_over_group(g, cand, minimum<int>());
      float sw = group_broadcast(g, s, idx);
      chosen_i[k] = idx;
      chosen_w[k] = sw;
      if (e == idx) cur = -3.0e38f;
    }
    if (e == 0) {
      float sum = 0.f;
      for (int k = 0; k < TOPK; k++) sum += chosen_w[k];
      for (int k = 0; k < TOPK; k++) {
        ridx[t * TOPK + k] = chosen_i[k];
        rwt[t * TOPK + k] = chosen_w[k] / (sum + 1e-20f) * ROUTE_SCALE;
      }
    }
  });
  if (rec && T == 1) {
    if (!g_rec.ids) { g_rec.cap = 1 << 16; g_rec.ids = sycl::malloc_device<int32_t>(g_rec.cap * TOPK, c->q.q); g_rec.w = sycl::malloc_device<float>(g_rec.cap * TOPK, c->q.q); }
    if (g_rec.n < g_rec.cap) {
      int32_t *ri2 = g_rec.ids + g_rec.n * TOPK; float *rw2 = g_rec.w + g_rec.n * TOPK; const int32_t *src_i = c->ridx; const float *src_w = c->rwt;
      c->q.single_task([=]() { for (int k = 0; k < TOPK; k++) { ri2[k] = src_i[k]; rw2[k] = src_w[k]; } });
      g_rec.n++;
    }
  }
}

// T == 1 fusion of k_router + k_cvt_f16 + k_group (one work-group of NE items; same arithmetic, same results).
// k_group reads ridx[p] for p < 8; every work-item already holds the chosen experts, so no global round trip is needed.
void k_route_fused1(xik_ctx *c, const LayerW &lw) {
  const float *logit = c->tmp1;
  const float *bias = lw.router_bias;
  int32_t *ridx = c->ridx;
  float *rwt = c->rwt;
  const float *xin = c->in[0];
  sycl::half *x16 = c->x16_in;
  int32_t *ecnt = c->ecnt, *elist = c->elist, *actl = c->act_e, *nact = c->nact, *desc = c->desc;
  const int np = TOPK, maxper = 1, maxslots = std::min(NE, TOPK);
  c->q.parallel_for(nd_range<1>(NE, NE), [=](nd_item<1> it) {
    int e = it.get_local_id(0);
    auto g = it.get_group();
    // ---- k_cvt_f16 (independent of routing)
    for (int i = e; i < D; i += NE) x16[i] = (sycl::half)xin[i];
    // ---- k_router (identical code, t = 0)
    float s = sigmoidf(logit[e]);
    float sel = s + bias[e];
    float chosen_w[TOPK];
    int chosen_i[TOPK];
    float cur = sel;
    for (int k = 0; k < TOPK; k++) {
      float m = reduce_over_group(g, cur, maximum<float>());
      int cand = (cur == m) ? e : NE;
      int idx = reduce_over_group(g, cand, minimum<int>());
      float sw = group_broadcast(g, s, idx);
      chosen_i[k] = idx;
      chosen_w[k] = sw;
      if (e == idx) cur = -3.0e38f;
    }
    if (e == 0) {
      float sum = 0.f;
      for (int k = 0; k < TOPK; k++) sum += chosen_w[k];
      for (int k = 0; k < TOPK; k++) {
        ridx[k] = chosen_i[k];
        rwt[k] = chosen_w[k] / (sum + 1e-20f) * ROUTE_SCALE;
      }
    }
    // ---- k_group (identical code; ridx[p] == chosen_i[p])
    int cnt = 0;
    for (int p = 0; p < np; p++)
      if (chosen_i[p] == e) elist[(size_t)e * maxper + cnt++] = p;
    ecnt[e] = cnt;
    int flag = cnt > 0 ? 1 : 0;
    int pos = exclusive_scan_over_group(g, flag, plus<int>());
    if (flag) {
      actl[pos] = e;
      int32_t *d = desc + pos * 16;
      d[0] = e;
      d[1] = cnt;
      for (int i = 0; i < 8; i++) d[2 + i] = elist[(size_t)e * maxper + (i < cnt ? i : 0)];
    }
    int tot = reduce_over_group(g, flag, plus<int>());
    if (e == 0) nact[0] = tot;
    for (int j = tot + e; j < maxslots; j += NE) desc[j * 16 + 1] = 0;
  });
}
static bool fuse_route() { static const bool v = getenv("XIK_FUSE_ROUTE") && atoi(getenv("XIK_FUSE_ROUTE")); return v; }

void k_act(xik_ctx *c, int npairs, int nks) {
  if (abl_mask() & 16) return;
  const float *gu = c->gu_part;
  float *act = c->act;
  sycl::half *act16 = c->x16_act;
  size_t stride = (size_t)npairs * 2 * FI;
  c->q.parallel_for(range<1>((size_t)npairs * FI), [=](id<1> i) {
    size_t p = i[0] / FI;
    int j = (int)(i[0] % FI);
    float g = 0.f, u = 0.f;
    for (int k = 0; k < nks; k++) {
      g += gu[k * stride + p * 2 * FI + 2 * j];
      u += gu[k * stride + p * 2 * FI + 2 * j + 1];
    }
    float a = rbf(softcap(g, GATE_CAP) * sigmoidf(g) * softcap(u, UP_CAP));
    act[i[0]] = a;
    act16[i[0]] = (sycl::half)a;
  });
}

void k_moe_combine(xik_ctx *c, int T, int nks) {
  if (abl_mask() & 16) return;
  const float *y = c->yp_part, *w = c->rwt;
  float *out = c->moe_o;
  size_t stride = (size_t)T * TOPK * D;
  c->q.parallel_for(range<1>((size_t)T * D), [=](id<1> i) {
    size_t t = i[0] / D;
    int d = (int)(i[0] % D);
    float s = 0.f;
    for (int k = 0; k < TOPK; k++) {
      float yy = 0.f;
      for (int q = 0; q < nks; q++) yy += y[q * stride + (t * TOPK + k) * D + d];
      s += rbf(yy) * w[t * TOPK + k];
    }
    out[i[0]] = rbf(s);
  });
}

void k_add(xik_ctx *c, float *stream, const float *x, int T) {
  c->q.parallel_for(range<1>((size_t)T * D), [=](id<1> i) { stream[i[0]] += x[i[0]]; });
}

void k_sigmoid_inplace(xik_ctx *c, float *x, size_t n) {
  c->q.parallel_for(range<1>(n), [=](id<1> i) { x[i[0]] = sigmoidf(x[i[0]]); });
}

// ------------------------------------------------------------------ head
void k_softcap_argmax(xik_ctx *c, int rows) {
  float *lg = c->logits;
  int32_t *am = c->am_d;
  c->q.parallel_for(nd_range<1>((size_t)rows * 1024, 1024), [=](nd_item<1> it) {
    int r = it.get_group(0), l = it.get_local_id(0);
    auto g = it.get_group();
    float best = -3.0e38f;
    int bi = VOCAB_U;
    for (int i = l; i < VOCAB; i += 1024) {
      float v = softcap(lg[(size_t)r * VOCAB + i], FINAL_CAP);
      lg[(size_t)r * VOCAB + i] = v;
      if (i < VOCAB_U && v > best) { best = v; bi = i; }
    }
    float m = reduce_over_group(g, best, maximum<float>());
    int cand = (best == m) ? bi : VOCAB_U;
    int idx = reduce_over_group(g, cand, minimum<int>());
    if (l == 0) am[r] = idx;
  });
}

}  // namespace

// =============================================================== public API
namespace { void init_drafter(xik_ctx *c); }
static const uint16_t *tp16(xik_ctx *c, const std::string &n, bool must = true) {
  auto it = c->tensors.find(n);
  if (it == c->tensors.end()) {
    if (must) throw std::runtime_error("missing tensor " + n);
    return nullptr;
  }
  return (const uint16_t *)it->second.p;
}
static const float *tpf(xik_ctx *c, const std::string &n) { return (const float *)tp16(c, n); }
static const uint8_t *tp8(xik_ctx *c, const std::string &n) { return (const uint8_t *)tp16(c, n); }

extern "C" {

const char *xik_last_error(void) { return g_err.c_str(); }

xik_ctx *xik_create(int max_ctx, int max_tokens) {
  try {
    auto *c = new xik_ctx();
    c->max_ctx = max_ctx;
    c->max_tokens = max_tokens;
    if (const char *e = getenv("XIK_MOE_CFG")) c->moe_cfg = atoi(e);
    if (max_tokens > 1024) throw std::runtime_error("max_tokens > 1024 unsupported (local KV ring)");
    return c;
  } catch (std::exception &e) {
    g_err = e.what();
    return nullptr;
  }
}

void xik_destroy(xik_ctx *c) {
  if (!c) return;
  for (auto &kv : c->tensors) sycl::free(kv.second.base ? kv.second.base : kv.second.p, c->q);
  delete c;
}

// Experiment: shift the start of every repacked expert tensor by XIK_WOFF bytes (content untouched).
// Range: 0..4096 and a multiple of 16 (the ESIMD block loads below are compiled with alignment<16>; a shift that is not a
// multiple of 16 would make that promise false).
static size_t woff_bytes() {
  static const size_t v = [] {
    size_t w = getenv("XIK_WOFF") ? (size_t)atol(getenv("XIK_WOFF")) : 0;
    if (w > 4096 || w % 16 != 0) throw std::runtime_error("XIK_WOFF must be a multiple of 16 in [0, 4096]");
    return w;
  }();
  return v;
}
// Weight-tensor allocation.  Measured (docs/alignment.md): an expert tensor whose base is not a multiple of 256 B makes every 256 B
// weight load straddle two 256 B regions: NVFP4 w13 T=1 61 -> 66 us (+192) / 114 us (+128) / 166 us (+64), DRAM bytes read up to 2.7x.
// So the base alignment is guaranteed by the API (aligned_alloc_device, 4096) instead of being whatever the driver happens to return
// (it currently returns 2 MiB-aligned blocks, identical addresses).  XIK_ALLOC=plain restores malloc_device.
static bool g_w3sel[24][2];  // layer/matrix stored as W3A16
static void *alloc_expert(xik_ctx *c, size_t bytes) {
  static const bool plain = getenv("XIK_ALLOC") && std::string(getenv("XIK_ALLOC")) == "plain";
  return plain ? malloc_device(bytes, c->q) : sycl::aligned_alloc_device(4096, bytes, c->q.q);
}
// A pointer handed to an alignment<A> load must really be A-byte aligned.
static void require_aligned(const void *p, size_t a, const char *what) {
  if ((uintptr_t)p % a != 0) {
    char b[160];
    snprintf(b, sizeof b, "%s: address %p is not %zu-byte aligned (an alignment<%zu> load would be undefined)", what, p, a, a);
    throw std::runtime_error(b);
  }
}

// ---- activation statistics (XIK_ACT_STATS=1): mean square of every dense-weight input channel over all visits/tokens of a run (for activation-aware quantisation)
struct ActSt { float *s[24][4]; float cnt[24][4]; float *head = nullptr; float hcnt = 0; bool init = false; };
static ActSt g_as;
static bool as_on() { static const bool v = getenv("XIK_ACT_STATS") && atoi(getenv("XIK_ACT_STATS")); return v; }
static void as_rec(xik_ctx *c, int layer, int kind, const float *x, int K, int T) {  // kind 0..2 = in[0..2], 3 = attn_o, 4 = head input
  if (!g_as.init) { memset(&g_as, 0, sizeof g_as); g_as.init = true; }
  float *&acc = kind == 4 ? g_as.head : g_as.s[layer][kind];
  if (!acc) { acc = sycl::malloc_device<float>(K, c->q.q); c->q.memset(acc, 0, K * 4).wait(); }
  if (kind == 4) g_as.hcnt += T; else g_as.cnt[layer][kind] += T;
  float *a = acc;
  c->q.parallel_for(range<1>(K), [=](id<1> i) { float t = 0.f; for (int r = 0; r < T; r++) { float v = x[(size_t)r * K + i[0]]; t += v * v; } a[i[0]] += t; });
}
extern "C" int xik_actstats_dump(xik_ctx *c, const char *path) {
  try {
    c->q.wait(); if (!g_as.init) return 0;
    FILE *f = fopen(path, "wb"); if (!f) throw std::runtime_error("cannot write activation statistics");
    const int Ks[4] = {D, D, D, QD};
    for (int l = 0; l < 24; l++) for (int k = 0; k < 4; k++) {
      std::vector<float> h(Ks[k], 0.f); if (g_as.s[l][k]) c->q.memcpy(h.data(), g_as.s[l][k], Ks[k] * 4).wait();
      float n = g_as.cnt[l][k]; fwrite(&n, 4, 1, f); fwrite(h.data(), 4, Ks[k], f);
    }
    std::vector<float> h(D, 0.f); if (g_as.head) c->q.memcpy(h.data(), g_as.head, D * 4).wait();
    fwrite(&g_as.hcnt, 4, 1, f); fwrite(h.data(), 4, D, f); fclose(f);
    fprintf(stderr, "activation statistics -> %s\n", path); return 0;
  } catch (std::exception &e) { g_err = e.what(); return 1; }
}
// Quality simulation of group-wise int4 weights (XIK_W4SIM=group size, XIK_W4MASK bits: 1 q/k/v/r/gate, 2 wo, 4 head, XIK_W4ASYM=1 asymmetric (zero point),
// XIK_W4OBJ: 0 plain min/max, 1 clipping search by squared error, 2 clipping search by activation-weighted squared error (XIK_ACT_STATS_FILE)): the bf16
// weights are replaced in place by (q - zp) * scale, scale = fp16, rounded back to bf16.  Run in the bf16 dense mode; this is the error an int4 kernel with the
// same grouping sees (plus the bf16 rounding of the product).
static void k_w4sim(xik_ctx *c, uint16_t *w, int rows, int K, int G, int asym, int obj, const float *h) {
  const int ng = K / G;
  c->q.parallel_for(range<1>((size_t)rows * ng), [=](id<1> id) {
    size_t r = id[0] / ng; int g = (int)(id[0] % ng);
    uint16_t *p = w + r * K + (size_t)g * G;
    const float *hh = h ? h + (size_t)g * G : nullptr;
    float amax = 0.f, lo = 1e30f, hi = -1e30f;
    for (int i = 0; i < G; i++) { float x = bf2f(p[i]); amax = sycl::fmax(amax, sycl::fabs(x)); lo = sycl::fmin(lo, x); hi = sycl::fmax(hi, x); }
    lo = sycl::fmin(lo, 0.f); hi = sycl::fmax(hi, 0.f);
    float bs = 0.f, bz = 8.f, be = 1e30f;
    const int ncand = obj ? 12 : 1;
    for (int cdt = 0; cdt < ncand; cdt++) {
      float sc, zp;
      const float shrink = 1.f - 0.04f * cdt;  // 1.00 .. 0.56 of the full range
      if (asym) { sc = (float)(sycl::half)((hi - lo) * shrink / 15.f); if (sc == 0.f) continue; zp = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(-lo * shrink / sc))); }
      else { sc = (float)(sycl::half)(amax * shrink / 7.5f); if (sc == 0.f) continue; zp = 8.f; }
      float e = 0.f;
      for (int i = 0; i < G; i++) {
        float x = bf2f(p[i]); float q = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / sc) + zp)); float d = x - (q - zp) * sc;
        e += (obj == 2 && hh ? hh[i] : 1.f) * d * d;
      }
      if (e < be) { be = e; bs = sc; bz = zp; }
    }
    if (bs == 0.f) return;
    for (int i = 0; i < G; i++) {
      float x = bf2f(p[i]); float q = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / bs) + bz));
      float y = (q - bz) * bs;
      uint32_t u = sycl::bit_cast<uint32_t>(y); u += 0x7FFFu + ((u >> 16) & 1u); p[i] = (uint16_t)(u >> 16);
    }
  });
}
}  // extern "C"
// ---------------------------------------------------------------------------------------------------------------------------------
// Int4 output head: weights in the W4 tile layout (see w4_gemv), group 64, symmetric (nibble - 8) * scale, scale chosen by (activation-weighted) squared error.
static void k_w4pack(xik_ctx *c, const uint16_t *w, int rows, int K, int obj, const float *h, uint32_t *out, uint16_t *sc) {
  const int ngrp = K / 64;
  c->q.parallel_for(range<1>((size_t)rows * ngrp), [=](id<1> id) {
    const size_t r = id[0] / ngrp; const int g = (int)(id[0] % ngrp);
    const uint16_t *p = w + r * K + (size_t)g * 64;
    const float *hh = h ? h + (size_t)g * 64 : nullptr;
    float amax = 0.f;
    for (int i = 0; i < 64; i++) amax = sycl::fmax(amax, sycl::fabs(bf2f(p[i])));
    float bs = (float)(sycl::half)(amax / 7.5f), be = 1e30f;
    if (obj) {
      for (int cdt = 0; cdt < 12; cdt++) {
        float s2 = (float)(sycl::half)(amax * (1.f - 0.04f * cdt) / 7.5f); if (s2 == 0.f) continue;
        float e = 0.f;
        for (int i = 0; i < 64; i++) { float x = bf2f(p[i]); float q = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / s2) + 8.f)); float d = x - (q - 8.f) * s2; e += (hh ? hh[i] : 1.f) * d * d; }
        if (e < be) { be = e; bs = s2; }
      }
    }
    const int rb = (int)(r / 16), n = (int)(r % 16);
    sc[((size_t)rb * ngrp + g) * 16 + n] = sycl::bit_cast<uint16_t>((sycl::half)bs);
    for (int bl = 0; bl < 2; bl++)
      for (int q4 = 0; q4 < 4; q4++) {
        uint32_t d = 0;
        for (int j = 0; j < 8; j++) {
          float x = bf2f(p[bl * 32 + q4 * 8 + j]);
          uint32_t qv = bs == 0.f ? 8u : (uint32_t)sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / bs) + 8.f));
          d |= (j & 1) ? (qv << (16 + 4 * (j / 2))) : (qv << (4 * (j / 2)));
        }
        out[((size_t)rb * (K / 32) + g * 2 + bl) * 64 + q4 * 16 + n] = d;
      }
  });
}
// W4A16 GEMV for R <= 8 tokens: Y[t][row] = sum_g scale[row][g] * sum_{k in g} (nibble - 8) * x_fp16[t][k]  (fp16 DPAS, fp32 accumulate per 64-K group)
template <int KSD, int R>
static void w4_gemv_r(xik_ctx *c, const uint32_t *W, const uint16_t *S, const float *X, int ldx, float *Y, int ldy, int rows, int K, int t0, int nt, bool rnd) {
  const int nrb = rows / 16, ngrp = K / 64, per = ngrp / KSD;
  c->q.parallel_for(nd_range<1>((size_t)nrb * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    slm_init<KSD * 16 * R * 4>();
    const int rb = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    const int g0 = tid * per;
    const uint32_t *wp = W + ((size_t)rb * (K / 32) + (size_t)g0 * 2) * 64;
    const uint16_t *sp = S + ((size_t)rb * ngrp + g0) * 16;
    simd<float, 16 * R> acc = 0.f;
    simd<uint32_t, 128> cur, nxt;
    cur.template select<64, 1>(0) = block_load<uint32_t, 64>(wp);
    cur.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + 64);
    simd<uint16_t, 16> scur = block_load<uint16_t, 16>(sp);
    for (int g = 0; g < per; g++) {
      simd<uint16_t, 16> snx;
      if (g + 1 < per) {
        nxt.template select<64, 1>(0) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * 128);
        nxt.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * 128 + 64);
        snx = block_load<uint16_t, 16>(sp + (size_t)(g + 1) * 16);
      }
      simd<float, 16 * R> ag = 0.f;
#pragma unroll
      for (int t = 0; t < 4; t++) {
        simd<uint32_t, 128> B;
#pragma unroll
        for (int h = 0; h < 2; h++) {
          simd<uint32_t, 16> x = cur.template select<16, 1>(64 * (t / 2) + 16 * (2 * (t % 2) + h));
#pragma unroll
          for (int pp = 0; pp < 4; pp++) {
            simd<uint32_t, 16> v = (pp == 0 ? x : (x >> (4 * pp))) & 0x000F000Fu;
            B.template select<16, 1>(16 * (4 * h + pp)) = v | 0x64006400u;
          }
        }
        simd<sycl::half, 256> bh = B.template bit_cast_view<sycl::half>();
        bh -= (sycl::half)1032.0f;
        simd<int32_t, 128> bi = bh.template bit_cast_view<int32_t>();
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv; xv.copy_from(X + (size_t)(t0 + (r < nt ? r : 0)) * ldx + (size_t)(g0 + g) * 64 + t * 16);
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<float, 16 * R> z = 0.f;
        ag = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(t == 0 ? z : ag, bi, av);
      }
      simd<sycl::half, 16> sh = scur.template bit_cast_view<sycl::half>();
      simd<float, 16> sf = sh;
#pragma unroll
      for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += ag.template select<16, 1>(16 * r) * sf;
      if (g + 1 < per) { cur = nxt; scur = snx; }
    }
    slm_block_store<float, 16 * R>(tid * 16 * R * 4, acc);
    barrier();
    if (tid == 0) {
      simd<float, 16 * R> sum = slm_block_load<float, 16 * R>(0);
      for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16 * R>(j * 16 * R * 4);
      if (rnd) {
        simd<uint32_t, 16 * R> u = sum.template bit_cast_view<uint32_t>();
        u += 0x7FFFu + ((u >> 16) & 1u); u &= 0xFFFF0000u;
        sum = u.template bit_cast_view<float>();
      }
#pragma unroll
      for (int r = 0; r < R; r++)
        if (r < nt) { simd<float, 16> o = sum.template select<16, 1>(16 * r); o.copy_to(Y + (size_t)(t0 + r) * ldy + rb * 16); }
    }
  });
}
// output head GEMV: int4 when XIK_HEAD_W4 is set, otherwise the dense path
static void head_gemv(xik_ctx *c, const float *X, int ldx, float *Y, int T, bool rnd, int ksd, int cls) {
  if (!c->head_w4) { gemv_bf16(c, c->unembed, X, ldx, Y, VOCAB, VOCAB, D, T, rnd, ksd, cls); return; }
  for (int t0 = 0; t0 < T; t0 += 8) {
    const int n = std::min(8, T - t0);
    if (n == 1) w4_gemv_r<12, 1>(c, c->head_w4, c->head_s4, X, ldx, Y, VOCAB, VOCAB, D, t0, n, rnd);
    else if (n == 2) w4_gemv_r<12, 2>(c, c->head_w4, c->head_s4, X, ldx, Y, VOCAB, VOCAB, D, t0, n, rnd);
    else if (n <= 4) w4_gemv_r<12, 4>(c, c->head_w4, c->head_s4, X, ldx, Y, VOCAB, VOCAB, D, t0, n, rnd);
    else w4_gemv_r<12, 8>(c, c->head_w4, c->head_s4, X, ldx, Y, VOCAB, VOCAB, D, t0, n, rnd);
  }
}
// ---------------------------------------------------------------------------------------------------------------------------------
// attention int4 (XIK_AW4): quantiser (group 64, optional zero point, squared-error / activation-weighted scale search) and the multi-segment GEMV
static void k_w4zpack(xik_ctx *c, const uint16_t *w, int rows, int K, int asym, int obj, const float *h, uint32_t *out, uint32_t *sz) {
  const int ngrp = K / 64, nrbp = rows / 16;
  const bool tm = getenv("XIK_W4TM") != nullptr;
  c->q.parallel_for(range<1>((size_t)rows * ngrp), [=](id<1> id) {
    const size_t r = id[0] / ngrp; const int g = (int)(id[0] % ngrp);
    const uint16_t *p = w + r * K + (size_t)g * 64;
    const float *hh = h ? h + (size_t)g * 64 : nullptr;
    float amax = 0.f, lo = 1e30f, hi = -1e30f;
    for (int i = 0; i < 64; i++) { float x = bf2f(p[i]); amax = sycl::fmax(amax, sycl::fabs(x)); lo = sycl::fmin(lo, x); hi = sycl::fmax(hi, x); }
    lo = sycl::fmin(lo, 0.f); hi = sycl::fmax(hi, 0.f);
    float bs = 0.f, bz = 8.f, be = 1e30f;
    const int ncand = obj ? 12 : 1;
    for (int cdt = 0; cdt < ncand; cdt++) {
      float sc, zp; const float shrink = 1.f - 0.04f * cdt;
      if (asym) { sc = (float)(sycl::half)((hi - lo) * shrink / 15.f); if (sc == 0.f) continue; zp = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(-lo * shrink / sc))); }
      else { sc = (float)(sycl::half)(amax * shrink / 7.5f); if (sc == 0.f) continue; zp = 8.f; }
      float e = 0.f;
      for (int i = 0; i < 64; i++) { float x = bf2f(p[i]); float q = sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / sc) + zp)); float d = x - (q - zp) * sc; e += (obj == 2 && hh ? hh[i] : 1.f) * d * d; }
      if (e < be) { be = e; bs = sc; bz = zp; }
    }
    const int rb = (int)(r / 16), n = (int)(r % 16);
    sz[(tm ? ((size_t)g * nrbp + rb) : ((size_t)rb * ngrp + g)) * 16 + n] = (uint32_t)sycl::bit_cast<uint16_t>((sycl::half)bs) | ((uint32_t)sycl::bit_cast<uint16_t>((sycl::half)(1024.f + bz)) << 16);
    for (int bl = 0; bl < 2; bl++)
      for (int q4 = 0; q4 < 4; q4++) {
        uint32_t d = 0;
        for (int j = 0; j < 8; j++) {
          float x = bf2f(p[bl * 32 + q4 * 8 + j]);
          uint32_t qv = bs == 0.f ? (uint32_t)bz : (uint32_t)sycl::fmin(15.f, sycl::fmax(0.f, sycl::rint(x / bs) + bz));
          d |= (j & 1) ? (qv << (16 + 4 * (j / 2))) : (qv << (4 * (j / 2)));
        }
        out[(tm ? (((size_t)g * nrbp + rb) * 2 + bl) : ((size_t)rb * (K / 32) + g * 2 + bl)) * 64 + q4 * 16 + n] = d;
      }
  });
}
namespace {
// W4A16 GEMV over several matrices in one launch: one work-group of KSD = 12 threads per 16-row block, K split in KSD parts of K/64/12 groups (3 or 4), partials summed in thread order.
template <int R>
static void w4z_r(xik_ctx *c, const W4Args &a, int t0, int nt) {
  constexpr int KSD = 12;
  const bool tm = getenv("XIK_W4TM") != nullptr;
  c->q.parallel_for(nd_range<1>((size_t)a.total_wg * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    slm_init<KSD * 16 * R * 4>();
    const int wgi = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    int si = 0;
    while (si + 1 < a.n && wgi >= a.s[si + 1].wg0) si++;
    const W4Seg &sd = a.s[si];
    const int rb = wgi - sd.wg0, K = sd.K, ngrp = K / 64, per = ngrp / KSD, g0 = tid * per;
    const int nrbw = sd.rows / 16;
    const size_t wst = tm ? (size_t)nrbw * 128 : 128, sst = tm ? (size_t)nrbw * 16 : 16;  // tm: group-major layout [group][row block]
    const uint32_t *wp = tm ? sd.W + ((size_t)g0 * nrbw + rb) * 128 : sd.W + ((size_t)rb * (K / 32) + (size_t)g0 * 2) * 64;
    const uint32_t *sp = tm ? sd.SZ + ((size_t)g0 * nrbw + rb) * 16 : sd.SZ + ((size_t)rb * ngrp + g0) * 16;
    simd<float, 16 * R> acc = 0.f;
    simd<uint32_t, 128> cur, nxt;
    cur.template select<64, 1>(0) = block_load<uint32_t, 64>(wp);
    cur.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + 64);
    simd<uint32_t, 16> scur = block_load<uint32_t, 16>(sp);
    for (int g = 0; g < per; g++) {
      simd<uint32_t, 16> snx;
      if (g + 1 < per) {
        nxt.template select<64, 1>(0) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * wst);
        nxt.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * wst + 64);
        snx = block_load<uint32_t, 16>(sp + (size_t)(g + 1) * sst);
      }
      simd<uint32_t, 16> zpair = (scur >> 16) * 0x10001u;  // (1024 + zero point) in both halves
      simd<float, 16 * R> ag = 0.f;
#pragma unroll
      for (int t = 0; t < 4; t++) {
        simd<uint32_t, 128> B;
#pragma unroll
        for (int h = 0; h < 2; h++) {
          simd<uint32_t, 16> x = cur.template select<16, 1>(64 * (t / 2) + 16 * (2 * (t % 2) + h));
#pragma unroll
          for (int pp = 0; pp < 4; pp++) {
            simd<uint32_t, 16> v = (pp == 0 ? x : (x >> (4 * pp))) & 0x000F000Fu;
            B.template select<16, 1>(16 * (4 * h + pp)) = v | 0x64006400u;
          }
        }
        simd<sycl::half, 256> bh = B.template bit_cast_view<sycl::half>();
        simd<uint32_t, 128> Z;
#pragma unroll
        for (int i = 0; i < 8; i++) Z.template select<16, 1>(16 * i) = zpair;
        bh -= Z.template bit_cast_view<sycl::half>();
        simd<int32_t, 128> bi = bh.template bit_cast_view<int32_t>();
        simd<int32_t, 8 * R> av;
#pragma unroll
        for (int r = 0; r < R; r++) {
          simd<float, 16> xv; xv.copy_from(sd.X + (size_t)(t0 + (r < nt ? r : 0)) * sd.ldx + (size_t)(g0 + g) * 64 + t * 16);
          simd<sycl::half, 16> xh = xv;
          av.template select<8, 1>(8 * r) = xh.template bit_cast_view<int32_t>();
        }
        simd<float, 16 * R> z = 0.f;
        ag = xmx::dpas<8, R, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(t == 0 ? z : ag, bi, av);
      }
      simd<uint16_t, 32> sv16 = scur.template bit_cast_view<uint16_t>();
      simd<uint16_t, 16> slo = sv16.template select<16, 2>(0);
      simd<sycl::half, 16> sh = slo.template bit_cast_view<sycl::half>();
      simd<float, 16> sf = sh;
#pragma unroll
      for (int r = 0; r < R; r++) acc.template select<16, 1>(16 * r) += ag.template select<16, 1>(16 * r) * sf;
      if (g + 1 < per) { cur = nxt; scur = snx; }
    }
    slm_block_store<float, 16 * R>(tid * 16 * R * 4, acc);
    barrier();
    if (tid == 0) {
      simd<float, 16 * R> sum = slm_block_load<float, 16 * R>(0);
      for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16 * R>(j * 16 * R * 4);
      if (sd.rnd) {
        simd<uint32_t, 16 * R> u = sum.template bit_cast_view<uint32_t>();
        u += 0x7FFFu + ((u >> 16) & 1u); u &= 0xFFFF0000u;
        sum = u.template bit_cast_view<float>();
      }
#pragma unroll
      for (int r = 0; r < R; r++)
        if (r < nt) { simd<float, 16> o = sum.template select<16, 1>(16 * r); o.copy_to(sd.Y + (size_t)(t0 + r) * sd.ldy + rb * 16); }
    }
  });
}
static void w4z_run(xik_ctx *c, const W4Args &a, int T) {
  for (int t0 = 0; t0 < T; t0 += 8) {
    const int n = std::min(8, T - t0);
    if (n == 1) w4z_r<1>(c, a, t0, n);
    else if (n == 2) w4z_r<2>(c, a, t0, n);
    else if (n <= 4) w4z_r<4>(c, a, t0, n);
    else w4z_r<8>(c, a, t0, n);
  }
}
}  // namespace
// L2 prefetch of the int4 attention weights of the NEXT visit, issued after the MoE of the current visit: the expert streams bypass L2 (ldp policy), the
// small kernels in between leave DRAM idle, and the attention GEMV of the next visit then reads its weights from L2 (XIK_AWPF=1, T <= 16 only).
struct PfArgs { const uint8_t *p[12]; uint32_t n256[12]; int n = 0; uint32_t total = 0; uint32_t start[12]; };
static void w4_prefetch_layer(xik_ctx *c, int layer, bool side) {
  if (layer < 0 || layer >= NLAYER || g_w4alt.empty()) return;
  const LayerW &lw = c->L[layer];
  const void *keys[6] = {lw.wq, lw.wk, lw.wv, lw.wo, lw.wr, lw.gate_attn};
  PfArgs a;
  for (int i = 0; i < 6; i++) {
    auto it = g_w4alt.find(keys[i]);
    if (it == g_w4alt.end()) continue;
    for (int part = 0; part < 2; part++) {
      const uint8_t *pp = (const uint8_t *)(part ? it->second.sz : it->second.w); size_t bytes = part ? it->second.sb : it->second.wb;
      a.p[a.n] = pp; a.n256[a.n] = (uint32_t)((bytes + 255) / 256); a.start[a.n] = a.total; a.total += a.n256[a.n]; a.n++;
    }
  }
  if (!a.total) return;
  const uint32_t nthr = 4096;
  static sycl::queue *q2 = nullptr;
  if (side && !q2) q2 = new sycl::queue(c->q.q.get_context(), c->q.q.get_device(), sycl::property_list{sycl::property::queue::in_order{}});
  auto body = [=](id<1> id) SYCL_ESIMD_KERNEL {
    using namespace es;
    for (uint32_t u = id[0]; u < a.total; u += nthr) {
      int s2 = 0; while (s2 + 1 < a.n && u >= a.start[s2 + 1]) s2++;
      prefetch<uint32_t, 64>((const uint32_t *)(a.p[s2] + (size_t)(u - a.start[s2]) * 256), sycl::ext::oneapi::experimental::properties{es::cache_hint_L1<es::cache_hint::uncached>, es::cache_hint_L2<es::cache_hint::cached>});
    }
  };
  if (side) q2->parallel_for(range<1>(nthr), body); else c->q.parallel_for(range<1>(nthr), body);
}
// activation statistics (XIK_ACT_STATS_FILE, written by XIK_ACT_STATS runs): mean squares per input channel, [layer][kind 0..3] and the head
static std::vector<float> g_ast[24][4]; static bool g_ast_loaded = false;
static void ensure_ast() {
  if (g_ast_loaded || !getenv("XIK_ACT_STATS_FILE")) return;
  g_ast_loaded = true; FILE *f = fopen(getenv("XIK_ACT_STATS_FILE"), "rb"); const int Ks[4] = {D, D, D, QD};
  if (!f) throw std::runtime_error("cannot open XIK_ACT_STATS_FILE");
  for (int l = 0; l < 24; l++) for (int k = 0; k < 4; k++) { float n; if (fread(&n, 4, 1, f) != 1) throw std::runtime_error("short stats file"); g_ast[l][k].resize(Ks[k]); if (fread(g_ast[l][k].data(), 4, Ks[k], f) != (size_t)Ks[k]) throw std::runtime_error("short stats file"); }
  fclose(f);
}
// XIK_AW4 = "wq_du=0-23;wk_dv=0-23;wo_ud=0-5,18-23": matrices (name substring) and layers that get an int4 copy
static bool aw4_selected(const std::string &name, int layer) {
  const char *e = getenv("XIK_AW4"); if (!e || layer < 0) return false;
  std::string spec = e; size_t b = 0;
  while (b < spec.size()) {
    size_t se = spec.find(';', b); if (se == std::string::npos) se = spec.size();
    std::string item = spec.substr(b, se - b); b = se + 1;
    size_t eq = item.find('='); if (eq == std::string::npos) continue;
    if (name.find(item.substr(0, eq)) == std::string::npos) continue;
    const char *q = item.c_str() + eq + 1;
    while (*q) { int lo = 0, hi = -1, nn = 0; if (sscanf(q, "%d-%d%n", &lo, &hi, &nn) < 2) { if (sscanf(q, "%d%n", &lo, &nn) < 1) break; hi = lo; } if (layer >= lo && layer <= hi) return true; q += nn; if (*q == ',') q++; }
  }
  return false;
}
extern "C" {
int xik_upload(xik_ctx *c, const char *name, int dtype, const void *src, size_t bytes) {
  try {
    Buf b;
    b.p = malloc_device(bytes + 64, c->q);
    g_alloc_total += bytes + 64;
    if (!b.p) throw std::runtime_error(std::string("device alloc failed for ") + name);
    b.bytes = bytes;
    b.dtype = dtype;
    c->q.memcpy(b.p, src, bytes).wait();
    c->tensors[name] = b;
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

int xik_finalize(xik_ctx *c) {
  try {
    const bool dense_fp8 = getenv("XIK_DENSE_FP8") != nullptr, head_fp8 = getenv("XIK_HEAD_FP8") != nullptr;
    auto repack = [&](const std::string &name, int rows, int K) {
      auto it = c->tensors.find(name);
      if (it == c->tensors.end()) return;
      int rows_pad = (rows + 15) / 16 * 16;
      bool mtp = name.rfind("mtp.", 0) == 0;
      bool want8 = !mtp && (name == "model.llm.unembed.weight" ? head_fp8 : dense_fp8);
      size_t nb = (size_t)rows_pad * K * (want8 ? 1 : 2);
      uint32_t *nw = (uint32_t *)alloc_expert(c, nb + 64);
      if (!nw) throw std::runtime_error("repack alloc failed: " + name);
      require_aligned(nw, 256, "dense repacked weights");
      {
        static const int w4g = getenv("XIK_W4SIM") ? atoi(getenv("XIK_W4SIM")) : 0, w4m = getenv("XIK_W4MASK") ? atoi(getenv("XIK_W4MASK")) : 7;
        static const int w4a = getenv("XIK_W4ASYM") ? atoi(getenv("XIK_W4ASYM")) : 0, w4o = getenv("XIK_W4OBJ") ? atoi(getenv("XIK_W4OBJ")) : 1;
        static std::vector<float> st_h[24][4]; static std::vector<float> st_head; static bool st_loaded = false;
        if (w4g && w4o == 2 && !st_loaded && getenv("XIK_ACT_STATS_FILE")) {  // activation mean squares written by XIK_ACT_STATS runs
          st_loaded = true; FILE *f = fopen(getenv("XIK_ACT_STATS_FILE"), "rb"); const int Ks[4] = {D, D, D, QD};
          if (!f) throw std::runtime_error("cannot open XIK_ACT_STATS_FILE");
          for (int l = 0; l < 24; l++) for (int k = 0; k < 4; k++) { float n; if (fread(&n, 4, 1, f) != 1) throw std::runtime_error("short stats file"); st_h[l][k].resize(Ks[k]); if (fread(st_h[l][k].data(), 4, Ks[k], f) != (size_t)Ks[k]) throw std::runtime_error("short stats file"); for (auto &v : st_h[l][k]) v /= std::max(n, 1.f); }
          float n; st_head.resize(D); if (fread(&n, 4, 1, f) != 1 || fread(st_head.data(), 4, D, f) != (size_t)D) throw std::runtime_error("short stats file"); for (auto &v : st_head) v /= std::max(n, 1.f);
          fclose(f);
        }
        auto has = [&](const char *sub) { return name.find(sub) != std::string::npos; };
        int bit = (has("attn.wq_du") || has("attn.wk_dv") || has("attn.wv_dv") || has("attn.wr_du") || has("attn.gate_attn")) ? 1 : has("attn.wo_ud") ? 2 : name == "model.llm.unembed.weight" ? 4 : 0;
        if (w4g && getenv("XIK_W4SEL")) {  // per-matrix / per-layer selection: XIK_W4SEL=comma list of name substrings (wq_du,wk_dv,wv_dv,wr_du,gate_attn,wo_ud,unembed), XIK_W4LAYERS=lo-hi
          bool hit = false; std::string sel = getenv("XIK_W4SEL"); size_t b0 = 0;
          while (b0 <= sel.size()) { size_t e0 = sel.find(',', b0); if (e0 == std::string::npos) e0 = sel.size(); if (e0 > b0 && has(sel.substr(b0, e0 - b0).c_str())) hit = true; b0 = e0 + 1; }
          size_t lp = name.find("layers."); int ly = lp == std::string::npos ? -1 : atoi(name.c_str() + lp + 7);
          if (hit && getenv("XIK_W4LAYERS") && ly >= 0) { int lo = 0, hi = 99; sscanf(getenv("XIK_W4LAYERS"), "%d-%d", &lo, &hi); if (ly < lo || ly > hi) hit = false; }
          bit = hit ? w4m : 0;
        }
        if (w4g && (w4m & bit) && K % w4g == 0) {
          float *dh = nullptr;
          if (w4o == 2 && st_loaded) {
            const float *hp = nullptr; size_t pos = name.find("layers.");
            int layer = pos == std::string::npos ? -1 : atoi(name.c_str() + pos + 7);
            if (name == "model.llm.unembed.weight") hp = st_head.data();
            else if (layer >= 0 && layer < 24) {
              int kind = has("attn.wo_ud") ? 3 : (has("attn.wk_dv") && !is_local(layer)) ? 1 : (has("attn.wv_dv") && !is_local(layer)) ? 2 : 0;
              hp = st_h[layer][kind].data();
            }
            if (hp) { dh = sycl::malloc_device<float>(K, c->q.q); c->q.memcpy(dh, hp, K * 4).wait(); }
          }
          k_w4sim(c, (uint16_t *)it->second.p, rows, K, w4g, w4a, w4o, dh); c->q.wait();
          if (dh) sycl::free(dh, c->q);
        }
      }
      {
        size_t lp = name.find("layers."); int ly = lp == std::string::npos ? -1 : atoi(name.c_str() + lp + 7);
        if (!mtp && ly >= 0 && ly < 24 && K % 64 == 0 && rows % 16 == 0 && aw4_selected(name, ly)) {
          static const int aasym = getenv("XIK_AW4_ASYM") ? atoi(getenv("XIK_AW4_ASYM")) : 1;
          static const int aobj = getenv("XIK_AW4_OBJ") ? atoi(getenv("XIK_AW4_OBJ")) : (getenv("XIK_ACT_STATS_FILE") ? 2 : 1);
          ensure_ast();
          auto has2 = [&](const char *sub) { return name.find(sub) != std::string::npos; };
          int kind = has2("attn.wo_ud") ? 3 : (has2("attn.wk_dv") && !is_local(ly)) ? 1 : (has2("attn.wv_dv") && !is_local(ly)) ? 2 : 0;
          float *dh = nullptr;
          if (aobj == 2 && g_ast_loaded) { dh = sycl::malloc_device<float>(K, c->q.q); c->q.memcpy(dh, g_ast[ly][kind].data(), K * 4).wait(); }
          uint32_t *w4 = (uint32_t *)alloc_expert(c, (size_t)rows * K / 2 + 4096), *sz = (uint32_t *)alloc_expert(c, (size_t)rows * (K / 64) * 4 + 4096);
          require_aligned(w4, 256, "attention int4 weights");
          k_w4zpack(c, (const uint16_t *)it->second.p, rows, K, aasym, aobj, dh, w4, sz); c->q.wait();
          if (dh) sycl::free(dh, c->q);
          g_w4alt[nw] = W4Alt{w4, sz, (size_t)rows * K / 2, (size_t)rows * (K / 64) * 4};
        }
      }
      if (want8) {
        float *sc = (float *)malloc_device((size_t)rows_pad * 4 + 64, c->q);
        k_quant_fp8(c, (const uint16_t *)it->second.p, nw, sc, rows, rows_pad, K);
        g_fp8_scale[nw] = sc;
      } else {
        k_repack_bf16(c, (const uint16_t *)it->second.p, nw, rows, rows_pad, K);
      }
      c->q.wait();
      sycl::free(it->second.p, c->q);
      it->second.p = nw;
      it->second.bytes = nb;
    };
    for (int l = 0; l < NLAYER; l++) {
      std::string p = "model.llm.layers." + std::to_string(l) + ".";
      repack(p + "attn.wq_du.weight", QD, D);
      repack(p + "attn.wk_dv.weight", KVD, D);
      repack(p + "attn.wv_dv.weight", KVD, D);
      repack(p + "attn.wr_du.weight", RD, D);
      repack(p + "attn.attn_sink_proj.weight", NH, D);
      repack(p + "attn.gate_attn.weight", QD, D);
      repack(p + "attn.wo_ud.weight", D, QD);
      repack(p + "attn.k_sconv.weight_proj", 32, D);
      repack(p + "attn.v_sconv.weight_proj", 32, D);
      for (const char *cn : {"attn", "k", "v", "mlp"}) {
        std::string cp = p + "controllers." + cn + ".";
        repack(cp + "down_weight", RANK, 2 * D);
        repack(cp + "gain_weight", D, RANK);
        repack(cp + "forget_weight", D, RANK);
      }
    }
    for (int i = 0; i < 3; i++) {
      std::string p = "mtp.layers." + std::to_string(i) + ".";
      repack(p + "self_attn.q_proj.weight", QD, D);
      repack(p + "self_attn.k_proj.weight", KVD, D);
      repack(p + "self_attn.v_proj.weight", KVD, D);
      repack(p + "self_attn.k_proj_ctx.weight", KVD, D);
      repack(p + "self_attn.v_proj_ctx.weight", KVD, D);
      repack(p + "self_attn.o_proj.weight", D, QD);
      repack(p + "mlp.gate_proj.weight", DFF_, D);
      repack(p + "mlp.up_proj.weight", DFF_, D);
      repack(p + "mlp.down_proj.weight", D, DFF_);
    }
    c->embed = tp16(c, "model.llm.embed.weight");
    c->embed_norm = tp16(c, "model.llm.embed_norm.weight");
    c->unembed = tp16(c, "model.llm.unembed.weight");
    c->final_norm = tp16(c, "model.llm.norm.weight");
    for (int l = 0; l < NLAYER - 1; l++) c->attnres_q[l] = tpf(c, "model.llm.attn_res.attn_queries." + std::to_string(l));
    for (int l = 0; l < NLAYER; l++) c->attnres_mlp[l] = tpf(c, "model.llm.attn_res.mlp_queries." + std::to_string(l));
    c->attnres_out = tpf(c, "model.llm.attn_res.output_query");
    c->xpass_q = tpf(c, "model.llm.middle_cycle_cross_pass_queries");
    c->xpass_kvq = tpf(c, "model.llm.middle_cycle_cross_pass_kv_queries");
    for (int l = 0; l < NLAYER; l++) {
      std::string p = "model.llm.layers." + std::to_string(l) + ".";
      LayerW &w = c->L[l];
      memset(&w, 0, sizeof(w));
      w.wq = tp16(c, p + "attn.wq_du.weight");
      w.wk = tp16(c, p + "attn.wk_dv.weight");
      w.wv = tp16(c, p + "attn.wv_dv.weight");
      w.wr = tp16(c, p + "attn.wr_du.weight");
      w.sink = tp16(c, p + "attn.attn_sink_proj.weight");
      w.gate_attn = tp16(c, p + "attn.gate_attn.weight");
      w.wo = tp16(c, p + "attn.wo_ud.weight");
      w.q_clip = tp16(c, p + "attn.q_l2_clip.scale");
      w.rel_clip = tp16(c, p + "attn.rel_l2_clip.scale");
      w.rel_proj = tp16(c, p + "attn.rel_logits_proj.proj");
      if (is_local(l)) {
        w.k_conv = tp16(c, p + "attn.k_sconv.weight");
        w.v_conv = tp16(c, p + "attn.v_sconv.weight");
        w.attn_norm = tp16(c, p + "attn_norm.weight");
      } else {
        w.k_static = tp16(c, p + "attn.k_sconv.static_w");
        w.k_dynw = tp16(c, p + "attn.k_sconv.weight_proj");
        w.v_static = tp16(c, p + "attn.v_sconv.static_w");
        w.v_dynw = tp16(c, p + "attn.v_sconv.weight_proj");
        w.q_norm = tp16(c, p + "q_input_norm.weight");
        w.k_norm = tp16(c, p + "k_input_norm.weight");
        w.v_norm = tp16(c, p + "v_input_norm.weight");
      }
      w.attn_conv = tp16(c, p + "attn_sconv.weight");
      w.mlp_conv = tp16(c, p + "mlp_sconv.weight");
      w.mlp_norm = tp16(c, p + "mlp_norm.weight");
      w.router = tp16(c, p + "mlp.gate.weight");
      w.router_bias = tpf(c, p + "mlp.gate.bias");
      if (l >= CORE0 && l < CORE1) {
        const char *cn[4] = {"attn", "k", "v", "mlp"};
        for (int j = 0; j < 4; j++) {
          std::string cp = p + "controllers." + cn[j] + ".";
          w.ctl_down[j] = tp16(c, cp + "down_weight");
          w.ctl_gain[j] = tp16(c, cp + "gain_weight");
          w.ctl_forget[j] = tp16(c, cp + "forget_weight");
        }
      }
      if (is_mxfp8(l) && use_int8()) {
        for (int m = 0; m < 2; m++) {
          std::string wn = p + (m ? "mlp.experts.w2_weight" : "mlp.experts.w13_weight");
          std::string sn = wn + "_scale";
          int rows = m ? D : 2 * FI, K = m ? FI : D;
          Buf &wb = c->tensors.at(wn), &sb = c->tensors.at(sn);
          size_t nbw = (size_t)NE * rows * K, nbs = (size_t)NE * rows * (K / 32) * 2;
          uint8_t *nw = (uint8_t *)malloc_device(nbw + 64, c->q), *ns = (uint8_t *)malloc_device(nbs + 64, c->q);
          if (!nw || !ns) throw std::runtime_error("int8 repack alloc failed");
          k_requant_int8(c, (const uint8_t *)wb.p, (const uint8_t *)sb.p, (uint32_t *)nw, (uint16_t *)ns, rows, K);
          c->q.wait();
          sycl::free(wb.p, c->q); sycl::free(sb.p, c->q);
          wb.p = nw; sb.p = ns; wb.bytes = nbw; sb.bytes = nbs;
        }
      } else if (is_mxfp8(l) && !getenv("XIK_OLD_FP8")) {
        for (int m = 0; m < 2; m++) {
          std::string wn = p + (m ? "mlp.experts.w2_weight" : "mlp.experts.w13_weight");
          std::string sn = wn + "_scale";
          int rows = m ? D : 2 * FI, K = m ? FI : D;
          Buf &wb = c->tensors.at(wn), &sb = c->tensors.at(sn);
          size_t wo = woff_bytes();
          uint8_t *nw0 = (uint8_t *)alloc_expert(c, wb.bytes + 64 + 4096), *ns0 = (uint8_t *)alloc_expert(c, sb.bytes + 64 + 4096);
          if (!nw0 || !ns0) throw std::runtime_error("repack alloc failed");
          uint8_t *nw = nw0 + wo, *ns = ns0 + wo;
          require_aligned(nw0, 256, "MXFP8 expert weights (allocation)"); require_aligned(ns0, 256, "MXFP8 expert scales (allocation)");
          require_aligned(nw, 16, "MXFP8 expert weights"); require_aligned(ns, 16, "MXFP8 expert scales");
          if (wo == 0) { require_aligned(nw, 256, "MXFP8 expert weights"); require_aligned(ns, 256, "MXFP8 expert scales"); }
          k_repack_mxfp8(c, (const uint8_t *)wb.p, (uint32_t *)nw, (const uint8_t *)sb.p, ns, rows, K);
          c->q.wait();
          sycl::free(wb.base ? wb.base : wb.p, c->q); sycl::free(sb.base ? sb.base : sb.p, c->q);
          wb.p = nw; sb.p = ns; wb.base = nw0; sb.base = ns0;
        }
      }
      if (!is_mxfp8(l)) {
        for (int m = 0; m < 2; m++) {
          std::string wn = p + (m ? "mlp.experts.w2_weight" : "mlp.experts.w13_weight");
          std::string sn = wn + "_scale";
          int rows = m ? D : 2 * FI, K = m ? FI : D;
          Buf &wb = c->tensors.at(wn), &sb = c->tensors.at(sn);
          {  // W3A16 experts: XIK_W3=1, XIK_W3L=lo-hi layers (default all NVFP4 layers), XIK_W3W=1 w13 / 2 w2 / 3 both (default 3), XIK_W3NC clipping candidates
            static const bool w3on = getenv("XIK_W3") && atoi(getenv("XIK_W3")) != 0;
            static const int w3w = getenv("XIK_W3W") ? atoi(getenv("XIK_W3W")) : 3, w3nc = getenv("XIK_W3NC") ? atoi(getenv("XIK_W3NC")) : 8;
            bool in3 = !getenv("XIK_W3L");  // XIK_W3L = comma separated layers / ranges, e.g. "0-5,7,9-11"
            if (!in3) { const char *q = getenv("XIK_W3L"); while (*q) { int lo = 0, hi = -1, nn = 0; if (sscanf(q, "%d-%d%n", &lo, &hi, &nn) < 2) { if (sscanf(q, "%d%n", &lo, &nn) < 1) break; hi = lo; } if (l >= lo && l <= hi) in3 = true; q += nn; if (*q == ',') q++; } }
            if (w3on && (w3w & (1 << m)) && in3) {
              Buf &ab = c->tensors.at(wn + "_amax"), &db = c->tensors.at(wn + "_outer_scale_denominator");
              const size_t nwb = (size_t)NE * (rows / 16) * (K / 128) * 768, nsb = (size_t)NE * (rows / 16) * (K / 64) * 32;
              uint8_t *w0 = (uint8_t *)alloc_expert(c, nwb + 4096), *s0 = (uint8_t *)alloc_expert(c, nsb + 4096);
              if (!w0 || !s0) throw std::runtime_error("W3 alloc failed");
              require_aligned(w0, 256, "W3 expert weights"); require_aligned(s0, 256, "W3 expert scales");
              k_w3pack(c, (const uint8_t *)wb.p, (const uint8_t *)sb.p, (const float *)ab.p, (const float *)db.p, rows, K, (uint32_t *)w0, (uint16_t *)s0, w3nc);
              c->q.wait();
              sycl::free(wb.base ? wb.base : wb.p, c->q); sycl::free(sb.base ? sb.base : sb.p, c->q);
              wb.p = w0; sb.p = s0; wb.base = w0; sb.base = s0; wb.bytes = nwb; sb.bytes = nsb;
              g_w3sel[l][m] = true;
              continue;
            }
          }
          size_t wo = woff_bytes();
          uint8_t *nw0 = (uint8_t *)alloc_expert(c, wb.bytes + 64 + 4096), *ns0 = (uint8_t *)alloc_expert(c, sb.bytes + 64 + 4096);
          if (!nw0 || !ns0) throw std::runtime_error("repack alloc failed");
          uint8_t *nw = nw0 + wo, *ns = ns0 + wo;
          require_aligned(nw0, 256, "NVFP4 expert weights (allocation)"); require_aligned(ns0, 256, "NVFP4 expert scales (allocation)");
          require_aligned(nw, 16, "NVFP4 expert weights"); require_aligned(ns, 16, "NVFP4 expert scales");
          if (wo == 0) { require_aligned(nw, 256, "NVFP4 expert weights"); require_aligned(ns, 256, "NVFP4 expert scales"); }
          {  // expert quantisation simulation: XIK_E3SIM=bits (3|2), XIK_E3G=group (default 64), XIK_E3W=1 w13 /2 w2 /3 both, XIK_E3L=lo-hi layers, XIK_E3NC scale candidates, XIK_E3MAP=file (bytes [l][m][e] = bits 4|3|2 overrides), XIK_E3ERR=csv path
            static const int e3b = getenv("XIK_E3SIM") ? atoi(getenv("XIK_E3SIM")) : 0, e3g = getenv("XIK_E3G") ? atoi(getenv("XIK_E3G")) : 64;
            static const int e3w = getenv("XIK_E3W") ? atoi(getenv("XIK_E3W")) : 3, e3nc = getenv("XIK_E3NC") ? atoi(getenv("XIK_E3NC")) : 8;
            static std::vector<uint8_t> e3map; static bool e3loaded = false;
            if (!e3loaded) { e3loaded = true; if (getenv("XIK_E3MAP")) { FILE *f = fopen(getenv("XIK_E3MAP"), "rb"); if (!f) throw std::runtime_error("XIK_E3MAP"); e3map.resize(24 * 2 * NE); if (fread(e3map.data(), 1, e3map.size(), f) != e3map.size()) throw std::runtime_error("short XIK_E3MAP"); fclose(f); } }
            int lo = 0, hi = 99; if (getenv("XIK_E3L")) sscanf(getenv("XIK_E3L"), "%d-%d", &lo, &hi);
            if ((e3b || !e3map.empty()) && (e3w & (1 << m)) && l >= lo && l <= hi) {
              // MAP mode: per expert bits; uniform mode: all experts.  Run the kernel per bits class on the whole tensor, then restore other experts from a backup.
              size_t nw_b = (size_t)NE * rows * (K / 2), ns_b = (size_t)NE * rows * (K / 16);
              std::vector<uint8_t> bits_e(NE, (uint8_t)e3b);
              if (!e3map.empty()) for (int e = 0; e < NE; e++) bits_e[e] = e3map[((size_t)l * 2 + m) * NE + e];
              uint8_t *bw = nullptr, *bs2 = nullptr;
              if (!e3map.empty()) { bw = sycl::malloc_device<uint8_t>(nw_b, c->q.q); bs2 = sycl::malloc_device<uint8_t>(ns_b, c->q.q); c->q.memcpy(bw, wb.p, nw_b); c->q.memcpy(bs2, sb.p, ns_b); c->q.wait(); }
              float *derr = sycl::malloc_device<float>((size_t)NE * rows * 2, c->q.q);
              int done_bits = 0;
              for (int bt : {3, 2}) {
                bool any = false; for (int e = 0; e < NE; e++) if (bits_e[e] == bt) any = true;
                if (!any) continue; done_bits |= bt;
                k_e3sim(c, (uint8_t *)wb.p, (uint8_t *)sb.p, rows, K, e3g, bt, e3nc, derr); c->q.wait();
                if (!e3map.empty()) {  // keep only the experts of this class; others return to the backup (re-run overwrites in order: restore later)
                  std::vector<uint8_t> hm(NE); for (int e = 0; e < NE; e++) hm[e] = bits_e[e] == bt;
                  // copy this class's result to a side buffer by swapping: simple approach = process classes sequentially from the backup
                  uint8_t *tw = sycl::malloc_device<uint8_t>(nw_b, c->q.q), *ts2 = sycl::malloc_device<uint8_t>(ns_b, c->q.q);
                  c->q.memcpy(tw, wb.p, nw_b); c->q.memcpy(ts2, sb.p, ns_b); c->q.memcpy(wb.p, bw, nw_b); c->q.memcpy(sb.p, bs2, ns_b); c->q.wait();
                  // merge: wb/sb currently original; write class experts from tw/ts2 into the backup arrays (bw/bs2 hold the running merge)
                  for (int e = 0; e < NE; e++) if (hm[e]) { c->q.memcpy(bw + (size_t)e * rows * (K / 2), tw + (size_t)e * rows * (K / 2), (size_t)rows * (K / 2)); c->q.memcpy(bs2 + (size_t)e * rows * (K / 16), ts2 + (size_t)e * rows * (K / 16), (size_t)rows * (K / 16)); }
                  c->q.wait(); sycl::free(tw, c->q); sycl::free(ts2, c->q);
                }
              }
              if (!e3map.empty()) { c->q.memcpy(wb.p, bw, nw_b); c->q.memcpy(sb.p, bs2, ns_b); c->q.wait(); sycl::free(bw, c->q); sycl::free(bs2, c->q); }
              if (getenv("XIK_E3ERR")) {
                std::vector<float> he((size_t)NE * rows * 2); c->q.memcpy(he.data(), derr, he.size() * 4).wait();
                FILE *f = fopen(getenv("XIK_E3ERR"), "a");
                for (int e = 0; e < NE; e++) { double a = 0, b = 0; for (int r = 0; r < rows; r++) { a += he[2 * ((size_t)e * rows + r)]; b += he[2 * ((size_t)e * rows + r) + 1]; } fprintf(f, "%d,%d,%d,%d,%.6g\n", l, m, e, bits_e[e], b > 0 ? a / b : 0.0); }
                fclose(f);
              }
              sycl::free(derr, c->q);
              (void)done_bits;
            }
          }
          k_repack_fp4(c, (const uint8_t *)wb.p, nw, (const uint8_t *)sb.p, ns, rows, K);
          c->q.wait();
          sycl::free(wb.base ? wb.base : wb.p, c->q); sycl::free(sb.base ? sb.base : sb.p, c->q);
          wb.p = nw; sb.p = ns; wb.base = nw0; sb.base = ns0;
        }
      }
      w.w3_13 = g_w3sel[l][0]; w.w3_2 = g_w3sel[l][1];
      w.w13 = tp8(c, p + "mlp.experts.w13_weight");
      w.w13_s = tp8(c, p + "mlp.experts.w13_weight_scale");
      w.w2 = tp8(c, p + "mlp.experts.w2_weight");
      w.w2_s = tp8(c, p + "mlp.experts.w2_weight_scale");
      if (!is_mxfp8(l)) {
        w.w13_amax = tpf(c, p + "mlp.experts.w13_weight_amax");
        w.w2_amax = tpf(c, p + "mlp.experts.w2_weight_amax");
        w.w13_den = tpf(c, p + "mlp.experts.w13_weight_outer_scale_denominator");
        w.w2_den = tpf(c, p + "mlp.experts.w2_weight_outer_scale_denominator");
      }
    }
    // state
    int T = c->max_tokens;
    for (int s = 0; s < NSLOT; s++) {
      int layer = s < NLAYER ? s : CORE0 + (s - NLAYER) % NCORE;
      size_t cap = is_local(layer) ? RING : (size_t)c->max_ctx;
      c->kbf16 = !(getenv("XIK_KBF16") && atoi(getenv("XIK_KBF16")) == 0);  // default on (lossless, see docs/attention-vprefetch.md); XIK_KBF16=0 = fp32 K cache
      c->kcache[s] = c->kbf16 ? reinterpret_cast<float *>(dalloc<uint16_t>(c, cap * KVD)) : dalloc<float>(c, cap * KVD);
      c->vcache[s] = dalloc<float>(c, cap * KVD);
      for (int k = 0; k < 2; k++) c->convst[s][k] = dalloc<float>(c, 3 * (2 * KVD + 2 * D));
    }
    auto A = [&](size_t n) { return dalloc<float>(c, n); };
    c->stream = A((size_t)T * D);
    for (auto &b : c->pool) b = A((size_t)T * D);
    for (int j = 0; j < 3; j++) {
      c->pairb3[j] = A((size_t)T * 2 * D); c->hid3[j] = A((size_t)T * RANK);
      c->cg3[j] = A((size_t)T * D); c->cf3[j] = A((size_t)T * D);
    }
    for (auto &b : c->mix) b = A((size_t)T * D);
    for (auto &b : c->msg) b = A((size_t)T * D);
    for (auto &b : c->in) b = A((size_t)T * D);
    c->tmp0 = A((size_t)T * D * 2);
    c->tmp1 = A((size_t)T * D * 2);
    c->qb = A((size_t)T * QD);
    c->kb = A((size_t)T * KVD);
    c->vb = A((size_t)T * KVD);
    c->rb = A((size_t)T * RD);
    c->sinkb = A((size_t)T * NH);
    c->gateb = A((size_t)T * QD);
    c->dynk = A((size_t)T * 32);
    c->dynv = A((size_t)T * 32);
    c->attn_o = A((size_t)T * QD);
    c->ao2 = A((size_t)T * D);
    c->hid = A((size_t)T * RANK);
    c->pairb = A((size_t)T * 2 * D);
    c->gu = A((size_t)T * TOPK * 2 * FI);
    c->act = A((size_t)T * TOPK * FI);
    c->ypair = A((size_t)T * TOPK * D);
    c->gu_part = A((size_t)KSMAX * T * TOPK * 2 * FI);
    c->yp_part = A((size_t)KSMAX * T * TOPK * D);
    c->x16_in = dalloc<sycl::half>(c, (size_t)T * D);
    c->x16_act = dalloc<sycl::half>(c, (size_t)T * TOPK * FI);
    require_aligned(c->x16_in, 256, "x16_in"); require_aligned(c->x16_act, 256, "x16_act"); require_aligned(c->gu_part, 16, "gu_part"); require_aligned(c->yp_part, 16, "yp_part");
    c->rwt = A((size_t)T * TOPK);
    c->moe_o = A((size_t)T * D);
    c->convout = A((size_t)T * D);
    c->scr = A(8192);
    c->ahi = dalloc<int8_t>(c, (size_t)T * TOPK * 2304); c->alo = dalloc<uint8_t>(c, (size_t)T * TOPK * 2304); c->asx = dalloc<float>(c, (size_t)T * TOPK);
    c->ecnt = dalloc<int32_t>(c, NE); c->elist = dalloc<int32_t>(c, (size_t)NE * T); c->act_e = dalloc<int32_t>(c, NE); c->nact = dalloc<int32_t>(c, 4); c->desc = dalloc<int32_t>(c, (size_t)NE * 16);
    c->cap = A((size_t)CAPR * 4 * D);
    for (int sl = 0; sl < NSLOT; sl++) {
      c->sv_k[sl] = A((size_t)T * KVD); c->sv_v[sl] = A((size_t)T * KVD);
      c->sv_a[sl] = A((size_t)T * D); c->sv_m[sl] = A((size_t)T * D);
    }
    c->logits = A((size_t)T * VOCAB);
    c->ridx = dalloc<int32_t>(c, (size_t)T * TOPK);
    c->ids_d = dalloc<int32_t>(c, T + 8);
    c->dparams = c->ids_d + T;
    c->am_d = dalloc<int32_t>(c, T);
    c->trace_dev = A((size_t)NSLOT * T * D);
    init_drafter(c);
    // int4 head is the head format of the approximate (FP8) mode: XIK_HEAD_FP8=1 now selects it; XIK_HEAD_W4=0 keeps the FP8 head, XIK_HEAD_W4=64 forces it
    const int head_w4 = getenv("XIK_HEAD_W4") ? atoi(getenv("XIK_HEAD_W4")) : (getenv("XIK_HEAD_FP8") ? 64 : 0);
    if (head_w4 == 64) {  // int4 head: quantise the bf16 checkpoint weights (group 64, symmetric, squared-error scale search)
      auto it = c->tensors.find("model.llm.unembed.weight");
      if (it == c->tensors.end()) throw std::runtime_error("unembed missing");
      c->head_w4 = (uint32_t *)alloc_expert(c, (size_t)VOCAB * D / 2 + 64);
      c->head_s4 = (uint16_t *)alloc_expert(c, (size_t)VOCAB / 16 * (D / 64) * 32 + 64);
      require_aligned(c->head_w4, 256, "int4 head weights");
      float *dh = nullptr;
      if (getenv("XIK_ACT_STATS_FILE") && getenv("XIK_HEAD_W4_OBJ") && atoi(getenv("XIK_HEAD_W4_OBJ")) == 2) {  // activation-weighted error: needs the statistics file written by XIK_ACT_STATS runs
        FILE *f = fopen(getenv("XIK_ACT_STATS_FILE"), "rb"); const int Ks[4] = {D, D, D, QD}; if (!f) throw std::runtime_error("cannot open XIK_ACT_STATS_FILE");
        size_t skip = 0; for (int l = 0; l < 24; l++) for (int k = 0; k < 4; k++) skip += 4 + (size_t)Ks[k] * 4;
        fseek(f, (long)skip, SEEK_SET); float n = 1; std::vector<float> hv(D); if (fread(&n, 4, 1, f) != 1 || fread(hv.data(), 4, D, f) != (size_t)D) throw std::runtime_error("short stats file"); fclose(f);
        for (auto &v : hv) v /= std::max(n, 1.f);
        dh = sycl::malloc_device<float>(D, c->q.q); c->q.memcpy(dh, hv.data(), D * 4).wait();
      }
      k_w4pack(c, (const uint16_t *)it->second.p, VOCAB, D, getenv("XIK_HEAD_W4_OBJ") ? std::min(1, atoi(getenv("XIK_HEAD_W4_OBJ"))) : 1, dh, c->head_w4, c->head_s4);
      c->q.wait(); if (dh) sycl::free(dh, c->q);
      sycl::free(it->second.p, c->q); it->second.p = nullptr; it->second.bytes = 0;
      c->unembed = nullptr;
    } else {
      repack("model.llm.unembed.weight", VOCAB, D);
      c->unembed = tp16(c, "model.llm.unembed.weight");
    }
    c->q.wait();
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

void xik_reset(xik_ctx *c) {
  c->pos = 0;
  c->dpos = 0;
  c->cap_pos = c->ing_pos = 0;
  // KV needs no clearing (positions are tracked); conv history must be zero.
  for (int s = 0; s < NSLOT; s++) {
    c->cpar[s] = 0;
    for (int k = 0; k < 2; k++) c->q.memset(c->convst[s][k], 0, 3 * (2 * KVD + 2 * D) * 4);
  }
  c->q.wait();
}
int xik_pos(xik_ctx *c) { return c->pos; }
void xik_trace(xik_ctx *c, float *buf) { c->trace_host = buf; }
void xik_prof_enable(xik_ctx *c, int on) { c->prof = on; memset(c->prof_us, 0, sizeof(c->prof_us)); }
void xik_prof_get(xik_ctx *c, double *us) { memcpy(us, c->prof_us, sizeof(c->prof_us)); }

}  // extern "C"

// ------------------------------------------------------------ forward pass
namespace {

// prof phase ids
enum { P_MIX = 0, P_NORM, P_GEMV_ATTN, P_KV, P_ATTN, P_WO, P_CONV, P_MOE_ROUTE, P_MOE_W13, P_MOE_W2, P_LOOP, P_HEAD, P_MISC };

void k_capture(xik_ctx *c, const float *src, int idx, int T) {
  float *dst = c->cap;
  const int32_t *dpp = c->dparams;
  c->q.parallel_for(range<1>((size_t)T * D), [=](id<1> i) {
    size_t t = i[0] / D;
    int d = (int)(i[0] % D);
    size_t row = (size_t)((dpp[1] + (int)t) % CAPR);
    dst[(row * 4 + idx) * D + d] = src[i[0]];
  });
}

// state' = last 3 of [old state ; first n rows of the saved chunk inputs], all four streams of one slot
void k_commit_slot(xik_ctx *c, int slot, int n) {
  int par = c->cpar[slot];
  const float *old = c->convst[slot][par];
  float *nw = c->convst[slot][1 - par];
  const float *xk = c->sv_k[slot], *xv = c->sv_v[slot], *xa = c->sv_a[slot], *xm = c->sv_m[slot];
  c->q.parallel_for(range<1>((size_t)3 * (2 * KVD + 2 * D)), [=](id<1> id) {
    size_t i = id[0];
    int stream, C;
    const float *x;
    size_t base;
    if (i < (size_t)3 * KVD) { stream = 0; C = KVD; x = xk; base = 0; }
    else if (i < (size_t)6 * KVD) { stream = 1; C = KVD; x = xv; base = (size_t)3 * KVD; }
    else if (i < (size_t)6 * KVD + 3 * D) { stream = 2; C = D; x = xa; base = (size_t)6 * KVD; }
    else { stream = 3; C = D; x = xm; base = (size_t)6 * KVD + 3 * D; }
    (void)stream;
    size_t j = i - base;
    int s = (int)(j / C), ch = (int)(j % C);
    int src = n - 3 + s;
    nw[i] = src >= 0 ? x[(size_t)src * C + ch] : old[base + (size_t)(n + s) * C + ch];
  });
  c->cpar[slot] = 1 - par;
}

// ============================================================ DSpark drafter
// 3-layer block drafter (diffusion-style): the anchor token plus 7 mask positions are processed
// bidirectionally against a cache of target-hidden-state keys, then an RNN "markov" head picks the 7 tokens
// one after the other. Follows inkling2_dspark (MLX) semantics; bf16 rounding at the same places.
constexpr int DNL = 3, DFF = 9216, DRANK = 256, DB = 8, DCNT = 7;
constexpr float ROPE_BASE = 1000000.0f;
inline bool d_local(int i) { return i == 0 || i == 2; }

// out[t] = rbf(rms_w( sum_j alpha[j] * rbf(cap[t][j]) , w ))
void d_mix(xik_ctx *c, const float *cap, int n, const float *alpha, const uint16_t *w, float *out) {
  c->q.parallel_for(nd_range<1>((size_t)n * 256, 256), [=](nd_item<1> it) {
    int t = it.get_group(0), l = it.get_local_id(0);
    float v[9], ss = 0.f;
    for (int i = 0; i < 9; i++) {
      float a = 0.f;
      for (int j = 0; j < 4; j++) a += rbf(cap[((size_t)t * 4 + j) * D + l + i * 256]) * alpha[j];
      v[i] = a;
      ss += a * a;
    }
    ss = reduce_over_group(it.get_group(), ss, plus<float>());
    float inv = sycl::rsqrt(ss / D + EPS);
    for (int i = 0; i < 9; i++) out[(size_t)t * D + l + i * 256] = rbf(v[i] * inv * bf2f(w[l + i * 256]));
  });
}

// per (token, head): optional RMS norm (weight w), optional RoPE (non-traditional, pairs i / i+64), write to dst.
// cache: dst token slot = ring ? pos % ring : pos ; otherwise slot = t.
void d_head_prep(xik_ctx *c, const float *src, int nheads, const uint16_t *w, bool rope, int pos0, int n, float *dst,
                 int ring, bool cache) {
  c->q.parallel_for(nd_range<1>((size_t)n * nheads * 64, 64), [=](nd_item<1> it) {
    int idx = it.get_group(0), l = it.get_local_id(0);
    int t = idx / nheads, h = idx % nheads;
    const float *sp = src + (size_t)t * nheads * HD + h * HD;
    float a = sp[l], b = sp[l + 64];
    if (w) {
      float ss = reduce_over_group(it.get_group(), a * a + b * b, plus<float>());
      float inv = sycl::rsqrt(ss / HD + EPS);
      a = rbf(a * inv * bf2f(w[l]));
      b = rbf(b * inv * bf2f(w[l + 64]));
    }
    if (rope) {
      float ang = (float)(pos0 + t) * sycl::exp(-sycl::log(ROPE_BASE) * (float)l / 64.0f);
      float cs = sycl::cos(ang), sn = sycl::sin(ang);
      float o1 = a * cs - b * sn, o2 = a * sn + b * cs;
      a = rbf(o1);
      b = rbf(o2);
    }
    size_t slot = cache ? (size_t)(ring ? (pos0 + t) % ring : (pos0 + t)) : (size_t)t;
    float *dp = dst + slot * nheads * HD + h * HD;
    dp[l] = a;
    dp[l + 64] = b;
  });
}

// block attention: 8 queries x 24 heads, keys = cached context (window for local layers) + all 8 block keys.
void d_attn(xik_ctx *c, int li, const float *q, const float *kb, const float *vb, float *out) {
  bool local = d_local(li);
  int dpos = c->dpos;
  int lo = local ? std::max(0, dpos - WIN) : 0;
  int nctx = dpos - lo;
  const float *kc = c->dkc[li], *vc = c->dvc[li];
  int maxk = (local ? WIN : c->max_ctx) + DB;
  const float scale = 1.0f / sycl::sqrt((float)HD);
  c->q.submit([&](handler &h) {
    local_accessor<float, 1> lg(range<1>(maxk), h);
    local_accessor<float, 1> qs(range<1>(HD), h);
    h.parallel_for(nd_range<1>((size_t)DB * NH * HD, HD), [=](nd_item<1> it) {
      int idx = it.get_group(0), tid = it.get_local_id(0);
      int r = idx / NH, hh = idx % NH, kvh = hh / (NH / NKV);
      auto g = it.get_group();
      qs[tid] = q[(size_t)r * QD + hh * HD + tid];
      group_barrier(g);
      int nk = nctx + DB;
      float mx = -3.0e38f;
      for (int j = tid; j < nk; j += HD) {
        const float *kr;
        if (j < nctx) {
          int p = lo + j;
          kr = kc + (size_t)(local ? p % RING : p) * KVD + kvh * HD;
        } else {
          kr = kb + (size_t)(j - nctx) * KVD + kvh * HD;
        }
        float sacc = 0.f;
        for (int d = 0; d < HD; d += 4) {
          vec<float, 4> kk = *reinterpret_cast<const vec<float, 4> *>(kr + d);
          sacc += qs[d] * kk[0] + qs[d + 1] * kk[1] + qs[d + 2] * kk[2] + qs[d + 3] * kk[3];
        }
        sacc *= scale;
        lg[j] = sacc;
        mx = sycl::fmax(mx, sacc);
      }
      mx = reduce_over_group(g, mx, maximum<float>());
      float den = 0.f;
      for (int j = tid; j < nk; j += HD) {
        float e = sycl::exp(lg[j] - mx);
        lg[j] = e;
        den += e;
      }
      den = reduce_over_group(g, den, plus<float>());
      group_barrier(g);
      float o = 0.f;
      for (int j = 0; j < nk; j++) {
        const float *vr;
        if (j < nctx) {
          int p = lo + j;
          vr = vc + (size_t)(local ? p % RING : p) * KVD + kvh * HD;
        } else {
          vr = vb + (size_t)(j - nctx) * KVD + kvh * HD;
        }
        o += lg[j] * vr[tid];
      }
      out[(size_t)r * QD + hh * HD + tid] = rbf(o / den);
    });
  });
}

// sum = (first ? x : x + res); res = rbf(sum)
void d_addres(xik_ctx *c, const float *x, float *res, float *sum, bool first, size_t n) {
  c->q.parallel_for(range<1>(n), [=](id<1> i) {
    float v = first ? x[i[0]] : x[i[0]] + res[i[0]];
    sum[i[0]] = v;
    res[i[0]] = rbf(v);
  });
}
void d_silu_mul(xik_ctx *c, const float *g, const float *u, float *act, size_t n) {
  c->q.parallel_for(range<1>(n), [=](id<1> i) { act[i[0]] = rbf(g[i[0]] * sigmoidf(g[i[0]]) * u[i[0]]); });
}
void d_mask_rows(xik_ctx *c) {
  float *dx = c->dx;
  const uint16_t *m = c->d_mask;
  c->q.parallel_for(range<1>((size_t)(DB - 1) * D), [=](id<1> i) { dx[D + i[0]] = bf2f(m[i[0] % D]); });
}
void d_mk_in(xik_ctx *c) {
  float *in = c->dmkin;
  const float *xf = c->dxf, *fr = c->dfrnn;
  c->q.parallel_for(range<1>((size_t)DCNT * 2 * D), [=](id<1> i) {
    size_t r = i[0] / (2 * D);
    int k = (int)(i[0] % (2 * D));
    in[r * 2 * D + k] = k < D ? xf[(r + 1) * D + k] : fr[k - D];
  });
}
// RNN step: raw = rbf(W[:, :512] @ [state; w1[prev]] + ctx[i] + b); state' ; latent
void d_mk_state(xik_ctx *c, int i, int32_t anchor_tok_dev_idx) {
  const uint16_t *rw = c->mk_rw, *rb = c->mk_rb, *w1 = c->mk_w1;
  const float *ctxv = c->dmkctx + (size_t)i * 768;
  float *st = c->dmkst, *raw = c->dmkraw, *lat = c->dmklat;
  const int32_t *prevp = c->dtok + (i == 0 ? DCNT : i - 1);
  (void)anchor_tok_dev_idx;
  c->q.submit([&](handler &h) {
    h.parallel_for(nd_range<1>(768, 768), [=](nd_item<1> it) {
      int o = it.get_local_id(0);
      auto g = it.get_group();
      int prev = prevp[0];
      float acc = 0.f;
      const uint16_t *row = rw + (size_t)o * 5120;
      for (int k = 0; k < DRANK; k++) acc += bf2f(row[k]) * st[k];
      for (int k = 0; k < DRANK; k++) acc += bf2f(row[DRANK + k]) * bf2f(w1[(size_t)prev * DRANK + k]);
      raw[o] = rbf(acc + ctxv[o] + bf2f(rb[o]));
      group_barrier(g);
      if (o < DRANK) {
        float gt = rbf(sigmoidf(raw[o])), cd = rbf(sycl::tanh(raw[DRANK + o]));
        st[o] = rbf(rbf(gt * st[o]) + rbf((1.f - gt) * cd));
        lat[o] = rbf(sycl::tanh(raw[2 * DRANK + o]));
      }
    });
  });
}
// logits[v] = softcap(rbf(base[i][v] + rbf(foldB[v] + latent . foldW[v])))
void d_mk_logits(xik_ctx *c, int i) {
  const uint16_t *fw = c->foldW, *fb = c->foldB;
  const float *lat = c->dmklat, *base = c->dbase + (size_t)i * VOCAB;
  float *lg = c->dlg;
  int nsg = VOCAB / 4, wg = 128;
  int nwg = (nsg * 16 + wg - 1) / wg;
  c->q.parallel_for(nd_range<1>((size_t)nwg * wg, wg), [=](nd_item<1> it) SUBGROUP16 {
    auto sg = it.get_sub_group();
    int lane = sg.get_local_linear_id();
    int gsg = (int)(it.get_global_linear_id() / 16);
    if (gsg >= nsg) return;
    int row0 = gsg * 4;
    float acc[4] = {0, 0, 0, 0};
    for (int k8 = lane; k8 < DRANK / 8; k8 += 16) {
      float xv[8];
      for (int e = 0; e < 8; e++) xv[e] = lat[k8 * 8 + e];
      for (int r = 0; r < 4; r++) {
        vec<uint32_t, 4> w = *reinterpret_cast<const vec<uint32_t, 4> *>(fw + (size_t)(row0 + r) * DRANK + k8 * 8);
        for (int e = 0; e < 4; e++) {
          acc[r] += sycl::bit_cast<float>(w[e] << 16) * xv[2 * e] + sycl::bit_cast<float>(w[e] & 0xFFFF0000u) * xv[2 * e + 1];
        }
      }
    }
    for (int r = 0; r < 4; r++) {
      float sm = reduce_over_group(sg, acc[r], plus<float>());
      if (lane == 0) {
        float bias = rbf(bf2f(fb[row0 + r]) + sm);
        float l = rbf(base[row0 + r] + bias);
        lg[row0 + r] = rbf(FINAL_CAP * sycl::tanh(l / FINAL_CAP));
      }
    }
  });
}
void d_argmax(xik_ctx *c, int i) {
  const float *lg = c->dlg;
  int32_t *out = c->dtok + i;
  c->q.parallel_for(nd_range<1>(1024, 1024), [=](nd_item<1> it) {
    int l = it.get_local_id(0);
    auto g = it.get_group();
    float best = -3.0e38f;
    int bi = VOCAB_U;
    for (int k = l; k < VOCAB_U; k += 1024)
      if (lg[k] > best) { best = lg[k]; bi = k; }
    float m = reduce_over_group(g, best, maximum<float>());
    int cand = (best == m) ? bi : VOCAB_U;
    int idx = reduce_over_group(g, cand, minimum<int>());
    if (l == 0) out[0] = idx;
  });
}
// fold = unembed @ hidden_out.weight (bf16, fp32 accumulate), once at load
void d_fold(xik_ctx *c) {
  const uint16_t *U = c->unembed, *hw = c->mk_hw, *hb = c->mk_hb;
  uint16_t *fw = c->foldW, *fbias = c->foldB;
  c->q.parallel_for(range<1>((size_t)VOCAB * DRANK), [=](id<1> id) {
    size_t v = id[0] / DRANK;
    int r = (int)(id[0] % DRANK);
    float acc = 0.f;
    const uint16_t *ur = U + v * D;
    for (int d = 0; d < D; d++) acc += bf2f(ur[d]) * bf2f(hw[(size_t)d * DRANK + r]);
    uint32_t u = sycl::bit_cast<uint32_t>(acc);
    u += 0x7FFFu + ((u >> 16) & 1u);
    fw[id[0]] = (uint16_t)(u >> 16);
  });
  c->q.parallel_for(range<1>((size_t)VOCAB), [=](id<1> id) {
    float acc = 0.f;
    const uint16_t *ur = U + id[0] * D;
    for (int d = 0; d < D; d++) acc += bf2f(ur[d]) * bf2f(hb[d]);
    uint32_t u = sycl::bit_cast<uint32_t>(acc);
    u += 0x7FFFu + ((u >> 16) & 1u);
    fbias[id[0]] = (uint16_t)(u >> 16);
  });
}

void init_drafter(xik_ctx *c) {
  auto tp = [&](const std::string &n) { return (const uint16_t *)c->tensors.at(n).p; };
    if (c->tensors.count("mtp.fuse_weight")) {
      auto M = [&](const std::string &n) { return tp("mtp." + n); };
      c->d_fuse = M("fuse_weight"); c->d_norm = M("norm.weight"); c->d_mask = M("mask_embed");
      c->mk_dfl = M("markov_head.dflare_norm.weight"); c->mk_hw = M("markov_head.hidden_out.weight");
      c->mk_hb = M("markov_head.hidden_out.bias"); c->mk_w1 = M("markov_head.markov_w1.weight");
      c->mk_rw = M("markov_head.rnn_proj.weight"); c->mk_rb = M("markov_head.rnn_proj.bias");
      for (int i = 0; i < DNL; i++) {
        std::string p = "layers." + std::to_string(i) + ".";
        auto &d = c->dl[i];
        d.inln = M(p + "input_layernorm.weight"); d.postln = M(p + "post_attention_layernorm.weight"); d.dfl = M(p + "dflare_norm.weight");
        d.qp = M(p + "self_attn.q_proj.weight"); d.kp = M(p + "self_attn.k_proj.weight"); d.vp = M(p + "self_attn.v_proj.weight");
        d.kpc = M(p + "self_attn.k_proj_ctx.weight"); d.vpc = M(p + "self_attn.v_proj_ctx.weight"); d.op = M(p + "self_attn.o_proj.weight");
        d.qn = M(p + "self_attn.q_norm.weight"); d.kn = M(p + "self_attn.k_norm.weight"); d.knc = M(p + "self_attn.k_norm_ctx.weight");
        d.gp = M(p + "mlp.gate_proj.weight"); d.up = M(p + "mlp.up_proj.weight"); d.dp = M(p + "mlp.down_proj.weight");
        size_t cap = d_local(i) ? RING : (size_t)c->max_ctx;
        c->dkc[i] = dalloc<float>(c, cap * KVD);
        c->dvc[i] = dalloc<float>(c, cap * KVD);
      }
      {  // alpha = bf16(softmax(fuse_weight rows))
        uint16_t fw[16];
        c->q.memcpy(fw, c->d_fuse, 32).wait();
        float al[16];
        for (int r = 0; r < 4; r++) {
          float mx = -1e30f, e[4], sum = 0;
          for (int j = 0; j < 4; j++) { uint32_t u = (uint32_t)fw[r * 4 + j] << 16; float f; memcpy(&f, &u, 4); e[j] = f; mx = std::max(mx, f); }
          for (int j = 0; j < 4; j++) { e[j] = sycl::exp(e[j] - mx); sum += e[j]; }
          for (int j = 0; j < 4; j++) {
            float a = e[j] / sum; uint32_t u; memcpy(&u, &a, 4); u += 0x7FFF + ((u >> 16) & 1); u &= 0xFFFF0000u; memcpy(&a, &u, 4);
            al[r * 4 + j] = a;
          }
        }
        c->d_alpha = dalloc<float>(c, 16);
        c->q.memcpy(c->d_alpha, al, 64).wait();
      }
      c->foldW = dalloc<uint16_t>(c, (size_t)VOCAB * DRANK);
      c->foldB = dalloc<uint16_t>(c, VOCAB);
      d_fold(c);
      auto A2 = [&](size_t n) { return dalloc<float>(c, n); };
      size_t TT = (size_t)std::max(c->max_tokens, DB);
      c->dx = A2(DB * D); c->dres = A2(DB * D); c->dsum = A2(DB * D); c->dnorm = A2(DB * D);
      c->dq = A2(DB * QD); c->dk = A2(DB * KVD); c->dv = A2(DB * KVD); c->dat = A2(DB * QD); c->dtmp = A2(DB * D);
      c->dg = A2(DB * DFF); c->du = A2(DB * DFF); c->dact = A2(DB * DFF);
      c->dctxn = A2(TT * D); c->dkctx = A2(TT * KVD); c->dvctx = A2(TT * KVD);
      c->dbase = A2((size_t)DCNT * VOCAB); c->dxf = A2(DB * D);
      c->dmkin = A2(DCNT * 2 * D); c->dmkctx = A2(DCNT * 768); c->dmkst = A2(DRANK); c->dmkraw = A2(768); c->dmklat = A2(DRANK);
      c->dlg = A2(VOCAB); c->dfrnn = A2(D);
      c->dtok = dalloc<int32_t>(c, 16);
      c->has_dr = true;
      c->q.wait();
    }
}

struct Fwd {
  float *blk[4] = {nullptr, nullptr, nullptr, nullptr};
  int nb = 0;
  float *cur = nullptr;
  float *bank[2] = {nullptr, nullptr};
  std::vector<float *> freel;
  float *pop() { float *p = freel.back(); freel.pop_back(); return p; }
};

// ---------------------------------------------------------------------------------------------------------------------------------
// Fused ESIMD controller tail (T == 1): gain/forget GEMV (same DPAS recipe and summation order as dgemm_t, K = RANK = 64) + tanh + blend + rms norm
// in one launch with one software grid barrier.  Phase 1: every thread owns two 16-row blocks, computes gain g and forget f of its channels exactly as the
// GEMV kernel does, forms v = (1 - tanh f) * dest + tanh g * msg and stores v.  Barrier.  Phase 2: every thread recomputes the sum of squares over all
// 2304 channels in exactly the order of reduce_over_group (per work-item 9 values ascending, then halving trees over a sub-group of 32 and over the 8
// sub-groups -- verified bit for bit by --test-ctl) and writes rbf(v * rsqrt(ss/D + eps) * w).  tanh is the only part that is not bit-identical:
// XIK_CTL_TANH selects the variant (0 = exp/inv short sequence, 1 = piecewise polynomial; see ctl_tanh_*).
// Deadlock safety: 9 work-groups of 8 threads per stream, at most 3 streams (216 threads, far below the 1280 resident hardware threads); the spin is bounded.
namespace ctlx {
using namespace sycl::ext::intel::esimd;
template <int TV>
ESIMD_INLINE simd<float, 16> th(simd<float, 16> x) {
  simd<float, 16> ax = abs(x);
  simd<float, 16> r;
  if constexpr (TV == 0) {  // B: tanh|x| = 1 - 2/(exp(2|x|)+1), small |x| by the odd Taylor series
    simd<float, 16> e = exp(ax * 2.0f);
    r = 1.0f - 2.0f * inv(e + 1.0f);
    simd<float, 16> x2 = ax * ax;
    simd<float, 16> sm = ax * (1.0f + x2 * (-0.33333334f + x2 * (0.13333334f + x2 * -0.05396825f)));
    r.merge(sm, ax < 0.12f);
    r.merge(simd<float, 16>(1.0f), ax > 9.0f);
  } else if constexpr (TV == 2) {  // timing-only (WRONG numbers): the cheapest possible stand-in, bounds what any faster tanh could save
    r = ax * 0.5f;
  } else {  // C: placeholder = same as B (replaced by the fitted piecewise polynomial)
    simd<float, 16> e = exp(ax * 2.0f);
    r = 1.0f - 2.0f * inv(e + 1.0f);
    simd<float, 16> x2 = ax * ax;
    simd<float, 16> sm = ax * (1.0f + x2 * (-0.33333334f + x2 * (0.13333334f + x2 * -0.05396825f)));
    r.merge(sm, ax < 0.12f);
    r.merge(simd<float, 16>(1.0f), ax > 9.0f);
  }
  r.merge(-r, x < 0.0f);
  return r;
}
ESIMD_INLINE simd<int32_t, 8> pack_a(const float *hid, int t, bool fp8) {  // 16 fp32 activations as a DPAS A operand, as dgemm_t does: fp8 weights -> fp16 pairs, bf16 weights -> truncated bf16 pairs
  simd<float, 16> xv; xv.copy_from(hid + t * 16);
  if (fp8) {
    simd<sycl::half, 16> xh = xv;
    return xh.template bit_cast_view<int32_t>();
  }
  simd<uint32_t, 16> xb = xv.template bit_cast_view<uint32_t>();
  simd<uint32_t, 8> ev = xb.template select<8, 2>(0), od = xb.template select<8, 2>(1);
  simd<uint32_t, 8> pk = (ev >> 16) | (od & 0xFFFF0000u);
  return pk.template bit_cast_view<int32_t>();
}
// 16 rows, K = 64: four tiles, each its own accumulator from 0 (dgemm_t keeps one tile per thread), summed t0+t1+t2+t3, then (fp8) the per-row scale * 256
ESIMD_INLINE simd<float, 16> gemv64(const uint32_t *wp, const float *scale, int rb, simd<int32_t, 32> av, simd<int32_t, 32> avh) {
  simd<float, 16> s = 0.f;
  if (scale) {
#pragma unroll
    for (int t = 0; t < 4; t++) {
      simd<uint32_t, 64> bq; bq.copy_from(wp + (size_t)t * 64);
      simd<uint32_t, 128> B;
#pragma unroll
      for (int q = 0; q < 4; q++) {
        simd<uint32_t, 16> xq = bq.template select<16, 1>(16 * q);
        simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
        B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
        B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
      }
      simd<int32_t, 128> bi = B.template bit_cast_view<int32_t>();
      simd<int32_t, 8> a8 = avh.template select<8, 1>(8 * t);
      simd<float, 16> z = 0.f;
      simd<float, 16> d = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(z, bi, a8);
      if (t == 0) s = d; else s += d;
    }
    simd<float, 16> sv; sv.copy_from(scale + rb * 16);
    sv *= 256.0f;
    s *= sv;
    return s;
  }
#pragma unroll
  for (int t = 0; t < 4; t++) {
    simd<uint32_t, 64> t0v, t1v;
    t0v.copy_from(wp + (size_t)t * 128); t1v.copy_from(wp + (size_t)t * 128 + 64);
    simd<uint32_t, 128> b; b.template select<64, 1>(0) = t0v; b.template select<64, 1>(64) = t1v;
    simd<int32_t, 128> bi = b.template bit_cast_view<int32_t>();
    simd<float, 16> z = 0.f;
    simd<int32_t, 8> a8 = av.template select<8, 1>(8 * t);
    simd<float, 16> d = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::bf16, xmx::dpas_argument_type::bf16>(z, bi, a8);
    if (t == 0) s = d; else s += d;
  }
  return s;
}
ESIMD_INLINE simd<int32_t, 8> pack_v(simd<float, 16> xv, bool fp8) {  // same as pack_a for a register operand
  if (fp8) { simd<sycl::half, 16> xh = xv; return xh.template bit_cast_view<int32_t>(); }
  simd<uint32_t, 16> xb = xv.template bit_cast_view<uint32_t>();
  simd<uint32_t, 8> ev = xb.template select<8, 2>(0), od = xb.template select<8, 2>(1);
  simd<uint32_t, 8> pk = (ev >> 16) | (od & 0xFFFF0000u);
  return pk.template bit_cast_view<int32_t>();
}
// sum of squares of 2304 values in the exact order of reduce_over_group over 256 work-items x 9 values (see --test-ctl), then rsqrt(ss/D + eps)
template <int DV = 0>
ESIMD_INLINE float norm_inv(const float *x, bool coherent) {
  simd<float, 256> p;
#pragma unroll
  for (int i = 0; i < 9; i++) {
    simd<float, 256> v;
#pragma unroll
    for (int q4 = 0; q4 < 4; q4++) {
      if (coherent) v.template select<64, 1>(64 * q4) = block_load<float, 64>(x + i * 256 + 64 * q4, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
      else v.template select<64, 1>(64 * q4) = block_load<float, 64>(x + i * 256 + 64 * q4);
    }
    if (i == 0) p = v * v; else p += v * v;
  }
  simd<float, 8> sg;
#pragma unroll
  for (int g = 0; g < 8; g++) {
    simd<float, 16> h = p.template select<16, 1>(32 * g) + p.template select<16, 1>(32 * g + 16);
    simd<float, 8> h8 = h.template select<8, 1>(0) + h.template select<8, 1>(8);
    simd<float, 4> h4 = h8.template select<4, 1>(0) + h8.template select<4, 1>(4);
    simd<float, 2> h2 = h4.template select<2, 1>(0) + h4.template select<2, 1>(2);
    sg[g] = h2[0] + h2[1];
  }
  simd<float, 4> w4 = sg.template select<4, 1>(0) + sg.template select<4, 1>(4);
  simd<float, 2> w2 = w4.template select<2, 1>(0) + w4.template select<2, 1>(2);
  const float ss = w2[0] + w2[1];
  float q;
  if constexpr (DV == 0) q = ss / (float)D;
  else if constexpr (DV == 1) q = ss * (1.0f / (float)D);
  else if constexpr (DV == 2) q = ss * inv(simd<float, 1>((float)D))[0];
  else q = (ss * 0.00390625f) / 9.0f;  // exact scaling by 2^-8, then /9
  return rsqrt(simd<float, 1>(q + EPS))[0];
}
ESIMD_INLINE simd<int32_t, 128> unpack_fp8(simd<uint32_t, 64> bq) {  // one 16x16 fp8 e4m3 tile -> fp16 bit patterns (value * 2^-8), as dgemm_t
  simd<uint32_t, 128> B;
#pragma unroll
  for (int q = 0; q < 4; q++) {
    simd<uint32_t, 16> xq = bq.template select<16, 1>(16 * q);
    simd<uint32_t, 16> m0 = xq & 0x00FF00FFu, m1 = (xq >> 8) & 0x00FF00FFu;
    B.template select<16, 1>(16 * (2 * q)) = ((m0 & 0x007F007Fu) << 7) | ((m0 & 0x00800080u) << 8);
    B.template select<16, 1>(16 * (2 * q + 1)) = ((m1 & 0x007F007Fu) << 7) | ((m1 & 0x00800080u) << 8);
  }
  return B.template bit_cast_view<int32_t>();
}
ESIMD_INLINE simd<float, 16> rbf16(simd<float, 16> x) {
  simd<uint32_t, 16> u = x.template bit_cast_view<uint32_t>();
  u += 0x7FFFu + ((u >> 16) & 1u);
  u &= 0xFFFF0000u;
  return u.template bit_cast_view<float>();
}
}  // namespace ctlx

#define GRID_BARRIER(TARGET)                                                                                                                        \
  {                                                                                                                                                 \
    fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();                                                                           \
    barrier();                                                                                                                                      \
    if (tid == 0) {                                                                                                                                 \
      atomic_update<atomic_op::inc, uint32_t, 1>(a.bar, simd<uint32_t, 1>(0));                                                                      \
      uint32_t spins = 0;                                                                                                                           \
      while (!(a.dbg & 1) && spins < 200000u) {                                                                                                     \
        uint32_t cur = atomic_update<atomic_op::add, uint32_t, 1>(a.bar, simd<uint32_t, 1>(0), simd<uint32_t, 1>(0))[0];                            \
        if (cur >= (TARGET)) break;                                                                                                                 \
        spins++;                                                                                                                                    \
      }                                                                                                                                             \
      if (spins >= 200000u) atomic_update<atomic_op::inc, uint32_t, 1>(a.err, simd<uint32_t, 1>(0));                                              \
    }                                                                                                                                               \
    barrier();                                                                                                                                      \
    fence<memory_kind::global, fence_flush_op::none, fence_scope::gpu>();                                                                           \
  }
#define CTL_STAMP(I) if (a.ts && tid == 0) { simd<uint64_t, 1> tv_ = rdtsc(); a.ts[((size_t)a.tsidx * 54 + wg) * 6 + (I)] = tv_[0]; }
struct CtlFArgs {
  const uint32_t *wg[3], *wf[3];
  const float *sg[3], *sf[3];  // fp8 per-row scales (null = bf16 weights)
  const float *hid[3], *dest[3], *msg[3];
  const uint16_t *nw[3];
  float *out[3], *vbuf[3];
  uint32_t *bar;
  uint32_t target;
  uint32_t *err;
  int dbg;  // 1: no grid barrier wait (debug)
  // full fusion (pairnorm + down GEMV in the same launch)
  const uint32_t *wd[3]; const float *sd[3]; float *hp[3]; float *hdbg[3]; uint32_t base;
  uint64_t *ts; int tsidx;  // optional per-work-group phase timestamps (XIK_CTL_TS=1): 6 stamps per work-group
};
template <int TV, bool FULL = false>
void k_ctl_fused(xik_ctx *c, const CtlFArgs &a, int n) {
  const uint32_t nwg = (uint32_t)n * 9;
  c->q.parallel_for(nd_range<1>((size_t)nwg * 8, 8), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace sycl::ext::intel::esimd;
    slm_init<64>();
    const int wg = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    if (a.dbg & 8) return;  // debug: empty kernel
    CTL_STAMP(0)
    const int k = wg / 9, ts = (wg % 9) * 8 + tid;  // thread index within the stream, 0..71
    simd<int32_t, 32> av, avh;
    if constexpr (FULL) {
      // ---- phase 0: pairnorm (recomputed per unit, exact order) + ctl_down GEMV partials.  Unit u = rb * 16 + t16: row block rb of the 64 rank rows,
      //      tiles 18*t16 .. 18*t16+17 of the 288 K tiles (the K split of dgemm_t with KSD = 16, per = 18).  Partials -> global, barrier, then every
      //      thread sums the 16 partials of each row block in the order dgemm_t uses, applies scale and bf16 rounding -> hid (registers).
      const bool fpd = a.sd[k] != nullptr;
      const int tw = fpd ? 64 : 128;
      if (ts < 64) {
        const int rb0 = ts / 16, t16 = ts % 16;  // 16 K-partials of 18 tiles per row block, as dgemm_t (KSD = 16)
        const float *xseg = (t16 < 8) ? a.dest[k] : a.msg[k];
        const int off = (t16 & 7) * 288;
        const float inv_ = ctlx::norm_inv(xseg, false);
        const uint32_t *wp = a.wd[k] + ((size_t)rb0 * 288 + t16 * 18) * tw;
        simd<float, 16> acc = 0.f;
        if (fpd) {
          simd<uint32_t, 384> cur, nxt;
#pragma unroll
          for (int i = 0; i < 6; i++) cur.template select<64, 1>(64 * i) = block_load<uint32_t, 64>(wp + (size_t)i * 64);
#pragma unroll
          for (int g3 = 0; g3 < 3; g3++) {
            if (g3 < 2) {
#pragma unroll
              for (int i = 0; i < 6; i++) nxt.template select<64, 1>(64 * i) = block_load<uint32_t, 64>(wp + (size_t)((g3 + 1) * 6 + i) * 64);
            }
#pragma unroll
            for (int i = 0; i < 6; i++) {
              simd<float, 16> xv; xv.copy_from(xseg + off + 16 * (g3 * 6 + i));
              xv = ctlx::rbf16(xv * inv_);
              simd<int32_t, 8> a8 = ctlx::pack_v(xv, true);
              simd<int32_t, 128> bi = ctlx::unpack_fp8(cur.template select<64, 1>(64 * i));
              acc = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(acc, bi, a8);
            }
            if (g3 < 2) cur = nxt;
          }
        } else {
          for (int i = 0; i < 18; i++) {
            simd<uint32_t, 64> t0v, t1v;
            t0v.copy_from(wp + (size_t)i * 128); t1v.copy_from(wp + (size_t)i * 128 + 64);
            simd<uint32_t, 128> b2; b2.template select<64, 1>(0) = t0v; b2.template select<64, 1>(64) = t1v;
            simd<int32_t, 128> bi = b2.template bit_cast_view<int32_t>();
            simd<float, 16> xv; xv.copy_from(xseg + off + 16 * i);
            xv = ctlx::rbf16(xv * inv_);
            simd<int32_t, 8> a8 = ctlx::pack_v(xv, false);
            acc = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::bf16, xmx::dpas_argument_type::bf16>(acc, bi, a8);
          }
        }
        acc.copy_to(a.hp[k] + ts * 16);
      }
      CTL_STAMP(1)
      GRID_BARRIER(a.base + nwg)
      CTL_STAMP(2)
#pragma unroll
      for (int rb = 0; rb < 4; rb++) {
        simd<float, 16> sum = block_load<float, 16>(a.hp[k] + rb * 256, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
        for (int j = 1; j < 16; j++)
          sum += block_load<float, 16>(a.hp[k] + rb * 256 + j * 16, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
        if (fpd) { simd<float, 16> sv; sv.copy_from(a.sd[k] + rb * 16); sv *= 256.0f; sum *= sv; }
        sum = ctlx::rbf16(sum);
        av.template select<8, 1>(8 * rb) = ctlx::pack_v(sum, false);
        avh.template select<8, 1>(8 * rb) = ctlx::pack_v(sum, true);
        if (a.hdbg[k] && ts == 0) sum.copy_to(a.hdbg[k] + rb * 16);
      }
    } else {
#pragma unroll
      for (int t = 0; t < 4; t++) { av.template select<8, 1>(8 * t) = ctlx::pack_a(a.hid[k], t, false); avh.template select<8, 1>(8 * t) = ctlx::pack_a(a.hid[k], t, true); }
    }
    const int tile = a.sg[k] ? 64 : 128;
    if (a.dbg & 16) return;  // debug: after the A-operand packing only
    simd<float, 16> vv[2];
#pragma unroll
    for (int u = 0; u < 2; u++) {
      const int rb = ts + 72 * u;
      simd<float, 16> g = ctlx::gemv64(a.wg[k] + (size_t)rb * 4 * tile, a.sg[k], rb, av, avh);
      simd<float, 16> f = ctlx::gemv64(a.wf[k] + (size_t)rb * 4 * tile, a.sf[k], rb, av, avh);
      simd<float, 16> de, ms;
      de.copy_from(a.dest[k] + rb * 16); ms.copy_from(a.msg[k] + rb * 16);
      simd<float, 16> tf = ctlx::th<TV>(f), tg = ctlx::th<TV>(g);
      simd<float, 16> m1 = (1.0f - tf) * de, m2 = tg * ms;
      vv[u] = m1 + m2;
      vv[u].copy_to(a.vbuf[k] + rb * 16);
    }
    if (a.dbg & 2) return;  // debug: phase 1 only
    if (a.dbg & 2) return;  // debug: phase 1 only
    CTL_STAMP(3)
    GRID_BARRIER(a.base + (FULL ? 2u : 1u) * nwg)
    CTL_STAMP(4)
    // ---- phase 2: sum of squares in the exact order of reduce_over_group
    simd<float, 256> p;
    {
      simd<float, 256> v0;
#pragma unroll
      for (int q4 = 0; q4 < 4; q4++)
        v0.template select<64, 1>(64 * q4) = block_load<float, 64>(a.vbuf[k] + 64 * q4, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
      p = v0 * v0;
    }
    for (int i = 1; i < 9; i++) {
      simd<float, 256> vi;
#pragma unroll
      for (int q4 = 0; q4 < 4; q4++)
        vi.template select<64, 1>(64 * q4) = block_load<float, 64>(a.vbuf[k] + i * 256 + 64 * q4, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
      p += vi * vi;
    }
    simd<float, 8> sg;
#pragma unroll
    for (int g = 0; g < 8; g++) {
      simd<float, 16> h = p.template select<16, 1>(32 * g) + p.template select<16, 1>(32 * g + 16);
      simd<float, 8> h8 = h.template select<8, 1>(0) + h.template select<8, 1>(8);
      simd<float, 4> h4 = h8.template select<4, 1>(0) + h8.template select<4, 1>(4);
      simd<float, 2> h2 = h4.template select<2, 1>(0) + h4.template select<2, 1>(2);
      sg[g] = h2[0] + h2[1];
    }
    simd<float, 4> w4 = sg.template select<4, 1>(0) + sg.template select<4, 1>(4);
    simd<float, 2> w2 = w4.template select<2, 1>(0) + w4.template select<2, 1>(2);
    const float ss = w2[0] + w2[1];
    const float inv_ = rsqrt(simd<float, 1>(ss / (float)D + EPS))[0];
#pragma unroll
    for (int u = 0; u < 2; u++) {
      const int rb = ts + 72 * u;
      simd<float, 16> vcur;
      vcur = block_load<float, 16>(a.vbuf[k] + rb * 16, properties{cache_hint_L1<cache_hint::uncached>, cache_hint_L2<cache_hint::cached>, alignment<16>});
      simd<uint16_t, 16> wb; wb.copy_from(a.nw[k] + rb * 16);
      simd<uint32_t, 16> wu = wb; wu <<= 16;
      simd<float, 16> w = wu.template bit_cast_view<float>();
      simd<float, 16> o = ctlx::rbf16(vcur * inv_ * w);
      o.copy_to(a.out[k] + rb * 16);
    }
    CTL_STAMP(5)
  });
}

// error statistics of the fused tail against the SYCL k_blend path (XIK_CTL_CHECK=1)
struct CtlChk { double n = 0, mism = 0, maxabs = 0, maxulp = 0; long calls = 0; };
static CtlChk g_chk;

// controller blend for n parallel streams: dest[j] (+) msg[j] -> out[j]
void run_ctl(xik_ctx *c, const LayerW &lw, const int *cid, int n, const float **dest, const float **msg,
             const uint16_t **nw, float **out, int T) {
  if (abl_mask() & 1) return;
  PairArgs pa{};
  GArgs g1, g2;
  BlendArgs ba{};
  pa.n = n;
  ba.n = n;
  for (int j = 0; j < n; j++) {
    pa.dest[j] = dest[j]; pa.msg[j] = msg[j]; pa.pair[j] = c->pairb3[j];
    g1.add(lw.ctl_down[cid[j]], c->pairb3[j], 2 * D, c->hid3[j], RANK, RANK, 2 * D, true);
    g2.add(lw.ctl_gain[cid[j]], c->hid3[j], RANK, c->cg3[j], D, D, RANK, false);
    g2.add(lw.ctl_forget[cid[j]], c->hid3[j], RANK, c->cf3[j], D, D, RANK, false);
    ba.dest[j] = dest[j]; ba.msg[j] = msg[j]; ba.g[j] = c->cg3[j]; ba.f[j] = c->cf3[j]; ba.nw[j] = nw[j]; ba.out[j] = out[j];
  }
  g1.cls = 1;
  g2.cls = 1;
  static const int ctl_mode = getenv("XIK_CTL_FUSED") ? atoi(getenv("XIK_CTL_FUSED")) : 3;  // default 3 (T == 1 only; APPROXIMATE: exp/inv tanh, K-split order of the down GEMV differs by rounding); XIK_CTL_FUSED=0 restores the SYCL controller chain  // 0 off, 1 fused tail, 2 tail + compare, 3 fully fused (pairnorm + down + tail), 4 fully fused + compare
  static const int ctl_tv = getenv("XIK_CTL_TANH") ? atoi(getenv("XIK_CTL_TANH")) : 0;
  const bool fused = ctl_mode && T == 1 && n <= 3;
  const bool full = fused && ctl_mode >= 3;
  if (!full) {
    k_pairnorm(c, pa, T);
    gemv_multi(c, g1, T);
  }
  if (fused) {
    static uint32_t *bar = nullptr, *err = nullptr; static float *vb = nullptr, *chk = nullptr, *hpb = nullptr, *hchk = nullptr; static uint32_t expected = 0;
    if (!bar) {
      bar = sycl::malloc_device<uint32_t>(64, c->q.q); err = bar + 32; c->q.memset(bar, 0, 256).wait();
      vb = sycl::malloc_device<float>(3 * D, c->q.q); chk = sycl::malloc_device<float>(3 * D, c->q.q);
      hpb = sycl::malloc_device<float>(3 * 128 * 16, c->q.q); hchk = sycl::malloc_device<float>(3 * 64, c->q.q);
    }
    const bool check = ctl_mode == 2 || ctl_mode == 4;
    if (check) {  // reference result (and hid) from the unfused chain
      if (full) { k_pairnorm(c, pa, T); gemv_multi(c, g1, T); }
      gemv_multi(c, g2, T); k_blend(c, ba, T);
    }
    CtlFArgs fa{};
    for (int j = 0; j < n; j++) {
      fa.wg[j] = reinterpret_cast<const uint32_t *>(lw.ctl_gain[cid[j]]); fa.wf[j] = reinterpret_cast<const uint32_t *>(lw.ctl_forget[cid[j]]);
      fa.wd[j] = reinterpret_cast<const uint32_t *>(lw.ctl_down[cid[j]]);
      auto look = [&](const void *w) -> const float * { auto fi = g_fp8_scale.find(w); return fi == g_fp8_scale.end() ? nullptr : fi->second; };
      fa.sg[j] = look(lw.ctl_gain[cid[j]]); fa.sf[j] = look(lw.ctl_forget[cid[j]]); fa.sd[j] = look(lw.ctl_down[cid[j]]);
      fa.hid[j] = c->hid3[j]; fa.dest[j] = dest[j]; fa.msg[j] = msg[j]; fa.nw[j] = nw[j]; fa.out[j] = check ? chk + (size_t)j * D : out[j]; fa.vbuf[j] = vb + (size_t)j * D;
      fa.hp[j] = hpb + (size_t)j * 128 * 16; fa.hdbg[j] = (full && check) ? hchk + j * 64 : nullptr;
    }
    static uint64_t *tsb = nullptr; static int tscall = 0; static const bool ts_on = getenv("XIK_CTL_TS") && atoi(getenv("XIK_CTL_TS"));
    static std::vector<int> ts_n;
    fa.ts = nullptr; fa.tsidx = 0;
    if (ts_on && full) {
      if (!tsb) { tsb = sycl::malloc_device<uint64_t>(256 * 54 * 6, c->q.q); c->q.memset(tsb, 0, 256 * 54 * 6 * 8).wait(); }
      if (tscall < 256) { fa.ts = tsb; fa.tsidx = tscall; ts_n.push_back(n); tscall++; }
      if (tscall == 256) {
        tscall++;
        c->q.wait();
        std::vector<uint64_t> h(256 * 54 * 6); c->q.memcpy(h.data(), tsb, h.size() * 8).wait();
        for (int kind = 1; kind <= 3; kind += 2) {
          double sum[6] = {0, 0, 0, 0, 0, 0}, skew_start = 0, skew_end = 0, wait1 = 0, wait2 = 0; int cnt = 0;
          for (int ci = 0; ci < 256; ci++) {
            if (ts_n[ci] != kind) continue;
            const int nw = kind * 9; uint64_t t0 = ~0ull, mx_s = 0, mn_e = ~0ull, mx_e = 0;
            for (int w = 0; w < nw; w++) { const uint64_t *r = &h[((size_t)ci * 54 + w) * 6]; t0 = std::min(t0, r[0]); mx_s = std::max(mx_s, r[0]); mn_e = std::min(mn_e, r[5]); mx_e = std::max(mx_e, r[5]); }
            skew_start += (double)(mx_s - t0); skew_end += (double)(mx_e - mn_e);
            for (int w = 0; w < nw; w++) { const uint64_t *r = &h[((size_t)ci * 54 + w) * 6];
              for (int q = 1; q < 6; q++) sum[q] += (double)(r[q] - r[q - 1]); wait1 += 0; }
            cnt += nw;
          }
          if (cnt) { const double tick = 1.0 / 2400.0;  // us per rdtsc tick (about 2.4 GHz)
            int ncalls = 0; for (int ci = 0; ci < 256; ci++) ncalls += ts_n[ci] == kind;
            fprintf(stderr, "ctl timeline [%d stream(s), %d calls, per work-group mean, us]: phase0 (pairnorm+down partials) %.2f | wait barrier1 %.2f | hid sum + gain/forget/blend %.2f | wait barrier2 %.2f | norm + store %.2f | total %.2f ; launch skew (last start - first start) %.2f, finish skew %.2f\n",
              kind, ncalls, sum[1] * tick / cnt, sum[2] * tick / cnt, sum[3] * tick / cnt, sum[4] * tick / cnt, sum[5] * tick / cnt, (sum[1] + sum[2] + sum[3] + sum[4] + sum[5]) * tick / cnt, skew_start * tick / ncalls, skew_end * tick / ncalls); }
        }
      }
    }
    fa.bar = bar; fa.err = err; fa.dbg = getenv("XIK_CTL_DBG") ? atoi(getenv("XIK_CTL_DBG")) : 0;
    fa.base = expected; expected += (uint32_t)(full ? 2 : 1) * n * 9;  // the counter is shared by every call: targets are running totals of work-groups
    if (full) { if (ctl_tv == 2) k_ctl_fused<2, true>(c, fa, n); else k_ctl_fused<0, true>(c, fa, n); }
    else { if (ctl_tv == 2) k_ctl_fused<2>(c, fa, n); else k_ctl_fused<0>(c, fa, n); }
    if (check) {
      c->q.wait();
      std::vector<float> a_(n * D), b_(n * D), ha(n * 64), hb(n * 64); uint32_t e_ = 0;
      for (int j = 0; j < n; j++) {
        c->q.memcpy(a_.data() + (size_t)j * D, out[j], D * 4); c->q.memcpy(b_.data() + (size_t)j * D, chk + (size_t)j * D, D * 4);
        c->q.memcpy(ha.data() + j * 64, c->hid3[j], 256); if (full) c->q.memcpy(hb.data() + j * 64, hchk + j * 64, 256);
      }
      c->q.memcpy(&e_, err, 4); c->q.wait();
      static double hn = 0, hm = 0;
      if (full) for (int i = 0; i < n * 64; i++) {
        hn++; const bool bad = sycl::bit_cast<uint32_t>(ha[i]) != sycl::bit_cast<uint32_t>(hb[i]); hm += bad;
        static int shown = 0;
        if (bad && shown < 12) { shown++; fprintf(stderr, "hid mismatch call %ld stream %d row %d: ref %.9g (0x%08x) fused %.9g (0x%08x)\n", g_chk.calls, i / 64, i % 64, ha[i], sycl::bit_cast<uint32_t>(ha[i]), hb[i], sycl::bit_cast<uint32_t>(hb[i])); }
      }
      for (int i = 0; i < n * D; i++) {
        g_chk.n++;
        uint32_t ua = sycl::bit_cast<uint32_t>(a_[i]), ub = sycl::bit_cast<uint32_t>(b_[i]);
        if (ua != ub) { g_chk.mism++; double d = std::fabs((double)a_[i] - (double)b_[i]); g_chk.maxabs = std::max(g_chk.maxabs, d);
          long du = std::labs((long)(ua >> 16) - (long)(ub >> 16)); g_chk.maxulp = std::max(g_chk.maxulp, (double)du); }
      }
      if (++g_chk.calls % 480 == 0)
        fprintf(stderr, "ctl-check [mode %d, tanh variant %d]: %ld calls, %.0f outputs, mismatching %.4f%%, max |diff| %.3e, max diff %.0f bf16-ulp, hid mismatches %.0f / %.0f, barrier timeouts %u\n", ctl_mode, ctl_tv, g_chk.calls, g_chk.n, 100.0 * g_chk.mism / g_chk.n, g_chk.maxabs, g_chk.maxulp, hm, hn, e_);
    }
    return;
  }
  gemv_multi(c, g2, T);
  k_blend(c, ba, T);
}

void run_layer(xik_ctx *c, Fwd &f, int layer, int pass, int T, int pos0, bool have_msg) {
  const LayerW &lw = c->L[layer];
  const int slot = slot_of(layer, pass);
  const bool local = is_local(layer);
  const bool boundary = layer % BLK == 0;
  const int par = c->cpar[slot];
  float *st_old = c->convst[slot][par], *st_new = c->defer ? nullptr : c->convst[slot][1 - par];
  float *inp[3];
  float *kb0 = c->kb, *vb0 = c->vb, *ao0 = c->ao2, *mo0 = c->moe_o;
  if (c->defer) { c->kb = c->sv_k[slot]; c->vb = c->sv_v[slot]; c->ao2 = c->sv_a[slot]; c->moe_o = c->sv_m[slot]; }

  // ---- attention inputs via attention-residual mix
  const float *attn_src[3];
  if (layer > 0) {
    int nq = local ? 1 : 3;
    MixArgs a{};
    for (int b = 0; b < f.nb; b++) a.st[b] = f.blk[b];
    a.st[f.nb] = f.cur;
    a.ns = f.nb + 1;
    a.nq = nq;
    const float *qp = c->attnres_q[layer - 1];
    for (int j = 0; j < nq; j++) { a.qry[j] = qp + (size_t)j * D; a.out[j] = c->mix[j]; }
    if (!(abl_mask() & 256)) k_mix(c, a, T);
    for (int j = 0; j < 3; j++) attn_src[j] = c->mix[local ? 0 : j];
  } else {
    for (int j = 0; j < 3; j++) attn_src[j] = f.cur;
  }
  phase(c, P_MIX);

  if (have_msg) {
    int cid[3] = {0, 1, 2};
    const float *dest[3] = {attn_src[0], attn_src[1], attn_src[2]}, *msg[3] = {c->msg[0], c->msg[1], c->msg[2]};
    const uint16_t *nw[3];
    float *out[3] = {c->in[0], c->in[1], c->in[2]};
    for (int j = 0; j < 3; j++) nw[j] = local ? lw.attn_norm : (j == 0 ? lw.q_norm : j == 1 ? lw.k_norm : lw.v_norm);
    run_ctl(c, lw, cid, 3, dest, msg, nw, out, T);
    for (int j = 0; j < 3; j++) inp[j] = c->in[j];
    phase(c, P_LOOP);
  } else if (local) {
    NormArgs na{};
    na.n = 1; na.x[0] = attn_src[0]; na.w[0] = lw.attn_norm; na.out[0] = c->in[0];
    k_wnorm(c, na, T);
    inp[0] = inp[1] = inp[2] = c->in[0];
    phase(c, P_NORM);
  } else {
    NormArgs na{};
    na.n = 3;
    const uint16_t *nw[3] = {lw.q_norm, lw.k_norm, lw.v_norm};
    for (int j = 0; j < 3; j++) { na.x[j] = attn_src[j]; na.w[j] = nw[j]; na.out[j] = c->in[j]; inp[j] = c->in[j]; }
    k_wnorm(c, na, T);
    phase(c, P_NORM);
  }

  if (as_on()) { as_rec(c, layer, 0, inp[0], D, T); if (!local) { as_rec(c, layer, 1, inp[1], D, T); as_rec(c, layer, 2, inp[2], D, T); } }
  // ---- projections: one launch
  {
    GArgs g;
    g.add(lw.wq, inp[0], D, c->qb, QD, QD, D, false);
    g.add(lw.wr, inp[0], D, c->rb, RD, RD, D, false);
    g.add(lw.sink, inp[0], D, c->sinkb, NH, NH, D, false);
    g.add(lw.gate_attn, inp[0], D, c->gateb, QD, QD, D, false);
    g.add(lw.wk, inp[1], D, c->kb, KVD, KVD, D, true);
    g.add(lw.wv, inp[2], D, c->vb, KVD, KVD, D, true);
    if (!local) {
      g.add(lw.k_dynw, inp[1], D, c->dynk, 32, 32, D, false);
      g.add(lw.v_dynw, inp[2], D, c->dynv, 32, 32, D, false);
    }
    gemv_multi(c, g, T);
  }
  phase(c, P_GEMV_ATTN);
  k_qr_clip(c, lw, T);
  k_kv(c, lw, slot, local, T, pos0);
  phase(c, P_KV);
  k_attn(c, lw, slot, local, T, pos0);
  phase(c, P_ATTN);
  if (as_on()) as_rec(c, layer, 3, c->attn_o, QD, T);
  static const int ksd_wo = getenv("XIK_KSD_WO") ? atoi(getenv("XIK_KSD_WO")) : 32;
  gemv_bf16(c, lw.wo, c->attn_o, QD, c->ao2, D, D, QD, T, true, ksd_wo, 2);
  phase(c, P_WO);

  // ---- attn short conv, residual / block bookkeeping
  {
    float *dst;
    const float *addto = nullptr;
    if (boundary) {
      f.blk[f.nb++] = f.cur;
      f.cur = f.pop();
      dst = f.cur;
    } else {
      dst = f.cur;
      addto = f.cur;
    }
    ConvArgs a{c->ao2, st_old + 6 * KVD, st_new ? st_new + 6 * KVD : nullptr, dst, addto, D, T, lw.attn_conv, nullptr, nullptr, 0, 2.2360679775f};
    k_conv(c, a);
  }
  phase(c, P_CONV);

  // ---- MLP input mix
  {
    MixArgs a{};
    for (int b = 0; b < f.nb; b++) a.st[b] = f.blk[b];
    a.st[f.nb] = f.cur;
    a.ns = f.nb + 1;
    a.nq = 1;
    a.qry[0] = c->attnres_mlp[layer];
    a.out[0] = c->mix[0];
    if (!(abl_mask() & 512)) k_mix(c, a, T);
  }
  phase(c, P_MIX);
  if (have_msg) {
    int cid[1] = {3};
    const float *dest[1] = {c->mix[0]}, *msg[1] = {c->msg[3]};
    const uint16_t *nw[1] = {lw.mlp_norm};
    float *out[1] = {c->in[0]};
    run_ctl(c, lw, cid, 1, dest, msg, nw, out, T);
    phase(c, P_LOOP);
  } else {
    NormArgs na{};
    na.n = 1; na.x[0] = c->mix[0]; na.w[0] = lw.mlp_norm; na.out[0] = c->in[0];
    k_wnorm(c, na, T);
    phase(c, P_NORM);
  }

  // ---- MoE
  gemv_bf16_old(c, lw.router, c->in[0], D, c->tmp1, NE, NE, D, T, false);
  const bool fr = fuse_route() && T == 1 && !use_int8() && !getenv("XIK_OLD_FP8");
  if (fr) k_route_fused1(c, lw); else k_router(c, lw, T);
  phase(c, P_MOE_ROUTE);
  int np = T * TOPK;
  int nks = 1;
  if (is_mxfp8(layer)) {
    if (use_int8()) {
      int slots = std::min(NE, np);
      k_group(c, np, T);
      k_quant_act16(c, c->in[0], D, D, T, c->ahi, c->alo, c->asx);
      moe_i8g(c, lw.w13, lw.w13_s, c->ahi, c->alo, c->asx, D, true, T, slots, 2 * FI, D, c->gu_part, 2 * FI);
      phase(c, P_MOE_W13);
      nks = 1;
      k_act(c, np, 1);
      k_quant_act16(c, c->act, FI, FI, np, c->ahi, c->alo, c->asx);
      moe_i8g(c, lw.w2, lw.w2_s, c->ahi, c->alo, c->asx, FI, false, T, slots, D, FI, c->yp_part, D);
    } else if (getenv("XIK_OLD_FP8")) {
      expert_fp8<true>(c, lw, c->in[0], D, c->gu_part, 2 * FI, c->ridx, np, 2 * FI, D);
      phase(c, P_MOE_W13);
      k_act(c, np, 1);
      expert_fp8<false>(c, lw, c->act, FI, c->yp_part, D, c->ridx, np, D, FI);
    } else {
      if (!fr) { k_cvt_f16(c, c->in[0], c->x16_in, (size_t)T * D);
      k_group(c, np, T); }
      int slots = std::min(NE, np);
      nks = fp8_ks();
      moe_fp8g(c, lw.w13, lw.w13_s, c->x16_in, D, true, T, slots, 2 * FI, D, c->gu_part, 2 * FI, (size_t)np * 2 * FI);
      phase(c, P_MOE_W13);
      k_act(c, np, nks);
      moe_fp8g(c, lw.w2, lw.w2_s, c->x16_act, FI, false, T, slots, D, FI, c->yp_part, D, (size_t)np * D);
    }
  } else {
    int mcfg = (c->moe_cfg >= 0) ? c->moe_cfg : 1;  // one K split for every T: results must not depend on the verify width
    nks = MOE_CFGS[mcfg].ks;
    if (!fr) { k_cvt_f16(c, c->in[0], c->x16_in, (size_t)T * D);
    k_group(c, np, T); }
    int slots = std::min(NE, np);
    if (lw.w3_13) moe_w3g(c, lw.w13, lw.w13_s, c->x16_in, D, true, T, slots, 2 * FI, D, c->gu_part, (size_t)np * 2 * FI, 2 * FI);
    else moe_fp4g(c, mcfg, lw.w13, lw.w13_s, c->x16_in, D, true, lw.w13_amax, lw.w13_den, T, slots, 2 * FI, D, c->gu_part,
             (size_t)np * 2 * FI, 2 * FI);
    phase(c, P_MOE_W13);
    k_act(c, np, nks);
    if (lw.w3_2) moe_w3g(c, lw.w2, lw.w2_s, c->x16_act, FI, false, T, slots, D, FI, c->yp_part, (size_t)np * D, D);
    else moe_fp4g(c, mcfg, lw.w2, lw.w2_s, c->x16_act, FI, false, lw.w2_amax, lw.w2_den, T, slots, D, FI, c->yp_part,
             (size_t)np * D, D);
  }
  k_moe_combine(c, T, nks);
  phase(c, P_MOE_W2);
  {
    ConvArgs a{c->moe_o, st_old + 6 * KVD + 3 * D, st_new ? st_new + 6 * KVD + 3 * D : nullptr, f.cur, f.cur, D, T, lw.mlp_conv, nullptr, nullptr, 0, 2.2360679775f};
    k_conv(c, a);
  }
  if (!c->defer) c->cpar[slot] = 1 - par;
  c->kb = kb0; c->vb = vb0; c->ao2 = ao0; c->moe_o = mo0;
  phase(c, P_CONV);
  {
    static const int awpf = getenv("XIK_AWPF") ? atoi(getenv("XIK_AWPF")) : 0;  // 1: prefetch kernel in the main queue, 2: in a second queue
    if (awpf && T <= 16) { const int nl = (layer == CORE1 - 1 && pass < NPASS - 1) ? CORE0 : layer + 1; w4_prefetch_layer(c, nl, awpf == 2); }
  }
}

}  // namespace

static void enqueue_body(xik_ctx *c, int T, int rows, bool out_argmax, int pos0) {
    Fwd f;
    for (int i = 9; i >= 0; i--) f.freel.push_back(c->pool[i]);
    f.cur = f.pop();
    {
      float *keep = c->stream;
      c->stream = f.cur;
      k_embed(c, T);
      c->stream = keep;
    }
    int vi = 0;
    auto trace = [&]() {
      if (c->trace_host) c->q.memcpy(c->trace_dev + (size_t)vi * T * D, f.cur, (size_t)T * D * 4);
      vi++;
    };
    auto capv = [&]() { if (vi == 5) k_capture(c, f.cur, 0, T); else if (vi == 23) k_capture(c, f.cur, 1, T); else if (vi == 41) k_capture(c, f.cur, 2, T); };
    for (int l = 0; l < CORE0; l++) { capv(); run_layer(c, f, l, 0, T, pos0, false); trace(); }
    static const int npass_use = getenv("XIK_PASSES") ? std::max(1, std::min(NPASS, atoi(getenv("XIK_PASSES")))) : NPASS;  // APPROXIMATE mode: fewer loop passes
    static const char *skip_env = getenv("XIK_SKIP_LAYERS");  // e.g. "17,16": layers (6..17) skipped in pass XIK_SKIP_PASS (default 2)
    static const int skip_pass = getenv("XIK_SKIP_PASS") ? atoi(getenv("XIK_SKIP_PASS")) : 2;
    static const unsigned skip_mask = [] { unsigned m = 0; if (const char *e = getenv("XIK_SKIP_LAYERS")) { for (const char *q = e; *q;) { int v = atoi(q); if (v >= CORE0 && v < CORE1) m |= 1u << (v - CORE0); while (*q && *q != ',') q++; if (*q) q++; } } return m; }();
    const bool skip_on = skip_env && skip_mask;
    for (int p = 0; p < npass_use; p++) {
      if (p > 0) {
        if (p > 1) { f.freel.push_back(f.bank[0]); f.freel.push_back(f.bank[1]); }
        // bank = [blocks[2], stream]; reset to the prelude state (blocks[0..1])
        f.bank[0] = f.blk[2];
        f.bank[1] = f.cur;
        f.blk[2] = nullptr;
        float *s5 = f.blk[1];
        f.cur = f.pop();
        c->q.memcpy(f.cur, s5, (size_t)T * D * 4);
        f.freel.push_back(s5);
        f.blk[1] = nullptr;
        f.nb = 1;  // blocks = [emb]; layer 6 (a boundary) re-appends the prelude stream
      }
      for (int l = CORE0; l < CORE1; l++) {
        if (skip_on && p == skip_pass && ((skip_mask >> (l - CORE0)) & 1)) {  // APPROXIMATE mode: layer skipped in this pass
          if (l % BLK == 0) {  // block boundary: keep the block bookkeeping, new stream starts as a copy of the old one
            f.blk[f.nb++] = f.cur;
            float *nc = f.pop();
            c->q.memcpy(nc, f.cur, (size_t)T * D * 4);
            f.cur = nc;
          }
          capv();
          trace();
          continue;
        }
        if (p > 0) {
          int ci = l - CORE0;
          MixArgs a{};
          a.st[0] = f.bank[0]; a.st[1] = f.bank[1]; a.ns = 2; a.nq = 4;
          a.qry[0] = c->xpass_q + (size_t)(2 * ci) * D;       a.out[0] = c->msg[0];  // attn
          a.qry[1] = c->xpass_kvq + (size_t)(2 * ci) * D;     a.out[1] = c->msg[1];  // k
          a.qry[2] = c->xpass_kvq + (size_t)(2 * ci + 1) * D; a.out[2] = c->msg[2];  // v
          a.qry[3] = c->xpass_q + (size_t)(2 * ci + 1) * D;   a.out[3] = c->msg[3];  // mlp
          if (!(abl_mask() & 1024)) k_mix(c, a, T);
          phase(c, P_LOOP);
        }
        capv();
        run_layer(c, f, l, p, T, pos0, p > 0);
        trace();
      }
    }
    for (int l = CORE1; l < NLAYER; l++) { capv(); run_layer(c, f, l, 0, T, pos0, false); trace(); }

    // ---- head: output mix, norm, unembed
    {
      MixArgs a{};
      for (int b = 0; b < f.nb; b++) a.st[b] = f.blk[b];
      a.st[f.nb] = f.cur;
      a.ns = f.nb + 1; a.nq = 1; a.qry[0] = c->attnres_out; a.out[0] = c->mix[0];
      if (!(abl_mask() & 4096)) k_mix(c, a, T);
      NormArgs na{};
      na.n = 1; na.x[0] = c->mix[0]; na.w[0] = c->final_norm; na.out[0] = c->in[0];
      k_wnorm(c, na, T);
      k_capture(c, c->in[0], 3, T);
    }
    const float *hx = out_argmax ? c->in[0] : c->in[0] + (size_t)(T - 1) * D;
    static const int ksd_head = getenv("XIK_KSD_HEAD") ? atoi(getenv("XIK_KSD_HEAD")) : KSD_DEFAULT;
    if (as_on()) as_rec(c, 0, 4, hx, D, rows);
    head_gemv(c, hx, D, c->logits, rows, false, ksd_head, 3);
    k_softcap_argmax(c, rows);
    phase(c, P_HEAD);
}

static int do_forward(xik_ctx *c, const int32_t *ids, int T, float *logits_last, int32_t *out_argmax, bool defer) {
  try {
    c->defer = defer;
    if (T < 1 || T > c->max_tokens) throw std::runtime_error("bad T");
    if (c->pos + T > c->max_ctx) throw std::runtime_error("context overflow");
    if (c->pos + T > 8192) throw std::runtime_error("log-scaling beyond 8192 tokens not implemented yet");
    const int pos0 = c->pos;
    auto t_fwd0 = std::chrono::steady_clock::now();
    if (c->prof) { c->q.wait(); c->tprev = std::chrono::steady_clock::now(); }
    int rows = out_argmax ? T : 1;
    c->q.memcpy(c->ids_d, ids, (size_t)T * 4);
    if (c->cap_pos + T - c->ing_pos > CAPR) throw std::runtime_error("drafter hidden-state backlog overflow (ingest more often)");
    int hdr[2] = {pos0, c->cap_pos};
    c->q.memcpy(c->dparams, hdr, 8);
    static const bool want_graph = getenv("XIK_GRAPH") != nullptr;
    bool use_graph = want_graph && out_argmax && !c->prof && !c->trace_host && T <= 8 && !c->graph_failed;
    if (use_graph)
      for (int sl = 1; sl < NSLOT; sl++) if (c->cpar[sl] != c->cpar[0]) use_graph = false;
    if (use_graph) {
      namespace gx = sycl::ext::oneapi::experimental;
      std::array<int, 4> key{T, rows, defer ? 1 : 0, c->cpar[0]};
      auto it = c->graphs.find(key);
      try {
        if (it == c->graphs.end()) {
          int saved[NSLOT];
          memcpy(saved, c->cpar, sizeof(saved));
          gx::command_graph<gx::graph_state::modifiable> g(c->q.q.get_context(), c->q.q.get_device());
          g.begin_recording(c->q.q);
          enqueue_body(c, T, rows, out_argmax != nullptr, pos0);
          g.end_recording();
          memcpy(c->cpar, saved, sizeof(saved));
          auto ge = std::make_shared<gx::command_graph<gx::graph_state::executable>>(g.finalize());
          it = c->graphs.emplace(key, ge).first;
        }
        c->q.q.ext_oneapi_graph(*it->second);
        if (!defer) for (int sl = 0; sl < NSLOT; sl++) c->cpar[sl] ^= 1;
      } catch (std::exception &ex) {
        fprintf(stderr, "xik: graph path disabled (%s)\n", ex.what());
        c->graph_failed = true;
        c->q.wait();
        throw;
      }
    } else {
      enqueue_body(c, T, rows, out_argmax != nullptr, pos0);
    }
    if (out_argmax) c->q.memcpy(out_argmax, c->am_d, (size_t)T * 4);
    if (logits_last) c->q.memcpy(logits_last, c->logits + (size_t)(rows - 1) * VOCAB, (size_t)VOCAB_U * 4);
    if (c->trace_host) c->q.memcpy(c->trace_host, c->trace_dev, (size_t)NSLOT * T * D * 4);
    static const bool timing = getenv("XIK_TIMING") != nullptr;
    auto t_sub = std::chrono::steady_clock::now();
    c->q.wait();
    if (timing) {
      auto t_end = std::chrono::steady_clock::now();
      c->prof_us[14] += std::chrono::duration<double, std::micro>(t_sub - t_fwd0).count();
      c->prof_us[15] += std::chrono::duration<double, std::micro>(t_end - t_fwd0).count();
    }
    if (defer) c->pend_T = T; else { c->pos += T; c->cap_pos += T; if (!c->has_dr) c->ing_pos = c->cap_pos; }
    c->defer = false;
    return 0;
  } catch (std::exception &e) {
    c->defer = false;
    g_err = e.what();
    return 1;
  }
}

extern "C" int xik_forward(xik_ctx *c, const int32_t *ids, int T, float *logits_last, int32_t *out_argmax) {
  return do_forward(c, ids, T, logits_last, out_argmax, false);
}

// Speculative verification: runs T tokens without committing recurrent state; xik_commit(n) keeps the first n.
extern "C" int xik_verify(xik_ctx *c, const int32_t *ids, int T, int32_t *out_argmax) {
  return do_forward(c, ids, T, nullptr, out_argmax, true);
}

extern "C" int xik_commit(xik_ctx *c, int n) {
  try {
    if (n < 1 || n > c->pend_T) throw std::runtime_error("bad commit count");
    for (int sl = 0; sl < NSLOT; sl++) k_commit_slot(c, sl, n);
    c->q.wait();
    c->pos += n;
    c->cap_pos += n;
    if (!c->has_dr) c->ing_pos = c->cap_pos;
    c->pend_T = 0;
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

// Feed the next pending hidden-state rows (in order) into the drafter's context. Rows are kept in a ring, so plain
// target steps can run without touching the drafter and the backlog is ingested in one batch before drafting.
static void ingest_chunk(xik_ctx *c, int start, int n) {
  const float *cap = c->cap + (size_t)start * 4 * D;
  for (int i = 0; i < DNL; i++) {
    auto &d = c->dl[i];
    d_mix(c, cap, n, c->d_alpha + i * 4, d.dfl, c->dctxn);
    GArgs g;
    g.add(d.kpc, c->dctxn, D, c->dkctx, KVD, KVD, D, true);
    g.add(d.vpc, c->dctxn, D, c->dvctx, KVD, KVD, D, true);
    gemv_multi(c, g, n);
    d_head_prep(c, c->dkctx, NKV, d.knc, true, c->dpos, n, c->dkc[i], d_local(i) ? RING : 0, true);
    d_head_prep(c, c->dvctx, NKV, nullptr, false, c->dpos, n, c->dvc[i], d_local(i) ? RING : 0, true);
  }
  // f_rnn: mix of the last context hidden with the markov head's row/norm
  d_mix(c, cap + (size_t)(n - 1) * 4 * D, 1, c->d_alpha + 12, c->mk_dfl, c->dfrnn);
  c->dpos += n;
  c->ing_pos += n;
}
extern "C" int xik_pending(xik_ctx *c) { return c->cap_pos - c->ing_pos; }
// Drop pending hidden states without feeding them to the drafter (its context then has a gap: only valid when the
// drafter will not be used again for this sequence).
extern "C" void xik_discard_pending(xik_ctx *c) { c->ing_pos = c->cap_pos; }
extern "C" int xik_ingest_pending(xik_ctx *c) {
  try {
    if (!c->has_dr) throw std::runtime_error("no drafter loaded");
    while (c->cap_pos > c->ing_pos) {
      int start = c->ing_pos % CAPR;
      int n = std::min({c->cap_pos - c->ing_pos, c->max_tokens, CAPR - start});
      ingest_chunk(c, start, n);
    }
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

// Draft 7 tokens after `anchor` (the token the target has not processed yet).
extern "C" int xik_draft(xik_ctx *c, int32_t anchor, int32_t *out7) {
  try {
    if (!c->has_dr) throw std::runtime_error("no drafter loaded");
    const int R = DB;
    c->q.memcpy(c->ids_d, &anchor, 4);
    c->q.memcpy(c->dtok + DCNT, &anchor, 4);
    {
      float *keep = c->stream;
      c->stream = c->dx;
      k_embed(c, 1);
      c->stream = keep;
    }
    d_mask_rows(c);
    for (int i = 0; i < DNL; i++) {
      auto &d = c->dl[i];
      d_addres(c, c->dx, c->dres, c->dsum, i == 0, (size_t)R * D);
      NormArgs na{};
      na.n = 1; na.x[0] = c->dsum; na.w[0] = d.inln; na.out[0] = c->dnorm;
      k_wnorm(c, na, R);
      GArgs g;
      g.add(d.qp, c->dnorm, D, c->dq, QD, QD, D, true);
      g.add(d.kp, c->dnorm, D, c->dk, KVD, KVD, D, true);
      g.add(d.vp, c->dnorm, D, c->dv, KVD, KVD, D, true);
      gemv_multi(c, g, R);
      d_head_prep(c, c->dq, NH, d.qn, true, c->dpos, R, c->dq, 0, false);   // in place (per-head, same group)
      d_head_prep(c, c->dk, NKV, d.kn, true, c->dpos, R, c->dk, 0, false);
      d_attn(c, i, c->dq, c->dk, c->dv, c->dat);
      gemv_bf16(c, d.op, c->dat, QD, c->dtmp, D, D, QD, R, true);
      d_addres(c, c->dtmp, c->dres, c->dsum, false, (size_t)R * D);
      NormArgs nb{};
      nb.n = 1; nb.x[0] = c->dsum; nb.w[0] = d.postln; nb.out[0] = c->dnorm;
      k_wnorm(c, nb, R);
      GArgs g2;
      g2.add(d.gp, c->dnorm, D, c->dg, DFF, DFF, D, true);
      g2.add(d.up, c->dnorm, D, c->du, DFF, DFF, D, true);
      gemv_multi(c, g2, R);
      d_silu_mul(c, c->dg, c->du, c->dact, (size_t)R * DFF);
      gemv_bf16(c, d.dp, c->dact, DFF, c->dx, D, D, DFF, R, true);
    }
    d_addres(c, c->dx, c->dres, c->dsum, false, (size_t)R * D);
    {
      NormArgs nf{};
      nf.n = 1; nf.x[0] = c->dsum; nf.w[0] = c->d_norm; nf.out[0] = c->dxf;
      k_wnorm(c, nf, R);
    }
    head_gemv(c, c->dxf + D, D, c->dbase, DCNT, true, KSD_DEFAULT, 0);
    d_mk_in(c);
    {
      GArgs g;
      g.add(c->mk_rw + 2 * DRANK, c->dmkin, 2 * D, c->dmkctx, 768, 768, 2 * D, false, 5120);
      gemv_multi(c, g, DCNT);
    }
    c->q.memset(c->dmkst, 0, DRANK * 4);
    for (int i = 0; i < DCNT; i++) {
      d_mk_state(c, i, 0);
      d_mk_logits(c, i);
      d_argmax(c, i);
    }
    c->q.memcpy(out7, c->dtok, DCNT * 4).wait();
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

// Device memory report (bytes): [0] weights (llm), [1] drafter weights+fold, [2] target KV, [3] drafter KV,
// [4] conv state + saved chunk inputs, [5] all allocations made by this library, [6] driver free, [7] driver total
extern "C" void xik_mem(xik_ctx *c, uint64_t *o) {
  uint64_t w = 0, d = 0;
  for (auto &kv : c->tensors) (kv.first.rfind("mtp.", 0) == 0 ? d : w) += kv.second.bytes;
  d += c->foldW ? (uint64_t)VOCAB * DRANK * 2 + (uint64_t)VOCAB * 2 : 0;
  uint64_t kvb = 0, dkv = 0, cs = 0;
  for (int s = 0; s < NSLOT; s++) {
    int layer = s < NLAYER ? s : CORE0 + (s - NLAYER) % NCORE;
    size_t cap = is_local(layer) ? RING : (size_t)c->max_ctx;
    kvb += cap * KVD * 4 * 2;
    cs += 2ull * 3 * (2 * KVD + 2 * D) * 4 + (uint64_t)c->max_tokens * (2 * KVD + 2 * D) * 4;
  }
  if (c->has_dr)
    for (int i = 0; i < DNL; i++) dkv += (d_local(i) ? (size_t)RING : (size_t)c->max_ctx) * KVD * 4 * 2;
  o[0] = w; o[1] = d; o[2] = kvb; o[3] = dkv; o[4] = cs; o[5] = g_alloc_total;
  auto dev = c->q.get_device();
  o[6] = dev.has(sycl::aspect::ext_intel_free_memory) ? dev.get_info<sycl::ext::intel::info::device::free_memory>() : 0;
  o[7] = dev.get_info<sycl::info::device::global_mem_size>();
}

extern "C" void xik_set_moe_cfg(xik_ctx *c, int cfg) { c->moe_cfg = cfg; }

// Micro-benchmark of one NVFP4 expert kernel run back to back: kind 0 = w13, 1 = w2; T tokens, 8 experts each
// (distinct per token). Returns average microseconds per call and the bytes of expert weights it touches.

// ---------------------------------------------------------------- NVFP4 micro-benchmark variants (benchmark only, not used in inference)
// Same thread mapping / memory layout / NB=2 software pipeline as moe_fp4g_t<1,2> at T=1, w13 shape (1152 threads, 36 supertiles x 4 DPAS).
// No stage / timestamp / descriptor branches.  VAR 0: DPAS only (one tile loaded before the loop, B perturbed by the loop index so the DPAS
// cannot be hoisted); 1: loads (W,S,x) + DPAS on the raw dwords; 2: loads + FP4 unpack + DPAS; 3: loads + unpack + scale + DPAS (= lean production).
// NA independent accumulators (the DPAS result of every 16-K block goes to acc[(u*4+b)%NA]).
template <int VAR, int NA, int PW, bool DESC>
ESIMD_INLINE void fp4v_body(const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, float *Y, uint32_t gid, const int32_t *desc,
                            const float *amax, const float *den) {
  {
    using namespace es;
    const int NB = 2, per = 36, nrb = 144;
    uint32_t rb = gid % 144u, j = gid / 144u;
    int e = (int)((j * 7 + 3) % 128);
    float gsc = 1.f;
    if (DESC) {  // as production: expert id comes from a descriptor load, weight/scale addresses depend on it
      simd<int32_t, 16> d = block_load<int32_t, 16>(desc + j * 16);
      if (d[1] <= 0) return;
      e = d[0];
      gsc = amax[e] / den[0] * 16384.0f;
    }
    const uint32_t *wp = reinterpret_cast<const uint32_t *>(Wp) + (((size_t)e * nrb + rb) * 36) * 128;
    const uint32_t *sp = reinterpret_cast<const uint32_t *>(Sp) + (((size_t)e * nrb + rb) * 36) * 16;
    const uint32_t *xr = reinterpret_cast<const uint32_t *>(X16);
    simd<float, 16> acc[NA];
#pragma unroll
    for (int i = 0; i < NA; i++) acc[i] = 0.f;
    simd<uint32_t, 16> fold = 0;
    simd<uint32_t, 128> wb[NB];
    simd<uint32_t, 16> sb[NB];
    simd<uint32_t, 32> xb[NB];
    auto load = [&](int u, int s) {
      simd<uint32_t, 64> t0 = ldp<PW, 64>(wp + (size_t)s * 128);
      simd<uint32_t, 64> t1 = ldp<PW, 64>(wp + (size_t)s * 128 + 64);
      wb[u].template select<64, 1>(0) = t0;
      wb[u].template select<64, 1>(64) = t1;
      sb[u] = block_load<uint32_t, 16>(sp + (size_t)s * 16);
      xb[u] = block_load<uint32_t, 32>(xr + (size_t)s * 32);
    };
    if (VAR == 0) {
      load(0, 0);
      wb[1] = wb[0];
      xb[1] = xb[0];
    } else {
#pragma unroll
      for (int u = 0; u < NB; u++) load(u, u);
    }
    for (int s0 = 0; s0 < per; s0 += NB) {
#pragma unroll
      for (int u = 0; u < NB; u++) {
        int s = s0 + u;
        simd<uint8_t, 64> s8 = sb[u].template bit_cast_view<uint8_t>();
        if (VAR == 1) fold ^= sb[u];
#pragma unroll
        for (int b = 0; b < 4; b++) {
          simd<int32_t, 128> Bi;
          if (VAR == 0 || VAR == 1) {
            Bi = wb[u].template bit_cast_view<int32_t>();
            if (VAR == 0) Bi.template select<16, 1>(0) += (int32_t)s;
          } else {
            simd<uint32_t, 16> R0 = wb[u].template select<16, 1>(32 * b), R1 = wb[u].template select<16, 1>(32 * b + 16);
            simd<uint32_t, 128> B;
#pragma unroll
            for (int r = 0; r < 4; r++) {
              B.template select<16, 1>(16 * r) = fp4_pair(R0 >> (4 * r));
              B.template select<16, 1>(16 * (r + 4)) = fp4_pair(R1 >> (4 * r));
            }
            Bi = B.template bit_cast_view<int32_t>();
          }
          simd<int32_t, 8> a = xb[u].template select<8, 1>(8 * b).template bit_cast_view<int32_t>();
          simd<float, 16> z = 0.f;
          simd<float, 16> res = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16,
                                          xmx::dpas_argument_type::fp16>(z, Bi, a);
          if (VAR == 3) {
            simd<uint8_t, 16> sc8 = s8.template select<16, 1>(16 * b);
            simd<uint32_t, 16> sw = convert<uint32_t>(sc8);
            simd<uint32_t, 16> sbits = (sw & 0x7Fu) << 20;
            simd<float, 16> sc = sbits.template bit_cast_view<float>() * 1.329227995784916e36f;
            acc[(u * 4 + b) % NA] += res * sc;
          } else {
            acc[(u * 4 + b) % NA] += res;
          }
        }
        if (VAR == 2) fold ^= sb[u];
        if (VAR != 0 && s + NB < per) load(u, s + NB);
      }
    }
    simd<float, 16> o = acc[0];
#pragma unroll
    for (int i = 1; i < NA; i++) o += acc[i];
    o += fold.template bit_cast_view<float>();
    o *= gsc;
    o.copy_to(Y + (size_t)gid * 16);
  }
}

template <int VAR, int NA, int PW = 0, bool DESC = false>
void fp4v_t(xik_ctx *c, const uint8_t *Wp, const uint8_t *Sp, const sycl::half *X16, float *Y, const int32_t *desc = nullptr,
            const float *amax = nullptr, const float *den = nullptr) {
  c->q.parallel_for(nd_range<1>(1152, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    fp4v_body<VAR, NA, PW, DESC>(Wp, Sp, X16, Y, (uint32_t)it.get_global_id(0), desc, amax, den);
  });
}

extern "C" int xik_bench_fp4var(xik_ctx *c, int var, int na, int rot, int iters, double *out_us, double *out_dur) {
  try {
    int it = 0;
    static int32_t *fdesc = nullptr;
    if (!fdesc) {
      fdesc = sycl::malloc_device<int32_t>(8 * 16, c->q.q);
      std::vector<int32_t> h(8 * 16, 0);
      for (int j = 0; j < 8; j++) { h[j * 16] = (j * 7 + 3) % 128; h[j * 16 + 1] = 1; h[j * 16 + 2] = j * 8; }
      c->q.memcpy(fdesc, h.data(), sizeof(int32_t) * h.size()).wait();
    }
    auto run = [&]() {
      const LayerW &lq = c->L[(it++ % rot) % 20];
      // 4: lean D + descriptor/amax/den loads; 5: + weights L1-streaming/L2-uncached; 6: arithmetic expert id + st.uc; 7: B (load+dpas) + st.uc; 8: C + st.uc
      if (na == 1 && var == 4) { fp4v_t<3, 1, 0, true>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part, fdesc, lq.w13_amax, lq.w13_den); return; }
      if (na == 1 && var == 5) { fp4v_t<3, 1, 5, true>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part, fdesc, lq.w13_amax, lq.w13_den); return; }
      if (na == 1 && var == 6) { fp4v_t<3, 1, 5, false>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part); return; }
      if (na == 1 && var == 7) { fp4v_t<1, 1, 5, false>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part); return; }
      if (na == 1 && var == 8) { fp4v_t<2, 1, 5, false>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part); return; }
#define FV(V, N) if (var == V && na == N) { fp4v_t<V, N>(c, lq.w13, lq.w13_s, c->x16_in, c->gu_part); return; }
#define FVN(V) FV(V, 1) FV(V, 2) FV(V, 4) FV(V, 8)
      FVN(0) FVN(1) FVN(2) FVN(3)
#undef FVN
#undef FV
    };
    for (int i = 0; i < 20; i++) run();
    c->q.wait();
    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < iters; i++) run();
    c->q.wait();
    *out_us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / iters;
    c->q.wait();
    c->q.evs.clear(); c->q.rec = true; c->q.tag = 0;
    for (int i = 0; i < 100; i++) run();
    c->q.wait();
    c->q.rec = false;
    double sd = 0; int n = 0;
    for (auto &p : c->q.evs) { sd += (p.second.get_profiling_info<sycl::info::event_profiling::command_end>() - p.second.get_profiling_info<sycl::info::event_profiling::command_start>()) * 1e-3; n++; }
    c->q.evs.clear();
    *out_dur = n ? sd / n : 0;
    return 0;
  } catch (std::exception &ex) { g_err = ex.what(); return 1; }
}

extern "C" int xik_bench_moe(xik_ctx *c, int layer, int kind, int cfg, int T, int iters, double *out_us, double *out_bytes) {
  try {
    const bool fp8l = is_mxfp8(layer);
    const LayerW &lw = c->L[layer];
    int np = T * TOPK;
    std::vector<int32_t> r(np);
    for (int p = 0; p < np; p++) r[p] = (p * 7 + 3 + (p / 8) * 11) % NE;
    if (const char *pe = getenv("XIK_BENCH_EXP")) {  // expert placement experiment (T=1 pattern, later tokens offset)
      int mode = atoi(pe);
      for (int p = 0; p < np; p++) {
        int k = p % 8, tk = p / 8;
        if (mode == 1) r[p] = (k + 8 * tk) % NE;                 // C: 8 contiguous experts
        else if (mode == 2) r[p] = (k * 16 + 1 + tk) % NE;       // D: widest spread, stride 16
        else if (mode == 3) r[p] = (k * 2 + tk) % NE;            // stride 2
      }
    }
    if (const char *pd = getenv("XIK_BENCH_DIST")) {  // n distinct experts (duplicates across the T*8 picks): fixed-vs-slope fit
      int n = std::max(1, std::min(atoi(pd), np));
      for (int p = 0; p < np; p++) r[p] = ((p % n) * 7 + 3) % NE;
    }
    c->q.memcpy(c->ridx, r.data(), np * 4).wait();
    k_group(c, np, T);
    c->q.wait();
    int slots = std::min(NE, np);
    int nks = MOE_CFGS[cfg].ks;
    std::vector<char> seen(NE, 0);
    int distinct = 0;
    for (int e : r) if (!seen[e]) { seen[e] = 1; distinct++; }
    int it = 0;
    auto run = [&]() {
      if (fp8l) {
        const LayerW &lq = c->L[20 + (it++ % 4)];  // 4 MXFP8 layers x ~1 GB: cold weights every call
        if (kind == 0) moe_fp8g(c, lq.w13, lq.w13_s, c->x16_in, D, true, T, slots, 2 * FI, D, c->gu_part, 2 * FI, (size_t)np * 2 * FI);
        else moe_fp8g(c, lq.w2, lq.w2_s, c->x16_act, FI, false, T, slots, D, FI, c->yp_part, D, (size_t)np * D);
        return;
      }
      static const int nrot = getenv("XIK_BENCH_ROT") ? atoi(getenv("XIK_BENCH_ROT")) : 20;  // 20 = cold; 1 = same layer every call (TLB warm)
      const LayerW &lq = c->L[(layer + (it++ % nrot)) % 20];  // rotate over layers: weights are cold every call
      if (kind == 0) {
        if (lq.w3_13) moe_w3g(c, lq.w13, lq.w13_s, c->x16_in, D, true, T, slots, 2 * FI, D, c->gu_part, (size_t)np * 2 * FI, 2 * FI);
        else moe_fp4g(c, cfg, lq.w13, lq.w13_s, c->x16_in, D, true, lq.w13_amax, lq.w13_den, T, slots, 2 * FI, D, c->gu_part, (size_t)np * 2 * FI, 2 * FI);
      } else {
        if (lq.w3_2) moe_w3g(c, lq.w2, lq.w2_s, c->x16_act, FI, false, T, slots, D, FI, c->yp_part, (size_t)np * D, D);
        else moe_fp4g(c, cfg, lq.w2, lq.w2_s, c->x16_act, FI, false, lq.w2_amax, lq.w2_den, T, slots, D, FI, c->yp_part, (size_t)np * D, D);
      }
    };
    (void)nks;
    for (int i = 0; i < 20; i++) run();
    c->q.wait();
    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < iters; i++) run();
    c->q.wait();
    double us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / iters;
    *out_us = us;
    if (getenv("XIK_BENCH_PROF")) {  // GPU-timestamp decomposition: kernel duration vs start-to-start period vs idle gap
      c->q.wait();
      c->q.evs.clear(); c->q.rec = true; c->q.tag = 0;
      for (int i = 0; i < 100; i++) run();
      c->q.wait();
      c->q.rec = false;
      std::vector<std::pair<double, double>> k;
      for (auto &p : c->q.evs) k.push_back({p.second.get_profiling_info<sycl::info::event_profiling::command_start>() * 1e-3,
                                            p.second.get_profiling_info<sycl::info::event_profiling::command_end>() * 1e-3});
      c->q.evs.clear();
      std::sort(k.begin(), k.end());
      double sd = 0, sp = 0, sg = 0; int n = 0; double mind = 1e30, minp = 1e30;
      for (size_t i = 1; i + 1 < k.size(); i++) {
        double d = k[i].second - k[i].first, per = k[i + 1].first - k[i].first, gap = k[i + 1].first - k[i].second;
        sd += d; sp += per; sg += gap; n++; mind = std::min(mind, d); minp = std::min(minp, per);
      }
      fprintf(stderr, "PROF kind=%d T=%d kernels=%zu dur=%.2f (min %.2f) period=%.2f (min %.2f) gap=%.2f us\n", kind, T, k.size(), sd / n, mind, sp / n, minp, sg / n);
    }
    if (getenv("XIK_BENCH_FIRST") && !fp8l && kind == 0 && T == 1) {  // first-load latency of a fresh kernel (rdtsc start -> data arrived)
      uint64_t *buf = sycl::malloc_device<uint64_t>(2 * 1152, c->q.q);
      std::vector<uint64_t> h(2 * 1152);
      const int32_t *hot = c->desc;
      auto probe = [&](int mode, const char *name) {
        for (int rep = 0; rep < 3; rep++) {
          const uint8_t *cold = c->L[(layer + rep * 3) % 20].w13;
          c->q.memset(buf, 0, 2 * 1152 * 8).wait();
          if (mode == 1) c->q.single_task([=]() { ((volatile int32_t *)hot)[0] = 1; });          // write the line in the preceding kernel
          c->q.parallel_for(nd_range<1>(1152, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
            using namespace es;
            size_t g = it.get_global_id(0);
            uint64_t t0 = es::rdtsc();
            simd<int32_t, 16> v;
            if (mode == 2) v = block_load<int32_t, 16>(reinterpret_cast<const int32_t *>(cold) + g * 16384);  // distinct 64 KB apart
            else v = block_load<int32_t, 16>(hot);
            uint64_t t1 = t0;
            if (v[0] != 0x7fc12345) t1 = es::rdtsc();
            simd<uint64_t, 2> o; o[0] = t0; o[1] = t1;
            o.copy_to(buf + 2 * g);
          });
          c->q.wait();
          c->q.memcpy(h.data(), buf, 2 * 1152 * 8).wait();
          uint64_t b = ~0ull; for (int i = 0; i < 1152; i++) b = std::min(b, h[2 * i]);
          std::vector<double> lat; for (int i = 0; i < 1152; i++) lat.push_back((h[2 * i + 1] - h[2 * i]) / 2400.0);
          std::sort(lat.begin(), lat.end());
          fprintf(stderr, "FIRST %-34s first-load latency us p10/p50/p90/max = %.2f/%.2f/%.2f/%.2f\n", name, lat[115], lat[576], lat[1036], lat[1151]);
        }
      };
      // instruction-fetch probe: NI straight-line ALU instructions (dependent on t0, cannot be folded) before the hot load
      auto probe_code = [&](auto NIc, const char *name) {
        constexpr int NI = decltype(NIc)::value;
        for (int rep = 0; rep < 3; rep++) {
          c->q.memset(buf, 0, 2 * 1152 * 8).wait();
          c->q.parallel_for(nd_range<1>(1152, 16), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
            using namespace es;
            size_t g = it.get_global_id(0);
            uint64_t t0 = es::rdtsc();
            simd<int32_t, 16> x = (int32_t)(t0 & 0xff) + simd<int32_t, 16>(0, 1);
#pragma unroll
            for (int i = 0; i < NI; i++) x = x * (2 * i + 3) + (i ^ 0x55);
            simd<int32_t, 16> v = block_load<int32_t, 16>(hot);
            v ^= x;
            uint64_t t1 = t0;
            if (v[0] != 0x7fc12345) t1 = es::rdtsc();
            simd<uint64_t, 2> o; o[0] = t0; o[1] = t1;
            o.copy_to(buf + 2 * g);
          });
          c->q.wait();
          c->q.memcpy(h.data(), buf, 2 * 1152 * 8).wait();
          std::vector<double> lat; for (int i = 0; i < 1152; i++) lat.push_back((h[2 * i + 1] - h[2 * i]) / 2400.0);
          std::sort(lat.begin(), lat.end());
          fprintf(stderr, "FIRST %-34s  start->load-arrived us p10/p50/p90/max = %.2f/%.2f/%.2f/%.2f\n", name, lat[115], lat[576], lat[1036], lat[1151]);
        }
      };
      probe_code(std::integral_constant<int, 16>{}, "16 ALU instr before load");
      probe_code(std::integral_constant<int, 256>{}, "256 ALU instr before load");
      probe_code(std::integral_constant<int, 1024>{}, "1024 ALU instr before load");
      probe_code(std::integral_constant<int, 4096>{}, "4096 ALU instr before load");
      probe(0, "hot buffer, no write before");
      probe(1, "hot buffer written by prev kernel");
      probe(2, "distinct cold weight lines (64KB apart)");
      sycl::free(buf, c->q.q);
    }
    if (getenv("XIK_BENCH_TS") && !fp8l) {  // per-thread start/end timeline of one cold kernel
      size_t nth = (size_t)slots * (kind == 0 ? 2 * FI : D) / 16 * nks;
      uint64_t *buf = sycl::malloc_device<uint64_t>(8 * nth, c->q.q);
      std::vector<uint64_t> h(8 * nth);
      for (int rep = 0; rep < 3; rep++) {
        c->q.memset(buf, 0, 8 * nth * 8).wait();
        g_ts = buf;
        run();
        c->q.wait();
        g_ts = nullptr;
        c->q.memcpy(h.data(), buf, 8 * nth * 8).wait();
        uint64_t t0 = ~0ull, t1 = 0;
        std::vector<std::pair<uint64_t, uint64_t>> th;
        for (size_t i = 0; i < nth; i++) if (h[8 * i]) { th.push_back({h[8 * i], h[8 * i + 1]}); t0 = std::min(t0, h[8 * i]); t1 = std::max(t1, h[8 * i + 1]); }
        if (th.empty()) continue;
        if (const char *dp = getenv("XIK_BENCH_TSDUMP")) {
          char fn[512]; snprintf(fn, sizeof fn, "%s.k%d.T%d.n%zu.r%d", dp, kind, T, nth, rep);
          if (FILE *f = fopen(fn, "wb")) { fwrite(h.data(), 8, 8 * nth, f); fclose(f); }
        }
        std::sort(th.begin(), th.end());
        std::vector<uint64_t> en; for (auto &x : th) en.push_back(x.second);
        std::sort(en.begin(), en.end());
        auto q = [&](std::vector<uint64_t> &v, double f) { return (double)(v[(size_t)(f * (v.size() - 1))] - t0); };
        std::vector<uint64_t> st; for (auto &x : th) st.push_back(x.first);
        std::vector<uint64_t> dur; for (auto &x : th) dur.push_back(x.second - x.first);
        std::sort(dur.begin(), dur.end());
        fprintf(stderr, "TS kind=%d T=%d threads=%zu span=%llu ticks | start p0/50/90/100=%.0f/%.0f/%.0f/%.0f | end p0/10/50/90/100=%.0f/%.0f/%.0f/%.0f/%.0f | dur p0/50/100=%llu/%llu/%llu\n",
                kind, T, th.size(), (unsigned long long)(t1 - t0), q(st, 0), q(st, .5), q(st, .9), q(st, 1), q(en, 0), q(en, .1), q(en, .5), q(en, .9), q(en, 1),
                (unsigned long long)dur[0], (unsigned long long)dur[dur.size() / 2], (unsigned long long)dur.back());
      }
      sycl::free(buf, c->q.q);
    }
    if (fp8l) *out_bytes = (double)distinct * (kind == 0 ? (2.0 * FI * D * (1 + 1.0 / 32)) : ((double)D * FI * (1 + 1.0 / 32)));
    else *out_bytes = (double)distinct * (kind == 0 ? (2.0 * FI * D / 2 + 2.0 * FI * D / 16) : ((double)D * FI / 2 + (double)D * FI / 16));
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

// Fixed cost of one in-order kernel: n back-to-back tiny kernels (kind 0: 1-WG rmsnorm, 1: empty 1-item kernel).

// ---- controller re-implementation groundwork: which ESIMD math / reduction orders reproduce the SYCL kernels bit for bit?
extern "C" int xik_test_ctl(xik_ctx *c) {
  try {
    std::mt19937 rng(12345);
    // (1) math functions: sycl::tanh / sycl::rsqrt (as used by k_blend / k_pairnorm) against ESIMD versions
    const int N = 1 << 20;
    std::vector<float> hx(N), hr(N);
    std::uniform_real_distribution<float> ux(-6.f, 6.f), ur(1e-4f, 50.f);
    for (int i = 0; i < N; i++) { hx[i] = ux(rng); hr[i] = ur(rng); }
    float *dx = sycl::malloc_device<float>(N, c->q.q), *dr = sycl::malloc_device<float>(N, c->q.q);
    float *o_th = sycl::malloc_device<float>(N, c->q.q), *o_rs = sycl::malloc_device<float>(N, c->q.q);
    float *e_th = sycl::malloc_device<float>(N, c->q.q), *e_rs = sycl::malloc_device<float>(N, c->q.q), *e_th_s = sycl::malloc_device<float>(N, c->q.q);
    c->q.memcpy(dx, hx.data(), N * 4); c->q.memcpy(dr, hr.data(), N * 4); c->q.wait();
    float *i0 = sycl::malloc_device<float>(N, c->q.q), *i1 = sycl::malloc_device<float>(N, c->q.q), *i2 = sycl::malloc_device<float>(N, c->q.q), *i3 = sycl::malloc_device<float>(N, c->q.q);
    c->q.parallel_for(range<1>(N), [=](id<1> i) { o_th[i] = sycl::tanh(dx[i]); o_rs[i] = sycl::rsqrt(dr[i]);
      i0[i] = sycl::ext::intel::math::__imf_tanhf(dx[i]); i1[i] = sycl::ext::intel::math::__imf_tanhf_ha(dx[i]); i2[i] = sycl::ext::intel::math::__imf_tanhf_la(dx[i]); i3[i] = sycl::ext::intel::math::__imf_tanhf_ep(dx[i]); }).wait();
    {
      std::vector<float> ref(N), v0(N), v1(N), v2(N), v3(N);
      c->q.memcpy(ref.data(), o_th, N * 4); c->q.memcpy(v0.data(), i0, N * 4); c->q.memcpy(v1.data(), i1, N * 4); c->q.memcpy(v2.data(), i2, N * 4); c->q.memcpy(v3.data(), i3, N * 4); c->q.wait();
      size_t k0 = 0, k1 = 0, k2 = 0, k3 = 0;
      for (int i = 0; i < N; i++) { k0 += ref[i] != v0[i]; k1 += ref[i] != v1[i]; k2 += ref[i] != v2[i]; k3 += ref[i] != v3[i]; }
      fprintf(stderr, "math  sycl::tanh vs __imf_tanhf / _ha / _la / _ep mismatches: %zu / %zu / %zu / %zu of %d\n", k0, k1, k2, k3, N);
    }
    c->q.parallel_for(range<1>(N / 16), [=](id<1> i) SYCL_ESIMD_KERNEL {
      using namespace es;
      simd<float, 16> x, r;
      x.copy_from(dx + i[0] * 16); r.copy_from(dr + i[0] * 16);
      simd<float, 16> ex = es::exp(x * 2.0f);
      simd<float, 16> t = (ex - 1.0f) / (ex + 1.0f);  // ESIMD vector tanh from exp (no esimd::tanh exists)
      t.copy_to(e_th + i[0] * 16);
      simd<float, 16> rr = es::rsqrt(r);
      rr.copy_to(e_rs + i[0] * 16);
      simd<float, 16> ts;  // variant 2: 1 - 2/(exp(2x)+1)
      ts = 1.0f - 2.0f / (ex + 1.0f);
      ts.copy_to(e_th_s + i[0] * 16);
    }).wait();
    std::vector<float> a(N), b(N), cc(N), d(N), e(N);
    c->q.memcpy(a.data(), o_th, N * 4); c->q.memcpy(b.data(), e_th, N * 4); c->q.memcpy(cc.data(), e_th_s, N * 4);
    c->q.memcpy(d.data(), o_rs, N * 4); c->q.memcpy(e.data(), e_rs, N * 4); c->q.wait();
    size_t m1 = 0, m2 = 0, m3 = 0;
    for (int i = 0; i < N; i++) { m1 += a[i] != b[i]; m2 += a[i] != cc[i]; m3 += d[i] != e[i]; }
    fprintf(stderr, "math  tanh: SYCL tanh vs ESIMD (e-1)/(e+1) mismatches %zu / %d | SYCL tanh vs ESIMD 1-2/(e+1) %zu / %d | rsqrt: SYCL vs es::rsqrt %zu / %d\n", m1, N, m2, N, m3, N);
    {  // ESIMD tanh candidates against the SYCL reference, split by |x| range
      constexpr int NV = 6;
      float *ov[NV]; for (int v = 0; v < NV; v++) ov[v] = sycl::malloc_device<float>(N, c->q.q);
      c->q.parallel_for(range<1>(N / 16), [=](id<1> i) SYCL_ESIMD_KERNEL {
        using namespace es;
        simd<float, 16> x; x.copy_from(dx + i[0] * 16);
        simd<float, 16> ax = es::abs(x), sg = x / ax;   // sign via division is fine for the test (x != 0)
        simd<float, 16> em = es::exp(ax * -2.0f), ep = es::exp(ax * 2.0f);
        simd<float, 16> t[NV];
        t[0] = (1.0f - em) / (1.0f + em);
        t[1] = 1.0f - 2.0f / (ep + 1.0f);
        t[2] = 1.0f - 2.0f * es::inv(ep + 1.0f);
        t[3] = (ep - 1.0f) / (ep + 1.0f);
        t[4] = (1.0f - em) * es::inv(1.0f + em);
        t[5] = 2.0f / (1.0f + em) - 1.0f;
        for (int v = 0; v < NV; v++) { simd<float, 16> r = t[v] * sg; r.copy_to(ov[v] + i[0] * 16); }
      }).wait();
      std::vector<float> ref(N), cv(N); c->q.memcpy(ref.data(), o_th, N * 4).wait();
      for (int v = 0; v < NV; v++) {
        c->q.memcpy(cv.data(), ov[v], N * 4).wait();
        size_t mm[3] = {0, 0, 0}, tot[3] = {0, 0, 0};
        for (int i = 0; i < N; i++) { float ax = std::fabs(hx[i]); int r = ax < 0.5f ? 0 : ax < 2.0f ? 1 : 2; tot[r]++; mm[r] += ref[i] != cv[i]; }
        fprintf(stderr, "tanh variant %d: mismatches |x|<0.5: %zu/%zu, 0.5..2: %zu/%zu, >2: %zu/%zu\n", v, mm[0], tot[0], mm[1], tot[1], mm[2], tot[2]);
      }
    }
    {  // pairnorm: SYCL k_pairnorm against the ESIMD recomputation (norm_inv + rbf) on random "residual-like" vectors
      const int NV = 512;
      std::vector<float> hv((size_t)NV * 2 * D);
      std::normal_distribution<float> nd(0.f, 1.f);
      for (int v = 0; v < NV; v++) { float sc = std::exp(nd(rng) * 1.5f); for (int i = 0; i < 2 * D; i++) hv[(size_t)v * 2 * D + i] = nd(rng) * sc; }
      float *dv = sycl::malloc_device<float>(hv.size(), c->q.q), *pr = sycl::malloc_device<float>(hv.size(), c->q.q), *pe = sycl::malloc_device<float>(hv.size(), c->q.q);
      c->q.memcpy(dv, hv.data(), hv.size() * 4).wait();
      size_t bad = 0, badv = 0, tot = 0;
      for (int v = 0; v < NV; v++) {
        PairArgs pa{}; pa.n = 1; pa.dest[0] = dv + (size_t)v * 2 * D; pa.msg[0] = dv + (size_t)v * 2 * D + D; pa.pair[0] = pr + (size_t)v * 2 * D;
        k_pairnorm(c, pa, 1);
      }
      c->q.wait();
      std::vector<float> a1(hv.size()), a2(hv.size());
      c->q.memcpy(a1.data(), pr, hv.size() * 4).wait();
      auto run_dv = [&](auto tag) {
        constexpr int DVv = decltype(tag)::value;
        c->q.parallel_for(nd_range<1>((size_t)NV * 2, 1), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
          using namespace es;
          int g = (int)it.get_group(0); const float *x = dv + (size_t)g * D;
          float inv = ctlx::norm_inv<DVv>(x, false);
          for (int i = 0; i < D / 16; i++) { simd<float, 16> xv; xv.copy_from(x + i * 16); simd<float, 16> o = ctlx::rbf16(xv * inv); o.copy_to(pe + (size_t)g * D + i * 16); }
        }).wait();
        c->q.memcpy(a2.data(), pe, hv.size() * 4).wait();
        bad = badv = tot = 0;
        for (int v = 0; v < NV; v++) { size_t bv = 0; for (int i = 0; i < 2 * D; i++) bv += a1[(size_t)v * 2 * D + i] != a2[(size_t)v * 2 * D + i]; bad += bv; badv += bv > 0; tot += 2 * D; }
        fprintf(stderr, "pairnorm: SYCL vs ESIMD recomputation, ss/D variant %d: %zu / %zu outputs differ, %zu / %d vectors have a difference\n", DVv, bad, tot, badv, NV);
      };
      run_dv(std::integral_constant<int, 0>{}); run_dv(std::integral_constant<int, 1>{}); run_dv(std::integral_constant<int, 2>{}); run_dv(std::integral_constant<int, 3>{});
    }
    // (2) reduce_over_group(plus) over 256 work-items: find the summation order
    const int NT = 4096;
    std::vector<float> hp((size_t)NT * 256); std::uniform_real_distribution<float> up(0.f, 4.f);
    for (auto &v : hp) v = up(rng) * up(rng);
    float *dp = sycl::malloc_device<float>(hp.size(), c->q.q), *dres = sycl::malloc_device<float>(NT, c->q.q);
    c->q.memcpy(dp, hp.data(), hp.size() * 4).wait();
    c->q.parallel_for(nd_range<1>((size_t)NT * 256, 256), [=](nd_item<1> it) {
      float v = dp[it.get_global_id(0)];
      float r = reduce_over_group(it.get_group(), v, plus<float>());
      if (it.get_local_id(0) == 0) dres[it.get_group(0)] = r;
    }).wait();
    std::vector<float> gres(NT); c->q.memcpy(gres.data(), dres, NT * 4).wait();
    // candidate orders (host, IEEE fp32)
    auto cand = [&](int S, int intra, int inter, const float *p) {
      std::vector<float> sg(256 / S);
      for (int g = 0; g < 256 / S; g++) {
        float v[64]; for (int l = 0; l < S; l++) v[l] = p[g * S + l];
        if (intra == 0) { for (int off = S / 2; off >= 1; off >>= 1) for (int l = 0; l < off; l++) v[l] = v[l] + v[l + off]; sg[g] = v[0]; }          // halving tree
        else if (intra == 1) { for (int off = 1; off < S; off <<= 1) for (int l = 0; l + off < S; l += 2 * off) v[l] = v[l] + v[l + off]; sg[g] = v[0]; }  // adjacent pairs first
        else { float s = v[0]; for (int l = 1; l < S; l++) s = s + v[l]; sg[g] = s; }                                                                      // sequential
      }
      float r;
      if (inter == 0) { r = sg[0]; for (size_t g = 1; g < sg.size(); g++) r = r + sg[g]; }                                                                 // sequential over sub-groups
      else if (inter == 1) { std::vector<float> w = sg; for (size_t off = w.size() / 2; off >= 1; off >>= 1) for (size_t g = 0; g < off; g++) w[g] = w[g] + w[g + off]; r = w[0]; }
      else { std::vector<float> w = sg; for (size_t off = 1; off < w.size(); off <<= 1) for (size_t g = 0; g + off < w.size(); g += 2 * off) w[g] = w[g] + w[g + off]; r = w[0]; }
      return r;
    };
    const char *in_n[3] = {"halving", "adjacent", "sequential"}, *out_n[3] = {"sequential", "halving", "adjacent"};
    int bestm = -1; std::string bestn;
    for (int S : {16, 32})
      for (int intra = 0; intra < 3; intra++)
        for (int inter = 0; inter < 3; inter++) {
          int match = 0;
          for (int t = 0; t < NT; t++) match += cand(S, intra, inter, hp.data() + (size_t)t * 256) == gres[t];
          if (match > bestm) { bestm = match; bestn = "subgroup " + std::to_string(S) + ", intra " + in_n[intra] + ", inter " + out_n[inter]; }
          if (match == NT) fprintf(stderr, "reduce: EXACT match subgroup %d intra %s inter %s (%d / %d)\n", S, in_n[intra], out_n[inter], match, NT);
        }
    fprintf(stderr, "reduce: best candidate %s matches %d / %d groups\n", bestn.c_str(), bestm, NT);
    return 0;
  } catch (std::exception &ex) { g_err = ex.what(); return 1; }
}

// ---------------------------------------------------------------------------------------------------------------------------------
// W4A16 dense GEMV feasibility kernel (benchmark): int4 weights (nibble - 8) x fp16 activations on the fp16 DPAS, per-(row, 64-K group) fp16 scale applied to the
// group partial sum.  Layout per 16-row block and 32 K: 256 B = 64 dwords [q][n] (q = 0..3, n = row): dword (q,n) holds K = 8q..8q+7 of row n with nibble j of the
// K-chunk at bit 4*(j/2) (j even) or 16 + 4*(j/2) (j odd), so that ((x >> 4p) & 0x000F000F) | 0x64006400 is the half2 (1024 + k_{2p}, 1024 + k_{2p+1}): one
// shift, one and, one or per output dword, then one half subtraction (-1032) turns it into (nibble - 8) exactly.  Scales: [row block][64-K group][16 rows] fp16.
template <int KSD>
void w4_gemv(xik_ctx *c, const uint32_t *W, const uint16_t *S, const float *X, float *Y, int rows, int K) {
  const int nrb = rows / 16, ngrp = K / 64, per = ngrp / KSD;  // groups per thread (K split over KSD threads)
  c->q.parallel_for(nd_range<1>((size_t)nrb * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    slm_init<KSD * 16 * 4>();
    const int rb = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    const int g0 = tid * per;
    const uint32_t *wp = W + ((size_t)rb * (K / 32) + (size_t)g0 * 2) * 64;
    const uint16_t *sp = S + ((size_t)rb * ngrp + g0) * 16;
    simd<float, 16> acc = 0.f;
    simd<uint32_t, 128> cur, nxt;
    cur.template select<64, 1>(0) = block_load<uint32_t, 64>(wp);
    cur.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + 64);
    simd<uint16_t, 16> scur = block_load<uint16_t, 16>(sp);
    for (int g = 0; g < per; g++) {
      simd<uint16_t, 16> snx;
      if (g + 1 < per) {
        nxt.template select<64, 1>(0) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * 128);
        nxt.template select<64, 1>(64) = block_load<uint32_t, 64>(wp + (size_t)(g + 1) * 128 + 64);
        snx = block_load<uint16_t, 16>(sp + (size_t)(g + 1) * 16);
      }
      simd<float, 16> ag = 0.f;
#pragma unroll
      for (int t = 0; t < 4; t++) {  // four 16-K tiles of this group
        simd<uint32_t, 128> B;
#pragma unroll
        for (int h = 0; h < 2; h++) {
          simd<uint32_t, 16> x = cur.template select<16, 1>(64 * (t / 2) + 16 * (2 * (t % 2) + h));
#pragma unroll
          for (int pp = 0; pp < 4; pp++) {
            simd<uint32_t, 16> v = (pp == 0 ? x : (x >> (4 * pp))) & 0x000F000Fu;
            B.template select<16, 1>(16 * (4 * h + pp)) = v | 0x64006400u;
          }
        }
        simd<sycl::half, 256> bh = B.template bit_cast_view<sycl::half>();
        bh -= (sycl::half)1032.0f;
        simd<int32_t, 128> bi = bh.template bit_cast_view<int32_t>();
        simd<float, 16> xv; xv.copy_from(X + (size_t)(g0 + g) * 64 + t * 16);
        simd<sycl::half, 16> xh = xv;
        simd<int32_t, 8> a8 = xh.template bit_cast_view<int32_t>();
        simd<float, 16> z = 0.f;
        ag = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(t == 0 ? z : ag, bi, a8);
      }
      simd<sycl::half, 16> sh = scur.template bit_cast_view<sycl::half>();
      simd<float, 16> sf = sh;
      acc += ag * sf;
      if (g + 1 < per) { cur = nxt; scur = snx; }
    }
    slm_block_store<float, 16>(tid * 64, acc);
    barrier();
    if (tid == 0) {
      simd<float, 16> sum = slm_block_load<float, 16>(0);
      for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16>(j * 64);
      sum.copy_to(Y + rb * 16);
    }
  });
}
// ---------------------------------------------------------------------------------------------------------------------------------
// W3A16 formats (benchmark).  A super-tile is 16 rows x 128 K = 768 B = 3 x 256 B, dword (d, n) d = 0..11, lane n = row.  Each group of 32 K uses 3 dwords (a, b, c) = (d, d+1, d+2), d = 3g,
// and produces 16 fp16-pair registers (pair rho = K 2*rho, 2*rho+1 in the low / high half), 2 DPAS B operands.  Code q = 0..7 stands for (q - 4).
//   FMT 0 plain      : element e at bit 3e of the 96-bit group stream (elements straddle dwords)
//   FMT 1 split 2+1  : a, b = 2-bit planes (8 pairs each, pair q at bit 2q / 16 + 2q), c = 1-bit plane (pair rho at bit rho / 16 + rho)
//   FMT 2 bitplanes  : a, b, c = bit 0, 1, 2 of the code, pair rho at bit rho / 16 + rho
//   FMT 3 pre-permuted: pair rho = 5*i + j sits at bits 3j..3j+2 (low half) and 16 + 3j.. (high half) of dword i, i = 0..2 (15 pairs); pair 15 uses bits 15 / 31 of a, b, c
namespace w3 {
using namespace es;
ESIMD_INLINE simd<uint32_t, 16> plain_elem(int e, const simd<uint32_t, 16> &a, const simd<uint32_t, 16> &b, const simd<uint32_t, 16> &c) {
  const int bit = 3 * e, w = bit / 32, o = bit % 32;
  const simd<uint32_t, 16> &d0 = w == 0 ? a : w == 1 ? b : c;
  if (o <= 29) return (o == 0 ? d0 : (d0 >> o)) & 7u;
  const simd<uint32_t, 16> &d1 = w == 0 ? b : c;
  return ((d0 >> o) | (d1 << (32 - o))) & 7u;
}
template <int FMT>
ESIMD_INLINE simd<uint32_t, 16> pair_reg(int rho, const simd<uint32_t, 16> &a, const simd<uint32_t, 16> &b, const simd<uint32_t, 16> &c) {
  const uint32_t M = 0x64006400u;
  if constexpr (FMT == 3) {
    if (rho < 15) { const int i = rho / 5, j = rho % 5; const simd<uint32_t, 16> &d = i == 0 ? a : i == 1 ? b : c; return ((j == 0 ? d : (d >> (3 * j))) & 0x00070007u) | M; }
    return (((a >> 15) & 0x00010001u) | ((b >> 14) & 0x00020002u) | ((c >> 13) & 0x00040004u)) | M;
  } else if constexpr (FMT == 2) {
    simd<uint32_t, 16> x = (rho == 0 ? a : (a >> rho)) & 0x00010001u;
    x |= rho >= 1 ? ((b >> (rho - 1)) & 0x00020002u) : ((b << 1) & 0x00020002u);
    x |= rho >= 2 ? ((c >> (rho - 2)) & 0x00040004u) : ((c << (2 - rho)) & 0x00040004u);
    return x | M;
  } else if constexpr (FMT == 1) {
    const simd<uint32_t, 16> &l = rho < 8 ? a : b; const int q = rho & 7;
    simd<uint32_t, 16> x = ((q == 0 ? l : (l >> (2 * q))) & 0x00030003u);
    x |= rho >= 2 ? ((c >> (rho - 2)) & 0x00040004u) : ((c << (2 - rho)) & 0x00040004u);
    return x | M;
  } else {  // plain stream
    return (plain_elem(2 * rho, a, b, c) | (plain_elem(2 * rho + 1, a, b, c) << 16)) | M;
  }
}
}
template <int FMT, int KSD, int GS>
static void w3_gemv(xik_ctx *c, const uint32_t *W, const uint16_t *S, const sycl::half *X, float *Y, int rows, int K) {
  const int nrb = rows / 16, ntile = K / 128, per = ntile / KSD, gpt = 128 / GS;  // scale groups per tile
  c->q.parallel_for(nd_range<1>((size_t)nrb * KSD, KSD), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
    using namespace es;
    slm_init<KSD * 16 * 4>();
    const int rb = (int)it.get_group(0), tid = (int)it.get_local_id(0);
    const int t0 = tid * per;
    const uint32_t *wp = W + ((size_t)rb * ntile + t0) * 192;
    const uint16_t *sp = S + ((size_t)rb * (K / GS) + (size_t)t0 * gpt) * 16;
    const sycl::half *xp = X + (size_t)t0 * 128;
    simd<float, 16> acc = 0.f;
    simd<uint32_t, 192> cur, nxt;
#define W3LD(d, t) do { (d).template select<64, 1>(0) = block_load<uint32_t, 64>(wp + (size_t)(t) * 192); (d).template select<64, 1>(64) = block_load<uint32_t, 64>(wp + (size_t)(t) * 192 + 64); (d).template select<64, 1>(128) = block_load<uint32_t, 64>(wp + (size_t)(t) * 192 + 128); } while (0)
    W3LD(cur, 0);
    for (int t = 0; t < per; t++) {
      if (t + 1 < per) W3LD(nxt, t + 1);
      simd<uint16_t, 16 * 4> sc4;  // up to 4 scale groups per tile (GS >= 32)
#pragma unroll
      for (int q = 0; q < gpt; q++) sc4.template select<16, 1>(16 * q) = block_load<uint16_t, 16>(sp + ((size_t)t * gpt + q) * 16);
      simd<float, 16> ag = 0.f;
#pragma unroll
      for (int g = 0; g < 4; g++) {
        simd<uint32_t, 16> a = cur.template select<16, 1>(48 * g), b = cur.template select<16, 1>(48 * g + 16), cc = cur.template select<16, 1>(48 * g + 32);
        simd<uint32_t, 256> B;
#pragma unroll
        for (int rho = 0; rho < 16; rho++) B.template select<16, 1>(16 * rho) = w3::pair_reg<FMT>(rho, a, b, cc);
        simd<sycl::half, 512> bh = B.template bit_cast_view<sycl::half>();
        bh -= (sycl::half)1028.0f;
        simd<int32_t, 256> bi = bh.template bit_cast_view<int32_t>();
#pragma unroll
        for (int s2 = 0; s2 < 2; s2++) {
          simd<int32_t, 8> av = block_load<int32_t, 8>(reinterpret_cast<const int32_t *>(xp + (size_t)t * 128 + g * 32 + s2 * 16));
          simd<float, 16> z = 0.f;
          ag = xmx::dpas<8, 1, float, float, int32_t, int32_t, xmx::dpas_argument_type::fp16, xmx::dpas_argument_type::fp16>(((g * 2 + s2) % (GS / 16)) == 0 ? z : ag, simd<int32_t, 128>(bi.template select<128, 1>(128 * s2)), av);
        }
        if ((g + 1) * 32 % GS == 0) {
          simd<sycl::half, 16> sh = sc4.template select<16, 1>(16 * ((g * 32) / GS)).template bit_cast_view<sycl::half>();
          simd<float, 16> sf = sh;
          acc += ag * sf;
        }
      }
      if (t + 1 < per) cur = nxt;
    }
    slm_block_store<float, 16>(tid * 64, acc);
    barrier();
    if (tid == 0) {
      simd<float, 16> sum = slm_block_load<float, 16>(0);
      for (int j = 1; j < KSD; j++) sum += slm_block_load<float, 16>(j * 64);
      sum.copy_to(Y + rb * 16);
    }
  });
}
extern "C" int xik_bench_w3(xik_ctx *c, int rows, int K, int fmt, int ksd, int gs, int iters, int check, double *out_us, double *out_err) {
  try {
    const int nrb = rows / 16, ntile = K / 128, ngrp = K / gs;
    std::mt19937 rng(11);
    std::vector<uint8_t> q((size_t)rows * K);
    for (auto &v : q) v = rng() & 7;
    std::vector<uint32_t> hw((size_t)nrb * ntile * 192);
    for (int rb = 0; rb < nrb; rb++)
      for (int tt = 0; tt < ntile; tt++)
        for (int n = 0; n < 16; n++) {
          uint32_t d[12] = {0};
          for (int g = 0; g < 4; g++) {
            const uint8_t *e = &q[(size_t)(rb * 16 + n) * K + tt * 128 + g * 32];
            uint32_t *w = d + 3 * g;
            if (fmt == 0) {
              for (int i = 0; i < 32; i++) { int bit = 3 * i; for (int b = 0; b < 3; b++) if ((e[i] >> b) & 1) w[(bit + b) / 32] |= 1u << ((bit + b) % 32); }
            } else if (fmt == 1) {
              for (int rho = 0; rho < 16; rho++) for (int h = 0; h < 2; h++) {
                uint32_t v = e[2 * rho + h]; int qq = rho & 7; uint32_t *l = rho < 8 ? &w[0] : &w[1];
                *l |= (v & 3) << (2 * qq + 16 * h); w[2] |= ((v >> 2) & 1) << (rho + 16 * h);
              }
            } else if (fmt == 2) {
              for (int rho = 0; rho < 16; rho++) for (int h = 0; h < 2; h++) { uint32_t v = e[2 * rho + h]; for (int b = 0; b < 3; b++) w[b] |= ((v >> b) & 1) << (rho + 16 * h); }
            } else {
              for (int rho = 0; rho < 16; rho++) for (int h = 0; h < 2; h++) {
                uint32_t v = e[2 * rho + h];
                if (rho < 15) w[rho / 5] |= v << (3 * (rho % 5) + 16 * h);
                else for (int b = 0; b < 3; b++) w[b] |= ((v >> b) & 1) << (15 + 16 * h);
              }
            }
          }
          for (int dd = 0; dd < 12; dd++) hw[((size_t)rb * ntile + tt) * 192 + dd * 16 + n] = d[dd];
        }
    std::vector<uint16_t> hs((size_t)nrb * ngrp * 16); std::vector<float> sf(hs.size());
    for (size_t i = 0; i < hs.size(); i++) { sycl::half h = (sycl::half)(0.01f + 0.0001f * (float)(rng() % 100)); hs[i] = sycl::bit_cast<uint16_t>(h); sf[i] = (float)h; }
    std::vector<sycl::half> hx(K); for (auto &v : hx) v = (sycl::half)(((int)(rng() % 2001) - 1000) / 1000.f);
    uint32_t *dw = sycl::aligned_alloc_device<uint32_t>(256, hw.size(), c->q.q); uint16_t *ds = sycl::aligned_alloc_device<uint16_t>(256, hs.size(), c->q.q);
    sycl::half *dx = sycl::aligned_alloc_device<sycl::half>(256, K, c->q.q); float *dy = sycl::aligned_alloc_device<float>(256, rows, c->q.q);
    c->q.memcpy(dw, hw.data(), hw.size() * 4); c->q.memcpy(ds, hs.data(), hs.size() * 2); c->q.memcpy(dx, hx.data(), K * 2); c->q.wait();
#define W3CALL(W) do { \
      if (fmt == 0) { if (gs == 64) { if (ksd == 9) w3_gemv<0, 9, 64>(c, W, ds, dx, dy, rows, K); else w3_gemv<0, 3, 64>(c, W, ds, dx, dy, rows, K); } else { if (ksd == 9) w3_gemv<0, 9, 128>(c, W, ds, dx, dy, rows, K); else w3_gemv<0, 3, 128>(c, W, ds, dx, dy, rows, K); } } \
      else if (fmt == 1) { if (gs == 64) { if (ksd == 9) w3_gemv<1, 9, 64>(c, W, ds, dx, dy, rows, K); else w3_gemv<1, 3, 64>(c, W, ds, dx, dy, rows, K); } else { if (ksd == 9) w3_gemv<1, 9, 128>(c, W, ds, dx, dy, rows, K); else w3_gemv<1, 3, 128>(c, W, ds, dx, dy, rows, K); } } \
      else if (fmt == 2) { if (gs == 64) { if (ksd == 9) w3_gemv<2, 9, 64>(c, W, ds, dx, dy, rows, K); else w3_gemv<2, 3, 64>(c, W, ds, dx, dy, rows, K); } else { if (ksd == 9) w3_gemv<2, 9, 128>(c, W, ds, dx, dy, rows, K); else w3_gemv<2, 3, 128>(c, W, ds, dx, dy, rows, K); } } \
      else { if (gs == 64) { if (ksd == 9) w3_gemv<3, 9, 64>(c, W, ds, dx, dy, rows, K); else w3_gemv<3, 3, 64>(c, W, ds, dx, dy, rows, K); } else { if (ksd == 9) w3_gemv<3, 9, 128>(c, W, ds, dx, dy, rows, K); else w3_gemv<3, 3, 128>(c, W, ds, dx, dy, rows, K); } } } while (0)
    W3CALL(dw); c->q.wait();
    *out_err = 0;
    if (check) {
      std::vector<float> hy(rows); c->q.memcpy(hy.data(), dy, rows * 4).wait();
      double me = 0, mr = 0;
      for (int r = 0; r < rows; r += 7) {
        double ref = 0;
        for (int g = 0; g < ngrp; g++) { double gs2 = 0; for (int k = 0; k < gs; k++) gs2 += ((double)q[(size_t)r * K + g * gs + k] - 4.0) * (double)(float)hx[g * gs + k]; ref += gs2 * sf[((size_t)(r / 16) * ngrp + g) * 16 + r % 16]; }
        me = std::max(me, std::fabs(ref - hy[r])); mr = std::max(mr, std::fabs(ref));
      }
      *out_err = me / (mr + 1e-30);
    }
    const int NC = (int)std::max<size_t>(6, (size_t)(80u << 20) / (hw.size() * 4) + 1); std::vector<uint32_t *> cw(NC); cw[0] = dw;
    for (int i = 1; i < NC; i++) { cw[i] = sycl::aligned_alloc_device<uint32_t>(256, hw.size(), c->q.q); c->q.memcpy(cw[i], hw.data(), hw.size() * 4); }
    c->q.wait();
    for (int i = 0; i < 20; i++) { uint32_t *w = cw[i % NC]; W3CALL(w); }
    c->q.wait();
    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < iters; i++) { uint32_t *w = cw[i % NC]; W3CALL(w); }
    c->q.wait();
    *out_us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / iters;
    return 0;
  } catch (std::exception &e) { g_err = e.what(); return 1; }
}
extern "C" int xik_bench_w4(xik_ctx *c, int rows, int K, int ksd, int iters, int check, double *out_us, double *out_err) {
  try {
    const int nrb = rows / 16, ngrp = K / 64;
    std::mt19937 rng(7);
    std::vector<uint8_t> nib((size_t)rows * K);
    for (auto &v : nib) v = rng() & 15;
    std::vector<uint32_t> hw((size_t)nrb * (K / 32) * 64);
    // pack: block b (32 K) of row block rb: dword (q, n) holds K = 8q..8q+7 of row n, nibble j at bit 4*(j/2) (even j) or 16 + 4*(j/2) (odd j)
    for (int rb = 0; rb < nrb; rb++)
      for (int b = 0; b < K / 32; b++)
        for (int q = 0; q < 4; q++)
          for (int n = 0; n < 16; n++) {
            uint32_t d = 0;
            for (int j = 0; j < 8; j++) {
              uint32_t v = nib[(size_t)(rb * 16 + n) * K + b * 32 + 8 * q + j];
              d |= (j & 1) ? (v << (16 + 4 * (j / 2))) : (v << (4 * (j / 2)));
            }
            hw[((size_t)rb * (K / 32) + b) * 64 + q * 16 + n] = d;
          }
    std::vector<uint16_t> hs((size_t)nrb * ngrp * 16); std::vector<float> sf(hs.size());
    for (size_t i = 0; i < hs.size(); i++) { sycl::half h = (sycl::half)(0.01f + 0.0001f * (float)(rng() % 100)); hs[i] = sycl::bit_cast<uint16_t>(h); sf[i] = (float)h; }
    std::vector<float> hx(K); for (auto &v : hx) v = ((int)(rng() % 2001) - 1000) / 1000.f;
    uint32_t *dw = sycl::aligned_alloc_device<uint32_t>(256, hw.size(), c->q.q); uint16_t *ds = sycl::aligned_alloc_device<uint16_t>(256, hs.size(), c->q.q);
    float *dx = sycl::aligned_alloc_device<float>(256, K, c->q.q), *dy = sycl::aligned_alloc_device<float>(256, rows, c->q.q);
    c->q.memcpy(dw, hw.data(), hw.size() * 4); c->q.memcpy(ds, hs.data(), hs.size() * 2); c->q.memcpy(dx, hx.data(), K * 4); c->q.wait();
    auto run = [&]() { if (ksd == 12) w4_gemv<12>(c, dw, ds, dx, dy, rows, K); else if (ksd == 16) w4_gemv<16>(c, dw, ds, dx, dy, rows, K); else if (ksd == 9) w4_gemv<9>(c, dw, ds, dx, dy, rows, K); else if (ksd == 6) w4_gemv<6>(c, dw, ds, dx, dy, rows, K); else if (ksd == 4) w4_gemv<4>(c, dw, ds, dx, dy, rows, K); else w4_gemv<8>(c, dw, ds, dx, dy, rows, K); };
    run(); c->q.wait();
    *out_err = 0;
    if (check) {
      std::vector<float> hy(rows); c->q.memcpy(hy.data(), dy, rows * 4).wait();
      double me = 0, mr = 0;
      for (int r = 0; r < rows; r += 7) {
        double ref = 0;
        for (int g = 0; g < ngrp; g++) { double gs = 0; for (int k = 0; k < 64; k++) gs += ((double)nib[(size_t)r * K + g * 64 + k] - 8.0) * (double)(float)(sycl::half)hx[g * 64 + k]; ref += gs * sf[((size_t)(r / 16) * ngrp + g) * 16 + (r % 16)]; }
        me = std::max(me, std::fabs(ref - hy[r])); mr = std::max(mr, std::fabs(ref));
      }
      *out_err = me / (mr + 1e-30);
    }
    // cold weights: rotate over several copies so the weights are not L2-resident
    const int NC = (int)std::max<size_t>(6, (size_t)(80u << 20) / (hw.size() * 4) + 1); std::vector<uint32_t *> cw(NC); cw[0] = dw;
    for (int i = 1; i < NC; i++) { cw[i] = sycl::aligned_alloc_device<uint32_t>(256, hw.size(), c->q.q); c->q.memcpy(cw[i], hw.data(), hw.size() * 4); }
    c->q.wait();
    auto run2 = [&](int i) { uint32_t *w = cw[i % NC]; if (ksd == 12) w4_gemv<12>(c, w, ds, dx, dy, rows, K); else if (ksd == 16) w4_gemv<16>(c, w, ds, dx, dy, rows, K); else if (ksd == 9) w4_gemv<9>(c, w, ds, dx, dy, rows, K); else if (ksd == 6) w4_gemv<6>(c, w, ds, dx, dy, rows, K); else if (ksd == 4) w4_gemv<4>(c, w, ds, dx, dy, rows, K); else w4_gemv<8>(c, w, ds, dx, dy, rows, K); };
    for (int i = 0; i < 20; i++) run2(i);
    c->q.wait();
    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < iters; i++) run2(i);
    c->q.wait();
    *out_us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / iters;
    return 0;
  } catch (std::exception &e) { g_err = e.what(); return 1; }
}

// ---- native integer DPAS semantics probe: which (src1, src2) precisions exist on this device and how many K elements one instruction consumes
template <sycl::ext::intel::esimd::xmx::dpas_argument_type PB, sycl::ext::intel::esimd::xmx::dpas_argument_type PA, int KB, int KA>  // KB / KA: elements per dword of B / A
static void probe_dpas(xik_ctx *c, const char *name, int kexp, std::mt19937 &rng) {
  try {
    // B: 8 dwords x 16 lanes, A: 8 dwords (R = 1).  Fill with small random bytes; the host reference assumes the K dimension runs over the elements of the 8 dwords of
    // lane n (B) and of A in order, element e of dword d = K index d * KB + e (B) / d * KA + e (A) when KB == KA.
    std::vector<uint32_t> hb(128), ha(8);
    for (auto &v : hb) v = rng(); for (auto &v : ha) v = rng();
    uint32_t *db = sycl::malloc_device<uint32_t>(128, c->q.q), *da = sycl::malloc_device<uint32_t>(8, c->q.q); int32_t *dr = sycl::malloc_device<int32_t>(16, c->q.q);
    c->q.memcpy(db, hb.data(), 512); c->q.memcpy(da, ha.data(), 32); c->q.memset(dr, 0, 64).wait();
    c->q.parallel_for(nd_range<1>(1, 1), [=](nd_item<1> it) SYCL_ESIMD_KERNEL {
      using namespace es;
      simd<int32_t, 128> b; simd<int32_t, 8> a; simd<int32_t, 16> z = 0;
      b.copy_from(reinterpret_cast<const int32_t *>(db)); a.copy_from(reinterpret_cast<const int32_t *>(da));
      simd<int32_t, 16> r = sycl::ext::intel::esimd::xmx::dpas<8, 1, int32_t, int32_t, int32_t, int32_t, PB, PA>(z, b, a);
      r.copy_to(dr);
    }).wait();
    std::vector<int32_t> r(16); c->q.memcpy(r.data(), dr, 64).wait();
    fprintf(stderr, "dpas %-8s compiled and ran, result[0..3] = %d %d %d %d (expected K per instruction %d)\n", name, r[0], r[1], r[2], r[3], kexp);
    (void)KB; (void)KA;
  } catch (std::exception &e) { fprintf(stderr, "dpas %s: %s\n", name, e.what()); }
}
extern "C" int xik_probe_dpas(xik_ctx *c) {
  std::mt19937 rng(3);
  probe_dpas<sycl::ext::intel::esimd::xmx::dpas_argument_type::s8, sycl::ext::intel::esimd::xmx::dpas_argument_type::s8, 4, 4>(c, "s8 x s8", 32, rng);
  probe_dpas<sycl::ext::intel::esimd::xmx::dpas_argument_type::s4, sycl::ext::intel::esimd::xmx::dpas_argument_type::s4, 8, 8>(c, "s4 x s4", 64, rng);
  probe_dpas<sycl::ext::intel::esimd::xmx::dpas_argument_type::u4, sycl::ext::intel::esimd::xmx::dpas_argument_type::u4, 8, 8>(c, "u4 x u4", 64, rng);
  probe_dpas<sycl::ext::intel::esimd::xmx::dpas_argument_type::u8, sycl::ext::intel::esimd::xmx::dpas_argument_type::s8, 4, 4>(c, "u8 x s8", 32, rng);
  return 0;
}

extern "C" double xik_bench_launch(xik_ctx *c, int n, int kind) {
  const uint16_t *w = c->final_norm;
  NormArgs na{};
  na.n = 1; na.x[0] = c->stream; na.w[0] = w; na.out[0] = c->in[0];
  auto one = [&]() {
    if (kind == 0) k_wnorm(c, na, 1);
    else c->q.single_task([=]() {});
  };
  for (int i = 0; i < 50; i++) one();
  c->q.wait();
  auto t0 = std::chrono::steady_clock::now();
  for (int i = 0; i < n; i++) one();
  c->q.wait();
  return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / n;
}

// ---- GPU-timestamp profiling by phase segments (all kernels of a segment are recorded with their events)
extern "C" void xik_prof_rec(xik_ctx *c, int on) {
  c->q.wait();
  c->q.rec = on != 0;
  c->q.evs.clear();
  c->seg_tag.clear();
  c->q.tag = -1;
}
extern "C" void xik_prof_tag(xik_ctx *c, int tag) {
  c->seg_tag.push_back(tag);
  c->q.tag = (int)c->seg_tag.size() - 1;
}
// out: 6 doubles per segment: tag, kernel count, sum of kernel durations (us), GPU span first start..last end (us),
// start (us since the first recorded kernel), end (us).  Returns the number of segments.
extern "C" int xik_prof_segments(xik_ctx *c, double *out, int max_seg) {
  c->q.wait();
  int n = (int)c->seg_tag.size();
  if (n > max_seg) n = max_seg;
  std::vector<double> cnt(n, 0), sum(n, 0), st(n, 1e30), en(n, 0);
  double t0 = 1e30;
  for (auto &p : c->q.evs) {
    double a = p.second.get_profiling_info<sycl::info::event_profiling::command_start>() * 1e-3;
    t0 = std::min(t0, a);
  }
  for (auto &p : c->q.evs) {
    int sg = p.first;
    if (sg < 0 || sg >= n) continue;
    double a = p.second.get_profiling_info<sycl::info::event_profiling::command_start>() * 1e-3 - t0;
    double b = p.second.get_profiling_info<sycl::info::event_profiling::command_end>() * 1e-3 - t0;
    cnt[sg] += 1;
    sum[sg] += b - a;
    st[sg] = std::min(st[sg], a);
    en[sg] = std::max(en[sg], b);
  }
  for (int i = 0; i < n; i++) {
    out[i * 6 + 0] = c->seg_tag[i];
    out[i * 6 + 1] = cnt[i];
    out[i * 6 + 2] = sum[i];
    out[i * 6 + 3] = cnt[i] > 0 ? en[i] - st[i] : 0;
    out[i * 6 + 4] = cnt[i] > 0 ? st[i] : 0;
    out[i * 6 + 5] = en[i];
  }
  return n;
}

// Per-projection micro-benchmark (cold: rotates over the 24 layers).  which: 0 q, 1 k, 2 v, 3 r, 4 gate, 5 wo,
// 6 head, 7 the fused launch used by the engine (q,r,sink,gate,k,v).  Returns us/call and logical bytes/call.
extern "C" int xik_bench_dense(xik_ctx *c, int which, int T, int iters, double *out_us, double *out_bytes, int *out_fp8) {
  try {
    int it = 0;
    auto isfp8 = [&](const void *w) { return g_fp8_scale.count(w) > 0; };
    struct M { int rows, K; };
    M dims[8] = {{QD, D}, {KVD, D}, {KVD, D}, {RD, D}, {QD, D}, {D, QD}, {VOCAB, D}, {0, 0}};
    auto wsel = [&](const LayerW &lw) -> const uint16_t * {
      switch (which) { case 0: return lw.wq; case 1: return lw.wk; case 2: return lw.wv; case 3: return lw.wr; case 4: return lw.gate_attn; default: return lw.wo; }
    };
    const LayerW &l0 = c->L[0];
    bool fp8 = isfp8(which == 6 ? (const void *)c->unembed : which == 7 ? (const void *)l0.wq : (const void *)wsel(l0));
    *out_fp8 = fp8;
    auto bytes_of = [&](int rows, int K) { return (double)rows * K * (fp8 ? 1.0 : 2.0) + (fp8 ? rows * 4.0 : 0.0); };
    double by = 0;
    if (which == 7) by = bytes_of(QD, D) * 2 + bytes_of(RD, D) + bytes_of(KVD, D) * 2 + bytes_of(32, D);
    else by = bytes_of(dims[which].rows, dims[which].K);
    auto run = [&]() {
      const LayerW &lw = c->L[it++ % NLAYER];
      DArgs d;
      if (which == 7) {
        d.add(lw.wq, c->in[0], D, c->qb, QD, QD, D, false);
        d.add(lw.wr, c->in[0], D, c->rb, RD, RD, D, false);
        d.add(lw.sink, c->in[0], D, c->sinkb, NH, NH, D, false);
        d.add(lw.gate_attn, c->in[0], D, c->gateb, QD, QD, D, false);
        d.add(lw.wk, c->in[0], D, c->kb, KVD, KVD, D, true);
        d.add(lw.wv, c->in[0], D, c->vb, KVD, KVD, D, true);
        d.ksd = 16;
      } else if (which == 6) {
        d.add(c->unembed, c->in[0], D, c->logits, VOCAB, VOCAB, D, false);
      } else {
        d.add(wsel(lw), which == 5 ? c->attn_o : c->in[0], which == 5 ? QD : D, which == 5 ? c->ao2 : c->qb, which == 5 ? D : dims[which].rows,
              dims[which].rows, dims[which].K, false);
        d.ksd = which == 5 ? 32 : 16;
      }
      dgemm(c, d, T);
    };
    for (int i = 0; i < 24; i++) run();
    c->q.wait();
    auto t0 = std::chrono::steady_clock::now();
    for (int i = 0; i < iters; i++) run();
    c->q.wait();
    *out_us = std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t0).count() / iters;
    *out_bytes = by;
    return 0;
  } catch (std::exception &e) {
    g_err = e.what();
    return 1;
  }
}

// Layout report: real device addresses of every SEND stream an expert kernel issues.  For each stream the report enumerates every load
// address of one launch (all experts, row blocks and supertiles) and gives: load count, logical bytes per load, the largest power of two
// that divides ALL addresses (the alignment that can be promised), and how the addresses spread over mod-64/128/256 (so a 64 B scale load
// is not mistaken for a 256 B weight load).  Memory alignment (this report) is not the DPAS GRF operand alignment (see docs/isa).
extern "C" void xik_layout_report(xik_ctx *c, int layer) {
  const LayerW &lw = c->L[layer];
  auto m = [](const void *p, size_t a) { return (size_t)((uintptr_t)p % a); };
  struct St { const char *name; const void *base; size_t off0, pitch_e, pitch_rb, pitch_s; size_t bytes; int nE, nRB, nS; };
  auto stat = [&](const St &t) {
    size_t n = 0; uintptr_t orall = 0; size_t h256[4] = {0, 0, 0, 0}; size_t h64[4] = {0, 0, 0, 0}; size_t h128[2] = {0, 0}; size_t m16 = 0;
    for (int e = 0; e < t.nE; e++)
      for (int rb = 0; rb < t.nRB; rb++)
        for (int st = 0; st < t.nS; st++) {
          uintptr_t a = (uintptr_t)t.base + t.off0 + e * t.pitch_e + rb * t.pitch_rb + st * t.pitch_s;
          orall |= a; n++; h256[(a % 256) / 64]++; h128[(a % 128) / 64]++; h64[(a % 64) / 16]++; if (a % 16) m16++;
        }
    size_t al = orall ? (size_t)(orall & (~orall + 1)) : (size_t)1 << 20;  // lowest set bit of the OR of all addresses = common alignment
    fprintf(stderr, "    %-22s base %p (mod 16/64/128/256/4096 = %zu/%zu/%zu/%zu/%zu) | %zu loads x %zu B | common alignment %zu B | addr mod256 in {0,64,128,192}: %zu/%zu/%zu/%zu | mod128 in {0,64}: %zu/%zu | not 16B aligned: %zu\n",
            t.name, t.base, m(t.base, 16), m(t.base, 64), m(t.base, 128), m(t.base, 256), m(t.base, 4096), n, t.bytes, al, h256[0], h256[1], h256[2], h256[3], h128[0], h128[1], m16);
  };
  fprintf(stderr, "layer %d (%s)\n", layer, is_mxfp8(layer) ? "MXFP8" : "NVFP4");
  for (int k = 0; k < 2; k++) {
    int rows = k ? D : 2 * FI, K = k ? FI : D, nrb = rows / 16, nst = K / 64;
    const char *kn = k ? "w2 " : "w13";
    const void *W = k ? lw.w2 : lw.w13, *S = k ? lw.w2_s : lw.w13_s;
    if (!is_mxfp8(layer)) {
      size_t te = (size_t)nrb * nst;
      St ws[] = {{"weights tile[0:256)", W, 0, te * 512, (size_t)nst * 512, 512, 256, NE, nrb, nst},
                 {"weights tile[256:512)", W, 256, te * 512, (size_t)nst * 512, 512, 256, NE, nrb, nst},
                 {"scales (64 B/supertile)", S, 0, te * 64, (size_t)nst * 64, 64, 64, NE, nrb, nst}};
      fprintf(stderr, "  NVFP4 %s (rows %d, K %d, %d row blocks x %d supertiles), per-thread streams:\n", kn, rows, K, nrb, nst);
      for (auto &t : ws) stat(t);
    } else {
      size_t te = (size_t)nrb * nst;
      St ws[] = {{"weights 4x256 B", W, 0, te * 1024, (size_t)nst * 1024, 1024, 256, NE, nrb, nst},
                 {"weights +64 dw (h=1)", W, 256, te * 1024, (size_t)nst * 1024, 1024, 256, NE, nrb, nst},
                 {"weights +128 dw (h=2)", W, 512, te * 1024, (size_t)nst * 1024, 1024, 256, NE, nrb, nst},
                 {"weights +192 dw (h=3)", W, 768, te * 1024, (size_t)nst * 1024, 1024, 256, NE, nrb, nst},
                 {"scales (32 B/supertile)", S, 0, te * 32, (size_t)nst * 32, 32, 32, NE, nrb, nst}};
      fprintf(stderr, "  MXFP8 %s (rows %d, K %d), per-thread streams:\n", kn, rows, K);
      for (auto &t : ws) stat(t);
    }
    // activation stream: row r of x (ldx halves), 128 B per supertile (K=64 halves)
    const void *X = k ? (const void *)c->x16_act : (const void *)c->x16_in;
    size_t ldx = k ? FI : D;
    St xs = {k ? "x16_act row stream" : "x16_in row stream", X, 0, 0, ldx * 2, 128, 128, 1, TOPK * (k ? 1 : 1), nst};
    stat(xs);
  }
  fprintf(stderr, "  outputs: gu_part %p mod256 %zu | yp_part %p mod256 %zu | amax/den %p/%p\n", c->gu_part, m(c->gu_part, 256), c->yp_part, m(c->yp_part, 256), lw.w13_amax, lw.w13_den);
  fprintf(stderr, "  dense: wq tiles %p mod256 %zu | wo %p mod256 %zu | unembed %p mod256 %zu\n", lw.wq, m(lw.wq, 256), lw.wo, m(lw.wo, 256), c->unembed, m(c->unembed, 256));
}
