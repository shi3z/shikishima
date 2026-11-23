#!/bin/bash
cd /data/inkling
B=/data/inkling/target_exp3/release/xi-run
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1
./runexp3.sh $B /data/inkling/model x 1 --layout > lay_default.log 2>&1
for w in 64 128 192 256; do XIK_WOFF=$w XIK_LAYOUT_LAYERS=0,21 ./runexp3.sh $B /data/inkling/model x 1 --layout > lay_woff$w.log 2>&1; done
XIK_ALLOC=aligned ./runexp3.sh $B /data/inkling/model x 1 --layout > lay_aligned.log 2>&1
XIK_WOFF=8 XIK_LAYOUT_LAYERS=0 ./runexp3.sh $B /data/inkling/model x 1 --layout > lay_woff8.log 2>&1
XIK_WOFF=5000 XIK_LAYOUT_LAYERS=0 ./runexp3.sh $B /data/inkling/model x 1 --layout > lay_woff5000.log 2>&1
echo LAYDONE > lay.done
