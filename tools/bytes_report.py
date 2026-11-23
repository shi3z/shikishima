#!/usr/bin/env python3
"""Exact weight bytes: resident per category, and read per generated token (T=1) from the 48-visit schedule.
Sizes come from the checkpoint header (shapes/dtypes) and the engine's repacked formats (same byte counts)."""
import json, struct, re, sys, collections
path = sys.argv[1] if len(sys.argv) > 1 else '/data/inkling/model/model-00001-of-00001.safetensors'
f = open(path, 'rb'); n = struct.unpack('<Q', f.read(8))[0]; h = json.loads(f.read(n)); h.pop('__metadata__', None)
DT = {'BF16': 2, 'F32': 4, 'F8_E4M3': 1, 'U8': 1, 'I8': 1}
def nbytes(m):
    e = 1
    for s in m['shape']: e *= s
    return e * DT[m['dtype']]
res = collections.OrderedDict()
def add(k, b): res[k] = res.get(k, 0) + b
for name, m in h.items():
    b = nbytes(m)
    if name.startswith('model.visual'): add('vision encoder (not loaded)', b); continue
    mm = re.match(r'model\.llm\.layers\.(\d+)\.(.*)', name)
    if name == 'model.llm.embed.weight': add('embedding table (BF16)', b)
    elif name == 'model.llm.unembed.weight': add('unembed / output head (BF16)', b)
    elif mm:
        l = int(mm.group(1)); r = mm.group(2)
        if r.startswith('mlp.experts'):
            add('experts MXFP8 (layers 20-23)' if l >= 20 else 'experts NVFP4 (layers 0-19)', b)
        elif r.startswith('attn.w') or r.startswith('attn.gate') or r.startswith('attn.attn_sink'): add('attention dense BF16 (q,k,v,r,gate,sink,o)', b)
        elif r.startswith('controllers'): add('loop controllers BF16 (rank 64)', b)
        elif r.startswith('mlp.gate'): add('router BF16/F32', b)
        else: add('small tensors (convs, norms, clips, rel-proj)', b)
    else: add('small tensors (convs, norms, clips, rel-proj)', b)
print("RESIDENT WEIGHT BYTES (checkpoint = engine; repack keeps the byte count, FP8 modes shrink dense/head)")
tot = 0
for k, v in res.items():
    print(f"  {k:48s} {v/2**30:8.3f} GiB"); tot += v if 'vision' not in k else 0
print(f"  {'TOTAL loaded by the engine':48s} {tot/2**30:8.3f} GiB   (+ drafter {635801416/2**30:.3f} GiB, fold tables 0.10 GiB)")

# ---- bytes READ per token, T=1 (8 experts)
D, I, V = 2304, 1152, 201024
visits = {l: 1 for l in range(24)}
for l in range(6, 18): visits[l] = 3
assert sum(visits.values()) == 48
glob = {5, 11, 17, 23}
attn = D*3072*2 + 2*D*1024*2 + D*384*2 + D*32*2 + D*3072*2 + 3072*D*2      # q,k,v,r,sink(pad 32),gate,o
dyn = 2 * (32 * D * 2)
router = 128 * D * 2
ctl = 4 * (64*2*D*2 + 2 * D*64*2)
fp4 = 8 * (2*I*D//2 + 2*I*(D//16) + D*I//2 + D*(I//16))
fp8 = 8 * (2*I*D + 2*I*(D//32) + D*I + D*(I//32))
rows = collections.OrderedDict()
def acc(k, per_visit, cnt): rows[k] = rows.get(k, 0) + per_visit * cnt
for l, c in visits.items():
    acc('attention dense BF16 (48 visits)', attn + (dyn if l in glob else 0), c)
    acc('router (48 visits)', router, c)
    acc('experts NVFP4, 8 per visit (44 visits)' if l < 20 else 'experts MXFP8, 8 per visit (4 visits)', fp4 if l < 20 else fp8, c)
acc('loop controllers (24 visits: passes 2,3)', ctl, 24)
acc('output head (1)', V * D * 2, 1)
tt = sum(rows.values())
print("\nBYTES READ PER GENERATED TOKEN (T=1, logical = every weight byte touched once per visit)")
for k, v in rows.items(): print(f"  {k:48s} {v/1e6:9.1f} MB  {100*v/tt:5.1f}%")
print(f"  {'TOTAL':48s} {tt/1e9:9.3f} GB")
for bw in (456, 333, 400):
    print(f"  memory floor at {bw} GB/s: {tt/bw/1e6:6.2f} ms/token = {bw*1e9/tt:5.1f} tok/s")
fp8d = tt - (rows['attention dense BF16 (48 visits)'] + rows['output head (1)']) * 0.5 - rows['router (48 visits)']*0 
print(f"  with FP8 dense+head (lossy mode): ~{(tt - 0.5*(rows['attention dense BF16 (48 visits)'] + rows['output head (1)']))/1e9:.2f} GB")
