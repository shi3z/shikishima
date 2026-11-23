"""ctypes driver for libxik.so: safetensors loader + generation loop."""
import ctypes as C, json, mmap, os, struct, sys, time
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
LIB = os.path.join(HERE, "..", "build", "libxik.so")
VOCAB_U = 200058


def header(path):
    with open(path, "rb") as f:
        n = struct.unpack("<Q", f.read(8))[0]
        h = json.loads(f.read(n))
    h.pop("__metadata__", None)
    return h, 8 + n


class Engine:
    def __init__(self, model_dir, max_ctx=4096, max_tokens=64, verbose=True):
        self.lib = C.CDLL(LIB)
        L = self.lib
        L.xik_create.restype = C.c_void_p
        L.xik_create.argtypes = [C.c_int, C.c_int]
        L.xik_upload.argtypes = [C.c_void_p, C.c_char_p, C.c_int, C.c_void_p, C.c_size_t]
        L.xik_finalize.argtypes = [C.c_void_p]
        L.xik_forward.argtypes = [C.c_void_p, C.c_void_p, C.c_int, C.c_void_p, C.c_void_p]
        L.xik_reset.argtypes = [C.c_void_p]
        L.xik_trace.argtypes = [C.c_void_p, C.c_void_p]
        L.xik_prof_enable.argtypes = [C.c_void_p, C.c_int]
        L.xik_prof_get.argtypes = [C.c_void_p, C.c_void_p]
        L.xik_last_error.restype = C.c_char_p
        self.max_tokens = max_tokens
        self.ctx = L.xik_create(max_ctx, max_tokens)
        if not self.ctx:
            raise RuntimeError(L.xik_last_error().decode())
        t0 = time.time()
        path = os.path.join(model_dir, "model-00001-of-00001.safetensors")
        h, base = header(path)
        with open(path, "rb") as f:
            mm = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
        arr = np.frombuffer(mm, dtype=np.uint8)
        total = 0
        for name, m in h.items():
            if not name.startswith("model.llm."):
                continue
            a, b = m["data_offsets"]
            buf = arr[base + a: base + b]
            r = L.xik_upload(self.ctx, name.encode(), 2, buf.ctypes.data, b - a)
            if r:
                raise RuntimeError(L.xik_last_error().decode())
            total += b - a
        if L.xik_finalize(self.ctx):
            raise RuntimeError(L.xik_last_error().decode())
        if verbose:
            print(f"loaded {total/2**30:.2f} GiB in {time.time()-t0:.1f}s", file=sys.stderr)
        self._arr = arr
        self._mm = mm
        self.logits = np.zeros(VOCAB_U, np.float32)

    def reset(self):
        self.lib.xik_reset(self.ctx)

    def forward(self, ids, want_logits=True, want_argmax=False):
        ids = np.ascontiguousarray(ids, dtype=np.int32)
        T = len(ids)
        am = np.zeros(T, np.int32) if want_argmax else None
        r = self.lib.xik_forward(self.ctx, ids.ctypes.data, T,
                                 self.logits.ctypes.data if want_logits else None,
                                 am.ctypes.data if want_argmax else None)
        if r:
            raise RuntimeError(self.lib.xik_last_error().decode())
        return am

    def trace(self, buf):
        self.lib.xik_trace(self.ctx, buf.ctypes.data if buf is not None else None)

    def prefill(self, ids):
        """chunked prefill; returns logits of the last token"""
        for i in range(0, len(ids), self.max_tokens):
            self.forward(ids[i:i + self.max_tokens], want_logits=(i + self.max_tokens >= len(ids)))
        return self.logits

    def generate(self, ids, n, eos=None, stream_cb=None):
        self.reset()
        t0 = time.time()
        lg = self.prefill(list(ids))
        tp = time.time() - t0
        out = [int(lg.argmax())]
        t1 = time.time()
        for _ in range(n - 1):
            if eos is not None and out[-1] == eos:
                break
            self.forward([out[-1]])
            out.append(int(self.logits.argmax()))
            if stream_cb: stream_cb(out[-1])
        td = time.time() - t1
        return out, tp, td
