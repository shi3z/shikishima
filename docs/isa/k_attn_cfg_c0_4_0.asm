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
        mov (16|M16)             r8.0<4>:uw    r1.16<1;1,0>:uw                 
(W)     shr (1|M0)               r4.3<1>:ud    r11.0<0;1,0>:ud   4:w               {@2,$2.dst}
(W)     mov (1|M0)               r2.0<1>:uq    r2.2<0;1,0>:uq                  
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0xC00:uw              {I@2}
(W)     mad (1|M0)               r4.5<1>:d     r5.0<0;0>:d       r4.3<0;0>:d       -24:w              
(W)     mach (1|M0)              r14.0<1>:d    r4.3<0;1,0>:ud    0xC00:ud             
(W)     mul (1|M0)               r4.6<1>:ud    r4.3<0;1,0>:ud    0xC00:uw             
(W)     shl (1|M0)               r10.2<1>:d    r4.5<0;1,0>:d     7:w               {I@3}
(W)     mov (1|M0)               r4.7<1>:d     r14.0<0;1,0>:d                   {I@3}
(W)     send.ugm (1|M0)          r10      r2  null:0  0x0            0x02108580           {I@2,$3} // wr:1+0, rd:1; load.ugm.d32x1t.a64
(W)     add (1|M0)               r5.1<1>:q     r4.3<0;1,0>:q     r10.2<0;1,0>:ud  {@1,$3.dst}
        mov (32|M0)              r106.0<1>:d   r1.0<1;1,0>:uw                  
        add (16|M0)              r15.0<1>:q    r5.1<0;1,0>:q     r6.0<4;1,0>:uw   {I@2}
        add (16|M16)             r17.0<1>:q    r5.1<0;1,0>:q     r8.0<4;1,0>:uw  
        shl (16|M0)              r121.0<1>:q   r15.0<1;1,0>:q    2:w               {Compacted,I@2}
        shl (16|M16)             r118.0<1>:q   r17.0<1;1,0>:q    2:w               {Compacted,I@2}
        add (16|M0)              r20.0<1>:q    r121.0<1;1,0>:q   r2.3<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r22.0<1>:q    r118.0<1;1,0>:q   r2.3<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r6       r20  null:0  0x0            0x08200580           {I@1,$4} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     mov (1|M0)               r2.6<1>:w     r3.56<0;1,0>:b                   {$1.dst}
        shl (32|M0)              r12.0<1>:d    r106.0<1;1,0>:d   2:w              
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x600:uw             
(W)     and (1|M0)               r10.3<1>:d    r4.5<0;1,0>:d     255:w              
(W)     and (1|M0)               r3.29<1>:w    r2.6<0;1,0>:w     1:w               {I@4}
(W)     mach (1|M0)              r11.0<1>:d    r4.3<0;1,0>:ud    0x600:ud             
(W)     mul (1|M0)               r4.8<1>:ud    r4.3<0;1,0>:ud    0x600:uw             
(W)     shl (1|M0)               r2.0<1>:d     r4.5<0;1,0>:d     4:w              
(W)     mov (1|M0)               r4.16<2>:b    r3.29<0;1,0>:w                   {I@4}
(W)     mul (1|M0)               acc0.0<1>:ud  r10.3<0;1,0>:ud   0xAAAB:uw             
(W)     mov (1|M0)               r4.9<1>:d     r11.0<0;1,0>:d                   {I@5}
(W)     mach (1|M0)              r19.0<1>:ud   r10.3<0;1,0>:ud   0xAAAAAAAB:ud             
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x60:uw             
(W)     shl (1|M0)               r5.0<1>:q     r2.0<0;1,0>:ud    2:w               {I@6}
(W)     mov (1|M0)               r10.2<1>:w    r4.16<0;1,0>:ub                  {I@6}
(W)     add (1|M0)               r19.1<1>:q    r4.4<0;1,0>:q     r3.0<0;1,0>:q    {I@5}
(W)     mach (1|M0)              r14.0<1>:d    r4.3<0;1,0>:ud    0x60:ud             
(W)     mul (1|M0)               r4.10<1>:ud   r4.3<0;1,0>:ud    0x60:uw             
(W)     cmp (32|M0)   (eq)f0.0   null<2>:w     r10.2<0;1,0>:w    0:w               {I@4}
(W)     add (1|M0)               r2.0<1>:q     r19.1<0;1,0>:q    r5.0<0;1,0>:q    {I@4}
(W)     mov (1|M0)               r4.11<1>:d    r14.0<0;1,0>:d                   {I@4}
(W)     shl (1|M0)               r2.4<1>:q     r4.5<0;1,0>:ud    2:w              
(W)     add (1|M0)               r1.13<1>:d    r10.0<0;1,0>:d    r4.3<0;1,0>:d   
(W)     add (1|M0)               r8.0<1>:q     r4.5<0;1,0>:q     r3.1<0;1,0>:q    {Compacted,I@3}
(W)     sel (1|M0)    (ge)f0.0   r5.0<1>:d     r1.13<0;1,0>:d    1023:w               {Compacted,I@2}
(W)     mov (1|M0)               r11.0<1>:q    r2.0<0;1,0>:q                   
(W)     add (1|M0)               r9.0<1>:d     r5.0<0;1,0>:d     -1023:w               {Compacted,I@2}
(W)     add (1|M0)               r16.0<1>:q    r8.0<0;1,0>:q     r2.4<0;1,0>:q    {Compacted}
(W&~f0.0) sel (1|M0)             r120.0<1>:d   r9.0<0;1,0>:d     0:w               {I@2}
(W)     send.ugm (1|M0)          r113     r2  null:0  0x0            0x0210C580           {$5} // wr:1+0, rd:1; load.ugm.d32x8t.a64
(W)     send.ugm (1|M0)          r1       r11  null:0  0x20000            0x0210C580           {$6} // wr:1+0, rd:1; load.ugm.d32x8t.a64.flat[A+0x20]
(W)     send.ugm (1|M0)          r123     r16  null:0  0x0            0x02108580           {I@2,$7} // wr:1+0, rd:1; load.ugm.d32x1t.a64
(W)     mov (1|M0)               r1.8<1>:d     r2.2<0;1,0>:ud                   {$6.dst}
(W)     add (1|M0)               r1.12<1>:d    r1.13<0;1,0>:d    -r120.0<0;1,0>:d {I@2}
        send.slm (32|M0)         null     r12  r6:2  0x1000000            0x04000504           {$4} // wr:2+2, rd:0; store.slm.d32.a32.flat[A+0x1000]
(W)     send.slm (1|M0)          r14      r112  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r14.0<1;1,0>:ud                  {Compacted,$8.dst}
(W)     send.ugm (1|M0)          r15      r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:f    3.58732e-43:f                              
(W)     mov (2|M0)               r11.10<1>:ub  r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r15.0<1;1,0>:ud                  {Compacted,$9.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f2.0   null<1>:d     r1.12<0;1,0>:d    r106.0<1;1,0>:d 
(W)     shl (1|M0)               r2.0<1>:d     r19.0<0;1,0>:d    6:w               {$5.src}
(W)     mov (1|M0)               r1.14<1>:ud   f2.0<0;1,0>:ud                  
(W)     and (1|M0)               r1.9<1>:d     r2.0<0;1,0>:d     32640:w               {I@2}
(~f2.0) goto (32|M0)                         L1296                  L1296                
L1264:
        mov (32|M0)              r114.0<1>:ud  0x0:ud                             
        goto (32|M0)                         L1296                  L6272                
L1296:
        join (32|M0)                         L6272                                
L1312:
        mov (32|M0)              r114.0<1>:f   0.0:f                               {Compacted,I@3}
        mov (32|M0)              r104.0<1>:d   r106.0<1;1,0>:d                  {Compacted}
(W)     shl (1|M0)               r2.0<1>:d     r1.9<0;1,0>:d     2:w              
(W)     add (1|M0)               r1.5<1>:q     r3.2<0;1,0>:q     r2.0<0;1,0>:ud   {I@1}
L1360:
        add (32|M0)   (lt)f2.0   r110.0<1>:d   r120.0<0;1,0>:d   r104.0<1;1,0>:d 
(~f2.0) mov (32|M0)              r38.0<1>:d    r110.0<1;1,0>:d                  {I@1}
(f2.0)  add3 (32|M0)             r38.0<1>:d    r120.0<0;0>:d     r104.0<1;0>:d     2047:w              
        sync.nop                             null                             {Compacted,$11.src}
        and (32|M0)              r6.0<1>:d     r38.0<1;1,0>:d    -2048:w               {Compacted,@1,$4.src}
        add3 (32|M0)             r10.0<1>:d    r120.0<0;0>:d     r104.0<1;0>:d     -r6.0<1>:d       {@1,$10.src}
(f0.0)  sel (32|M0)              r16.0<1>:d    r104.0<1;1,0>:d   r10.0<1;1,0>:d   {@1,$7.src}
        mov (16|M0)              r18.0<2>:ud   r16.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r20.0<2>:ud   r17.0<1;1,0>:ud                  {Compacted}
        shl (16|M0)              r22.0<1>:q    r18.0<2;1,0>:d    12:w               {I@2}
        shl (16|M16)             r24.0<1>:q    r20.0<2;1,0>:d    12:w               {I@2}
        add (16|M0)              r26.0<1>:q    r1.5<0;1,0>:q     r22.0<1;1,0>:q   {Compacted,I@2}
        add (16|M16)             r28.0<1>:q    r1.5<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@2}
        send.ugm (32|M0)         r30      r26  null:0  0x0            0x08803580           {I@1,$12} // wr:4+0, rd:8; load.ugm.d32x4.a64
        send.ugm (32|M0)         r38      r26  null:0  0x10000            0x08803580           {$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x10]
        send.ugm (32|M0)         r46      r26  null:0  0x20000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x20]
        send.ugm (32|M0)         r54      r26  null:0  0x30000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x30]
        send.ugm (32|M0)         r62      r26  null:0  0x40000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x40]
        send.ugm (32|M0)         r70      r26  null:0  0x50000            0x08803580           {$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x50]
        send.ugm (32|M0)         r78      r26  null:0  0x60000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x60]
        send.ugm (32|M0)         r86      r26  null:0  0x70000            0x08803580           {$3} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x70]
