#!/usr/bin/env python3
"""GPU time and memory traffic per generated token, by category, from two VTune gpu-hotspots results of a plain decode run
(overview mode: time / XMX / GRF / spill;  global-memory-accesses mode: DRAM bandwidth / L3 miss / host traffic).
usage: time_table.py <overview tasks.csv> <memory tasks.csv> <decode steps>
Dense kernels are classified by their global work size (= work-groups x K-split): proj 8608/8672, wo 4608, head 201024,
controller gain/forget 13824, controller down 64, controller hidden 192.  Logical bytes: tools/bytes_report.py."""
import csv, re, sys, collections
BYTES = {'attention dense (q,k,v,r,gate,sink,o)': 2585.8, 'experts NVFP4': 1576.6, 'experts MXFP8': 262.8,
         'output head': 926.3, 'loop controllers': 113.2, 'router': 28.3}
def cat(name, gws):
    if name.startswith('dgemm'):
        if gws == 201024: return 'output head'
        if gws in (8608, 8672, 4608): return 'attention dense (q,k,v,r,gate,sink,o)'
        if gws in (13824, 192, 64): return 'loop controllers'
        return 'dgemm other'
    if name.startswith('moe_fp4g'): return 'experts NVFP4'
    if name.startswith(('moe_fp8g', 'expert_fp8')): return 'experts MXFP8'
    if name.startswith('gemv_bf16'): return 'router'
    if name.startswith(('k_blend', 'k_pairnorm')): return 'loop controllers'
    if name.startswith(('k_attn', 'k_kv', 'k_qr_clip')): return 'attention core (score/softmax/kv/conv-state)'
    if name.startswith(('k_wnorm', 'k_mix', 'k_embed', 'k_capture')): return 'norm / attention-residual mix'
    if name.startswith(('k_act', 'k_cvt_f16', 'k_moe_combine', 'k_group', 'k_router')): return 'MoE glue (route, group, act, combine, cvt)'
    if name.startswith('k_conv'): return 'short convs'
    return 'other'
def load(path):
    rows = list(csv.reader(open(path), delimiter='\t')); h = rows[0]; ix = {n: i for i, n in enumerate(h)}
    g = lambda r, c: float(r[ix[c]]) if c in ix and r[ix[c]] not in ('', '-') else 0.0
    out = []
    for r in rows[1:]:
        if len(r) < 30 or 'zeCommand' in r[0] or any(s in r[0] for s in ('d_fold', 'repack', 'quant', 'memset')): continue
        name = re.sub(r'\(anonymous namespace\)::', '', r[0]); name = re.sub(r'\(void, sycl.*|\(xik_ctx.*|\(void, queue.*|<.*', '', name)
        out.append((cat(name, int(g(r, 'Work Size:Global'))), g(r, 'Computing Task:Total Time'), int(g(r, 'Computing Task:Instance Count')), g, r))
    return out
A, B, N = load(sys.argv[1]), load(sys.argv[2]), int(sys.argv[3])
agg = collections.OrderedDict()
for c, t, n, g, r in A:
    a = agg.setdefault(c, dict(t=0, n=0, xmx=0, act=0, stall=0, spill=0, grf=0, occ=0))
    a['t'] += t; a['n'] += n
    for k, col in (('xmx', 'XVE Pipelines:XMX active(%)'), ('act', 'XVE Array:Active(%)'), ('stall', 'XVE Array:Stalled(%)'), ('occ', 'XVE Threads Occupancy(%)')): a[k] += g(r, col) * t
    a['spill'] = max(a['spill'], g(r, 'Computing Task:Spill Memory Size')); a['grf'] = max(a['grf'], g(r, 'Computing Task:General Register File Size'))
mem = collections.defaultdict(lambda: dict(t=0, rd=0, miss=0, host=0, sys=0))
for c, t, n, g, r in B:
    m = mem[c]; m['t'] += t
    m['rd'] += g(r, 'GPU Memory Bandwidth, GB/sec:Read') * t; m['miss'] += g(r, 'GPU L3:Miss Ratio(%)') * t
    m['host'] += g(r, 'Host to GPU Memory Bandwidth, GB/sec:Read') * t; m['sys'] += g(r, 'System Memory Bandwidth, GB/sec:Read') * t
T = sum(a['t'] for a in agg.values())
print(f"kernel time per token {T/N*1e3:.2f} ms, {sum(a['n'] for a in agg.values())/N:.0f} launches/token ({N} decode steps)\n")
hdr = f"{'category':46s}{'ms/tok':>7s}{'share':>7s}{'launch':>7s} | {'logical MB':>10s}{'eff GB/s':>9s}{'floor@456':>10s}{'excess':>7s} | {'ctr GB/s':>8s}{'L3miss':>7s} | {'XMX%':>5s}{'stall%':>7s}{'occ%':>5s}{'GRF':>5s}{'spill':>6s}"
print(hdr); print('-' * len(hdr)); tf = 0
for c, a in sorted(agg.items(), key=lambda x: -x[1]['t']):
    t = a['t']; ms = t / N * 1e3; lg = BYTES.get(c); m = mem.get(c)
    if lg: fl = lg / 456.0; tf += fl; s = f"{lg:10.0f}{lg/ms:9.0f}{fl:10.2f}{ms-fl:7.2f}"
    else: s = f"{'-':>10s}{'-':>9s}{'-':>10s}{ms:7.2f}"
    ctr = f"{m['rd']/m['t']:8.0f}{m['miss']/m['t']:7.1f}" if m and m['t'] > 0 else f"{'-':>8s}{'-':>7s}"
    print(f"{c:46s}{ms:7.2f}{100*t/T:6.1f}%{a['n']/N:7.0f} | {s} | {ctr} | {a['xmx']/t:5.1f}{a['stall']/t:7.1f}{a['occ']/t:5.0f}{a['grf']:5.0f}{a['spill']:6.0f}")
print(f"{'TOTAL':46s}{T/N*1e3:7.2f}{'':7s}{'':7s} | {sum(BYTES.values()):10.0f}{sum(BYTES.values())/(T/N*1e3):9.0f}{tf:10.2f}{T/N*1e3-tf:7.2f}")
tm = sum(m['t'] for m in mem.values())
print(f"\nhost->GPU read {sum(m['host'] for m in mem.values())/tm:.3f} GB/s, system-memory read {sum(m['sys'] for m in mem.values())/tm:.3f} GB/s during decode (no offload / migration if ~0)")
