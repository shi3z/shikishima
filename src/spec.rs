//! Greedy speculative decoding: any `Drafter` proposes tokens, the engine verifies them in one
//! pass and keeps the longest prefix the target itself would have produced (lossless).
use crate::engine::Engine;

pub trait Drafter {
    /// Propose up to `max` tokens following `history` (prompt + generated so far, last token = anchor).
    fn draft(&mut self, history: &[i32], max: usize) -> Vec<i32>;
}

/// Prompt-lookup drafter: finds the latest earlier occurrence of the trailing n-gram and copies what followed.
pub struct LookupDrafter {
    pub ngram: usize,
}

impl Drafter for LookupDrafter {
    fn draft(&mut self, h: &[i32], max: usize) -> Vec<i32> {
        for n in (1..=self.ngram).rev() {
            if h.len() <= n {
                continue;
            }
            let key = &h[h.len() - n..];
            for i in (0..h.len() - n).rev() {
                if &h[i..i + n] == key {
                    let end = (i + n + max).min(h.len());
                    return h[i + n..end].to_vec();
                }
            }
        }
        vec![]
    }
}

#[derive(Default, Debug)]
pub struct SpecStats {
    pub cycles: usize,
    pub drafted: usize,
    pub accepted: usize,
    pub t_draft: f64,
    pub t_verify: f64,
    pub t_commit: f64,
    pub hist: [usize; 9],
}

/// Generates `n` tokens after `prompt`. `history` must be the prompt; returns generated tokens.
pub fn generate(e: &mut Engine, d: &mut dyn Drafter, prompt: &[i32], n: usize, block: usize) -> Result<(Vec<i32>, SpecStats), String> {
    let mut hist = prompt.to_vec();
    let mut out = vec![];
    let mut st = SpecStats::default();
    // after prefill: `bonus` = target's token for the next position (not yet fed to the engine)
    let mut bonus = e.prefill(prompt)?;
    while out.len() < n {
        hist.push(bonus);
        out.push(bonus);
        if out.len() >= n {
            break;
        }
        let drafts = d.draft(&hist, block.saturating_sub(1));
        let mut ids = vec![bonus];
        ids.extend_from_slice(&drafts);
        let am = e.verify(&ids)?;
        let mut acc = 0;
        while acc < drafts.len() && am[acc] == drafts[acc] {
            acc += 1;
        }
        e.commit(1 + acc)?;
        st.cycles += 1;
        st.drafted += drafts.len();
        st.accepted += acc;
        for k in 0..acc {
            hist.push(drafts[k]);
            out.push(drafts[k]);
        }
        bonus = am[acc];
    }
    out.truncate(n);
    Ok((out, st))
}

/// Longest-suffix copy proposal: finds the earlier occurrence with the longest common suffix (>= `min_n`) and
/// proposes what followed it (up to `max` tokens).
pub fn copy_proposal(h: &[i32], min_n: usize, max_n: usize, max: usize) -> Vec<i32> {
    let len = h.len();
    if len < min_n + 1 {
        return vec![];
    }
    let mut best: (usize, usize) = (0, 0); // (match length, start of continuation)
    for i in (0..len - 1).rev() {
        let mut m = 0;
        while m < max_n && i >= m && h[i - m] == h[len - 1 - m] {
            m += 1;
        }
        if m >= min_n && m > best.0 {
            best = (m, i + 1);
            if m >= max_n {
                break;
            }
        }
    }
    if best.0 == 0 {
        return vec![];
    }
    let end = (best.1 + max).min(len);
    h[best.1..end].to_vec()
}

/// Online policy: picks how many tokens to verify, from measured acceptance and a linear cost model.
pub struct Adaptive {
    /// est[j-1] ~ P(at least j drafts accepted | j drafts verified), exponential moving average
    est: [f64; 7],
    /// per-position acceptance probability of copy proposals (geometric model)
    pub copy_rate: f64,
    pub c1: f64,    // seconds, one-token pass
    pub slope: f64, // seconds per extra verified token
    pub c_draft: f64,
    cycles_since_draft: usize,
}

