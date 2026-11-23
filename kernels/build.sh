#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="${1:-$here/../build}"; mkdir -p "$out"
if ! command -v icpx >/dev/null 2>&1; then set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u; fi
icpx -fsycl -O2 -std=c++20 -fPIC -shared -ffp-contract=off -fno-fast-math -Wno-deprecated-declarations \
  "$here/xik.cpp" -o "$out/libxik.so"
echo "built $out/libxik.so"
