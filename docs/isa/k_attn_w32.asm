L0:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                             
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud             
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw             
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x60:ud              {I@2}
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x0:ud              {I@1}
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1}
(W)     mov (8|M0)               r2.0<1>:ud    r1.0<1;1,0>:ud                  
(W)     send.ugm (1|M0)          r1       r127  null:0  0xFF000000            0x6219D500           {A@1,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src}
(W)     add (1|M0)               r127.0<1>:ud  r127.0<0;1,0>:ud  0x0:ud              {I@1}
(W)     send.ugm (1|M0)          r3       r127  null:0  0xFF000000            0x6219D500           {I@1,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
(W)     send.ugm (1|M0)          r4       r127  null:0  0xFF040000            0x6219C500           {$2} // wr:1+0, rd:1; load.ugm.d32x8t.a32.ca.cc.bti[255][A+0x40]
(W)     mov (16|M0)              r112.0<1>:ud  r0.0<1;1,0>:ud                   {Compacted}
(W)     or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x400004C0:ud              {A@1}
(W)     mov (1|M0)               r5.0<1>:d     r112.1<0;1,0>:d                  {Compacted,A@1}
        mov (16|M0)              r6.0<4>:uw    r1.0<1;1,0>:uw                   {$0.dst}
(W)     mul (1|M0)               acc0.0<1>:ud  r5.0<0;1,0>:ud    0xAAAB:uw              {I@2}
(W)     mach (1|M0)              r11.0<1>:ud   r5.0<0;1,0>:ud    0xAAAAAAAB:ud             
        mov (16|M0)              r125.0<1>:q   r6.0<4;1,0>:uw                   {I@3}
(W)     shr (1|M0)               r4.3<1>:ud    r11.0<0;1,0>:ud   4:w               {@2,$2.dst}
        mov (16|M16)             r8.0<4>:uw    r1.16<1;1,0>:uw                 
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0xC00:uw              {I@2}
(W)     mad (1|M0)               r4.5<1>:d     r5.0<0;0>:d       r4.3<0;0>:d       -24:w              
(W)     mach (1|M0)              r7.0<1>:d     r4.3<0;1,0>:ud    0xC00:ud             
(W)     mul (1|M0)               r4.6<1>:ud    r4.3<0;1,0>:ud    0xC00:uw             
(W)     shl (1|M0)               r2.3<1>:d     r4.5<0;1,0>:d     7:w               {I@3}
(W)     mov (1|M0)               r4.7<1>:d     r7.0<0;1,0>:d                    {I@3}
        mov (16|M16)             r123.0<1>:q   r8.0<4;1,0>:uw                  
(W)     add (1|M0)               r5.2<1>:q     r4.3<0;1,0>:q     r2.3<0;1,0>:ud   {I@2}
(W)     mov (1|M0)               r2.0<1>:uq    r2.2<0;1,0>:uq                   {Compacted}
        add (16|M0)              r8.0<1>:q     r5.2<0;1,0>:q     r125.0<1;1,0>:q  {Compacted,I@2}
        add (16|M16)             r14.0<1>:q    r5.2<0;1,0>:q     r123.0<1;1,0>:q  {Compacted}
        shl (16|M0)              r121.0<1>:q   r8.0<1;1,0>:q     2:w               {Compacted,I@2}
        shl (16|M16)             r119.0<1>:q   r14.0<1;1,0>:q    2:w               {Compacted,I@2}
        add (16|M0)              r16.0<1>:q    r121.0<1;1,0>:q   r2.3<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r18.0<1>:q    r119.0<1;1,0>:q   r2.3<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r22      r16  null:0  0x0            0x08200580           {I@1,$3} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     send.ugm (1|M0)          r10      r2  null:0  0x0            0x02108580           {$4} // wr:1+0, rd:1; load.ugm.d32x1t.a64
        mov (32|M0)              r110.0<1>:d   r1.0<1;1,0>:uw                  
(W)     mov (1|M0)               r3.29<1>:w    r3.56<0;1,0>:b                   {$1.dst}
        shl (32|M0)              r12.0<1>:d    r110.0<1;1,0>:d   2:w               {I@2}
(W)     and (1|M0)               r4.8<1>:w     r3.29<0;1,0>:w    1:w               {I@2}
(W)     and (1|M0)               r2.10<1>:d    r4.5<0;1,0>:d     255:w               {$4.src}
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x600:uw             
(W)     mov (1|M0)               r6.0<2>:b     r4.8<0;1,0>:w                    {I@3}
(W)     mach (1|M0)              r5.0<1>:d     r4.3<0;1,0>:ud    0x600:ud             
(W)     mul (1|M0)               acc0.0<1>:ud  r2.10<0;1,0>:ud   0xAAAB:uw              {I@4}
(W)     mov (1|M0)               r2.24<1>:w    r6.0<0;1,0>:ub                   {I@3}
(W)     mach (1|M0)              r6.0<1>:ud    r2.10<0;1,0>:ud   0xAAAAAAAB:ud             
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x60:uw             
(W)     shl (1|M0)               r2.11<1>:d    r4.5<0;1,0>:d     4:w              
(W)     mul (1|M0)               r2.0<1>:ud    r4.3<0;1,0>:ud    0x600:uw              {Compacted}
(W)     mov (1|M0)               r2.1<1>:d     r5.0<0;1,0>:d                    {Compacted,I@7}
(W)     mach (1|M0)              r11.0<1>:d    r4.3<0;1,0>:ud    0x60:ud             
(W)     mul (1|M0)               r2.8<1>:ud    r4.3<0;1,0>:ud    0x60:uw             
(W)     cmp (32|M0)   (eq)f0.0   null<2>:w     r2.24<0;1,0>:w    0:w               {I@7}
(W)     shl (1|M0)               r5.1<1>:q     r2.11<0;1,0>:ud   2:w               {I@6}
(W)     add (1|M0)               r6.1<1>:q     r2.0<0;1,0>:q     r3.0<0;1,0>:q    {Compacted,I@5}
(W)     mov (1|M0)               r2.9<1>:d     r11.0<0;1,0>:d                   {I@5}
(W)     shl (1|M0)               r2.7<1>:q     r4.5<0;1,0>:ud    2:w              
(W)     add (1|M0)               r7.0<1>:q     r6.1<0;1,0>:q     r5.1<0;1,0>:q    {Compacted,I@3}
(W)     add (1|M0)               r4.2<1>:q     r2.4<0;1,0>:q     r3.1<0;1,0>:q    {I@3}
(W)     mov (1|M0)               r1.6<1>:d     r2.2<0;1,0>:ud                  
(W)     mov (1|M0)               r20.0<1>:q    r7.0<0;1,0>:q                    {I@3}
(W)     add (1|M0)               r8.0<1>:q     r4.2<0;1,0>:q     r2.7<0;1,0>:q    {I@3}
(W)     send.ugm (1|M0)          r118     r7  null:0  0x0            0x0210C580           {$5} // wr:1+0, rd:1; load.ugm.d32x8t.a64
(W)     send.ugm (1|M0)          r113     r20  null:0  0x20000            0x0210C580           {I@2,$6} // wr:1+0, rd:1; load.ugm.d32x8t.a64.flat[A+0x20]
(W)     send.ugm (1|M0)          r127     r8  null:0  0x0            0x02108580           {I@1,$7} // wr:1+0, rd:1; load.ugm.d32x1t.a64
(W)     add (1|M0)               r1.7<1>:d     r1.6<0;1,0>:d     4096:w              
        send.slm (32|M0)         null     r12  r22:2  0x1000000            0x04000504           {$3} // wr:2+2, rd:0; store.slm.d32.a32.flat[A+0x1000]
(W)     add (1|M0)               r1.1<1>:d     r10.0<0;1,0>:d    r4.3<0;1,0>:d    {Compacted,$4.dst}
(W)     sel (1|M0)    (ge)f0.0   r5.0<1>:d     r1.1<0;1,0>:d     1023:w               {Compacted,I@1}
(W)     add (1|M0)               r6.1<1>:d     r5.0<0;1,0>:d     -1023:w               {Compacted,I@1}
(W&~f0.0) sel (1|M0)             r1.0<1>:d     r6.1<0;1,0>:d     0:w               {I@1}
(W)     add (1|M0)               r1.3<1>:d     r1.1<0;1,0>:d     -r1.0<0;1,0>:d   {I@1}
        sync.nop                             null                             {Compacted,$5.src}
(W)     send.slm (1|M0)          r7       r112  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r7.0<1;1,0>:ud                   {$8.dst}
(W)     send.ugm (1|M0)          r9       r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:f    3.58732e-43:f                              
(W)     mov (2|M0)               r11.10<1>:ub  r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r9.0<1;1,0>:ud                   {Compacted,$9.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     shl (1|M0)               r2.0<1>:d     r6.0<0;1,0>:d     6:w               {Compacted}
        cmp (32|M0)   (lt)f2.0   null<1>:d     r1.3<0;1,0>:d     r110.0<1;1,0>:d 
(W)     and (1|M0)               r4.3<1>:d     r2.0<0;1,0>:d     32640:w               {I@2}
(W)     mov (1|M0)               r1.2<1>:ud    f2.0<0;1,0>:ud                  
(W)     mov (1|M0)               r1.4<1>:q     r4.3<0;1,0>:ud                   {I@2}
(~f2.0) goto (32|M0)                         L1320                  L1320                
L1296:
        mov (32|M0)              r116.0<1>:ud  0x0:ud                              {Compacted}
        goto (32|M0)                         L1320                  L6232                
L1320:
        join (32|M0)                         L6232                                
L1336:
        mov (32|M0)              r116.0<1>:ud  0x0:ud                              {Compacted}
        mov (32|M0)              r108.0<1>:d   r110.0<1;1,0>:d                  {Compacted}
(W)     shl (1|M0)               r2.0<1>:q     r1.4<0;1,0>:q     2:w               {Compacted,I@7}
(W)     add (1|M0)               r1.2<1>:q     r2.0<0;1,0>:q     r3.2<0;1,0>:q    {I@1}
L1376:
        add (32|M0)   (lt)f2.0   r114.0<1>:d   r1.0<0;1,0>:d     r108.0<1;1,0>:d 
(~f2.0) mov (32|M0)              r6.0<1>:d     r114.0<1;1,0>:d                  {I@1}
(f2.0)  add3 (32|M0)             r6.0<1>:d     r1.0<0;0>:d       r108.0<1;0>:d     2047:w              
        and (32|M0)              r6.0<1>:d     r6.0<1;1,0>:d     -2048:w               {Compacted,I@1}
        add3 (32|M0)             r10.0<1>:d    r1.0<0;0>:d       r108.0<1;0>:d     -r6.0<1>:d       {@1,$10.src}
(f0.0)  sel (32|M0)              r14.0<1>:d    r108.0<1;1,0>:d   r10.0<1;1,0>:d   {I@1}
        mov (16|M0)              r16.0<2>:ud   r14.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r18.0<2>:ud   r15.0<1;1,0>:ud                  {Compacted}
        shl (16|M0)              r20.0<1>:q    r16.0<2;1,0>:d    12:w               {@2,$6.src}
        shl (16|M16)             r22.0<1>:q    r18.0<2;1,0>:d    12:w               {@2,$3.src}
        add (16|M0)              r24.0<1>:q    r1.2<0;1,0>:q     r20.0<1;1,0>:q   {Compacted,I@2}
        add (16|M16)             r26.0<1>:q    r1.2<0;1,0>:q     r22.0<1;1,0>:q   {I@2}
        send.ugm (32|M0)         r28      r24  null:0  0x0            0x08803580           {I@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64
        send.ugm (32|M0)         r36      r24  null:0  0x10000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x10]
        send.ugm (32|M0)         r44      r24  null:0  0x20000            0x08803580           {$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x20]
        send.ugm (32|M0)         r52      r24  null:0  0x30000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x30]
        send.ugm (32|M0)         r60      r24  null:0  0x40000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x40]
        send.ugm (32|M0)         r68      r24  null:0  0x50000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x50]
