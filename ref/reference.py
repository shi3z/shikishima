# SPDX-License-Identifier: Apache-2.0
"""Pure-torch reference implementation of looped Inkling 2 (Inkling 2 Mini).

Semantics transcribed from the reference implementations:
- per-layer math: transformers `models/inkling2` (Inkling 2 Small, non-looped)
- loop / cross-pass message gating: llama.cpp `src/models/inkling2-loop.cpp`
  (transformers has no `inkling2_loop` support)

Self-contained (no vLLM imports) so it runs on CPU as the correctness oracle
for platform backends, and its ops can be lifted into the vLLM XPU backend.

Single-sequence, stateful: `prefill(ids)` then `decode(id)` steps. Caches:
per-slot KV (8 full-attention slots), per-slot conv states, SWA windows.

Block-residual bookkeeping (verified identical across HF, llama.cpp and
vLLM PR #69028): block k = the residual stream entering boundary layer
6k (= the stream value at the end of layer 6k-1). The current stream lives
outside the bank; at a boundary the pre-boundary stream joins the bank and
the post-attention conv output starts the new stream.
"""

from __future__ import annotations

import json
import math
from dataclasses import dataclass
from pathlib import Path

import torch
import torch.nn.functional as F
from safetensors import safe_open

LOOP_STREAMS = ("attn", "k", "v", "mlp")


@dataclass
class RefConfig:
    vocab_size: int
    unpadded_vocab_size: int
    hidden_size: int
    num_layers: int
    num_heads: int
    num_kv_heads: int
    head_dim: int
    swa_heads: int
    swa_kv_heads: int
    swa_head_dim: int
    d_rel: int
    rel_extent: int
    sliding_window: int
    sconv_kernel: int
    rms_eps: float
    local_layer_ids: set[int]
    log_scaling_n_floor: int
    log_scaling_alpha: float
    qk_clip: float
    rel_clip: float
    block_size: int
    gate_softcap: float
    up_softcap: float
    final_softcap: float
    n_experts: int
    top_k: int
    inter_size: int
    route_scale: float
    use_gate_bias: bool
    core_start: int
    core_end: int
    num_passes: int
    gate_rank: int

    @classmethod
    def from_hf(cls, cfg: dict) -> "RefConfig":
        t = cfg["text_config"]
        loop = t["loop_config"]
        return cls(
            vocab_size=t["vocab_size"],
            unpadded_vocab_size=t["unpadded_vocab_size"],
            hidden_size=t["hidden_size"],
            num_layers=t["num_hidden_layers"],
            num_heads=t["num_attention_heads"],
            num_kv_heads=t["num_key_value_heads"],
            head_dim=t["head_dim"],
            swa_heads=t["swa_num_attention_heads"],
            swa_kv_heads=t["swa_num_key_value_heads"],
            swa_head_dim=t["swa_head_dim"],
            d_rel=t["d_rel"],
            rel_extent=t["rel_extent"],
            sliding_window=t["sliding_window_size"],
            sconv_kernel=t["sconv_kernel_size"],
            rms_eps=t["rms_norm_eps"],
            local_layer_ids=set(t["local_layer_ids"]),
            log_scaling_n_floor=t["log_scaling_n_floor"],
            log_scaling_alpha=t["log_scaling_alpha"],
            qk_clip=t["qk_l2_clip_threshold"],
            rel_clip=t["rel_l2_clip_threshold"],
            block_size=t["n_layers_per_attn_res_block"],
            gate_softcap=t["mlp_gate_softcap"],
            up_softcap=t["mlp_up_softcap"],
            final_softcap=t["final_logit_softcapping"],
            n_experts=t["n_routed_experts"],
            top_k=t["num_experts_per_tok"],
            inter_size=t["intermediate_size"],
            route_scale=t["route_scale"],
            use_gate_bias=t["use_gate_bias"],
            core_start=loop["core_start"],
            core_end=loop["core_end"],
            num_passes=loop["num_passes"],
            gate_rank=loop["gate_rank"],
        )

    @property
    def n_slots(self) -> int:
        return self.num_layers + (self.num_passes - 1) * (self.core_end - self.core_start)

    @property
    def n_visits(self) -> int:
        return self.num_layers + (self.num_passes - 1) * (self.core_end - self.core_start)