impl Adaptive {
    pub fn new() -> Self {
        let f = |k: &str, d: f64| std::env::var(k).ok().and_then(|v| v.parse().ok()).unwrap_or(d);
        Self { est: [0.6, 0.45, 0.3, 0.2, 0.15, 0.1, 0.08], copy_rate: 0.7, c1: f("XIK_C1", 0.0225), slope: f("XIK_SLOPE", 0.0031), c_draft: f("XIK_CDRAFT", 0.0107), cycles_since_draft: 0 }
    }
    /// best DSpark length and its predicted tokens/s
    pub fn plan_draft(&self, kmax: usize) -> (usize, f64) {
        let mut best = (0usize, 1.0 / self.c1);
        let mut gain = 1.0;
        for k in 1..=kmax.min(7) {
            gain += self.est[k - 1];
            let r = gain / (self.c1 + self.slope * k as f64 + self.c_draft);
            if r > best.1 {
                best = (k, r);
            }
        }
        best
    }
    /// best copy length (<= len) and its predicted tokens/s, assuming geometric acceptance
    pub fn plan_copy(&self, len: usize) -> (usize, f64) {
        let mut best = (0usize, 0.0);
        let mut gain = 1.0;
        let mut p = 1.0;
        for k in 1..=len {
            p *= self.copy_rate;
            gain += p;
            let r = gain / (self.c1 + self.slope * k as f64);
            if r > best.1 {
                best = (k, r);
            }
        }
        best
    }
    pub fn choose(&mut self, kmax: usize) -> usize {
        let best = self.plan_draft(kmax);
        // refresh the statistics now and then even when drafting looks unprofitable
        if best.0 == 0 {
            self.cycles_since_draft += 1;
            if self.cycles_since_draft >= 12 {
                self.cycles_since_draft = 0;
                return kmax.min(3);
            }
        } else {
            self.cycles_since_draft = 0;
        }
        best.0
    }
    pub fn update(&mut self, k: usize, acc: usize) {
        for j in 1..=k {
            let hit = if acc >= j { 1.0 } else { 0.0 };
            self.est[j - 1] += 0.12 * (hit - self.est[j - 1]);
        }
    }
    pub fn update_copy(&mut self, k: usize, acc: usize) {
        let trials = acc + if acc < k { 1 } else { 0 };
        let r = acc as f64 / trials.max(1) as f64;
        self.copy_rate += 0.25 * (r.clamp(0.05, 0.98) - self.copy_rate);
    }
}

/// Online controller: tracks the measured cost of a plain step, of verifying extra rows, and of drafting, and the
/// acceptance of both proposal sources; picks the path with the best expected committed tokens per second.
pub struct Ctl {
    est: [f64; 7],    // DSpark: P(at least j of the first j drafts accepted)
    copy_rate: f64,   // copy proposals: per-position acceptance (geometric model)
    cs: f64,          // decayed counts of accepted / rejected copied tokens
    cf: f64,
    pub t_commit: f64, // s, commit of a verified window (paid by speculative rounds only)
    pub t_plain: f64, // s, plain step (T=1 forward)
    pub slope: f64,   // s per extra verified row
    pub t_draft: f64, // s, draft + pending ingest
    since_probe: usize,
    pub cooldown: usize,   // rounds during which DSpark is not tried (it recently lost against a plain step)
    pub losses: usize,
}

impl Ctl {
    pub fn new(t_plain: f64) -> Self {
        let f = |k: &str, d: f64| std::env::var(k).ok().and_then(|v| v.parse().ok()).unwrap_or(d);
        Self { est: [0.6, 0.45, 0.3, 0.2, 0.15, 0.1, 0.08], copy_rate: 0.7, cs: 3.0, cf: 1.3, t_commit: 0.0012, t_plain: f("XIK_C1", t_plain), slope: f("XIK_SLOPE", 0.0031), t_draft: f("XIK_CDRAFT", 0.0107), since_probe: 0, cooldown: 0, losses: 0 }
    }
    fn vcost(&self, rows: usize) -> f64 {
        self.t_plain + self.slope * (rows as f64 - 1.0) + self.t_commit
    }
    pub fn plan_dspark(&self, kmax: usize) -> (usize, f64) {
        let (mut best, mut gain) = ((0usize, 0.0), 1.0);
        for k in 1..=kmax.min(7) {
            gain += self.est[k - 1] * 0.85; // conservative: the moving average lags behind sudden drops in acceptance
            let r = gain / (self.vcost(1 + k) + self.t_draft);
            if r > best.1 { best = (k, r); }
        }
        best
    }
    pub fn plan_copy(&self, len: usize) -> (usize, f64) {
        let (mut best, mut gain, mut p) = ((0usize, 0.0), 1.0, 1.0);
        for k in 1..=len {
            p *= self.copy_rate;
            gain += p;
            let r = gain / self.vcost(1 + k);
            if r > best.1 { best = (k, r); }
        }
        best
    }
    pub fn upd_dspark(&mut self, k: usize, acc: usize) {
        for j in 1..=k {
            let hit = if acc >= j { 1.0 } else { 0.0 };
            self.est[j - 1] += 0.12 * (hit - self.est[j - 1]);
        }
    }
    pub fn upd_copy(&mut self, k: usize, acc: usize) {
        // per-token Bernoulli counts with decay: one failure when the window was cut short
        self.cs = self.cs * 0.8 + acc as f64;
        self.cf = self.cf * 0.8 + if acc < k { 1.0 } else { 0.0 };
        self.copy_rate = (self.cs / (self.cs + self.cf)).clamp(0.05, 0.985);
    }
    pub fn obs_plain(&mut self, t: f64) { self.t_plain += 0.1 * (t - self.t_plain); }
    pub fn obs_verify(&mut self, rows: usize, t: f64) {
        if rows >= 2 {
            let s = ((t - self.t_plain) / (rows as f64 - 1.0)).max(0.0005);
            self.slope += 0.1 * (s - self.slope);
        }
    }
    pub fn obs_commit(&mut self, t: f64) { self.t_commit += 0.1 * (t - self.t_commit); }
    pub fn obs_draft(&mut self, t: f64) { self.t_draft += 0.15 * (t - self.t_draft); }
}

