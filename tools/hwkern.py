#!/usr/bin/env python3
"""Per-kernel VTune metrics of a T=1 decode run (hwt1.sh output dir): time/call, calls/step, XMX active, ALU0+XMX, SBID stall, Send stall, occupancy, spill,
DRAM read (VTune counter).  usage: hwkern.py DIR steps"""
import csv, sys, re
D = sys.argv[1]; steps = int(sys.argv[2]) if len(sys.argv) > 2 else 63
def load(m):
    rows = list(csv.reader(open(f'{D}/{m}/tasks.csv'), delimiter='\t'))
    h = rows[0]; ix = {c: i for i, c in enumerate(h)}
    out = {}
    for r in rows[1:]:
        try: inst = int(float(r[ix['Computing Task:Instance Count']]))
        except: continue
        if inst < steps * 0.9 or re.search('zeCommand|pack', r[0]): continue
        nm = re.sub(r'\(anonymous namespace\)::', '', r[0]); nm = re.sub(r'\(xik_ctx.*|\(void,.*', '', nm)[:34] + ' g' + r[1]
        out[nm] = (r, ix)
    return out
ov, ce = load('overview'), load('compute-extended')
def g(t, k, c):
    if k not in t: return float('nan')
    r, ix = t[k]
    try: return float(r[ix[c]])
    except: return float('nan')
keys = sorted(ov, key=lambda k: -g(ov, k, 'Computing Task:Total Time'))
print(f"{'kernel':40s} {'n/st':>5s} {'us/call':>8s} {'ms/st':>6s} {'XMX%':>5s} {'A0+X%':>5s} {'SBID%':>5s} {'Send%':>5s} {'Occ%':>5s} {'spill':>5s} {'DRAMrd':>7s}")
for k in keys[:22]:
    n = g(ov, k, 'Computing Task:Instance Count'); t = g(ov, k, 'Computing Task:Total Time')
    print(f"{k:40s} {n/steps:5.1f} {t/n*1e6:8.1f} {t/steps*1e3:6.3f} {g(ov,k,'XVE Pipelines:XMX active(%)'):5.1f} {g(ov,k,'XVE Pipelines:ALU0 and XMX active(%)'):5.1f} {g(ov,k,'XVE Stall Reasons:SBID(%)'):5.1f} {g(ov,k,'XVE Stall Reasons:Send(%)'):5.1f} {g(ov,k,'XVE Threads Occupancy(%)'):5.1f} {g(ov,k,'Computing Task:Spill Memory Size'):5.0f} {g(ov,k,'GPU Memory Bandwidth, GB/sec:Read'):7.0f}")
