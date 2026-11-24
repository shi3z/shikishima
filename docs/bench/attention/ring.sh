#!/bin/bash
while ! grep -q ISODONE /data/inkling/iso.log; do sleep 20; done
cd /data/inkling
B=/data/inkling/target_exp_b/release/xi-run
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_TIMING=1
# 1. bit-exact logits / token parity vs the original loop: 512-token prompt, 64 teacher-free steps, full logits written each step
IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range(512)))")
for cfg in "0 -1 0" "1 -1 0" "8 -1 0" "12 -1 0" "16 -1 0" "4 9 0" "6 9 0" "8 9 0" "12 9 0"; do set -- $cfg
  tag=$1_$2
  XIK_ATTN=$1 XIK_ATTN_UNR=$2 XIK_ATTN_ABL=$3 ./runexp5.sh $B /data/inkling/model "$IDS" 64 --tf g /data/inkling/tf_$tag > /dev/null 2>&1
  if cmp -s tf_$tag.logits tf_0_-1.logits && cmp -s tf_$tag.ids tf_0_-1.ids; then echo "parity VW=$1 UNR=$2 logits+ids BITWISE-IDENTICAL (64 steps, ctx 512..576)"; else echo "parity VW=$1 UNR=$2 DIFFERENT"; fi
  [ "$tag" != "0_-1" ] && rm -f tf_$tag.logits
done
# 2. timing: interleaved, 5 reps (ctx 256) / 3 reps (1024, 4000)
for N in 256 1024 4000; do
  REPS=5; [ $N != 256 ] && REPS=3
  IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range($N)))")
  for r in $(seq 1 $REPS); do for cfg in "0 -1 0" "8 -1 0" "12 -1 0" "16 -1 0" "4 9 0" "6 9 0" "8 9 0" "12 9 0"; do set -- $cfg
    echo "ring ctx=$N rep=$r cfg=$1,$2,$3 $(XIK_ATTN=$1 XIK_ATTN_UNR=$2 XIK_ATTN_ABL=$3 ./runexp5.sh $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
  done; done
done
echo RINGDONE
