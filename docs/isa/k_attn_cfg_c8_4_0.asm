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
(W)     mov (16|M0)              r110.0<1>:ud  r0.0<1;1,0>:ud                   {Compacted}
(W)     or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x400004C0:ud              {A@1}
(W)     mov (1|M0)               r5.0<1>:d     r110.1<0;1,0>:d                  {Compacted,A@1}
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
        mov (32|M0)              r104.0<1>:d   r1.0<1;1,0>:uw                  
        add (16|M0)              r15.0<1>:q    r5.1<0;1,0>:q     r6.0<4;1,0>:uw   {I@2}
        add (16|M16)             r17.0<1>:q    r5.1<0;1,0>:q     r8.0<4;1,0>:uw  
        shl (16|M0)              r117.0<1>:q   r15.0<1;1,0>:q    2:w               {Compacted,I@2}
        shl (16|M16)             r115.0<1>:q   r17.0<1;1,0>:q    2:w               {Compacted,I@2}
        add (16|M0)              r21.0<1>:q    r117.0<1;1,0>:q   r2.3<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r23.0<1>:q    r115.0<1;1,0>:q   r2.3<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r6       r21  null:0  0x0            0x08200580           {I@1,$4} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     mov (1|M0)               r2.6<1>:w     r3.56<0;1,0>:b                   {$1.dst}
        shl (32|M0)              r12.0<1>:d    r104.0<1;1,0>:d   2:w              
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x600:uw             
(W)     and (1|M0)               r2.0<1>:d     r4.5<0;1,0>:d     255:w              
(W)     and (1|M0)               r3.29<1>:w    r2.6<0;1,0>:w     1:w               {I@4}
(W)     mach (1|M0)              r11.0<1>:d    r4.3<0;1,0>:ud    0x600:ud             
(W)     mul (1|M0)               r4.8<1>:ud    r4.3<0;1,0>:ud    0x600:uw             
(W)     shl (1|M0)               r2.1<1>:d     r4.5<0;1,0>:d     4:w              
(W)     mov (1|M0)               r4.16<2>:b    r3.29<0;1,0>:w                   {I@4}
(W)     mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    0xAAAB:uw             
(W)     mov (1|M0)               r4.9<1>:d     r11.0<0;1,0>:d                   {I@5}
(W)     mach (1|M0)              r19.0<1>:ud   r2.0<0;1,0>:ud    0xAAAAAAAB:ud             
(W)     mul (1|M0)               acc0.0<1>:ud  r4.3<0;1,0>:ud    0x60:uw             
(W)     shl (1|M0)               r5.0<1>:q     r2.1<0;1,0>:ud    2:w               {I@6}
(W)     mov (1|M0)               r10.2<1>:w    r4.16<0;1,0>:ub                  {I@6}
(W)     add (1|M0)               r19.1<1>:q    r4.4<0;1,0>:q     r3.0<0;1,0>:q    {I@5}
(W)     mach (1|M0)              r20.0<1>:d    r4.3<0;1,0>:ud    0x60:ud             
(W)     mul (1|M0)               r4.10<1>:ud   r4.3<0;1,0>:ud    0x60:uw             
(W)     cmp (32|M0)   (eq)f0.0   null<2>:w     r10.2<0;1,0>:w    0:w               {I@4}
(W)     add (1|M0)               r14.0<1>:q    r19.1<0;1,0>:q    r5.0<0;1,0>:q    {I@4}
(W)     mov (1|M0)               r4.11<1>:d    r20.0<0;1,0>:d                   {I@4}
(W)     shl (1|M0)               r2.4<1>:q     r4.5<0;1,0>:ud    2:w              
(W)     add (1|M0)               r114.8<1>:d   r10.0<0;1,0>:d    r4.3<0;1,0>:d   
(W)     add (1|M0)               r2.0<1>:q     r4.5<0;1,0>:q     r3.1<0;1,0>:q    {Compacted,I@3}
(W)     sel (1|M0)    (ge)f0.0   r5.0<1>:d     r114.8<0;1,0>:d   1023:w               {Compacted,I@2}
(W)     mov (1|M0)               r1.2<1>:f     r2.2<0;1,0>:f                   
(W)     add (1|M0)               r9.0<1>:d     r5.0<0;1,0>:d     -1023:w               {I@1}
(W)     mov (1|M0)               r11.0<1>:q    r14.0<0;1,0>:q                  
(W)     add (1|M0)               r8.0<1>:q     r2.0<0;1,0>:q     r2.4<0;1,0>:q   
(W&~f0.0) sel (1|M0)             r1.1<1>:d     r9.0<0;1,0>:d     0:w               {I@3}
(W)     send.ugm (1|M0)          r114     r14  null:0  0x0            0x0210C580           {$5} // wr:1+0, rd:1; load.ugm.d32x8t.a64
(W)     send.ugm (1|M0)          r111     r11  null:0  0x20000            0x0210C580           {I@3,$6} // wr:1+0, rd:1; load.ugm.d32x8t.a64.flat[A+0x20]
(W)     send.ugm (1|M0)          r119     r8  null:0  0x0            0x02108580           {I@2,$7} // wr:1+0, rd:1; load.ugm.d32x1t.a64
(W)     add (1|M0)               r1.3<1>:d     r1.2<0;1,0>:d     4096:w               {F@1}
(W)     add (1|M0)               r1.6<1>:d     r114.8<0;1,0>:d   -r1.1<0;1,0>:d   {@2,$5.dst}
        send.slm (32|M0)         null     r12  r6:2  0x1000000            0x04000504           {$4} // wr:2+2, rd:0; store.slm.d32.a32.flat[A+0x1000]
(W)     send.slm (1|M0)          r14      r110  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r14.0<1;1,0>:ud                  {$8.dst}
(W)     send.ugm (1|M0)          r15      r110  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:f    3.58732e-43:f                               {$6.src}
(W)     mov (2|M0)               r11.10<1>:ub  r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r15.0<1;1,0>:ud                  {$9.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f2.0   null<1>:d     r1.6<0;1,0>:d     r104.0<1;1,0>:d 
(W)     shl (1|M0)               r2.0<1>:d     r19.0<0;1,0>:d    6:w              
(W)     mov (1|M0)               r1.7<1>:ud    f2.0<0;1,0>:ud                  
(W)     and (1|M0)               r1.0<1>:d     r2.0<0;1,0>:d     32640:w               {I@2}
(~f2.0) goto (32|M0)                         L1344                  L1344                
L1312:
        mov (32|M0)              r112.0<1>:ud  0x0:ud                             
        goto (32|M0)                         L1344                  L6312                
L1344:
        join (32|M0)                         L6312                                
L1360:
        mov (32|M0)              r112.0<1>:f   0.0:f                               {Compacted,I@3}
        mov (32|M0)              r106.0<1>:d   r104.0<1;1,0>:d                  {Compacted}
(W)     shl (1|M0)               r2.0<1>:d     r1.0<0;1,0>:d     2:w              
(W)     add (1|M0)               r1.2<1>:q     r3.2<0;1,0>:q     r2.0<0;1,0>:ud   {I@1}
L1408:
        add (32|M0)   (lt)f2.0   r108.0<1>:d   r1.1<0;1,0>:d     r106.0<1;1,0>:d 
(~f2.0) mov (32|M0)              r6.0<1>:d     r108.0<1;1,0>:d                  {@1,$4.src}
(f2.0)  add3 (32|M0)             r6.0<1>:d     r1.1<0;0>:d       r106.0<1;0>:d     2047:w              
        and (32|M0)              r6.0<1>:d     r6.0<1;1,0>:d     -2048:w               {I@1}
        add3 (32|M0)             r10.0<1>:d    r1.1<0;0>:d       r106.0<1;0>:d     -r6.0<1>:d       {@1,$10.src}
(f0.0)  sel (32|M0)              r16.0<1>:d    r106.0<1;1,0>:d   r10.0<1;1,0>:d   {I@1}
        mov (16|M0)              r18.0<2>:ud   r16.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r20.0<2>:ud   r17.0<1;1,0>:ud                  {Compacted}
        shl (16|M0)              r22.0<1>:q    r18.0<2;1,0>:d    12:w               {I@2}
        shl (16|M16)             r24.0<1>:q    r20.0<2;1,0>:d    12:w               {I@2}
        add (16|M0)              r26.0<1>:q    r1.2<0;1,0>:q     r22.0<1;1,0>:q   {Compacted,I@2}
        add (16|M16)             r28.0<1>:q    r1.2<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@2}
        send.ugm (32|M0)         r30      r26  null:0  0x0            0x08803580           {I@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64
        send.ugm (32|M0)         r38      r26  null:0  0x10000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x10]
        send.ugm (32|M0)         r46      r26  null:0  0x20000            0x08803580           {$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x20]
        send.ugm (32|M0)         r54      r26  null:0  0x30000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x30]
        send.ugm (32|M0)         r62      r26  null:0  0x40000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x40]
        send.ugm (32|M0)         r70      r26  null:0  0x50000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x50]
        send.ugm (32|M0)         r78      r26  null:0  0x60000            0x08803580           {$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x60]
        send.ugm (32|M0)         r86      r26  null:0  0x70000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x70]
(W)     mov (1|M0)               r2.0<1>:ud    0x1000:uw                             
(W)     mov (1|M0)               r5.0<1>:ud    0x1020:uw                             
(W)     send.slm (1|M0)          r12      r2  null:0  0x0            0x0210C500           {I@2,$3} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r8.0<1>:ud    0x1040:uw                              {$7.src}
(W)     mov (1|M0)               r9.0<1>:ud    0x1060:uw                             
(W)     send.slm (1|M0)          r13      r5  null:0  0x0            0x0210C500           {I@3,$5} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     send.slm (1|M0)          r14      r8  null:0  0x0            0x0210C500           {I@2,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     send.slm (1|M0)          r15      r9  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r2.0<1>:ud    0x1080:uw                              {$3.src}
(W)     mov (1|M0)               r5.0<1>:ud    0x10A0:uw                              {$5.src}
        sync.nop                             null                             {Compacted,$3.dst}
        mul (32|M0)              r6.0<1>:f     r12.0<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc2.0<1>:f   r12.1<0;1,0>:f    r32.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.5<0;1,0>:f    r40.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r10.0<1>:f    r12.4<0;1,0>:f    r38.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted,F@4}
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r34.0<1;1,0>:f   {Compacted,$8.src}
        add (32|M0)              acc0.0<1>:f   r10.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@3}
        mul (32|M0)              r16.0<1>:f    r12.3<0;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r18.0<1>:f    r12.6<0;1,0>:f    r42.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r24.0<1>:f    acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r94.0<1>:f    acc2.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$5.dst}
        mul (32|M0)              r20.0<1>:f    r13.0<0;1,0>:f    r46.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              r22.0<1>:f    r13.1<0;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.7<0;1,0>:f    r44.0<1;1,0>:f  
        mul (32|M0)              r6.0<1>:f     r13.4<0;1,0>:f    r54.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc2.0<1>:f   r13.5<0;1,0>:f    r56.0<1;1,0>:f  
        mul (32|M0)              r96.0<1>:f    r13.2<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              r98.0<1>:f    r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@5}
        add (32|M0)              r10.0<1>:f    r24.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     acc2.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r18.0<1>:f    r14.1<0;1,0>:f    r64.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r16.0<1>:f    r14.0<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r13.6<0;1,0>:f    r58.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r8.0<1>:f     r13.3<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              r30.0<1>:f    r94.0<1;1,0>:f    0.0:f               {Compacted}
        add (32|M0)              r32.0<1>:f    r98.0<1;1,0>:f    r96.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r38.0<1>:f    r14.2<0;1,0>:f    r66.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {F@7}
        send.ugm (32|M0)         r48      r26  null:0  0x80000            0x08803580           {F@6,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x80]
        mul (32|M0)              r36.0<1>:f    r13.7<0;1,0>:f    r60.0<1;1,0>:f  
        mul (32|M0)              r24.0<1>:f    r14.4<0;1,0>:f    r70.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              r34.0<1>:f    r30.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r20.0<1>:f    r32.0<1;1,0>:f    r8.0<1;1,0>:f    {F@7}
        mul (32|M0)              acc2.0<1>:f   r14.5<0;1,0>:f    r72.0<1;1,0>:f  
        send.ugm (32|M0)         r56      r26  null:0  0x90000            0x08803580           {F@5,$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x90]
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r14.3<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r10.0<1>:f    r15.1<0;1,0>:f    r80.0<1;1,0>:f   {Compacted,$1.dst}
        add (32|M0)              r6.0<1>:f     r34.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              r8.0<1>:f     r15.0<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r24.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc0.0<1>:f   r14.6<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r30.0<1>:f    r14.7<0;1,0>:f    r76.0<1;1,0>:f  
        add (32|M0)              r16.0<1>:f    r44.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r12.0<1>:f    r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@6}
        mul (32|M0)              r20.0<1>:f    r15.2<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    r8.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r18.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r24.0<1>:f    r12.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r36.0<1>:f    r18.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc2.0<1>:f   r22.0<1;1,0>:f    r20.0<1;1,0>:f  
        send.ugm (32|M0)         r16      r26  null:0  0xA0000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xA0]
        send.ugm (32|M0)         r64      r26  null:0  0xB0000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xB0]
        send.ugm (32|M0)         r72      r26  null:0  0xC0000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xC0]
        mul (32|M0)              r32.0<1>:f    r15.4<0;1,0>:f    r86.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              r34.0<1>:f    r15.5<0;1,0>:f    r88.0<1;1,0>:f  
        add (32|M0)              r42.0<1>:f    r24.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              r6.0<1>:f     r32.0<1;1,0>:f    r34.0<1;1,0>:f   {Compacted,F@2}
        send.ugm (32|M0)         r30      r26  null:0  0xD0000            0x08803580           {F@1,$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xD0]
        send.ugm (32|M0)         r94      r26  null:0  0xE0000            0x08803580           {$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xE0]
        mul (32|M0)              r38.0<1>:f    r15.3<0;1,0>:f    r84.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r40.0<1>:f    r15.6<0;1,0>:f    r90.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@2}
