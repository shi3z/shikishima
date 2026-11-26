#!/usr/bin/env bash
# Rebuild the hand-edited zebin of w4z_r<1, 12> and run it inside the engine:
#   1. offline ISA of the current source:   scripts/isa.sh "w4z_r<1, 12>" /data/inkling/isa/w4z2   (ocloc output: /data/inkling/isa/w4z2/oc/k_bmg.bin)
#   2. splice the edited text:              isa_patch k_bmg.bin <kernel> edit2.asm edit2.bin   (SWSB as written, no -a)
#   3. run:                                 XIK_ISA_W4Z1=edit2.bin xi-run ...
# The edit: the 4th activation load of each 64-K group renamed r26 -> r110 and moved up behind the 3rd (SBID $0 free in between).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"; Z=${1:-/data/inkling/isa/w4z2/oc/k_bmg.bin}; OUT=${2:-/data/inkling/isa/w4z2/edit2.bin}
N=_ZTSZN12_GLOBAL__N_15w4z_rILi1ELi12EEEvP7xik_ctxRKNS_6W4ArgsEiiEUlN4sycl3_V17nd_itemILi1EEEE_
/data/inkling/isa/isa_patch "$Z" "$N" "$here/edit2.asm" "$OUT"
