#!/bin/bash
while ! grep -q CARGO10DONE /data/inkling/cargo10.log 2>/dev/null; do sleep 15; done
cd /data/inkling
B=/data/inkling/target_exp10/release/xi-run; R=/data/inkling/runexp10.sh
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_TIMING=1
IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range(512)))")
# 1. record the real routing of the exact workload used below (prompt 512, 8 warm + 60 measured T=1 steps)
XIK_ROUTE_REC=1 XIK_ROUTE_DUMP=/data/inkling/route512.bin $R $B /data/inkling/model "$IDS" 8 --bench-submit > rec.log 2>&1
grep -E "routing|T=1 step" rec.log | cut -c1-120
# 2. ablations with the recorded routing replayed in every configuration; "real" = original router (reference)
for r in 1 2 3 4 5; do
  echo "rr rep=$r cfg=real $(XIK_ABL=0 $R $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
  for m in 0 1 2 4 8 16 32 64 127; do
    echo "rr rep=$r cfg=replay mask=$m $(XIK_ROUTE_REPLAY=/data/inkling/route512.bin XIK_ABL=$m $R $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
  done
done
echo RRDONE