(W)     mov (1|M0)               r2.0<1>:ud    0x1000:uw                             
(W)     mov (1|M0)               r5.0<1>:ud    0x1020:uw                             
(W)     send.slm (1|M0)          r12      r2  null:0  0x0            0x0210C500           {I@2,$6} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r8.0<1>:ud    0x1040:uw                             
(W)     mov (1|M0)               r9.0<1>:ud    0x1060:uw                             
(W)     send.slm (1|M0)          r13      r5  null:0  0x0            0x0210C500           {I@3,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     send.slm (1|M0)          r14      r8  null:0  0x0            0x0210C500           {I@2,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     send.slm (1|M0)          r15      r9  null:0  0x0            0x0210C500           {I@1,$5} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r2.0<1>:ud    0x1080:uw                              {$6.src}
(W)     mov (1|M0)               r5.0<1>:ud    0x10A0:uw                              {$8.src}
        add (32|M0)              r108.0<1>:d   r1.13<0;1,0>:d    -r110.0<1;1,0>:d {Compacted}
        cmp (32|M0)   (lt)f2.0   null<1>:d     r108.0<1;1,0>:d   1024:w               {I@1}
        sync.nop                             null                             {Compacted,$6.dst}
        mul (32|M0)              r6.0<1>:f     r12.0<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              acc2.0<1>:f   r12.1<0;1,0>:f    r32.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.5<0;1,0>:f    r40.0<1;1,0>:f   {$13.dst}
        mul (32|M0)              r10.0<1>:f    r12.4<0;1,0>:f    r38.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted,F@4}
        sync.nop                             null                             {Compacted,$5.src}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r34.0<1;1,0>:f   {Compacted,$9.src}
        add (32|M0)              acc0.0<1>:f   r10.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r16.0<1>:f    r12.3<0;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r18.0<1>:f    r12.6<0;1,0>:f    r42.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r24.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r94.0<1>:f    acc2.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r20.0<1>:f    r13.0<0;1,0>:f    r46.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              r22.0<1>:f    r13.1<0;1,0>:f    r48.0<1;1,0>:f  
        mul (32|M0)              acc0.0<1>:f   r12.7<0;1,0>:f    r44.0<1;1,0>:f  
        mul (32|M0)              r6.0<1>:f     r13.4<0;1,0>:f    r54.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              acc2.0<1>:f   r13.5<0;1,0>:f    r56.0<1;1,0>:f  
        mul (32|M0)              r96.0<1>:f    r13.2<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              r98.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              r10.0<1>:f    r24.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r18.0<1>:f    r14.1<0;1,0>:f    r64.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r16.0<1>:f    r14.0<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r13.6<0;1,0>:f    r58.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r8.0<1>:f     r13.3<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              r30.0<1>:f    r94.0<1;1,0>:f    0.0:f               {Compacted}
        add (32|M0)              r32.0<1>:f    r98.0<1;1,0>:f    r96.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r38.0<1>:f    r14.2<0;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@7}
        send.ugm (32|M0)         r48      r26  null:0  0x80000            0x08803580           {F@6,$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x80]
        mul (32|M0)              r36.0<1>:f    r13.7<0;1,0>:f    r60.0<1;1,0>:f  
        mul (32|M0)              r24.0<1>:f    r14.4<0;1,0>:f    r70.0<1;1,0>:f   {Compacted,$1.dst}
        add (32|M0)              r34.0<1>:f    r30.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r20.0<1>:f    r32.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r14.5<0;1,0>:f    r72.0<1;1,0>:f  
        send.ugm (32|M0)         r56      r26  null:0  0x90000            0x08803580           {F@5,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x90]
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r14.3<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$5.dst}
        mul (32|M0)              r10.0<1>:f    r15.1<0;1,0>:f    r80.0<1;1,0>:f   {Compacted,$2.dst}
        add (32|M0)              r6.0<1>:f     r34.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              r8.0<1>:f     r15.0<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r24.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc0.0<1>:f   r14.6<0;1,0>:f    r74.0<1;1,0>:f  
        mul (32|M0)              r30.0<1>:f    r14.7<0;1,0>:f    r76.0<1;1,0>:f  
        add (32|M0)              r16.0<1>:f    r44.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r12.0<1>:f    r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              r20.0<1>:f    r15.2<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    r8.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r18.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r24.0<1>:f    r12.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r36.0<1>:f    r18.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc2.0<1>:f   r22.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r16      r26  null:0  0xA0000            0x08803580           {F@1,$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xA0]
        send.ugm (32|M0)         r64      r26  null:0  0xB0000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xB0]
        send.ugm (32|M0)         r72      r26  null:0  0xC0000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xC0]
        mul (32|M0)              r32.0<1>:f    r15.4<0;1,0>:f    r86.0<1;1,0>:f   {Compacted,$3.dst}
        mul (32|M0)              r34.0<1>:f    r15.5<0;1,0>:f    r88.0<1;1,0>:f  
        add (32|M0)              r42.0<1>:f    r24.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              r6.0<1>:f     r32.0<1;1,0>:f    r34.0<1;1,0>:f   {F@2}
        send.ugm (32|M0)         r30      r26  null:0  0xD0000            0x08803580           {F@1,$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xD0]
        send.ugm (32|M0)         r94      r26  null:0  0xE0000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xE0]
        mul (32|M0)              r38.0<1>:f    r15.3<0;1,0>:f    r84.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r40.0<1>:f    r15.6<0;1,0>:f    r90.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {F@2}
(W)     send.slm (1|M0)          r10      r2  null:0  0x0            0x0210C500           {$3} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r46.0<1>:f    r15.7<0;1,0>:f    r92.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   r42.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$3.dst}
        mul (32|M0)              r14.0<1>:f    r10.0<0;1,0>:f    r48.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              acc0.0<1>:f   r10.1<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r10.5<0;1,0>:f    r58.0<1;1,0>:f   {$13.dst}
        mul (32|M0)              r38.0<1>:f    r10.4<0;1,0>:f    r56.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r11      r5  null:0  0x0            0x0210C500           {$6} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r24.0<1>:f    r10.2<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r38.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x10C0:uw                             
        mul (32|M0)              r40.0<1>:f    r10.3<0;1,0>:f    r54.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r10.6<0;1,0>:f    r60.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x10E0:uw                             
        add (32|M0)              r46.0<1>:f    acc2.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r88.0<1>:f    acc0.0<1;1,0>:f   r40.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$6.dst}
        mul (32|M0)              r44.0<1>:f    r11.0<0;1,0>:f    r16.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc2.0<1>:f   r10.7<0;1,0>:f    r62.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r6.0<1>:f     r11.1<0;1,0>:f    r18.0<1;1,0>:f   {Compacted,$8.src}
        mul (32|M0)              r14.0<1>:f    r11.4<0;1,0>:f    r64.0<1;1,0>:f   {$15.dst}
        mul (32|M0)              acc0.0<1>:f   r11.5<0;1,0>:f    r66.0<1;1,0>:f  
        send.ugm (32|M0)         r80      r26  null:0  0xF0000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xF0]
        mul (32|M0)              r90.0<1>:f    r11.2<0;1,0>:f    r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              r92.0<1>:f    r44.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r38.0<1>:f    r46.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r42.0<1>:f    r12.1<0;1,0>:f    r74.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r40.0<1>:f    r12.0<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r11.6<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r24.0<1>:f    r11.3<0;1,0>:f    r22.0<1;1,0>:f   {Compacted}
        add (32|M0)              r48.0<1>:f    r8.0<1;1,0>:f     r88.0<1;1,0>:f   {Compacted}
        add (32|M0)              r50.0<1>:f    r92.0<1;1,0>:f    r90.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r40.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r54.0<1>:f    r11.7<0;1,0>:f    r70.0<1;1,0>:f  
        mul (32|M0)              r16.0<1>:f    r12.4<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$1.dst}
        add (32|M0)              r52.0<1>:f    r48.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r50.0<1;1,0>:f    r24.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r32.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r38.0<1>:f    r13.1<0;1,0>:f    r96.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              r24.0<1>:f    r13.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@7}
        add (32|M0)              r18.0<1>:f    r44.0<1;1,0>:f    r54.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@7}
        mul (32|M0)              r46.0<1>:f    r12.7<0;1,0>:f    r36.0<1;1,0>:f  
        add (32|M0)              r44.0<1>:f    r24.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@5}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r34.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r32      r26  null:0  0x100000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x100]
        send.ugm (32|M0)         r54      r26  null:0  0x110000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x110]
        mul (32|M0)              r20.0<1>:f    r12.3<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r52.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
        add (32|M0)              r42.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r10.0<1>:f    r14.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r98.0<1;1,0>:f   {Compacted}
        add (32|M0)              r50.0<1>:f    r42.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r16.0<1>:f    r10.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   r44.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@3}
        send.ugm (32|M0)         r40      r26  null:0  0x120000            0x08803580           {F@1,$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x120]
        send.ugm (32|M0)         r62      r26  null:0  0x130000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x130]
        send.ugm (32|M0)         r70      r26  null:0  0x140000            0x08803580           {$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x140]
        send.ugm (32|M0)         r88      r26  null:0  0x150000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x150]
        mul (32|M0)              r52.0<1>:f    r13.3<0;1,0>:f    r100.0<1;1,0>:f 
        send.ugm (32|M0)         r96      r26  null:0  0x160000            0x08803580           {F@1,$3} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x160]
        mul (32|M0)              r48.0<1>:f    r13.4<0;1,0>:f    r80.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              r8.0<1>:f     r13.5<0;1,0>:f    r82.0<1;1,0>:f  
