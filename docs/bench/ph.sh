#!/bin/bash
cd /home/shi3z/shikishima/xeinkling
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1
for c in A B C D E; do
  unset XIK_DENSE_POL XIK_LSC_POL XIK_NO_FASTDIV
  case $c in
   A) export XIK_DENSE_POL=0 XIK_LSC_POL=0,0 XIK_NO_FASTDIV=1;;
   B) export XIK_DENSE_POL=0 XIK_NO_FASTDIV=1;;
   C) export XIK_LSC_POL=0,0 XIK_NO_FASTDIV=1;;
   D) export XIK_NO_FASTDIV=1;;
   E) ;;
  esac
  timeout 900 scripts/vtune_run.sh /data/inkling/ph$c 48 > /data/inkling/ph$c.log 2>&1
  timeout 900 scripts/vtune_run.sh /data/inkling/ph${c}m 48 -knob characterization-mode=global-memory-accesses > /data/inkling/ph${c}m.log 2>&1
done
echo PHDONE > /data/inkling/ph.done