#[derive(Default, Debug, Clone)]
pub struct KindStats {
    pub rounds: usize,
    pub tokens: usize, // committed tokens
    pub secs: f64,
}
/// Per-source diagnostics of speculative rounds.
#[derive(Debug, Clone)]
pub struct SpecDiag {
    pub rounds: usize,
    pub cand_len: usize, // copy: length of the proposal found (before the controller trimmed it)
    pub k_sum: usize,    // tokens proposed to the verifier
    pub acc_sum: usize,  // tokens accepted
    pub full: usize,     // rounds in which every proposed token was accepted
    pub khist: [usize; 33],
    pub t_verify: f64,
    pub t_commit: f64,
}
impl Default for SpecDiag {
    fn default() -> Self {
        Self { rounds: 0, cand_len: 0, k_sum: 0, acc_sum: 0, full: 0, khist: [0; 33], t_verify: 0.0, t_commit: 0.0 }
    }
}
impl SpecDiag {
    pub fn add(&mut self, cand: usize, k: usize, acc: usize, tv: f64, tc: f64) {
        self.rounds += 1;
        self.cand_len += cand;
        self.k_sum += k;
        self.acc_sum += acc;
        if acc == k { self.full += 1; }
        self.khist[k.min(32)] += 1;
        self.t_verify += tv;
        self.t_commit += tc;
    }
    pub fn report(&self, name: &str) -> String {
        if self.rounds == 0 { return format!("{name}: no rounds"); }
        let r = self.rounds as f64;
        let hist: Vec<String> = self.khist.iter().enumerate().filter(|(_, c)| **c > 0).map(|(k, c)| format!("K{k}:{c}")).collect();
        format!("{name}: rounds {} | candidate len {:.1} | K {:.1} | accepted {:.2} (of K: {:.0}%) | full-accept {:.0}% | verify {:.1} ms | commit {:.2} ms | K hist [{}]",
            self.rounds, self.cand_len as f64 / r, self.k_sum as f64 / r, self.acc_sum as f64 / r, 100.0 * self.acc_sum as f64 / self.k_sum.max(1) as f64,
            100.0 * self.full as f64 / r, self.t_verify / r * 1e3, self.t_commit / r * 1e3, hist.join(" "))
    }
}
#[derive(Default, Debug)]
pub struct HybridStats {
    pub copy_diag: SpecDiag,
    pub dspark_diag: SpecDiag,
    pub plain: KindStats,
    pub dspark: KindStats,
    pub copy: KindStats,
    pub prefill_secs: f64,
    pub ctl_secs: f64,
    pub draft_secs: f64,
    pub ingest_secs: f64,
}

