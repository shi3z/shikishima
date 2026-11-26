#!/usr/bin/env python3
"""Expert-selection correlation of recorded T=1 routing (XIK_ROUTE_REC dump): consecutive tokens, re-visits of the looped layers, frequency skew,
and the upper bound of bytes an L2-resident expert set could save.  usage: route_corr.py route.bin"""
import sys, numpy as np
raw = open(sys.argv[1], 'rb').read()
n = int(np.frombuffer(raw[:8], np.uint64)[0]); ids = np.frombuffer(raw[8:8 + n * 32], np.int32).reshape(n, 8)
V = 48; nst = n // V; ids = ids[:nst * V].reshape(nst, V, 8)
layer = np.array(list(range(6)) + [l for p in range(3) for l in range(6, 18)] + list(range(18, 24)))
passno = np.array([0] * 6 + [p for p in range(3) for l in range(6, 18)] + [0] * 6)
E = 128
onehot = np.zeros((nst, V, E), bool)
for k in range(8): np.put_along_axis(onehot, ids[:, :, k:k + 1], True, axis=2)
print(f"steps {nst}, visits/step {V}")
# consecutive tokens, same visit
ov = (onehot[1:] & onehot[:-1]).sum(-1) / 8.0
print(f"consecutive-token overlap (fraction of the 8 experts also used by the previous token at the same visit): mean {ov.mean():.3f}  (random {8/128:.3f})")
print("  per visit:", ' '.join(f'{x:.2f}' for x in ov.mean(0)))
# re-visit: pass 0 vs 1 vs 2 of the same token, same physical layer
for a, b in [(0, 1), (1, 2), (0, 2)]:
    va = [v for v in range(V) if passno[v] == a and 6 <= layer[v] < 18]; vb = [v for v in range(V) if passno[v] == b and 6 <= layer[v] < 18]
    o = (onehot[:, va] & onehot[:, vb]).sum(-1) / 8.0
    print(f"re-visit overlap pass {a} -> {b} (same token, same layer): mean {o.mean():.3f}")
# frequency skew per physical layer (all visits of the layer pooled)
cover = []
for l in range(24):
    vs = [v for v in range(V) if layer[v] == l]
    f = onehot[:, vs].sum((0, 1)).astype(float); f /= f.sum()
    fs = np.sort(f)[::-1]; cover.append((fs[:4].sum(), fs[:8].sum(), fs[:16].sum()))
c = np.array(cover)
print("per-layer share of expert uses covered by the hottest 4 / 8 / 16 experts (mean over layers): %.3f / %.3f / %.3f  (uniform: %.3f / %.3f / %.3f)" % (*c.mean(0), 4/128, 8/128, 16/128))
# static L2 pinning bound: bytes per expert use ~3.24 MB (planar INT3 w13 + w2), budget B MB, choose (layer, expert) pairs by use count
uses = {}
for v in range(V):
    l = layer[v]; cnt = onehot[:, v].sum(0)
    for e in range(E): uses[(l, e)] = uses.get((l, e), 0) + int(cnt[e])
tot = sum(uses.values()); srt = sorted(uses.values(), reverse=True)
for mb in (6.5, 13, 16):
    k = int(mb // 3.24); print(f"static pinning of the {k} most used (layer, expert) pairs ({k * 3.24:.1f} MB of L2): {sum(srt[:k]) / tot * 100:.2f} % of expert bytes per step")
# dynamic: experts used by the previous token at the same visit kept (oracle LRU of one token) -> bytes saved share = consecutive overlap, but needs 48 x 8 x 3.24 MB resident
print(f"keeping the previous token's experts would need {48 * 8 * 3.24 / 1024:.2f} GB resident (L2 is ~18 MB); re-visit reuse needs the 8 experts of a layer kept across 12 visits: {8 * 3.24:.0f} MB per layer")