(W)     mov (1|M0)               r2.0<1>:ud    0x1000:uw                             
(W)     mov (1|M0)               r5.0<1>:ud    0x1020:uw                             
(W)     send.slm (1|M0)          r9       r2  null:0  0x0            0x0210C500           {I@2,$1} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     send.slm (1|M0)          r12      r5  null:0  0x0            0x0210C500           {I@1,$2} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r8.0<1>:ud    0x1040:uw                              {$7.src}
(W)     mov (1|M0)               r2.0<1>:ud    0x1060:uw                              {$1.src}
(W)     send.slm (1|M0)          r13      r8  null:0  0x0            0x0210C500           {I@2,$4} // wr:1+0, rd:1; load.slm.d32x8t.a32
        send.ugm (32|M0)         r84      r24  null:0  0xB0000            0x08803580           {$8} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xB0]
(W)     mov (1|M0)               r5.0<1>:ud    0x1080:uw                              {$2.src}
        send.ugm (32|M0)         r92      r24  null:0  0x110000            0x08803580           {$9} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x110]
        send.ugm (32|M0)         r100     r24  null:0  0x160000            0x08803580           {$5} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x160]
        sync.nop                             null                             {Compacted,$1.dst}
        mul (32|M0)              r6.0<1>:f     r9.0<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc2.0<1>:f   r9.1<0;1,0>:f     r30.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r9.5<0;1,0>:f     r38.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r14.0<1>:f    r9.4<0;1,0>:f     r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r10.0<1>:f    r9.2<0;1,0>:f     r32.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r16.0<1>:f    r9.3<0;1,0>:f     r34.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r18.0<1>:f    r9.6<0;1,0>:f     r40.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@4}
        sync.nop                             null                             {Compacted,$2.dst}
        mul (32|M0)              r20.0<1>:f    r12.0<0;1,0>:f    r44.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              r22.0<1>:f    r12.1<0;1,0>:f    r46.0<1;1,0>:f   {Compacted}
        add (32|M0)              r76.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r78.0<1>:f    acc2.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r9.7<0;1,0>:f     r42.0<1;1,0>:f  
        mul (32|M0)              r80.0<1>:f    r12.2<0;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r6.0<1>:f     r12.4<0;1,0>:f    r52.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              r82.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r54.0<1;1,0>:f  
        add (32|M0)              r14.0<1>:f    r76.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@7}
        mul (32|M0)              r10.0<1>:f    r12.3<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              r28.0<1>:f    r78.0<1;1,0>:f    0.0:f               {Compacted,F@7}
        add (32|M0)              r30.0<1>:f    r82.0<1;1,0>:f    r80.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r56.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r32.0<1>:f    r12.7<0;1,0>:f    r58.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$4.dst}
        mul (32|M0)              r16.0<1>:f    r13.0<0;1,0>:f    r60.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r8.0<1>:f     r13.1<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        add (32|M0)              r18.0<1>:f    r28.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r20.0<1>:f    r30.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r36.0<1>:f    r16.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r6.0<1>:f     r18.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r42.0<1>:f    r22.0<1;1,0>:f    r32.0<1;1,0>:f   {Compacted,F@3}
        send.ugm (32|M0)         r16      r24  null:0  0x60000            0x08803580           {F@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x60]
        send.ugm (32|M0)         r48      r24  null:0  0x70000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x70]
        mul (32|M0)              r38.0<1>:f    r13.4<0;1,0>:f    r68.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r34.0<1>:f    r13.2<0;1,0>:f    r64.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r40.0<1>:f    r13.5<0;1,0>:f    r70.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r36.0<1;1,0>:f    r34.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r14.0<1>:f    r38.0<1;1,0>:f    r40.0<1;1,0>:f   {F@2}
        send.ugm (32|M0)         r32      r24  null:0  0x90000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x90]
        send.ugm (32|M0)         r56      r24  null:0  0x80000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x80]
        mul (32|M0)              r44.0<1>:f    r13.3<0;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r76      r24  null:0  0xA0000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xA0]
        mul (32|M0)              r10.0<1>:f    r13.6<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        add (32|M0)              r28.0<1>:f    r6.0<1;1,0>:f     r42.0<1;1,0>:f   {Compacted}
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r44.0<1;1,0>:f   {Compacted,F@3}
(W)     send.slm (1|M0)          r7       r2  null:0  0x0            0x0210C500           {A@2,$0} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r46.0<1>:f    r13.7<0;1,0>:f    r74.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r28.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$0.dst}
        mul (32|M0)              r12.0<1>:f    r7.0<0;1,0>:f     r16.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc0.0<1>:f   r7.1<0;1,0>:f     r18.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r7.5<0;1,0>:f     r50.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r28.0<1>:f    r7.4<0;1,0>:f     r48.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {F@4}
(W)     send.slm (1|M0)          r10      r5  null:0  0x0            0x0210C500           {I@1,$1} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r14.0<1>:f    r7.2<0;1,0>:f     r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r28.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r40.0<1>:f    r7.6<0;1,0>:f     r52.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r30.0<1>:f    r7.3<0;1,0>:f     r22.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r46.0<1>:f    acc2.0<1;1,0>:f   r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r64.0<1>:f    acc0.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              acc2.0<1>:f   r7.7<0;1,0>:f     r54.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$1.dst}
        mul (32|M0)              r12.0<1>:f    r10.4<0;1,0>:f    r32.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              acc0.0<1>:f   r10.5<0;1,0>:f    r34.0<1;1,0>:f  
        mul (32|M0)              r42.0<1>:f    r10.0<0;1,0>:f    r56.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              r44.0<1>:f    r10.1<0;1,0>:f    r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              r18.0<1>:f    r46.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@7}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        mul (32|M0)              acc2.0<1>:f   r10.6<0;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              r68.0<1>:f    r42.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r40.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r42.0<1>:f    r10.7<0;1,0>:f    r38.0<1;1,0>:f  
        add (32|M0)              r50.0<1>:f    r40.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@1}
        send.ugm (32|M0)         r34      r24  null:0  0xC0000            0x08803580           {F@1,$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xC0]
        mul (32|M0)              r66.0<1>:f    r10.2<0;1,0>:f    r60.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r54      r24  null:0  0xD0000            0x08803580           {F@1,$4} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xD0]
(W)     mov (1|M0)               r6.0<1>:ud    0x10A0:uw                             
        mul (32|M0)              r14.0<1>:f    r10.3<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        add (32|M0)              r16.0<1>:f    r8.0<1;1,0>:f     r64.0<1;1,0>:f   {Compacted}
        add (32|M0)              r20.0<1>:f    r68.0<1;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r62      r24  null:0  0xE0000            0x08803580           {F@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xE0]
(W)     send.slm (1|M0)          r11      r6  null:0  0x0            0x0210C500           {I@1,$12} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              r28.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted}
        add (32|M0)              r30.0<1>:f    r20.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$12.dst}
        mul (32|M0)              r22.0<1>:f    r11.0<0;1,0>:f    r76.0<1;1,0>:f   {Compacted,$15.dst}
        send.ugm (32|M0)         r70      r24  null:0  0x100000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x100]
        mul (32|M0)              r6.0<1>:f     r11.1<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r8.0<1>:f     r11.2<0;1,0>:f    r80.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r46.0<1>:f    r11.4<0;1,0>:f    r84.0<1;1,0>:f   {Compacted,$8.dst}
        mul (32|M0)              r48.0<1>:f    r11.5<0;1,0>:f    r86.0<1;1,0>:f  
        add (32|M0)              r44.0<1>:f    r22.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r16.0<1>:f    r46.0<1;1,0>:f    r48.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc2.0<1>:f   r44.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@2}
        send.ugm (32|M0)         r42      r24  null:0  0xF0000            0x08803580           {F@1,$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xF0]
        mul (32|M0)              r52.0<1>:f    r11.3<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r12.0<1>:f    r28.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r2.0<1>:ud    0x10C0:uw                             
        mul (32|M0)              r14.0<1>:f    r11.6<0;1,0>:f    r88.0<1;1,0>:f   {Compacted}
        add (32|M0)              r20.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r18.0<1>:f    r12.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@3}