(W)     mov (1|M0)               r2.0<1>:ud    0x1100:uw                             
        mul (32|M0)              r18.0<1>:f    r13.6<0;1,0>:f    r84.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r48.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@2}
        add (32|M0)              r20.0<1>:f    r16.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f  
(W)     send.slm (1|M0)          r8       r2  null:0  0x0            0x0210C500           {A@1,$6} // wr:1+0, rd:1; load.slm.d32x8t.a32
        send.ugm (32|M0)         r78      r26  null:0  0x170000            0x08803580           {$8} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x170]
        mul (32|M0)              r30.0<1>:f    r13.7<0;1,0>:f    r86.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r10.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$6.dst}
        mul (32|M0)              r14.0<1>:f    r8.0<0;1,0>:f     r32.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              acc0.0<1>:f   r8.1<0;1,0>:f     r34.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r5.0<1>:ud    0x1120:uw                             
        mul (32|M0)              acc2.0<1>:f   r8.5<0;1,0>:f     r56.0<1;1,0>:f   {$14.dst}
        mul (32|M0)              r18.0<1>:f    r8.4<0;1,0>:f     r54.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r9       r5  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r16.0<1>:f    r8.2<0;1,0>:f     r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r18.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x1140:uw                             
        mul (32|M0)              r20.0<1>:f    r8.3<0;1,0>:f     r38.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r22.0<1>:f    r8.6<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$12} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x1160:uw                             
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r22.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r48.0<1>:f    acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$13} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r24.0<1>:f    r9.0<0;1,0>:f     r40.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              acc2.0<1>:f   r8.7<0;1,0>:f     r60.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$13.src}
        mul (32|M0)              r6.0<1>:f     r9.1<0;1,0>:f     r42.0<1;1,0>:f   {Compacted,$12.src}
        mul (32|M0)              r14.0<1>:f    r9.4<0;1,0>:f     r62.0<1;1,0>:f   {$0.dst}
        mul (32|M0)              acc0.0<1>:f   r9.5<0;1,0>:f     r64.0<1;1,0>:f  
        mul (32|M0)              r50.0<1>:f    r9.2<0;1,0>:f     r44.0<1;1,0>:f   {Compacted}
        add (32|M0)              r52.0<1>:f    r24.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r18.0<1>:f    r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$12.dst}
        mul (32|M0)              r22.0<1>:f    r12.1<0;1,0>:f    r72.0<1;1,0>:f   {Compacted,$1.dst}
        mul (32|M0)              r20.0<1>:f    r12.0<0;1,0>:f    r70.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.6<0;1,0>:f     r66.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r16.0<1>:f    r9.3<0;1,0>:f     r46.0<1;1,0>:f   {Compacted}
        add (32|M0)              r32.0<1>:f    r10.0<1;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        add (32|M0)              r34.0<1>:f    r52.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r24.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r10.0<1>:f    r12.2<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r38.0<1>:f    r9.7<0;1,0>:f     r68.0<1;1,0>:f  
        mul (32|M0)              r30.0<1>:f    r12.4<0;1,0>:f    r88.0<1;1,0>:f   {Compacted,$2.dst}
        add (32|M0)              r36.0<1>:f    r32.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r34.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r90.0<1;1,0>:f  
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r42.0<1>:f    r12.3<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    r24.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r14.0<1>:f    r36.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$13.dst}
        mul (32|M0)              r18.0<1>:f    r13.1<0;1,0>:f    r98.0<1;1,0>:f   {$3.dst}
        mul (32|M0)              r32.0<1>:f    r12.7<0;1,0>:f    r94.0<1;1,0>:f  
        mul (32|M0)              r16.0<1>:f    r13.0<0;1,0>:f    r96.0<1;1,0>:f   {Compacted}
        add (32|M0)              r20.0<1>:f    r44.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r8.0<1>:f     r14.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r24.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    r8.0<1;1,0>:f     r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r36.0<1>:f    r22.0<1;1,0>:f    r32.0<1;1,0>:f   {F@3}
        send.ugm (32|M0)         r16      r26  null:0  0x180000            0x08803580           {F@1,$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x180]
        send.ugm (32|M0)         r48      r26  null:0  0x190000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x190]
        send.ugm (32|M0)         r56      r26  null:0  0x1A0000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1A0]
        send.ugm (32|M0)         r64      r26  null:0  0x1B0000            0x08803580           {$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1B0]
        send.ugm (32|M0)         r86      r26  null:0  0x1C0000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1C0]
        mul (32|M0)              r34.0<1>:f    r13.4<0;1,0>:f    r78.0<1;1,0>:f   {Compacted,$8.dst}
        mul (32|M0)              r10.0<1>:f    r13.5<0;1,0>:f    r80.0<1;1,0>:f  
        add (32|M0)              r42.0<1>:f    r30.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r34.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted,F@2}
        send.ugm (32|M0)         r30      r26  null:0  0x1D0000            0x08803580           {F@1,$3} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1D0]
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r100.0<1;1,0>:f  {Compacted}
        send.ugm (32|M0)         r94      r26  null:0  0x1E0000            0x08803580           {F@1,$6} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1E0]
        send.ugm (32|M0)         r72      r26  null:0  0x1F0000            0x08803580           {$8} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1F0]
        mul (32|M0)              r38.0<1>:f    r13.3<0;1,0>:f    r102.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc2.0<1>:f   r24.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
(W)     mov (1|M0)               r2.0<1>:ud    0x1180:uw                             
        mul (32|M0)              r40.0<1>:f    r13.6<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@3}
(W)     send.slm (1|M0)          r10      r2  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r46.0<1>:f    r13.7<0;1,0>:f    r84.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   r42.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r14.0<1>:f    r10.0<0;1,0>:f    r16.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc0.0<1>:f   r10.1<0;1,0>:f    r18.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r5.0<1>:ud    0x11A0:uw                             
        mul (32|M0)              acc2.0<1>:f   r10.5<0;1,0>:f    r50.0<1;1,0>:f   {$15.dst}
        mul (32|M0)              r26.0<1>:f    r10.4<0;1,0>:f    r48.0<1;1,0>:f   {Compacted,$8.src}
