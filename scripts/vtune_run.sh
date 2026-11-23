#!/usr/bin/env bash
# VTune gpu-hotspots of xi-run (decode loop). usage: scripts/vtune_run.sh <out dir> [n_tokens] [extra vtune knobs]
cd "$(dirname "$0")/.."
R=$1; N=${2:-24}; shift 2 || true
export PATH=$PATH:/opt/intel/oneapi/vtune/latest/bin64; source /opt/intel/oneapi/setvars.sh >/dev/null 2>&1
mkdir -p $R
read p k r < <(echo $(cat /proc/sys/kernel/yama/ptrace_scope /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/kptr_restrict))
restore() { sudo -n sysctl -w kernel.yama.ptrace_scope=$p kernel.perf_event_paranoid=$k kernel.kptr_restrict=$r >/dev/null 2>&1; }
trap restore EXIT
sudo -n sysctl -w kernel.yama.ptrace_scope=0 kernel.perf_event_paranoid=0 kernel.kptr_restrict=0 >/dev/null
rm -rf $R/vt
vtune -collect gpu-hotspots "$@" -r $R/vt -- scripts/b60run ./target/release/xi-run /data/inkling/model ids:371,151451,149879,151194,149884 $N > $R/run.log 2>&1
vtune -report hotspots -group-by computing-task -r $R/vt -format csv -csv-delimiter tab > $R/tasks.csv 2>$R/report.err
echo done > $R/DONE
