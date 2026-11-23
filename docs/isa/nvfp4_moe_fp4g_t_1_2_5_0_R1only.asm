L0:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                              {A@1}
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud             
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw             
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x80:ud              {I@2}
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1}
(W)     send.ugm (1|M0)          r1       r127  null:0  0xFF000000            0x6219D500           {A@1,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
        nop                    
        nop                    
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src}
(W)     send.ugm (1|M0)          r2       r127  null:0  0xFF000000            0x6229E500           {A@1,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ca.cc.bti[255]
(W)     mov (16|M0)              r20.0<1>:ud   r0.0<1;1,0>:ud                   {Compacted}
        mov (1|M0)               r126.0<1>:uq  r3.1<0;1,0>:uq                   {Compacted,$1.dst}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        and (1|M0)    (eq)f2.1   r1.6<2>:b     r2.28<0;1,0>:b    1:w               {A@1,$0.dst}
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r0.2<0;1,0>:uw  
        mach (1|M0)              r5.0<1>:ud    r2.0<0;1,0>:ud    r0.1<0;1,0>:ud  
        and (1|M0)               r30.0<2>:b    r3.44<0;1,0>:b    1:w              
        mov (1|M0)               r4.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
(~f2.1) cmp (1|M0)    (ne)f2.1   null<1>:d     r2.6<0;1,0>:d     144:w              
        mov (1|M0)               r108.1<1>:d   r5.0<0;1,0>:d                    {Compacted,I@4}
        mov (1|M0)               r108.0<1>:f   r4.0<0;1,0>:f                    {I@3}
        add (1|M0)               r108.0<1>:q   r108.0<0;1,0>:q   r1.0<0;1,0>:uw   {A@1}
(W&f2.1) jmpi                                L432                                
L352:
(W)     mul (1|M0)               acc0.0<1>:ud  r108.0<0;1,0>:ud  0x8E39:uw              {I@2}
        mach (1|M0)              r125.0<1>:ud  r108.0<0;1,0>:ud  0x38E38E39:ud             
        shr (1|M0)               r125.0<1>:ud  r125.0<0;1,0>:ud  0x5:uw              {Compacted,I@1}
        mul (1|M0)               r30.1<1>:d    r125.0<0;1,0>:d   -144:w               {Compacted,I@1}
        add (1|M0)               r30.1<1>:d    r30.1<0;1,0>:d    r108.0<0;1,0>:d  {I@1}
(W)     jmpi                                 L664                                
L432:
        mov (1|M0)               r108.1<1>:q   r2.6<0;1,0>:d                   
        mov (2|M0)               r41.0<1>:q    r108.0<1;1,0>:q                  {I@1}
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
(W)     call (16|M0)             r125.2        L8256                                 {A@1}
L512:
        mul (1|M0)               acc0.0<1>:ud  r126.12<0;1,0>:ud  r108.4<0;1,0>:uw
        mach (1|M0)              r5.0<1>:ud    r126.12<0;1,0>:ud  r108.2<0;1,0>:ud {Compacted}
        mov (1|M0)               r125.0<1>:d   r126.12<0;1,0>:ud               
        mov (1|M0)               r4.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r126.12<0;1,0>:d  r108.6<0;1,0>:uw
        macl (1|M0)              r6.0<1>:d     r126.12<0;1,0>:d  r108.3<0;1,0>:d  {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r126.13<0;1,0>:d  r108.4<0;1,0>:uw
        macl (1|M0)              r7.0<1>:d     r126.13<0;1,0>:d  r108.2<0;1,0>:d  {Compacted}
        mov (1|M0)               r1.2<1>:d     r4.0<0;1,0>:d                    {I@5}
        add3 (1|M0)              r1.3<1>:d     r7.0<0;0>:d       r5.0<0;0>:d       r6.0<0>:d        {I@2}
        add (1|M0)               r108.0<1>:q   r108.0<0;1,0>:q   -r1.1<0;1,0>:q   {I@1}
        mov (1|M0)               r30.1<1>:d    r108.0<0;1,0>:d                  {Compacted,I@1}
L664:
        shl (1|M0)               r125.0<1>:d   r125.0<0;1,0>:d   4:w               {Compacted}
        shl (1|M0)               r1.1<1>:q     r125.0<0;1,0>:ud  2:w               {I@1}
        add (1|M0)               r4.0<1>:q     r2.4<0;1,0>:q     r1.1<0;1,0>:q    {I@1}
        send.ugm (1|M0)          r124     r4  null:0  0x0            0x0210D580           {I@1,$2} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        cmp (1|M0)    (lt)f1.0   null<1>:d     r124.1<0;1,0>:d   1:w               {$2.dst}
(W&f1.0) jmpi                                L8232                                
L752:
        mul (1|M0)               acc0.0<1>:d   r124.0<0;1,0>:d   r2.12<0;1,0>:uw 
        mach (1|M0)              r5.0<1>:d     r124.0<0;1,0>:d   r2.6<0;1,0>:d   
        mov (1|M0)               r1.2<1>:q     r2.12<0;1,0>:d                  
        mov (1|M0)               r4.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r1.3<1>:d     r5.0<0;1,0>:d                    {I@3}
        send.ugm (1|M0)          r5       r126  null:0  0x0            0x04100580           {I@1,$3} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r1.2<1>:d     r4.0<0;1,0>:d                    {Compacted}
        shl (1|M0)               r4.0<1>:q     r124.0<0;1,0>:d   2:w              
        add (1|M0)               r1.1<1>:q     r1.1<0;1,0>:q     r30.1<0;1,0>:ud  {I@2}
        add (1|M0)               r10.0<1>:q    r3.0<0;1,0>:q     r4.0<0;1,0>:q    {Compacted,I@2}
        mul (1|M0)               acc0.0<1>:ud  r1.2<0;1,0>:ud    r1.8<0;1,0>:uw   {I@2}
        send.ugm (1|M0)          r123     r10  null:0  0x0            0x04100580           {I@2,$4} // wr:2+0, rd:1; load.ugm.d32.a64
        mach (1|M0)              r7.0<1>:ud    r1.2<0;1,0>:ud    r1.4<0;1,0>:ud   {Compacted}
        shl (1|M0)               r30.1<1>:ud   r30.1<0;1,0>:ud   0x4:uw             
        mov (1|M0)               r6.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r1.2<0;1,0>:d     r1.10<0;1,0>:uw 
        macl (1|M0)              r8.0<1>:d     r1.2<0;1,0>:d     r1.5<0;1,0>:d    {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r1.3<0;1,0>:d     r1.8<0;1,0>:uw  
        macl (1|M0)              r9.0<1>:d     r1.3<0;1,0>:d     r1.4<0;1,0>:d    {Compacted}
        mul (1|M0)               acc0.0<1>:d   r124.0<0;1,0>:d   r3.12<0;1,0>:uw 
        add3 (1|M0)              r2.5<1>:d     r9.0<0;0>:d       r7.0<0;0>:d       r8.0<0>:d        {I@2}
        mach (1|M0)              r7.0<1>:d     r124.0<0;1,0>:d   r3.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r2.4<1>:d     r6.0<0;1,0>:d                    {Compacted}
        mov (1|M0)               r6.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r126.1<1>:q   r30.1<0;1,0>:ud                  {$3.src}
        mov (1|M0)               r30.3<1>:d    r7.0<0;1,0>:d                    {I@4}
        shl (1|M0)               r32.0<1>:q    r2.2<0;1,0>:q     9:w               {Compacted,I@4}
        mov (1|M0)               r30.2<1>:d    r6.0<0;1,0>:d                    {Compacted,I@4}
        shl (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   2:w               {I@4}
        shl (1|M0)               r2.2<1>:q     r2.2<0;1,0>:q     6:w              
        add (1|M0)               r32.0<1>:q    r2.5<0;1,0>:q     r32.0<0;1,0>:q   {Compacted,I@4}
        shl (1|M0)               r30.1<1>:q    r30.1<0;1,0>:q    2:w               {I@4}
        mov (16|M0)              r34.0<1>:f    0.0:f                               {Compacted}
        mov (1|M0)               r126.2<1>:q   r2.13<0;1,0>:d                  
        mov (1|M0)               r30.2<1>:q    r124.1<0;1,0>:ud                
        mov (1|M0)               r126.3<1>:q   0:w                              
        add (1|M0)               r126.1<1>:q   r3.6<0;1,0>:q     r126.1<0;1,0>:q  {I@7}
        add (1|M0)               r31.0<1>:q    r2.7<0;1,0>:q     r2.2<0;1,0>:q    {Compacted,I@7}
        add (1|M0)               r122.0<1>:q   r32.0<0;1,0>:q    256:w               {Compacted,I@7}
        add (1|M0)               r33.0<1>:q    r32.0<0;1,0>:q    512:w               {Compacted}
        add (1|M0)               r121.0<1>:q   r32.0<0;1,0>:q    768:w               {Compacted}
        add (1|M0)               r30.1<1>:q    r3.2<0;1,0>:q     r30.1<0;1,0>:q   {I@7}
        math.inv (1|M0)          r3.7<1>:f     r5.0<0;1,0>:f                    {$3.dst}
        sync.nop                             null                             {Compacted,M@1}
        mul (1|M0)               r123.0<1>:f   r123.0<0;1,0>:f   r3.7<0;1,0>:f    {Compacted,$4.dst}
        mul (1|M0)               r123.0<1>:f   r123.0<0;1,0>:f   16384.0:f               {F@1}
L1344:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r126.7<0;1,0>:d   0:w               {I@7}
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r126.6<0;1,0>:d   0:w              
(W&f2.0) jmpi                                L1448                                
L1392:
        shl (1|M0)               r1.1<1>:q     r126.3<0;1,0>:q   2:w              
        add (1|M0)               r4.0<1>:q     r30.1<0;1,0>:q    r1.1<0;1,0>:q    {Compacted,@1,$2.src}
        send.ugm (1|M0)          r39      r4  null:0  0x0            0x04100580           {I@1,$3} // wr:2+0, rd:1; load.ugm.d32.a64
(W)     jmpi                                 L1456                                
L1448:
        mov (1|M0)               r39.0<1>:d    r124.2<0;1,0>:d                  {Compacted}
L1456:
        asr (1|M0)               r1.2<1>:d     r39.0<0;1,0>:d    31:w               {@1,$3.dst}
        cmp (1|M0)    (eq)f0.1   null<1>:w     r30.0<0;1,0>:b    0:w              
        shr (1|M0)               r1.2<1>:ud    r1.2<0;1,0>:ud    0x1D:uw              {I@2}
        cmp (1|M0)    (gt)f0.0   null<1>:d     r2.13<0;1,0>:d    0:w              
        add (1|M0)               r1.2<1>:d     r39.0<0;1,0>:d    r1.2<0;1,0>:d    {I@2}
        asr (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     3:w               {I@1}
(f0.1)  mov (1|M0)               r1.2<1>:d     r39.0<0;1,0>:d                  
        mul (1|M0)               acc0.0<1>:d   r1.2<0;1,0>:d     r3.20<0;1,0>:uw  {I@1}
        mach (1|M0)              r5.0<1>:d     r1.2<0;1,0>:d     r3.10<0;1,0>:d  
        mov (1|M0)               r4.0<1>:d     acc0.0<0;1,0>:d                  {$2.src}
        mov (1|M0)               r2.5<1>:d     r5.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r2.4<1>:d     r4.0<0;1,0>:d                    {Compacted,I@2}
        shl (1|M0)               r2.2<1>:q     r2.2<0;1,0>:q     1:w               {I@1}
        sync.nop                             null                             {Compacted,$5.src}
        add (1|M0)               r115.0<1>:q   r3.4<0;1,0>:q     r2.2<0;1,0>:q    {Compacted,@1,$10.src}
(W&f0.0) jmpi                                L1712                                
L1688:
        mov (16|M0)              r40.0<1>:f    r34.0<1;1,0>:f                   {Compacted}
(W)     jmpi                                 L7936                                
L1712:
        send.ugm (1|M0)          r111     r32  null:0  0x0            0x024AF580           {$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r44      r122  null:0  0x0            0x024AF580           {$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$14.dst}
        send.ugm (1|M0)          r110     r31  null:0  0x0            0x0210D580           {$6} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r48      r115  null:0  0x0            0x0220E580           {I@3,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        cmp (1|M0)    (eq)f3.1   null<1>:d     r2.13<0;1,0>:d    1:w              
(W&f3.1) jmpi                                L1920                                
L1824:
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r117     r33  null:0  0x0            0x024AF580           {$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r35      r121  null:0  0x0            0x024AF580           {$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$12.dst}
        send.ugm (1|M0)          r116     r31  null:0  0x40000            0x0210D580           {$9} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r42      r115  null:0  0x80000            0x0220E580           {$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L1920:
        mov (16|M0)              r40.0<1>:f    r34.0<1;1,0>:f                  
        mov (2|M0)               r30.8<1>:d    0x1:v                              
        mov (1|M0)               r126.4<1>:q   0:w                              
L1968:
        cmp (1|M0)    (lt)f2.0   null<1>:ud    r126.8<0;1,0>:ud  r126.4<0;1,0>:ud {I@1}
        cmp (1|M0)    (lt)f1.1   null<1>:d     r126.9<0;1,0>:d   r126.5<0;1,0>:d 
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r126.9<0;1,0>:d   r126.5<0;1,0>:d 
(f1.1)  sel (1|M0)               r2.6<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f2.0)  sel (1|M0)               r1.4<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r1.4<0;1,0>:uw    r2.6<0;1,0>:uw   {I@1}
(W&~f3.0) jmpi                               L4848                                
L2096:
        shr (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x4:uw              {$7.dst}
        shl (16|M0)              r18.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        sync.nop                             null                             {Compacted,$0.src}
        shl (16|M0)              r4.0<1>:d     r111.0<1;1,0>:d   12:w               {Compacted,$8.src}
        sync.nop                             null                             {$1.src}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                               {$10.src}
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,$12.src}
        shl (16|M0)              r5.0<1>:d     r111.0<1;1,0>:d   9:w               {Compacted,$14.src}
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r8.0<1>:ud    acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r112.0<1;1,0>:ud  0x4:uw             
        bfn.0xEA (16|M0)         r7.0<1>:ud    r4.0<1;0>:ud      r5.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r4.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r16.0<1>:d    r112.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r19.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r15.0<1>:d    r112.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc0.0<1;0>:ud    r19.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x8:uw             
        bfn.0xEA (16|M0)         r11.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r15.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r9.0<1>:ud    acc0.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r112.0<1;1,0>:ud  0x8:uw             
        sync.nop                             null                             {$14.dst}
        and (16|M0)              r1.4<1>:w     r110.0<1;1,0>:ub  127:w               {$6.dst}
        shl (16|M0)              r16.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r4.0<1>:d     r1.8<2;1,0>:ub                   {I@3}
        and (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r19.0<1>:d    r111.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r21.0<1>:d    r112.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     20:w               {I@4}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r10.0<1>:ud   r19.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r112.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r21.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r4.0<1;1,0>:f     1.329228e+36:f               {I@1}
        shr (16|M0)              acc2.0<1>:ud  r113.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        dpas.8x1 (16|M0)         r5:f          null:f            r7:hf             r48.0:hf         {$10}
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r23.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r114.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r27.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r113.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r24.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r114.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r18.0<1>:d    r114.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r16.0<1>:d    r113.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@4}
        and (16|M0)              r9.0<1>:d     r113.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r15.0<1>:d    r113.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r1.4<1>:w     r110.16<1;1,0>:ub  127:w             
        shl (16|M0)              r17.0<1>:d    r114.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r13.0<1>:d    r114.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r18.0<1>:d    r18.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r28.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r113.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r25.0<1>:ud   r9.0<1;0>:ud      acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r114.0<1;1,0>:ud  0x3:uw             
        mov (16|M0)              r10.0<1>:d    r1.8<2;1,0>:ub                   {I@7}
        bfn.0xEA (16|M0)         r26.0<1>:ud   r18.0<1;0>:ud     r17.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r22.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r29.0<1>:ud   r13.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r10.0<1>:d    r10.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r8:f          null:f            r22:hf            r48.16:hf        {$4}
        mul (16|M0)              acc1.0<1>:f   r10.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   r40.0<1;0>:f      acc0.0<1;0>:f     r5.0<1>:f        {Compacted,$10.dst}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r8.0<1>:f        {Compacted,$4.dst}
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x4:uw              {$8.dst}
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        shl (16|M0)              r4.0<1>:d     r44.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r7.0<1>:d     r44.0<1;1,0>:d    9:w              
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r45.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r11.0<1>:ud   r4.0<1;0>:ud      r7.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r19.0<1>:d    r45.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r21.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r9.0<1>:d     r45.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r19.0<1>:d    r19.0<1;1,0>:d    -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r16.0<1>:ud   acc2.0<1;0>:ud    r21.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r15.0<1>:ud   r19.0<1;0>:ud     r9.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r9.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r45.0<1;1,0>:ud   0x8:uw             
        and (16|M0)              r1.4<1>:w     r110.32<1;1,0>:ub  127:w             
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r7.0<1>:d     r1.8<2;1,0>:ub                   {I@3}
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        and (16|M0)              r19.0<1>:d    r44.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r21.0<1>:d    r45.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r7.0<1>:d     r7.0<1;1,0>:d     20:w               {I@4}
        bfn.0xEA (16|M0)         r17.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r19.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r45.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r18.0<1>:ud   r21.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r7.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@6}
        shr (16|M0)              acc2.0<1>:ud  r46.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        shl (16|M0)              r8.0<1>:d     r46.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,I@4}
        dpas.8x1 (16|M0)         r4:f          null:f            r11:hf            r49.0:hf         {$3}
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw              {$3.src}
        and (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r5.0<1>:d     r46.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r8.0<1>:d     r8.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r23.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r47.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r22.0<1>:ud   r8.0<1;0>:ud      r5.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r13.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        shl (16|M0)              r10.0<1>:d    r47.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r27.0<1>:ud   acc2.0<1;0>:ud    r13.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r46.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r9.0<1>:d     r47.0<1;1,0>:d    9:w              
        and (16|M0)              r10.0<1>:d    r10.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        bfn.0xEA (16|M0)         r26.0<1>:ud   r10.0<1;0>:ud     r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        add (1|M0)               r30.3<1>:q    r126.4<0;1,0>:q   2:w              
        bfn.0xEA (16|M0)         r24.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r47.0<1;1,0>:ud   0x8:uw             
        cmp (1|M0)    (lt)f1.1   null<1>:ud    r30.6<0;1,0>:ud   r126.4<0;1,0>:ud {I@3}
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r46.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r1.4<1>:w     r110.48<1;1,0>:ub  127:w             
        and (16|M0)              r11.0<1>:d    r47.0<1;1,0>:d    -2147450880:d              
        cmp (1|M0)    (lt)f1.0   null<1>:d     r30.7<0;1,0>:d    r126.5<0;1,0>:d 
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r30.7<0;1,0>:d    r126.5<0;1,0>:d 
        bfn.0xEA (16|M0)         r28.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r46.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r25.0<1>:ud   r5.0<1;0>:ud      acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r47.0<1;1,0>:ud   0x3:uw             
(W)     mov (1|M0)               r2.6<1>:hf    0x1:hf                             
        mov (16|M0)              r8.0<1>:d     r1.8<2;1,0>:ub                   {I@7}
        bfn.0xEA (16|M0)         r29.0<1>:ud   r11.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
(f1.1)  sel (1|M0)               r2.7<1>:uw    r2.6<0;1,0>:uw    0x0:uw              {F@1}
(f1.0)  sel (1|M0)               r3.14<1>:uw   r2.6<0;1,0>:uw    0x0:uw             
        shl (16|M0)              r8.0<1>:d     r8.0<1;1,0>:d     20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@4}
        dpas.8x1 (16|M0)         r40:f         null:f            r22:hf            r49.16:hf        {$4}
        or (1|M0)     (ne)f2.1   null<1>:uw    r2.7<0;1,0>:uw    r3.14<0;1,0>:uw  {I@2}
        mul (16|M0)              acc2.0<1>:f   r8.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r4.0<1>:f        {Compacted,$3.dst}
        mad (16|M0)              r40.0<1>:f    acc0.0<1;0>:f     acc2.0<1;0>:f     r40.0<1>:f       {Compacted,$4.dst}
(W&~f2.1) jmpi                               L4848                                
L4712:
        shl (1|M0)               r4.0<1>:q     r30.3<0;1,0>:q    9:w               {Compacted,F@2}
        shl (1|M0)               r1.1<1>:q     r30.3<0;1,0>:q    6:w              
        add (1|M0)               r4.0<1>:q     r32.0<0;1,0>:q    r4.0<0;1,0>:q    {Compacted,I@2}
        shl (1|M0)               r30.3<1>:q    r30.3<0;1,0>:q    7:w              
        send.ugm (1|M0)          r111     r4  null:0  0x0            0x024AF580           {I@2,$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r5.0<1>:q     r31.0<0;1,0>:q    r1.1<0;1,0>:q    {Compacted}
        add (1|M0)               r4.0<1>:q     r4.0<0;1,0>:q     256:w               {Compacted,$7.src}
        add (1|M0)               r6.0<1>:q     r115.0<0;1,0>:q   r30.3<0;1,0>:q   {Compacted,I@3}
        send.ugm (1|M0)          r110     r5  null:0  0x0            0x0210D580           {I@3,$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r44      r4  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r48      r6  null:0  0x0            0x0220E580           {I@1,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L4848:
        or (2|M0)                r1.2<1>:d     r126.8<1;1,0>:d   r30.8<1;1,0>:d  
(W)     mov (1|M0)               r2.6<1>:hf    0x1:hf                             
        cmp (1|M0)    (lt)f1.0   null<1>:ud    r1.2<0;1,0>:ud    r126.4<0;1,0>:ud {I@1}
        cmp (1|M0)    (lt)f0.1   null<1>:d     r1.3<0;1,0>:d     r126.5<0;1,0>:d 
(f1.0)  cmp (1|M0)    (eq)f1.0   null<1>:d     r1.3<0;1,0>:d     r126.5<0;1,0>:d 
(f0.1)  sel (1|M0)               r3.14<1>:uw   r2.6<0;1,0>:uw    0x0:uw              {F@1}
(f1.0)  sel (1|M0)               r2.7<1>:uw    r2.6<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r2.7<0;1,0>:uw    r3.14<0;1,0>:uw  {I@1}
(W&~f2.0) jmpi                               L7792                                
L4992:
        sync.nop                             null                             {Compacted,$15.dst}
        shr (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x4:uw              {$11.dst}
        shl (16|M0)              r18.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        sync.nop                             null                             {Compacted,$0.src}
        shl (16|M0)              r4.0<1>:d     r117.0<1;1,0>:d   12:w               {Compacted,$8.src}
        sync.nop                             null                             {Compacted,$1.src}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                               {$10.src}
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,$12.src}
        shl (16|M0)              r5.0<1>:d     r117.0<1;1,0>:d   9:w               {Compacted,$14.src}
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r8.0<1>:ud    acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x4:uw             
        bfn.0xEA (16|M0)         r7.0<1>:ud    r4.0<1;0>:ud      r5.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r4.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r16.0<1>:d    r118.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r19.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r15.0<1>:d    r118.0<1;1,0>:d   9:w               {Compacted}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc0.0<1;0>:ud    r19.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x8:uw             
        bfn.0xEA (16|M0)         r11.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r15.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r9.0<1>:ud    acc0.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x8:uw             
        sync.nop                             null                             {$12.dst}
        and (16|M0)              r1.4<1>:w     r116.0<1;1,0>:ub  127:w               {$9.dst}
        shl (16|M0)              r16.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r17.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r4.0<1>:d     r1.8<2;1,0>:ub                   {I@3}
        and (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r19.0<1>:d    r117.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r21.0<1>:d    r118.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     20:w               {I@4}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc0.0<1;0>:ud    r17.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r10.0<1>:ud   r19.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r21.0<1;0>:ud     acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r4.0<1;1,0>:f     1.329228e+36:f               {I@1}
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        sync.nop                             null                             {$1.dst}
        dpas.8x1 (16|M0)         r5:f          null:f            r7:hf             r42.0:hf         {$5}
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw              {$5.src}
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r23.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x4:uw             
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r27.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r24.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x8:uw             
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r18.0<1>:d    r120.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r16.0<1>:d    r119.0<1;1,0>:d   12:w               {Compacted}
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@4}
        and (16|M0)              r9.0<1>:d     r119.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r15.0<1>:d    r119.0<1;1,0>:d   9:w              
        and (16|M0)              r1.4<1>:w     r116.16<1;1,0>:ub  127:w             
        shl (16|M0)              r17.0<1>:d    r120.0<1;1,0>:d   9:w              
        and (16|M0)              r13.0<1>:d    r120.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r18.0<1>:d    r18.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r16.0<1>:d    r16.0<1;1,0>:d    -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r28.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x3:uw             
        bfn.0xEA (16|M0)         r25.0<1>:ud   r9.0<1;0>:ud      acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x3:uw             
        mov (16|M0)              r10.0<1>:d    r1.8<2;1,0>:ub                   {I@7}
        bfn.0xEA (16|M0)         r26.0<1>:ud   r18.0<1;0>:ud     r17.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r22.0<1>:ud   r16.0<1;0>:ud     r15.0<1;0>:ud     r6.0<0>:ud       {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r29.0<1>:ud   r13.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shl (16|M0)              r10.0<1>:d    r10.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r8:f          null:f            r22:hf            r42.16:hf        {$3}
        mul (16|M0)              acc1.0<1>:f   r10.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   r40.0<1;0>:f      acc0.0<1;0>:f     r5.0<1>:f        {Compacted,$5.dst}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r8.0<1>:f        {Compacted,$3.dst}
        sync.nop                             null                             {Compacted,$0.dst}
        shr (16|M0)              acc2.0<1>:ud  r35.0<1;1,0>:ud   0x4:uw              {$13.dst}
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        shl (16|M0)              r4.0<1>:d     r35.0<1;1,0>:d    12:w              
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r7.0<1>:d     r35.0<1;1,0>:d    9:w              
        and (16|M0)              r4.0<1>:d     r4.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r12.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r36.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r11.0<1>:ud   r4.0<1;0>:ud      r7.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r4.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r19.0<1>:d    r36.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r21.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r4.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r9.0<1>:d     r36.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r19.0<1>:d    r19.0<1;1,0>:d    -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r16.0<1>:ud   acc2.0<1;0>:ud    r21.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r35.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r15.0<1>:ud   r19.0<1;0>:ud     r9.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r9.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r13.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r36.0<1;1,0>:ud   0x8:uw             
        and (16|M0)              r1.4<1>:w     r116.32<1;1,0>:ub  127:w             
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r7.0<1>:d     r1.8<2;1,0>:ub                   {I@3}
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        and (16|M0)              r19.0<1>:d    r35.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r21.0<1>:d    r36.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r7.0<1>:d     r7.0<1;1,0>:d     20:w               {I@4}
        bfn.0xEA (16|M0)         r17.0<1>:ud   acc2.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r35.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r14.0<1>:ud   r19.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r36.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r18.0<1>:ud   r21.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r7.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@6}
        shr (16|M0)              acc2.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw              {F@1}
        shl (16|M0)              r8.0<1>:d     r37.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,I@4}
        dpas.8x1 (16|M0)         r4:f          null:f            r11:hf            r43.0:hf         {$4}
        shl (16|M0)              r11.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw              {$4.src}
        and (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x80008000:ud              {I@3}
        shl (16|M0)              r5.0<1>:d     r37.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r8.0<1>:d     r8.0<1;1,0>:d     -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r23.0<1>:ud   acc2.0<1;0>:ud    r11.0<1;0>:ud     r6.0<0>:ud       {I@4} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r22.0<1>:ud   r8.0<1;0>:ud      r5.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r13.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        shl (16|M0)              r10.0<1>:d    r38.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r27.0<1>:ud   acc2.0<1;0>:ud    r13.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r9.0<1>:d     r38.0<1;1,0>:d    9:w              
        and (16|M0)              r10.0<1>:d    r10.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r8.0<1>:ud    acc2.0<1;1,0>:ud  0xC:uw             
        bfn.0xEA (16|M0)         r26.0<1>:ud   r10.0<1;0>:ud     r9.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r9.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x80008000:ud              {I@3}
        add (1|M0)               r126.5<1>:q   r126.4<0;1,0>:q   3:w              
        bfn.0xEA (16|M0)         r24.0<1>:ud   acc2.0<1;0>:ud    r9.0<1;0>:ud      r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        cmp (1|M0)    (lt)f0.1   null<1>:ud    r126.10<0;1,0>:ud  r126.4<0;1,0>:ud {I@3}
        shl (16|M0)              r10.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r7.0<1>:ud    acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r10.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r37.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r1.4<1>:w     r116.48<1;1,0>:ub  127:w             
        and (16|M0)              r11.0<1>:d    r38.0<1;1,0>:d    -2147450880:d              
        cmp (1|M0)    (lt)f0.0   null<1>:d     r126.11<0;1,0>:d  r126.5<0;1,0>:d 
(f0.1)  cmp (1|M0)    (eq)f0.1   null<1>:d     r126.11<0;1,0>:d  r126.5<0;1,0>:d 
        bfn.0xEA (16|M0)         r28.0<1>:ud   acc2.0<1;0>:ud    r7.0<1;0>:ud      r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r25.0<1>:ud   r5.0<1;0>:ud      acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
(W)     mov (1|M0)               r2.6<1>:hf    0x1:hf                             
        mov (16|M0)              r8.0<1>:d     r1.8<2;1,0>:ub                   {I@7}
        bfn.0xEA (16|M0)         r29.0<1>:ud   r11.0<1;0>:ud     acc2.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
(f0.1)  sel (1|M0)               r2.7<1>:uw    r2.6<0;1,0>:uw    0x0:uw              {F@1}
(f0.0)  sel (1|M0)               r3.14<1>:uw   r2.6<0;1,0>:uw    0x0:uw             
        shl (16|M0)              r8.0<1>:d     r8.0<1;1,0>:d     20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@4}
        dpas.8x1 (16|M0)         r40:f         null:f            r22:hf            r43.16:hf        {$3}
        or (1|M0)     (ne)f1.1   null<1>:uw    r2.7<0;1,0>:uw    r3.14<0;1,0>:uw  {I@2}
        mul (16|M0)              acc2.0<1>:f   r8.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r4.0<1>:f        {Compacted,$4.dst}
        mad (16|M0)              r40.0<1>:f    acc0.0<1;0>:f     acc2.0<1;0>:f     r40.0<1>:f       {Compacted,$3.dst}
(W&~f1.1) jmpi                               L7792                                
L7656:
        shl (1|M0)               r4.0<1>:q     r126.5<0;1,0>:q   9:w               {Compacted,F@2}
        shl (1|M0)               r1.1<1>:q     r126.5<0;1,0>:q   6:w              
        add (1|M0)               r4.0<1>:q     r32.0<0;1,0>:q    r4.0<0;1,0>:q    {Compacted,I@2}
        shl (1|M0)               r126.5<1>:q   r126.5<0;1,0>:q   7:w              
        send.ugm (1|M0)          r117     r4  null:0  0x0            0x024AF580           {I@2,$15} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r5.0<1>:q     r31.0<0;1,0>:q    r1.1<0;1,0>:q    {Compacted}
        add (1|M0)               r4.0<1>:q     r4.0<0;1,0>:q     256:w               {Compacted,$15.src}
        add (1|M0)               r6.0<1>:q     r115.0<0;1,0>:q   r126.5<0;1,0>:q  {Compacted,I@3}
        send.ugm (1|M0)          r116     r5  null:0  0x0            0x0210D580           {I@3,$12} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r35      r4  null:0  0x0            0x024AF580           {I@2,$0} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r42      r6  null:0  0x0            0x0220E580           {I@1,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L7792:
        add (1|M0)               r126.4<1>:q   r126.4<0;1,0>:q   2:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r126.8<0;1,0>:ud  r126.4<0;1,0>:ud {I@1}
        cmp (1|M0)    (lt)f3.1   null<1>:d     r126.9<0;1,0>:d   r126.5<0;1,0>:d 
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r126.9<0;1,0>:d   r126.5<0;1,0>:d 
(f3.1)  sel (1|M0)               r2.6<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f0.0)  sel (1|M0)               r1.4<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f1.0   null<1>:uw    r1.4<0;1,0>:uw    r2.6<0;1,0>:uw   {I@1}
(W&f1.0) jmpi                                L1968                                
L7936:
        add (1|M0)               r126.3<1>:q   r126.3<0;1,0>:q   8:w              
        mul (1|M0)               acc0.0<1>:d   r39.0<0;1,0>:d    r3.28<0;1,0>:uw 
        cmp (1|M0)    (lt)f3.1   null<1>:ud    r126.6<0;1,0>:ud  r30.4<0;1,0>:ud  {I@2}
        sync.nop                             null                             {Compacted,$1.src}
        mach (1|M0)              r6.0<1>:d     r39.0<0;1,0>:d    r3.14<0;1,0>:d   {Compacted,$10.src}
        cmp (1|M0)    (lt)f3.0   null<1>:ud    r126.7<0;1,0>:ud  r30.5<0;1,0>:ud 
(W)     mov (1|M0)               r2.6<1>:hf    0x1:hf                             
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:d     r126.7<0;1,0>:d   r30.5<0;1,0>:d  
        sync.nop                             null                             {$12.src}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {$14.src}
        mov (1|M0)               r1.3<1>:d     r6.0<0;1,0>:d                    {I@4}
(f3.0)  sel (1|M0)               r3.14<1>:uw   r2.6<0;1,0>:uw    0x0:uw              {F@1}
        mov (1|M0)               r1.2<1>:d     r5.0<0;1,0>:d                    {I@3}
(f3.1)  sel (1|M0)               r2.7<1>:uw    r2.6<0;1,0>:uw    0x0:uw             
        shl (1|M0)               r1.1<1>:q     r1.1<0;1,0>:q     2:w               {I@2}
        or (1|M0)     (ne)f0.1   null<1>:uw    r2.7<0;1,0>:uw    r3.14<0;1,0>:uw  {I@2}
        sync.nop                             null                             {Compacted,$0.src}
        mul (16|M0)              r4.0<1>:f     r123.0<0;1,0>:f   r40.0<1;1,0>:f   {Compacted,$8.src}
        add (1|M0)               r7.0<1>:q     r126.1<0;1,0>:q   r1.1<0;1,0>:q    {Compacted,I@2}
        send.ugm (1|M0)          null     r7  r4:1  0x0            0x0200D584           {A@1,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&f0.1) jmpi                                L1344                                
L8232:
(W)     mov (16|M0)              r127.0<1>:f   r20.0<1;1,0>:f                   {Compacted}
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,F@1,$4} // wr:1+0, rd:0; end of thread
L8256:
        mov (2|M0)               r109.0<1>:d   0x1:v                              
        mov (1|M0)               r30.10<1>:d   63:w                              
        mov (1|M0)               r30.6<1>:q    0:w                              
        mov (1|M0)               r30.7<1>:q    0:w                              
L8320:
        mov (1|M0)               r126.6<1>:q   r30.10<0;1,0>:ud                 {I@3}
        shl (1|M0)               r30.6<1>:q    r30.6<0;1,0>:q    1:w               {I@3}
        shr (1|M0)               r4.0<1>:uq    r41.0<0;1,0>:uq   r126.6<0;1,0>:uq {I@2}
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
        bfn.0xEA (2|M0)          r4.0<1>:ud    r30.12<1;0>:ud    r4.0<1;0>:ud      r109.0<1>:ud     {I@1} // s0|s1&s2
        cmp (1|M0)    (eq)f0.0   null<1>:d     r30.10<0;1,0>:d   0:w              
        cmp (1|M0)    (lt)f3.0   null<1>:ud    r4.0<0;1,0>:ud    r41.2<0;1,0>:ud  {I@2}
        cmp (1|M0)    (lt)f2.1   null<1>:ud    r4.1<0;1,0>:ud    r41.3<0;1,0>:ud 
        shl (1|M0)               r126.6<1>:uq  r1.3<0;1,0>:uw    r126.6<0;1,0>:uq {F@1}
        add (1|M0)               r126.14<1>:ud  r30.10<0;1,0>:ud  0xFFFFFFFF:ud            
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r4.1<0;1,0>:d     r41.3<0;1,0>:d  
(f2.1)  sel (1|M0)               r1.5<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        add (1|M0)               r30.6<1>:q    r4.0<0;1,0>:q     -r41.1<0;1,0>:q 
        or (2|M0)                r126.12<1>:d  r126.12<1;1,0>:d  r30.14<1;1,0>:d  {I@5}
(f3.0)  sel (1|M0)               r1.4<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f1.1   null<1>:uw    r1.4<0;1,0>:uw    r1.5<0;1,0>:uw   {I@1}
(f1.1)  mov (1|M0)               r30.12<1>:ud  r4.0<0;1,0>:d                   
(f1.1)  mov (1|M0)               r30.13<1>:ud  r4.1<0;1,0>:d                   
(f1.1)  mov (1|M0)               r126.12<1>:ud  r30.14<0;1,0>:d                
(f1.1)  mov (1|M0)               r126.13<1>:ud  r30.15<0;1,0>:d                
(W&f0.0) jmpi                                L8704                                
L8656:
        mov (1|M0)               r30.10<1>:d   r126.14<0;1,0>:d                
        mov (1|M0)               r30.7<1>:q    r126.6<0;1,0>:q                  {I@3}
(W)     jmpi                                 L8320                                
L8704:
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
        ret (16|M0)                          r125.2                           {A@1}
L8752:
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