(W)     send.slm (1|M0)          r10      r2  null:0  0x0            0x0210C500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r46.0<1>:f    r15.7<0;1,0>:f    r92.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   r42.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$2.dst}
        mul (32|M0)              r14.0<1>:f    r10.0<0;1,0>:f    r48.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc0.0<1>:f   r10.1<0;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r10.5<0;1,0>:f    r58.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r38.0<1>:f    r10.4<0;1,0>:f    r56.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r11      r5  null:0  0x0            0x0210C500           {I@1,$3} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r24.0<1>:f    r10.2<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r38.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x10C0:uw                             
        mul (32|M0)              r40.0<1>:f    r10.3<0;1,0>:f    r54.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r10.6<0;1,0>:f    r60.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$5} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x10E0:uw                             
        add (32|M0)              r46.0<1>:f    acc2.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r88.0<1>:f    acc0.0<1;1,0>:f   r40.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$3.dst}
        mul (32|M0)              r44.0<1>:f    r11.0<0;1,0>:f    r16.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              acc2.0<1>:f   r10.7<0;1,0>:f    r62.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$8.src}
        mul (32|M0)              r6.0<1>:f     r11.1<0;1,0>:f    r18.0<1;1,0>:f   {Compacted,$5.src}
        mul (32|M0)              r14.0<1>:f    r11.4<0;1,0>:f    r64.0<1;1,0>:f   {$14.dst}
        mul (32|M0)              acc0.0<1>:f   r11.5<0;1,0>:f    r66.0<1;1,0>:f  
        send.ugm (32|M0)         r80      r26  null:0  0xF0000            0x08803580           {$9} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0xF0]
        mul (32|M0)              r90.0<1>:f    r11.2<0;1,0>:f    r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              r92.0<1>:f    r44.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r38.0<1>:f    r46.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$5.dst}
        mul (32|M0)              r42.0<1>:f    r12.1<0;1,0>:f    r74.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r40.0<1>:f    r12.0<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r11.6<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r24.0<1>:f    r11.3<0;1,0>:f    r22.0<1;1,0>:f   {Compacted}
        add (32|M0)              r48.0<1>:f    r8.0<1;1,0>:f     r88.0<1;1,0>:f   {Compacted}
        add (32|M0)              r50.0<1>:f    r92.0<1;1,0>:f    r90.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r40.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r54.0<1>:f    r11.7<0;1,0>:f    r70.0<1;1,0>:f  
        mul (32|M0)              r16.0<1>:f    r12.4<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              r52.0<1>:f    r48.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r50.0<1;1,0>:f    r24.0<1;1,0>:f   {F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r32.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r38.0<1>:f    r13.1<0;1,0>:f    r96.0<1;1,0>:f   {Compacted,$1.dst}
        mul (32|M0)              r24.0<1>:f    r13.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@7}
        add (32|M0)              r18.0<1>:f    r44.0<1;1,0>:f    r54.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@7}
        mul (32|M0)              r46.0<1>:f    r12.7<0;1,0>:f    r36.0<1;1,0>:f  
        add (32|M0)              r44.0<1>:f    r24.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@5}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r34.0<1;1,0>:f   {Compacted}
        send.ugm (32|M0)         r32      r26  null:0  0x100000            0x08803580           {F@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x100]
        send.ugm (32|M0)         r54      r26  null:0  0x110000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x110]
        mul (32|M0)              r20.0<1>:f    r12.3<0;1,0>:f    r78.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r52.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
        add (32|M0)              r42.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r10.0<1>:f    r14.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r98.0<1;1,0>:f   {Compacted}
        add (32|M0)              r50.0<1>:f    r42.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r16.0<1>:f    r10.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   r44.0<1;1,0>:f    r6.0<1;1,0>:f    {F@3}
        send.ugm (32|M0)         r40      r26  null:0  0x120000            0x08803580           {F@1,$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x120]
        send.ugm (32|M0)         r62      r26  null:0  0x130000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x130]
        send.ugm (32|M0)         r70      r26  null:0  0x140000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x140]
        send.ugm (32|M0)         r88      r26  null:0  0x150000            0x08803580           {$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x150]
        mul (32|M0)              r52.0<1>:f    r13.3<0;1,0>:f    r100.0<1;1,0>:f  {Compacted}
        send.ugm (32|M0)         r96      r26  null:0  0x160000            0x08803580           {F@1,$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x160]
        mul (32|M0)              r48.0<1>:f    r13.4<0;1,0>:f    r80.0<1;1,0>:f   {Compacted,$9.dst}
        mul (32|M0)              r8.0<1>:f     r13.5<0;1,0>:f    r82.0<1;1,0>:f  
(W)     mov (1|M0)               r2.0<1>:ud    0x1100:uw                             
        mul (32|M0)              r18.0<1>:f    r13.6<0;1,0>:f    r84.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r48.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@2}
        add (32|M0)              r20.0<1>:f    r16.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r8       r2  null:0  0x0            0x0210C500           {A@1,$2} // wr:1+0, rd:1; load.slm.d32x8t.a32
        send.ugm (32|M0)         r78      r26  null:0  0x170000            0x08803580           {$3} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x170]
        mul (32|M0)              r30.0<1>:f    r13.7<0;1,0>:f    r86.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r10.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$2.dst}
        mul (32|M0)              r14.0<1>:f    r8.0<0;1,0>:f     r32.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc0.0<1>:f   r8.1<0;1,0>:f     r34.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r5.0<1>:ud    0x1120:uw                             
        mul (32|M0)              acc2.0<1>:f   r8.5<0;1,0>:f     r56.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r18.0<1>:f    r8.4<0;1,0>:f     r54.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r9       r5  null:0  0x0            0x0210C500           {I@1,$5} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r16.0<1>:f    r8.2<0;1,0>:f     r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r18.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x1140:uw                             
        mul (32|M0)              r20.0<1>:f    r8.3<0;1,0>:f     r38.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r22.0<1>:f    r8.6<0;1,0>:f     r58.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x1160:uw                             
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r22.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r48.0<1>:f    acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$5.dst}
        mul (32|M0)              r24.0<1>:f    r9.0<0;1,0>:f     r40.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              acc2.0<1>:f   r8.7<0;1,0>:f     r60.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r6.0<1>:f     r9.1<0;1,0>:f     r42.0<1;1,0>:f   {Compacted,$8.src}
        mul (32|M0)              r14.0<1>:f    r9.4<0;1,0>:f     r62.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc0.0<1>:f   r9.5<0;1,0>:f     r64.0<1;1,0>:f  
        mul (32|M0)              r50.0<1>:f    r9.2<0;1,0>:f     r44.0<1;1,0>:f   {Compacted}
        add (32|M0)              r52.0<1>:f    r24.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@4}
        add (32|M0)              r18.0<1>:f    r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r22.0<1>:f    r12.1<0;1,0>:f    r72.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r20.0<1>:f    r12.0<0;1,0>:f    r70.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r9.6<0;1,0>:f     r66.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r16.0<1>:f    r9.3<0;1,0>:f     r46.0<1;1,0>:f   {Compacted}
        add (32|M0)              r32.0<1>:f    r10.0<1;1,0>:f    r48.0<1;1,0>:f   {Compacted}
        add (32|M0)              r34.0<1>:f    r52.0<1;1,0>:f    r50.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r24.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r10.0<1>:f    r12.2<0;1,0>:f    r74.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r20.0<1;1,0>:f    r22.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r38.0<1>:f    r9.7<0;1,0>:f     r68.0<1;1,0>:f  
        mul (32|M0)              r30.0<1>:f    r12.4<0;1,0>:f    r88.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              r36.0<1>:f    r32.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r34.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r90.0<1;1,0>:f  
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r42.0<1>:f    r12.3<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              r40.0<1>:f    r24.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r14.0<1>:f    r36.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r30.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r18.0<1>:f    r13.1<0;1,0>:f    r98.0<1;1,0>:f   {Compacted,$1.dst}
        mul (32|M0)              r32.0<1>:f    r12.7<0;1,0>:f    r94.0<1;1,0>:f  
        mul (32|M0)              r16.0<1>:f    r13.0<0;1,0>:f    r96.0<1;1,0>:f   {Compacted}
        add (32|M0)              r20.0<1>:f    r44.0<1;1,0>:f    r42.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r8.0<1>:f     r14.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              r24.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    r8.0<1;1,0>:f     r20.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r36.0<1>:f    r22.0<1;1,0>:f    r32.0<1;1,0>:f   {F@3}
        send.ugm (32|M0)         r16      r26  null:0  0x180000            0x08803580           {F@1,$11} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x180]
        send.ugm (32|M0)         r48      r26  null:0  0x190000            0x08803580           {$12} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x190]
        send.ugm (32|M0)         r56      r26  null:0  0x1A0000            0x08803580           {$13} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1A0]
        send.ugm (32|M0)         r64      r26  null:0  0x1B0000            0x08803580           {$14} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1B0]
        send.ugm (32|M0)         r86      r26  null:0  0x1C0000            0x08803580           {$15} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1C0]
        mul (32|M0)              r34.0<1>:f    r13.4<0;1,0>:f    r78.0<1;1,0>:f   {Compacted,$3.dst}
        mul (32|M0)              r10.0<1>:f    r13.5<0;1,0>:f    r80.0<1;1,0>:f  
        add (32|M0)              r42.0<1>:f    r30.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r34.0<1;1,0>:f    r10.0<1;1,0>:f   {Compacted,F@2}
        send.ugm (32|M0)         r30      r26  null:0  0x1D0000            0x08803580           {F@1,$0} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1D0]
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r100.0<1;1,0>:f  {Compacted}
        send.ugm (32|M0)         r94      r26  null:0  0x1E0000            0x08803580           {F@1,$1} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1E0]
        send.ugm (32|M0)         r72      r26  null:0  0x1F0000            0x08803580           {$2} // wr:4+0, rd:8; load.ugm.d32x4.a64.flat[A+0x1F0]
        mul (32|M0)              r38.0<1>:f    r13.3<0;1,0>:f    r102.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc2.0<1>:f   r24.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted}