(W)     send.slm (1|M0)          r11      r5  null:0  0x0            0x0210C500           {I@1,$12} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r24.0<1>:f    r10.2<0;1,0>:f    r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r26.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x11C0:uw                             
        mul (32|M0)              r28.0<1>:f    r10.3<0;1,0>:f    r22.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r38.0<1>:f    r10.6<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$13} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x11E0:uw                             
        add (32|M0)              r42.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$14} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$12.dst}
        mul (32|M0)              r40.0<1>:f    r11.1<0;1,0>:f    r58.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              acc2.0<1>:f   r10.7<0;1,0>:f    r54.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$14.src}
        mul (32|M0)              r6.0<1>:f     r11.0<0;1,0>:f    r56.0<1;1,0>:f   {Compacted,$13.src}
        mul (32|M0)              r14.0<1>:f    r11.4<0;1,0>:f    r64.0<1;1,0>:f   {$1.dst}
        mul (32|M0)              acc0.0<1>:f   r11.5<0;1,0>:f    r66.0<1;1,0>:f  
        mul (32|M0)              r46.0<1>:f    r11.2<0;1,0>:f    r60.0<1;1,0>:f   {Compacted}
        add (32|M0)              r80.0<1>:f    r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r18.0<1>:f    r42.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$13.dst}
        mul (32|M0)              r24.0<1>:f    r12.0<0;1,0>:f    r86.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              r26.0<1>:f    r12.1<0;1,0>:f    r88.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r11.6<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r20.0<1>:f    r11.3<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        add (32|M0)              r16.0<1>:f    r8.0<1;1,0>:f     r44.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    r80.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r38.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r90.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r24.0<1;1,0>:f    r26.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r40.0<1>:f    r11.7<0;1,0>:f    r70.0<1;1,0>:f  
        mul (32|M0)              r42.0<1>:f    r12.4<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$3.dst}
        add (32|M0)              r28.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r22.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r32.0<1;1,0>:f  
        add (32|M0)              r48.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@7}
        mul (32|M0)              r46.0<1>:f    r12.3<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    r38.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r14.0<1>:f    r28.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r42.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$14.dst}
        mul (32|M0)              r16.0<1>:f    r13.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted,$6.dst}
        mul (32|M0)              r18.0<1>:f    r13.1<0;1,0>:f    r96.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r34.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r24.0<1>:f    r12.7<0;1,0>:f    r36.0<1;1,0>:f  
        add (32|M0)              r20.0<1>:f    r48.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r10.0<1>:f    r14.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r98.0<1;1,0>:f   {Compacted}
        add (32|M0)              r26.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {F@7}
        mul (32|M0)              r8.0<1>:f     r13.5<0;1,0>:f    r74.0<1;1,0>:f   {$8.dst}
        mul (32|M0)              r28.0<1>:f    r13.4<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r13.3<0;1,0>:f    r100.0<1;1,0>:f  {Compacted}
        add (32|M0)              r38.0<1>:f    r10.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r24.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              acc2.0<1>:f   r26.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@6}
        mul (32|M0)              r44.0<1>:f    r13.6<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r28.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@6}
        add (32|M0)              r46.0<1>:f    r38.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r32.0<1>:f    r13.7<0;1,0>:f    r78.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              acc0.0<1>:f   r46.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r116.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(f2.0)  goto (32|M0)                         L5168                  L5168                
L5144:
        mov (32|M0)              r44.0<1>:ud   0x0:ud                              {Compacted,F@4}
        goto (32|M0)                         L5168                  L6096                
L5168:
        join (32|M0)                         L6096                                
