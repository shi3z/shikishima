#!/bin/bash
cd /home/shi3z/shikishima/xeinkling
export PATH=$PATH:/opt/intel/oneapi/vtune/latest/bin64; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1
read p k r < <(echo $(cat /proc/sys/kernel/yama/ptrace_scope /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/kptr_restrict))
restore() { sudo -n sysctl -w kernel.yama.ptrace_scope=$p kernel.perf_event_paranoid=$k kernel.kptr_restrict=$r >/dev/null 2>&1; }
trap restore EXIT
sudo -n sysctl -w kernel.yama.ptrace_scope=0 kernel.perf_event_paranoid=0 kernel.kptr_restrict=0 >/dev/null
for kind in 0 1; do for T in 1 8; do for rot in 20 1; do
  R=/data/inkling/xm_k${kind}_T${T}_r${rot}; rm -rf $R; mkdir -p $R
  XIK_BENCH_TLIST=$T XIK_BENCH_CFGS=1 XIK_BENCH_KINDS=$kind XIK_BENCH_ITERS=3000 XIK_BENCH_ROT=$rot \
   vtune -collect gpu-hotspots -r $R/vt -- scripts/b60run ./target/release/xi-run /data/inkling/model x 1 --bench-moe > $R/run.log 2>&1
  vtune -report hotspots -group-by computing-task -r $R/vt -format csv -csv-delimiter tab > $R/tasks.csv 2>$R/rep.err
done; done; done
echo XMDONE > /data/inkling/xm.done
