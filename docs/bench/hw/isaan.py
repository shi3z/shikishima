import re,sys,glob,os,collections
def an(path):
    L=open(path).read().split('\n')
    inflight={}   # sbid -> line of issue
    nsend=ndpas=nalu=0; loads=0; maxout=0
    out_at_dpas=[]; alu_between=[]; cur_alu=0; seen_dpas=False
    seq=[]  # compressed tags
    waits=0; allwr=0; spills=0
    for i,l in enumerate(L):
        m=re.match(r'^(\([^)]*\))?\s*(\w[\w.]*)',l.strip()) if l.strip() and not l.strip().startswith('//') and not l.strip().endswith(':') else None
        if not m: continue
        op=m.group(2); tok=re.findall(r'\$(\d+)(\.dst|\.src)?',l.split('//')[0])
        for t,kind in tok:
            if kind=='.dst' and t in inflight: del inflight[t]; waits+=1
        if 'sync.allwr' in l or op=='sync.allwr': allwr+=1; inflight.clear()
        if op.startswith('send'):
            nsend+=1
            isload='load' in l.split('//')[-1]
            if isload:
                loads+=1
                for t,kind in tok:
                    if kind=='': inflight[t]=i
            if '.ss' in l or 'scratch' in l: spills+=1
            seq.append('S' if isload else 's')
            maxout=max(maxout,len(inflight))
        elif op.startswith('dpas'):
            ndpas+=1; out_at_dpas.append(len(inflight)); alu_between.append(cur_alu); cur_alu=0; seq.append('D')
        elif op in ('sync.nop','nop','wait') or op.startswith('sync') or op.startswith('jmpi') or op.startswith('goto') or op.startswith('join') or op.startswith('call') or op.startswith('ret') or op.startswith('brc') or op.startswith('brd'):
            seq.append('c')
        else:
            nalu+=1; cur_alu+=1; seq.append('a')
    return dict(lines=len(L),send=nsend,loads=loads,dpas=ndpas,alu=nalu,maxout=maxout,
        avg_out_at_dpas=(sum(out_at_dpas)/len(out_at_dpas) if out_at_dpas else 0),
        alu_between=(sum(alu_between[1:])/max(1,len(alu_between)-1)),allwr=allwr,spill=spills,seq=''.join(seq))
if __name__=='__main__':
    d=sys.argv[1]
    for pat in sys.argv[2:]:
        for f in sorted(glob.glob(d+'/.text*'+pat+'*asm')):
            r=an(f); nm=os.path.basename(f)[:90]
            print(nm); print({k:(round(v,1) if isinstance(v,float) else v) for k,v in r.items() if k!='seq'})
            s=r['seq']
            # compress
            c=re.sub(r'(.)\1+',lambda m:m.group(1)+str(len(m.group(0))),s)
            print(c[:900]); print()