L5184:
        mov (16|M0)              r6.0<2>:ud    r108.0<1;1,0>:ud                 {Compacted}
        mov (16|M16)             r8.0<2>:ud    r109.0<1;1,0>:ud                 {Compacted}
        shl (16|M0)              r10.0<1>:q    r6.0<2;1,0>:d     1:w               {I@2}
        shl (16|M16)             r12.0<1>:q    r8.0<2;1,0>:d     1:w               {I@2}
        add (16|M0)              r14.0<1>:q    r10.0<1;1,0>:q    r3.3<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r16.0<1>:q    r12.0<1;1,0>:q    r3.3<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r18      r14  null:0  0x0            0x08200B80           {I@1,$15} // wr:4+0, rd:2; load.ugm.d16u32.a64
        send.ugm (32|M0)         r20      r14  null:0  0x800000            0x08200B80           {$0} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x800]
        send.ugm (32|M0)         r22      r14  null:0  0x1000000            0x08200B80           {$1} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1000]
        send.ugm (32|M0)         r26      r14  null:0  0x2000000            0x08200B80           {$2} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2000]
        send.ugm (32|M0)         r24      r14  null:0  0x1800000            0x08200B80           {$3} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1800]
        send.ugm (32|M0)         r28      r14  null:0  0x2800000            0x08200B80           {$6} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2800]
        send.ugm (32|M0)         r30      r14  null:0  0x3000000            0x08200B80           {F@3,$8} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3000]
        send.ugm (32|M0)         r32      r14  null:0  0x3800000            0x08200B80           {F@2,$9} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3800]
        send.ugm (32|M0)         r34      r14  null:0  0x4000000            0x08200B80           {$12} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4000]
        send.ugm (32|M0)         r36      r14  null:0  0x6800000            0x08200B80           {$13} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6800]
        send.ugm (32|M0)         r6       r14  null:0  0x4800000            0x08200B80           {$14} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4800]
        send.ugm (32|M0)         r8       r14  null:0  0x5000000            0x08200B80           {$7} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5000]
        send.ugm (32|M0)         r10      r14  null:0  0x5800000            0x08200B80           {$4} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5800]
        send.ugm (32|M0)         r12      r14  null:0  0x6000000            0x08200B80           {$10} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6000]
        send.ugm (32|M0)         r38      r14  null:0  0x7000000            0x08200B80           {$5} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7000]
        send.ugm (32|M0)         r40      r14  null:0  0x7800000            0x08200B80           {$11} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7800]
        shl (32|M0)              r42.0<1>:d    r18.0<1;1,0>:ud   16:w               {$15.dst}
        shl (32|M0)              r44.0<1>:d    r20.0<1;1,0>:ud   16:w               {$0.dst}
        sync.nop                             null                             {Compacted,I@2}
        mul (32|M0)              acc0.0<1>:f   r113.0<0;1,0>:f   r42.0<1;1,0>:f   {Compacted,$5.dst}
        mul (32|M0)              acc2.0<1>:f   r113.1<0;1,0>:f   r44.0<1;1,0>:f   {I@1}
        shl (32|M0)              r46.0<1>:d    r22.0<1;1,0>:ud   16:w               {$1.dst}
        shl (32|M0)              r54.0<1>:d    r26.0<1;1,0>:ud   16:w               {$2.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   0.0:f               {Compacted}
        shl (32|M0)              r48.0<1>:d    r24.0<1;1,0>:ud   16:w               {$3.dst}
        mul (32|M0)              r50.0<1>:f    r113.2<0;1,0>:f   r46.0<1;1,0>:f   {Compacted,I@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r113.4<0;1,0>:f   r54.0<1;1,0>:f   {Compacted,I@2}
        mul (32|M0)              r52.0<1>:f    r113.3<0;1,0>:f   r48.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r56.0<1>:d    r28.0<1;1,0>:ud   16:w               {$6.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r50.0<1;1,0>:f   {Compacted,F@4}
        shl (32|M0)              r58.0<1>:d    r30.0<1;1,0>:ud   16:w               {$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@2}
        sync.nop                             null                             {Compacted,I@2}
        mul (32|M0)              r14.0<1>:f    r113.5<0;1,0>:f   r56.0<1;1,0>:f   {$11.src}
        shl (32|M0)              r18.0<1>:d    r32.0<1;1,0>:ud   16:w               {$9.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r16.0<1>:f    r113.6<0;1,0>:f   r58.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {Compacted,F@3}
        shl (32|M0)              r20.0<1>:d    r34.0<1;1,0>:ud   16:w               {$12.dst}
        mul (32|M0)              r24.0<1>:f    r113.7<0;1,0>:f   r18.0<1;1,0>:f   {I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@3}
        sync.nop                             null                             {F@2}
        shl (32|M0)              r18.0<1>:d    r36.0<1;1,0>:ud   16:w               {$13.dst}
        shl (32|M0)              r22.0<1>:d    r6.0<1;1,0>:ud    16:w               {$14.dst}
        mul (32|M0)              r26.0<1>:f    r1.0<0;1,0>:f     r20.0<1;1,0>:f   {Compacted,I@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted}
        shl (32|M0)              r30.0<1>:d    r8.0<1;1,0>:ud    16:w               {$7.dst}
        mul (32|M0)              acc2.0<1>:f   r1.5<0;1,0>:f     r18.0<1;1,0>:f   {I@3}
        mul (32|M0)              r28.0<1>:f    r1.1<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,I@2}
        shl (32|M0)              r42.0<1>:d    r10.0<1;1,0>:ud   16:w               {$4.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@4}
        mul (32|M0)              r32.0<1>:f    r1.2<0;1,0>:f     r30.0<1;1,0>:f   {I@2}
        shl (32|M0)              r44.0<1>:d    r12.0<1;1,0>:ud   16:w               {$10.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r34.0<1>:f    r1.3<0;1,0>:f     r42.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r6.0<1>:f     r1.4<0;1,0>:f     r44.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r20.0<1>:d    r38.0<1;1,0>:ud   16:w               {$5.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r34.0<1;1,0>:f   {Compacted,F@3}
        shl (32|M0)              r22.0<1>:d    r40.0<1;1,0>:ud   16:w               {$11.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted,F@2}
        mul (32|M0)              r8.0<1>:f     r1.6<0;1,0>:f     r20.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r10.0<1>:f    r1.7<0;1,0>:f     r22.0<1;1,0>:f   {I@1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@3}
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@2}
L6096:
        join (32|M0)                         L6272                                
L6112:
        mul (32|M0)              acc0.0<1>:f   r116.0<1;1,0>:f   r3.15<0;1,0>:f   {Compacted}
        shl (32|M0)              r8.0<1>:d     r104.0<1;1,0>:d   2:w               {Compacted,F@3}
        add (32|M0)              r32.0<1>:d    r104.0<1;1,0>:d   128:w               {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r44.0<1;1,0>:f   {Compacted,F@2}
        add3 (32|M0)             r10.0<1>:d    r1.8<0;0>:d       r8.0<1;0>:d       4096:w               {I@2}
        cmp (32|M0)   (gt)f1.0   null<1>:d     r32.0<1;1,0>:d    r1.12<0;1,0>:d   {I@2}
        add (32|M0)              r6.0<1>:f     acc0.0<1;1,0>:f   -r123.0<0;1,0>:f {$7.dst}
        send.slm (32|M0)         null     r10  r6:2  0x0            0x04000504           {A@1,$11} // wr:2+2, rd:0; store.slm.d32.a32
        sel (32|M0)   (ge)f0.0   r114.0<1>:f   r114.0<1;1,0>:f   r6.0<1;1,0>:f   
(f1.0)  goto (32|M0)                         L6272                  L6272                
L6240:
        mov (32|M0)              r104.0<1>:f   r32.0<1;1,0>:f                  
(W)     jmpi                                 L1360                                
L6272:
        join (32|M0)                         L6288                                
L6288:
        sync.nop                             null                             {Compacted,$11.src}
(W)     mov (32|M0)              r5.0<1>:f     -inf:f                               {$4.src}
        mov (32|M0)              r5.0<1>:f     r114.0<1;1,0>:f                  {Compacted,F@3}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
        sync.nop                             null                             {Compacted,I@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,$10.src}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r7.0<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {Compacted,F@1}
(W)     send.slm (1|M0)          r13      r112  null:0  0x0            0x0210001F           {$15} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r14.2<1>:f    3.58732e-43:f                              
(W)     mov (2|M0)               r14.10<1>:ub  r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r13.0<1;1,0>:ud                  {Compacted,$15.dst}
(W)     send.gtwy (1|M0)         null     r14  null:0  0x0            0x02000004           {I@2,$0} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               acc0.0<1>:d   r4.1<0;1,0>:d     r4.0<0;1,0>:uw  
(W)     macl (1|M0)              r5.0<1>:d     r4.1<0;1,0>:d     r4.0<0;1,0>:d   
(W)     mov (1|M0)               r1.3<1>:ud    0x2:uw                             
(W)     mul (1|M0)               acc0.0<1>:d   r5.0<0;1,0>:d     r4.4<0;1,0>:uw   {I@2}
(W)     macl (1|M0)              r2.0<1>:d     r5.0<0;1,0>:d     r4.2<0;1,0>:d    {Compacted}
(W)     mov (1|M0)               r3.58<2>:b    r112.8<0;1,0>:b                 
(W)     add (1|M0)               r2.1<1>:d     r2.0<0;1,0>:d     31:w               {Compacted,I@2}
(W)     mov (8|M0)               r48.0<1>:w    0x76543210:v                              
(W)     shr (1|M0)               r4.4<1>:ud    r2.1<0;1,0>:ud    3:w               {I@2}
(W)     mov (1|M0)               r1.6<1>:d     r3.58<0;1,0>:ub                 
(W)     shr (1|M0)               r1.7<1>:ud    r4.4<0;1,0>:ud    r1.3<0;1,0>:d    {I@2}
(W)     add (8|M0)               r48.8<1>:w    r48.0<1;1,0>:w    8:w              
(W)     add (1|M0)               r6.0<1>:d     r1.7<0;1,0>:d     -1:w               {I@2}
(W)     and (1|M0)               r4.3<1>:d     r2.0<0;1,0>:d     31:w              
(W)     cmp (1|M0)    (gt)f2.0   null<1>:ud    r6.0<0;1,0>:ud    r1.6<0;1,0>:ud   {I@2}
(W)     add (16|M0)              r48.16<1>:w   r48.0<1;1,0>:w    16:w              
        cmp (32|M0)   (eq)f1.0   null<2>:w     r48.0<1;1,0>:w    0:w               {I@1}
(W&~f2.0) cmp (1|M0)  (eq)f2.0   null<1>:d     r4.3<0;1,0>:d     0:w              
(W&~f2.0) sel (1|M0)             r1.15<1>:d    r4.3<0;1,0>:d     32:w              
(~f1.0) goto (32|M0)                         L6832                  L6832                
L6800:
(W)     shl (1|M0)               r2.0<1>:d     r1.6<0;1,0>:d     2:w              
(W)     send.slm (1|M0)          null     r2  r7:1  0x0            0x02008504           {I@1,$1} // wr:1+1, rd:0; store.slm.d32x1t.a32
L6832:
        join (32|M0)                         L6848                                
L6848:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$2.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               r2.0<1>:d     r1.6<0;1,0>:d     32:w               {$1.src}
        mov (32|M0)              r124.0<1>:d   r48.0<1;1,0>:uw                 
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.7<0;1,0>:ud    0x20:uw             
        add (32|M0)              r126.0<1>:d   r2.0<0;1,0>:d     r124.0<1;1,0>:d  {I@2}
(W&f2.0) jmpi                                L7056                                
L7024:
(W)     mov (1|M0)               r1.0<1>:d     r1.7<0;1,0>:d                   
(W)     jmpi                                 L7776                                
L7056:
        shl (32|M0)              r52.0<1>:d    r126.0<1;1,0>:d   2:w               {Compacted,I@4}
(W)     shl (1|M0)               r13.0<1>:d    r1.6<0;1,0>:d     2:w               {Compacted}
(W)     mov (1|M0)               r1.2<1>:d     r1.7<0;1,0>:d                   
L7088:
(W)     add (1|M0)               r2.0<1>:d     r1.2<0;1,0>:d     31:w               {I@1}
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r126.0<1;1,0>:ud  r1.2<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.1<1>:ud    r4.3<0;1,0>:ud    r1.3<0;1,0>:d    {I@1}
(W)     mul (1|M0)               r1.4<1>:d     r1.1<0;1,0>:d     32:w               {I@1}
(f3.0)  goto (32|M0)                         L7216                  L7216                
L7184:
        mov (32|M0)              r42.0<1>:ud   0xFF800000:ud                              {$4.dst}
        goto (32|M0)                         L7216                  L7248                
L7216:
        join (32|M0)                         L7248                                
L7232:
        send.slm (32|M0)         r42      r52  null:0  0x0            0x04200500           {I@3,$4} // wr:2+0, rd:2; load.slm.d32.a32
L7248:
        join (32|M0)                         L7264                                
L7264:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {$8.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$3.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$9.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r126.0<1;1,0>:ud  r1.4<0;1,0>:ud  
(~f3.0) goto (32|M0)                         L7552                  L7552                
L7408:
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$10.src}
        mov (32|M0)              r5.0<1>:ud    r42.0<1;1,0>:ud                  {Compacted,$4.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {@1,$6.src}
(~f1.0) goto (32|M0)                         L7552                  L7552                
L7536:
(W)     send.slm (1|M0)          null     r13  r3:1  0x0            0x02008504           {F@1,$6} // wr:1+1, rd:0; store.slm.d32x1t.a32
L7552:
        join (32|M0)                         L7568                                
L7568:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$11} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$10.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$11.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$8} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.1<0;1,0>:ud    0x20:uw             
(W)     mov (1|M0)               r1.4<1>:d     r1.1<0;1,0>:d                   
(W&f3.0) jmpi                                L7744                                
L7712:
(W)     mov (1|M0)               r1.0<1>:d     r1.4<0;1,0>:d                    {I@2}
(W)     jmpi                                 L7776                                
L7744:
(W)     mov (1|M0)               r1.2<1>:d     r1.1<0;1,0>:d                   
(W)     jmpi                                 L7088                                
L7776:
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.0<0;1,0>:ud    r1.15<0;1,0>:ud  {I@4}
(W&f3.0) jmpi                                L8080                                
L7808:
        cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.0<0;1,0>:ud    r124.0<1;1,0>:ud
(f3.0)  goto (32|M0)                         L7872                  L7872                
L7840:
        mov (32|M0)              r56.0<1>:ud   0xFF800000:ud                             
        goto (32|M0)                         L7872                  L7920                
L7872:
        join (32|M0)                         L7920                                
L7888:
        sync.nop                             null                             {Compacted,$8.src}
        shl (32|M0)              r6.0<1>:d     r124.0<1;1,0>:d   2:w               {Compacted,$3.src}
        send.slm (32|M0)         r56      r6  null:0  0x0            0x04200500           {I@1,$12} // wr:2+0, rd:2; load.slm.d32.a32
L7920:
        join (32|M0)                         L7936                                
L7936:
        sync.allrd                           ($8,$12)                
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$3.src}
        mov (32|M0)              r5.0<1>:ud    r56.0<1;1,0>:ud                  {Compacted,$12.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r1.2<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {F@1}
(W)     jmpi                                 L8240                                
L8080:
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                             
(W)     mov (1|M0)               r1.1<1>:d     1:w                               {Compacted}
        sync.nop                             null                             {Compacted,$6.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$13} // wr:1+0, rd:1; load.slm.d32x1t.a32
L8128:
(W)     shl (1|M0)               r2.0<1>:d     r1.1<0;1,0>:d     2:w               {Compacted,@1,$13.src}
(W)     add (1|M0)               r1.1<1>:d     r1.1<0;1,0>:d     1:w              
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$14} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r1.1<0;1,0>:ud    r1.0<0;1,0>:ud   {I@1}
        sync.nop                             null                             {Compacted,$14.dst}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$13.dst}
(W)     mov (1|M0)               r1.4<1>:f     r3.0<0;1,0>:f                    {Compacted,F@1}
(W&f3.0) jmpi                                L8128                                
L8224:
(W)     mov (1|M0)               r1.2<1>:f     r1.4<0;1,0>:f                    {F@1}
L8240:
(W)     mov (1|M0)               f3.0<1>:ud    r1.14<0;1,0>:ud                 
(W)     mov (1|M0)               r1.11<1>:f    0xB5BFBE8E:f                              
(W)     mov (1|M0)               r1.10<1>:f    0xBF317200:f                              
(~f3.0) goto (32|M0)                         L8336                  L8336                
L8304:
        mov (32|M0)              r46.0<1>:ud   0x0:ud                             
        goto (32|M0)                         L8336                  L8704                
L8336:
        join (32|M0)                         L8704                                
L8352:
        mov (32|M0)              r36.0<1>:d    r106.0<1;1,0>:d                  {Compacted}
        mov (32|M0)              r46.0<1>:f    0.0:f                               {Compacted,I@4}
L8368:
        sync.allrd                           ($8,$15)                
        shl (32|M0)              r6.0<1>:d     r36.0<1;1,0>:d    2:w               {Compacted,@1,$3.src}
        add3 (32|M0)             r8.0<1>:d     r1.8<0;0>:d       r6.0<1;0>:d       4096:w               {I@1}
        send.slm (32|M0)         r10      r8  null:0  0x0            0x04200500           {I@1,$1} // wr:2+0, rd:2; load.slm.d32.a32
        add (32|M0)              r34.0<1>:d    r36.0<1;1,0>:d    128:w               {Compacted}
        add (32|M0)              acc0.0<1>:f   r10.0<1;1,0>:f    -r1.2<0;1,0>:f   {@4,$1.dst}
        mul (32|M0)              acc2.0<1>:f   acc0.0<1;1,0>:f   1.442695e+00:f              
        rndz (32|M0)             r12.0<1>:f    acc2.0<1;1,0>:f                  {$6.src}
        mad (32|M0)              acc2.0<1>:f   acc0.0<1;0>:f     r12.0<1;0>:f      r1.10<0>:f       {Compacted,F@1}
        mad (32|M0)              acc2.0<1>:f   acc2.0<1;0>:f     r12.0<1;0>:f      r1.11<0>:f       {Compacted}
        mul (32|M0)              r14.0<1>:f    acc2.0<1;1,0>:f   1.442695e+00:f               {$0.src}
        math.exp (32|M0)         r16.0<1>:f    r12.0<1;1,0>:f                   {$7.src}
        math.exp (32|M0)         r18.0<1>:f    r14.0<1;1,0>:f                   {F@1}
        mul (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {M@1}
        cmp (32|M0)   (lt)f3.0   null<1>:f     acc0.0<1;1,0>:f   -105.0:f              
(~f3.0) sel (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   0.0:f              
        cmp (32|M0)   (gt)f3.0   null<1>:f     acc0.0<1;1,0>:f   105.0:f              
(~f3.0) sel (32|M0)              r6.0<1>:f     acc2.0<1;1,0>:f   inf:f              
        cmp (32|M0)   (gt)f3.0   null<1>:d     r34.0<1;1,0>:d    r1.12<0;1,0>:d   {A@1}
        send.slm (32|M0)         null     r8  r6:2  0x0            0x04000504           {$15} // wr:2+2, rd:0; store.slm.d32.a32
        add (32|M0)              r46.0<1>:f    r46.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
(f3.0)  goto (32|M0)                         L8704                  L8704                
L8680:
        mov (32|M0)              r36.0<1>:f    r34.0<1;1,0>:f                   {Compacted}
(W)     jmpi                                 L8368                                
L8704:
        join (32|M0)                         L8720                                
L8720:
        sync.nop                             null                             {Compacted,F@2}
        sync.allrd                           ($8,$15)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$3.src}
        mov (32|M0)              r5.0<1>:f     r46.0<1;1,0>:f                   {Compacted,I@1}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {Compacted,F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {Compacted,@1,$6.src}
(W)     send.slm (1|M0)          r12      r112  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r13.2<1>:ud   0x100:ud                              {Compacted}
(W)     mov (2|M0)               r13.10<1>:ub  r112.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r12.0<1;1,0>:ud                  {$2.dst}
(W)     send.gtwy (1|M0)         null     r13  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(~f1.0) goto (32|M0)                         L8976                  L8976                
L8944:
(W)     shl (1|M0)               r2.0<1>:d     r1.6<0;1,0>:d     2:w               {F@1}
(W)     send.slm (1|M0)          null     r2  r3:1  0x0            0x02008504           {I@1,$6} // wr:1+1, rd:0; store.slm.d32x1t.a32
L8976:
        join (32|M0)                         L8992                                
L8992:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$8.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$9} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W&f2.0) jmpi                                L9136                                
L9104:
(W)     mov (1|M0)               r1.5<1>:d     r1.7<0;1,0>:d                   
(W)     jmpi                                 L9808                                
L9136:
        shl (32|M0)              r50.0<1>:d    r126.0<1;1,0>:d   2:w               {Compacted}
(W)     shl (1|M0)               r12.0<1>:d    r1.6<0;1,0>:d     2:w               {Compacted}
(W)     mov (1|M0)               r1.1<1>:d     r1.7<0;1,0>:d                   
L9168:
(W)     add (1|M0)               r2.0<1>:d     r1.1<0;1,0>:d     31:w               {@1,$6.src}
        cmp (32|M0)   (lt)f2.0   null<1>:ud    r126.0<1;1,0>:ud  r1.1<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.0<1>:ud    r4.3<0;1,0>:ud    r1.3<0;1,0>:d    {I@1}
(W)     mul (1|M0)               r1.4<1>:d     r1.0<0;1,0>:d     32:w               {Compacted,I@1}
(f2.0)  goto (32|M0)                         L9280                  L9280                
L9256:
        mov (32|M0)              r40.0<1>:ud   0x0:ud                              {Compacted,$10.dst}
        goto (32|M0)                         L9280                  L9312                
L9280:
        join (32|M0)                         L9312                                
L9296:
        send.slm (32|M0)         r40      r50  null:0  0x0            0x04200500           {I@3,$10} // wr:2+0, rd:2; load.slm.d32.a32
L9312:
        join (32|M0)                         L9328                                
L9328:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$13} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {Compacted,$12.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$9.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {Compacted,$13.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$14} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r126.0<1;1,0>:ud  r1.4<0;1,0>:ud  
(~f3.0) goto (32|M0)                         L9600                  L9600                
L9456:
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$14.src}
        mov (32|M0)              r5.0<1>:ud    r40.0<1;1,0>:ud                  {Compacted,$10.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {@1,$11.src}
(~f1.0) goto (32|M0)                         L9600                  L9600                
L9584:
(W)     send.slm (1|M0)          null     r12  r3:1  0x0            0x02008504           {F@1,$11} // wr:1+1, rd:0; store.slm.d32x1t.a32
L9600:
        join (32|M0)                         L9616                                
L9616:
(W)     send.slm (1|M0)          r5       r112  null:0  0x0            0x0210001F           {$15} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$14.src}
(W)     mov (2|M0)               r6.10<1>:ub   r112.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$15.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$12} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.0<0;1,0>:ud    0x20:uw             
(W&f2.0) jmpi                                L9776                                
L9744:
(W)     mov (1|M0)               r1.5<1>:d     r1.0<0;1,0>:d                   
(W)     jmpi                                 L9808                                
L9776:
(W)     mov (1|M0)               r1.1<1>:d     r1.0<0;1,0>:d                   
(W)     jmpi                                 L9168                                
L9808:
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.5<0;1,0>:ud    r1.15<0;1,0>:ud  {I@4}
(W&f3.0) jmpi                                L10104                                
L9840:
        cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.5<0;1,0>:ud    r124.0<1;1,0>:ud
