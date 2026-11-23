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
(W)     mov (16|M0)              r26.0<1>:ud   r0.0<1;1,0>:ud                   {Compacted}
        mov (1|M0)               r125.0<1>:uq  r2.5<0;1,0>:uq                   {Compacted,$1.dst}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r0.2<0;1,0>:uw   {A@1}
        mach (1|M0)              r4.0<1>:ud    r2.0<0;1,0>:ud    r0.1<0;1,0>:ud   {Compacted}
        mov (16|M0)              r113.0<1>:f   0.0:f                               {Compacted}
        mov (1|M0)               r3.0<1>:ud    acc0.0<0;1,0>:ud                
        mov (1|M0)               r126.3<1>:d   r4.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r126.2<1>:d   r3.0<0;1,0>:d                    {I@2}
        send.ugm (1|M0)          r114     r125  null:0  0x0            0x0220E580           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   r1.0<0;1,0>:uw   {@1,$0.dst}
        add (1|M0)               r105.0<1>:uq  r125.0<0;1,0>:uq  0x80:uw             
(W)     mul (1|M0)               acc0.0<1>:ud  r126.2<0;1,0>:ud  0x8E39:uw              {I@2}
        mach (1|M0)              r5.0<1>:ud    r126.2<0;1,0>:ud  0x38E38E39:ud             
        mov (1|M0)               r95.1<1>:q    0:w                              
        shr (1|M0)               r5.0<1>:ud    r5.0<0;1,0>:ud    0x5:uw              {Compacted,I@2}
        mul (1|M0)               r6.0<1>:d     r5.0<0;1,0>:d     7:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     3:w               {Compacted,I@1}
        and (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     127:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     -r5.0<0;1,0>:d   {I@1}
        mul (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     144:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     r126.2<0;1,0>:d  {Compacted,I@1}
        mul (1|M0)               r6.0<1>:d     r6.0<0;1,0>:d     36:w               {Compacted,I@1}
        shl (1|M0)               r7.0<1>:q     r6.0<0;1,0>:ud    9:w               {I@1}
        shl (1|M0)               r8.0<1>:q     r6.0<0;1,0>:ud    6:w              
        add (1|M0)               r126.0<1>:q   r2.3<0;1,0>:q     r7.0<0;1,0>:q    {Compacted,I@2}
        add (1|M0)               r95.0<1>:q    r2.4<0;1,0>:q     r8.0<0;1,0>:q    {I@2}
        send.ugm (1|M0)          r100     r126  null:0  0x0            0x0240F580           {I@2,$3} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r117     r126  null:0  0x100000            0x0240F580           {$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r96      r126  null:0  0x200000            0x0240F580           {$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x200]
        send.ugm (1|M0)          r121     r126  null:0  0x300000            0x0240F580           {$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x300]
        send.ugm (1|M0)          r116     r95  null:0  0x0            0x0210D580           {I@1,$7} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        add (1|M0)               r104.0<1>:uq  r95.0<0;1,0>:uq   0x40:uw             
L608:
        sync.nop                             null                             {$13.dst}
        shr (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x4:uw              {$3.dst}
        shl (16|M0)              r18.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r8.0<1>:ud    acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r101.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r20.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r19.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc0.0<1;0>:ud    r19.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r22.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r21.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r9.0<1>:ud    acc0.0<1;0>:ud    r21.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r101.0<1;1,0>:ud  0x8:uw             
        sync.nop                             null                             {$8.dst}
        and (16|M0)              r29.0<1>:w    r116.0<1;1,0>:ub  127:w               {$7.dst}
        shl (16|M0)              r24.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r23.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r30.0<1>:d    r29.0<2;1,0>:ub                  {I@3}
        and (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r25.0<1>:d    r100.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r27.0<1>:d    r101.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r30.0<1>:d    r30.0<1;1,0>:d    20:w               {I@4}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc0.0<1;0>:ud    r23.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r10.0<1>:ud   r25.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r101.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r27.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r30.0<1;1,0>:f    1.329228e+36:f               {I@1}
        shr (16|M0)              acc2.0<1>:ud  r102.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r44.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r43.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r34.0<1>:ud   acc2.0<1;0>:ud    r43.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r103.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r46.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r45.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r46.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r38.0<1>:ud   acc2.0<1;0>:ud    r45.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r102.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r48.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r47.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r48.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r35.0<1>:ud   acc2.0<1;0>:ud    r47.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r103.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r4.0<1>:d     r100.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r16.0<1>:d    r101.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r50.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r3.0<1>:d     r100.0<1;1,0>:d   9:w               {Compacted,$11.src}
        shl (16|M0)              r15.0<1>:d    r101.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r32.0<1>:d    r102.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r42.0<1>:d    r103.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r49.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@7}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              acc2.0<1>:ud  r50.0<1;1,0>:ud   0x80008000:ud              {I@7}
        and (16|M0)              r51.0<1>:d    r102.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r31.0<1>:d    r102.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r41.0<1>:d    r103.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r53.0<1>:d    r103.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r55.0<1>:w    r116.16<1;1,0>:ub  127:w             
        and (16|M0)              r32.0<1>:d    r32.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r42.0<1>:d    r42.0<1;1,0>:d    -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r7.0<1>:ud    r4.0<1;0>:ud      r3.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r11.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r39.0<1>:ud   acc2.0<1;0>:ud    r49.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r102.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r36.0<1>:ud   r51.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r103.0<1;1,0>:ud  0x3:uw             
        mov (16|M0)              r56.0<1>:d    r55.0<2;1,0>:ub                  {I@7}
        bfn.0xEA (16|M0)         r33.0<1>:ud   r32.0<1;0>:ud     r31.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r37.0<1>:ud   r42.0<1;0>:ud     r41.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        sync.nop                             null                             {Compacted,I@7}
        sync.nop                             null                             {Compacted,$9.dst}
        dpas.8x1 (16|M0)         r28:f         null:f            r7:hf             r114.0:hf        {$2}
        bfn.0xEA (16|M0)         r40.0<1>:ud   r53.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r56.0<1>:d    r56.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r54:f         null:f            r33:hf            r114.16:hf       {$14}
        mul (16|M0)              acc1.0<1>:f   r56.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   r113.0<1;0>:f     acc0.0<1;0>:f     r28.0<1>:f       {Compacted,$2.dst}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r54.0<1>:f       {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$10.dst}
        shr (16|M0)              acc2.0<1>:ud  r117.0<1;1,0>:ud  0x4:uw              {$4.dst}
        shl (16|M0)              r70.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        send.ugm (1|M0)          r106     r105  null:0  0x0            0x0220E580           {$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r112     r104  null:0  0x0            0x0210D580           {$0} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        shl (16|M0)              r69.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r70.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r60.0<1>:ud   acc2.0<1;0>:ud    r69.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r118.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r71.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r64.0<1>:ud   acc2.0<1;0>:ud    r71.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r117.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r74.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r73.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r74.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r61.0<1>:ud   acc2.0<1;0>:ud    r73.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r118.0<1;1,0>:ud  0x8:uw             
        and (16|M0)              r81.0<1>:w    r116.32<1;1,0>:ub  127:w             
        shl (16|M0)              r76.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r75.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r82.0<1>:d    r81.0<2;1,0>:ub                  {I@3}
        and (16|M0)              acc2.0<1>:ud  r76.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r77.0<1>:d    r117.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r79.0<1>:d    r118.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r82.0<1>:d    r82.0<1;1,0>:d    20:w               {I@4}
        bfn.0xEA (16|M0)         r65.0<1>:ud   acc2.0<1;0>:ud    r75.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r117.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r62.0<1>:ud   r77.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r118.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r66.0<1>:ud   r79.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r82.0<1;1,0>:f    1.329228e+36:f               {I@6}
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r3.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r3.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r87.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r58.0<1>:d    r117.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r68.0<1>:d    r118.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r12.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r57.0<1>:d    r117.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r67.0<1>:d    r118.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r84.0<1>:d    r119.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r94.0<1>:d    r120.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r58.0<1>:d    r58.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r68.0<1>:d    r68.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              acc2.0<1>:ud  r12.0<1;1,0>:ud   0x80008000:ud              {I@7}
        and (16|M0)              r13.0<1>:d    r119.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r83.0<1>:d    r119.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r93.0<1>:d    r120.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r15.0<1>:d    r120.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r16.0<1>:w    r116.48<1;1,0>:ub  127:w             
        and (16|M0)              r84.0<1>:d    r84.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r59.0<1>:ud   r58.0<1;0>:ud     r57.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r63.0<1>:ud   r68.0<1;0>:ud     r67.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r88.0<1>:ud   r13.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x3:uw             
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r95.2<0;1,0>:ud   0x22:uw             
        mov (16|M0)              r17.0<1>:d    r16.0<2;1,0>:ub                  {I@7}
        bfn.0xEA (16|M0)         r85.0<1>:ud   r84.0<1;0>:ud     r83.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r89.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        sync.nop                             null                             {Compacted,I@7}
        dpas.8x1 (16|M0)         r80:f         null:f            r59:hf            r115.0:hf        {$1}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r15.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r17.0<1>:d    r17.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r108:f        null:f            r85:hf            r115.16:hf       {$2}
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r95.3<0;1,0>:d    0:w              
        mul (16|M0)              acc2.0<1>:f   r17.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r80.0<1>:f       {Compacted,$1.dst}
        mad (16|M0)              r108.0<1>:f   acc0.0<1;0>:f     acc2.0<1;0>:f     r108.0<1>:f      {Compacted,$2.dst}
(W&~f0.0) jmpi                               L3312                                
L3152:
        add (1|M0)               r1.1<1>:q     r95.1<0;1,0>:q    2:w              
        shl (1|M0)               r2.2<1>:q     r1.1<0;1,0>:q     9:w               {I@1}
        shl (1|M0)               r4.0<1>:q     r1.1<0;1,0>:q     6:w              
        shl (1|M0)               r1.1<1>:q     r1.1<0;1,0>:q     7:w              
        add (1|M0)               r3.0<1>:q     r126.0<0;1,0>:q   r2.2<0;1,0>:q    {Compacted,I@3}
        add (1|M0)               r5.0<1>:q     r95.0<0;1,0>:q    r4.0<0;1,0>:q    {Compacted,I@3}
        add (1|M0)               r6.0<1>:q     r125.0<0;1,0>:q   r1.1<0;1,0>:q    {I@3}
        send.ugm (1|M0)          r100     r3  null:0  0x0            0x0240F580           {I@3,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r117     r3  null:0  0x100000            0x0240F580           {$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r116     r5  null:0  0x0            0x0210D580           {I@2,$8} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r114     r6  null:0  0x0            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L3312:
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$12.dst}
        shr (16|M0)              acc0.0<1>:ud  r96.0<1;1,0>:ud   0x4:uw              {$5.dst}
        shl (16|M0)              r18.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                               {$9.src}
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r8.0<1>:ud    acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r20.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r19.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc0.0<1;0>:ud    r19.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r96.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r22.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r21.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r9.0<1>:ud    acc0.0<1;0>:ud    r21.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x8:uw             
        and (16|M0)              r30.0<1>:w    r112.0<1;1,0>:ub  127:w               {$0.dst}
        shl (16|M0)              r24.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r23.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r31.0<1>:d    r30.0<2;1,0>:ub                  {I@3}
        and (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r25.0<1>:d    r96.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r27.0<1>:d    r97.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r31.0<1>:d    r31.0<1;1,0>:d    20:w               {I@4}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc0.0<1;0>:ud    r23.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r96.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r10.0<1>:ud   r25.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r27.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r31.0<1;1,0>:f    1.329228e+36:f               {I@1}
        shr (16|M0)              acc2.0<1>:ud  r98.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r46.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r45.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r46.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r36.0<1>:ud   acc2.0<1;0>:ud    r45.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r99.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r48.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r47.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r48.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r40.0<1>:ud   acc2.0<1;0>:ud    r47.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r98.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r50.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r49.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r50.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r37.0<1>:ud   acc2.0<1;0>:ud    r49.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r99.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r4.0<1>:d     r96.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r16.0<1>:d    r97.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r52.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r3.0<1>:d     r96.0<1;1,0>:d    9:w               {Compacted,$10.src}
        shl (16|M0)              r15.0<1>:d    r97.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r34.0<1>:d    r98.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r44.0<1>:d    r99.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r51.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@7}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              acc2.0<1>:ud  r52.0<1;1,0>:ud   0x80008000:ud              {I@7}
        and (16|M0)              r53.0<1>:d    r98.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r33.0<1>:d    r98.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r43.0<1>:d    r99.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r55.0<1>:d    r99.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r57.0<1>:w    r112.16<1;1,0>:ub  127:w             
        and (16|M0)              r34.0<1>:d    r34.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r44.0<1>:d    r44.0<1;1,0>:d    -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r7.0<1>:ud    r4.0<1;0>:ud      r3.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r11.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r41.0<1>:ud   acc2.0<1;0>:ud    r51.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r98.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r38.0<1>:ud   r53.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r99.0<1;1,0>:ud   0x3:uw             
        mov (16|M0)              r58.0<1>:d    r57.0<2;1,0>:ub                  {I@7}
        bfn.0xEA (16|M0)         r35.0<1>:ud   r34.0<1;0>:ud     r33.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r39.0<1>:ud   r44.0<1;0>:ud     r43.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        sync.nop                             null                             {I@7}
        dpas.8x1 (16|M0)         r29:f         null:f            r7:hf             r106.0:hf        {$15}
        bfn.0xEA (16|M0)         r42.0<1>:ud   r55.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r58.0<1>:d    r58.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r56:f         null:f            r35:hf            r106.16:hf       {$3}
        mul (16|M0)              acc1.0<1>:f   r58.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   r108.0<1;0>:f     acc0.0<1;0>:f     r29.0<1>:f       {Compacted,$15.dst}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r56.0<1>:f       {Compacted,$3.dst}
        sync.nop                             null                             {Compacted,$11.dst}
        shr (16|M0)              acc2.0<1>:ud  r121.0<1;1,0>:ud  0x4:uw              {$6.dst}
        shl (16|M0)              r72.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r71.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r62.0<1>:ud   acc2.0<1;0>:ud    r71.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r122.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r74.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r73.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r74.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r66.0<1>:ud   acc2.0<1;0>:ud    r73.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r121.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r76.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r75.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r76.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r63.0<1>:ud   acc2.0<1;0>:ud    r75.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r122.0<1;1,0>:ud  0x8:uw             
        and (16|M0)              r83.0<1>:w    r112.32<1;1,0>:ub  127:w             
        shl (16|M0)              r78.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r77.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r84.0<1>:d    r83.0<2;1,0>:ub                  {I@3}
        and (16|M0)              acc2.0<1>:ud  r78.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r79.0<1>:d    r121.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r81.0<1>:d    r122.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r84.0<1>:d    r84.0<1;1,0>:d    20:w               {I@4}
        bfn.0xEA (16|M0)         r67.0<1>:ud   acc2.0<1;0>:ud    r77.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r121.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r64.0<1>:ud   r79.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r122.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r68.0<1>:ud   r81.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r84.0<1;1,0>:f    1.329228e+36:f               {I@6}
        shr (16|M0)              acc2.0<1>:ud  r123.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw              {$8.src}
        and (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r88.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r124.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r123.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r12.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r12.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r124.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r60.0<1>:d    r121.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r70.0<1>:d    r122.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r14.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r59.0<1>:d    r121.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r69.0<1>:d    r122.0<1;1,0>:d   9:w               {Compacted}
        shl (16|M0)              r86.0<1>:d    r123.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r4.0<1>:d     r124.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r13.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r60.0<1>:d    r60.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r70.0<1>:d    r70.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              acc2.0<1>:ud  r14.0<1;1,0>:ud   0x80008000:ud              {I@7}
        and (16|M0)              r15.0<1>:d    r123.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r85.0<1>:d    r123.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r18.0<1>:w    r112.48<1;1,0>:ub  127:w             
        and (16|M0)              r17.0<1>:d    r124.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r3.0<1>:d     r124.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r86.0<1>:d    r86.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r61.0<1>:ud   r60.0<1;0>:ud     r59.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r65.0<1>:ud   r70.0<1;0>:ud     r69.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc2.0<1;0>:ud    r13.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r123.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r90.0<1>:ud   r15.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r124.0<1;1,0>:ud  0x3:uw             
        mov (16|M0)              r19.0<1>:d    r18.0<2;1,0>:ub                  {I@7}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r86.0<1;0>:ud     r85.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r4.0<1;0>:ud      r3.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        sync.nop                             null                             {I@7}
        dpas.8x1 (16|M0)         r82:f         null:f            r61:hf            r107.0:hf        {$4}
        bfn.0xEA (16|M0)         r94.0<1>:ud   r17.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r19.0<1>:d    r19.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r113:f        null:f            r87:hf            r107.16:hf       {$5}
        mul (16|M0)              acc2.0<1>:f   r19.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r82.0<1>:f       {Compacted,$4.dst}
        mad (16|M0)              r113.0<1>:f   acc0.0<1;0>:f     acc2.0<1;0>:f     r113.0<1>:f      {Compacted,$5.dst}
(W&~f0.0) jmpi                               L5904                                
L5784:
        add (1|M0)               r105.0<1>:q   r95.1<0;1,0>:q    3:w               {Compacted}
        add (1|M0)               r95.1<1>:q    r95.1<0;1,0>:q    2:w              
        shl (1|M0)               r1.1<1>:q     r105.0<0;1,0>:q   9:w               {Compacted,I@2}
        shl (1|M0)               r104.0<1>:q   r105.0<0;1,0>:q   6:w               {Compacted}
        add (1|M0)               r3.0<1>:q     r126.0<0;1,0>:q   r1.1<0;1,0>:q    {Compacted,I@2}
        shl (1|M0)               r105.0<1>:q   r105.0<0;1,0>:q   7:w               {Compacted}
        send.ugm (1|M0)          r96      r3  null:0  0x0            0x0240F580           {I@2,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r121     r3  null:0  0x100000            0x0240F580           {$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        add (1|M0)               r104.0<1>:q   r95.0<0;1,0>:q    r104.0<0;1,0>:q  {Compacted}
        add (1|M0)               r105.0<1>:q   r125.0<0;1,0>:q   r105.0<0;1,0>:q  {Compacted,I@2}
(W)     jmpi                                 L608                                
L5904:
        shl (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   6:w              
        add (16|M0)              r3.0<1>:f     r113.0<1;1,0>:f   0.0:f               {Compacted,F@1}
(W)     mov (16|M0)              r127.0<1>:ud  r26.0<1;1,0>:ud                  {Compacted}
        add (1|M0)               r4.0<1>:q     r2.6<0;1,0>:q     r126.1<0;1,0>:q  {I@2}
        send.ugm (1|M0)          null     r4  r3:1  0x0            0x0200D584           {A@1,$6} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$7} // wr:1+0, rd:0; end of thread
L5984:
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
