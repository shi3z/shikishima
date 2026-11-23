# SPDX-License-Identifier: Apache-2.0
"""Dequantize Inkling 2 Mini expert weights (NVFP4 / MXFP8) to BF16.

Reads a `thinkingmachines/Inkling-2-Mini` checkout and writes a BF16 copy of
every expert tensor plus the untouched BF16 tensors, producing a checkpoint
loadable without the Inkling2 quant config (for the vLLM XPU port, AutoRound
requantization, or any runtime without NVFP4 kernels).

Decode schemes (verified against llama.cpp's conversion/inkling2.py and
vLLM's Inkling2 Hopper path):

NVFP4 (`compute_dtype: nvfp4`, layers 0-19 experts):
    value = e2m1(low/high nibbles, interleaved) * e4m3fn(block_scale)
            * (amax_expert / denominator)
    blocks of 16 elements along the input (K) dimension; block scales are
    fp8_e4m3fn bytes; `amax` is per expert, `outer_scale_denominator` is a
    single fp32 scalar per tensor.

MXFP8 (`compute_dtype: mxfp8`, layers 20-23 experts):
    value = e4m3fn(byte) * 2 ** (ue8m0_byte - 127)
    blocks of 32 elements along K; scales are ue8m0 power-of-two exponents.

Usage:
    python scripts/inkling2_dequant.py --model models/inkling-hf --out models/inkling-bf16
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import torch
from safetensors.torch import load_file, save_file

_e2m1_mag = torch.tensor([0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=torch.float32)
E2M1_VALUES = torch.where(
    (torch.arange(16) >> 3) == 1, -_e2m1_mag.repeat(2), _e2m1_mag.repeat(2)
)  # sign in bit 3
_E4M3 = torch.arange(256, dtype=torch.uint8).view(torch.float8_e4m3fn).to(torch.float32)


def dequant_nvfp4(
    packed: torch.Tensor, scale: torch.Tensor, amax: torch.Tensor, denominator: torch.Tensor
) -> torch.Tensor:
    """`packed` `[E, R, K/2]` uint8, `scale` `[E, R, K/16]` e4m3 bytes,
    `amax` `[E]`, `denominator` scalar -> fp32 `[E, R, K]`."""
    experts, rows, packed_k = packed.shape
    packed = packed.view(torch.uint8) if packed.dtype != torch.uint8 else packed
    values = torch.empty(experts, rows, packed_k * 2, dtype=torch.float32)
    values[:, :, 0::2] = E2M1_VALUES[(packed & 0x0F).long()]
    values[:, :, 1::2] = E2M1_VALUES[(packed >> 4).long()]
    block_scale = _E4M3[scale.view(torch.uint8).long()]
    values = values.view(experts, rows, -1, 16) * block_scale[:, :, :, None]
    values = values.view(experts, rows, -1)
    outer = amax.to(torch.float32).view(experts, 1, 1) / denominator.to(torch.float32)
    return values * outer


def dequant_mxfp8(packed: torch.Tensor, scale: torch.Tensor) -> torch.Tensor:
    """`packed` `[E, R, K]` e4m3 bytes, `scale` `[E, R, K/32]` ue8m0 -> fp32."""
    experts, rows, k = packed.shape
    values = _E4M3[packed.view(torch.uint8).long()]
    exponent = scale.view(torch.uint8).to(torch.int32) - 127
    block_scale = torch.ldexp(torch.ones_like(exponent, dtype=torch.float32), exponent)
    return (values.view(experts, rows, -1, 32) * block_scale[:, :, :, None]).view(
        experts, rows, k
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--dtype", choices=["bfloat16", "float16", "float32"], default="bfloat16")
    parser.add_argument("--max-shard-gb", type=float, default=8.0)
    parser.add_argument("--skip-visual", action="store_true", help="drop model.visual.* tensors")
    parser.add_argument("--skip-mtp", action="store_true", help="drop mtp tensors (kept by default)")
    args = parser.parse_args()

    qcfg = json.loads((args.model / "hf_quant_config.json").read_text())
    groups = qcfg["model"]["parameter_groups"]
    # Both the llm and mtp sections can carry quantized tensors.
    nvfp4: dict[str, tuple[str, str, str]] = {}
    mxfp8: set[str] = set()
    for section in ("model", "mtp"):
        for group in qcfg.get(section, {}).get("parameter_groups", []):
            compute = group["compute_dtype"]
            tensors = group.get("tensors", [])
            if compute == "nvfp4":
                for t in tensors:
                    base = t.removesuffix("_weight")
                    nvfp4[t] = (
                        f"{base}_weight_scale",
                        f"{base}_weight_amax",
                        f"{base}_weight_outer_scale_denominator",
                    )
            elif compute == "mxfp8":
                mxfp8.update(tensors)

    index_path = args.model / "model.safetensors.index.json"
    weight_map: dict[str, str] = {}
    if index_path.exists():
        weight_map = json.loads(index_path.read_text())["weight_map"]
    shards = sorted(set(weight_map.values())) or ["model.safetensors"]

    args.out.mkdir(parents=True, exist_ok=True)
    out_total = 0
    out_shard_bytes = 0
    out_current: dict[str, torch.Tensor] = {}
    out_files: list[str] = []

    def flush() -> None:
        nonlocal out_shard_bytes
        if not out_current:
            return
        name = f"model-{len(out_files):05d}.safetensors"
        save_file(out_current, args.out / name, metadata={"format": "pt"})
        out_files.append(name)
        for key in out_current:
            weight_map_out[key] = name  # type: ignore[name-defined]
        out_current.clear()
        out_shard_bytes = 0

    weight_map_out: dict[str, str] = {}
    consumed: set[str] = set()
    for base, (s, a, d) in nvfp4.items():
        consumed.update((s, a, d))
    for t in mxfp8:
        consumed.add(f"{t.removesuffix('_weight')}_weight_scale")

    for shard in shards:
        loaded = load_file(args.model / shard)
        for name in sorted(loaded):
            if name in consumed:
                continue
            if args.skip_visual and name.startswith("model.visual."):
                continue
            if args.skip_mtp and not name.startswith("model."):
                continue
            tensor = loaded[name]
            if name in nvfp4:
                scale_name, amax_name, denom_name = nvfp4[name]
                values = dequant_nvfp4(
                    tensor.view(torch.uint8),
                    loaded[scale_name],
                    loaded[amax_name],
                    loaded[denom_name],
                )
                del loaded[scale_name], loaded[amax_name], loaded[denom_name]
                out_current[name] = values.to(getattr(torch, args.dtype))
                del values
            elif name in mxfp8:
                scale_name = f"{name.removesuffix('_weight')}_weight_scale"
                values = dequant_mxfp8(tensor, loaded[scale_name])
                del loaded[scale_name]
                out_current[name] = values.to(getattr(torch, args.dtype))
                del values
            else:
                out_current[name] = tensor
            nbytes = out_current[name].numel() * out_current[name].element_size()
            out_total += nbytes
            out_shard_bytes += nbytes
            if out_shard_bytes >= args.max_shard_gb * 2**30:
                flush()
        del loaded

    flush()
    for i, name in enumerate(out_files):
        final = f"model-{i:05d}-of-{len(out_files):05d}.safetensors"
        (args.out / name).rename(args.out / final)
        weight_map_out = {k: (final if v == name else v) for k, v in weight_map_out.items()}
    (args.out / "model.safetensors.index.json").write_text(
        json.dumps({"metadata": {"total_size": out_total}, "weight_map": weight_map_out})
    )
    print(f"wrote {len(out_files)} shards, {out_total / 2**30:.1f} GiB total -> {args.out}")


if __name__ == "__main__":
    main()