(W)     send.slm (1|M0)          r9       r2  null:0  0x0            0x0210C500           {I@1,$15} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r32.0<1>:f    r11.7<0;1,0>:f    r90.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              acc0.0<1>:f   r18.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r6.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$15.dst}
        mul (32|M0)              r12.0<1>:f    r9.0<0;1,0>:f     r34.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              acc0.0<1>:f   r9.1<0;1,0>:f     r36.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.5<0;1,0>:f     r56.0<1;1,0>:f   {$4.dst}
(W)     mov (1|M0)               r5.0<1>:ud    0x10E0:uw                             
        mul (32|M0)              r16.0<1>:f    r9.4<0;1,0>:f     r54.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {F@4}
(W)     send.slm (1|M0)          r10      r5  null:0  0x0            0x0210C500           {I@1,$0} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r14.0<1>:f    r9.2<0;1,0>:f     r38.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r18.0<1>:f    r9.3<0;1,0>:f     r40.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r20.0<1>:f    r9.6<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r32.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.7<0;1,0>:f     r60.0<1;1,0>:f  
        send.ugm (32|M0)         r54      r24  null:0  0x120000            0x08803580           {F@1,$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x120]
(W)     mov (1|M0)               r8.0<1>:ud    0x1100:uw                             
        sync.nop                             null                             {Compacted,$0.dst}
        mul (32|M0)              r22.0<1>:f    r10.0<0;1,0>:f    r62.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              r28.0<1>:f    r10.1<0;1,0>:f    r64.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r50.0<1>:f    r10.2<0;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r14.0<1>:f    r10.3<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r62      r24  null:0  0x130000            0x08803580           {F@1,$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x130]
(W)     send.slm (1|M0)          r11      r8  null:0  0x0            0x0210C500           {I@1,$4} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              r52.0<1>:f    r22.0<1;1,0>:f    r28.0<1;1,0>:f   {Compacted}
        add (32|M0)              r34.0<1>:f    r6.0<1;1,0>:f     r32.0<1;1,0>:f   {Compacted}
        add (32|M0)              r36.0<1>:f    r52.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@2}
        sync.nop                             null                             {Compacted,$4.dst}
        mul (32|M0)              r18.0<1>:f    r11.0<0;1,0>:f    r70.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              r8.0<1>:f     r11.1<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r6.0<1>:f     r11.2<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r52.0<1>:f    r11.3<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r70      r24  null:0  0x140000            0x08803580           {F@1,$8} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x140]
        mul (32|M0)              r12.0<1>:f    r10.4<0;1,0>:f    r42.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc0.0<1>:f   r10.5<0;1,0>:f    r44.0<1;1,0>:f  
        add (32|M0)              r16.0<1>:f    r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              acc2.0<1>:f   r10.6<0;1,0>:f    r46.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r38.0<1>:f    r10.7<0;1,0>:f    r48.0<1;1,0>:f  
        add (32|M0)              r22.0<1>:f    r36.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted}
        add (32|M0)              r20.0<1>:f    r34.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              r28.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        send.ugm (32|M0)         r78      r24  null:0  0x150000            0x08803580           {$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x150]
        add (32|M0)              r12.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r50.0<1>:f    r28.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r34.0<1>:f    r12.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@1}
        send.ugm (32|M0)         r44      r24  null:0  0x170000            0x08803580           {F@1,$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x170]
        add (32|M0)              r30.0<1>:f    r18.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted}
        mul (32|M0)              r40.0<1>:f    r11.5<0;1,0>:f    r94.0<1;1,0>:f   {$9.dst}
        mul (32|M0)              r32.0<1>:f    r11.4<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r30.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@3}
(W)     mov (1|M0)               r2.0<1>:ud    0x1120:uw                             
        mul (32|M0)              r14.0<1>:f    r11.6<0;1,0>:f    r96.0<1;1,0>:f   {Compacted}
        add (32|M0)              r16.0<1>:f    r32.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r36.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r7       r2  null:0  0x0            0x0210C500           {A@1,$13} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r42.0<1>:f    r11.7<0;1,0>:f    r98.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   r34.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$13.dst}
        mul (32|M0)              r12.0<1>:f    r7.0<0;1,0>:f     r54.0<1;1,0>:f   {Compacted,$1.dst}
        mul (32|M0)              acc0.0<1>:f   r7.1<0;1,0>:f     r56.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r5.0<1>:ud    0x1140:uw                             
        mul (32|M0)              acc2.0<1>:f   r7.5<0;1,0>:f     r64.0<1;1,0>:f   {$2.dst}
        mul (32|M0)              r16.0<1>:f    r7.4<0;1,0>:f     r62.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r10      r5  null:0  0x0            0x0210C500           {I@1,$14} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r14.0<1>:f    r7.2<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r18.0<1>:f    r7.3<0;1,0>:f     r60.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r20.0<1>:f    r7.6<0;1,0>:f     r66.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r32.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r56      r24  null:0  0x180000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x180]
        sync.nop                             null                             {Compacted,$14.dst}
        mul (32|M0)              r22.0<1>:f    r10.0<0;1,0>:f    r70.0<1;1,0>:f   {Compacted,$8.dst}
        mul (32|M0)              acc2.0<1>:f   r7.7<0;1,0>:f     r68.0<1;1,0>:f  
        send.ugm (32|M0)         r64      r24  null:0  0x190000            0x08803580           {F@1,$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x190]
(W)     mov (1|M0)               r6.0<1>:ud    0x1160:uw                             
        mul (32|M0)              r28.0<1>:f    r10.1<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r11      r6  null:0  0x0            0x0210C500           {I@1,$1} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r12.0<1>:f    r10.4<0;1,0>:f    r78.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc0.0<1>:f   r10.5<0;1,0>:f    r80.0<1;1,0>:f  
        mul (32|M0)              r34.0<1>:f    r10.2<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        add (32|M0)              r36.0<1>:f    r22.0<1;1,0>:f    r28.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r16.0<1>:f    r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$1.dst}
        mul (32|M0)              r18.0<1>:f    r11.0<0;1,0>:f    r100.0<1;1,0>:f  {Compacted,$5.dst}
        mul (32|M0)              r6.0<1>:f     r11.1<0;1,0>:f    r102.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r10.6<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r38.0<1>:f    r8.0<1;1,0>:f     r32.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    r36.0<1;1,0>:f    r34.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r42.0<1>:f    r10.7<0;1,0>:f    r84.0<1;1,0>:f  
        mul (32|M0)              r14.0<1>:f    r10.3<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              r30.0<1>:f    r18.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@7}
        add (32|M0)              r28.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r8.0<1>:f     r11.2<0;1,0>:f    r104.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r32.0<1>:f    r11.4<0;1,0>:f    r44.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              r34.0<1>:f    r11.5<0;1,0>:f    r46.0<1;1,0>:f  
        send.ugm (32|M0)         r72      r24  null:0  0x1A0000            0x08803580           {F@6,$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1A0]
        add (32|M0)              r20.0<1>:f    r38.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted}
        add (32|M0)              r36.0<1>:f    r28.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r30.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@5}
        add (32|M0)              r16.0<1>:f    r32.0<1;1,0>:f    r34.0<1;1,0>:f   {Compacted,F@4}
        send.ugm (32|M0)         r28      r24  null:0  0x1B0000            0x08803580           {F@1,$4} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1B0]
        send.ugm (32|M0)         r80      r24  null:0  0x1C0000            0x08803580           {$8} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1C0]
        add (32|M0)              r22.0<1>:f    r40.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r88      r24  null:0  0x1D0000            0x08803580           {$9} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1D0]
        mul (32|M0)              r52.0<1>:f    r11.3<0;1,0>:f    r106.0<1;1,0>:f  {Compacted}
        add (32|M0)              r12.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@2}
(W)     mov (1|M0)               r2.0<1>:ud    0x1180:uw                             
        mul (32|M0)              r14.0<1>:f    r11.6<0;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r38.0<1>:f    r12.0<1;1,0>:f    r36.0<1;1,0>:f   {F@3}
(W)     send.slm (1|M0)          r9       r2  null:0  0x0            0x0210C500           {I@1,$11} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r54.0<1>:f    r11.7<0;1,0>:f    r50.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              acc0.0<1>:f   r38.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r54.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r6.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$11.dst}
        mul (32|M0)              r12.0<1>:f    r9.0<0;1,0>:f     r56.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r14.0<1>:f    r9.2<0;1,0>:f     r60.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r9.1<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r54      r24  null:0  0x1E0000            0x08803580           {F@1,$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1E0]
        mul (32|M0)              r18.0<1>:f    r9.3<0;1,0>:f     r62.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r20.0<1>:f    r9.6<0;1,0>:f     r68.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r16.0<1>:f    r9.4<0;1,0>:f     r64.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.5<0;1,0>:f     r66.0<1;1,0>:f  
        send.ugm (32|M0)         r62      r24  null:0  0x1F0000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1F0]
(W)     mov (1|M0)               r5.0<1>:ud    0x11A0:uw                             
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
(W)     send.slm (1|M0)          r10      r5  null:0  0x0            0x0210C500           {I@1,$14} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
(W)     mov (1|M0)               r8.0<1>:ud    0x11C0:uw                             
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r11      r8  null:0  0x0            0x0210C500           {I@1,$15} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$14.dst}
        mul (32|M0)              r22.0<1>:f    r10.0<0;1,0>:f    r72.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              r36.0<1>:f    r10.1<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        add (32|M0)              r38.0<1>:f    acc2.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.7<0;1,0>:f     r70.0<1;1,0>:f  
        mul (32|M0)              r42.0<1>:f    r10.2<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r12.0<1>:f    r10.4<0;1,0>:f    r28.0<1;1,0>:f   {Compacted,$4.dst}
        add (32|M0)              r44.0<1>:f    r22.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              acc0.0<1>:f   r10.5<0;1,0>:f    r30.0<1;1,0>:f  
        add (32|M0)              r16.0<1>:f    r38.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@7}
        mul (32|M0)              r14.0<1>:f    r10.3<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              r46.0<1>:f    r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r48.0<1>:f    r44.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              acc0.0<1>:f   r12.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$15.dst}
        mul (32|M0)              r18.0<1>:f    r11.0<0;1,0>:f    r80.0<1;1,0>:f   {Compacted,$8.dst}
        mul (32|M0)              r8.0<1>:f     r11.1<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r10.6<0;1,0>:f    r32.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r50.0<1>:f    r10.7<0;1,0>:f    r34.0<1;1,0>:f  
        add (32|M0)              r20.0<1>:f    r46.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    r48.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r36.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r6.0<1>:f     r11.2<0;1,0>:f    r84.0<1;1,0>:f   {Compacted}
        add (32|M0)              r38.0<1>:f    r18.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@7}
        mul (32|M0)              r40.0<1>:f    r11.4<0;1,0>:f    r88.0<1;1,0>:f   {Compacted,$9.dst}
        mul (32|M0)              r42.0<1>:f    r11.5<0;1,0>:f    r90.0<1;1,0>:f  
        mul (32|M0)              r52.0<1>:f    r11.3<0;1,0>:f    r86.0<1;1,0>:f   {Compacted}
        add (32|M0)              r12.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r44.0<1>:f    r36.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              acc2.0<1>:f   r38.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@6}