(f2.0)  goto (32|M0)                         L9896                  L9896                
L9872:
        mov (32|M0)              r54.0<1>:ud   0x0:ud                              {Compacted}
        goto (32|M0)                         L9896                  L9952                
L9896:
        join (32|M0)                         L9952                                
L9912:
        sync.nop                             null                             {Compacted,$12.src}
        shl (32|M0)              r6.0<1>:d     r124.0<1;1,0>:d   2:w               {$9.src}
        send.slm (32|M0)         r54      r6  null:0  0x0            0x04200500           {I@1,$1} // wr:2+0, rd:2; load.slm.d32.a32
L9952:
        join (32|M0)                         L9968                                
L9968:
        sync.allrd                           ($1,$12)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$9.src}
        mov (32|M0)              r5.0<1>:ud    r54.0<1;1,0>:ud                  {Compacted,$1.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {Compacted,@1,$6.src}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r1.14<1>:f    r2.0<0;1,0>:f     r2.1<0;1,0>:f    {F@1}
(W)     jmpi                                 L10272                                
L10104:
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                              {$6.src}
(W)     mov (1|M0)               r1.0<1>:d     1:w                               {Compacted}
        sync.nop                             null                             {Compacted,$11.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x1t.a32
L10160:
(W)     shl (1|M0)               r2.0<1>:d     r1.0<0;1,0>:d     2:w               {Compacted,@1,$2.src}
(W)     add (1|M0)               r1.0<1>:d     r1.0<0;1,0>:d     1:w               {Compacted}
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$6} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f1.0   null<1>:ud    r1.0<0;1,0>:ud    r1.5<0;1,0>:ud   {I@1}
        sync.nop                             null                             {Compacted,$6.dst}
(W)     add (1|M0)               r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$2.dst}
(W)     mov (1|M0)               r1.1<1>:f     r3.0<0;1,0>:f                    {F@1}
(W&f1.0) jmpi                                L10160                                
L10256:
(W)     mov (1|M0)               r1.14<1>:f    r1.1<0;1,0>:f                    {F@1}
L10272:
(W)     mul (1|M0)               r2.0<1>:f     r1.2<0;1,0>:f     -1.442695e+00:f              
(W)     cmp (1|M0)    (gt)f2.0   null<1>:f     r1.2<0;1,0>:f     105.0:f              
        sync.nop                             null                             {Compacted,$12.src}