def rms_norm(x: torch.Tensor, eps: float = 1e-6) -> torch.Tensor:
    return x.float() * torch.rsqrt(x.float().square().mean(-1, keepdim=True) + eps)


def weighted_rms_norm(x: torch.Tensor, weight: torch.Tensor, eps: float) -> torch.Tensor:
    return (rms_norm(x, eps) * weight.float()).to(torch.bfloat16)


def l2_clip(x: torch.Tensor, scale: torch.Tensor | None, threshold: float) -> torch.Tensor:
    x = x.float() if scale is None else x.float() * scale.float()
    norm = x.norm(dim=-1, keepdim=True)
    factor = (threshold / (norm + 1e-6)).clamp(max=1.0)
    return (x * factor).to(torch.bfloat16)


def softcap(x: torch.Tensor, cap: float) -> torch.Tensor:
    return torch.tanh(x / cap) * cap


def softcapped_swiglu(gate: torch.Tensor, up: torch.Tensor, gate_cap: float, up_cap: float) -> torch.Tensor:
    return softcap(gate.float(), gate_cap) * torch.sigmoid(gate.float()) * softcap(up.float(), up_cap)


def attn_res_mix(blocks: list[torch.Tensor], cur: torch.Tensor, query: torch.Tensor) -> torch.Tensor:
    """Block attention-residual mix (fp32).

    `blocks`: `[B, T, D]`-able list of fp32 bank states; `cur`: `[T, D]` fp32;
    `query`: `[n_q, D]` fp32, pre-scaled by D**-0.5. Returns `[n_q, T, D]`.
    """
    states = torch.stack([*blocks, cur], dim=0)
    states = rms_norm(states, 1e-6)
    scores = torch.einsum("q d, b t d -> b q t", query, states)
    scores = F.softmax(scores.float(), dim=0)
    mix = torch.einsum("b q t, b t d -> q t d", scores, states)
    return mix


def loop_blend(
    dest: torch.Tensor,
    message: torch.Tensor,
    down: torch.Tensor,
    gain: torch.Tensor,
    forget: torch.Tensor,
) -> torch.Tensor:
    """`(1 - tanh(f(h))) * dest + tanh(g(h)) * message`, h = W_down @ [rms(dest); rms(msg)].

    `dest`, `message`: `[T, D]` fp32; `down`: `[r, 2D]` bf16; `gain`, `forget`: `[D, r]` bf16.
    Returns fp32 `[T, D]` (the caller applies the output norm)."""
    pair = torch.stack((dest, message), dim=1)
    pair = rms_norm(pair, 1e-6).to(torch.bfloat16).flatten(1)
    hidden = pair @ down.t()
    g = torch.mm(hidden.float(), gain.t().float())
    f = torch.mm(hidden.float(), forget.t().float())
    return (1.0 - torch.tanh(f)) * dest + torch.tanh(g) * message