(W)     mov (1|M0)               r2.0<1>:ud    0x11E0:uw                             
        mul (32|M0)              r14.0<1>:f    r11.6<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        add (32|M0)              r16.0<1>:f    r40.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@6}
        add (32|M0)              r46.0<1>:f    r12.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r28.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x0210C500           {I@1,$0} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r30.0<1>:f    r11.7<0;1,0>:f    r94.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r14.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              acc0.0<1>:f   r46.0<1;1,0>:f    r28.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$0.dst}
        mul (32|M0)              r6.0<1>:f     r5.0<0;1,0>:f     r54.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              acc0.0<1>:f   r5.1<0;1,0>:f     r56.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r5.5<0;1,0>:f     r64.0<1;1,0>:f   {$13.dst}
        mul (32|M0)              r12.0<1>:f    r5.4<0;1,0>:f     r62.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r6.0<1;1,0>:f     acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r10.0<1>:f    r5.2<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r12.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r16.0<1>:f    r5.6<0;1,0>:f     r66.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r14.0<1>:f    r5.3<0;1,0>:f     r60.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r18.0<1>:f    r5.7<0;1,0>:f     r68.0<1;1,0>:f  
        add (32|M0)              r20.0<1>:d    r1.1<0;1,0>:d     -r114.0<1;1,0>:d {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,F@2}
        cmp (32|M0)   (lt)f3.0   null<1>:d     r20.0<1;1,0>:d    1024:w               {I@1}
        add (32|M0)              acc0.0<1>:f   r8.0<1;1,0>:f     acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r60.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(f3.0)  goto (32|M0)                         L5096                  L5096                
L5072:
        mov (32|M0)              r18.0<1>:ud   0x0:ud                              {Compacted,F@3}
        goto (32|M0)                         L5096                  L6048                
L5096:
        join (32|M0)                         L6048                                
