import re,sys,glob
def load(W):
    a=glob.glob(f'/data/inkling/isa_attn/w{W}/dump/.text*asm')[0]
    return [l.rstrip() for l in open(a)]
def loops(L):
    lab={}
    for i,l in enumerate(L):
        m=re.match(r'(L\d+):',l)
        if m: lab[m.group(1)]=i
    out=[]
    for i,l in enumerate(L):
        m=re.search(r'jmpi\s+(L\d+)',l)
        if m and m.group(1) in lab and lab[m.group(1)]<i: out.append((lab[m.group(1)],i))
    return out
def isinstr(x): s=x.strip(); return s and not s.startswith('//') and not re.match(r'L\d+:',s)
if __name__=='__main__':
    for W in sys.argv[1:]:
        L=load(W); print('== W'+W)
        for a,b in loops(L):
            seg=L[a:b+1]
            ins=[x for x in seg if isinstr(x)]
            sends=[x for x in ins if ' send' in x]
            ld=[x for x in sends if 'load' in x]
            fm=[x for x in ins if re.search(r'\b(mad|mul|add|mac)\b',x) and ':f' in x]
            print(f"  loop {a+1}-{b+1}: instr {len(ins)} send {len(sends)} (global loads {sum('ugm' in x and 'load' in x for x in sends)}, slm loads {sum('slm' in x and 'load' in x for x in sends)}) fp mul/add/mad {len(fm)} sync {sum('sync' in x for x in ins)} jmpi {sum('jmpi' in x for x in ins)}")
