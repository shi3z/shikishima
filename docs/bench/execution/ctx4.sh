#!/bin/bash
# standard contexts 512 / 1024 / 4096 / 8192 (prompt 512, 1024, 4000, 8100 tokens so that +68 bench steps stay inside max_ctx 4096 / 8192)
while ! grep -q CARGO7DONE /data/inkling/cargo7.log 2>/dev/null; do sleep 20; done
while ! grep -q KBFDONE /data/inkling/kbf.log 2>/dev/null; do sleep 20; done
cd /data/inkling
B=/data/inkling/target_exp7/release/xi-run; R=/data/inkling/runexp7.sh
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_TIMING=1
N=8100
IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range($N)))")
for cfg in "XIK_ATTN=0 XIK_KBF16=0" "XIK_KBF16=0" "XIK_KBF16=1"; do
  tag=$(echo $cfg | tr ' =' '__')
  env $cfg XI_MAX_CTX=8192 $R $B /data/inkling/model "$IDS" 16 --tf g /data/inkling/tf8k_$tag >/dev/null 2>&1
done
for t in XIK_KBF16_0 XIK_KBF16_1; do
  if cmp -s tf8k_XIK_ATTN_0_XIK_KBF16_0.logits tf8k_$t.logits && cmp -s tf8k_XIK_ATTN_0_XIK_KBF16_0.ids tf8k_$t.ids; then echo "parity ctx8100 $t vs original attention: BITWISE-IDENTICAL (16 steps)"; else echo "parity ctx8100 $t vs original attention: DIFFERENT"; fi
done
rm -f tf8k_*.logits
for N in 512 1024 4000 8100; do
  MC=4096; [ $N = 8100 ] && MC=8192
  IDS=$(python3 -c "print('ids:'+','.join(str(1000+(i*37)%40000) for i in range($N)))")
  for r in 1 2 3 4 5; do for cfg in "XIK_ATTN=0 XIK_KBF16=0" "XIK_KBF16=0" "XIK_KBF16=1"; do
    echo "ctx4 ctx=$N rep=$r cfg=[$cfg] $(env $cfg XI_MAX_CTX=$MC $R $B /data/inkling/model "$IDS" 8 --bench-submit 2>&1 | grep -o 'wall [0-9.]* ms')"
  done; done
done
echo CTX4DONE
