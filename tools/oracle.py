"""CPU oracle: reference.py with lazily dequantised experts. Dumps per-visit traces + logits."""
import json, os, sys, numpy as np, torch
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "ref"))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import reference as R
from safetensors import safe_open

E2M1 = torch.tensor([0, .5, 1, 1.5, 2, 3, 4, 6, -0., -.5, -1, -1.5, -2, -3, -4, -6], dtype=torch.float32)
E4M3 = torch.arange(256, dtype=torch.uint8).view(torch.float8_e4m3fn).to(torch.float32)


class LazyExperts:
    def __init__(self, f, pre, layer):
        self.f, self.pre, self.mx = f, pre, layer >= 20

    def get(self, name, e):
        return self.f.get_slice(self.pre + name)[e:e + 1]

    def __getitem__(self, key):  # (kind, e)
        kind, e = key
        w = self.get(f"{kind}_weight", e).view(torch.uint8)
        s = self.get(f"{kind}_weight_scale", e).view(torch.uint8)
        if self.mx:
            v = E4M3[w.long()]
            sc = torch.ldexp(torch.ones(s.shape), s.int() - 127)
            v = (v.view(1, w.shape[1], -1, 32) * sc[..., None]).view(1, w.shape[1], -1)
        else:
            amax = self.f.get_tensor(self.pre + f"{kind}_weight_amax")[e]
            den = self.f.get_tensor(self.pre + f"{kind}_weight_outer_scale_denominator")
            v = torch.empty(1, w.shape[1], w.shape[2] * 2)
            v[..., 0::2] = E2M1[(w & 15).long()]
            v[..., 1::2] = E2M1[(w >> 4).long()]
            v = (v.view(1, w.shape[1], -1, 16) * E4M3[s.long()][..., None]).view(1, w.shape[1], -1)
            v = v * (amax.float() / den.float())
        return v[0].to(torch.bfloat16)


class W13:
    def __init__(self, lz, kind): self.lz, self.kind = lz, kind
    def __getitem__(self, e): return self.lz[(self.kind, e)]


def load(model_dir):
    cfg = R.RefConfig.from_hf(json.load(open(os.path.join(model_dir, "config.json"))))
    f = safe_open(os.path.join(model_dir, "model-00001-of-00001.safetensors"), "pt")
    w = {}
    for n in f.keys():
        if not n.startswith("model.llm."): continue
        if ".mlp.experts." in n: continue
        w[n] = f.get_tensor(n)
    return cfg, f, w


class Oracle(R.Inkling2Reference):
    def __init__(self, cfg, f, w):
        super().__init__(cfg, w)
        for l in range(cfg.num_layers):
            pre = f"model.llm.layers.{l}.mlp.experts."
            lz = LazyExperts(f, pre, l)
            self.w[pre + "w13_weight"] = W13(lz, "w13")
            self.w[pre + "w2_weight"] = W13(lz, "w2")
        self.trace = []
        orig = self._layer
        def wrapped(*a, **k):
            r = orig(*a, **k)
            self.trace.append(r[0].clone())
            return r
        self._layer = wrapped


if __name__ == "__main__":
    model_dir = sys.argv[1]; ids = [int(x) for x in sys.argv[2].split(",")]; out = sys.argv[3]
    cfg, f, w = load(model_dir)
    o = Oracle(cfg, f, w)
    with torch.no_grad():
        lg = o.logits(torch.tensor(ids))
    np.savez(out, trace=torch.stack(o.trace).numpy(), logits=lg[-1].numpy(), ids=np.array(ids))
    print("top5", lg[-1].topk(5))
