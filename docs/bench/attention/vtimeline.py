import re,sys,glob
def timeline(d, loop_pick=0):
    a=glob.glob(d+'/dump/.text*asm')[0]
    L=[l.rstrip() for l in open(a)]
    def isinstr(x): s=x.strip(); return s and not s.startswith('//') and not re.match(r'L\d+:',s)
    lab={}
    for i,l in enumerate(L):
        m=re.match(r'(L\d+):',l)
        if m: lab[m.group(1)]=i
    cands=[]
    for i,l in enumerate(L):
        m=re.search(r'jmpi\s+(L\d+)',l)
        if m and m.group(1) in lab and lab[m.group(1)]<i:
            seg=L[lab[m.group(1)]:i+1]
            if any('load.ugm.d32.a64' in x for x in seg): cands.append((lab[m.group(1)],i))
    cands.sort(key=lambda t:-(t[1]-t[0]))
    a_,b_=cands[loop_pick]
    seg=[x for x in L[a_:b_+1] if isinstr(x)]
    ev=[];pos=0
    gl_dst={}
    for k,x in enumerate(seg):
        t=re.sub(r'\s+',' ',x.strip())
        if ' send.ugm' in x and 'load' in x:
            m=re.search(r'send\.ugm \(\d+\|M0\)\s+r(\d+)',x); sb=re.search(r'\$(\d+)',x)
            ev.append((k,'GLD',f"dst r{m.group(1)} SBID ${sb.group(1) if sb else '-'}")); gl_dst[int(m.group(1))]=len([e for e in ev if e[1]=='GLD'])
        elif ' send.slm' in x and 'load' in x:
            m=re.search(r'load\.slm\.(\S+)',x); sb=re.search(r'\$(\d+)',x)
            ev.append((k,'SLM',f"{m.group(1)} SBID ${sb.group(1) if sb else '-'}"))
        elif t.startswith('sync') or ('sync' in t and 'nop' in t):
            if '.dst' in t: ev.append((k,'WAIT',re.sub(r'.*\{','{',t)))
        elif re.search(r'\bmul\b',t) and ':f' in t and 'acc0' in t:
            ev.append((k,'FMUL',re.sub(r'^\S*\s*','',t)[:70]))
        elif re.search(r'\badd\b',t) and ':f' in t and 'r14' in t:
            ev.append((k,'FADD',''))
        elif 'jmpi' in t: ev.append((k,'JMP',''))
    return len(seg),ev,(a_+1,b_+1)
if __name__=='__main__':
    d=sys.argv[1]; n,ev,(a,b)=timeline(d,int(sys.argv[2]) if len(sys.argv)>2 else 0)
    print(f"loop asm lines {a}-{b}, {n} instructions")
    for k,t,s in ev: print(f"  {k:4} {t:5} {s}")