(W)     mov (1|M0)               r2.0<1>:ud    0x1180:uw                             
        mul (32|M0)              r40.0<1>:f    r13.6<0;1,0>:f    r82.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@3}
(W)     send.slm (1|M0)          r10      r2  null:0  0x0            0x0210C500           {I@1,$3} // wr:1+0, rd:1; load.slm.d32x8t.a32
        mul (32|M0)              r46.0<1>:f    r13.7<0;1,0>:f    r84.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   r42.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r46.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r8.0<1>:f     acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$3.dst}
        mul (32|M0)              r14.0<1>:f    r10.0<0;1,0>:f    r16.0<1;1,0>:f   {Compacted,$11.dst}
        mul (32|M0)              acc0.0<1>:f   r10.1<0;1,0>:f    r18.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               r5.0<1>:ud    0x11A0:uw                             
        mul (32|M0)              acc2.0<1>:f   r10.5<0;1,0>:f    r50.0<1;1,0>:f   {$12.dst}
        mul (32|M0)              r26.0<1>:f    r10.4<0;1,0>:f    r48.0<1;1,0>:f   {Compacted,$2.src}
(W)     send.slm (1|M0)          r11      r5  null:0  0x0            0x0210C500           {I@1,$5} // wr:1+0, rd:1; load.slm.d32x8t.a32
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@4}
        mul (32|M0)              r24.0<1>:f    r10.2<0;1,0>:f    r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc2.0<1>:f   r26.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted,F@3}
(W)     mov (1|M0)               r6.0<1>:ud    0x11C0:uw                             
        mul (32|M0)              r28.0<1>:f    r10.3<0;1,0>:f    r22.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r38.0<1>:f    r10.6<0;1,0>:f    r52.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,F@4}
(W)     send.slm (1|M0)          r12      r6  null:0  0x0            0x0210C500           {I@1,$8} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     mov (1|M0)               r7.0<1>:ud    0x11E0:uw                             
        add (32|M0)              r42.0<1>:f    acc2.0<1;1,0>:f   r38.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              r44.0<1>:f    acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted}