class ShortConv:
    """Depthwise causal short conv with persistent input state.

    Static: weight `[C, K]`; scale `(K+1)**-0.5`.
    Dynamic: `(static_w [C, K], weight_proj [H*K, D_in])`; per-token per-head
    taps added to the static ones; scale `(2K+1)**-0.5`.
    Output: `(conv(x) + x) / scale` in bf16.
    """

    def __init__(self, weight: torch.Tensor | None, dynamic: tuple[torch.Tensor, torch.Tensor] | None, kernel: int):
        self.weight = weight
        self.dynamic = dynamic
        self.kernel = kernel
        self.state: torch.Tensor | None = None  # [S, C] fp32 history (oldest first)

    def reset(self) -> None:
        self.state = None

    def __call__(self, x: torch.Tensor, dyn_input: torch.Tensor | None = None) -> torch.Tensor:
        k = self.kernel
        residual = x
        xf = x.float()
        if self.state is not None and self.state.shape[0] > 0:
            context = torch.cat([self.state, xf], dim=0)
        else:
            context = F.pad(xf.transpose(0, 1), (k - 1, 0)).transpose(0, 1)
        self.state = context[-(k - 1):].clone() if k > 1 else context[:, :0]
        if self.dynamic is None:
            w = self.weight.float()
            windows = context.unfold(0, k, 1).flip(-1)  # [T, C, K], lag 0 = current
            out = (windows * w).sum(-1)
            denom = math.sqrt(k + 1)
        else:
            static_w, weight_proj = self.dynamic
            heads = weight_proj.shape[0] // k
            ch = x.shape[1]
            ch_per_head = ch // heads
            dyn = (dyn_input.float() @ weight_proj.t().float()).view(-1, heads, k)
            static = static_w.float().t().reshape(heads, ch_per_head, k)
            weights = static[None] + dyn[:, :, None, :]
            windows = context.unfold(0, k, 1).flip(-1).view(-1, heads, ch_per_head, k)
            out = (windows * weights).sum(-1).reshape(-1, ch)
            denom = math.sqrt(2 * k + 1)
        return ((out + residual.float()) / denom).to(torch.bfloat16)


class RelLogits:
    def __init__(self, proj: torch.Tensor, extent: int):
        self.proj = proj.float()
        self.extent = extent

    def __call__(self, rel_states: torch.Tensor, q_pos: torch.Tensor, kv_pos: torch.Tensor) -> torch.Tensor:
        rel = torch.einsum("t h d, d e -> h t e", rel_states.float(), self.proj)
        dist = q_pos[:, None] - kv_pos[None, :]
        idx = dist.clamp(0, self.extent - 1)
        idx = idx[None].expand(rel.shape[0], -1, -1)
        bias = rel.gather(2, idx)
        return bias.masked_fill((dist < 0) | (dist >= self.extent), 0.0)