L5112:
        mov (16|M0)              r6.0<2>:ud    r20.0<1;1,0>:ud                  {Compacted}
        mov (16|M16)             r8.0<2>:ud    r21.0<1;1,0>:ud                  {Compacted,F@2}
        shl (16|M0)              r10.0<1>:q    r6.0<2;1,0>:d     1:w               {I@2}
        shl (16|M16)             r12.0<1>:q    r8.0<2;1,0>:d     1:w               {I@2}
        add (16|M0)              r14.0<1>:q    r10.0<1;1,0>:q    r3.3<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r16.0<1>:q    r12.0<1;1,0>:q    r3.3<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r18      r14  null:0  0x0            0x08200B80           {I@1,$1} // wr:4+0, rd:2; load.ugm.d16u32.a64
        send.ugm (32|M0)         r20      r14  null:0  0x800000            0x08200B80           {$2} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x800]
        send.ugm (32|M0)         r22      r14  null:0  0x1000000            0x08200B80           {$4} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1000]
        send.ugm (32|M0)         r26      r14  null:0  0x2000000            0x08200B80           {$8} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2000]
        send.ugm (32|M0)         r24      r14  null:0  0x1800000            0x08200B80           {$9} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1800]
        send.ugm (32|M0)         r28      r14  null:0  0x2800000            0x08200B80           {$11} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2800]
        send.ugm (32|M0)         r30      r14  null:0  0x3000000            0x08200B80           {$12} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3000]
        send.ugm (32|M0)         r32      r14  null:0  0x3800000            0x08200B80           {$13} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3800]
        send.ugm (32|M0)         r34      r14  null:0  0x4000000            0x08200B80           {$14} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4000]
        send.ugm (32|M0)         r36      r14  null:0  0x6800000            0x08200B80           {$15} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6800]
        send.ugm (32|M0)         r6       r14  null:0  0x4800000            0x08200B80           {$0} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4800]
        send.ugm (32|M0)         r8       r14  null:0  0x5000000            0x08200B80           {$6} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5000]
        send.ugm (32|M0)         r10      r14  null:0  0x5800000            0x08200B80           {$7} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5800]
        send.ugm (32|M0)         r12      r14  null:0  0x6000000            0x08200B80           {$3} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6000]
        send.ugm (32|M0)         r38      r14  null:0  0x7000000            0x08200B80           {$10} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7000]
        send.ugm (32|M0)         r40      r14  null:0  0x7800000            0x08200B80           {$5} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7800]
        shl (32|M0)              r42.0<1>:d    r18.0<1;1,0>:ud   16:w               {$1.dst}
        shl (32|M0)              r44.0<1>:d    r20.0<1;1,0>:ud   16:w               {$2.dst}
        sync.nop                             null                             {Compacted,I@2}
        mul (32|M0)              acc0.0<1>:f   r118.0<0;1,0>:f   r42.0<1;1,0>:f   {Compacted,$5.dst}
        mul (32|M0)              acc2.0<1>:f   r118.1<0;1,0>:f   r44.0<1;1,0>:f   {I@1}
        shl (32|M0)              r46.0<1>:d    r22.0<1;1,0>:ud   16:w               {$4.dst}
        shl (32|M0)              r54.0<1>:d    r26.0<1;1,0>:ud   16:w               {$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   0.0:f               {Compacted}
        shl (32|M0)              r48.0<1>:d    r24.0<1;1,0>:ud   16:w               {$9.dst}
        mul (32|M0)              r50.0<1>:f    r118.2<0;1,0>:f   r46.0<1;1,0>:f   {Compacted,I@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r118.4<0;1,0>:f   r54.0<1;1,0>:f   {Compacted,I@2}
        mul (32|M0)              r52.0<1>:f    r118.3<0;1,0>:f   r48.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r56.0<1>:d    r28.0<1;1,0>:ud   16:w               {$11.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r50.0<1;1,0>:f   {Compacted,F@4}
        shl (32|M0)              r58.0<1>:d    r30.0<1;1,0>:ud   16:w               {$12.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@2}
        sync.nop                             null                             {Compacted,I@2}
        mul (32|M0)              r14.0<1>:f    r118.5<0;1,0>:f   r56.0<1;1,0>:f   {$5.src}
        shl (32|M0)              r18.0<1>:d    r32.0<1;1,0>:ud   16:w               {$13.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r16.0<1>:f    r118.6<0;1,0>:f   r58.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@3}
        shl (32|M0)              r20.0<1>:d    r34.0<1;1,0>:ud   16:w               {$14.dst}
        mul (32|M0)              r24.0<1>:f    r118.7<0;1,0>:f   r18.0<1;1,0>:f   {I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@3}
        sync.nop                             null                             {F@2}
        shl (32|M0)              r18.0<1>:d    r36.0<1;1,0>:ud   16:w               {$15.dst}
        shl (32|M0)              r22.0<1>:d    r6.0<1;1,0>:ud    16:w               {$0.dst}
        sync.nop                             null                             {Compacted,I@3}
        mul (32|M0)              r26.0<1>:f    r113.0<0;1,0>:f   r20.0<1;1,0>:f   {Compacted,$6.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f  
        shl (32|M0)              r30.0<1>:d    r8.0<1;1,0>:ud    16:w               {$6.dst}
        mul (32|M0)              acc2.0<1>:f   r113.5<0;1,0>:f   r18.0<1;1,0>:f   {I@3}
        mul (32|M0)              r28.0<1>:f    r113.1<0;1,0>:f   r22.0<1;1,0>:f   {Compacted,I@2}
        shl (32|M0)              r42.0<1>:d    r10.0<1;1,0>:ud   16:w               {$7.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@4}
        mul (32|M0)              r32.0<1>:f    r113.2<0;1,0>:f   r30.0<1;1,0>:f   {Compacted,I@2}
        shl (32|M0)              r44.0<1>:d    r12.0<1;1,0>:ud   16:w               {$3.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r34.0<1>:f    r113.3<0;1,0>:f   r42.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r6.0<1>:f     r113.4<0;1,0>:f   r44.0<1;1,0>:f   {I@1}
        shl (32|M0)              r20.0<1>:d    r38.0<1;1,0>:ud   16:w               {$10.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r34.0<1;1,0>:f   {Compacted,F@3}
        shl (32|M0)              r22.0<1>:d    r40.0<1;1,0>:ud   16:w               {$5.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted,F@2}
        mul (32|M0)              r8.0<1>:f     r113.6<0;1,0>:f   r20.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r10.0<1>:f    r113.7<0;1,0>:f   r22.0<1;1,0>:f   {I@1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@3}
        add (32|M0)              r18.0<1>:f    acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@2}
L6048:
        join (32|M0)                         L6232                                
L6064:
        mul (32|M0)              acc0.0<1>:f   r60.0<1;1,0>:f    r3.15<0;1,0>:f   {Compacted}
        shl (32|M0)              r8.0<1>:d     r108.0<1;1,0>:d   2:w               {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {F@2}
        add3 (32|M0)             r10.0<1>:d    r1.6<0;0>:d       r8.0<1;0>:d       4096:w               {I@1}
        add (32|M0)              r6.0<1>:f     acc0.0<1;1,0>:f   -r127.0<0;1,0>:f {$7.dst}
        send.slm (32|M0)         null     r10  r6:2  0x0            0x04000504           {A@1,$1} // wr:2+2, rd:0; store.slm.d32.a32
        sel (32|M0)   (ge)f0.0   r116.0<1>:f   r116.0<1;1,0>:f   r6.0<1;1,0>:f   
        sync.nop                             null                             {Compacted,F@1}
        add (32|M0)              r6.0<1>:d     r108.0<1;1,0>:d   128:w               {Compacted,$1.src}
        cmp (32|M0)   (gt)f1.0   null<1>:d     r6.0<1;1,0>:d     r1.3<0;1,0>:d    {I@1}
(f1.0)  goto (32|M0)                         L6232                  L6232                
L6208:
        mov (32|M0)              r108.0<1>:f   r6.0<1;1,0>:f                    {Compacted}
(W)     jmpi                                 L1376                                
L6232:
        join (32|M0)                         L6248                                
L6248:
(W)     mov (32|M0)              r5.0<1>:f     -inf:f                               {I@4}
        mov (32|M0)              r5.0<1>:f     r116.0<1;1,0>:f                  {Compacted}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {F@1}
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,$7.src}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
        sync.nop                             null                             {Compacted,I@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,$10.src}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
        sync.nop                             null                             {Compacted,I@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {$3.src}
(W)     sel (1|M0)    (ge)f0.0   r8.0<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {F@1}
(W)     send.slm (1|M0)          r13      r112  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r14.2<1>:f    3.58732e-43:f                              
(W)     mov (2|M0)               r14.10<1>:ub  r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r13.0<1;1,0>:ud                  {$2.dst}
(W)     send.gtwy (1|M0)         null     r14  null:0  0x0            0x02000004           {I@2,$4} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               acc0.0<1>:d   r4.1<0;1,0>:d     r4.0<0;1,0>:uw  
(W)     macl (1|M0)              r5.0<1>:d     r4.1<0;1,0>:d     r4.0<0;1,0>:d   
(W)     mov (1|M0)               r1.10<1>:ud   0x2:uw                             
(W)     mul (1|M0)               acc0.0<1>:d   r5.0<0;1,0>:d     r4.4<0;1,0>:uw   {I@2}
(W)     macl (1|M0)              r2.0<1>:d     r5.0<0;1,0>:d     r4.2<0;1,0>:d    {Compacted}
(W)     mov (1|M0)               r3.58<2>:b    r112.8<0;1,0>:b                 
(W)     add (1|M0)               r2.1<1>:d     r2.0<0;1,0>:d     31:w               {Compacted,I@2}
(W)     mov (8|M0)               r7.0<1>:w     0x76543210:v                              
(W)     shr (1|M0)               r4.4<1>:ud    r2.1<0;1,0>:ud    3:w               {I@2}
(W)     mov (1|M0)               r1.12<1>:d    r3.58<0;1,0>:ub                 
(W)     shr (1|M0)               r1.14<1>:ud   r4.4<0;1,0>:ud    r1.10<0;1,0>:d   {I@2}
(W)     add (8|M0)               r7.8<1>:w     r7.0<1;1,0>:w     8:w              
(W)     add (1|M0)               r6.0<1>:d     r1.14<0;1,0>:d    -1:w               {I@2}
(W)     and (1|M0)               r4.3<1>:d     r2.0<0;1,0>:d     31:w              
(W)     cmp (1|M0)    (gt)f3.0   null<1>:ud    r6.0<0;1,0>:ud    r1.12<0;1,0>:ud  {I@2}
(W)     add (16|M0)              r7.16<1>:w    r7.0<1;1,0>:w     16:w              
        cmp (32|M0)   (eq)f1.0   null<2>:w     r7.0<1;1,0>:w     0:w               {I@1}
(W&~f3.0) cmp (1|M0)  (eq)f3.0   null<1>:d     r4.3<0;1,0>:d     0:w              
(W&~f3.0) sel (1|M0)             r1.15<1>:d    r4.3<0;1,0>:d     32:w              
(~f1.0) goto (32|M0)                         L6816                  L6816                
L6784:
(W)     shl (1|M0)               r2.0<1>:d     r1.12<0;1,0>:d    2:w              
(W)     send.slm (1|M0)          null     r2  r8:1  0x0            0x02008504           {I@1,$8} // wr:1+1, rd:0; store.slm.d32x1t.a32
L6816:
        join (32|M0)                         L6832                                
L6832:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$9.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               r2.0<1>:d     r1.12<0;1,0>:d    32:w               {Compacted,$8.src}
        mov (32|M0)              r20.0<1>:d    r7.0<1;1,0>:uw                   {$6.src}
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.14<0;1,0>:ud   0x20:uw             
        add (32|M0)              r22.0<1>:d    r2.0<0;1,0>:d     r20.0<1;1,0>:d   {Compacted,I@2}
(W&f2.0) jmpi                                L7024                                
L6992:
(W)     mov (1|M0)               r1.1<1>:d     r1.14<0;1,0>:d                  
(W)     jmpi                                 L7776                                
L7024:
        shl (32|M0)              r16.0<1>:d    r22.0<1;1,0>:d    2:w               {Compacted,I@4}
(W)     shl (1|M0)               r13.0<1>:d    r1.12<0;1,0>:d    2:w               {Compacted}
(W)     mov (1|M0)               r1.5<1>:d     r1.14<0;1,0>:d                  
L7056:
(W)     add (1|M0)               r2.0<1>:d     r1.5<0;1,0>:d     31:w               {I@1}
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.5<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.4<1>:ud    r4.3<0;1,0>:ud    r1.10<0;1,0>:d   {I@1}
(W)     mul (1|M0)               r1.11<1>:d    r1.4<0;1,0>:d     32:w               {I@1}
(f3.0)  goto (32|M0)                         L7200                  L7200                
L7152:
        sync.nop                             null                             {$4.src}
        mov (32|M0)              r14.0<1>:ud   0xFF800000:ud                              {$11.dst}
        goto (32|M0)                         L7200                  L7248                
L7200:
        join (32|M0)                         L7248                                
L7216:
        sync.nop                             null                             {$4.src}
        send.slm (32|M0)         r14      r16  null:0  0x0            0x04200500           {I@3,$11} // wr:2+0, rd:2; load.slm.d32.a32
L7248:
        join (32|M0)                         L7264                                
L7264:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$14} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {$13.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$10.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$14.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$15} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.11<0;1,0>:ud 
(~f3.0) goto (32|M0)                         L7552                  L7552                
L7408:
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$15.src}
        mov (32|M0)              r5.0<1>:ud    r14.0<1;1,0>:ud                  {Compacted,$11.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {@1,$12.src}
(~f1.0) goto (32|M0)                         L7552                  L7552                
L7536:
(W)     send.slm (1|M0)          null     r13  r3:1  0x0            0x02008504           {F@1,$12} // wr:1+1, rd:0; store.slm.d32x1t.a32
L7552:
        join (32|M0)                         L7568                                
L7568:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$0} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$15.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$0.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$13} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.4<0;1,0>:ud    0x20:uw             
(W)     mov (1|M0)               r1.11<1>:d    r1.4<0;1,0>:d                   
(W&f3.0) jmpi                                L7744                                
L7712:
(W)     mov (1|M0)               r1.1<1>:d     r1.11<0;1,0>:d                   {I@2}
(W)     jmpi                                 L7776                                
L7744:
(W)     mov (1|M0)               r1.5<1>:d     r1.4<0;1,0>:d                   
(W)     jmpi                                 L7056                                
L7776:
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.1<0;1,0>:ud    r1.15<0;1,0>:ud  {I@4}
(W&f3.0) jmpi                                L8112                                
L7808:
        cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.1<0;1,0>:ud    r20.0<1;1,0>:ud 
(f3.0)  goto (32|M0)                         L7888                  L7888                
L7840:
        sync.nop                             null                             {$4.src}
        mov (32|M0)              r14.0<1>:ud   0xFF800000:ud                              {$11.dst}
        goto (32|M0)                         L7888                  L7952                
L7888:
        join (32|M0)                         L7952                                
L7904:
        sync.nop                             null                             {Compacted,$13.src}
        shl (32|M0)              r6.0<1>:d     r20.0<1;1,0>:d    2:w               {Compacted,$10.src}
        sync.nop                             null                             {$4.src}
        send.slm (32|M0)         r14      r6  null:0  0x0            0x04200500           {I@1,$11} // wr:2+0, rd:2; load.slm.d32.a32
L7952:
        join (32|M0)                         L7968                                
L7968:
        sync.allrd                           ($11,$13)                
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$10.src}
        mov (32|M0)              r5.0<1>:ud    r14.0<1;1,0>:ud                  {Compacted,$11.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r1.11<1>:f    r12.0<0;1,0>:f    r12.1<0;1,0>:f   {F@1}
(W)     jmpi                                 L8288                                
L8112:
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                             
(W)     mov (1|M0)               r1.4<1>:d     1:w                               {Compacted}
        sync.nop                             null                             {Compacted,$12.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$1} // wr:1+0, rd:1; load.slm.d32x1t.a32
L8160:
(W)     shl (1|M0)               r2.0<1>:d     r1.4<0;1,0>:d     2:w               {@1,$1.src}
(W)     add (1|M0)               r1.4<1>:d     r1.4<0;1,0>:d     1:w              
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r1.4<0;1,0>:ud    r1.1<0;1,0>:ud   {I@1}
        sync.nop                             null                             {Compacted,$2.dst}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$1.dst}
(W)     mov (1|M0)               r1.5<1>:f     r3.0<0;1,0>:f                    {F@1}
(W&f3.0) jmpi                                L8160                                
L8272:
(W)     mov (1|M0)               r1.11<1>:f    r1.5<0;1,0>:f                    {F@1}
L8288:
(W)     mov (1|M0)               f3.0<1>:ud    r1.2<0;1,0>:ud                  
(W)     mov (1|M0)               r1.5<1>:f     0xB5BFBE8E:f                              
(W)     mov (1|M0)               r1.4<1>:f     0xBF317200:f                               {I@3}
(~f3.0) goto (32|M0)                         L8384                  L8384                
L8352:
        mov (32|M0)              r24.0<1>:ud   0x0:ud                             
        goto (32|M0)                         L8384                  L8744                
L8384:
        join (32|M0)                         L8744                                
L8400:
        mov (32|M0)              r24.0<1>:ud   0x0:ud                              {Compacted}
L8408:
        sync.allrd                           ($3,$13)                
        shl (32|M0)              r6.0<1>:d     r110.0<1;1,0>:d   2:w               {Compacted,$10.src}
        add3 (32|M0)             r8.0<1>:d     r1.6<0;0>:d       r6.0<1;0>:d       4096:w               {I@1}
        send.slm (32|M0)         r10      r8  null:0  0x0            0x04200500           {I@1,$8} // wr:2+0, rd:2; load.slm.d32.a32
        add (32|M0)              r110.0<1>:d   r110.0<1;1,0>:d   128:w              
        add (32|M0)              acc0.0<1>:f   r10.0<1;1,0>:f    -r1.11<0;1,0>:f  {@3,$8.dst}
        mul (32|M0)              acc2.0<1>:f   acc0.0<1;1,0>:f   1.442695e+00:f              
        rndz (32|M0)             r12.0<1>:f    acc2.0<1;1,0>:f                  {$12.src}
        mad (32|M0)              acc2.0<1>:f   acc0.0<1;0>:f     r12.0<1;0>:f      r1.4<0>:f        {Compacted,F@1}
        mad (32|M0)              acc2.0<1>:f   acc2.0<1;0>:f     r12.0<1;0>:f      r1.5<0>:f        {Compacted}
        sync.nop                             null                             {$4.src}
        mul (32|M0)              r14.0<1>:f    acc2.0<1;1,0>:f   1.442695e+00:f               {$11.dst}
        math.exp (32|M0)         r16.0<1>:f    r12.0<1;1,0>:f                  
        math.exp (32|M0)         r18.0<1>:f    r14.0<1;1,0>:f                   {F@1}
        mul (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {M@1}
        cmp (32|M0)   (lt)f3.0   null<1>:f     acc0.0<1;1,0>:f   -105.0:f              
(~f3.0) sel (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   0.0:f              
        cmp (32|M0)   (gt)f3.0   null<1>:f     acc0.0<1;1,0>:f   105.0:f              
(~f3.0) sel (32|M0)              r6.0<1>:f     acc2.0<1;1,0>:f   inf:f              
        cmp (32|M0)   (gt)f3.0   null<1>:d     r110.0<1;1,0>:d   r1.3<0;1,0>:d    {A@1}
        send.slm (32|M0)         null     r8  r6:2  0x0            0x04000504           {$3} // wr:2+2, rd:0; store.slm.d32.a32
        add (32|M0)              r24.0<1>:f    r24.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
(~f3.0) goto.b (32|M0)                       L8744                  L8408                
L8744:
        join (32|M0)                         L8760                                
L8760:
        sync.nop                             null                             {Compacted,F@1}
        sync.allrd                           ($3,$13)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$10.src}
        mov (32|M0)              r5.0<1>:f     r24.0<1;1,0>:f                   {Compacted,I@1}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {Compacted,F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {Compacted,@1,$12.src}
(W)     send.slm (1|M0)          r12      r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r13.2<1>:ud   0x100:ud                              {Compacted}
(W)     mov (2|M0)               r13.10<1>:ub  r112.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r12.0<1;1,0>:ud                  {Compacted,$9.dst}
(W)     send.gtwy (1|M0)         null     r13  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(~f1.0) goto (32|M0)                         L9008                  L9008                
L8976:
(W)     shl (1|M0)               r2.0<1>:d     r1.12<0;1,0>:d    2:w               {F@1}
(W)     send.slm (1|M0)          null     r2  r3:1  0x0            0x02008504           {I@1,$12} // wr:1+1, rd:0; store.slm.d32x1t.a32
L9008:
        join (32|M0)                         L9024                                
L9024:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$13} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$13.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$14} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W&f2.0) jmpi                                L9168                                
L9136:
(W)     mov (1|M0)               r1.13<1>:d    r1.14<0;1,0>:d                  
(W)     jmpi                                 L9872                                
L9168:
        sync.nop                             null                             {Compacted,$4.src}
        shl (32|M0)              r14.0<1>:d    r22.0<1;1,0>:d    2:w               {Compacted,$11.dst}
(W)     shl (1|M0)               r16.0<1>:d    r1.12<0;1,0>:d    2:w               {Compacted}
(W)     mov (1|M0)               r1.2<1>:d     r1.14<0;1,0>:d                  
L9208:
(W)     add (1|M0)               r2.0<1>:d     r1.2<0;1,0>:d     31:w               {Compacted,@1,$12.src}
        cmp (32|M0)   (lt)f2.0   null<1>:ud    r22.0<1;1,0>:ud   r1.2<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.1<1>:ud    r4.3<0;1,0>:ud    r1.10<0;1,0>:d   {I@1}
(W)     mul (1|M0)               r1.12<1>:d    r1.1<0;1,0>:d     32:w               {I@1}
(f2.0)  goto (32|M0)                         L9328                  L9328                
L9296:
        sync.nop                             null                             {Compacted,$10.src}
        mov (32|M0)              r12.0<1>:ud   0x0:ud                              {Compacted,$15.dst}
        goto (32|M0)                         L9328                  L9368                
L9328:
        join (32|M0)                         L9368                                
L9344:
        sync.nop                             null                             {Compacted,$10.src}
        send.slm (32|M0)         r12      r14  null:0  0x0            0x04200500           {I@3,$15} // wr:2+0, rd:2; load.slm.d32.a32
L9368:
        join (32|M0)                         L9384                                
L9384:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {Compacted,$1.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$14.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$2.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.12<0;1,0>:ud 
(~f3.0) goto (32|M0)                         L9664                  L9664                
L9520:
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$3.src}
        mov (32|M0)              r5.0<1>:ud    r12.0<1;1,0>:ud                  {Compacted,$15.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {@1,$0.src}
(~f1.0) goto (32|M0)                         L9664                  L9664                
L9648:
(W)     send.slm (1|M0)          null     r16  r3:1  0x0            0x02008504           {F@1,$0} // wr:1+1, rd:0; store.slm.d32x1t.a32
L9664:
        join (32|M0)                         L9680                                
L9680:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$3.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$8.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$1} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.1<0;1,0>:ud    0x20:uw             
(W&f2.0) jmpi                                L9840                                
L9808:
(W)     mov (1|M0)               r1.13<1>:d    r1.1<0;1,0>:d                   
(W)     jmpi                                 L9872                                
L9840:
(W)     mov (1|M0)               r1.2<1>:d     r1.1<0;1,0>:d                   
(W)     jmpi                                 L9208                                
L9872:
(W)     cmp (32|M0)   (gt)f1.0   null<1>:ud    r1.13<0;1,0>:ud   r1.15<0;1,0>:ud  {I@4}
(W&f1.0) jmpi                                L10192                                
L9904:
        cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.13<0;1,0>:ud   r20.0<1;1,0>:ud 
(f3.0)  goto (32|M0)                         L9968                  L9968                
L9936:
        sync.nop                             null                             {Compacted,$10.src}
        mov (32|M0)              r12.0<1>:ud   0x0:ud                              {Compacted,$15.dst}
        goto (32|M0)                         L9968                  L10032                
L9968:
        join (32|M0)                         L10032                                
L9984:
        sync.nop                             null                             {Compacted,$1.src}
        shl (32|M0)              r6.0<1>:d     r20.0<1;1,0>:d    2:w               {Compacted,$14.src}
        sync.nop                             null                             {$10.src}
        send.slm (32|M0)         r12      r6  null:0  0x0            0x04200500           {I@1,$15} // wr:2+0, rd:2; load.slm.d32.a32
L10032:
        join (32|M0)                         L10048                                
L10048:
        sync.allrd                           ($1,$15)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$14.src}
        mov (32|M0)              r5.0<1>:ud    r12.0<1;1,0>:ud                  {Compacted,$15.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {@1,$12.src}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r1.10<1>:f    r2.0<0;1,0>:f     r2.1<0;1,0>:f    {F@1}
(W)     jmpi                                 L10384                                
L10192:
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                              {$12.src}
(W)     mov (1|M0)               r1.1<1>:d     1:w                               {Compacted}
        sync.nop                             null                             {$0.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$9} // wr:1+0, rd:1; load.slm.d32x1t.a32
L10256:
(W)     shl (1|M0)               r2.0<1>:d     r1.1<0;1,0>:d     2:w               {@1,$9.src}
(W)     add (1|M0)               r1.1<1>:d     r1.1<0;1,0>:d     1:w              
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$12} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f2.0   null<1>:ud    r1.1<0;1,0>:ud    r1.13<0;1,0>:ud  {I@1}
        sync.nop                             null                             {Compacted,$12.dst}