(W)     send.slm (1|M0)          r13      r7  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$5.dst}
        mul (32|M0)              r40.0<1>:f    r11.1<0;1,0>:f    r58.0<1;1,0>:f   {Compacted,$13.dst}
        mul (32|M0)              acc2.0<1>:f   r10.7<0;1,0>:f    r54.0<1;1,0>:f  
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r6.0<1>:f     r11.0<0;1,0>:f    r56.0<1;1,0>:f   {Compacted,$8.src}
        mul (32|M0)              r14.0<1>:f    r11.4<0;1,0>:f    r64.0<1;1,0>:f   {$14.dst}
        mul (32|M0)              acc0.0<1>:f   r11.5<0;1,0>:f    r66.0<1;1,0>:f  
        mul (32|M0)              r46.0<1>:f    r11.2<0;1,0>:f    r60.0<1;1,0>:f   {Compacted}
        add (32|M0)              r80.0<1>:f    r6.0<1;1,0>:f     r40.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r18.0<1>:f    r42.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   r14.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@5}
        sync.nop                             null                             {Compacted,$8.dst}
        mul (32|M0)              r24.0<1>:f    r12.0<0;1,0>:f    r86.0<1;1,0>:f   {Compacted,$15.dst}
        mul (32|M0)              r26.0<1>:f    r12.1<0;1,0>:f    r88.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r11.6<0;1,0>:f    r68.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r20.0<1>:f    r11.3<0;1,0>:f    r62.0<1;1,0>:f   {Compacted}
        add (32|M0)              r16.0<1>:f    r8.0<1;1,0>:f     r44.0<1;1,0>:f   {Compacted}
        add (32|M0)              r22.0<1>:f    r80.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r38.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r8.0<1>:f     r12.2<0;1,0>:f    r90.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   r24.0<1;1,0>:f    r26.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              r40.0<1>:f    r11.7<0;1,0>:f    r70.0<1;1,0>:f  
        mul (32|M0)              r42.0<1>:f    r12.4<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              r28.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r6.0<1>:f     r22.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@7}
        mul (32|M0)              acc2.0<1>:f   r12.5<0;1,0>:f    r32.0<1;1,0>:f  
        add (32|M0)              r48.0<1>:f    acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@7}
        mul (32|M0)              r46.0<1>:f    r12.3<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        add (32|M0)              r44.0<1>:f    r38.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r14.0<1>:f    r28.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@5}
        add (32|M0)              acc2.0<1>:f   r42.0<1;1,0>:f    acc2.0<1;1,0>:f  {Compacted}
        sync.nop                             null                             {Compacted,$9.dst}
        mul (32|M0)              r16.0<1>:f    r13.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted,$1.dst}
        mul (32|M0)              r18.0<1>:f    r13.1<0;1,0>:f    r96.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc0.0<1>:f   r12.6<0;1,0>:f    r34.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r24.0<1>:f    r12.7<0;1,0>:f    r36.0<1;1,0>:f  
        add (32|M0)              r20.0<1>:f    r48.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r10.0<1>:f    r14.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r22.0<1>:f    acc2.0<1;1,0>:f   acc0.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r6.0<1>:f     r13.2<0;1,0>:f    r98.0<1;1,0>:f   {Compacted}
        add (32|M0)              r26.0<1>:f    r16.0<1;1,0>:f    r18.0<1;1,0>:f   {F@7}
        mul (32|M0)              r8.0<1>:f     r13.5<0;1,0>:f    r74.0<1;1,0>:f   {$2.dst}
        mul (32|M0)              r28.0<1>:f    r13.4<0;1,0>:f    r72.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r42.0<1>:f    r13.3<0;1,0>:f    r100.0<1;1,0>:f  {Compacted}
        add (32|M0)              r38.0<1>:f    r10.0<1;1,0>:f    r20.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              r40.0<1>:f    r22.0<1;1,0>:f    r24.0<1;1,0>:f   {Compacted,F@7}
        add (32|M0)              acc2.0<1>:f   r26.0<1;1,0>:f    r6.0<1;1,0>:f    {Compacted,F@6}
        mul (32|M0)              r44.0<1>:f    r13.6<0;1,0>:f    r76.0<1;1,0>:f   {Compacted}
        add (32|M0)              r14.0<1>:f    r28.0<1;1,0>:f    r8.0<1;1,0>:f    {Compacted,F@6}
        add (32|M0)              r46.0<1>:f    r38.0<1;1,0>:f    r40.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              r30.0<1>:f    acc2.0<1;1,0>:f   r42.0<1;1,0>:f   {Compacted}
        add (32|M0)              r82.0<1>:d    r114.8<0;1,0>:d   -r108.0<1;1,0>:d {Compacted}
        mul (32|M0)              r32.0<1>:f    r13.7<0;1,0>:f    r78.0<1;1,0>:f  
        add (32|M0)              acc2.0<1>:f   r14.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,F@4}
        add (32|M0)              acc0.0<1>:f   r46.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,F@3}
        cmp (32|M0)   (lt)f2.0   null<1>:d     r82.0<1;1,0>:d    1024:w               {I@1}
        add (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        add (32|M0)              r60.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(f2.0)  goto (32|M0)                         L5200                  L5200                
L5168:
        mov (32|M0)              r18.0<1>:ud   0x0:ud                             
        goto (32|M0)                         L5200                  L6128                
L5200:
        join (32|M0)                         L6128                                
L5216:
        mov (16|M0)              r6.0<2>:ud    r82.0<1;1,0>:ud                  {Compacted}
        mov (16|M16)             r8.0<2>:ud    r83.0<1;1,0>:ud                  {Compacted}
        shl (16|M0)              r10.0<1>:q    r6.0<2;1,0>:d     1:w               {I@2}
        shl (16|M16)             r12.0<1>:q    r8.0<2;1,0>:d     1:w               {I@2}
        add (16|M0)              r14.0<1>:q    r10.0<1;1,0>:q    r3.3<0;1,0>:q    {Compacted,A@2}
        add (16|M16)             r16.0<1>:q    r12.0<1;1,0>:q    r3.3<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r18      r14  null:0  0x0            0x08200B80           {I@1,$11} // wr:4+0, rd:2; load.ugm.d16u32.a64
        send.ugm (32|M0)         r20      r14  null:0  0x800000            0x08200B80           {$12} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x800]
        send.ugm (32|M0)         r22      r14  null:0  0x1000000            0x08200B80           {$13} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1000]
        send.ugm (32|M0)         r26      r14  null:0  0x2000000            0x08200B80           {$14} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2000]
        send.ugm (32|M0)         r24      r14  null:0  0x1800000            0x08200B80           {$15} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x1800]
        send.ugm (32|M0)         r28      r14  null:0  0x2800000            0x08200B80           {$0} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x2800]
        send.ugm (32|M0)         r30      r14  null:0  0x3000000            0x08200B80           {F@3,$1} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3000]
        send.ugm (32|M0)         r32      r14  null:0  0x3800000            0x08200B80           {F@2,$2} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x3800]
        send.ugm (32|M0)         r34      r14  null:0  0x4000000            0x08200B80           {$3} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4000]
        send.ugm (32|M0)         r36      r14  null:0  0x6800000            0x08200B80           {$5} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6800]
        send.ugm (32|M0)         r6       r14  null:0  0x4800000            0x08200B80           {$8} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x4800]
        send.ugm (32|M0)         r8       r14  null:0  0x5000000            0x08200B80           {$9} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5000]
        send.ugm (32|M0)         r10      r14  null:0  0x5800000            0x08200B80           {$6} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x5800]
        send.ugm (32|M0)         r12      r14  null:0  0x6000000            0x08200B80           {$7} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x6000]
        send.ugm (32|M0)         r38      r14  null:0  0x7000000            0x08200B80           {$4} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7000]
        send.ugm (32|M0)         r40      r14  null:0  0x7800000            0x08200B80           {$10} // wr:4+0, rd:2; load.ugm.d16u32.a64.flat[A+0x7800]
        shl (32|M0)              r42.0<1>:d    r18.0<1;1,0>:ud   16:w               {$11.dst}
        shl (32|M0)              r44.0<1>:d    r20.0<1;1,0>:ud   16:w               {$12.dst}
        mul (32|M0)              acc0.0<1>:f   r114.0<0;1,0>:f   r42.0<1;1,0>:f   {Compacted,I@2}
        mul (32|M0)              acc2.0<1>:f   r114.1<0;1,0>:f   r44.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r46.0<1>:d    r22.0<1;1,0>:ud   16:w               {$13.dst}
        shl (32|M0)              r54.0<1>:d    r26.0<1;1,0>:ud   16:w               {$14.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   0.0:f              
        shl (32|M0)              r48.0<1>:d    r24.0<1;1,0>:ud   16:w               {$15.dst}
        mul (32|M0)              r50.0<1>:f    r114.2<0;1,0>:f   r46.0<1;1,0>:f   {Compacted,I@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r114.4<0;1,0>:f   r54.0<1;1,0>:f   {Compacted,I@2}
        mul (32|M0)              r52.0<1>:f    r114.3<0;1,0>:f   r48.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r56.0<1>:d    r28.0<1;1,0>:ud   16:w               {$0.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r50.0<1;1,0>:f   {Compacted,F@4}
        shl (32|M0)              r58.0<1>:d    r30.0<1;1,0>:ud   16:w               {$1.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r52.0<1;1,0>:f   {Compacted,F@2}
        sync.nop                             null                             {I@2}
        mul (32|M0)              r14.0<1>:f    r114.5<0;1,0>:f   r56.0<1;1,0>:f   {$10.src}
        shl (32|M0)              r18.0<1>:d    r32.0<1;1,0>:ud   16:w               {$2.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r16.0<1>:f    r114.6<0;1,0>:f   r58.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r14.0<1;1,0>:f   {F@3}
        shl (32|M0)              r20.0<1>:d    r34.0<1;1,0>:ud   16:w               {$3.dst}
        mul (32|M0)              r24.0<1>:f    r114.7<0;1,0>:f   r18.0<1;1,0>:f   {I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,F@3}
        sync.nop                             null                             {Compacted,F@2}
        shl (32|M0)              r18.0<1>:d    r36.0<1;1,0>:ud   16:w               {$5.dst}
        shl (32|M0)              r22.0<1>:d    r6.0<1;1,0>:ud    16:w               {$8.dst}
        sync.nop                             null                             {Compacted,I@3}
        mul (32|M0)              r26.0<1>:f    r111.0<0;1,0>:f   r20.0<1;1,0>:f   {Compacted,$6.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted}
        shl (32|M0)              r30.0<1>:d    r8.0<1;1,0>:ud    16:w               {$9.dst}
        mul (32|M0)              acc2.0<1>:f   r111.5<0;1,0>:f   r18.0<1;1,0>:f   {I@3}
        mul (32|M0)              r28.0<1>:f    r111.1<0;1,0>:f   r22.0<1;1,0>:f   {Compacted,I@2}
        shl (32|M0)              r42.0<1>:d    r10.0<1;1,0>:ud   16:w               {$6.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@4}
        mul (32|M0)              r32.0<1>:f    r111.2<0;1,0>:f   r30.0<1;1,0>:f   {Compacted,I@2}
        shl (32|M0)              r44.0<1>:d    r12.0<1;1,0>:ud   16:w               {$7.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r34.0<1>:f    r111.3<0;1,0>:f   r42.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@3}
        mul (32|M0)              r6.0<1>:f     r111.4<0;1,0>:f   r44.0<1;1,0>:f   {Compacted,I@1}
        shl (32|M0)              r20.0<1>:d    r38.0<1;1,0>:ud   16:w               {$4.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r34.0<1;1,0>:f   {Compacted,F@3}
        shl (32|M0)              r22.0<1>:d    r40.0<1;1,0>:ud   16:w               {$10.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted,F@2}
        mul (32|M0)              r8.0<1>:f     r111.6<0;1,0>:f   r20.0<1;1,0>:f   {Compacted,I@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              r10.0<1>:f    r111.7<0;1,0>:f   r22.0<1;1,0>:f   {I@1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted,F@3}
        add (32|M0)              r18.0<1>:f    acc0.0<1;1,0>:f   r10.0<1;1,0>:f   {Compacted,F@2}
L6128:
        join (32|M0)                         L6312                                
L6144:
        mul (32|M0)              acc0.0<1>:f   r60.0<1;1,0>:f    r3.15<0;1,0>:f   {Compacted}
        shl (32|M0)              r8.0<1>:d     r106.0<1;1,0>:d   2:w               {Compacted,F@3}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {F@2}
        add3 (32|M0)             r10.0<1>:d    r1.2<0;0>:d       r8.0<1;0>:d       4096:w               {I@1}
        add (32|M0)              r6.0<1>:f     acc0.0<1;1,0>:f   -r119.0<0;1,0>:f {$7.dst}
        send.slm (32|M0)         null     r10  r6:2  0x0            0x04000504           {A@1,$11} // wr:2+2, rd:0; store.slm.d32.a32
        sel (32|M0)   (ge)f0.0   r112.0<1>:f   r112.0<1;1,0>:f   r6.0<1;1,0>:f   
        sync.nop                             null                             {Compacted,F@1}
        add (32|M0)              r6.0<1>:d     r106.0<1;1,0>:d   128:w               {Compacted,$11.src}
        cmp (32|M0)   (gt)f1.0   null<1>:d     r6.0<1;1,0>:d     r1.6<0;1,0>:d    {I@1}
(f1.0)  goto (32|M0)                         L6312                  L6312                
L6288:
        mov (32|M0)              r106.0<1>:f   r6.0<1;1,0>:f                    {Compacted}
(W)     jmpi                                 L1408                                
L6312:
        join (32|M0)                         L6328                                
L6328:
        sync.nop                             null                             {Compacted,I@4}
(W)     mov (32|M0)              r5.0<1>:f     -inf:f                               {$4.src}
        mov (32|M0)              r5.0<1>:f     r112.0<1;1,0>:f                  {Compacted}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {F@1}
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,$7.src}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
        sync.nop                             null                             {Compacted,I@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,$10.src}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r114.0<1>:f   r12.0<0;1,0>:f    r12.1<0;1,0>:f   {F@1}
(W)     send.slm (1|M0)          r13      r110  null:0  0x0            0x0210001F           {$12} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r14.2<1>:f    3.58732e-43:f                              
(W)     mov (2|M0)               r14.10<1>:ub  r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r13.0<1;1,0>:ud                  {$12.dst}
(W)     send.gtwy (1|M0)         null     r14  null:0  0x0            0x02000004           {I@2,$13} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               acc0.0<1>:d   r4.1<0;1,0>:d     r4.0<0;1,0>:uw  
(W)     macl (1|M0)              r5.0<1>:d     r4.1<0;1,0>:d     r4.0<0;1,0>:d   
(W)     mov (1|M0)               r1.9<1>:ud    0x2:uw                             
(W)     mul (1|M0)               acc0.0<1>:d   r5.0<0;1,0>:d     r4.4<0;1,0>:uw   {I@2}
(W)     macl (1|M0)              r2.0<1>:d     r5.0<0;1,0>:d     r4.2<0;1,0>:d    {Compacted}
(W)     mov (1|M0)               r3.58<2>:b    r110.8<0;1,0>:b                 
(W)     add (1|M0)               r2.1<1>:d     r2.0<0;1,0>:d     31:w               {Compacted,I@2}
(W)     mov (8|M0)               r7.0<1>:w     0x76543210:v                              
(W)     shr (1|M0)               r4.4<1>:ud    r2.1<0;1,0>:ud    3:w               {I@2}
(W)     mov (1|M0)               r1.11<1>:d    r3.58<0;1,0>:ub                 
(W)     shr (1|M0)               r1.13<1>:ud   r4.4<0;1,0>:ud    r1.9<0;1,0>:d    {I@2}
(W)     add (8|M0)               r7.8<1>:w     r7.0<1;1,0>:w     8:w              
(W)     add (1|M0)               r6.0<1>:d     r1.13<0;1,0>:d    -1:w               {I@2}
(W)     and (1|M0)               r4.3<1>:d     r2.0<0;1,0>:d     31:w              
(W)     cmp (1|M0)    (gt)f2.0   null<1>:ud    r6.0<0;1,0>:ud    r1.11<0;1,0>:ud  {I@2}
(W)     add (16|M0)              r7.16<1>:w    r7.0<1;1,0>:w     16:w              
        cmp (32|M0)   (eq)f1.0   null<2>:w     r7.0<1;1,0>:w     0:w               {I@1}
(W&~f2.0) cmp (1|M0)  (eq)f2.0   null<1>:d     r4.3<0;1,0>:d     0:w              
(W&~f2.0) sel (1|M0)             r1.14<1>:d    r4.3<0;1,0>:d     32:w              
(~f1.0) goto (32|M0)                         L6896                  L6896                
L6864:
(W)     shl (1|M0)               r2.0<1>:d     r1.11<0;1,0>:d    2:w              
(W)     send.slm (1|M0)          null     r2  r114:1  0x0            0x02008504           {I@1,$14} // wr:1+1, rd:0; store.slm.d32x1t.a32
L6896:
        join (32|M0)                         L6912                                
L6912:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$15} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$15.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$0} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     mul (1|M0)               r2.0<1>:d     r1.11<0;1,0>:d    32:w               {$14.src}
        mov (32|M0)              r20.0<1>:d    r7.0<1;1,0>:uw                  
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.13<0;1,0>:ud   0x20:uw             
        add (32|M0)              r22.0<1>:d    r2.0<0;1,0>:d     r20.0<1;1,0>:d   {I@2}
(W&f2.0) jmpi                                L7120                                
L7088:
(W)     mov (1|M0)               r1.8<1>:d     r1.13<0;1,0>:d                  
(W)     jmpi                                 L7856                                
L7120:
        shl (32|M0)              r16.0<1>:d    r22.0<1;1,0>:d    2:w               {Compacted,I@4}
(W)     shl (1|M0)               r114.0<1>:d   r1.11<0;1,0>:d    2:w               {Compacted}
(W)     mov (1|M0)               r1.5<1>:d     r1.13<0;1,0>:d                  
L7152:
(W)     add (1|M0)               r2.0<1>:d     r1.5<0;1,0>:d     31:w               {I@1}
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.5<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.4<1>:ud    r4.3<0;1,0>:ud    r1.9<0;1,0>:d    {I@1}
(W)     mul (1|M0)               r1.10<1>:d    r1.4<0;1,0>:d     32:w               {I@1}
(f3.0)  goto (32|M0)                         L7296                  L7296                
L7248:
        sync.nop                             null                             {$13.src}
        mov (32|M0)              r14.0<1>:ud   0xFF800000:ud                              {$1.dst}
        goto (32|M0)                         L7296                  L7344                
L7296:
        join (32|M0)                         L7344                                
L7312:
        sync.nop                             null                             {$13.src}
        send.slm (32|M0)         r14      r16  null:0  0x0            0x04200500           {I@3,$1} // wr:2+0, rd:2; load.slm.d32.a32
L7344:
        join (32|M0)                         L7360                                
L7360:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$4} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {Compacted,$3.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$0.src}
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {Compacted,$4.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$5} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.10<0;1,0>:ud 
(~f3.0) goto (32|M0)                         L7632                  L7632                
L7488:
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$5.src}
        mov (32|M0)              r5.0<1>:ud    r14.0<1;1,0>:ud                  {Compacted,$1.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r12.0<0;1,0>:f    r12.1<0;1,0>:f   {@1,$2.src}
(~f1.0) goto (32|M0)                         L7632                  L7632                
L7616:
(W)     send.slm (1|M0)          null     r114  r3:1  0x0            0x02008504           {F@1,$2} // wr:1+1, rd:0; store.slm.d32x1t.a32
L7632:
        join (32|M0)                         L7648                                
L7648:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$8} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$5.src}
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$8.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.4<0;1,0>:ud    0x20:uw             
(W)     mov (1|M0)               r1.10<1>:d    r1.4<0;1,0>:d                   
(W&f3.0) jmpi                                L7824                                
L7792:
(W)     mov (1|M0)               r1.8<1>:d     r1.10<0;1,0>:d                   {I@2}
(W)     jmpi                                 L7856                                
L7824:
(W)     mov (1|M0)               r1.5<1>:d     r1.4<0;1,0>:d                   
(W)     jmpi                                 L7152                                
L7856:
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.8<0;1,0>:ud    r1.14<0;1,0>:ud  {I@4}
(W&f3.0) jmpi                                L8192                                
L7888:
        cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.8<0;1,0>:ud    r20.0<1;1,0>:ud 
(f3.0)  goto (32|M0)                         L7968                  L7968                
L7920:
        sync.nop                             null                             {$13.src}
        mov (32|M0)              r14.0<1>:ud   0xFF800000:ud                              {$1.dst}
        goto (32|M0)                         L7968                  L8032                
L7968:
        join (32|M0)                         L8032                                
L7984:
        sync.nop                             null                             {Compacted,$3.src}
        shl (32|M0)              r6.0<1>:d     r20.0<1;1,0>:d    2:w               {Compacted,$0.src}
        sync.nop                             null                             {$13.src}
        send.slm (32|M0)         r14      r6  null:0  0x0            0x04200500           {I@1,$1} // wr:2+0, rd:2; load.slm.d32.a32
L8032:
        join (32|M0)                         L8048                                
L8048:
        sync.allrd                           ($1,$3)                
(W)     mov (32|M0)              r5.0<1>:ud    0xFF800000:ud                              {$0.src}
        mov (32|M0)              r5.0<1>:ud    r14.0<1;1,0>:ud                  {Compacted,$1.dst}
(W)     sel (16|M0)   (ge)f0.0   r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (8|M0)    (ge)f0.0   r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     sel (4|M0)    (ge)f0.0   r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     mov (2|M0)               r2.0<1>:ud    r11.2<1;1,0>:ud                  {Compacted,F@1}
(W)     sel (2|M0)    (ge)f0.0   r12.0<1>:f    r11.0<1;1,0>:f    r2.0<1;1,0>:f    {I@1}
(W)     sel (1|M0)    (ge)f0.0   r1.10<1>:f    r12.0<0;1,0>:f    r12.1<0;1,0>:f   {F@1}
(W)     jmpi                                 L8368                                
L8192:
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                             
(W)     mov (1|M0)               r1.4<1>:d     1:w                               {Compacted}
        sync.nop                             null                             {Compacted,$2.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$9} // wr:1+0, rd:1; load.slm.d32x1t.a32
L8240:
(W)     shl (1|M0)               r2.0<1>:d     r1.4<0;1,0>:d     2:w               {@1,$9.src}
(W)     add (1|M0)               r1.4<1>:d     r1.4<0;1,0>:d     1:w              
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$10} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r1.4<0;1,0>:ud    r1.8<0;1,0>:ud   {I@1}
        sync.nop                             null                             {Compacted,$10.dst}
