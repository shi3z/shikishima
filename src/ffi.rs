//! Raw C ABI of libxik.so (kernels/xik.h).
use std::os::raw::{c_char, c_int, c_void};

#[repr(C)]
pub struct XikCtx {
    _p: [u8; 0],
}

unsafe extern "C" {
    pub fn xik_last_error() -> *const c_char;
    pub fn xik_create(max_ctx: c_int, max_tokens: c_int) -> *mut XikCtx;
    pub fn xik_destroy(c: *mut XikCtx);
    pub fn xik_upload(c: *mut XikCtx, name: *const c_char, dtype: c_int, src: *const c_void, bytes: usize) -> c_int;
    pub fn xik_finalize(c: *mut XikCtx) -> c_int;
    pub fn xik_reset(c: *mut XikCtx);
    pub fn xik_pos(c: *mut XikCtx) -> c_int;
    pub fn xik_forward(c: *mut XikCtx, ids: *const i32, t: c_int, logits_last: *mut f32, out_argmax: *mut i32) -> c_int;
    pub fn xik_verify(c: *mut XikCtx, ids: *const i32, t: c_int, out_argmax: *mut i32) -> c_int;
    pub fn xik_commit(c: *mut XikCtx, n: c_int) -> c_int;
    pub fn xik_ingest_pending(c: *mut XikCtx) -> c_int;
    pub fn xik_pending(c: *mut XikCtx) -> c_int;
    pub fn xik_discard_pending(c: *mut XikCtx);
    pub fn xik_draft(c: *mut XikCtx, anchor: i32, out7: *mut i32) -> c_int;
    pub fn xik_mem(c: *mut XikCtx, out: *mut u64);
    pub fn xik_set_moe_cfg(c: *mut XikCtx, cfg: c_int);
    pub fn xik_bench_moe(c: *mut XikCtx, layer: c_int, kind: c_int, cfg: c_int, t: c_int, iters: c_int, us: *mut f64, bytes: *mut f64) -> c_int;
    pub fn xik_bench_fp4var(c: *mut XikCtx, var: c_int, na: c_int, rot: c_int, iters: c_int, us: *mut f64, dur: *mut f64) -> c_int;
    pub fn xik_route_dump(c: *mut XikCtx, path: *const std::os::raw::c_char) -> c_int;
    pub fn xik_bench_launch(c: *mut XikCtx, n: c_int, kind: c_int) -> f64;
    pub fn xik_prof_rec(c: *mut XikCtx, on: c_int);
    pub fn xik_prof_tag(c: *mut XikCtx, tag: c_int);
    pub fn xik_prof_segments(c: *mut XikCtx, out: *mut f64, max_seg: c_int) -> c_int;
    pub fn xik_bench_dense(c: *mut XikCtx, which: c_int, t: c_int, iters: c_int, us: *mut f64, bytes: *mut f64, fp8: *mut c_int) -> c_int;
    pub fn xik_layout_report(c: *mut XikCtx, layer: c_int);
    pub fn xik_trace(c: *mut XikCtx, buf: *mut f32);
    pub fn xik_prof_enable(c: *mut XikCtx, on: c_int);
    pub fn xik_prof_get(c: *mut XikCtx, us16: *mut f64);
}
