import csv,sys,re,os,collections
def load(path):
    rows=list(csv.reader(open(path),delimiter='\t'))
    if not rows: return None,[]
    return rows[0],rows[1:]
def nm(s):
    s=re.sub(r'\(anonymous namespace\)::','',s); s=re.sub(r'\(void,.*|\(xik_ctx.*|\(sycl.*','',s); return s[:48]
def f(x):
    try: return float(x)
    except: return 0.0
def agg(path, cols, minmax_inst=13):
    h,rows=load(path)
    if not h: return None
    ix={c:i for i,c in enumerate(h)}
    ks=[]
    for r in rows:
        name=nm(r[0]); inst=int(f(r[ix['Computing Task:Instance Count']]))
        if re.search(r'zeCommand|pack|repack|d_fold|k_quant_fp8.*1769472|k_w3pack',r[0]) or inst<minmax_inst or (r[0].startswith('(anonymous namespace)::k_quant_fp8') and int(f(r[ix['Work Size:Global']]))>=589824): continue
        t=f(r[ix['Computing Task:Total Time']])*1e3
        ks.append((name,r[ix['Work Size:Global']],t,inst,r))
    return h,ix,ks
def wmean(h,ix,ks,col):
    if col not in ix: return None
    tot=sum(k[2] for k in ks); 
    return sum(k[2]*f(k[4][ix[col]]) for k in ks)/tot if tot else 0
def sumcol(h,ix,ks,col):
    if col not in ix: return None
    return sum(f(k[4][ix[col]]) for k in ks)