(W)     sel (1|M0)    (ge)f0.0   r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$9.dst}
(W)     mov (1|M0)               r1.5<1>:f     r3.0<0;1,0>:f                    {F@1}
(W&f3.0) jmpi                                L8240                                
L8352:
(W)     mov (1|M0)               r1.10<1>:f    r1.5<0;1,0>:f                    {F@1}
L8368:
(W)     mov (1|M0)               f3.0<1>:ud    r1.7<0;1,0>:ud                  
(W)     mov (1|M0)               r1.5<1>:f     0xB5BFBE8E:f                              
(W)     mov (1|M0)               r1.4<1>:f     0xBF317200:f                               {I@3}
(~f3.0) goto (32|M0)                         L8464                  L8464                
L8432:
        mov (32|M0)              r24.0<1>:ud   0x0:ud                             
        goto (32|M0)                         L8464                  L8848                
L8464:
        join (32|M0)                         L8848                                
L8480:
        mov (32|M0)              r4.0<1>:d     r104.0<1;1,0>:d                  {Compacted}
        mov (32|M0)              r24.0<1>:f    0.0:f                               {Compacted,I@4}
L8496:
        sync.allrd                           ($3,$11)                
        shl (32|M0)              r6.0<1>:d     r4.0<1;1,0>:d     2:w               {Compacted,@1,$0.src}
        add3 (32|M0)             r8.0<1>:d     r1.2<0;0>:d       r6.0<1;0>:d       4096:w               {I@1}
        send.slm (32|M0)         r10      r8  null:0  0x0            0x04200500           {I@1,$12} // wr:2+0, rd:2; load.slm.d32.a32
        add (32|M0)              r4.0<1>:d     r4.0<1;1,0>:d     128:w               {Compacted}
        add (32|M0)              acc0.0<1>:f   r10.0<1;1,0>:f    -r1.10<0;1,0>:f  {@4,$12.dst}
        mul (32|M0)              acc2.0<1>:f   acc0.0<1;1,0>:f   1.442695e+00:f              
        rndz (32|M0)             r12.0<1>:f    acc2.0<1;1,0>:f                 
        mad (32|M0)              acc2.0<1>:f   acc0.0<1;0>:f     r12.0<1;0>:f      r1.4<0>:f        {Compacted,F@1}
        mad (32|M0)              acc2.0<1>:f   acc2.0<1;0>:f     r12.0<1;0>:f      r1.5<0>:f        {Compacted}
        sync.nop                             null                             {$13.src}
        mul (32|M0)              r14.0<1>:f    acc2.0<1;1,0>:f   1.442695e+00:f               {$1.dst}
        math.exp (32|M0)         r16.0<1>:f    r12.0<1;1,0>:f                  
        math.exp (32|M0)         r18.0<1>:f    r14.0<1;1,0>:f                   {F@1}
        mul (32|M0)              acc2.0<1>:f   r16.0<1;1,0>:f    r18.0<1;1,0>:f   {M@1}
        cmp (32|M0)   (lt)f3.0   null<1>:f     acc0.0<1;1,0>:f   -105.0:f              
(~f3.0) sel (32|M0)              acc2.0<1>:f   acc2.0<1;1,0>:f   0.0:f              
        cmp (32|M0)   (gt)f3.0   null<1>:f     acc0.0<1;1,0>:f   105.0:f              
(~f3.0) sel (32|M0)              r6.0<1>:f     acc2.0<1;1,0>:f   inf:f              
        cmp (32|M0)   (gt)f3.0   null<1>:d     r4.0<1;1,0>:d     r1.6<0;1,0>:d    {A@1}
        send.slm (32|M0)         null     r8  r6:2  0x0            0x04000504           {$11} // wr:2+2, rd:0; store.slm.d32.a32
        add (32|M0)              r24.0<1>:f    r24.0<1;1,0>:f    r6.0<1;1,0>:f   
(f3.0)  goto (32|M0)                         L8848                  L8848                
L8832:
(W)     jmpi                                 L8496                                
L8848:
        join (32|M0)                         L8864                                
L8864:
        sync.nop                             null                             {F@1}
        sync.allrd                           ($3,$11)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$0.src}
        mov (32|M0)              r5.0<1>:f     r24.0<1;1,0>:f                   {Compacted,I@1}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,F@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {Compacted,F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {Compacted,@1,$2.src}
(W)     send.slm (1|M0)          r12      r110  null:0  0x0            0x0210001F           {$14} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r13.2<1>:ud   0x100:ud                             
(W)     mov (2|M0)               r13.10<1>:ub  r110.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r12.0<1;1,0>:ud                  {$14.dst}
(W)     send.gtwy (1|M0)         null     r13  null:0  0x0            0x02000004           {I@2,$15} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(~f1.0) goto (32|M0)                         L9136                  L9136                
L9104:
(W)     shl (1|M0)               r2.0<1>:d     r1.11<0;1,0>:d    2:w               {F@1}
(W)     send.slm (1|M0)          null     r2  r3:1  0x0            0x02008504           {I@1,$0} // wr:1+1, rd:0; store.slm.d32x1t.a32
L9136:
        join (32|M0)                         L9152                                
L9152:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                              
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$2.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W&f2.0) jmpi                                L9296                                
L9264:
(W)     mov (1|M0)               r1.12<1>:d    r1.13<0;1,0>:d                  
(W)     jmpi                                 L10000                                
L9296:
        sync.nop                             null                             {Compacted,$13.src}
        shl (32|M0)              r14.0<1>:d    r22.0<1;1,0>:d    2:w               {Compacted,$1.dst}
(W)     shl (1|M0)               r114.0<1>:d   r1.11<0;1,0>:d    2:w              
(W)     mov (1|M0)               r1.7<1>:d     r1.13<0;1,0>:d                  
L9344:
(W)     add (1|M0)               r2.0<1>:d     r1.7<0;1,0>:d     31:w               {@1,$0.src}
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r22.0<1;1,0>:ud   r1.7<0;1,0>:ud  
(W)     shr (1|M0)               r4.3<1>:ud    r2.0<0;1,0>:ud    3:w               {I@2}
(W)     shr (1|M0)               r1.8<1>:ud    r4.3<0;1,0>:ud    r1.9<0;1,0>:d    {I@1}
(W)     mul (1|M0)               r1.11<1>:d    r1.8<0;1,0>:d     32:w               {I@1}
(f3.0)  goto (32|M0)                         L9472                  L9472                
L9440:
        sync.nop                             null                             {Compacted,$15.src}
        mov (32|M0)              r12.0<1>:ud   0x0:ud                              {Compacted,$4.dst}
        goto (32|M0)                         L9472                  L9520                
L9472:
        join (32|M0)                         L9520                                
L9488:
        sync.nop                             null                             {$15.src}
        send.slm (32|M0)         r12      r14  null:0  0x0            0x04200500           {I@3,$4} // wr:2+0, rd:2; load.slm.d32.a32
L9520:
        join (32|M0)                         L9536                                