(W)     add (1|M0)               r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$9.dst}
(W)     mov (1|M0)               r1.2<1>:f     r3.0<0;1,0>:f                    {F@1}
(W&f2.0) jmpi                                L10256                                
L10368:
(W)     mov (1|M0)               r1.10<1>:f    r1.2<0;1,0>:f                    {F@1}
L10384:
(W)     mul (1|M0)               r2.0<1>:f     r1.11<0;1,0>:f    -1.442695e+00:f              
(W)     cmp (1|M0)    (gt)f2.0   null<1>:f     r1.11<0;1,0>:f    105.0:f               {I@1}
        sync.nop                             null                             {Compacted,$1.src}
(W)     rndz (1|M0)              r6.0<1>:f     r2.0<0;1,0>:f                    {Compacted,@2,$14.src}
(W)     cmp (1|M0)    (lt)f1.0   null<1>:f     r1.11<0;1,0>:f    -105.0:f              
(W)     mad (1|M0)               r4.3<1>:f     -r1.11<0;0>:f     r1.4<0;0>:f       r6.0<0>:f        {F@2}
(W)     math.exp (1|M0)          r5.0<1>:f     r6.0<0;1,0>:f                   
(W)     mad (1|M0)               r5.2<1>:f     r4.3<0;0>:f       r1.5<0;0>:f       r6.0<0>:f        {F@1}
(W)     mul (1|M0)               r6.1<1>:f     r5.2<0;1,0>:f     1.442695e+00:f               {F@1}
(W)     math.exp (1|M0)          r5.1<1>:f     r6.1<0;1,0>:f                    {F@1}
(W)     mul (1|M0)               r7.0<1>:f     r5.0<0;1,0>:f     r5.1<0;1,0>:f    {M@1}
(W&~f2.0) sel (1|M0)             r8.0<1>:f     r7.0<0;1,0>:f     0.0:f               {F@1}
(W&~f1.0) sel (1|M0)             r1.11<1>:f    r8.0<0;1,0>:f     inf:f               {F@1}
(W)     send.slm (1|M0)          r9       r112  null:0  0x0            0x0210001F           {$13} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r9.0<1;1,0>:ud                   {Compacted,$13.dst}
(W)     send.ugm (1|M0)          r10      r112  null:0  0x0            0x0210001F           {$14} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:ud   0x100:ud                              {Compacted}
(W)     mov (2|M0)               r11.10<1>:ub  r112.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r10.0<1;1,0>:ud                  {Compacted,$14.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$1} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        sync.nop                             null                             {Compacted,$10.src}
        add (16|M0)              r12.0<1>:q    r1.4<0;1,0>:q     r125.0<1;1,0>:q  {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$4.src}
        add (16|M16)             r14.0<1>:q    r1.4<0;1,0>:q     r123.0<1;1,0>:q  {Compacted,$11.dst}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.3<0;1,0>:d     31:w              
        shl (16|M0)              r5.0<1>:q     r12.0<1;1,0>:q    2:w               {Compacted,I@3}
        shl (16|M16)             r16.0<1>:q    r14.0<1;1,0>:q    2:w               {Compacted,@3,$0.src}
        add (16|M0)              r60.0<1>:q    r5.0<1;1,0>:q     r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r58.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
