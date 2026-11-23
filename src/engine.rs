//! Safe wrapper over libxik.
use crate::{ffi, loader::Safetensors};
use std::{ffi::CString, path::Path};

pub const VOCAB_U: usize = 200058;

pub struct Engine {
    ctx: *mut ffi::XikCtx,
    pub max_tokens: usize,
    pub logits: Vec<f32>,
    pub has_drafter: bool,
}

fn last_error() -> String {
    unsafe { std::ffi::CStr::from_ptr(ffi::xik_last_error()).to_string_lossy().into_owned() }
}

impl Engine {
    pub fn new(model_dir: &Path, max_ctx: usize, max_tokens: usize) -> Result<Self, String> {
        let ctx = unsafe { ffi::xik_create(max_ctx as i32, max_tokens as i32) };
        if ctx.is_null() {
            return Err(last_error());
        }
        let st = Safetensors::open(&model_dir.join("model-00001-of-00001.safetensors"))?;
        for t in st.tensors.iter().filter(|t| t.name.starts_with("model.llm.")) {
            let name = CString::new(t.name.as_str()).unwrap();
            let b = st.bytes(t);
            if unsafe { ffi::xik_upload(ctx, name.as_ptr(), 2, b.as_ptr().cast(), b.len()) } != 0 {
                return Err(last_error());
            }
        }
        let mtp = model_dir.join("mtp.safetensors");
        let mut has_drafter = false;
        if mtp.exists() && std::env::var("XIK_NO_DRAFTER").is_err() {
            let sm = Safetensors::open(&mtp)?;
            for t in sm.tensors.iter() {
                let name = CString::new(format!("mtp.{}", t.name)).unwrap();
                let b = sm.bytes(t);
                if unsafe { ffi::xik_upload(ctx, name.as_ptr(), 2, b.as_ptr().cast(), b.len()) } != 0 {
                    return Err(last_error());
                }
            }
            has_drafter = true;
        }
        if unsafe { ffi::xik_finalize(ctx) } != 0 {
            return Err(last_error());
        }
        Ok(Self { ctx, max_tokens, logits: vec![0.0; VOCAB_U], has_drafter })
    }

    pub fn reset(&mut self) {
        unsafe { ffi::xik_reset(self.ctx) }
    }
    pub fn pos(&self) -> usize {
        unsafe { ffi::xik_pos(self.ctx) as usize }
    }

    /// Runs `ids` (<= max_tokens). Fills `self.logits` (last token) when `want_logits`;
    /// returns the greedy next token after every position when `want_argmax`.
    pub fn forward(&mut self, ids: &[i32], want_logits: bool, want_argmax: bool) -> Result<Vec<i32>, String> {
        let mut am = vec![0i32; if want_argmax { ids.len() } else { 0 }];
        let r = unsafe {
            ffi::xik_forward(
                self.ctx,
                ids.as_ptr(),
                ids.len() as i32,
                if want_logits { self.logits.as_mut_ptr() } else { std::ptr::null_mut() },
                if want_argmax { am.as_mut_ptr() } else { std::ptr::null_mut() },
            )
        };
        if r != 0 {
            return Err(last_error());
        }
        Ok(am)
    }

    /// Speculative verification of `ids`: returns the greedy token after every position.
    /// Nothing is committed until `commit(n)`.
    pub fn verify(&mut self, ids: &[i32]) -> Result<Vec<i32>, String> {
        let mut am = vec![0i32; ids.len()];
        if unsafe { ffi::xik_verify(self.ctx, ids.as_ptr(), ids.len() as i32, am.as_mut_ptr()) } != 0 {
            return Err(last_error());
        }
        Ok(am)
    }
    /// Keep the first `n` tokens of the last `verify`.
    pub fn commit(&mut self, n: usize) -> Result<(), String> {
        if unsafe { ffi::xik_commit(self.ctx, n as i32) } != 0 {
            return Err(last_error());
        }
        Ok(())
    }

