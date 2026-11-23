L0:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                              {A@1}
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud             
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw             
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x40:ud              {I@2}
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1}
(W)     send.ugm (1|M0)          r1       r127  null:0  0xFF000000            0x6219D500           {A@1,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
        nop                    
        nop                    
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src}
(W)     send.ugm (1|M0)          r2       r127  null:0  0xFF000000            0x6219D500           {A@1,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
(W)     mov (16|M0)              r3.0<1>:ud    r0.0<1;1,0>:ud                   {Compacted}
        mov (1|M0)               r9.0<1>:uq    r2.5<0;1,0>:uq                   {Compacted,$1.dst}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r0.2<0;1,0>:uw   {A@1}
        mach (1|M0)              r5.0<1>:ud    r2.0<0;1,0>:ud    r0.1<0;1,0>:ud   {Compacted}
        mov (16|M0)              r31.0<1>:f    0.0:f                               {Compacted}
        mov (1|M0)               r4.0<1>:ud    acc0.0<0;1,0>:ud                
        mov (1|M0)               r2.15<1>:d    r5.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r2.14<1>:d    r4.0<0;1,0>:d                    {I@2}
        mov (16|M0)              r33.0<1>:d    0:w                              
        add (1|M0)               r2.7<1>:q     r2.7<0;1,0>:q     r1.0<0;1,0>:uw   {@2,$0.dst}
        send.ugm (1|M0)          r29      r9  null:0  0x0            0x0220E580           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mul (1|M0)               acc0.0<1>:ud  r2.14<0;1,0>:ud   0x8E39:uw              {I@1}
        mach (1|M0)              r6.0<1>:ud    r2.14<0;1,0>:ud   0x38E38E39:ud             
        add (1|M0)               r28.0<1>:uq   r9.0<0;1,0>:uq    0x80:uw             
        shr (1|M0)               r6.0<1>:ud    r6.0<0;1,0>:ud    0x5:uw              {Compacted,I@2}
        mov (1|M0)               r1.4<1>:q     0:w                              
        mul (1|M0)               r1.2<1>:d     r6.0<0;1,0>:d     7:w               {Compacted,I@2}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     3:w               {I@1}
        and (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     127:w               {I@1}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     -r6.0<0;1,0>:d   {I@1}
        mul (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     144:w               {I@1}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r2.14<0;1,0>:d   {I@1}
        mul (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     36:w               {I@1}
        shl (1|M0)               r1.2<1>:q     r1.2<0;1,0>:ud    9:w               {I@1}
        shl (1|M0)               r1.3<1>:q     r1.2<0;1,0>:ud    6:w              
        add (1|M0)               r7.0<1>:q     r2.3<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}
        add (1|M0)               r8.0<1>:q     r2.4<0;1,0>:q     r1.3<0;1,0>:q    {Compacted,I@2}
        send.ugm (1|M0)          r18      r7  null:0  0x0            0x0240F580           {I@2,$3} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r22      r7  null:0  0x100000            0x0240F580           {$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r10      r7  null:0  0x200000            0x0240F580           {$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x200]
        send.ugm (1|M0)          r14      r7  null:0  0x300000            0x0240F580           {$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x300]
        send.ugm (1|M0)          r27      r8  null:0  0x0            0x0210D580           {I@1,$7} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        add (1|M0)               r26.0<1>:uq   r8.0<0;1,0>:uq    0x40:uw             
L656:
        send.ugm (1|M0)          r34      r28  null:0  0x0            0x0220E580           {$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r32      r26  null:0  0x0            0x0210D580           {I@1,$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.allwr                           ($3,$4,$8,$12,$13)                
        dpas.8x1 (16|M0)         r36:f         null:f            r18:hf            r29.0:hf         {Atomic,$2.dst}
        dpas.8x1 (16|M0)         r37:f         null:f            r18:hf            r29.16:hf        {Atomic}
        dpas.8x1 (16|M0)         r38:f         null:f            r18:hf            r30.0:hf         {$2}
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r1.8<0;1,0>:ud    0x22:uw             
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r36.0<1;1,0>:f   {Compacted,@1,$2.dst}
        dpas.8x1 (16|M0)         r39:f         null:f            r18:hf            r30.16:hf        {$15}
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r37.0<1;1,0>:f   {Compacted,F@1}
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r1.9<0;1,0>:d     0:w              
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r38.0<1;1,0>:f   {Compacted,F@1}
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r39.0<1;1,0>:f   {Compacted,@1,$15.dst}
(W&f0.0) jmpi                                L880                                
L848:
        mov (16|M0)              r43.0<1>:d    r27.0<1;1,0>:d                   {$7.dst}
(W)     jmpi                                 L1056                                
L880:
        add (1|M0)               r1.7<1>:q     r1.4<0;1,0>:q     2:w              
        shl (1|M0)               r1.5<1>:q     r1.7<0;1,0>:q     9:w               {I@1}
        shl (1|M0)               r1.6<1>:q     r1.7<0;1,0>:q     6:w              
        shl (1|M0)               r1.7<1>:q     r1.7<0;1,0>:q     7:w              
        add (1|M0)               r40.0<1>:q    r7.0<0;1,0>:q     r1.5<0;1,0>:q    {I@3}
        add (1|M0)               r41.0<1>:q    r8.0<0;1,0>:q     r1.6<0;1,0>:q    {I@3}
        add (1|M0)               r42.0<1>:q    r9.0<0;1,0>:q     r1.7<0;1,0>:q    {I@3}
        send.ugm (1|M0)          r18      r40  null:0  0x0            0x0240F580           {I@3,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r22      r40  null:0  0x100000            0x0240F580           {$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r43      r41  null:0  0x0            0x0210D580           {I@2,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r29      r42  null:0  0x0            0x0220E580           {I@1,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L1056:
        sync.allwr                           ($6,$9,$10,$11)                
        dpas.8x1 (16|M0)         r44:f         null:f            r10:hf            r34.0:hf         {Atomic,$5.dst}
        dpas.8x1 (16|M0)         r45:f         null:f            r10:hf            r34.16:hf        {Atomic}
        dpas.8x1 (16|M0)         r46:f         null:f            r10:hf            r35.0:hf         {$5}
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r44.0<1;1,0>:f   {Compacted,@1,$5.dst}
        dpas.8x1 (16|M0)         r47:f         null:f            r10:hf            r35.16:hf        {$1}
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r45.0<1;1,0>:f   {Compacted,F@1}
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r46.0<1;1,0>:f   {Compacted,F@1}
        sync.nop                             null                             {Compacted,$14.dst}
        bfn.0x96 (16|M0)         r33.0<1>:ud   r27.0<1;0>:ud     r33.0<1;0>:ud     r32.0<1>:ud      {$7.dst} // s0^s1^s2
        add (16|M0)              r31.0<1>:f    r31.0<1;1,0>:f    r47.0<1;1,0>:f   {Compacted,@1,$1.dst}
(W&~f0.0) jmpi                               L1344                                
L1208:
        add (1|M0)               r28.0<1>:q    r1.4<0;1,0>:q     3:w               {Compacted}
        mov (16|M0)              r27.0<1>:d    r43.0<1;1,0>:d                   {Compacted,$0.dst}
        shl (1|M0)               r2.2<1>:q     r28.0<0;1,0>:q    9:w               {Compacted,I@2}
        shl (1|M0)               r26.0<1>:q    r28.0<0;1,0>:q    6:w               {Compacted}
        add (1|M0)               r48.0<1>:q    r7.0<0;1,0>:q     r2.2<0;1,0>:q    {Compacted,I@2}
        shl (1|M0)               r28.0<1>:q    r28.0<0;1,0>:q    7:w              
        send.ugm (1|M0)          r10      r48  null:0  0x0            0x0240F580           {I@2,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r14      r48  null:0  0x100000            0x0240F580           {$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        add (1|M0)               r1.4<1>:q     r1.4<0;1,0>:q     2:w              
        add (1|M0)               r26.0<1>:q    r8.0<0;1,0>:q     r26.0<0;1,0>:q   {Compacted}
        add (1|M0)               r28.0<1>:q    r9.0<0;1,0>:q     r28.0<0;1,0>:q   {Compacted,I@3}
(W)     jmpi                                 L656                                
L1344:
        shl (1|M0)               r2.7<1>:q     r2.7<0;1,0>:q     6:w              
        add (16|M0)              r49.0<1>:f    r31.0<1;1,0>:f    r33.0<1;1,0>:f   {Compacted,F@1}
(W)     mov (16|M0)              r127.0<1>:ud  r3.0<1;1,0>:ud                   {Compacted}
        add (1|M0)               r50.0<1>:q    r2.6<0;1,0>:q     r2.7<0;1,0>:q    {I@2}
        send.ugm (1|M0)          null     r50  r49:1  0x0            0x0200D584           {A@1,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$3} // wr:1+0, rd:0; end of thread
L1424:
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
        illegal                
