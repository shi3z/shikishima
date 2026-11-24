#!/bin/bash
while ! grep -q RINGDONE /data/inkling/ring.log; do sleep 20; done
cd /data/inkling
B=/data/inkling/target_exp_b/release/xi-run; R=/data/inkling/runexp5.sh
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1
IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range(512)))")
for cfg in "8 4" "0 4"; do set -- $cfg
  XIK_ATTN=$1 XIK_ATTN_UNR=$2 $R $B /data/inkling/model "$IDS" 64 --tf g /data/inkling/tf_$1_$2 >/dev/null 2>&1
  if cmp -s tf_$1_$2.logits tf_0_-1.logits && cmp -s tf_$1_$2.ids tf_0_-1.ids; then echo "parity VW=$1 UNR=$2 BITWISE-IDENTICAL"; else echo "parity VW=$1 UNR=$2 DIFFERENT"; fi; rm -f tf_$1_$2.logits
done
declare -a NAMES=(code history prose repeat edit_py jsonl)
declare -a PS=(
"Explain how a binary search tree works and write a Python implementation with insert and search functions."
"What are the main causes of the French Revolution?"
"Write a short story about a lighthouse keeper who discovers a message in a bottle."
"The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown"
$'Rewrite the following Python function exactly, changing only the name of the variable total to acc.\n\ndef summarize(items):\n    total = 0\n    for item in items:\n        total += item.price * item.qty\n    return total'
$'Here is a JSONL file:\n{"id": 1, "name": "alpha", "status": "pending"}\n{"id": 2, "name": "beta", "status": "pending"}\nSet every status to done.'
)
for i in "${!PS[@]}"; do for m in plain hybrid; do
  X=""; [ $m = hybrid ] && X="--hybrid"
  XIK_ATTN=0 $R $B /data/inkling/model "${PS[$i]}" 256 $X > /data/inkling/atdp_0_${m}_${NAMES[$i]}.out 2>/dev/null
  XIK_ATTN=8 XIK_ATTN_UNR=4 $R $B /data/inkling/model "${PS[$i]}" 256 $X > /data/inkling/atdp_1_${m}_${NAMES[$i]}.out 2>/dev/null
  cmp -s /data/inkling/atdp_0_${m}_${NAMES[$i]}.out /data/inkling/atdp_1_${m}_${NAMES[$i]}.out && S=IDENTICAL || S=DIFFERENT
  echo "parity ${NAMES[$i]} $m $S"
done; done
for r in 1 2 3 4 5; do for i in "${!PS[@]}"; do for f in 0 1; do for m in plain hybrid; do
  X=""; [ $m = hybrid ] && X="--hybrid"
  if [ $f = 0 ]; then E="XIK_ATTN=0"; else E="XIK_ATTN=8 XIK_ATTN_UNR=4"; fi
  echo "r$r ${NAMES[$i]} attn=$f $m: $(env $E $R $B /data/inkling/model "${PS[$i]}" 256 --bench 2 $X 2>&1 >/dev/null | grep -o 'median [0-9.]* min [0-9.]* max [0-9.]* tok/s (wall, prefill included) | decode-only median [0-9.]*' | sed 's/ min.*decode-only//')"
done; done; done; done
echo ATDDONE