class Inkling2Reference:
    """Stateful single-sequence reference of looped Inkling 2."""

    def __init__(self, cfg: RefConfig, weights: dict[str, torch.Tensor], device="cpu"):
        self.cfg = cfg
        fp32_names = (
            "attn_res.attn_queries",
            "attn_res.mlp_queries",
            "attn_res.output_query",
            "middle_cycle_cross_pass_queries",
            "middle_cycle_cross_pass_kv_queries",
        )
        cast = {}
        for name, tensor in weights.items():
            if any(p in name for p in fp32_names) or name.endswith("mlp.gate.weight") or name.endswith("mlp.gate.bias"):
                cast[name] = tensor.to(device=device, dtype=torch.float32)
            else:
                cast[name] = tensor.to(device=device, dtype=torch.bfloat16)
        self.w = cast
        self.device = device
        c = cfg
        self.sconvs: dict[tuple[int, int], ShortConv] = {}
        for slot in range(c.n_slots):
            self._build_slot_sconvs(slot)
        self.kv: dict[int, tuple[torch.Tensor, torch.Tensor]] = {}
        self.seq_len = 0

    # ---- slot helpers --------------------------------------------------------

    def slot_layer(self, slot: int) -> int:
        c = self.cfg
        return slot if slot < c.num_layers else c.core_start + (slot - c.num_layers) % (c.core_end - c.core_start)

    def is_global(self, slot: int) -> bool:
        return self.slot_layer(slot) not in self.cfg.local_layer_ids

    def _build_slot_sconvs(self, slot: int) -> None:
        c = self.cfg
        layer = self.slot_layer(slot)
        pre = f"model.llm.layers.{layer}."
        if layer in c.local_layer_ids:
            # Conv1d layout [C, 1, K], tap 0 = oldest -> flip so tap index == lag
            self.sconvs[slot, 0] = ShortConv(self.w[pre + "attn.k_sconv.weight"].squeeze(1).flip(-1), None, c.sconv_kernel)
            self.sconvs[slot, 1] = ShortConv(self.w[pre + "attn.v_sconv.weight"].squeeze(1).flip(-1), None, c.sconv_kernel)
        else:
            # dynamic static_w is [K, C] (tap 0 = current token); ShortConv transposes
            self.sconvs[slot, 0] = ShortConv(
                None,
                (self.w[pre + "attn.k_sconv.static_w"], self.w[pre + "attn.k_sconv.weight_proj"]),
                c.sconv_kernel,
            )
            self.sconvs[slot, 1] = ShortConv(
                None,
                (self.w[pre + "attn.v_sconv.static_w"], self.w[pre + "attn.v_sconv.weight_proj"]),
                c.sconv_kernel,
            )
        self.sconvs[slot, 2] = ShortConv(self.w[pre + "attn_sconv.weight"].squeeze(1).flip(-1), None, c.sconv_kernel)
        self.sconvs[slot, 3] = ShortConv(self.w[pre + "mlp_sconv.weight"].squeeze(1).flip(-1), None, c.sconv_kernel)

    def reset(self) -> None:
        self.kv.clear()
        self.seq_len = 0
        for conv in self.sconvs.values():
            conv.reset()

    # ---- pieces ---------------------------------------------------------------

    def _tau(self, positions: torch.Tensor) -> torch.Tensor | None:
        c = self.cfg
        tau = 1.0 + c.log_scaling_alpha * torch.log(
            ((positions.float() + 1) / c.log_scaling_n_floor).clamp(min=1.0)
        )
        return None if bool((tau == 1.0).all()) else tau

    def _attention(self, slot: int, inputs: list[torch.Tensor], positions: torch.Tensor) -> torch.Tensor:
        c = self.cfg
        layer = self.slot_layer(slot)
        local = layer in c.local_layer_ids
        pre = f"model.llm.layers.{layer}.attn."
        n_heads = c.swa_heads if local else c.num_heads
        n_kv = c.swa_kv_heads if local else c.num_kv_heads
        hd = c.swa_head_dim if local else c.head_dim
        window = c.sliding_window if local else None
        extent = c.sliding_window if local else c.rel_extent
        groups = n_heads // n_kv

        q_in, k_in, v_in = inputs
        t = q_in.shape[0]
        q = (q_in.float() @ self.w[pre + "wq_du.weight"].t().float()).view(t, n_heads, hd)
        # conv input = the K/V projection; dynamic taps project the raw stream
        k_proj = (k_in.float() @ self.w[pre + "wk_dv.weight"].t().float()).to(torch.bfloat16)
        v_proj = (v_in.float() @ self.w[pre + "wv_dv.weight"].t().float()).to(torch.bfloat16)
        k_new = self.sconvs[slot, 0](k_proj, dyn_input=k_in if not local else None).view(t, n_kv, hd)
        v_new = self.sconvs[slot, 1](v_proj, dyn_input=v_in if not local else None).view(t, n_kv, hd)
        r = (q_in.float() @ self.w[pre + "wr_du.weight"].t().float()).view(t, n_heads, c.d_rel)

        # cache: full layers keep everything; local layers keep a window
        if self.is_global(slot):
            k_all, v_all = self.kv.get(slot, (None, None))
            k_all = k_new.float() if k_all is None else torch.cat([k_all, k_new.float()], 0)
            v_all = v_new.float() if v_all is None else torch.cat([v_all, v_new.float()], 0)
            self.kv[slot] = (k_all, v_all)
        else:
            k_all, v_all = self.kv.get(slot, (None, None))
            k_all = k_new.float() if k_all is None else torch.cat([k_all, k_new.float()], 0)
            v_all = v_new.float() if v_all is None else torch.cat([v_all, v_new.float()], 0)
            if k_all.shape[0] > c.sliding_window + t:
                k_all, v_all = k_all[-(c.sliding_window + t):], v_all[-(c.sliding_window + t):]
            self.kv[slot] = (k_all, v_all)

        past = k_all.shape[0] - t
        kv_pos = torch.arange(past, past + k_all.shape[0])
        q_pos = kv_pos[past:]

        q = l2_clip(q, self.w[pre + "q_l2_clip.scale"], c.qk_clip)
        k_clipped = l2_clip(k_all, None, c.qk_clip)
        v_normed = rms_norm(v_all, c.rms_eps)
        r = l2_clip(r, self.w[pre + "rel_l2_clip.scale"], c.rel_clip)

        bias = RelLogits(self.w[pre + "rel_logits_proj.proj"], extent)(r, q_pos, kv_pos)
        sink = q_in.float() @ self.w[pre + "attn_sink_proj.weight"].t().float()
        bias = bias - sink.t()[:, :, None]

        dist = q_pos[:, None] - kv_pos[None, :]
        mask = dist < 0
        if window is not None:
            mask = mask | (dist >= window)

        k_rep = k_clipped.transpose(0, 1).repeat_interleave(groups, dim=0).float()
        v_rep = v_normed.transpose(0, 1).repeat_interleave(groups, dim=0).float()
        scores = torch.einsum("t h d, h s d -> h t s", q.float(), k_rep) / math.sqrt(hd)
        scores = scores + bias + torch.zeros(1, t, k_all.shape[0]).masked_fill(mask, float("-inf"))
        scores = torch.cat([scores, torch.zeros_like(scores[:, :, :1])], dim=-1)
        probs = F.softmax(scores.float(), dim=-1)[..., :-1]
        out = torch.einsum("h t s, h s d -> t h d", probs, v_rep).reshape(t, n_heads * hd)

        gate = torch.sigmoid(q_in.float() @ self.w[pre + "gate_attn.weight"].t().float())
        out = out * gate
        return (out.to(torch.bfloat16) @ self.w[pre + "wo_ud.weight"].t()).to(torch.bfloat16)

    def _moe(self, slot: int, x: torch.Tensor) -> torch.Tensor:
        c = self.cfg
        layer = self.slot_layer(slot)
        pre = f"model.llm.layers.{layer}.mlp."
        flat = x.float().reshape(-1, c.hidden_size)
        scores = torch.sigmoid(flat @ self.w[pre + "gate.weight"].t().float())
        w13 = self.w[pre + "experts.w13_weight"]
        w2 = self.w[pre + "experts.w2_weight"]
        out = torch.zeros_like(flat)
        sel = scores + self.w[pre + "gate.bias"].float() if c.use_gate_bias else scores
        indices = torch.topk(sel, c.top_k, dim=-1).indices
        weights = scores.gather(1, indices)
        weights = weights / (weights.sum(-1, keepdim=True) + 1e-20) * c.route_scale
        for e in indices.unique().tolist():
            mask = indices == e
            tok, pos = mask.nonzero(as_tuple=True)
            gu = flat[tok] @ w13[e].float().t()
            # the checkpoint's fused rows are interleaved (gate_i, up_i)
            gate, up = gu[:, 0::2], gu[:, 1::2]
            act = softcapped_swiglu(gate, up, c.gate_softcap, c.up_softcap)
            y = act.to(torch.bfloat16) @ w2[e].t().to(torch.bfloat16)
            out.index_add_(0, tok, y.float() * weights[tok, pos, None])
        return out.to(torch.bfloat16)

    def _messages(self, layer: int, bank: list[torch.Tensor]) -> torch.Tensor:
        """Cross-pass messages for core layer `layer` from the previous pass's
        bank: attn_res mix with the layer's 4 message queries. `[4, T, D]`."""
        c = self.cfg
        core_idx = layer - c.core_start
        scale = c.hidden_size**-0.5
        q_attn = self.w["model.llm.middle_cycle_cross_pass_queries"][2 * core_idx].float() * scale
        q_mlp = self.w["model.llm.middle_cycle_cross_pass_queries"][2 * core_idx + 1].float() * scale
        q_k = self.w["model.llm.middle_cycle_cross_pass_kv_queries"][2 * core_idx].float() * scale
        q_v = self.w["model.llm.middle_cycle_cross_pass_kv_queries"][2 * core_idx + 1].float() * scale
        blocks, cur = bank[:-1], bank[-1]
        return torch.stack(
            [attn_res_mix(blocks, cur, q.view(1, -1))[0] for q in (q_attn, q_k, q_v, q_mlp)], 0
        )

    def _layer(
        self,
        slot: int,
        stream: torch.Tensor,
        blocks: list[torch.Tensor],
        positions: torch.Tensor,
        messages: torch.Tensor | None,
    ) -> tuple[torch.Tensor, list[torch.Tensor]]:
        """One (slot, pass) visit. Returns (new stream, new blocks)."""
        c = self.cfg
        layer = self.slot_layer(slot)
        local = layer in c.local_layer_ids
        pre = f"model.llm.layers.{layer}."
        boundary = layer % c.block_size == 0

        if layer > 0:
            query = self.w[f"model.llm.attn_res.attn_queries.{layer - 1}"].float() * c.hidden_size**-0.5
            n_q = 1 if local else 3
            mixed = attn_res_mix(blocks, stream, query.view(n_q, -1))
            attn_inputs = [mixed[j] for j in range(n_q)]
        else:
            attn_inputs = [stream] * 3

        if messages is not None:
            blended = []
            for j, ctrl in enumerate(LOOP_STREAMS[:3]):
                dest = attn_inputs[0] if local else attn_inputs[j]
                out = loop_blend(
                    dest,
                    messages[j],
                    self.w[f"{pre}controllers.{ctrl}.down_weight"],
                    self.w[f"{pre}controllers.{ctrl}.gain_weight"],
                    self.w[f"{pre}controllers.{ctrl}.forget_weight"],
                )
                if local:
                    out = weighted_rms_norm(out, self.w[pre + "attn_norm.weight"], c.rms_eps)
                else:
                    out = weighted_rms_norm(out, self.w[pre + f"{('q', 'k', 'v')[j]}_input_norm.weight"], c.rms_eps)
                blended.append(out)
            attn_inputs = blended
        else:
            if local:
                n = weighted_rms_norm(attn_inputs[0], self.w[pre + "attn_norm.weight"], c.rms_eps)
                attn_inputs = [n, n, n]
            else:
                attn_inputs = [
                    weighted_rms_norm(attn_inputs[j], self.w[pre + f"{s}_input_norm.weight"], c.rms_eps)
                    for j, s in enumerate(("q", "k", "v"))
                ]

        attn_out = self._attention(slot, attn_inputs, positions)
        attn_out = self.sconvs[slot, 2](attn_out)

        new_blocks = list(blocks)
        if boundary:
            new_blocks.append(stream)
            new_stream = attn_out.float()
        else:
            new_stream = stream + attn_out.float()

        mlp_query = self.w[f"model.llm.attn_res.mlp_queries.{layer}"].float() * c.hidden_size**-0.5
        mlp_in = attn_res_mix(new_blocks, new_stream, mlp_query.view(1, -1))[0]
        if messages is not None:
            mlp_in = loop_blend(
                mlp_in,
                messages[3],
                self.w[f"{pre}controllers.mlp.down_weight"],
                self.w[f"{pre}controllers.mlp.gain_weight"],
                self.w[f"{pre}controllers.mlp.forget_weight"],
            )
            mlp_in = weighted_rms_norm(mlp_in, self.w[pre + "mlp_norm.weight"], c.rms_eps)
        else:
            mlp_in = weighted_rms_norm(mlp_in, self.w[pre + "mlp_norm.weight"], c.rms_eps)

        moe_out = self.sconvs[slot, 3](self._moe(slot, mlp_in))
        return new_stream + moe_out.float(), new_blocks

    def _forward_hidden(self, ids: torch.Tensor) -> torch.Tensor:
        """Returns the post-final-norm hidden states for `ids` `[T]`."""
        c = self.cfg
        start = self.seq_len
        positions = torch.arange(start, start + ids.shape[0])
        self.seq_len += ids.shape[0]

        emb = self.w["model.llm.embed.weight"][ids].float()
        stream = rms_norm(emb, c.rms_eps) * self.w["model.llm.embed_norm.weight"].float()

        core = list(range(c.core_start, c.core_end))
        visits = [(i, 0) for i in range(c.core_start)]
        visits += [(i, p) for p in range(c.num_passes) for i in core]
        visits += [(i, 0) for i in range(c.core_end, c.num_layers)]

        blocks: list[torch.Tensor] = []
        prelude_blocks: list[torch.Tensor] = []
        prelude_stream: torch.Tensor | None = None
        bank: list[torch.Tensor] | None = None

        for i, p in visits:
            if i == c.core_start and p == 0:
                prelude_blocks = list(blocks)
                prelude_stream = stream.clone()
            elif i == c.core_start and p > 0:
                # bank = previous pass's blocks after the first core block + its output
                bank = [*blocks[len(prelude_blocks) + 1:], stream.clone()]
                blocks = list(prelude_blocks)
                stream = prelude_stream.clone()
            messages = self._messages(i, bank) if (p > 0 and bank is not None) else None
            slot = i if p == 0 else c.num_layers + (p - 1) * (c.core_end - c.core_start) + (i - c.core_start)
            stream, blocks = self._layer(slot, stream, blocks, positions, messages)

        # final output mix + norm
        out_query = self.w["model.llm.attn_res.output_query"].float() * c.hidden_size**-0.5
        hidden = attn_res_mix(blocks, stream, out_query.view(1, -1))[0]
        return weighted_rms_norm(hidden, self.w["model.llm.norm.weight"], c.rms_eps)

    def logits(self, ids: torch.Tensor) -> torch.Tensor:
        c = self.cfg
        hidden = self._forward_hidden(ids)
        logits = (hidden.to(torch.bfloat16) @ self.w["model.llm.unembed.weight"].t()).float()
        logits = softcap(logits, c.final_softcap)
        return logits[..., : c.unpadded_vocab_size]

    def prefill(self, ids: torch.Tensor) -> torch.Tensor:
        return self.logits(ids)

    def decode(self, token: int) -> torch.Tensor:
        return self.logits(torch.tensor([token]))

    def generate(self, ids: torch.Tensor, max_new: int, eos: int | None = None) -> torch.Tensor:
        out = [self.prefill(ids)[0, -1].argmax().item()]
        for _ in range(max_new - 1):
            if eos is not None and out[-1] == eos:
                break
            out.append(self.decode(out[-1])[0, -1].argmax().item())
        return torch.tensor(out)


def load_checkpoint(model_dir: str | Path, device="cpu") -> tuple[RefConfig, dict[str, torch.Tensor]]:
    """Load the BF16-dequantized checkpoint written by scripts/inkling2_dequant.py."""
    model_dir = Path(model_dir)
    cfg = RefConfig.from_hf(json.loads((model_dir / "config.json").read_text()))
    index = json.loads((model_dir / "model.safetensors.index.json").read_text())
    weight_map = index["weight_map"]
    shards = sorted(set(weight_map.values()))
    keep = [n for n in weight_map if n.startswith("model.llm.")]
    weights: dict[str, torch.Tensor] = {}
    for shard in shards:
        names = [n for n in keep if weight_map[n] == shard]
        if not names:
            continue
        with safe_open(model_dir / shard, framework="pt") as f:
            for n in names:
                weights[n] = f.get_tensor(n).to(device)
    return cfg, weights