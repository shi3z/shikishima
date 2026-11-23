/* xik.h — C ABI of the XeInkling kernel library (libxik.so).
 *
 * Inkling-2-Mini (looped MoE, NVFP4/MXFP8 experts) on one Intel Arc Pro B60.
 * Host side uploads raw checkpoint tensors by name; the library owns all
 * device memory, the recurrent state (KV rings, short-conv history) and the
 * per-token forward pass.
 */
#ifndef XIK_H
#define XIK_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

typedef struct xik_ctx xik_ctx;

enum { XIK_BF16 = 0, XIK_F32 = 1, XIK_U8 = 2 /* fp4 packed / fp8 / scales */ };

const char *xik_last_error(void);
xik_ctx *xik_create(int max_ctx, int max_tokens);
void xik_destroy(xik_ctx *);
/* name: safetensors tensor name; raw bytes, copied to the device */
int xik_upload(xik_ctx *, const char *name, int dtype, const void *src, size_t bytes);
/* resolve all uploaded tensors, allocate caches/workspace; 0 = ok */
int xik_finalize(xik_ctx *);
void xik_reset(xik_ctx *);
int xik_pos(xik_ctx *);

/* Run T tokens (T <= max_tokens) from the current position, advancing it.
 * logits_last: optional host float[200058] receiving the logits of the last
 * token. out_argmax: optional int[T] receiving the greedy token after each
 * position (computes the head for all T rows when non-NULL). */
int xik_forward(xik_ctx *, const int32_t *ids, int T, float *logits_last, int32_t *out_argmax);

/* Speculative decoding: verify T tokens (all-position greedy output) without committing recurrent
 * state, then keep the first n of them. KV rows past n are simply overwritten later. */
int xik_verify(xik_ctx *, const int32_t *ids, int T, int32_t *out_argmax);
int xik_commit(xik_ctx *, int n);

/* DSpark drafter (needs the mtp.* tensors uploaded). ingest(n): feed the first n tokens' captured target
 * hidden states of the last forward/verify (call after every prefill chunk and every commit);
 * draft(anchor): 7 proposed tokens following `anchor`. */
int xik_ingest(xik_ctx *, int n);
int xik_draft(xik_ctx *, int32_t anchor, int32_t *out7);

/* Memory report, see xik.cpp (8 x uint64). */
void xik_mem(xik_ctx *, uint64_t *out8);

void xik_set_moe_cfg(xik_ctx *, int cfg);
int xik_bench_moe(xik_ctx *, int layer, int kind, int cfg, int T, int iters, double *out_us, double *out_bytes);

void xik_prof_rec(xik_ctx *, int on);
void xik_prof_tag(xik_ctx *, int tag);
int xik_prof_segments(xik_ctx *, double *out6, int max_seg);

/* Debug: capture the residual stream after every visit (48) of the next
 * forward into host buffer float[48][T][2304]. NULL disables. */
void xik_trace(xik_ctx *, float *buf);
/* Per-phase timing (microseconds, accumulated) — 16 slots. */
void xik_prof_enable(xik_ctx *, int on);
void xik_prof_get(xik_ctx *, double *us16);

#ifdef __cplusplus
}
#endif
#endif