L9536:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$9} // wr:1+0, rd:1; fence.slm.none.group
        sync.nop                             null                             {Compacted,$8.src}
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$3.src}
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {Compacted,$9.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$10} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (32|M0)   (lt)f2.0   null<1>:ud    r22.0<1;1,0>:ud   r1.11<0;1,0>:ud 
(~f2.0) goto (32|M0)                         L9792                  L9792                
L9664:
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$10.src}
        mov (32|M0)              r5.0<1>:ud    r12.0<1;1,0>:ud                  {Compacted,$4.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {Compacted,F@1}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r3.0<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {Compacted,@1,$5.src}
(~f1.0) goto (32|M0)                         L9792                  L9792                
L9776:
(W)     send.slm (1|M0)          null     r114  r3:1  0x0            0x02008504           {F@1,$5} // wr:1+1, rd:0; store.slm.d32x1t.a32
L9792:
        join (32|M0)                         L9808                                
L9808:
(W)     send.slm (1|M0)          r5       r110  null:0  0x0            0x0210001F           {$11} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r6.2<1>:f     3.58732e-43:f                               {$10.src}
(W)     mov (2|M0)               r6.10<1>:ub   r110.11<0;1,0>:ub                {F@1}
(W)     mov (8|M0)               null<1>:ud    r5.0<1;1,0>:ud                   {$11.dst}
(W)     send.gtwy (1|M0)         null     r6  null:0  0x0            0x02000004           {I@2,$8} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (gt)f3.0   null<1>:ud    r1.8<0;1,0>:ud    0x20:uw             
(W&f3.0) jmpi                                L9968                                
L9936:
(W)     mov (1|M0)               r1.12<1>:d    r1.8<0;1,0>:d                   
(W)     jmpi                                 L10000                                
L9968:
(W)     mov (1|M0)               r1.7<1>:d     r1.8<0;1,0>:d                   
(W)     jmpi                                 L9344                                
L10000:
(W)     cmp (32|M0)   (gt)f2.0   null<1>:ud    r1.12<0;1,0>:ud   r1.14<0;1,0>:ud  {I@4}
(W&f2.0) jmpi                                L10320                                
L10032:
        cmp (32|M0)   (gt)f1.0   null<1>:ud    r1.12<0;1,0>:ud   r20.0<1;1,0>:ud 
(f1.0)  goto (32|M0)                         L10096                  L10096                
L10064:
        sync.nop                             null                             {Compacted,$15.src}
        mov (32|M0)              r12.0<1>:ud   0x0:ud                              {Compacted,$4.dst}
        goto (32|M0)                         L10096                  L10160                
L10096:
        join (32|M0)                         L10160                                
L10112:
        sync.nop                             null                             {Compacted,$8.src}
        shl (32|M0)              r6.0<1>:d     r20.0<1;1,0>:d    2:w               {Compacted,$3.src}
        sync.nop                             null                             {$15.src}
        send.slm (32|M0)         r12      r6  null:0  0x0            0x04200500           {I@1,$4} // wr:2+0, rd:2; load.slm.d32.a32
L10160:
        join (32|M0)                         L10176                                
L10176:
        sync.allrd                           ($4,$8)                
(W)     mov (32|M0)              r5.0<1>:ud    0x0:ud                              {$3.src}
        mov (32|M0)              r5.0<1>:ud    r12.0<1;1,0>:ud                  {Compacted,$4.dst}
(W)     add (16|M0)              r7.0<1>:f     r5.0<1;1,0>:f     r6.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (8|M0)               r8.0<1>:ud    r7.8<1;1,0>:ud                   {Compacted,F@1}
(W)     add (8|M0)               r9.0<1>:f     r7.0<1;1,0>:f     r8.0<1;1,0>:f    {Compacted,I@1}
(W)     mov (4|M0)               r10.0<1>:ud   r9.4<1;1,0>:ud                   {Compacted,F@1}
(W)     add (4|M0)               r11.0<1>:f    r9.0<1;1,0>:f     r10.0<1;1,0>:f   {Compacted,I@1}
(W)     add (1|M0)               r2.0<1>:f     r11.0<0;1,0>:f    r11.2<0;1,0>:f   {@1,$0.src}
(W)     add (1|M0)               r2.1<1>:f     r11.1<0;1,0>:f    r11.3<0;1,0>:f  
(W)     add (1|M0)               r1.9<1>:f     r2.0<0;1,0>:f     r2.1<0;1,0>:f    {F@1}
(W)     jmpi                                 L10512                                
L10320:
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (1|M0)               r2.0<1>:ud    0x0:uw                              {$0.src}
(W)     mov (1|M0)               r1.7<1>:d     1:w                              
        sync.nop                             null                             {Compacted,$5.src}
(W)     send.slm (1|M0)          r3       r2  null:0  0x0            0x02108500           {I@2,$12} // wr:1+0, rd:1; load.slm.d32x1t.a32
L10384:
(W)     shl (1|M0)               r2.0<1>:d     r1.7<0;1,0>:d     2:w               {@1,$12.src}
(W)     add (1|M0)               r1.7<1>:d     r1.7<0;1,0>:d     1:w              
(W)     send.slm (1|M0)          r5       r2  null:0  0x0            0x02108500           {I@2,$14} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     cmp (32|M0)   (lt)f1.0   null<1>:ud    r1.7<0;1,0>:ud    r1.12<0;1,0>:ud  {I@1}
        sync.nop                             null                             {Compacted,$14.dst}
(W)     add (1|M0)               r3.0<1>:f     r3.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted,$12.dst}
(W)     mov (1|M0)               r1.8<1>:f     r3.0<0;1,0>:f                    {F@1}
(W&f1.0) jmpi                                L10384                                
L10496:
(W)     mov (1|M0)               r1.9<1>:f     r1.8<0;1,0>:f                    {F@1}
L10512:
(W)     mul (1|M0)               r2.0<1>:f     r1.10<0;1,0>:f    -1.442695e+00:f              
(W)     cmp (1|M0)    (gt)f2.0   null<1>:f     r1.10<0;1,0>:f    105.0:f              
        sync.nop                             null                             {Compacted,$8.src}
(W)     rndz (1|M0)              r6.0<1>:f     r2.0<0;1,0>:f                    {Compacted,@2,$3.src}
(W)     cmp (1|M0)    (lt)f1.0   null<1>:f     r1.10<0;1,0>:f    -105.0:f               {I@1}
(W)     mad (1|M0)               r4.3<1>:f     -r1.10<0;0>:f     r1.4<0;0>:f       r6.0<0>:f        {F@2}
(W)     math.exp (1|M0)          r5.0<1>:f     r6.0<0;1,0>:f                   
(W)     mad (1|M0)               r5.2<1>:f     r4.3<0;0>:f       r1.5<0;0>:f       r6.0<0>:f        {F@1}
(W)     mul (1|M0)               r6.1<1>:f     r5.2<0;1,0>:f     1.442695e+00:f               {F@1}
(W)     math.exp (1|M0)          r5.1<1>:f     r6.1<0;1,0>:f                    {F@1}
(W)     mul (1|M0)               r7.0<1>:f     r5.0<0;1,0>:f     r5.1<0;1,0>:f    {M@1}
(W&~f2.0) sel (1|M0)             r8.0<1>:f     r7.0<0;1,0>:f     0.0:f               {F@1}
(W&~f1.0) sel (1|M0)             r1.10<1>:f    r8.0<0;1,0>:f     inf:f               {F@1}
(W)     send.slm (1|M0)          r9       r110  null:0  0x0            0x0210001F           {$0} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (8|M0)               null<1>:ud    r9.0<1;1,0>:ud                   {Compacted,$0.dst}
(W)     send.ugm (1|M0)          r10      r110  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.ugm.none.group
(W)     mov (1|M0)               r11.2<1>:ud   0x100:ud                              {Compacted}
(W)     mov (2|M0)               r11.10<1>:ub  r110.11<0;1,0>:ub                {I@1}
(W)     mov (8|M0)               null<1>:ud    r10.0<1;1,0>:ud                  {$2.dst}
(W)     send.gtwy (1|M0)         null     r11  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.6<0;1,0>:d     7:w              
(W&~f3.0) jmpi                               L10896                                
L10848:
        mov (32|M0)              r38.0<1>:f    0.0:f                              
(W)     mov (1|M0)               r1.8<1>:d     0:w                              
(W)     jmpi                                 L21840                                
L10896:
(W)     add3 (1|M0)              r2.0<1>:d     r114.8<0;0>:d     -r1.1<0;0>:d      -7:w              
(W)     shr (1|M0)               r2.1<1>:ud    r2.0<0;1,0>:ud    3:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:ud    r2.0<0;1,0>:ud    0x18:uw             
(W)     add (1|M0)               r1.11<1>:d    r2.1<0;1,0>:d     1:w               {I@2}
(W)     and (1|M0)               r1.7<1>:d     r1.11<0;1,0>:d    3:w               {I@1}
(W&~f2.0) jmpi                               L11040                                
L10992:
        mov (32|M0)              r38.0<1>:f    0.0:f                               {Compacted}
(W)     mov (1|M0)               r40.0<1>:d    8:w                               {Compacted}
(W)     mov (1|M0)               r1.13<1>:d    0:w                              
(W)     jmpi                                 L19520                                
L11040:
        mov (32|M0)              r38.0<1>:f    0.0:f                               {Compacted}
(W)     and (1|M0)               r1.12<1>:d    r1.11<0;1,0>:d    1073741820:d              
(W)     mov (1|M0)               r40.4<1>:d    8:w                               {Compacted}
(W)     mov (1|M0)               r40.5<1>:d    0:w                              
(W)     mov (1|M0)               r1.11<1>:d    0:w                              
L11104:
(W)     add (1|M0)               r1.14<1>:d    r1.1<0;1,0>:d     r40.5<0;1,0>:d   {I@2}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    0:w               {A@1}
(W&f1.0) jmpi                                L11184                                
L11152:
(W)     mov (1|M0)               r1.15<1>:d    r1.14<0;1,0>:d                  
(W)     jmpi                                 L11200                                
L11184:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2047:w              
L11200:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.5<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.5<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,@1,$3.src}
        sync.allrd                           ($4,$13)                
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$1.dst}
        sync.nop                             null                             {Compacted,$15.src}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {@2,$4.dst}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r28      r18  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L11440                                
L11424:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2048:w              
L11440:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$8.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r24      r18  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L11664                                
L11648:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2049:w              
L11664:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$9.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L11888                                
L11872:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2050:w              
L11888:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$10.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r26      r18  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L12112                                
L12096:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2051:w              
L12112:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$11.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r30      r18  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L12336                                
L12320:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2052:w              
L12336:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$12.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r32      r18  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L12560                                
L12544:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2053:w              
L12560:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$14.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r34      r18  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L12784                                
L12768:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.5<0;0>:d      2054:w              
L12784:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     shl (1|M0)               r2.1<1>:d     r40.5<0;1,0>:d    2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r6.0<1>:d     r1.3<0;0>:d       r2.1<0;0>:d       4:w               {I@2}
(W)     add3 (1|M0)              r5.1<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      7:w               {I@2}
(W)     send.slm (1|M0)          r10      r6  null:0  0x0            0x0210B500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x4t.a32
(W)     add3 (1|M0)              r5.0<1>:d     r1.2<0;0>:d       r2.1<0;0>:d       4096:w              
(W)     shl (1|M0)               r10.4<1>:d    r5.1<0;1,0>:d     10:w               {@2,$2.dst}
(W)     send.slm (1|M0)          r9       r5  null:0  0x0            0x02108500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W)     add3 (1|M0)              r7.0<1>:d     r1.3<0;0>:d       r2.1<0;0>:d       20:w              
        add3 (32|M0)             r12.0<1>:d    r10.4<0;0>:d      r1.0<0;0>:d       r104.0<1>:d      {I@2}
(W)     send.slm (1|M0)          r11      r7  null:0  0x0            0x0210A500           {I@2,$6} // wr:1+0, rd:1; load.slm.d32x3t.a32
        mov (16|M0)              r14.0<2>:ud   r12.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r16.0<2>:ud   r13.0<1;1,0>:ud                  {Compacted}
(W)     shl (1|M0)               r40.2<1>:d    r40.4<0;1,0>:d    2:w              
        sync.nop                             null                             {Compacted,$0.src}
        mul (32|M0)              r18.0<1>:f    r10.0<0;1,0>:f    r24.0<1;1,0>:f   {Compacted,$9.dst}
        mul (32|M0)              r20.0<1>:f    r10.1<0;1,0>:f    r22.0<1;1,0>:f   {$10.dst}
        shl (16|M16)             r24.0<1>:q    r16.0<2;1,0>:d    2:w               {A@2}
        shl (16|M0)              r22.0<1>:q    r14.0<2;1,0>:d    2:w               {F@1}
        sync.nop                             null                             {Compacted,$2.dst}
        mul (32|M0)              acc0.0<1>:f   r9.0<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$8.dst}
        sync.nop                             null                             {Compacted,$6.src}
        mul (32|M0)              r6.0<1>:f     r10.2<0;1,0>:f    r26.0<1;1,0>:f   {Compacted,$11.dst}
(W)     add3 (1|M0)              r8.0<1>:d     r1.2<0;0>:d       r40.2<0;0>:d      4128:w               {I@3}
        add (16|M16)             r28.0<1>:q    r24.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,A@2}
        add (16|M0)              r26.0<1>:q    r22.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,A@1}
        sync.nop                             null                             {Compacted,$5.src}
