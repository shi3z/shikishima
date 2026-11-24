#!/bin/bash
# dispatch-path experiments (T=1 step wall, ctx 512, interleaved): SYCL graph, L0 command-list modes, batch sizes
while ! grep -q ABLKDONE /data/inkling/ablk.log 2>/dev/null; do sleep 20; done
cd /data/inkling
B=/data/inkling/target_exp7/release/xi-run; R=/data/inkling/runexp8.sh
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_TIMING=1
IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range(512)))")
declare -a CFG=("BASE=1" "XIK_GRAPH=1" "UR_L0_USE_IMMEDIATE_COMMANDLISTS=0" "UR_L0_USE_IMMEDIATE_COMMANDLISTS=1" "UR_L0_USE_IMMEDIATE_COMMANDLISTS=2" "UR_L0_BATCH_SIZE=16" "UR_L0_BATCH_SIZE=64")
for r in 1 2 3 4 5; do for cfg in "${CFG[@]}"; do
  echo "disp rep=$r cfg=[$cfg] $(env $cfg $R $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
done; done
echo DISPDONE