(W)     rndz (1|M0)              r6.0<1>:f     r2.0<0;1,0>:f                    {Compacted,@2,$9.src}
(W)     cmp (1|M0)    (lt)f1.0   null<1>:f     r1.2<0;1,0>:f     -105.0:f               {I@1}
(W)     mad (1|M0)               r4.3<1>:f     -r1.2<0;0>:f      r1.10<0;0>:f      r6.0<0>:f        {F@2}
(W)     math.exp (1|M0)          r5.0<1>:f     r6.0<0;1,0>:f                   
(W)     mad (1|M0)               r5.2<1>:f     r4.3<0;0>:f       r1.11<0;0>:f      r6.0<0>:f        {F@1}
(W)     mul (1|M0)               r6.1<1>:f     r5.2<0;1,0>:f     1.442695e+00:f               {F@1}
(W)     math.exp (1|M0)          r5.1<1>:f     r6.1<0;1,0>:f                    {F@1}
(W)     mul (1|M0)               r7.0<1>:f     r5.0<0;1,0>:f     r5.1<0;1,0>:f    {M@1}
(W&~f2.0) sel (1|M0)             r8.0<1>:f     r7.0<0;1,0>:f     0.0:f               {F@1}
(W&~f1.0) sel (1|M0)             r1.15<1>:f    r8.0<0;1,0>:f     inf:f               {F@1}
(W)     send.slm (1|M0)          r9       r112  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r9.0<1;1,0>:ud                   {$8.dst}
(W)     send.ugm (1|M0)          r10      r112  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:ud   0x100:ud                              {Compacted}
(W)     mov (2|M0)               r11.10<1>:ub  r112.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r10.0<1;1,0>:ud                  {Compacted,$9.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$12} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.12<0;1,0>:d    0:w               {F@1}
(W&~f1.0) jmpi                               L10640                                
L10608:
        mov (32|M0)              r24.0<1>:ud   0x0:ud                             
(W)     jmpi                                 L12448                                
L10640:
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r1.12<0;1,0>:ud   0x3:uw             
(W)     add3 (1|M0)              r1.0<1>:d     r1.13<0;0>:d      -r120.0<0;0>:d    1:w              
(W)     and (1|M0)               r1.6<1>:d     r1.0<0;1,0>:d     3:w               {I@1}
(W&~f3.0) jmpi                               L10736                                
L10704:
        mov (32|M0)              r24.0<1>:f    0.0:f                               {Compacted}
(W)     mov (1|M0)               r1.1<1>:d     0:w                               {Compacted}
(W)     jmpi                                 L12064                                
L10736:
        mov (32|M0)              r24.0<1>:f    0.0:f                              
(W)     and (1|M0)               r1.7<1>:d     r1.0<0;1,0>:d     -4:w              
(W)     mov (1|M0)               r1.5<1>:d     0:w                              
(W)     mov (1|M0)               r1.0<1>:d     0:w                               {Compacted}
L10792:
(W)     shl (1|M0)               r2.0<1>:d     r1.0<0;1,0>:d     2:w               {Compacted,I@1}
(W)     add (1|M0)               r1.2<1>:d     r120.0<0;1,0>:d   r1.0<0;1,0>:d   
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       r2.0<0;0>:d       4096:w               {I@2}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.2<0;1,0>:d     0:w               {I@2}
        sync.nop                             null                             {$11.src}
(W)     send.slm (1|M0)          r3       r5  null:0  0x0            0x02108500           {I@2,$13} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W&~f2.0) jmpi                               L10912                                
L10896:
(W)     add3 (1|M0)              r1.2<1>:d     r120.0<0;0>:d     r1.0<0;0>:d       2047:w              
L10912:
(W)     and (1|M0)               r2.0<1>:d     r1.2<0;1,0>:d     -2048:w               {Compacted,I@1}
(W)     or (1|M0)                r1.2<1>:d     r1.0<0;1,0>:d     1:w               {Compacted}
(W)     add3 (1|M0)              r4.3<1>:d     r120.0<0;0>:d     r1.0<0;0>:d       -r2.0<0>:d       {I@2}
(W)     shl (1|M0)               r4.4<1>:d     r1.2<0;1,0>:d     2:w               {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r1.0<0;1,0>:d     r4.3<0;1,0>:d    {@2,$13.src}
(W)     add3 (1|M0)              r6.0<1>:d     r1.8<0;0>:d       r4.4<0;0>:d       4096:w               {I@2}
(W)     shl (1|M0)               r6.1<1>:d     r5.0<0;1,0>:d     10:w               {I@2}
(W)     send.slm (1|M0)          r7       r6  null:0  0x0            0x02108500           {I@1,$14} // wr:1+0, rd:1; load.slm.d32x1t.a32
        add3 (32|M0)             r8.0<1>:d     r6.1<0;0>:d       r1.9<0;0>:d       r106.0<1>:d     
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,@1,$12.src}
        mov (16|M16)             r12.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$3.src}
        shl (16|M0)              r14.0<1>:q    r10.0<2;1,0>:d    2:w               {@2,$0.src}
        shl (16|M16)             r16.0<1>:q    r12.0<2;1,0>:d    2:w               {@2,$7.src}
        add (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$13.dst}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$15} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r1.3<1>:d     r120.0<0;1,0>:d   r1.2<0;1,0>:d   
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.3<0;1,0>:d     0:w               {I@1}
        mul (32|M0)              acc0.0<1>:f   r3.0<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$15.dst}
        add (32|M0)              r28.0<1>:f    r24.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f3.0) jmpi                               L11200                                
L11184:
(W)     add3 (1|M0)              r1.3<1>:d     r120.0<0;0>:d     r1.2<0;0>:d       2047:w              
L11200:
(W)     and (1|M0)               r2.0<1>:d     r1.3<0;1,0>:d     -2048:w               {I@1}
(W)     or (1|M0)                r1.3<1>:d     r1.0<0;1,0>:d     2:w              
(W)     add3 (1|M0)              r4.3<1>:d     r120.0<0;0>:d     r1.2<0;0>:d       -r2.0<0>:d       {I@2}
(W)     shl (1|M0)               r4.4<1>:d     r1.3<0;1,0>:d     2:w               {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r1.2<0;1,0>:d     r4.3<0;1,0>:d    {I@2}
(W)     add3 (1|M0)              r6.0<1>:d     r1.8<0;0>:d       r4.4<0;0>:d       4096:w               {@2,$14.src}
(W)     shl (1|M0)               r6.1<1>:d     r5.0<0;1,0>:d     10:w               {I@2}
(W)     send.slm (1|M0)          r30      r6  null:0  0x0            0x02108500           {I@1,$1} // wr:1+0, rd:1; load.slm.d32x1t.a32
        add3 (32|M0)             r8.0<1>:d     r6.1<0;0>:d       r1.9<0;0>:d       r106.0<1>:d     
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r12.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r14.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r12.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {A@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r1.4<1>:d     r120.0<0;1,0>:d   r1.3<0;1,0>:d    {Compacted}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.4<0;1,0>:d     0:w               {I@1}
        sync.nop                             null                             {Compacted,$2.dst}
        mul (32|M0)              acc0.0<1>:f   r7.0<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              r26.0<1>:f    r28.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f2.0) jmpi                               L11504                                
L11488:
(W)     add3 (1|M0)              r1.4<1>:d     r120.0<0;0>:d     r1.3<0;0>:d       2047:w              
L11504:
(W)     and (1|M0)               r2.0<1>:d     r1.4<0;1,0>:d     -2048:w               {Compacted,I@1}
(W)     or (1|M0)                r1.2<1>:d     r1.0<0;1,0>:d     3:w               {Compacted}
(W)     add3 (1|M0)              r4.3<1>:d     r120.0<0;0>:d     r1.3<0;0>:d       -r2.0<0>:d       {I@2}
(W)     shl (1|M0)               r4.4<1>:d     r1.2<0;1,0>:d     2:w               {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r1.3<0;1,0>:d     r4.3<0;1,0>:d    {I@2}
(W)     add3 (1|M0)              r6.0<1>:d     r1.8<0;0>:d       r4.4<0;0>:d       4096:w               {@2,$1.src}
(W)     shl (1|M0)               r6.1<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@2}
(W)     send.slm (1|M0)          r3       r6  null:0  0x0            0x02108500           {I@1,$6} // wr:1+0, rd:1; load.slm.d32x1t.a32
        add3 (32|M0)             r8.0<1>:d     r6.1<0;0>:d       r1.9<0;0>:d       r106.0<1>:d     
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r12.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r14.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r12.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$6.dst}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {A@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r1.4<1>:d     r120.0<0;1,0>:d   r1.2<0;1,0>:d    {Compacted}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.4<0;1,0>:d     0:w               {I@1}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              acc0.0<1>:f   r30.0<0;1,0>:f    r22.0<1;1,0>:f   {Compacted,$1.dst}
        add (32|M0)              r30.0<1>:f    r26.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f1.0) jmpi                               L11792                                
