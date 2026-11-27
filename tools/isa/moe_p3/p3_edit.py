#!/usr/bin/env python3
"""Hand edit of the T = 1 planar expert kernel (moe_p3_isa) ISA: activation records loaded one tile ahead with two register sets.
Compiler code: each tile's two 128-B record loads (r11:2 at +0, r28:2 at +0x80, address r10 = AQ_base + t * 256) are issued at the start of the tile and
waited for by the first DPAS of that tile.  Edit:
  * before the loop:   records of tile 0  -> set A (r60:2, r62:2)
  * tile t (u = 0):    consume set A; load tile t + 1 -> set B (r64:2, r66:2)
  * tile t + 1 (u = 1): consume set B; load tile t + 2 -> set A
Input: SWSB-stripped text (swsb_strip.py); assemble with isa_patch -a (IGA regenerates the dependencies)."""
import re, sys
L = open(sys.argv[1]).read().split('\n')
def find(pat, start=0):
    for i in range(start, len(L)):
        if re.search(pat, L[i]): return i
    raise SystemExit('not found: ' + pat)
SEND0 = r'send\.ugm \(1\|M0\)\s+r11\s+r10\s+null:0\s+0x0\s+0x0220E580'
SEND1 = r'send\.ugm \(1\|M0\)\s+r28\s+r10\s+null:0\s+0x80000\s+0x0220E580'
loop = find(r'^L1424:')
u0a = find(SEND0); u0b = find(SEND1, u0a)
u1a = find(SEND0, u0b + 1); u1b = find(SEND1, u1a)
u1_label = max(i for i in range(u0b, u1a) if re.match(r'^L\d+:', L[i]))   # label opening the u = 1 block
end_u1 = find(r'^L4128:', u1b)
def rename(lo, hi, mp):
    for i in range(lo, hi):
        if i in (u0a, u0b, u1a, u1b): continue
        s = L[i]
        for a, b in mp.items(): s = re.sub(r'\b' + a + r'(?=[.:\s])', b, s)
        L[i] = s
A = {'r11': 'r60', 'r12': 'r61', 'r28': 'r62', 'r29': 'r63'}
B = {'r11': 'r64', 'r12': 'r65', 'r28': 'r66', 'r29': 'r67'}
rename(u0b + 1, u1_label, A)   # tile t consumers (u = 0 block up to the u = 1 block)
rename(u1b + 1, end_u1, B)     # tile t + 1 consumers
ind = '        '
L[u0a] = ind + 'add (1|M0)               r71.0<1>:q    r10.0<0;1,0>:q    256:w'
L[u0b] = ind + 'send.ugm (1|M0)          r64      r71  null:0  0x0            0x0220E580\n' + ind + 'send.ugm (1|M0)          r66      r71  null:0  0x80000            0x0220E580'
L[u1a] = ind + 'add (1|M0)               r72.0<1>:q    r10.0<0;1,0>:q    256:w'
L[u1b] = ind + 'send.ugm (1|M0)          r60      r72  null:0  0x0            0x0220E580\n' + ind + 'send.ugm (1|M0)          r62      r72  null:0  0x80000            0x0220E580'
pre = [ind + 'mov (1|M0)               r70.0<1>:q    r126.1<0;1,0>:q',
       ind + 'send.ugm (1|M0)          r60      r70  null:0  0x0            0x0220E580',
       ind + 'send.ugm (1|M0)          r62      r70  null:0  0x80000            0x0220E580']
L[loop:loop] = pre
open(sys.argv[2], 'w').write('\n'.join(L) + '\n')
print(f'loop L1424 at {loop}, u0 sends {u0a},{u0b}, u1 block label {u1_label}, u1 sends {u1a},{u1b}, end {end_u1}', file=sys.stderr)