    /// Feed all pending target hidden states (kept in a ring since the last call) to the drafter's context.
    pub fn ingest_pending(&mut self) -> Result<(), String> {
        if unsafe { ffi::xik_ingest_pending(self.ctx) } != 0 {
            return Err(last_error());
        }
        Ok(())
    }
    /// Compatibility: ingest everything pending (the argument is ignored).
    pub fn ingest(&mut self, _n: usize) -> Result<(), String> {
        self.ingest_pending()
    }
    /// Plain decoding never drafts: forget the backlog (the drafter context would have a gap afterwards).
    pub fn discard_pending(&mut self) {
        unsafe { ffi::xik_discard_pending(self.ctx) }
    }
    pub fn pending(&self) -> usize {
        unsafe { ffi::xik_pending(self.ctx) as usize }
    }
    /// DSpark: 7 tokens proposed after `anchor`.
    pub fn draft(&mut self, anchor: i32) -> Result<[i32; 7], String> {
        let mut o = [0i32; 7];
        if unsafe { ffi::xik_draft(self.ctx, anchor, o.as_mut_ptr()) } != 0 {
            return Err(last_error());
        }
        Ok(o)
    }
    /// Prefill that also feeds the drafter context.
    pub fn prefill_drafting(&mut self, ids: &[i32]) -> Result<i32, String> {
        let mut last = 0;
        for ch in ids.chunks(self.max_tokens) {
            last = self.forward(ch, false, true)?.pop().unwrap();
            self.ingest_pending()?;
        }
        Ok(last)
    }

    /// Chunked prefill; returns the greedy token after the last prompt token.
    pub fn prefill(&mut self, ids: &[i32]) -> Result<i32, String> {
        let mut last = 0;
        for ch in ids.chunks(self.max_tokens) {
            last = self.forward(ch, false, true)?.pop().unwrap();
            if self.pending() > 128 {
                self.discard_pending(); // plain prefill: the drafter is not used for this sequence
            }
        }
        Ok(last)
    }

    pub fn mem(&self) -> [u64; 8] {
        let mut o = [0u64; 8];
        unsafe { ffi::xik_mem(self.ctx, o.as_mut_ptr()) };
        o
    }
    /// Debug: residual stream after every visit of the next forward(s) is copied to `buf` ([48][T][2304] f32). Null disables.
    pub fn set_trace(&mut self, buf: *mut f32) {
        unsafe { ffi::xik_trace(self.ctx, buf) }
    }
    pub fn set_moe_cfg(&mut self, cfg: i32) {
        unsafe { ffi::xik_set_moe_cfg(self.ctx, cfg) }
    }
    /// (microseconds per call, expert-weight bytes touched) of one NVFP4 expert kernel run back to back.
    pub fn bench_moe(&mut self, layer: i32, kind: i32, cfg: i32, t: i32, iters: i32) -> Result<(f64, f64), String> {
        let (mut us, mut by) = (0f64, 0f64);
        if unsafe { ffi::xik_bench_moe(self.ctx, layer, kind, cfg, t, iters, &mut us, &mut by) } != 0 {
            return Err(last_error());
        }
        Ok((us, by))
    }
    pub fn bench_launch(&mut self, n: i32, kind: i32) -> f64 {
        unsafe { ffi::xik_bench_launch(self.ctx, n, kind) }
    }
    pub fn prof_rec(&mut self, on: bool) {
        unsafe { ffi::xik_prof_rec(self.ctx, on as i32) }
    }
    pub fn prof_tag(&mut self, tag: i32) {
        unsafe { ffi::xik_prof_tag(self.ctx, tag) }
    }
    /// per segment: (tag, kernels, sum of kernel us, GPU span us, start us, end us)
    pub fn prof_segments(&mut self) -> Vec<[f64; 6]> {
        let mut buf = vec![0f64; 6 * 4096];
        let n = unsafe { ffi::xik_prof_segments(self.ctx, buf.as_mut_ptr(), 4096) } as usize;
        (0..n).map(|i| [buf[i * 6], buf[i * 6 + 1], buf[i * 6 + 2], buf[i * 6 + 3], buf[i * 6 + 4], buf[i * 6 + 5]]).collect()
    }
    /// cold single-projection benchmark: (us per call, logical bytes, fp8 weights?)
    pub fn bench_dense(&mut self, which: i32, t: i32, iters: i32) -> Result<(f64, f64, bool), String> {
        let (mut us, mut by, mut f8) = (0f64, 0f64, 0i32);
        if unsafe { ffi::xik_bench_dense(self.ctx, which, t, iters, &mut us, &mut by, &mut f8) } != 0 {
            return Err(last_error());
        }
        Ok((us, by, f8 != 0))
    }
    pub fn layout_report(&self, layer: i32) {
        unsafe { ffi::xik_layout_report(self.ctx, layer) }
    }
    pub fn prof(&mut self, on: bool) {
        unsafe { ffi::xik_prof_enable(self.ctx, on as i32) }
    }
    pub fn prof_us(&mut self) -> [f64; 16] {
        let mut a = [0f64; 16];
        unsafe { ffi::xik_prof_get(self.ctx, a.as_mut_ptr()) };
        a
    }
}

impl Drop for Engine {
    fn drop(&mut self) {
        unsafe { ffi::xik_destroy(self.ctx) }
    }
}
