#!/bin/bash
cd /home/shi3z/shikishima/xeinkling
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1
declare -a NAMES=(code history prose repeat edit_py jsonl)
declare -a PS=(
"Explain how a binary search tree works and write a Python implementation with insert and search functions."
"What are the main causes of the French Revolution?"
"Write a short story about a lighthouse keeper who discovers a message in a bottle."
"The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown"
$'Rewrite the following Python function exactly, changing only the name of the variable total to acc.\n\ndef summarize(items):\n    total = 0\n    for item in items:\n        total += item.price * item.qty\n    return total'
$'Here is a JSONL file:\n{"id": 1, "name": "alpha", "status": "pending"}\n{"id": 2, "name": "beta", "status": "pending"}\nSet every status to done.'
)
for r in 1 2 3; do
 for i in "${!PS[@]}"; do
  for f in 0 1; do
    if [ $f = 0 ]; then export XIK_DENSE_POL=0 XIK_LSC_POL=0,0 XIK_NO_FASTDIV=1; else unset XIK_DENSE_POL XIK_LSC_POL XIK_NO_FASTDIV; fi
    for m in plain hybrid; do
      X=""; [ $m = hybrid ] && X="--hybrid"
      echo "r$r ${NAMES[$i]} pol=$f $m: $(scripts/b60run ./target/release/xi-run /data/inkling/model "${PS[$i]}" 256 --bench 2 $X 2>&1 >/dev/null | grep -o 'median [0-9.]* min [0-9.]* max [0-9.]* tok/s (wall, prefill included) | decode-only median [0-9.]*' | sed 's/ min.*decode-only//')"
    done
  done
 done
done
echo CUMDONE
