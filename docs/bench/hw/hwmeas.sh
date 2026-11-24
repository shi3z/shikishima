#!/usr/bin/env bash
# VTune GPU counters for K0/K1/K3 x T=1,8,16 x 4 characterization modes (bench-prefill pass of T tokens, repeated)
export PATH=$PATH:/opt/intel/oneapi/vtune/latest/bin64; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1
read p k r < <(echo $(cat /proc/sys/kernel/yama/ptrace_scope /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/kptr_restrict))
restore() { sudo -n sysctl -w kernel.yama.ptrace_scope=$p kernel.perf_event_paranoid=$k kernel.kptr_restrict=$r >/dev/null 2>&1; }
trap restore EXIT
sudo -n sysctl -w kernel.yama.ptrace_scope=0 kernel.perf_event_paranoid=0 kernel.kptr_restrict=0 >/dev/null
cd /data/inkling
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_ACT_STATS_FILE=/data/inkling/act_stats.bin
A3="wq_du=0-23;wk_dv=0-23;wr_du=0-23;gate_attn=0-23;wv_dv=0-23;wo_ud=0-23"
A1="wq_du=0-23;wk_dv=0-23;wr_du=0-23;gate_attn=0-23"
for cfg in K3 K0 K1; do
  case $cfg in K0) AW="none=0"; W3=0; WL="";; K1) AW="$A1"; W3=1; WL="2,6-9,11,13-14";; K3) AW="$A3"; W3=1; WL="0-19";; esac
  for T in 1 8 16; do for mode in overview global-memory-accesses compute-extended; do
    D=hw/${cfg}_T${T}_$mode; [ -f $D/DONE ] && continue; rm -rf $D; mkdir -p $D
    XIK_AW4="$AW" XIK_W3=$W3 XIK_W3L="$WL" XIK_BENCH_TS=$T XIK_BENCH_REPS=${REPS:-12} \
      vtune -collect gpu-hotspots -knob characterization-mode=$mode -r $D/vt -- ./runexp37.sh /data/inkling/target_exp25/release/xi-run /data/inkling/model x 1 --bench-prefill > $D/run.log 2>&1
    vtune -report hotspots -group-by computing-task -r $D/vt -format csv -csv-delimiter tab > $D/tasks.csv 2>$D/report.err
    rm -rf $D/vt; [ -s $D/tasks.csv ] && echo done > $D/DONE
    echo "$cfg T=$T $mode $(wc -l < $D/tasks.csv)"
  done; done
done
echo HWDONE
