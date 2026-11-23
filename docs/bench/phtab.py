import csv,re,sys,collections
sys.argv=['x']
exec(open('time_table_fp8.py').read().split("A, B, N =")[0])
N=48
def agg(path):
    rows=list(csv.reader(open(path),delimiter='\t'));h=rows[0];ix={n:i for i,n in enumerate(h)}
    g=lambda r,c: float(r[ix[c]]) if c in ix and r[ix[c]] not in('','-') else 0.0
    out=collections.defaultdict(lambda:collections.defaultdict(float))
    for r in rows[1:]:
        if len(r)<30 or 'zeCommand' in r[0] or any(s in r[0] for s in('d_fold','repack','quant','memset')):continue
        name=re.sub(r'\(anonymous namespace\)::','',r[0]);name=re.sub(r'\(void, sycl.*|\(xik_ctx.*|\(void, queue.*|<.*','',name)
        c=cat(name,int(g(r,'Work Size:Global')));t=g(r,'Computing Task:Total Time');a=out[c]
        a['t']+=t
        for k,col in(('dram','GPU Memory Bandwidth, GB/sec:Read'),('dramw','GPU Memory Bandwidth, GB/sec:Write'),('lsc','GPU Load Store Cache:Average Bandwidth, GB/s:Read'),('l3r','GPU L3:Average Bandwidth, GB/s:Read'),('l3w','GPU L3:Average Bandwidth, GB/s:Write')):
            a[k]+=g(r,col)*t   # GB/s*s = GB
        for k,col in(('lscmiss','GPU Load Store Cache:Miss Ratio(%)'),('l3miss','GPU L3:Miss Ratio(%)')): a[k]+=g(r,col)*t
    return out
cfg='ABCDE';D={c:agg(f'ph{c}m/tasks.csv') for c in cfg}
cats=['experts NVFP4','attention dense (q,k,v,r,gate,sink,o)','loop controllers','output head','experts MXFP8','attention core (score/softmax/kv/conv-state)']
print("per token (memory-mode run; MB/token = counter GB/s x time / 48)")
for c in cats:
    print('##',c)
    print(f"{'cfg':3}{'ms':>7}{'DRAM rd MB':>11}{'DRAM wr MB':>11}{'LSC rd MB':>10}{'L3 rd MB':>9}{'L3 wr MB':>9}{'LSC miss%':>10}{'L3 miss%':>9}")
    for k in cfg:
        a=D[k][c];t=a['t']
        print(f"{k:3}{t/N*1e3:7.2f}{a['dram']/N*1e3:11.1f}{a['dramw']/N*1e3:11.1f}{a['lsc']/N*1e3:10.1f}{a['l3r']/N*1e3:9.1f}{a['l3w']/N*1e3:9.1f}{a['lscmiss']/t:10.1f}{a['l3miss']/t:9.1f}")
print('## TOTAL')
for k in cfg:
    t=sum(a['t'] for a in D[k].values())
    print(k,f"{t/N*1e3:.2f} ms  DRAM rd {sum(a['dram'] for a in D[k].values())/N*1e3:.0f} MB  wr {sum(a['dramw'] for a in D[k].values())/N*1e3:.0f} MB  LSC rd {sum(a['lsc'] for a in D[k].values())/N*1e3:.0f}  L3 rd {sum(a['l3r'] for a in D[k].values())/N*1e3:.0f}")
