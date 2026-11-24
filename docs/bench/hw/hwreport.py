import sys; sys.path.insert(0,'/data/inkling')
from hwan import *
def A(cfg,T,mode):
    r=agg(f'/data/inkling/hw/{cfg}_T{T}_{mode}/tasks.csv',[])
    return r
def g(h,ix,r,c): return f(r[ix[c]]) if c in ix else None
out=[]
P=out.append
P("## 1. Whole inference (kernel-time weighted mean over all decode/verify kernels of one forward pass; weight upload / one-time packing kernels excluded)\n")
P("| cfg | T | kernel time/pass ms | XVE Active % | Stalled % | Idle % | thread occupancy % | ALU0 active % | ALU1 active % | XMX active % | ALU0&XMX both % | multi-pipe % | stall SBID % | stall Send % | stall Pipe % | DRAM read GB/s | DRAM write GB/s | L3 miss % | LSC miss % |")
P("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
for cfg in ['K0','K1','K3']:
    for T in [1,8,16]:
        ho,io,ko=A(cfg,T,'overview'); hm,im,km=A(cfg,T,'global-memory-accesses')
        tot=sum(k[2] for k in ko)/13
        w=lambda c:wmean(ho,io,ko,c)
        wm=lambda c:wmean(hm,im,km,c)
        P(f"| {cfg} | {T} | {tot:.2f} | {w('XVE Array:Active(%)'):.1f} | {w('XVE Array:Stalled(%)'):.1f} | {w('XVE Array:Idle(%)'):.1f} | {w('XVE Threads Occupancy(%)'):.1f} | {w('XVE Pipelines:ALU0 active(%)'):.1f} | {w('XVE Pipelines:ALU1 active(%)'):.1f} | {w('XVE Pipelines:XMX active(%)'):.1f} | {w('XVE Pipelines:ALU0 and XMX active(%)'):.1f} | {w('XVE Pipelines:Multiple pipes active(%)'):.1f} | {w('XVE Stall Reasons:SBID(%)'):.1f} | {w('XVE Stall Reasons:Send(%)'):.1f} | {w('XVE Stall Reasons:Pipe(%)'):.1f} | {w('GPU Memory Bandwidth, GB/sec:Read'):.0f} | {w('GPU Memory Bandwidth, GB/sec:Write'):.1f} | {w('GPU L3:Miss Ratio(%)'):.1f} | {wm('GPU Load Store Cache:Miss Ratio(%)'):.1f} |")
P("\n(Averages are over kernel durations only; the GPU idle time between kernels is not part of these percentages. DRAM bandwidth is the VTune average over each kernel; for kernels shorter than the sampling interval it is unreliable.)\n")
P("## 2. Instruction counts per pass (compute-extended mode; one pass = sum over kernels / 13 passes)\n")
P("| cfg | T | SEND | ALU0 | ALU1 | XMX (DPAS) | bit-manip | control | ext-math | XMX per SEND | ALU(0+1) per XMX |")
P("|---|---|---|---|---|---|---|---|---|---|---|")
for cfg in ['K0','K1','K3']:
    for T in [1,8,16]:
        h,ix,ks=A(cfg,T,'compute-extended')
        s=lambda c:sumcol(h,ix,ks,c)/13
        sd,a0,a1,xm=s('XVE Instructions:Send Instructions'),s('XVE Instructions:ALU0 Instructions'),s('XVE Instructions:ALU1 Instructions'),s('XVE Instructions:XMX instructions')
        P(f"| {cfg} | {T} | {sd/1e6:.1f} M | {a0/1e6:.1f} M | {a1/1e6:.1f} M | {xm/1e6:.2f} M | {s('XVE Instructions:Bit Manipulation Instructions')/1e6:.1f} M | {s('XVE Instructions:Control Instructions')/1e6:.1f} M | {s('XVE Instructions:Extended Math Instructions')/1e6:.1f} M | {xm/sd:.3f} | {(a0+a1)/xm:.0f} |")
P("\n## 3. Main kernels (time share of the pass; instance-averaged metrics)\n")
for cfg in ['K3','K1','K0']:
    for T in [1,8,16]:
        ho,io,ko=A(cfg,T,'overview'); hm,im,km=A(cfg,T,'global-memory-accesses'); hc,ic,kc=A(cfg,T,'compute-extended')
        tot=sum(k[2] for k in ko)
        mm={(k[0],k[1]):k for k in km}; cc={(k[0],k[1]):k for k in kc}
        P(f"\n### {cfg}, T = {T}\n")
        P("| kernel (global size) | share % | avg us | GRF | spill B | Active % | Stalled % | Idle % | occup % | ALU0 % | ALU1 % | XMX % | SBID % | Send % | DRAM rd GB/s | DRAM wr GB/s | L3 miss % | LSC miss % | XMX/SEND instr | ALU/XMX instr |")
        P("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
        for k in sorted(ko,key=lambda k:-k[2])[:12]:
            r=k[4]; m=mm.get((k[0],k[1])); c=cc.get((k[0],k[1]))
            gm=lambda col: (f"{g(hm,im,m[4],col):.0f}" if m else "n/a")
            xs="n/a"; ax="n/a"
            if c:
                sd=g(hc,ic,c[4],'XVE Instructions:Send Instructions'); xm=g(hc,ic,c[4],'XVE Instructions:XMX instructions'); a=g(hc,ic,c[4],'XVE Instructions:ALU0 Instructions')+g(hc,ic,c[4],'XVE Instructions:ALU1 Instructions')
                xs=f"{xm/sd:.2f}" if sd else "n/a"; ax=f"{a/xm:.0f}" if xm else "no XMX"
            P(f"| {k[0]} ({k[1]}) | {100*k[2]/tot:.1f} | {k[2]*1e3/k[3]:.1f} | {g(ho,io,r,'Computing Task:General Register File Size'):.0f} | {g(ho,io,r,'Computing Task:Spill Memory Size'):.0f} | {g(ho,io,r,'XVE Array:Active(%)'):.1f} | {g(ho,io,r,'XVE Array:Stalled(%)'):.1f} | {g(ho,io,r,'XVE Array:Idle(%)'):.1f} | {g(ho,io,r,'XVE Threads Occupancy(%)'):.1f} | {g(ho,io,r,'XVE Pipelines:ALU0 active(%)'):.1f} | {g(ho,io,r,'XVE Pipelines:ALU1 active(%)'):.1f} | {g(ho,io,r,'XVE Pipelines:XMX active(%)'):.2f} | {g(ho,io,r,'XVE Stall Reasons:SBID(%)'):.1f} | {g(ho,io,r,'XVE Stall Reasons:Send(%)'):.1f} | {g(ho,io,r,'GPU Memory Bandwidth, GB/sec:Read'):.0f} | {g(ho,io,r,'GPU Memory Bandwidth, GB/sec:Write'):.1f} | {g(ho,io,r,'GPU L3:Miss Ratio(%)'):.0f} | {gm('GPU Load Store Cache:Miss Ratio(%)')} | {xs} | {ax} |")
print("\n".join(out))