(W&~f2.0) jmpi                               L10808                                
L10776:
        mov (32|M0)              r52.0<1>:f    0.0:f                               {Compacted}
(W)     mov (1|M0)               r1.1<1>:d     0:w                               {Compacted}
(W)     jmpi                                 L16896                                
L10808:
        mov (32|M0)              r52.0<1>:f    0.0:f                               {Compacted}
(W)     mov (1|M0)               r1.2<1>:d     32:w                               {Compacted}
(W)     mov (1|M0)               r84.0<1>:d    0:w                               {Compacted}
L10832:
(W)     add (1|M0)               r1.8<1>:d     r1.0<0;1,0>:d     r84.0<0;1,0>:d   {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     0:w               {I@1}
(W&f2.0) jmpi                                L10912                                
L10880:
(W)     mov (1|M0)               r1.9<1>:d     r1.8<0;1,0>:d                   
(W)     jmpi                                 L10928                                
L10912:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2047:w              
L10928:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -1:w               {F@3}
(W)     add3 (1|M0)              r4.3<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r84.0<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@1}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r62      r7  null:0  0x0            0x08200580           {I@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L11088                                
L11072:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2048:w              
L11088:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$2.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r56      r7  null:0  0x0            0x08200580           {I@1,$3} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L11248                                
L11232:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2049:w              
L11248:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$3.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r18      r7  null:0  0x0            0x08200580           {I@1,$4} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L11408                                
L11392:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2050:w              
L11408:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$4.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r20      r7  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L11568                                
L11552:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2051:w              
L11568:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$8.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r22      r7  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L11728                                
L11712:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2052:w              
L11728:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$9.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r24      r7  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L11888                                
L11872:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2053:w              
L11888:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$10.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r26      r7  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L12048                                
L12032:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2054:w              
L12048:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -8:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      8:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      7:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$11.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r46      r7  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L12208                                
L12192:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2055:w              
L12208:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -9:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      9:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      8:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$12.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r44      r7  null:0  0x0            0x08200580           {I@1,$13} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L12368                                
L12352:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2056:w              
L12368:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -10:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      10:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      9:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$13.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r28      r7  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L12528                                
L12512:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2057:w              
L12528:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -11:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      11:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      10:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$14.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r30      r7  null:0  0x0            0x08200580           {I@1,$15} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L12688                                
L12672:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2058:w              
L12688:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -12:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      12:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      11:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$15.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r32      r7  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L12848                                
L12832:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2059:w              
L12848:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -13:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      13:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      12:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$0.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r34      r7  null:0  0x0            0x08200580           {I@1,$6} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L13008                                
L12992:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2060:w              
L13008:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -14:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      14:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      13:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$6.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r36      r7  null:0  0x0            0x08200580           {I@1,$7} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L13168                                
L13152:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2061:w              
L13168:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -15:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      15:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      14:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$7.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r38      r7  null:0  0x0            0x08200580           {I@1,$5} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L13328                                
L13312:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2062:w              
L13328:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -16:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      16:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      15:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$5.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r40      r7  null:0  0x0            0x08200580           {I@1,$1} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L13488                                
L13472:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2063:w              
L13488:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -17:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      17:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      16:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$1.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r42      r7  null:0  0x0            0x08200580           {I@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L13648                                
L13632:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2064:w              
L13648:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -18:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      18:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      17:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$2.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r50      r7  null:0  0x0            0x08200580           {I@1,$3} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L13808                                
L13792:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2065:w              
L13808:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -19:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      19:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      18:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$3.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r74      r7  null:0  0x0            0x08200580           {I@1,$4} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L13968                                
L13952:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2066:w              
L13968:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -20:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      20:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      19:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$4.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r48      r7  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L14128                                
L14112:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2067:w              
L14128:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -21:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      21:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      20:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$8.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r72      r7  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L14288                                
L14272:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2068:w              
L14288:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -22:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      22:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      21:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$9.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r82      r7  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L14448                                
L14432:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2069:w              
L14448:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -23:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      23:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      22:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$10.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r70      r7  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L14608                                
L14592:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2070:w              
L14608:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -24:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      24:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      23:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$11.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r80      r7  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L14768                                
L14752:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2071:w              
L14768:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -25:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      25:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      24:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$12.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r86      r7  null:0  0x0            0x08200580           {I@1,$13} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L14928                                
L14912:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2072:w              
L14928:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -26:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      26:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      25:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$13.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r78      r7  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L15088                                
L15072:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2073:w              
L15088:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -27:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      27:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      26:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$14.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r68      r7  null:0  0x0            0x08200580           {I@1,$15} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L15248                                
L15232:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2074:w              
L15248:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -28:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      28:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      27:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$15.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r66      r7  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L15408                                
L15392:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2075:w              
L15408:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.8<0;1,0>:d     -29:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      29:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      28:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$0.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r54      r7  null:0  0x0            0x08200580           {I@1,$6} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L15568                                
L15552:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2076:w              
L15568:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.8<0;1,0>:d     -30:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      30:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      29:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$6.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r64      r7  null:0  0x0            0x08200580           {I@1,$7} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L15728                                
L15712:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2077:w              
L15728:
(W)     and (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.8<0;1,0>:d     -31:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      31:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      30:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:q     r5.0<0;1,0>:d     12:w               {I@1}
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,@1,$7.src}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r76      r7  null:0  0x0            0x08200580           {I@1,$5} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L15888                                
L15872:
(W)     add3 (1|M0)              r1.9<1>:d     r1.0<0;0>:d       r84.0<0;0>:d      2078:w              
L15888:
(W)     shl (1|M0)               r2.0<1>:d     r84.0<0;1,0>:d    2:w              
(W)     and (1|M0)               r2.1<1>:d     r1.9<0;1,0>:d     -2048:w               {I@2}
(W)     add3 (1|M0)              r5.0<1>:d     r1.6<0;0>:d       r2.0<0;0>:d       4096:w               {I@2}
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.1<0;1,0>:d     0:w               {I@2}
        sync.nop                             null                             {$5.src}
(W)     send.slm (1|M0)          r9       r5  null:0  0x0            0x0210C500           {I@2,$1} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     add3 (1|M0)              r7.1<1>:d     r1.8<0;0>:d       -r4.3<0;0>:d      31:w               {I@1}
(W)     add3 (1|M0)              r8.0<1>:d     r1.7<0;0>:d       r2.0<0;0>:d       96:w              
(W)     shl (1|M0)               r9.4<1>:q     r7.1<0;1,0>:d     12:w               {@2,$1.dst}
(W)     send.slm (1|M0)          r12      r8  null:0  0x0            0x0210C500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (16|M0)              r13.0<1>:q    r60.0<1;1,0>:q    r9.4<0;1,0>:q    {Compacted,I@1}
        mul (32|M0)              acc0.0<1>:f   r9.0<0;1,0>:f     r62.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              acc2.0<1>:f   r9.1<0;1,0>:f     r56.0<1;1,0>:f   {Compacted,$3.dst}
        add (32|M0)              acc0.0<1>:f   r52.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@3}
        add (16|M16)             r15.0<1>:q    r58.0<1;1,0>:q    r9.4<0;1,0>:q    {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r18.0<1>:f    r9.2<0;1,0>:f     r18.0<1;1,0>:f   {Compacted,$4.dst}
        mul (32|M0)              r20.0<1>:f    r9.3<0;1,0>:f     r20.0<1;1,0>:f   {Compacted,$8.dst}
        mul (32|M0)              r22.0<1>:f    r9.4<0;1,0>:f     r22.0<1;1,0>:f   {$9.dst}
        mul (32|M0)              r24.0<1>:f    r9.5<0;1,0>:f     r24.0<1;1,0>:f   {$10.dst}
        mul (32|M0)              r26.0<1>:f    r9.6<0;1,0>:f     r26.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc2.0<1>:f   r9.7<0;1,0>:f     r46.0<1;1,0>:f   {$12.dst}
        sync.nop                             null                             {Compacted,$2.src}
        send.ugm (32|M0)         r8       r13  null:0  0x0            0x08200580           {A@1,$3} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add3 (1|M0)              r6.0<1>:d     r1.7<0;0>:d       r2.0<0;0>:d       32:w              
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r10      r6  null:0  0x0            0x0210C500           {I@1,$4} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r22.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted}
(W)     add3 (1|M0)              r7.0<1>:d     r1.7<0;0>:d       r2.0<0;0>:d       64:w              
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$1.src}
(W)     send.slm (1|M0)          r11      r7  null:0  0x0            0x0210C500           {I@1,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$8.src}
        mul (32|M0)              r6.0<1>:f     r10.0<0;1,0>:f    r44.0<1;1,0>:f   {Compacted,$13.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r28.0<1>:f    r10.1<0;1,0>:f    r28.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted,F@3}
        mul (32|M0)              r30.0<1>:f    r10.2<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$15.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r32.0<1>:f    r10.3<0;1,0>:f    r32.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r34.0<1>:f    r10.4<0;1,0>:f    r34.0<1;1,0>:f   {Compacted,$6.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r36.0<1>:f    r10.5<0;1,0>:f    r36.0<1;1,0>:f   {$7.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r34.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r38.0<1>:f    r10.6<0;1,0>:f    r38.0<1;1,0>:f   {Compacted,$5.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r36.0<1;1,0>:f   {F@3}
        mul (32|M0)              r40.0<1>:f    r10.7<0;1,0>:f    r40.0<1;1,0>:f   {$1.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r42.0<1>:f    r11.0<0;1,0>:f    r42.0<1;1,0>:f   {Compacted,$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r40.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r44.0<1>:f    r11.1<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r18.0<1>:f    r11.2<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r44.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r46.0<1>:f    r11.3<0;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,F@3}
        sync.nop                             null                             {Compacted,$3.dst}
        mul (32|M0)              acc2.0<1>:f   r12.7<0;1,0>:f    r8.0<1;1,0>:f    {$2.dst}
        mul (32|M0)              r48.0<1>:f    r11.4<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@4}
        mul (32|M0)              r20.0<1>:f    r11.5<0;1,0>:f    r82.0<1;1,0>:f  
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r48.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r50.0<1>:f    r11.6<0;1,0>:f    r70.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r52.0<1>:f    r11.7<0;1,0>:f    r80.0<1;1,0>:f  
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r50.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r22.0<1>:f    r12.0<0;1,0>:f    r86.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r14.0<1>:f    r12.1<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r22.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r16.0<1>:f    r12.2<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r24.0<1>:f    r12.3<0;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r54.0<1>:f    r12.4<0;1,0>:f    r54.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r56.0<1>:f    r12.5<0;1,0>:f    r64.0<1;1,0>:f  
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r54.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r26.0<1>:f    r12.6<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r56.0<1;1,0>:f   {F@3}
(W)     or (1|M0)                r2.3<1>:d     r1.2<0;1,0>:d     31:w              
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@2}
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r2.3<0;1,0>:d     r1.3<0;1,0>:d    {I@1}
        add (32|M0)              r52.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(W)     mov (1|M0)               r1.1<1>:d     r1.2<0;1,0>:d                   
(W&f1.0) jmpi                                L16896                                
L16848:
(W)     mov (1|M0)               r84.0<1>:d    r1.2<0;1,0>:d                   
(W)     add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     32:w              
(W)     jmpi                                 L10832                                
L16896:
(W)     cmp (32|M0)   (gt)f3.0   null<1>:d     r1.1<0;1,0>:d     r1.3<0;1,0>:d    {I@5}
(W&f3.0) jmpi                                L17216                                
L16928:
(W)     add (1|M0)               r1.2<1>:d     r1.0<0;1,0>:d     r1.1<0;1,0>:d   
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.2<0;1,0>:d     0:w               {I@1}
(W&~f2.0) jmpi                               L16992                                
L16976:
(W)     add3 (1|M0)              r1.2<1>:d     r1.0<0;0>:d       r1.1<0;0>:d       2047:w              
L16992:
(W)     and (1|M0)               r2.0<1>:d     r1.2<0;1,0>:d     -2048:w               {I@1}
(W)     shl (1|M0)               r2.1<1>:d     r1.1<0;1,0>:d     2:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.0<0;0>:d       r1.1<0;0>:d       -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r5.0<1>:d     r1.6<0;0>:d       r2.1<0;0>:d       4096:w               {I@2}
(W&f0.0) sel (1|M0)              r5.1<1>:d     r1.1<0;1,0>:d     r4.3<0;1,0>:d    {I@2}
(W)     send.slm (1|M0)          r6       r5  null:0  0x0            0x02108500           {I@1,$4} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     shl (1|M0)               r6.1<1>:q     r5.1<0;1,0>:d     12:w               {$4.dst}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.1<0;1,0>:d     r1.3<0;1,0>:d   
        add (16|M0)              r7.0<1>:q     r60.0<1;1,0>:q    r6.1<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r9.0<1>:q     r58.0<1;1,0>:q    r6.1<0;1,0>:q    {Compacted}
        send.ugm (32|M0)         r12      r7  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r12.0<1;1,0>:f   {Compacted,$8.dst}
        add (32|M0)              r52.0<1>:f    r52.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f3.0) jmpi                               L17216                                
L17184:
(W)     add (1|M0)               r1.1<1>:d     r1.1<0;1,0>:d     1:w              
(W)     jmpi                                 L16928                                
L17216:
        add (16|M0)              r8.0<1>:q     r121.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted}
        add (16|M16)             r10.0<1>:q    r119.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted,$1.src}
        send.ugm (32|M0)         r12      r8  null:0  0x0            0x08200580           {A@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r2.0<1>:f     r1.10<0;1,0>:f    r1.11<0;1,0>:f  
(W)     mov (1|M0)               r2.3<1>:f     0x4F800000:f                              
(W)     and (1|M0)    (eq)f0.0   r2.1<1>:d     r2.0<0;1,0>:d     2139095040:d               {F@2}
(W)     and (1|M0)               r7.0<1>:d     r2.0<0;1,0>:d     8388607:d              
(W)     mov (16|M0)              r127.0<1>:f   r112.0<1;1,0>:f                  {$7.dst}
(W)     cmp (1|M0)    (ge)f1.0   null<1>:ud    r2.1<0;1,0>:ud    0x64000000:ud              {I@2}
(W&f0.0) sel (1|M0)              r4.3<1>:f     r2.3<0;1,0>:f     1.0:f               {F@2}
(W&~f1.0) sel (1|M0)             r5.0<1>:f     r4.3<0;1,0>:f     0x2F800000:f               {F@1}
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r7.0<0;1,0>:d     0:w               {A@1}
(W&~f1.0) cmp (32|M0) (eq)f1.0   null<1>:d     r2.1<0;1,0>:d     0:w              
(W)     mul (1|M0)               r5.1<1>:f     r2.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted}
(W)     not (1|M0)               f0.0<1>:ud    f1.0<0;1,0>:ud                  
(W)     math.inv (1|M0)          r6.0<1>:f     r5.1<0;1,0>:f                    {F@1}
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:f     r52.0<1;1,0>:f    r2.0<0;1,0>:f    {I@1}
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r52.0<1;1,0>:f   {Compacted,M@1}
        mul (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r5.0<0;1,0>:f   
(~f0.0) sel (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   1.0:f              
        mul (32|M0)              acc2.0<1>:f   r12.0<1;1,0>:f    -1.442695e+00:f               {$9.dst}
        rndz (32|M0)             r14.0<1>:f    acc2.0<1;1,0>:f                 
        mad (32|M0)              acc2.0<1>:f   -r12.0<1;0>:f     r14.0<1;0>:f      r1.4<0>:f        {F@1}
        mad (32|M0)              acc2.0<1>:f   acc2.0<1;0>:f     r14.0<1;0>:f      r1.5<0>:f       
        mul (32|M0)              r6.0<1>:f     acc2.0<1;1,0>:f   1.442695e+00:f              
        math.exp (32|M0)         r16.0<1>:f    r14.0<1;1,0>:f                  
        cmp (32|M0)   (gt)f0.0   null<1>:f     r12.0<1;1,0>:f    105.0:f              
        math.exp (32|M0)         r18.0<1>:f    r6.0<1;1,0>:f                    {F@2}
        mul (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,M@1}
        add (32|M0)              r20.0<1>:f    acc2.0<1;1,0>:f   1.0:f               {Compacted}
        math.inv (32|M0)         r22.0<1>:f    r20.0<1;1,0>:f                   {F@1}
        cmp (32|M0)   (lt)f3.0   null<1>:f     r12.0<1;1,0>:f    -105.0:f              
(~f0.0) sel (32|M0)              acc2.0<1>:f   r22.0<1;1,0>:f    1.0:f               {M@1}
(~f3.0) sel (32|M0)              r8.0<1>:f     acc2.0<1;1,0>:f   0.0:f              
        mul (32|M0)              r10.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {F@1}
        shr (32|M0)              r24.0<1>:ud   r10.0<1;1,0>:ud   16:w               {F@1}
        and (32|M0)              r28.0<1>:d    r24.0<1;1,0>:d    1:w               {I@1}
        add3 (32|M0)             r14.0<1>:d    r28.0<1;0>:d      r10.0<1;0>:d      32767:w               {I@1}
        add (16|M0)              r16.0<1>:q    r121.0<1;1,0>:q   r3.6<0;1,0>:q   
        add (16|M16)             r18.0<1>:q    r119.0<1;1,0>:q   r3.6<0;1,0>:q   
        and (32|M0)              r6.0<1>:d     r14.0<1;1,0>:d    -65536:d               {I@3}
        send.ugm (32|M0)         null     r16  r6:2  0x0            0x08000584           {I@1,$10} // wr:4+2, rd:0; store.ugm.d32.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$11} // wr:1+0, rd:0; end of thread
L17856:
(W)     mov (16|M0)              null<1>:ud    0xF268A3:ud                             
(W)     mov (16|M0)              null<1>:ud    0xF2137EC2:ud                             
(W)     mov (16|M0)              null<1>:ud    0x0:ud                             
(W)     mov (16|M0)              null<1>:ud    0x1:ud                             
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
