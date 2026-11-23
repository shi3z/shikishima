use std::{path::PathBuf, time::Instant};
use xeinkling::Engine;

fn main() {
    let a: Vec<String> = std::env::args().collect();
    if a.len() < 4 {
        eprintln!("usage: xi-run <model_dir> <prompt|ids:1,2,3> <n_new> [--max-ctx N]");
        std::process::exit(2);
    }
    let dir = PathBuf::from(&a[1]);
    let n: usize = a[3].parse().unwrap();
    let tok = tokenizers::Tokenizer::from_file(dir.join("tokenizer.json")).expect("tokenizer");
    let ids: Vec<i32> = if let Some(l) = a[2].strip_prefix("ids:") {
        l.split(',').map(|x| x.parse().unwrap()).collect()
    } else {
        tok.encode(a[2].as_str(), false).unwrap().get_ids().iter().map(|&x| x as i32).collect()
    };
    let t0 = Instant::now();
    let mut e = Engine::new(&dir, 4096, 64).expect("engine");
    eprintln!("load {:.1}s", t0.elapsed().as_secs_f64());
    e.reset();
    if let Some(i) = a.iter().position(|x| x == "--profile-cycles") {
        let k: usize = a[i + 1].parse().unwrap();
        let cyc: usize = a[i + 2].parse().unwrap();
        eprintln!("{}", xeinkling::spec::profile_cycles(&mut e, &ids, cyc, k).unwrap());
        return;
    }
    if a.iter().any(|x| x == "--bench-submit") {
        let c0 = e.prefill_drafting(&ids).unwrap();
        let mut cur = c0;
        for _ in 0..8 { cur = e.forward(&[cur], false, true).unwrap()[0]; }
        e.prof(false);
        let n = 60;
        let before = e.prof_us();
        let t = Instant::now();
        for _ in 0..n { cur = e.forward(&[cur], false, true).unwrap()[0]; }
        let wall = t.elapsed().as_secs_f64() * 1e3 / n as f64;
        let after = e.prof_us();
        eprintln!("T=1 step: wall {:.2} ms | host submit finished at {:.2} ms | complete at {:.2} ms (in-forward timers)", wall, (after[14] - before[14]) / n as f64 / 1e3, (after[15] - before[15]) / n as f64 / 1e3);
        return;
    }
    if a.iter().any(|x| x == "--bench-prefill") {
        // time per forward pass of T new tokens (plain forward, state reset between sizes)
        for t in [1usize, 2, 4, 8, 16, 32, 64] {
            let toks: Vec<i32> = (0..t as i32).map(|i| 1000 + i * 37).collect();
            e.reset();
            e.forward(&toks, false, true).unwrap(); // warm-up
            let mut v = vec![];
            for _ in 0..5 {
                e.reset();
                let t0 = Instant::now();
                e.forward(&toks, false, true).unwrap();
                v.push(t0.elapsed().as_secs_f64() * 1e3);
            }
            v.sort_by(|a, b| a.partial_cmp(b).unwrap());
            eprintln!("T={t:3}: {:7.1} ms per pass = {:6.2} ms/token = {:7.0} tok/s", v[2], v[2] / t as f64, t as f64 / v[2] * 1e3);
        }
        return;
    }
    if let Some(i) = a.iter().position(|x| x == "--loop-pass") {
        // repeat one T-token pass many times (for VTune): xi-run <dir> x 1 --loop-pass T N
        let t: usize = a[i + 1].parse().unwrap();
        let nn: usize = a[i + 2].parse().unwrap();
        let toks: Vec<i32> = (0..t as i32).map(|i| 1000 + i * 37).collect();
        for _ in 0..nn {
            e.reset();
            e.forward(&toks, false, true).unwrap();
        }
        return;
    }
    if a.iter().any(|x| x == "--bench-launch") {
        eprintln!("empty kernel      : {:.2} us/launch (back to back, in-order queue)", e.bench_launch(4000, 1));
        eprintln!("1-WG rmsnorm (T=1): {:.2} us/launch", e.bench_launch(4000, 0));
        return;
    }
    if a.iter().any(|x| x == "--bench-fp8") {
        // cold MXFP8 expert kernel (layers 20-23): T tokens x 8 experts
        for t in [1usize, 8] {
            for kind in 0..2 {
                let (us, by) = e.bench_moe(20, kind, 0, t as i32, 200).unwrap();
                eprintln!("T={t} {} : {:7.1} us  {:6.1} MB  = {:6.1} GB/s", if kind == 0 { "w13" } else { "w2 " }, us, by / 1e6, by / us / 1e3);
            }
        }
        return;
    }
    if a.iter().any(|x| x == "--bench-moe") {
        for t in [1, 8] {
            for kind in 0..2 {
                for cfg in 0..4 {
                    let mut v = vec![];
                    for layer in [0, 7, 13] {
                        let (us, by) = e.bench_moe(layer, kind, cfg, t, 200).unwrap();
                        v.push((us, by));
                    }
                    let us = v.iter().map(|x| x.0).sum::<f64>() / 3.0;
                    let by = v[0].1;
                    eprintln!("T={t} {} cfg{cfg}: {:7.1} us  {:6.1} MB  = {:6.1} GB/s", if kind == 0 { "w13" } else { "w2 " }, us, by / 1e6, by / us / 1e3);
                }
            }
        }
        return;
    }
    if a.iter().any(|x| x == "--mem") {
        let m = e.mem();
        let g = |x: u64| x as f64 / (1u64 << 30) as f64;
        eprintln!("weights(llm)     {:7.2} GiB", g(m[0]));
        eprintln!("drafter+fold     {:7.2} GiB", g(m[1]));
        eprintln!("target KV        {:7.2} GiB  (max_ctx 4096)", g(m[2]));
        eprintln!("drafter KV       {:7.2} GiB", g(m[3]));
        eprintln!("conv/saved state {:7.2} GiB", g(m[4]));
        eprintln!("all allocations  {:7.2} GiB  => workspace {:.2} GiB", g(m[5]), g(m[5].saturating_sub(m[0] + m[1] + m[2] + m[3] + m[4])));
        eprintln!("driver free {:.2} GiB of {:.2} GiB", g(m[6]), g(m[7]));
        return;
    }
    if let Some(i) = a.iter().position(|x| x == "--bench") {
        let reps: usize = a[i + 1].parse().unwrap();
        let spec = a.iter().any(|x| x == "--dspark" || x == "--hybrid");
        let hybrid = a.iter().any(|x| x == "--hybrid");
        let blk: usize = a.iter().position(|x| x == "--block").map(|i| a[i + 1].parse().unwrap()).unwrap_or(8);
        let mut v = vec![];
        let mut vd = vec![]; // decode-only
        let mut pf = vec![];
        for rep in 0..=reps {
            e.reset();
            let t1 = Instant::now();
            let (toks, tpre) = if hybrid {
                let (o, _st, hs) = xeinkling::spec::generate_hybrid(&mut e, &ids, n, blk, 31, true).unwrap();
                if rep == reps {
                    eprintln!("{}", hs.copy_diag.report("copy  "));
                    eprintln!("{}", hs.dspark_diag.report("dspark"));
                    eprintln!("plain: rounds {} | copy rounds {} | dspark rounds {}", hs.plain.rounds, hs.copy.rounds, hs.dspark.rounds);
                }
                (o.len(), hs.prefill_secs)
            } else if spec {
                (xeinkling::spec::generate_dspark(&mut e, &ids, n, blk).unwrap().0.len(), 0.0)
            } else {
                let tp = Instant::now();
                let mut cur = e.prefill(&ids).unwrap();
                let tpre = tp.elapsed().as_secs_f64();
                for _ in 1..n { cur = e.forward(&[cur], false, true).unwrap()[0]; if e.pending() > 128 { e.discard_pending(); } }
                (n, tpre)
            };
            let t = t1.elapsed().as_secs_f64();
            if rep > 0 { v.push(toks as f64 / t); vd.push(toks as f64 / (t - tpre).max(1e-6)); pf.push(tpre); } // first run = warm-up
        }
        v.sort_by(|a, b| a.partial_cmp(b).unwrap());
        vd.sort_by(|a, b| a.partial_cmp(b).unwrap());
        pf.sort_by(|a, b| a.partial_cmp(b).unwrap());
        eprintln!("{} {n} tok x{reps}: median {:.2} min {:.2} max {:.2} tok/s (wall, prefill included) | decode-only median {:.2} | prefill {} tok {:.0} ms", if hybrid { "hybrid" } else if spec { "dspark" } else { "plain" }, v[v.len() / 2], v[0], v[v.len() - 1], vd[vd.len() / 2], ids.len(), pf[pf.len() / 2] * 1e3);
        return;
    }
    if a.iter().any(|x| x == "--hybrid") {
        let t1 = Instant::now();
        let (out, st, hs) = xeinkling::spec::generate_hybrid(&mut e, &ids, n, 8, 31, true).unwrap();
        let t = t1.elapsed().as_secs_f64();
        println!("{}", tok.decode(&out.iter().map(|&x| x as u32).collect::<Vec<_>>(), false).unwrap());
        eprintln!("hybrid: {n} tok in {t:.2}s = {:.2} tok/s | {hs:?} accepted {}", n as f64 / t, st.accepted);
        return;
    }
    if a.iter().any(|x| x == "--dspark") {
        let blk: usize = a.iter().position(|x| x == "--block").map(|i| a[i + 1].parse().unwrap()).unwrap_or(8);
        let t1 = Instant::now();
        let (out, st) = xeinkling::spec::generate_dspark(&mut e, &ids, n, blk).unwrap();
        let t = t1.elapsed().as_secs_f64();
        println!("{}", tok.decode(&out.iter().map(|&x| x as u32).collect::<Vec<_>>(), false).unwrap());
        eprintln!("ids {:?}", &out[..out.len().min(16)]);
        eprintln!("dspark: {n} tok in {t:.2}s = {:.2} tok/s | accept {:.2}/cycle {st:?}", n as f64 / t, st.accepted as f64 / st.cycles.max(1) as f64);
        return;
    }
    if a.iter().any(|x| x == "--spec") {
        let mut d = xeinkling::spec::LookupDrafter { ngram: 3 };
        let t1 = Instant::now();
        let (out, st) = xeinkling::spec::generate(&mut e, &mut d, &ids, n, 8).unwrap();
        let t = t1.elapsed().as_secs_f64();
        println!("{}", tok.decode(&out.iter().map(|&x| x as u32).collect::<Vec<_>>(), false).unwrap());
        eprintln!("ids {:?}", &out[..out.len().min(16)]);
        eprintln!("spec: {n} tok in {t:.2}s = {:.2} tok/s | {st:?}", n as f64 / t);
        return;
    }
    if a.iter().any(|x| x == "--prof-verify") {
        let c0 = e.prefill_drafting(&ids).unwrap();
        let blk: Vec<i32> = std::iter::once(c0).chain(std::iter::repeat(c0).take(7)).collect();
        e.verify(&blk).unwrap();
        e.commit(1).unwrap();
        e.prof(true);
        let _ = e.verify(&blk).unwrap();
        let us = e.prof_us();
        let names = ["mix", "norm", "gemv_attn", "kv", "attn", "wo", "conv", "route", "w13", "w2", "loop", "head", "misc"];
        let tot: f64 = us.iter().sum();
        for (i, n) in names.iter().enumerate() { eprintln!("{:10} {:8.0} us", n, us[i]); }
        eprintln!("total {tot:.0} us (8-token verify, synchronised per phase)");
        return;
    }
    let t1 = Instant::now();
    let mut cur = e.prefill(&ids).unwrap();
    let tp = t1.elapsed().as_secs_f64();
    let mut out = vec![cur];
    let t2 = Instant::now();
    for _ in 1..n {
        cur = e.forward(&[cur], false, true).unwrap()[0];
        out.push(cur);
        if e.pending() > 128 { e.discard_pending(); }
    }
    let td = t2.elapsed().as_secs_f64();
    let text = tok.decode(&out.iter().map(|&x| x as u32).collect::<Vec<_>>(), false).unwrap();
    println!("{text}");
    eprintln!("ids {:?}", &out[..out.len().min(16)]);
    eprintln!("prefill {} tok {:.3}s | decode {:.2} tok/s", ids.len(), tp, (n - 1) as f64 / td);
}