(W)     send.slm (1|M0)          r3       r8  null:0  0x0            0x0210C500           {I@1,$9} // wr:1+0, rd:1; load.slm.d32x8t.a32
        sync.nop                             null                             {Compacted,$6.dst}
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r8.0<1>:f     r11.0<0;1,0>:f    r32.0<1;1,0>:f   {Compacted,$14.dst}
        send.ugm (32|M0)         r32      r26  null:0  0x0            0x08200580           {F@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
        add (32|M0)              acc0.0<1>:f   r38.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r11.1<0;1,0>:f    r34.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r30.0<1>:f    r10.3<0;1,0>:f    r30.0<1;1,0>:f   {Compacted,$12.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r8.0<1;1,0>:f    {Compacted}
(W)     add (1|M0)               r1.15<1>:d    r1.1<0;1,0>:d     r40.4<0;1,0>:d  
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.15<0;1,0>:d    0:w               {I@1}
(W)     add (1|M0)               r40.3<1>:d    r40.4<0;1,0>:d    8:w              
        mul (32|M0)              acc2.0<1>:f   r11.2<0;1,0>:f    r32.0<1;1,0>:f   {Compacted,$10.dst}
        add (32|M0)              r36.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(W&f3.0) jmpi                                L13392                                
L13360:
(W)     mov (1|M0)               r3.14<1>:d    r1.15<0;1,0>:d                   {$9.dst}
(W)     jmpi                                 L13408                                
L13392:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2047:w               {$9.dst}
L13408:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.15<0;1,0>:d    -1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.4<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.4<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {A@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {A@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,A@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r34      r18  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L13632                                
L13616:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2048:w              
L13632:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.15<0;1,0>:d    -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$11.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r30      r18  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L13856                                
L13840:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2049:w              
L13856:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.15<0;1,0>:d    -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$12.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r28      r18  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L14080                                
L14064:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2050:w              
L14080:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.15<0;1,0>:d    -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$14.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r24      r18  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L14304                                
L14288:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2051:w              
L14304:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.15<0;1,0>:d    -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$0.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L14528                                
L14512:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2052:w              
L14528:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.15<0;1,0>:d    -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$2.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r26      r18  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L14752                                
L14736:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2053:w              
L14752:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.15<0;1,0>:d    -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$8.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r32      r18  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L14976                                
L14960:
(W)     add3 (1|M0)              r3.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      2054:w              
L14976:
(W)     and (1|M0)               r2.0<1>:d     r3.14<0;1,0>:d    -2048:w               {I@1}
(W)     add3 (1|M0)              r5.0<1>:d     r1.2<0;0>:d       r40.2<0;0>:d      4096:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     send.slm (1|M0)          r6       r5  null:0  0x0            0x0210C500           {I@2,$10} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     add3 (1|M0)              r6.8<1>:d     r1.15<0;0>:d      -r4.3<0;0>:d      7:w               {@1,$10.dst}
(W)     add3 (1|M0)              r1.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      8:w              
(W)     shl (1|M0)               r8.0<1>:d     r6.8<0;1,0>:d     10:w               {I@2}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    0:w               {I@2}
        add3 (32|M0)             r10.0<1>:d    r8.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@2}
        mov (16|M0)              r14.0<2>:ud   r10.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r16.0<2>:ud   r11.0<1;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r18.0<1>:f    r6.3<0;1,0>:f     r24.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r20.0<1>:f    r6.4<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r34.0<1;1,0>:f   {Compacted,$11.dst}
        shl (16|M16)             r24.0<1>:q    r16.0<2;1,0>:d    2:w               {A@1}
        shl (16|M0)              r22.0<1>:q    r14.0<2;1,0>:d    2:w               {F@2}
        mul (32|M0)              r12.0<1>:f    r6.2<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc2.0<1>:f   r6.1<0;1,0>:f     r30.0<1;1,0>:f   {Compacted,$12.dst}
        add (16|M0)              r28.0<1>:q    r22.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,A@1}
        add (16|M16)             r30.0<1>:q    r24.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,F@1}
        send.ugm (32|M0)         r8       r28  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
        add (32|M0)              acc0.0<1>:f   r36.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r6.6<0;1,0>:f     r32.0<1;1,0>:f   {Compacted,$9.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r12.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f  
        mul (32|M0)              r26.0<1>:f    r6.5<0;1,0>:f     r26.0<1;1,0>:f   {$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W)     add (1|M0)               r40.6<1>:d    r40.4<0;1,0>:d    16:w              
        mul (32|M0)              acc2.0<1>:f   r6.7<0;1,0>:f     r8.0<1;1,0>:f    {$10.dst}
        add (32|M0)              r38.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W&f2.0) jmpi                                L15440                                
L15408:
(W)     mov (1|M0)               r1.15<1>:d    r1.14<0;1,0>:d                  
(W)     jmpi                                 L15456                                
L15440:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2047:w              
L15456:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.3<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.3<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {A@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r36      r18  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L15680                                
L15664:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2048:w              
L15680:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$11.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r34      r18  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L15904                                
L15888:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2049:w              
L15904:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$12.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r32      r18  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L16128                                
L16112:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2050:w              
L16128:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$14.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r30      r18  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L16352                                
L16336:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2051:w              
L16352:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$0.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r28      r18  null:0  0x0            0x08200580           {I@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L16576                                
L16560:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2052:w              
L16576:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$2.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r26      r18  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L16800                                
L16784:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2053:w              
L16800:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$8.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r24      r18  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L17024                                
L17008:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.3<0;0>:d      2054:w              
L17024:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
        mul (32|M0)              acc0.0<1>:f   r3.0<0;1,0>:f     r36.0<1;1,0>:f   {Compacted,$11.dst}
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@1}
        add (32|M0)              acc0.0<1>:f   r38.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      7:w               {I@1}
        mul (32|M0)              acc2.0<1>:f   r3.1<0;1,0>:f     r34.0<1;1,0>:f   {Compacted,$12.dst}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$9.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
        mul (32|M0)              acc2.0<1>:f   r3.2<0;1,0>:f     r32.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r3.3<0;1,0>:f     r30.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r3.4<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$2.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r3.5<0;1,0>:f     r26.0<1;1,0>:f   {$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r3.6<0;1,0>:f     r24.0<1;1,0>:f   {Compacted,$9.dst}
(W)     add3 (1|M0)              r1.14<1>:d    r1.1<0;0>:d       r40.4<0;0>:d      16:w              
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    0:w               {I@1}
(W)     add (1|M0)               r40.5<1>:d    r40.4<0;1,0>:d    24:w              
        mul (32|M0)              acc2.0<1>:f   r3.7<0;1,0>:f     r22.0<1;1,0>:f   {$10.dst}
        add (32|M0)              r36.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W&f3.0) jmpi                                L17440                                
L17408:
(W)     mov (1|M0)               r1.15<1>:d    r1.14<0;1,0>:d                  
(W)     jmpi                                 L17456                                
L17440:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2047:w              
L17456:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.6<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.6<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r34      r18  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L17680                                
L17664:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2048:w              
L17680:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$11.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r30      r18  null:0  0x0            0x08200580           {A@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L17904                                
L17888:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2049:w              
L17904:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$12.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r28      r18  null:0  0x0            0x08200580           {A@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L18128                                
L18112:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2050:w              
L18128:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$14.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r24      r18  null:0  0x0            0x08200580           {A@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L18352                                
L18336:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2051:w              
L18352:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.14<0;1,0>:d    -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$0.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {A@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L18576                                
L18560:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2052:w              
L18576:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.14<0;1,0>:d    -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$2.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {I@2}
        send.ugm (32|M0)         r26      r18  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L18800                                
L18784:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2053:w              
L18800:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.14<0;1,0>:d    -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$8.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r32      r18  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L19024                                
L19008:
(W)     add3 (1|M0)              r1.15<1>:d    r1.1<0;0>:d       r40.6<0;0>:d      2054:w              
L19024:
(W)     and (1|M0)               r2.0<1>:d     r1.15<0;1,0>:d    -2048:w               {I@1}
(W)     add3 (1|M0)              r5.0<1>:d     r1.2<0;0>:d       r40.2<0;0>:d      4160:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     send.slm (1|M0)          r6       r5  null:0  0x0            0x0210C500           {I@2,$10} // wr:1+0, rd:1; load.slm.d32x8t.a32
(W)     add3 (1|M0)              r6.8<1>:d     r1.14<0;0>:d      -r4.3<0;0>:d      7:w               {@1,$10.dst}
(W)     add (1|M0)               r1.11<1>:d    r1.11<0;1,0>:d    4:w              
(W)     shl (1|M0)               r8.0<1>:d     r6.8<0;1,0>:d     10:w               {I@2}
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r1.11<0;1,0>:d    r1.12<0;1,0>:d   {I@2}
        add3 (32|M0)             r10.0<1>:d    r8.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@2}
        mov (16|M0)              r14.0<2>:ud   r10.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r16.0<2>:ud   r11.0<1;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r18.0<1>:f    r6.3<0;1,0>:f     r24.0<1;1,0>:f   {Compacted,$0.dst}
        mul (32|M0)              r20.0<1>:f    r6.4<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$2.dst}
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r34.0<1;1,0>:f   {Compacted,$11.dst}
        shl (16|M16)             r24.0<1>:q    r16.0<2;1,0>:d    2:w               {A@1}
        shl (16|M0)              r22.0<1>:q    r14.0<2;1,0>:d    2:w               {F@2}
        mul (32|M0)              r12.0<1>:f    r6.2<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$14.dst}
        mul (32|M0)              acc2.0<1>:f   r6.1<0;1,0>:f     r30.0<1;1,0>:f   {Compacted,$12.dst}
        add (16|M0)              r28.0<1>:q    r22.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,A@1}
        add (16|M16)             r30.0<1>:q    r24.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,F@1}
        send.ugm (32|M0)         r8       r28  null:0  0x0            0x08200580           {I@1,$10} // wr:4+0, rd:2; load.ugm.d32.a64
        add (32|M0)              acc0.0<1>:f   r36.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
        mul (32|M0)              acc2.0<1>:f   r6.6<0;1,0>:f     r32.0<1;1,0>:f   {Compacted,$9.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r12.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        mul (32|M0)              r26.0<1>:f    r6.5<0;1,0>:f     r26.0<1;1,0>:f   {$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@2}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(W)     add (1|M0)               r40.4<1>:d    r40.4<0;1,0>:d    32:w              
(W)     mov (2|M0)               r40.0<1>:d    r40.4<1;1,0>:d                   {Compacted,I@1}
        mul (32|M0)              acc2.0<1>:f   r6.7<0;1,0>:f     r8.0<1;1,0>:f    {$10.dst}
        add (32|M0)              r38.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}
(W&~f1.0) jmpi                               L11104                                
L19440:
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r1.7<0;1,0>:d     0:w              
(W&~f1.0) jmpi                               L19504                                
L19472:
(W)     mov (1|M0)               r1.8<1>:d     r40.1<0;1,0>:d                   {I@4}
(W)     jmpi                                 L21840                                
L19504:
(W)     mov (1|M0)               r1.13<1>:d    r40.1<0;1,0>:d                  
L19520:
(W)     mov (1|M0)               r1.12<1>:d    r40.0<0;1,0>:d                  
(W)     mov (1|M0)               r40.2<1>:d    r1.13<0;1,0>:d                   {I@2}
(W)     mov (1|M0)               r1.14<1>:d    0:w                              
L19568:
(W)     add (1|M0)               r1.11<1>:d    r1.1<0;1,0>:d     r40.2<0;1,0>:d   {I@2}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.11<0;1,0>:d    0:w               {I@1}
(W&f3.0) jmpi                                L19648                                
L19616:
(W)     mov (1|M0)               r1.13<1>:d    r1.11<0;1,0>:d                  
(W)     jmpi                                 L19664                                
L19648:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2047:w              
L19664:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.11<0;1,0>:d    -1:w              
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.2<0;0>:d      -r2.0<0>:d       {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      1:w              
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.2<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {A@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,@1,$3.src}
        sync.allrd                           ($4,$13)                
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$1.dst}
        sync.nop                             null                             {Compacted,$15.src}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {@2,$4.dst}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r28      r18  null:0  0x0            0x08200580           {I@1,$11} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L19904                                
L19888:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2048:w              
L19904:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.11<0;1,0>:d    -2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      1:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$11.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r24      r18  null:0  0x0            0x08200580           {I@1,$12} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L20128                                
L20112:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2049:w              
L20128:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.11<0;1,0>:d    -3:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      3:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      2:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$12.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L20352                                
L20336:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2050:w              
L20352:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.11<0;1,0>:d    -4:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      4:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      3:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$14.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r26      r18  null:0  0x0            0x08200580           {I@1,$0} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L20576                                
L20560:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2051:w              
L20576:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f1.0   null<1>:d     r1.11<0;1,0>:d    -5:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      5:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      4:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$0.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r34      r18  null:0  0x0            0x08200580           {I@1,$2} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f1.0) jmpi                               L20800                                
L20784:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2052:w              
L20800:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.11<0;1,0>:d    -6:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      6:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      5:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {Compacted,I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                  
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$2.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r32      r18  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f3.0) jmpi                               L21024                                
L21008:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2053:w              
L21024:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r1.11<0;1,0>:d    -7:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      7:w              
(W)     add3 (1|M0)              r5.0<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      6:w               {I@2}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {I@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$8.src}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r36      r18  null:0  0x0            0x08200580           {I@1,$9} // wr:4+0, rd:2; load.ugm.d32.a64
(W&~f2.0) jmpi                               L21248                                
L21232:
(W)     add3 (1|M0)              r1.13<1>:d    r1.1<0;0>:d       r40.2<0;0>:d      2054:w              
L21248:
(W)     and (1|M0)               r2.0<1>:d     r1.13<0;1,0>:d    -2048:w               {I@1}
(W)     shl (1|M0)               r2.1<1>:d     r40.2<0;1,0>:d    2:w              
(W&~f0.0) sel (1|M0)             r4.3<1>:d     r2.0<0;1,0>:d     0:w               {I@2}
(W)     add3 (1|M0)              r6.0<1>:d     r1.3<0;0>:d       r2.1<0;0>:d       4:w               {I@2}
(W)     add3 (1|M0)              r5.1<1>:d     r1.11<0;0>:d      -r4.3<0;0>:d      7:w               {I@2}
(W)     send.slm (1|M0)          r9       r6  null:0  0x0            0x0210B500           {I@2,$10} // wr:1+0, rd:1; load.slm.d32x4t.a32
(W)     add3 (1|M0)              r5.0<1>:d     r1.2<0;0>:d       r2.1<0;0>:d       4096:w              
(W)     shl (1|M0)               r8.1<1>:d     r5.1<0;1,0>:d     10:w               {I@2}
(W)     send.slm (1|M0)          r8       r5  null:0  0x0            0x02108500           {I@1,$7} // wr:1+0, rd:1; load.slm.d32x1t.a32
        add3 (32|M0)             r12.0<1>:d    r8.1<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {$7.dst}
        mov (16|M0)              r14.0<2>:ud   r12.0<1;1,0>:ud                  {Compacted,I@1}
        mov (16|M16)             r16.0<2>:ud   r13.0<1;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$10.dst}
        sync.nop                             null                             {Compacted,$9.src}
        mul (32|M0)              r18.0<1>:f    r9.0<0;1,0>:f     r24.0<1;1,0>:f   {Compacted,$12.dst}
        mul (32|M0)              r20.0<1>:f    r9.1<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$14.dst}
        shl (16|M16)             r24.0<1>:q    r16.0<2;1,0>:d    2:w               {A@1}
        shl (16|M0)              r22.0<1>:q    r14.0<2;1,0>:d    2:w               {F@1}