/// Plain steps, copy proposals (long, from the request's own history) and the DSpark drafter, whichever the
/// controller predicts to commit the most tokens per second. Output equals plain greedy decoding of the same weights.
pub fn generate_hybrid(e: &mut Engine, prompt: &[i32], n: usize, block: usize, max_copy: usize, use_dspark: bool) -> Result<(Vec<i32>, SpecStats, HybridStats), String> {
    use std::time::Instant;
    let mut out = vec![];
    let mut st = SpecStats::default();
    let mut hs = HybridStats::default();
    let mut ctl = Ctl::new(0.0225);
    let mut hist = prompt.to_vec();
    let tpf = Instant::now();
    let mut bonus = e.prefill_drafting(prompt)?;
    hs.prefill_secs = tpf.elapsed().as_secs_f64();
    let mut rounds = 0usize;
    let margin = 1.03;
    let trace = std::env::var("XIK_TRACE_CTL").is_ok();
    while out.len() < n {
        out.push(bonus);
        hist.push(bonus);
        if out.len() >= n {
            break;
        }
        let tc = Instant::now();
        // 0 plain, 1 dspark, 2 copy
        let (mut kind, mut k) = (0u8, 0usize);
        if rounds >= 3 {
            let cp = if max_copy > 0 { copy_proposal(&hist, 3, 12, max_copy.min(e.max_tokens - 1)) } else { vec![] };
            let fixed_ck: Option<usize> = std::env::var("XIK_COPY_K").ok().and_then(|v| v.parse().ok());
            let (ck, cr) = if cp.len() >= 2 {
                match fixed_ck {
                    Some(f) => (f.min(cp.len()), f64::MAX), // forced: always copy when a proposal exists
                    None => ctl.plan_copy(cp.len()),
                }
            } else { (0, 0.0) };
            if ctl.cooldown > 0 { ctl.cooldown -= 1; }
            let (dk, dr) = if use_dspark && ctl.cooldown == 0 { ctl.plan_dspark((block - 1).min(7)) } else { (0, 0.0) };
            let pr = margin / ctl.t_plain;
            if ck > 0 && cr > dr && cr > pr {
                kind = 2;
                k = ck;
            } else if dk > 0 && dr > pr {
                kind = 1;
                k = dk;
            } else if use_dspark && ctl.cooldown == 0 {
                ctl.since_probe += 1;
                if ctl.since_probe >= 16 { // refresh the DSpark statistics now and then
                    ctl.since_probe = 0;
                    kind = 1;
                    k = (block - 1).min(7).min(3);
                }
            }
            if trace {
                eprintln!("r{rounds} plain {:.1}/s | dspark k{dk} {:.1}/s | copy k{ck} {:.1}/s (len {}) | est {:?} rate {:.2} tp {:.1}ms sl {:.2}ms td {:.1}ms -> kind {kind} k {k}", 1.0 / ctl.t_plain, dr, cr, cp.len(), ctl.est.iter().map(|x| (x * 100.0).round() / 100.0).collect::<Vec<_>>(), ctl.copy_rate, ctl.t_plain * 1e3, ctl.slope * 1e3, ctl.t_draft * 1e3);
            }
            if kind == 2 {
                // proposals travel via `hist`-derived vector
                let drafts = cp[..k].to_vec();
                hs.ctl_secs += tc.elapsed().as_secs_f64();
                let mut ids = vec![bonus];
                ids.extend_from_slice(&drafts);
                let t1 = Instant::now();
                let am = e.verify(&ids)?;
                let dv = t1.elapsed().as_secs_f64();
                let mut acc = 0;
                while acc < drafts.len() && am[acc] == drafts[acc] { acc += 1; }
                let t2 = Instant::now();
                e.commit(1 + acc)?;
                ctl.obs_commit(t2.elapsed().as_secs_f64());
                let dt = dv + t2.elapsed().as_secs_f64();
                ctl.obs_verify(ids.len(), dv);
                ctl.upd_copy(k, acc);
                hs.copy_diag.add(cp.len(), k, acc, dv, dt - dv);
                hs.copy.rounds += 1; hs.copy.tokens += 1 + acc; hs.copy.secs += dt;
                st.cycles += 1; st.hist[acc.min(8)] += 1; st.drafted += k; st.accepted += acc;
                for j in 0..acc { out.push(drafts[j]); hist.push(drafts[j]); }
                bonus = am[acc];
                rounds += 1;
                if e.has_drafter && e.pending() > 160 { e.ingest_pending()?; }
                continue;
            }
        }
        hs.ctl_secs += tc.elapsed().as_secs_f64();
        if kind == 1 {
            let t0 = Instant::now();
            e.ingest_pending()?;
            let ti = t0.elapsed().as_secs_f64();
            let d7 = e.draft(bonus)?;
            let td = t0.elapsed().as_secs_f64();
            hs.ingest_secs += ti; hs.draft_secs += td - ti;
            ctl.obs_draft(td);
            let drafts = d7[..k].to_vec();
            let mut ids = vec![bonus];
            ids.extend_from_slice(&drafts);
            let t1 = Instant::now();
            let am = e.verify(&ids)?;
            let dv = t1.elapsed().as_secs_f64();
            let mut acc = 0;
            while acc < drafts.len() && am[acc] == drafts[acc] { acc += 1; }
            let t2 = Instant::now();
            e.commit(1 + acc)?;
            ctl.obs_commit(t2.elapsed().as_secs_f64());
            let dt = dv + t2.elapsed().as_secs_f64();
            ctl.obs_verify(ids.len(), dv);
            ctl.upd_dspark(k, acc);
            hs.dspark_diag.add(7, k, acc, dv, dt - dv);
            if (1 + acc) as f64 / (td + dt) < 1.0 / ctl.t_plain {
                ctl.losses += 1;
                if ctl.losses >= 2 { ctl.cooldown = 24; ctl.losses = 0; }
            } else {
                ctl.losses = 0;
            }
            hs.dspark.rounds += 1; hs.dspark.tokens += 1 + acc; hs.dspark.secs += td + dt;
            st.cycles += 1; st.hist[acc.min(8)] += 1; st.drafted += k; st.accepted += acc;
            for j in 0..acc { out.push(drafts[j]); hist.push(drafts[j]); }
            bonus = am[acc];
        } else {
            let t1 = Instant::now();
            let am = e.forward(&[bonus], false, true)?;
            let dt = t1.elapsed().as_secs_f64();
            ctl.obs_plain(dt);
            hs.plain.rounds += 1; hs.plain.tokens += 1; hs.plain.secs += dt;
            st.cycles += 1; st.hist[0] += 1;
            bonus = am[0];
            if e.has_drafter && e.pending() > 160 { e.ingest_pending()?; }
        }
        rounds += 1;
    }
    out.truncate(n);
    Ok((out, st, hs))
}