L11776:
(W)     add3 (1|M0)              r1.4<1>:d     r120.0<0;0>:d     r1.2<0;0>:d       2047:w              
L11792:
(W)     and (1|M0)               r2.0<1>:d     r1.4<0;1,0>:d     -2048:w               {I@1}
(W)     add (1|M0)               r1.5<1>:d     r1.5<0;1,0>:d     4:w              
(W)     add3 (1|M0)              r4.3<1>:d     r120.0<0;0>:d     r1.2<0;0>:d       -r2.0<0>:d       {I@2}
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r1.5<0;1,0>:d     r1.7<0;1,0>:d    {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r1.2<0;1,0>:d     r4.3<0;1,0>:d    {I@2}
(W)     add (1|M0)               r1.0<1>:d     r1.0<0;1,0>:d     4:w               {Compacted}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@2}
(W)     mov (1|M0)               r1.1<1>:d     r1.0<0;1,0>:d                    {I@2}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.9<0;0>:d       r106.0<1>:d      {I@2}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {A@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
        mul (32|M0)              acc0.0<1>:f   r3.0<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$9.dst}
        add (32|M0)              r24.0<1>:f    r30.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f3.0) jmpi                               L10792                                
L12032:
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r1.6<0;1,0>:d     0:w              
(W&f1.0) jmpi                                L12448                                
L12064:
(W)     mov (1|M0)               r1.2<1>:d     0:w                               {Compacted}
L12072:
(W)     shl (1|M0)               r2.0<1>:d     r1.1<0;1,0>:d     2:w               {Compacted}
(W)     add (1|M0)               r1.0<1>:d     r120.0<0;1,0>:d   r1.1<0;1,0>:d   
(W)     add3 (1|M0)              r5.0<1>:d     r1.8<0;0>:d       r2.0<0;0>:d       4096:w               {I@2}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.0<0;1,0>:d     0:w               {I@2}
        sync.nop                             null                             {$11.src}
(W)     send.slm (1|M0)          r3       r5  null:0  0x0            0x02108500           {A@2,$13} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W&~f3.0) jmpi                               L12192                                
L12176:
(W)     add3 (1|M0)              r1.0<1>:d     r120.0<0;0>:d     r1.1<0;0>:d       2047:w              
L12192:
(W)     and (1|M0)               r2.0<1>:d     r1.0<0;1,0>:d     -2048:w               {I@1}
(W)     add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r120.0<0;0>:d     r1.1<0;0>:d       -r2.0<0>:d       {I@2}
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r1.2<0;1,0>:d     r1.6<0;1,0>:d    {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r1.1<0;1,0>:d     r4.3<0;1,0>:d    {@2,$13.src}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.9<0;0>:d       r106.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,@1,$12.src}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$0.src}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {@2,$3.src}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {@2,$7.src}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$13.dst}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
        mul (32|M0)              acc0.0<1>:f   r3.0<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              r24.0<1>:f    r24.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&f2.0) jmpi                                L12448                                
L12416:
(W)     add (1|M0)               r1.1<1>:d     r1.1<0;1,0>:d     1:w              
(W)     jmpi                                 L12072                                
L12448:
        add (16|M0)              r8.0<1>:q     r121.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted}
        add (16|M16)             r10.0<1>:q    r118.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted,$12.src}
        sync.allrd                           ($3,$11)                
        send.ugm (32|M0)         r12      r8  null:0  0x0            0x08200580           {I@1,$15} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r2.0<1>:f     r1.14<0;1,0>:f    r1.15<0;1,0>:f  
(W)     mov (1|M0)               r2.3<1>:f     0x4F800000:f                              
(W)     and (1|M0)    (eq)f3.0   r2.1<1>:d     r2.0<0;1,0>:d     2139095040:d               {F@2}
(W)     and (1|M0)               r7.0<1>:d     r2.0<0;1,0>:d     8388607:d              
(W)     mov (16|M0)              r127.0<1>:f   r112.0<1;1,0>:f                 
(W)     cmp (1|M0)    (ge)f1.0   null<1>:ud    r2.1<0;1,0>:ud    0x64000000:ud              {I@2}
(W&f3.0) sel (1|M0)              r4.3<1>:f     r2.3<0;1,0>:f     1.0:f               {F@2}
(W&~f1.0) sel (1|M0)             r5.0<1>:f     r4.3<0;1,0>:f     0x2F800000:f               {F@1}
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r7.0<0;1,0>:d     0:w               {A@1}
(W&~f1.0) cmp (32|M0) (eq)f1.0   null<1>:d     r2.1<0;1,0>:d     0:w              
(W)     mul (1|M0)               r5.1<1>:f     r2.0<0;1,0>:f     r5.0<0;1,0>:f   
(W)     not (1|M0)               f0.0<1>:ud    f1.0<0;1,0>:ud                  
(W)     math.inv (1|M0)          r6.0<1>:f     r5.1<0;1,0>:f                    {F@1}
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:f     r24.0<1;1,0>:f    r2.0<0;1,0>:f    {I@1}
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r24.0<1;1,0>:f   {Compacted,M@1}
        mul (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r5.0<0;1,0>:f    {Compacted}
(~f0.0) sel (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   1.0:f              
        mul (32|M0)              acc2.0<1>:f   r12.0<1;1,0>:f    -1.442695e+00:f               {$15.dst}
        rndz (32|M0)             r14.0<1>:f    acc2.0<1;1,0>:f                  {$0.src}
        mad (32|M0)              acc2.0<1>:f   -r12.0<1;0>:f     r14.0<1;0>:f      r1.10<0>:f       {F@1}
        mad (32|M0)              acc2.0<1>:f   acc2.0<1;0>:f     r14.0<1;0>:f      r1.11<0>:f      
        mul (32|M0)              r6.0<1>:f     acc2.0<1;1,0>:f   1.442695e+00:f              
        math.exp (32|M0)         r16.0<1>:f    r14.0<1;1,0>:f                   {$7.src}
        cmp (32|M0)   (gt)f0.0   null<1>:f     r12.0<1;1,0>:f    105.0:f              
        math.exp (32|M0)         r18.0<1>:f    r6.0<1;1,0>:f                    {F@2}
        mul (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,M@1}
        add (32|M0)              r20.0<1>:f    acc2.0<1;1,0>:f   1.0:f               {Compacted}
        math.inv (32|M0)         r22.0<1>:f    r20.0<1;1,0>:f                   {F@1}
        cmp (32|M0)   (lt)f3.0   null<1>:f     r12.0<1;1,0>:f    -105.0:f              
(~f0.0) sel (32|M0)              acc2.0<1>:f   r22.0<1;1,0>:f    1.0:f               {M@1}
(~f3.0) sel (32|M0)              r8.0<1>:f     acc2.0<1;1,0>:f   0.0:f              
        mul (32|M0)              r10.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@1}
        shr (32|M0)              r24.0<1>:ud   r10.0<1;1,0>:ud   16:w               {F@1}
        and (32|M0)              r28.0<1>:d    r24.0<1;1,0>:d    1:w               {Compacted,I@1}
        add3 (32|M0)             r14.0<1>:d    r28.0<1;0>:d      r10.0<1;0>:d      32767:w               {I@1}
        add (16|M0)              r16.0<1>:q    r121.0<1;1,0>:q   r3.6<0;1,0>:q   
        add (16|M16)             r18.0<1>:q    r118.0<1;1,0>:q   r3.6<0;1,0>:q   
        and (32|M0)              r6.0<1>:d     r14.0<1;1,0>:d    -65536:d               {I@3}
        send.ugm (32|M0)         null     r16  r6:2  0x0            0x08000584           {I@1,$1} // wr:4+2, rd:0; store.ugm.d32.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$2} // wr:1+0, rd:0; end of thread
L13088:
(W)     mov (16|M0)              null<1>:ud    0x7B61166B:ud                             
(W)     mov (16|M0)              null<1>:ud    0x15297BD1:ud                             
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
        illegal                
        illegal                
