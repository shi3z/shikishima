#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set +u; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1 || true; set -u
icpx -fsycl -O2 -std=c++20 -Wno-deprecated-declarations "$here/xmxbench.cpp" -o "${1:-/data/inkling/xmxbench}"
echo built
