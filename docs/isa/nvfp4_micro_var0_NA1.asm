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
        mov (1|M0)               r16.0<1>:uq   r2.5<0;1,0>:uq                   {Compacted,$1.dst}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r0.2<0;1,0>:uw   {A@1}
        mach (1|M0)              r5.0<1>:ud    r2.0<0;1,0>:ud    r0.1<0;1,0>:ud   {Compacted}
        mov (16|M0)              r19.0<1>:f    0.0:f                               {Compacted}
        mov (1|M0)               r4.0<1>:ud    acc0.0<0;1,0>:ud                
        mov (1|M0)               r1.11<1>:d    r5.0<0;1,0>:d                    {@2,$0.dst}
        mov (1|M0)               r1.10<1>:d    r4.0<0;1,0>:d                    {I@2}
        send.ugm (1|M0)          r17      r16  null:0  0x0            0x0220E580           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r1.5<1>:q     r1.5<0;1,0>:q     r1.0<0;1,0>:uw   {I@1}
        mov (1|M0)               r1.3<1>:q     0:w                              
(W)     mul (1|M0)               acc0.0<1>:ud  r1.10<0;1,0>:ud   0x8E39:uw              {I@2}
        mach (1|M0)              r6.0<1>:ud    r1.10<0;1,0>:ud   0x38E38E39:ud             
        shr (1|M0)               r6.0<1>:ud    r6.0<0;1,0>:ud    0x5:uw              {Compacted,I@1}
        mul (1|M0)               r1.2<1>:d     r6.0<0;1,0>:d     7:w               {Compacted,I@1}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     3:w               {I@1}
        and (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     127:w               {I@1}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     -r6.0<0;1,0>:d   {I@1}
        mul (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     144:w               {I@1}
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r1.10<0;1,0>:d   {I@1}
        mul (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     36:w               {I@1}
        shl (1|M0)               r1.2<1>:q     r1.2<0;1,0>:ud    9:w               {I@1}
        add (1|M0)               r7.0<1>:q     r2.3<0;1,0>:q     r1.2<0;1,0>:q    {I@1}
        send.ugm (1|M0)          r8       r7  null:0  0x0            0x0240F580           {I@1,$3} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r12      r7  null:0  0x100000            0x0240F580           {$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
L544:
        mov (32|M0)              r20.0<1>:f    r8.0<1;1,0>:f                    {Compacted,$3.dst}
        mov (32|M0)              r22.0<1>:f    r10.0<1;1,0>:f                   {Compacted}
        mov (32|M0)              r24.0<1>:f    r12.0<1;1,0>:f                   {Compacted,$4.dst}
        mov (32|M0)              r26.0<1>:d    r14.0<1;1,0>:d                   {Compacted}
        add (16|M0)              r20.0<1>:d    r1.6<0;1,0>:d     r8.0<1;1,0>:d    {Compacted,F@3}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x1 (16|M0)         r28:f         null:f            r20:hf            r17.0:hf         {Atomic,$2.dst}
        dpas.8x1 (16|M0)         r29:f         null:f            r20:hf            r17.16:hf        {$2}
        or (1|M0)                r1.3<1>:d     r1.6<0;1,0>:d     1:w              
        dpas.8x1 (16|M0)         r30:f         null:f            r20:hf            r18.0:hf         {$5}
        mov (32|M0)              r36.0<1>:d    r8.0<1;1,0>:d                    {Compacted}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r28.0<1;1,0>:f   {Compacted,$2.dst}
        mov (32|M0)              r38.0<1>:d    r10.0<1;1,0>:d                   {Compacted}
        mov (32|M0)              r40.0<1>:d    r12.0<1;1,0>:d                   {Compacted}
        mov (32|M0)              r42.0<1>:d    r14.0<1;1,0>:d                  
        dpas.8x1 (16|M0)         r31:f         null:f            r20:hf            r18.16:hf        {$6}
        add (16|M0)              r36.0<1>:d    r1.3<0;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@5}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r29.0<1;1,0>:f   {Compacted,F@1}
        sync.nop                             null                             {Compacted,I@1}
        dpas.8x1 (16|M0)         r32:f         null:f            r36:hf            r17.0:hf         {$7}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r30.0<1;1,0>:f   {Compacted,@1,$5.dst}
        dpas.8x1 (16|M0)         r33:f         null:f            r36:hf            r17.16:hf        {$8}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r31.0<1;1,0>:f   {Compacted,@1,$6.dst}
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r1.6<0;1,0>:ud    0x22:uw             
        dpas.8x1 (16|M0)         r34:f         null:f            r36:hf            r18.0:hf         {$9}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r32.0<1;1,0>:f   {Compacted,@1,$7.dst}
        dpas.8x1 (16|M0)         r35:f         null:f            r36:hf            r18.16:hf        {$10}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r33.0<1;1,0>:f   {Compacted,@1,$8.dst}
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r1.7<0;1,0>:d     0:w              
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r34.0<1;1,0>:f   {Compacted,@1,$9.dst}
        add (16|M0)              r19.0<1>:f    r19.0<1;1,0>:f    r35.0<1;1,0>:f   {@1,$10.dst}
        add (1|M0)               r1.4<1>:q     r1.3<0;1,0>:q     2:w              
(W&~f0.0) jmpi                               L960                                
L928:
        mov (1|M0)               r1.3<1>:q     r1.4<0;1,0>:q                    {I@2}
(W)     jmpi                                 L544                                
L960:
        shl (1|M0)               r1.5<1>:q     r1.5<0;1,0>:q     6:w              
        add (16|M0)              r44.0<1>:f    r19.0<1;1,0>:f    0.0:f               {Compacted,F@1}
(W)     mov (16|M0)              r127.0<1>:ud  r3.0<1;1,0>:ud                   {Compacted}
        add (1|M0)               r45.0<1>:q    r2.6<0;1,0>:q     r1.5<0;1,0>:q    {I@2}
        send.ugm (1|M0)          null     r45  r44:1  0x0            0x0200D584           {A@1,$11} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,$12} // wr:1+0, rd:0; end of thread
L1040:
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