(W)     add3 (1|M0)              r7.0<1>:d     r1.3<0;0>:d       r2.1<0;0>:d       20:w              
        mul (32|M0)              acc0.0<1>:f   r8.0<0;1,0>:f     r28.0<1;1,0>:f   {Compacted,$11.dst}
        add (16|M16)             r30.0<1>:q    r24.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@3}
        add (16|M0)              r28.0<1>:q    r22.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,A@1}
(W)     send.slm (1|M0)          r10      r7  null:0  0x0            0x0210A500           {I@3,$12} // wr:1+0, rd:1; load.slm.d32x3t.a32
        sync.nop                             null                             {Compacted,$12.src}
        mul (32|M0)              r6.0<1>:f     r9.3<0;1,0>:f     r34.0<1;1,0>:f   {$2.dst}
        send.ugm (32|M0)         r34      r28  null:0  0x0            0x08200580           {A@1,$14} // wr:4+0, rd:2; load.ugm.d32.a64
        add (32|M0)              acc0.0<1>:f   r38.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted}
        sync.nop                             null                             {Compacted,$12.dst}
        mul (32|M0)              acc2.0<1>:f   r10.1<0;1,0>:f    r36.0<1;1,0>:f   {Compacted,$9.dst}
        mul (32|M0)              r26.0<1>:f    r9.2<0;1,0>:f     r26.0<1;1,0>:f   {Compacted,$0.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,F@2}
        mul (32|M0)              r32.0<1>:f    r10.0<0;1,0>:f    r32.0<1;1,0>:f   {Compacted,$8.dst}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,F@2}
(W)     add (1|M0)               r1.14<1>:d    r1.14<0;1,0>:d    1:w              
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r1.14<0;1,0>:d    r1.7<0;1,0>:d    {I@1}
(W)     mov (1|M0)               r40.0<1>:d    r1.12<0;1,0>:d                   {Compacted}
        mul (32|M0)              acc2.0<1>:f   r10.2<0;1,0>:f    r34.0<1;1,0>:f   {Compacted,$14.dst}
        add (32|M0)              r38.0<1>:f    acc0.0<1;1,0>:f   acc2.0<1;1,0>:f 
(W&~f3.0) jmpi                               L21792                                
L21760:
(W)     mov (1|M0)               r1.8<1>:d     r40.0<0;1,0>:d                   {I@2}
(W)     jmpi                                 L21840                                
L21792:
(W)     mov (1|M0)               r40.2<1>:d    r1.12<0;1,0>:d                  
(W)     add (1|M0)               r1.12<1>:d    r1.12<0;1,0>:d    8:w              
(W)     jmpi                                 L19568                                
L21840:
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r1.8<0;1,0>:d     r1.6<0;1,0>:d    {I@5}
(W&f1.0) jmpi                                L22264                                
L21872:
(W)     mov (1|M0)               r40.0<1>:d    r1.8<0;1,0>:d                    {Compacted}
L21880:
(W)     shl (1|M0)               r2.0<1>:d     r40.0<0;1,0>:d    2:w               {Compacted,I@1}
(W)     add (1|M0)               r1.3<1>:d     r1.1<0;1,0>:d     r40.0<0;1,0>:d  
(W)     add3 (1|M0)              r5.0<1>:d     r1.2<0;0>:d       r2.0<0;0>:d       4096:w               {I@2}
(W)     cmp (32|M0)   (lt)f3.0   null<1>:d     r1.3<0;1,0>:d     0:w               {I@2}
        sync.nop                             null                             {$5.src}
(W)     send.slm (1|M0)          r3       r5  null:0  0x0            0x02108500           {I@2,$2} // wr:1+0, rd:1; load.slm.d32x1t.a32
(W&~f3.0) jmpi                               L22000                                
L21984:
(W)     add3 (1|M0)              r1.3<1>:d     r1.1<0;0>:d       r40.0<0;0>:d      2047:w              
L22000:
(W)     and (1|M0)               r2.0<1>:d     r1.3<0;1,0>:d     -2048:w               {I@1}
(W)     cmp (32|M0)   (lt)f2.0   null<1>:d     r40.0<0;1,0>:d    r1.6<0;1,0>:d   
(W)     add3 (1|M0)              r4.3<1>:d     r1.1<0;0>:d       r40.0<0;0>:d      -r2.0<0>:d       {I@2}
(W&f0.0) sel (1|M0)              r5.0<1>:d     r40.0<0;1,0>:d    r4.3<0;1,0>:d    {@1,$2.src}
(W)     shl (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     10:w               {A@1}
        add3 (32|M0)             r8.0<1>:d     r6.0<0;0>:d       r1.0<0;0>:d       r104.0<1>:d      {I@1}
        sync.nop                             null                             {Compacted,A@1}
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,$3.src}
        sync.allrd                           ($4,$13)                
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$1.dst}
        sync.nop                             null                             {Compacted,$15.src}
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {@2,$4.dst}
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,@2,$2.dst}
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (32|M0)         r22      r18  null:0  0x0            0x08200580           {I@1,$5} // wr:4+0, rd:2; load.ugm.d32.a64
        mul (32|M0)              acc0.0<1>:f   r3.0<0;1,0>:f     r22.0<1;1,0>:f   {Compacted,$5.dst}
        add (32|M0)              r38.0<1>:f    r38.0<1;1,0>:f    acc0.0<1;1,0>:f  {Compacted,F@2}
(W&~f2.0) jmpi                               L22264                                
L22240:
(W)     add (1|M0)               r40.0<1>:d    r40.0<0;1,0>:d    1:w               {Compacted}
(W)     jmpi                                 L21880                                
L22264:
        add (16|M0)              r8.0<1>:q     r117.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted}
        add (16|M16)             r10.0<1>:q    r115.0<1;1,0>:q   r3.5<0;1,0>:q    {Compacted,$3.src}
        sync.nop                             null                             {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$15.src}
        send.ugm (32|M0)         r12      r8  null:0  0x0            0x08200580           {I@1,$8} // wr:4+0, rd:2; load.ugm.d32.a64
(W)     add (1|M0)               r2.0<1>:f     r1.9<0;1,0>:f     r1.10<0;1,0>:f   {Compacted}
(W)     mov (1|M0)               r2.3<1>:f     0x4F800000:f                              
(W)     and (1|M0)    (eq)f3.0   r2.1<1>:d     r2.0<0;1,0>:d     2139095040:d               {F@2}
(W)     and (1|M0)               r7.0<1>:d     r2.0<0;1,0>:d     8388607:d              
(W)     mov (16|M0)              r127.0<1>:f   r110.0<1;1,0>:f                 
(W)     cmp (1|M0)    (ge)f1.0   null<1>:ud    r2.1<0;1,0>:ud    0x64000000:ud              {I@2}
(W&f3.0) sel (1|M0)              r4.3<1>:f     r2.3<0;1,0>:f     1.0:f               {F@2}
(W&~f1.0) sel (1|M0)             r5.0<1>:f     r4.3<0;1,0>:f     0x2F800000:f               {F@1}
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r7.0<0;1,0>:d     0:w               {A@1}
(W&~f1.0) cmp (32|M0) (eq)f1.0   null<1>:d     r2.1<0;1,0>:d     0:w              
(W)     mul (1|M0)               r5.1<1>:f     r2.0<0;1,0>:f     r5.0<0;1,0>:f    {Compacted}
(W)     not (1|M0)               f0.0<1>:ud    f1.0<0;1,0>:ud                  
(W)     math.inv (1|M0)          r6.0<1>:f     r5.1<0;1,0>:f                    {F@1}
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:f     r38.0<1;1,0>:f    r2.0<0;1,0>:f    {I@1}
        mul (32|M0)              acc0.0<1>:f   r6.0<0;1,0>:f     r38.0<1;1,0>:f   {Compacted,M@1}
        mul (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   r5.0<0;1,0>:f    {Compacted}
(~f0.0) sel (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   1.0:f              
        mul (32|M0)              acc2.0<1>:f   r12.0<1;1,0>:f    -1.442695e+00:f               {$8.dst}
        sync.nop                             null                             {Compacted,$13.src}
        rndz (32|M0)             r14.0<1>:f    acc2.0<1;1,0>:f                  {$1.dst}
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
        add (16|M0)              r16.0<1>:q    r117.0<1;1,0>:q   r3.6<0;1,0>:q   
        add (16|M16)             r18.0<1>:q    r115.0<1;1,0>:q   r3.6<0;1,0>:q   
        and (32|M0)              r6.0<1>:d     r14.0<1;1,0>:d    -65536:d               {I@3}
        send.ugm (32|M0)         null     r16  r6:2  0x0            0x08000584           {I@1,$9} // wr:4+2, rd:0; store.ugm.d32.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$10} // wr:1+0, rd:0; end of thread
L22912:
(W)     mov (16|M0)              null<1>:ud    0x58E7D8B1:ud                             
(W)     mov (16|M0)              null<1>:ud    0x4738DA7C:ud                             
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
