#!/bin/bash
cd /data/inkling
B=/data/inkling/target_exp3/release/xi-run
export XIK_DENSE_FP8=1 XIK_HEAD_FP8=1 XIK_PROFILE=1
export PATH=$PATH:/opt/intel/oneapi/vtune/latest/bin64; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1
read p k r < <(echo $(cat /proc/sys/kernel/yama/ptrace_scope /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/kptr_restrict))
restore() { sudo -n sysctl -w kernel.yama.ptrace_scope=$p kernel.perf_event_paranoid=$k kernel.kptr_restrict=$r >/dev/null 2>&1; }
trap restore EXIT
sudo -n sysctl -w kernel.yama.ptrace_scope=0 kernel.perf_event_paranoid=0 kernel.kptr_restrict=0 >/dev/null
for rep in 1 2 3; do
for cfg in "0 d" "64 d" "128 d" "192 d" "256 d" "0 a"; do
  set -- $cfg; w=$1; al=$2
  if [ $al = a ]; then export XIK_ALLOC=aligned; else unset XIK_ALLOC; fi
  XIK_WOFF=$w XIK_BENCH_PROF=1 XIK_BENCH_TLIST=1,8 XIK_BENCH_CFGS=1 XIK_BENCH_KINDS=0,1 XIK_BENCH_ITERS=1500 ./runexp3.sh $B /data/inkling/model x 1 --bench-moe 2>&1 | grep PROF | awk -v w=$w -v a=$al -v r=$rep '{print "woff="w" alloc="a" rep="r" "$2,$3,$5}' >> woff_prof.log
done; done
unset XIK_ALLOC
for w in 0 64 128 192 256; do
  R=/data/inkling/woffvt_$w; rm -rf $R; mkdir -p $R
  XIK_WOFF=$w XIK_BENCH_TLIST=1 XIK_BENCH_CFGS=1 XIK_BENCH_KINDS=0 XIK_BENCH_ITERS=3000 vtune -collect gpu-hotspots -r $R/vt -- ./runexp3.sh $B /data/inkling/model x 1 --bench-moe > $R/run.log 2>&1
  vtune -report hotspots -group-by computing-task -r $R/vt -format csv -csv-delimiter tab > $R/tasks.csv 2>/dev/null
  XIK_WOFF=$w XIK_BENCH_TLIST=1 XIK_BENCH_CFGS=1 XIK_BENCH_KINDS=0 XIK_BENCH_ITERS=3000 vtune -collect gpu-hotspots -knob characterization-mode=global-memory-accesses -r $R/vtm -- ./runexp3.sh $B /data/inkling/model x 1 --bench-moe > $R/runm.log 2>&1
  vtune -report hotspots -group-by computing-task -r $R/vtm -format csv -csv-delimiter tab > $R/tasksm.csv 2>/dev/null
done
echo WOFFDONE > woff.done