/// Speculative decoding with the model's own DSpark drafter. Draft length is chosen per cycle (`Adaptive`);
/// `block` caps the verified tokens per cycle (<= 8). Output is identical to plain greedy decoding.
pub fn generate_dspark(e: &mut Engine, prompt: &[i32], n: usize, block: usize) -> Result<(Vec<i32>, SpecStats), String> {
    let mut out = vec![];
    let mut st = SpecStats::default();
    let mut pol = Adaptive::new();
    let fixed: Option<usize> = std::env::var("XIK_FIXED_K").ok().and_then(|v| v.parse().ok());
    let mut bonus = e.prefill_drafting(prompt)?;
    while out.len() < n {
        out.push(bonus);
        if out.len() >= n {
            break;
        }
        let k = fixed.unwrap_or_else(|| pol.choose((block - 1).min(7)));
        let mut ids = vec![bonus];
        let mut drafts: Vec<i32> = vec![];
        if k > 0 {
            let t0 = std::time::Instant::now();
            let d7 = e.draft(bonus)?;
            st.t_draft += t0.elapsed().as_secs_f64();
            drafts = d7[..k].to_vec();
            ids.extend_from_slice(&drafts);
        }
        let t1 = std::time::Instant::now();
        let am = e.verify(&ids)?;
        st.t_verify += t1.elapsed().as_secs_f64();
        let mut acc = 0;
        while acc < drafts.len() && am[acc] == drafts[acc] {
            acc += 1;
        }
        let t2 = std::time::Instant::now();
        e.commit(1 + acc)?;
        e.ingest(1 + acc)?;
        st.t_commit += t2.elapsed().as_secs_f64();
        st.cycles += 1;
        st.hist[acc] += 1;
        if k > 0 {
            pol.update(k, acc);
        }
        if std::env::var("XIK_DEBUG_DRAFT").is_ok() && st.cycles <= 14 {
            eprintln!("cycle {} k {} anchor {} drafts {:?} target {:?} acc {}", st.cycles, k, bonus, drafts, &am[..am.len().min(8)], acc);
        }
        st.drafted += drafts.len();
        st.accepted += acc;
        for j in 0..acc {
            out.push(drafts[j]);
        }
        bonus = am[acc];
    }
    out.truncate(n);
    Ok((out, st))
}

