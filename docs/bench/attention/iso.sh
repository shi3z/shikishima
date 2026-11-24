#!/bin/bash
# attention isolation: configs (VW,UNR,ABL) x context, interleaved repeats, T=1 step wall (bench-submit)
while ! grep -q ATTDONE /data/inkling/att.log; do sleep 20; done
cd /data/inkling
B=/data/inkling/target_exp_b/release/xi-run
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_TIMING=1
declare -a CFG=("0 -1 0" "0 4 0" "1 -1 0" "8 0 0" "8 4 0" "12 -1 0" "32 -1 0" "8 -1 0" "16 -1 0" "0 -1 1" "0 -1 2" "0 -1 3" "1 -1 1" "1 -1 2" "8 0 1" "8 0 2" "8 0 3")
run() { # ctx reps cfgs...
  N=$1; REPS=$2; shift 2
  IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range($N)))")
  for r in $(seq 1 $REPS); do for c in "$@"; do set -- $c
    echo "ctx=$N rep=$r cfg=$1,$2,$3 $(XIK_ATTN=$1 XIK_ATTN_UNR=$2 XIK_ATTN_ABL=$3 ./runexp3.sh $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
  done; done
}
# ctx 256: all configs x 5 reps
for r in 1 2 3 4 5; do for c in "${CFG[@]}"; do set -- $c
  IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range(256)))")
  echo "ctx=256 rep=$r cfg=$1,$2,$3 $(XIK_ATTN=$1 XIK_ATTN_UNR=$2 XIK_ATTN_ABL=$3 ./runexp3.sh $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
done; done
for N in 1024 4000; do for r in 1 2 3; do for c in "0 -1 0" "0 4 0" "1 -1 0" "8 -1 0" "8 4 0" "12 -1 0" "16 -1 0" "32 -1 0"; do set -- $c
  IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range($N)))")
  echo "ctx=$N rep=$r cfg=$1,$2,$3 $(XIK_ATTN=$1 XIK_ATTN_UNR=$2 XIK_ATTN_ABL=$3 ./runexp3.sh $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
done; done; done
echo ISODONE