/// Fully decomposed DSpark cycles with a fixed draft length `k` (k = 0: plain steps). GPU timestamps of every kernel
/// (draft / verify / commit+ingest segments) plus host wall time per segment. Returns the report as text.
pub fn profile_cycles(e: &mut Engine, prompt: &[i32], cycles: usize, k: usize) -> Result<String, String> {
    let mut bonus = e.prefill_drafting(prompt)?;
    // warm-up cycles (JIT, caches)
    for _ in 0..3 {
        let mut ids = vec![bonus];
        if k > 0 {
            ids.extend_from_slice(&e.draft(bonus)?[..k]);
        }
        let am = e.verify(&ids)?;
        let mut acc = 0;
        while acc + 1 < ids.len() && am[acc] == ids[acc + 1] { acc += 1; }
        e.commit(1 + acc)?;
        e.ingest(1 + acc)?;
        bonus = am[acc];
    }
    e.prof_rec(true);
    let (mut w_draft, mut w_verify, mut w_commit) = (0f64, 0f64, 0f64);
    let mut accepted = 0usize;
    let mut hist = [0usize; 9];
    let wall0 = std::time::Instant::now();
    for _ in 0..cycles {
        let mut ids = vec![bonus];
        if k > 0 {
            e.prof_tag(1);
            let t = std::time::Instant::now();
            let d = e.draft(bonus)?;
            w_draft += t.elapsed().as_secs_f64();
            ids.extend_from_slice(&d[..k]);
        }
        e.prof_tag(2);
        let t = std::time::Instant::now();
        let am = e.verify(&ids)?;
        w_verify += t.elapsed().as_secs_f64();
        let mut acc = 0;
        while acc + 1 < ids.len() && am[acc] == ids[acc + 1] { acc += 1; }
        e.prof_tag(3);
        let t = std::time::Instant::now();
        e.commit(1 + acc)?;
        e.ingest(1 + acc)?;
        w_commit += t.elapsed().as_secs_f64();
        accepted += 1 + acc;
        hist[acc.min(8)] += 1;
        bonus = am[acc];
    }
    let wall = wall0.elapsed().as_secs_f64();
    let segs = e.prof_segments();
    e.prof_rec(false);
    let mut agg = [[0f64; 4]; 4]; // per tag: n, kernels, sum, span
    let mut gap = [0f64; 4]; // idle before this tag's segment (us)
    let mut gn = [0f64; 4];
    let mut prev_end = None::<f64>;
    for s in &segs {
        let t = s[0] as usize;
        if t >= 4 || s[1] == 0.0 { continue; }
        agg[t][0] += 1.0;
        agg[t][1] += s[1];
        agg[t][2] += s[2];
        agg[t][3] += s[3];
        if let Some(pe) = prev_end {
            gap[t] += (s[4] - pe).max(0.0);
            gn[t] += 1.0;
        }
        prev_end = Some(s[5]);
    }
    let first = segs.iter().filter(|s| s[1] > 0.0).map(|s| s[4]).fold(1e30, f64::min);
    let last = segs.iter().filter(|s| s[1] > 0.0).map(|s| s[5]).fold(0.0, f64::max);
    let c = cycles as f64;
    let mut r = String::new();
    r += &format!("k={k}  cycles={cycles}  committed tokens/cycle {:.2}  hist(acc) {:?}\n", accepted as f64 / c, hist);
    r += "segment        kernels  sum-kernel(ms)  GPU-span(ms)  host-wall(ms)  idle-before(ms)\n";
    for (t, name, w) in [(1usize, "draft", w_draft), (2, "verify", w_verify), (3, "commit+ingest", w_commit)] {
        if agg[t][0] == 0.0 { continue; }
        r += &format!("{:<14}{:9.0}{:16.2}{:14.2}{:15.2}{:17.2}\n", name, agg[t][1] / agg[t][0], agg[t][2] / agg[t][0] / 1e3, agg[t][3] / agg[t][0] / 1e3, w / c * 1e3, if gn[t] > 0.0 { gap[t] / gn[t] / 1e3 } else { 0.0 });
    }
    let gpu_total = (last - first) / 1e3 / c;
    let sumk: f64 = (1..=3).map(|t| agg[t][2]).sum::<f64>() / 1e3 / c;
    r += &format!("per cycle: GPU wall {:.2} ms (kernels {:.2} ms, idle {:.2} ms), host wall {:.2} ms\n", gpu_total, sumk, gpu_total - sumk, wall / c * 1e3);
    r += &format!("effective: {:.1} tok/s (host wall), {:.1} tok/s (GPU timeline)\n", accepted as f64 / wall, accepted as f64 / (gpu_total * c / 1e3));
    Ok(r)
}
