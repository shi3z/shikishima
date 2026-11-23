L0:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                              {A@1}
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud             
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw             
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0xA0:ud              {I@2}
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1}
(W)     send.ugm (1|M0)          r1       r127  null:0  0xFF000000            0x6219D500           {A@1,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
        nop                    
        nop                    
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src}
(W)     send.ugm (1|M0)          r2       r127  null:0  0xFF000000            0x6229E500           {A@1,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ca.cc.bti[255]
(W)     send.ugm (1|M0)          r4       r127  null:0  0xFF080000            0x6219C500           {$2} // wr:1+0, rd:1; load.ugm.d32x8t.a32.ca.cc.bti[255][A+0x80]
(W)     mov (16|M0)              r74.0<1>:ud   r0.0<1;1,0>:ud                  
(W)     and (1|M0)               r4.1<1>:ud    r74.5<0;1,0>:ud   0xFFFFFC00:ud              {@1,$2.dst}
(W)     mov (1|M0)               r73.0<1>:f    9.18355e-41:f                              
        mov (1|M0)               r6.0<1>:uq    r3.2<0;1,0>:uq                   {$1.dst}
(W)     shr (1|M0)               a0.1<1>:ud    r4.1<0;1,0>:ud    0x4:ud              {A@1}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        cmp (1|M0)    (ne)f3.1   null<1>:d     r2.8<0;1,0>:d     144:w               {A@1}
(W)     mov (1|M0)               r122.1<1>:hf  0x1:hf                             
        and (1|M0)               r6.8<2>:b     r2.36<0;1,0>:b    1:w              
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r0.2<0;1,0>:uw  
(f3.1)  sel (1|M0)               r75.0<1>:uw   r122.1<0;1,0>:uw  0x0:uw              {F@1}
        mach (1|M0)              r8.0<1>:ud    r2.0<0;1,0>:ud    r0.1<0;1,0>:ud  
        xor (1|M0)    (ne)f2.1   null<1>:uw    r75.0<0;1,0>:uw   0x1:uw              {I@2}
(f3.1)  sel (1|M0)               r125.8<1>:uw  r122.1<0;1,0>:uw  0x0:uw             
        mov (1|M0)               r7.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
        mov (1|M0)               r125.1<1>:d   r8.0<0;1,0>:d                    {Compacted,I@4}
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:w     r6.8<0;1,0>:b     0:w              
        mov (1|M0)               r125.0<1>:f   r7.0<0;1,0>:f                    {I@3}
        and (1|M0)               r122.0<2>:b   r3.52<0;1,0>:b    1:w              
        add (1|M0)               r125.0<1>:q   r125.0<0;1,0>:q   r1.0<0;1,0>:uw   {A@1,$0.dst}
(f2.1)  sel (1|M0)               r76.0<1>:uw   r122.1<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r125.8<0;1,0>:uw  r76.0<0;1,0>:uw  {I@1}
(W&f3.0) jmpi                                L624                                
L544:
(W)     mul (1|M0)               acc0.0<1>:ud  r125.0<0;1,0>:ud  0x8E39:uw             
        mach (1|M0)              r7.0<1>:ud    r125.0<0;1,0>:ud  0x38E38E39:ud             
        shr (1|M0)               r7.0<1>:ud    r7.0<0;1,0>:ud    0x5:uw              {Compacted,I@1}
        mul (1|M0)               r73.1<1>:d    r7.0<0;1,0>:d     -144:w               {Compacted,I@1}
        add (1|M0)               r73.1<1>:d    r73.1<0;1,0>:d    r125.0<0;1,0>:d  {I@1}
(W)     jmpi                                 L856                                
L624:
        mov (1|M0)               r125.1<1>:q   r2.8<0;1,0>:d                   
        mov (2|M0)               r123.0<1>:q   r125.0<1;1,0>:q                  {I@1}
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
(W)     call (32|M0)             r101.0        L38032                                 {A@1}
L704:
        mul (1|M0)               acc0.0<1>:ud  r101.4<0;1,0>:ud  r125.4<0;1,0>:uw
        mach (1|M0)              r124.0<1>:ud  r101.4<0;1,0>:ud  r125.2<0;1,0>:ud {Compacted}
        mov (1|M0)               r7.0<1>:d     r101.4<0;1,0>:ud                
        mov (1|M0)               r123.0<1>:ud  acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r101.4<0;1,0>:d   r125.6<0;1,0>:uw
        macl (1|M0)              r103.0<1>:d   r101.4<0;1,0>:d   r125.3<0;1,0>:d  {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r101.5<0;1,0>:d   r125.4<0;1,0>:uw
        macl (1|M0)              r102.0<1>:d   r101.5<0;1,0>:d   r125.2<0;1,0>:d 
        mov (1|M0)               r101.0<1>:f   r123.0<0;1,0>:f                  {Compacted,I@5}
        add3 (1|M0)              r101.1<1>:d   r102.0<0;0>:d     r124.0<0;0>:d     r103.0<0>:d      {I@1}
        add (1|M0)               r125.0<1>:q   r125.0<0;1,0>:q   -r101.0<0;1,0>:q {A@1}
        mov (1|M0)               r73.1<1>:d    r125.0<0;1,0>:d                  {Compacted,I@1}
L856:
        shl (1|M0)               r7.0<1>:d     r7.0<0;1,0>:d     4:w               {Compacted}
        shl (1|M0)               r107.0<1>:q   r7.0<0;1,0>:ud    2:w               {I@1}
        add (1|M0)               r106.0<1>:q   r2.5<0;1,0>:q     r107.0<0;1,0>:q  {I@1}
        send.ugm (1|M0)          r77      r106  null:0  0x0            0x0210D580           {I@1,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        cmp (1|M0)    (lt)f2.1   null<1>:d     r77.1<0;1,0>:d    1:w               {$3.dst}
(W&f2.1) jmpi                                L37984                                
L944:
        mov (1|M0)               r73.2<1>:d    r77.0<0;1,0>:d                  
        mov (1|M0)               r4.2<1>:q     r2.14<0;1,0>:d                  
        mul (1|M0)               acc0.0<1>:d   r73.2<0;1,0>:d    r2.16<0;1,0>:uw  {I@2}
        mach (1|M0)              r76.0<1>:d    r73.2<0;1,0>:d    r2.8<0;1,0>:d   
        send.ugm (1|M0)          r103     r6  null:0  0x0            0x04100580           {$4} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r75.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r73.3<1>:d    r76.0<0;1,0>:d                   {I@2}
        mov (1|M0)               r73.2<1>:d    r75.0<0;1,0>:d                   {I@2}
        shl (1|M0)               r105.0<1>:q   r77.0<0;1,0>:d    2:w              
        add (1|M0)               r73.1<1>:q    r73.1<0;1,0>:q    r73.1<0;1,0>:ud  {I@2}
        shl (1|M0)               r73.1<1>:ud   r73.1<0;1,0>:ud   0x4:uw             
        mul (1|M0)               acc0.0<1>:ud  r73.2<0;1,0>:ud   r4.8<0;1,0>:uw   {I@2}
        mach (1|M0)              r127.0<1>:ud  r73.2<0;1,0>:ud   r4.4<0;1,0>:ud  
        mov (1|M0)               r4.4<1>:q     r73.1<0;1,0>:ud                  {I@3}
        mov (1|M0)               r126.0<1>:ud  acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r73.2<0;1,0>:d    r4.10<0;1,0>:uw 
        macl (1|M0)              r104.0<1>:d   r73.2<0;1,0>:d    r4.5<0;1,0>:d    {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r73.3<0;1,0>:d    r4.8<0;1,0>:uw  
        macl (1|M0)              r1.0<1>:d     r73.3<0;1,0>:d    r4.4<0;1,0>:d    {Compacted}
        mov (1|M0)               r123.0<1>:f   r126.0<0;1,0>:f                  {Compacted,I@5}
        add3 (1|M0)              r123.1<1>:d   r1.0<0;0>:d       r127.0<0;0>:d     r104.0<0>:d      {I@1}
        add (1|M0)               r104.0<1>:q   r3.1<0;1,0>:q     r105.0<0;1,0>:q  {Compacted}
        shl (1|M0)               r4.2<1>:q     r123.0<0;1,0>:q   9:w               {Compacted,A@1}
        send.ugm (1|M0)          r78      r104  null:0  0x0            0x04100580           {I@2,$5} // wr:2+0, rd:1; load.ugm.d32.a64
        shl (1|M0)               r4.4<1>:q     r4.4<0;1,0>:q     2:w              
        shl (1|M0)               r123.0<1>:q   r123.0<0;1,0>:q   6:w              
        add (1|M0)               r4.2<1>:q     r2.6<0;1,0>:q     r4.2<0;1,0>:q    {I@3}
        mov (1|M0)               r4.5<1>:q     r2.15<0;1,0>:d                  
        cmp (1|M0)    (eq)f1.0   null<1>:d     r2.15<0;1,0>:d    1:w              
        cmp (1|M0)    (gt)f0.1   null<1>:d     r2.15<0;1,0>:d    0:w              
        cmp (1|M0)    (eq)f0.0   null<1>:w     r122.0<0;1,0>:b   0:w              
        add (1|M0)               r4.4<1>:q     r3.7<0;1,0>:q     r4.4<0;1,0>:q    {I@7}
        add (1|M0)               r4.3<1>:q     r3.0<0;1,0>:q     r123.0<0;1,0>:q  {I@7}
        add (1|M0)               r3.2<1>:q     r4.2<0;1,0>:q     256:w               {I@7}
        add (1|M0)               r3.1<1>:q     r4.2<0;1,0>:q     512:w              
        mov (1|M0)               r3.7<1>:q     0:w                              
        add (1|M0)               r3.0<1>:q     r4.2<0;1,0>:q     768:w               {Compacted}
        sync.nop                             null                             {Compacted,$5.dst}
        math.inv (1|M0)          r78.1<1>:f    r103.0<0;1,0>:f                  {$4.dst}
        mul (1|M0)               r78.0<1>:f    r78.0<0;1,0>:f    r78.1<0;1,0>:f   {Compacted,M@1}
        mul (1|M0)               r78.0<1>:f    r78.0<0;1,0>:f    16384.0:f               {Compacted,F@1}
L1520:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r3.14<0;1,0>:d    0:w               {I@2}
        add (1|M0)               r78.3<1>:q    r77.1<0;1,0>:ud   -r3.7<0;1,0>:q  
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r3.15<0;1,0>:d    0:w              
(W&f1.1) jmpi                                L3368                                
L1584:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r78.7<0;1,0>:d    0:w               {I@3}
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r78.6<0;1,0>:ud   0x1:uw             
(W)     mov (1|M0)               r4.6<1>:hf    0x1:hf                             
        cmp (1|M0)    (gt)f3.1   null<1>:d     r78.7<0;1,0>:d    0:w              
        sync.nop                             null                             {F@1}
(f1.1)  sel (1|M0)               r127.1<1>:uw  r4.6<0;1,0>:uw    0x0:uw              {$12.src}
(f2.1)  sel (1|M0)               r127.0<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f3.0   null<1>:ud    r78.6<0;1,0>:ud   0x2:uw             
        and (1|M0)    (ne)f2.0   null<1>:uw    r127.1<0;1,0>:uw  r127.0<0;1,0>:uw {I@2}
        sync.allrd                           ($4,$9,$13,$14)                
(f1.1)  sel (1|M0)               r73.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw              {$0.src}
(f3.1)  sel (1|M0)               r4.7<1>:uw    r4.6<0;1,0>:uw    0x0:uw             
        sync.nop                             null                             {$5.dst}
(f3.0)  sel (1|M0)               r40.4<1>:uw   r4.6<0;1,0>:uw    0x0:uw              {$12.dst}
(f2.0)  sel (1|M0)               r4.24<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f3.0   null<1>:uw    r73.2<0;1,0>:uw   r40.4<0;1,0>:uw  {I@2}
        or (1|M0)     (ne)f2.0   null<1>:uw    r4.24<0;1,0>:uw   r4.7<0;1,0>:uw   {I@2}
(W)     mov (1|M0)               r78.2<1>:hf   0x1:hf                             
(f3.1)  sel (1|M0)               r73.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
(f1.1)  sel (1|M0)               r40.4<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
(f2.0)  sel (1|M0)               r111.0<1>:d   r78.2<0;1,0>:w    0:w               {F@1}
(f3.0)  sel (1|M0)               r78.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f2.0   null<1>:ud    r78.6<0;1,0>:ud   0x3:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r78.2<0;1,0>:uw   r73.2<0;1,0>:uw  {I@2}
(W)     mov (1|M0)               r73.2<1>:hf   0x2:hf                              {I@1}
        mov (1|M0)               r120.0<1>:f   r77.0<0;1,0>:f                   {Compacted}
(f2.0)  sel (1|M0)               r78.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        sync.nop                             null                             {Compacted,F@2}
(f2.1)  sel (1|M0)               r104.0<1>:d   r73.2<0;1,0>:w    0:w               {$7.src}
        and (1|M0)    (ne)f2.1   null<1>:uw    r40.4<0;1,0>:uw   r78.2<0;1,0>:uw  {I@2}
        mul (1|M0)               acc0.0<1>:d   r120.0<0;1,0>:d   r3.16<0;1,0>:uw  {F@1}
        mach (1|M0)              r38.0<1>:d    r120.0<0;1,0>:d   r3.8<0;1,0>:d   
        sync.allrd                           ($2,$3)                
(f3.1)  sel (1|M0)               r79.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw              {$1.src}
(f2.1)  sel (1|M0)               r73.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r78.6<0;1,0>:ud   0x4:uw             
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
(f1.1)  sel (1|M0)               r101.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw              {$12.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (1|M0)               r112.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@6,$9.dst}
        or (1|M0)     (ne)f3.0   null<1>:uw    r73.2<0;1,0>:uw   r79.2<0;1,0>:uw  {I@5}
        mov (1|M0)               r112.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@4}
        sync.nop                             null                             {$10.src}
(f2.1)  sel (1|M0)               r92.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw              {$6.src}
(W)     mov (1|M0)               r40.4<1>:hf   0x3:hf                             
        shl (1|M0)               r112.0<1>:q   r112.0<0;1,0>:q   2:w               {Compacted,A@2}
        and (1|M0)    (ne)f2.0   null<1>:uw    r101.2<0;1,0>:uw  r92.2<0;1,0>:uw  {I@2}
        shl (1|M0)               r102.0<1>:q   r3.7<0;1,0>:q     2:w               {Compacted,$15.src}
(f3.0)  sel (1|M0)               r92.2<1>:d    r40.4<0;1,0>:w    0:w               {F@1}
        add (1|M0)               r112.0<1>:q   r3.3<0;1,0>:q     r112.0<0;1,0>:q  {Compacted,I@4}
        cmp (1|M0)    (gt)f3.0   null<1>:ud    r78.6<0;1,0>:ud   0x5:uw             
(f3.1)  sel (1|M0)               r101.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
        add (1|M0)               r40.0<1>:q    r112.0<0;1,0>:q   r102.0<0;1,0>:q  {Compacted,I@3}
(f2.0)  sel (1|M0)               r102.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
(f1.1)  sel (1|M0)               r126.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw              {$0.src}
        or (1|M0)     (ne)f2.0   null<1>:uw    r102.2<0;1,0>:uw  r101.2<0;1,0>:uw {I@2}
(f3.0)  sel (1|M0)               r102.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
(W)     mov (1|M0)               r4.7<1>:hf    0x4:hf                             
        and (1|M0)    (ne)f3.0   null<1>:uw    r126.2<0;1,0>:uw  r102.2<0;1,0>:uw {I@1}
(f2.0)  sel (1|M0)               r40.2<1>:d    r4.7<0;1,0>:w     0:w               {F@1}
(f3.1)  sel (1|M0)               r126.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f2.0   null<1>:ud    r78.6<0;1,0>:ud   0x6:uw             
(f3.0)  sel (1|M0)               r127.0<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
(f1.1)  sel (1|M0)               r92.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r127.0<0;1,0>:uw  r126.2<0;1,0>:uw {I@2}
(W)     mov (1|M0)               r127.0<1>:hf  0x5:hf                              {I@1}
(f2.0)  sel (1|M0)               r127.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
        mov (1|M0)               r111.1<1>:d   0:w                              
(f2.1)  sel (1|M0)               r4.12<1>:d    r127.0<0;1,0>:w   0:w               {F@1}
        and (1|M0)    (ne)f2.1   null<1>:uw    r92.2<0;1,0>:uw   r127.2<0;1,0>:uw {I@3}
        mov (1|M0)               r104.1<1>:d   0:w                               {Compacted}
        shl (1|M0)               r111.0<1>:q   r111.0<0;1,0>:q   2:w               {Compacted,I@4}
        mov (1|M0)               r92.3<1>:d    0:w                              
(f3.1)  sel (1|M0)               r4.7<1>:uw    r4.6<0;1,0>:uw    0x0:uw             
        shl (1|M0)               r104.0<1>:q   r104.0<0;1,0>:q   2:w               {Compacted,I@4}
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r111.0<0;1,0>:q  {Compacted,I@4}
(f2.1)  sel (1|M0)               r101.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw             
        send.ugm (1|M0)          r92      r38  null:0  0x0            0x04100580           {I@2,$15} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r40.3<1>:d    0:w                              
        shl (1|M0)               r92.1<1>:q    r92.1<0;1,0>:q    2:w               {$15.dst}
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r104.0<0;1,0>:q 
        or (1|M0)     (ne)f3.0   null<1>:uw    r101.2<0;1,0>:uw  r4.7<0;1,0>:uw   {I@4}
        send.ugm (1|M0)          r101     r38  null:0  0x0            0x04100580           {I@1,$12} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r4.13<1>:d    0:w                              
(W)     mov (1|M0)               r126.2<1>:hf  0x6:hf                             
        shl (1|M0)               r40.1<1>:q    r40.1<0;1,0>:q    2:w              
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r92.1<0;1,0>:q   {$12.src}
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r78.6<0;1,0>:ud   0x7:uw             
        send.ugm (1|M0)          r102     r38  null:0  0x0            0x04100580           {I@2,$6} // wr:2+0, rd:1; load.ugm.d32.a64
        shl (1|M0)               r4.6<1>:q     r4.6<0;1,0>:q     2:w              
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r40.1<0;1,0>:q   {$6.src}
(f3.0)  sel (1|M0)               r40.2<1>:d    r126.2<0;1,0>:w   0:w               {F@1}
        mov (1|M0)               r40.3<1>:d    0:w                              
        send.ugm (1|M0)          r126     r38  null:0  0x0            0x04100580           {I@2,$11} // wr:2+0, rd:1; load.ugm.d32.a64
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r4.6<0;1,0>:q    {$11.src}
        shl (1|M0)               r40.1<1>:q    r40.1<0;1,0>:q    2:w               {I@2}
        send.ugm (1|M0)          r127     r38  null:0  0x0            0x04100580           {I@2,$10} // wr:2+0, rd:1; load.ugm.d32.a64
(f1.1)  sel (1|M0)               r102.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw              {$6.dst}
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r40.1<0;1,0>:q   {@2,$10.src}
(f2.1)  sel (1|M0)               r40.4<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r73.2<1>:uw   r4.6<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f2.0   null<1>:uw    r102.2<0;1,0>:uw  r40.4<0;1,0>:uw  {I@2}
(W)     mov (1|M0)               r102.2<1>:hf  4.172325e-07:hf                              {I@1}
        mov (1|M0)               r127.3<1>:d   0:w                               {$10.dst}
        sync.allwr                           ($1,$8,$13)                
        send.ugm (1|M0)          r42      r38  null:0  0x0            0x04100580           {$2} // wr:2+0, rd:1; load.ugm.d32.a64
(f2.0)  sel (1|M0)               r126.2<1>:uw  r4.6<0;1,0>:uw    0x0:uw              {$11.dst}
        send.ugm (1|M0)          r79      r40  null:0  0x0            0x04100580           {$7} // wr:2+0, rd:1; load.ugm.d32.a64
        or (1|M0)     (ne)f3.0   null<1>:uw    r126.2<0;1,0>:uw  r73.2<0;1,0>:uw  {I@1}
(f3.0)  sel (1|M0)               r127.2<1>:d   r102.2<0;1,0>:w   0:w               {F@1}
        shl (1|M0)               r127.1<1>:q   r127.1<0;1,0>:q   2:w               {I@1}
        add (1|M0)               r38.0<1>:q    r40.0<0;1,0>:q    r127.1<0;1,0>:q  {Compacted,@1,$2.src}
        sync.allwr                           ($0,$9)                
        send.ugm (1|M0)          r95      r38  null:0  0x0            0x04100580           {I@1,$8} // wr:2+0, rd:1; load.ugm.d32.a64
        sync.nop                             null                             {Compacted,$2.dst}
(W)     send.ugm (1|M0)          null     r73  r42:1  0x80400000:a0.1        0x4200D504           {$0} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        sync.nop                             null                             {Compacted,$8.dst}
(W)     send.ugm (1|M0)          null     r73  r95:1  0x80000000:a0.1        0x4200D504           {$13} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
(W)     jmpi                                 L3520                                
L3368:
        sync.allwr                           ($1,$2,$8,$13)                
        mov (1|M0)               r41.0<1>:d    r77.8<0;1,0>:d                   {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$3.src}
        mov (1|M0)               r94.0<1>:d    r77.9<0;1,0>:d                   {Compacted,$12.src}
(W)     send.ugm (1|M0)          null     r73  r41:1  0x80400000:a0.1        0x4200D504           {I@2,$14} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W)     send.ugm (1|M0)          null     r73  r94:1  0x80000000:a0.1        0x4200D504           {I@1,$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
        mov (1|M0)               r79.0<1>:d    r77.2<0;1,0>:d                   {Compacted}
        sync.nop                             null                             {Compacted,$10.src}
        mov (1|M0)               r92.0<1>:d    r77.3<0;1,0>:d                   {Compacted,$6.src}
        mov (1|M0)               r101.0<1>:d   r77.4<0;1,0>:d                   {Compacted,$12.dst}
        mov (1|M0)               r102.0<1>:d   r77.5<0;1,0>:d                   {$15.src}
        mov (1|M0)               r126.0<1>:d   r77.6<0;1,0>:d                   {$0.src}
        mov (1|M0)               r127.0<1>:d   r77.7<0;1,0>:d                  
L3520:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r78.7<0;1,0>:d    0:w              
        cmp (1|M0)    (lt)f2.0   null<1>:ud    r78.6<0;1,0>:ud   0x2:uw             
(W)     mov (1|M0)               r92.2<1>:hf   0x1:hf                             
(f3.0)  sel (1|M0)               r102.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw              {F@1}
(f2.0)  sel (1|M0)               r126.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f2.0   null<1>:uw    r102.2<0;1,0>:uw  r126.2<0;1,0>:uw {I@1}
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r78.7<0;1,0>:d    0:w              
(W&f2.0) jmpi                                L31264                                
L3648:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r78.6<0;1,0>:d    2:w              
(W)     mov (1|M0)               r79.2<1>:hf   0x1:hf                              {$7.dst}
(f3.0)  sel (1|M0)               r102.2<1>:uw  r79.2<0;1,0>:uw   0x0:uw              {F@1}
(f1.1)  sel (1|M0)               r101.2<1>:uw  r79.2<0;1,0>:uw   0x0:uw              {$12.dst}
        and (1|M0)    (ne)f1.1   null<1>:uw    r101.2<0;1,0>:uw  r102.2<0;1,0>:uw {I@1}
(W&f1.1) jmpi                                L24128                                
L3744:
        asr (1|M0)               r4.3<1>:d     r79.0<0;1,0>:d    31:w              
        asr (1|M0)               r126.1<1>:d   r92.0<0;1,0>:d    31:w              
        shr (1|M0)               r4.3<1>:ud    r4.3<0;1,0>:ud    0x1D:uw              {I@2}
        shr (1|M0)               r126.1<1>:ud  r126.1<0;1,0>:ud  0x1D:uw              {I@2}
        add (1|M0)               r4.3<1>:d     r79.0<0;1,0>:d    r4.3<0;1,0>:d    {I@2}
        asr (1|M0)               r127.1<1>:d   r101.0<0;1,0>:d   31:w              
        asr (1|M0)               r4.3<1>:d     r4.3<0;1,0>:d     3:w               {I@2}
(f0.0)  mov (1|M0)               r4.3<1>:d     r79.0<0;1,0>:d                  
        add (1|M0)               r126.1<1>:d   r92.0<0;1,0>:d    r126.1<0;1,0>:d 
        shr (1|M0)               r127.1<1>:ud  r127.1<0;1,0>:ud  0x1D:uw              {I@4}
        mul (1|M0)               acc0.0<1>:d   r4.3<0;1,0>:d     r3.24<0;1,0>:uw  {I@3}
        asr (1|M0)               r126.1<1>:d   r126.1<0;1,0>:d   3:w               {I@3}
        sync.nop                             null                             {$5.dst}
        mach (1|M0)              r38.0<1>:d    r4.3<0;1,0>:d     r3.12<0;1,0>:d   {$12.dst}
(f0.0)  mov (1|M0)               r126.1<1>:d   r92.0<0;1,0>:d                  
        add (1|M0)               r127.1<1>:d   r101.0<0;1,0>:d   r127.1<0;1,0>:d  {I@5}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r126.1<0;1,0>:d   r3.24<0;1,0>:uw  {I@3}
        mov (1|M0)               r4.13<1>:d    r38.0<0;1,0>:d                  
        asr (1|M0)               r127.1<1>:d   r127.1<0;1,0>:d   3:w               {I@4}
        mach (1|M0)              r38.0<1>:d    r126.1<0;1,0>:d   r3.12<0;1,0>:d  
(f0.0)  mov (1|M0)               r127.1<1>:d   r101.0<0;1,0>:d                 
        cmp (1|M0)    (lt)f3.1   null<1>:ud    r78.6<0;1,0>:ud   0x5:uw             
        mov (1|M0)               r4.12<1>:d    r37.0<0;1,0>:d                   {I@7}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r127.1<0;1,0>:d   r3.24<0;1,0>:uw  {I@4}
(W)     mov (1|M0)               r78.2<1>:hf   0x1:hf                             
        mov (1|M0)               r78.3<1>:d    r38.0<0;1,0>:d                  
        mach (1|M0)              r38.0<1>:d    r127.1<0;1,0>:d   r3.12<0;1,0>:d  
        mov (1|M0)               r78.2<1>:d    r37.0<0;1,0>:d                   {I@4}
(f3.0)  sel (1|M0)               r92.2<1>:uw   r78.2<0;1,0>:uw   0x0:uw              {F@1}
(f3.1)  sel (1|M0)               r101.2<1>:uw  r78.2<0;1,0>:uw   0x0:uw             
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r79.3<1>:d    r38.0<0;1,0>:d                   {I@5}
        and (1|M0)    (ne)f2.1   null<1>:uw    r92.2<0;1,0>:uw   r101.2<0;1,0>:uw {I@3}
        mov (1|M0)               r79.2<1>:d    r37.0<0;1,0>:d                   {I@3}
        shl (1|M0)               r4.6<1>:q     r4.6<0;1,0>:q     1:w              
        shl (1|M0)               r78.1<1>:q    r78.1<0;1,0>:q    1:w              
        shl (1|M0)               r79.1<1>:q    r79.1<0;1,0>:q    1:w               {I@3}
        sync.allrd                           ($4,$9,$13,$14)                
        add (1|M0)               r73.1<1>:q    r3.5<0;1,0>:q     r4.6<0;1,0>:q    {@3,$0.src}
        add (1|M0)               r4.7<1>:q     r3.5<0;1,0>:q     r78.1<0;1,0>:q   {I@3}
        add (1|M0)               r4.6<1>:q     r3.5<0;1,0>:q     r79.1<0;1,0>:q   {I@3}
(W&f2.1) jmpi                                L16048                                
L4448:
(W)     send.ugm (1|M0)          r40      r73  null:0  0x80400000:a0.1        0x4210D500           {I@4,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        asr (1|M0)               r73.1<1>:d    r102.0<0;1,0>:d   31:w               {$3.src}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r78.6<0;1,0>:d    5:w              
        shr (1|M0)               r73.1<1>:ud   r73.1<0;1,0>:ud   0x1D:uw              {I@2}
        asr (1|M0)               r78.1<1>:d    r126.0<0;1,0>:d   31:w               {Compacted}
(W)     mov (1|M0)               r92.2<1>:hf   0x1:hf                             
        add (1|M0)               r73.1<1>:d    r102.0<0;1,0>:d   r73.1<0;1,0>:d   {Compacted,I@2}
        shr (1|M0)               r78.1<1>:ud   r78.1<0;1,0>:ud   0x1D:uw              {I@2}
        sync.nop                             null                             {$1.dst}
        sync.allrd                           ($0,$2,$7)                
(W)     send.ugm (1|M0)          r93      r73  null:0  0x80000000:a0.1        0x4210D500           {I@2,$4} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
(f2.0)  sel (1|M0)               r101.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw              {F@1}
(f3.0)  sel (1|M0)               r126.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw             
        asr (1|M0)               r73.1<1>:d    r73.1<0;1,0>:d    3:w               {$4.src}
(f0.0)  mov (1|M0)               r73.1<1>:d    r102.0<0;1,0>:d                 
        add (1|M0)               r78.1<1>:d    r126.0<0;1,0>:d   r78.1<0;1,0>:d   {I@5}
        and (1|M0)    (ne)f2.0   null<1>:uw    r101.2<0;1,0>:uw  r126.2<0;1,0>:uw {I@4}
        mul (1|M0)               acc0.0<1>:d   r73.1<0;1,0>:d    r3.24<0;1,0>:uw  {I@3}
        asr (1|M0)               r78.1<1>:d    r78.1<0;1,0>:d    3:w               {I@3}
        mach (1|M0)              r38.0<1>:d    r73.1<0;1,0>:d    r3.12<0;1,0>:d  
(f0.0)  mov (1|M0)               r78.1<1>:d    r126.0<0;1,0>:d                 
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r78.1<0;1,0>:d    r3.24<0;1,0>:uw  {I@2}
        mov (1|M0)               r126.3<1>:d   r38.0<0;1,0>:d                  
        mach (1|M0)              r38.0<1>:d    r78.1<0;1,0>:d    r3.12<0;1,0>:d  
(f2.0)  sel (1|M0)               r78.1<1>:d    r79.0<0;1,0>:d    r127.0<0;1,0>:d 
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r78.6<0;1,0>:ud   0x6:uw             
        asr (1|M0)               r79.1<1>:d    r78.1<0;1,0>:d    31:w               {I@2}
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r78.7<0;1,0>:ud   0x0:uw             
        shr (1|M0)               r79.1<1>:ud   r79.1<0;1,0>:ud   0x1D:uw              {I@2}
(f3.1)  sel (1|M0)               r127.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw             
        add (1|M0)               r79.1<1>:d    r78.1<0;1,0>:d    r79.1<0;1,0>:d   {I@2}
        mov (1|M0)               r126.2<1>:d   r37.0<0;1,0>:d                  
        asr (1|M0)               r79.1<1>:d    r79.1<0;1,0>:d    3:w               {I@2}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
(~f0.0) mov (1|M0)               r78.1<1>:f    r79.1<0;1,0>:f                   {I@2}
(f3.0)  sel (1|M0)               r79.2<1>:uw   r92.2<0;1,0>:uw   0x0:uw              {F@1}
        mul (1|M0)               acc0.0<1>:d   r78.1<0;1,0>:d    r3.24<0;1,0>:uw 
        and (1|M0)    (ne)f3.1   null<1>:uw    r79.2<0;1,0>:uw   r127.2<0;1,0>:uw {I@2}
        mov (1|M0)               r102.3<1>:d   r38.0<0;1,0>:d                  
        mach (1|M0)              r38.0<1>:d    r78.1<0;1,0>:d    r3.12<0;1,0>:d  
(f2.1)  sel (1|M0)               r78.2<1>:uw   r92.2<0;1,0>:uw   0x0:uw             
(f3.1)  sel (1|M0)               r92.3<1>:uw   r92.2<0;1,0>:uw   0x0:uw             
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r78.6<0;1,0>:ud   0x7:uw             
        or (1|M0)     (ne)f1.1   null<1>:uw    r92.3<0;1,0>:uw   r78.2<0;1,0>:uw  {I@2}
(f3.0)  sel (1|M0)               r101.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw             
        mov (1|M0)               r102.2<1>:d   r37.0<0;1,0>:d                  
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r92.3<1>:d    r38.0<0;1,0>:d                  
        mov (1|M0)               r92.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@2}
        mov (32|M0)              r88.0<1>:f    0.0:f                               {Compacted}
(f1.1)  sel (1|M0)               r78.1<1>:d    r40.0<0;1,0>:d    r79.0<0;1,0>:d   {$3.dst}
        mov (32|M0)              r86.0<1>:f    0.0:f                               {Compacted}
        asr (1|M0)               r79.1<1>:d    r78.1<0;1,0>:d    31:w               {I@1}
        sync.nop                             null                             {Compacted,$11.src}
        mov (32|M0)              r84.0<1>:f    0.0:f                               {Compacted,$15.src}
        shr (1|M0)               r79.1<1>:ud   r79.1<0;1,0>:ud   0x1D:uw              {I@1}
        mov (32|M0)              r75.0<1>:f    0.0:f                               {Compacted,$6.dst}
        add (1|M0)               r79.1<1>:d    r78.1<0;1,0>:d    r79.1<0;1,0>:d   {I@1}
        shl (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   1:w              
        asr (1|M0)               r79.1<1>:d    r79.1<0;1,0>:d    3:w               {I@2}
        shl (1|M0)               r102.1<1>:q   r102.1<0;1,0>:q   1:w              
(~f0.0) mov (1|M0)               r78.1<1>:f    r79.1<0;1,0>:f                   {I@2}
(f3.1)  sel (1|M0)               r79.2<1>:uw   r92.2<0;1,0>:uw   0x0:uw              {F@1}
        mul (1|M0)               acc0.0<1>:d   r78.1<0;1,0>:d    r3.24<0;1,0>:uw 
        and (1|M0)    (ne)f3.0   null<1>:uw    r101.2<0;1,0>:uw  r79.2<0;1,0>:uw  {I@2}
        mach (1|M0)              r38.0<1>:d    r78.1<0;1,0>:d    r3.12<0;1,0>:d  
        shl (1|M0)               r92.1<1>:q    r92.1<0;1,0>:q    1:w              
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
(f3.0)  sel (1|M0)               r102.2<1>:uw  r92.2<0;1,0>:uw   0x0:uw             
(f2.1)  sel (1|M0)               r92.2<1>:uw   r92.2<0;1,0>:uw   0x0:uw             
        mov (1|M0)               r78.5<1>:d    r38.0<0;1,0>:d                   {I@5}
        or (1|M0)     (ne)f2.1   null<1>:uw    r102.2<0;1,0>:uw  r92.2<0;1,0>:uw  {I@2}
        mov (1|M0)               r78.4<1>:d    r37.0<0;1,0>:d                  
        add (1|M0)               r73.6<1>:q    r3.5<0;1,0>:q     r126.1<0;1,0>:q 
        shl (1|M0)               r78.2<1>:q    r78.2<0;1,0>:q    1:w               {I@2}
(f2.1)  sel (1|M0)               r126.1<1>:d   r93.0<0;1,0>:d    r79.0<0;1,0>:d   {$4.dst}
        add (1|M0)               r73.7<1>:q    r3.5<0;1,0>:q     r102.1<0;1,0>:q 
        asr (1|M0)               r127.1<1>:d   r126.1<0;1,0>:d   31:w               {I@2}
        add (1|M0)               r78.1<1>:q    r3.5<0;1,0>:q     r92.1<0;1,0>:q  
        shr (1|M0)               r127.1<1>:ud  r127.1<0;1,0>:ud  0x1D:uw              {I@2}
        add (1|M0)               r78.2<1>:q    r3.5<0;1,0>:q     r78.2<0;1,0>:q  
        add (1|M0)               r127.1<1>:d   r126.1<0;1,0>:d   r127.1<0;1,0>:d  {I@2}
        asr (1|M0)               r127.1<1>:d   r127.1<0;1,0>:d   3:w               {I@1}
(~f0.0) mov (1|M0)               r126.1<1>:f   r127.1<0;1,0>:f                  {I@1}
        mul (1|M0)               acc0.0<1>:d   r126.1<0;1,0>:d   r3.24<0;1,0>:uw  {F@1}
        mach (1|M0)              r38.0<1>:d    r126.1<0;1,0>:d   r3.12<0;1,0>:d  
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r127.3<1>:d   r38.0<0;1,0>:d                   {I@2}
        mov (1|M0)               r127.2<1>:d   r37.0<0;1,0>:d                   {I@2}
        shl (1|M0)               r127.1<1>:q   r127.1<0;1,0>:q   1:w               {I@1}
        add (1|M0)               r78.3<1>:q    r3.5<0;1,0>:q     r127.1<0;1,0>:q  {I@1}
(W&~f0.1) jmpi                               L15072                                
L5872:
        sync.allrd                           ($5,$7,$8)                
(W)     mov (1|M0)               r98.0<1>:uq   r4.3<0;1,0>:uq                   {Compacted,$6.dst}
(W)     mov (1|M0)               r93.0<1>:uq   r73.7<0;1,0>:uq                  {Compacted}
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r91      r98  null:0  0x0            0x0210D580           {I@2,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r109     r93  null:0  0x0            0x0220E580           {I@1,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r93.0<1>:uq   r78.1<0;1,0>:uq                  {Compacted,$3.src}
        sync.nop                             null                             {Compacted,$14.dst}
(W)     mov (1|M0)               r100.0<1>:uq  r4.2<0;1,0>:uq                   {Compacted,$4.dst}
        send.ugm (1|M0)          r112     r93  null:0  0x0            0x0220E580           {I@2,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r93.0<1>:uq   r78.2<0;1,0>:uq                  {Compacted,$9.src}
(W)     mov (1|M0)               r99.0<1>:uq   r3.2<0;1,0>:uq                   {Compacted,$3.dst}
        sync.nop                             null                             {$5.dst}
        send.ugm (1|M0)          r114     r93  null:0  0x0            0x0220E580           {I@2,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r97.0<1>:uq   r73.1<0;1,0>:uq                  {Compacted,$10.src}
        sync.allwr                           ($0,$8)                
(W)     mov (1|M0)               r96.0<1>:uq   r4.7<0;1,0>:uq                   {Compacted,$9.dst}
(W)     mov (1|M0)               r95.0<1>:uq   r4.6<0;1,0>:uq                   {Compacted,$13.src}
        sync.nop                             null                             {Compacted,$3.src}
(W)     mov (1|M0)               r94.0<1>:uq   r73.6<0;1,0>:uq                  {Compacted,$12.src}
(W)     mov (1|M0)               r93.0<1>:uq   r78.3<0;1,0>:uq                  {Compacted}
        send.ugm (1|M0)          r41      r100  null:0  0x0            0x024AF580           {$2} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r37      r99  null:0  0x0            0x024AF580           {I@6,$0} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r103     r96  null:0  0x0            0x0220E580           {I@4,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$3.dst}
        send.ugm (1|M0)          r105     r95  null:0  0x0            0x0220E580           {I@3,$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$13.dst}
        send.ugm (1|M0)          r107     r94  null:0  0x0            0x0220E580           {I@2,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r116     r93  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     send.ugm (1|M0)          null     r73  r91:1  0x80200000:a0.1        0x4200D504           {$1} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        send.ugm (1|M0)          r90      r97  null:0  0x0            0x0220E580           {$1} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W&f1.0) jmpi                                L6624                                
L6256:
        sync.nop                             null                             {Compacted,$0.dst}
(W)     mov (1|M0)               r57.0<1>:uq   r3.0<0;1,0>:uq                   {Compacted,$2.dst}
(W)     mov (1|M0)               r58.0<1>:uq   r3.1<0;1,0>:uq                   {Compacted}
        sync.nop                             null                             {Compacted,$4.dst}
        send.ugm (1|M0)          r21      r57  null:0  0x0            0x024AF580           {I@2,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
(W)     mov (1|M0)               r57.0<1>:uq   r78.1<0;1,0>:uq                  {Compacted,$10.src}
        sync.nop                             null                             {Compacted,$6.src}
(W)     mov (1|M0)               r125.0<1>:uq  r4.3<0;1,0>:uq                   {Compacted,$11.src}
        sync.nop                             null                             {Compacted,$6.dst}
        send.ugm (1|M0)          r61      r57  null:0  0x80000            0x0220E580           {I@2,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.allrd                           ($11,$15)                
(W)     mov (1|M0)               r124.0<1>:uq  r73.1<0;1,0>:uq                  {Compacted,$5.src}
(W)     mov (1|M0)               r123.0<1>:uq  r4.7<0;1,0>:uq                   {Compacted,$9.src}
(W)     mov (1|M0)               r122.0<1>:uq  r4.6<0;1,0>:uq                   {Compacted,$7.src}
(W)     mov (1|M0)               r121.0<1>:uq  r73.6<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r120.0<1>:uq  r73.7<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r93.0<1>:uq   r78.3<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r57.0<1>:uq   r78.2<0;1,0>:uq                  {Compacted,$14.src}
        sync.nop                             null                             {Compacted,$13.dst}
        send.ugm (1|M0)          r25      r58  null:0  0x0            0x024AF580           {$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$12.dst}
        send.ugm (1|M0)          r83      r125  null:0  0x40000            0x0210D580           {I@7,$11} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {$9.dst}
        send.ugm (1|M0)          r71      r124  null:0  0x80000            0x0220E580           {I@7,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r69      r123  null:0  0x80000            0x0220E580           {I@6,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r67      r122  null:0  0x80000            0x0220E580           {I@5,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r65      r121  null:0  0x80000            0x0220E580           {I@4,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$8.dst}
        send.ugm (1|M0)          r63      r120  null:0  0x80000            0x0220E580           {I@3,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r59      r57  null:0  0x80000            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r57      r93  null:0  0x80000            0x0220E580           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L6624:
        mov (1|M0)               r78.4<1>:q    0:w                              
L6640:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r78.9<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r78.8<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r78.9<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f3.0) jmpi                               L10880                                
L6704:
        sync.nop                             null                             {$1.dst}
        sync.allrd                           ($0,$4)                
        shl (16|M0)              r118.0<1>:d   r42.0<1;1,0>:d    12:w               {Compacted,$2.dst}
(W)     mov (1|M0)               r78.1<1>:f    0xE000E00:f                              
        shl (16|M0)              r111.0<1>:d   r42.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x4:uw             
        sync.nop                             null                             {Compacted,$3.src}
        shl (16|M0)              r94.0<1>:d    r41.0<1;1,0>:d    12:w               {Compacted,$12.src}
        sync.nop                             null                             {A@1}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        sync.nop                             null                             {Compacted,$2.src}
        shl (16|M0)              r93.0<1>:d    r41.0<1;1,0>:d    9:w               {Compacted,$7.src}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@4}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$3.dst}
        mov (8|M0)               r119.0<1>:f   r105.0<1;1,0>:f                  {$13.dst}
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$13.dst}
        mov (8|M0)               r119.8<1>:d   r107.0<1;1,0>:d                  {$12.dst}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {@2,$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r120.0<1>:f   r109.0<1;1,0>:f                 
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r41.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r42.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r120.8<1>:d   r112.0<1;1,0>:d                  {$9.dst}
        sync.nop                             null                             {$5.dst}
        mov (8|M0)               r121.0<1>:f   r114.0<1;1,0>:f                  {$8.dst}
        mov (8|M0)               r121.8<1>:d   r116.0<1;1,0>:d                  {$7.dst}
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        sync.nop                             null                             {Compacted,I@1}
        mov (8|M0)               r118.0<1>:f   r90.0<1;1,0>:f                  
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r118.8<1>:d   r103.0<1;1,0>:d                  {$4.dst}
        shl (16|M0)              r111.0<1>:d   r44.0<1;1,0>:d    9:w               {Compacted}
        sync.nop                             null                             {Compacted,A@1}
        sync.allrd                           ($6,$11)                
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$9}
        sync.nop                             null                             {$9.src}
(W)     send.ugm (1|M0)          r93      r73  null:0  0x80200000:a0.1        0x4210D500           {$8} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        shl (16|M0)              r94.0<1>:d    r43.0<1;1,0>:d    12:w              
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@1}
        add (1|M0)               r78.5<1>:q    r78.4<0;1,0>:q    2:w              
        cmp (1|M0)    (eq)f3.1   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d   {I@1}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r78.10<0;1,0>:ud  r4.10<0;1,0>:ud 
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d  
        and (16|M0)              r73.8<1>:w    r93.0<1;1,0>:ub   127:w               {$8.dst}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {I@1}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$9.dst}
        shl (16|M0)              r118.0<1>:d   r44.0<1;1,0>:d    12:w               {Compacted,F@1}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@1}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f     
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x4:uw              {F@1}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r43.0<1;1,0>:d    9:w              
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@3}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:d   r105.8<1;1,0>:d                 
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.8<1>:f   r107.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r120.0<1>:d   r109.8<1;1,0>:d                 
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r43.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r44.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r120.8<1>:f   r112.8<1;1,0>:f                 
        mov (8|M0)               r121.0<1>:d   r114.8<1;1,0>:d                 
        mov (8|M0)               r121.8<1>:f   r116.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        mov (8|M0)               r118.0<1>:d   r90.8<1;1,0>:d                  
        mov (8|M0)               r118.8<1>:f   r103.8<1;1,0>:f                  {I@2}
        shl (16|M0)              r111.0<1>:d   r38.0<1;1,0>:d    9:w               {Compacted,$0.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$7}
        sync.nop                             null                             {Compacted,$7.src}
(W)     send.ugm (1|M0)          r93      r73  null:0  0x80200000:a0.1        0x4210D500           {$1} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        shl (16|M0)              r94.0<1>:d    r37.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@1}
        and (16|M0)              r73.8<1>:w    r93.16<1;1,0>:ub  127:w               {$1.dst}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {I@1}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$7.dst}
        shl (16|M0)              r118.0<1>:d   r38.0<1;1,0>:d    12:w               {Compacted,F@1}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@1}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw              {F@1}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r37.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@3}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:f   r106.0<1;1,0>:f                 
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.8<1>:d   r108.0<1;1,0>:d                 
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r120.0<1>:f   r110.0<1;1,0>:f                 
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r37.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r38.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r120.8<1>:d   r113.0<1;1,0>:d                 
        mov (8|M0)               r121.0<1>:f   r115.0<1;1,0>:f                 
        mov (8|M0)               r121.8<1>:d   r117.0<1;1,0>:d                 
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        mov (8|M0)               r118.0<1>:f   r91.0<1;1,0>:f                   {I@1}
        mov (8|M0)               r118.8<1>:d   r104.0<1;1,0>:d                 
        shl (16|M0)              r111.0<1>:d   r40.0<1;1,0>:d    9:w               {Compacted}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$11}
        sync.nop                             null                             {Compacted,$11.src}
(W)     send.ugm (1|M0)          r93      r73  null:0  0x80200000:a0.1        0x4210D500           {$6} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        shl (16|M0)              r94.0<1>:d    r39.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@1}
        and (16|M0)              r73.8<1>:w    r93.32<1;1,0>:ub  127:w               {$6.dst}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {I@1}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$11.dst}
        shl (16|M0)              r118.0<1>:d   r40.0<1;1,0>:d    12:w               {Compacted,F@1}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@1}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x4:uw              {F@1}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r39.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@3}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:d   r106.8<1;1,0>:d                 
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.8<1>:f   r108.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r120.0<1>:d   r110.8<1;1,0>:d                 
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r39.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r40.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r120.8<1>:f   r113.8<1;1,0>:f                 
        mov (8|M0)               r121.0<1>:d   r115.8<1;1,0>:d                 
        mov (8|M0)               r121.8<1>:f   r117.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        mov (8|M0)               r118.0<1>:d   r91.8<1;1,0>:d                  
        mov (8|M0)               r118.8<1>:f   r104.8<1;1,0>:f                  {I@2}
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$4}
        sync.nop                             null                             {$4.src}
(W)     send.ugm (1|M0)          r93      r73  null:0  0x80200000:a0.1        0x4210D500           {$12} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        and (16|M0)              r73.8<1>:w    r93.48<1;1,0>:ub  127:w               {$12.dst}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {I@1}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$4.dst}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
(W&~f3.1) jmpi                               L10880                                
L10544:
        shl (1|M0)               r101.1<1>:q   r78.5<0;1,0>:q    6:w              
        shl (1|M0)               r118.0<1>:q   r78.5<0;1,0>:q    9:w               {Compacted,F@7}
        add (1|M0)               r97.0<1>:q    r4.3<0;1,0>:q     r101.1<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r78.5<1>:q    r78.5<0;1,0>:q    7:w              
        send.ugm (1|M0)          r90      r97  null:0  0x0            0x0210D580           {I@2,$9} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        add (1|M0)               r93.0<1>:q    r73.6<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,I@1}
        add (1|M0)               r118.0<1>:q   r4.2<0;1,0>:q     r118.0<0;1,0>:q  {Compacted}
        send.ugm (1|M0)          r107     r93  null:0  0x0            0x0220E580           {I@2,$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r93.0<1>:q    r73.7<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,$13.src}
        send.ugm (1|M0)          r41      r118  null:0  0x0            0x024AF580           {I@2,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r109     r93  null:0  0x0            0x0220E580           {I@1,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r93.0<1>:q    r78.1<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,$10.src}
        add (1|M0)               r96.0<1>:q    r73.1<0;1,0>:q    r78.5<0;1,0>:q   {Compacted}
        send.ugm (1|M0)          r112     r93  null:0  0x0            0x0220E580           {I@2,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r93.0<1>:q    r78.2<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,$14.src}
        add (1|M0)               r95.0<1>:q    r4.7<0;1,0>:q     r78.5<0;1,0>:q   {Compacted}
        send.ugm (1|M0)          r114     r93  null:0  0x0            0x0220E580           {I@2,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r94.0<1>:q    r4.6<0;1,0>:q     r78.5<0;1,0>:q   {Compacted}
        add (1|M0)               r118.0<1>:q   r118.0<0;1,0>:q   256:w               {Compacted,$1.src}
        add (1|M0)               r93.0<1>:q    r78.3<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,$5.src}
        send.ugm (1|M0)          r103     r95  null:0  0x0            0x0220E580           {I@4,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r105     r94  null:0  0x0            0x0220E580           {I@3,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r37      r118  null:0  0x0            0x024AF580           {I@2,$0} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r116     r93  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     send.ugm (1|M0)          null     r73  r90:1  0x80200000:a0.1        0x4200D504           {$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        sync.nop                             null                             {$9.src}
        send.ugm (1|M0)          r90      r96  null:0  0x0            0x0220E580           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L10880:
        mov (2|M0)               r73.4<1>:d    0x1:v                              
        or (2|M0)                r78.10<1>:d   r78.8<1;1,0>:d    r73.4<1;1,0>:d   {I@1}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d   {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r78.10<0;1,0>:ud  r4.10<0;1,0>:ud 
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d  
(W&~f3.0) jmpi                               L14992                                
L10976:
        sync.nop                             null                             {Compacted,$13.dst}
        sync.allrd                           ($0,$4)                
        shl (16|M0)              r118.0<1>:d   r26.0<1;1,0>:d    12:w               {Compacted,$5.dst}
(W)     mov (1|M0)               r78.1<1>:f    0xE000E00:f                              
        shl (16|M0)              r111.0<1>:d   r26.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x4:uw              {F@2}
        sync.nop                             null                             {Compacted,$3.src}
        shl (16|M0)              r94.0<1>:d    r25.0<1;1,0>:d    12:w               {Compacted,$12.src}
        sync.nop                             null                             {Compacted,A@1}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {$1.src} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        sync.nop                             null                             {Compacted,$2.src}
        shl (16|M0)              r93.0<1>:d    r25.0<1;1,0>:d    9:w               {Compacted,$7.src}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@4}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:f   r67.0<1;1,0>:f                   {$4.dst}
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$11.dst}
        mov (8|M0)               r119.8<1>:d   r65.0<1;1,0>:d                   {$0.dst}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {@2,$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        sync.nop                             null                             {Compacted,$8.dst}
        mov (8|M0)               r120.0<1>:f   r63.0<1;1,0>:f                   {$3.dst}
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r25.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r26.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r120.8<1>:d   r61.0<1;1,0>:d                   {$14.dst}
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r121.0<1>:f   r59.0<1;1,0>:f                   {$12.dst}
        mov (8|M0)               r121.8<1>:d   r57.0<1;1,0>:d                   {$2.dst}
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        sync.nop                             null                             {Compacted,I@1}
        mov (8|M0)               r118.0<1>:f   r71.0<1;1,0>:f                   {$9.dst}
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r118.8<1>:d   r69.0<1;1,0>:d                  
        and (16|M0)              r73.8<1>:w    r83.0<1;1,0>:ub   127:w               {$12.dst}
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$8}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {@1,$8.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$8.dst}
        shl (16|M0)              r118.0<1>:d   r28.0<1;1,0>:d    12:w               {Compacted,F@1}
        shl (16|M0)              r111.0<1>:d   r28.0<1;1,0>:d    9:w              
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@2}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r94.0<1>:d    r27.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@3} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r27.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@4}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:d   r67.8<1;1,0>:d                  
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.8<1>:f   r65.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        mov (8|M0)               r120.0<1>:d   r63.8<1;1,0>:d                  
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r27.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                  {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r28.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r120.8<1>:f   r61.8<1;1,0>:f                  
        mov (8|M0)               r121.0<1>:d   r59.8<1;1,0>:d                  
        mov (8|M0)               r121.8<1>:f   r57.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        mov (8|M0)               r118.0<1>:d   r71.8<1;1,0>:d                  
        mov (8|M0)               r118.8<1>:f   r69.8<1;1,0>:f                   {I@2}
        and (16|M0)              r73.8<1>:w    r83.16<1;1,0>:ub  127:w              
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$11}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {@1,$11.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$11.dst}
        sync.nop                             null                             {Compacted,F@1}
        shl (16|M0)              r118.0<1>:d   r22.0<1;1,0>:d    12:w               {Compacted,$4.dst}
        shl (16|M0)              r111.0<1>:d   r22.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@2}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r94.0<1>:d    r21.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@3} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r21.0<1;1,0>:d    9:w              
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@4}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:f   r68.0<1;1,0>:f                  
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.8<1>:d   r66.0<1;1,0>:d                  
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r120.0<1>:f   r64.0<1;1,0>:f                  
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@1} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r21.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r22.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r120.8<1>:d   r62.0<1;1,0>:d                  
        mov (8|M0)               r121.0<1>:f   r60.0<1;1,0>:f                  
        mov (8|M0)               r121.8<1>:d   r58.0<1;1,0>:d                  
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        mov (8|M0)               r118.0<1>:f   r72.0<1;1,0>:f                   {I@1}
        mov (8|M0)               r118.8<1>:d   r70.0<1;1,0>:d                  
        and (16|M0)              r73.8<1>:w    r83.32<1;1,0>:ub  127:w              
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$14}
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {@1,$14.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$14.dst}
        shl (16|M0)              r118.0<1>:d   r24.0<1;1,0>:d    12:w               {Compacted,F@1}
        shl (16|M0)              r111.0<1>:d   r24.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d               {I@2}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r94.0<1>:d    r23.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r118.0<1;0>:ud    r111.0<1;0>:ud    r78.1<0>:ud      {I@3} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r93.0<1>:d    r23.0<1;1,0>:d    9:w              
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@4}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        bfn.0xEA (16|M0)         r93.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r78.1<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        add (1|M0)               r78.5<1>:q    r78.4<0;1,0>:q    3:w              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        cmp (1|M0)    (eq)f3.1   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d  
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        mov (8|M0)               r119.0<1>:d   r68.8<1;1,0>:d                  
        bfn.0xEA (16|M0)         r99.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r23.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        and (16|M0)              r118.0<1>:d   r24.0<1;1,0>:d    -2147450880:d              
(W)     mov (1|M0)               r111.0<1>:ud  r78.1<0;1,0>:ud                 
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r119.8<1>:f   r66.8<1;1,0>:f                  
        mov (8|M0)               r120.0<1>:d   r64.8<1;1,0>:d                  
        mov (8|M0)               r120.8<1>:f   r62.8<1;1,0>:f                  
        mov (8|M0)               r121.0<1>:d   r60.8<1;1,0>:d                  
        mov (8|M0)               r121.8<1>:f   r58.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r100.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        mov (8|M0)               r118.0<1>:d   r72.8<1;1,0>:d                  
        mov (8|M0)               r118.8<1>:f   r70.8<1;1,0>:f                   {I@2}
        and (16|M0)              r73.8<1>:w    r83.48<1;1,0>:ub  127:w              
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r118:f        null:f            r93:hf            r118.0:hf        {$3}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r78.10<0;1,0>:ud  r4.10<0;1,0>:ud 
        mov (16|M0)              r93.0<1>:d    r73.16<2;1,0>:ub                 {@2,$3.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r78.11<0;1,0>:d   r4.11<0;1,0>:d  
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r118.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r89.0<1>:f    r89.0<1;0>:f      acc0.0<1;0>:f     r119.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r84.0<1>:f    r84.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
(W&~f3.1) jmpi                               L14992                                
L14656:
        shl (1|M0)               r118.0<1>:q   r78.5<0;1,0>:q    9:w               {Compacted,F@7}
        shl (1|M0)               r78.6<1>:q    r78.5<0;1,0>:q    6:w              
        shl (1|M0)               r78.5<1>:q    r78.5<0;1,0>:q    7:w              
        add (1|M0)               r118.0<1>:q   r4.2<0;1,0>:q     r118.0<0;1,0>:q  {Compacted,I@3}
        add (1|M0)               r57.0<1>:q    r73.1<0;1,0>:q    r78.5<0;1,0>:q   {I@2}
        send.ugm (1|M0)          r25      r118  null:0  0x0            0x024AF580           {I@2,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r71      r57  null:0  0x0            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r57.0<1>:q    r73.7<0;1,0>:q    r78.5<0;1,0>:q   {$9.src}
        add (1|M0)               r58.0<1>:q    r4.3<0;1,0>:q     r78.6<0;1,0>:q  
        send.ugm (1|M0)          r63      r57  null:0  0x0            0x0220E580           {I@2,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r57.0<1>:q    r78.1<0;1,0>:q    r78.5<0;1,0>:q   {Compacted,$8.src}
        add (1|M0)               r125.0<1>:q   r4.7<0;1,0>:q     r78.5<0;1,0>:q   {Compacted,F@1}
        send.ugm (1|M0)          r61      r57  null:0  0x0            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r124.0<1>:q   r4.6<0;1,0>:q     r78.5<0;1,0>:q   {Compacted}
        add (1|M0)               r123.0<1>:q   r73.6<0;1,0>:q    r78.5<0;1,0>:q   {Compacted}
        add (1|M0)               r93.0<1>:q    r78.3<0;1,0>:q    r78.5<0;1,0>:q   {Compacted}
        add (1|M0)               r118.0<1>:q   r118.0<0;1,0>:q   256:w               {Compacted,$13.src}
        add (1|M0)               r57.0<1>:q    r78.2<0;1,0>:q    r78.5<0;1,0>:q   {$6.src}
        send.ugm (1|M0)          r83      r58  null:0  0x0            0x0210D580           {$12} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r69      r125  null:0  0x0            0x0220E580           {I@6,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r67      r124  null:0  0x0            0x0220E580           {I@5,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r65      r123  null:0  0x0            0x0220E580           {I@4,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r21      r118  null:0  0x0            0x024AF580           {I@2,$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r59      r57  null:0  0x0            0x0220E580           {I@1,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r57      r93  null:0  0x0            0x0220E580           {$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L14992:
        add (1|M0)               r78.4<1>:q    r78.4<0;1,0>:q    2:w              
        cmp (1|M0)    (eq)f3.0   null<1>:d     r78.9<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r78.8<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r78.9<0;1,0>:d    r4.11<0;1,0>:d  
(W&f3.0) jmpi                                L6640                                
L15072:
        mul (1|M0)               acc0.0<1>:d   r79.0<0;1,0>:d    r4.4<0;1,0>:uw  
        mach (1|M0)              r38.0<1>:d    r79.0<0;1,0>:d    r4.2<0;1,0>:d    {$0.dst}
        sync.allrd                           ($7,$9,$11)                
        mul (16|M0)              r122.0<1>:f   r78.0<0;1,0>:f    r88.0<1;1,0>:f   {$4.src}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r92.0<0;1,0>:d    r4.4<0;1,0>:uw  
        mov (1|M0)               r126.3<1>:d   r38.0<0;1,0>:d                   {I@3}
        mach (1|M0)              r38.0<1>:d    r92.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r126.2<1>:d   r37.0<0;1,0>:d                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r101.0<0;1,0>:d   r4.4<0;1,0>:uw  
        mov (1|M0)               r101.3<1>:d   r38.0<0;1,0>:d                   {I@4}
        mach (1|M0)              r38.0<1>:d    r101.0<0;1,0>:d   r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r101.2<1>:d   r37.0<0;1,0>:d                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r73.3<1>:d    r38.0<0;1,0>:d                   {I@3}
        mov (1|M0)               r73.2<1>:d    r37.0<0;1,0>:d                   {I@2}
        shl (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   2:w              
        shl (1|M0)               r101.1<1>:q   r101.1<0;1,0>:q   2:w              
        shl (1|M0)               r73.1<1>:q    r73.1<0;1,0>:q    2:w               {I@3}
        mul (1|M0)               acc0.0<1>:d   r102.0<0;1,0>:d   r4.4<0;1,0>:uw  
        sync.nop                             null                             {Compacted,$10.dst}
        sync.nop                             null                             {Compacted,$15.src}
        mul (16|M0)              r109.0<1>:f   r78.0<0;1,0>:f    r89.0<1;1,0>:f   {Compacted,$3.dst}
        sync.nop                             null                             {Compacted,$14.src}
        mul (16|M0)              r120.0<1>:f   r78.0<0;1,0>:f    r86.0<1;1,0>:f   {Compacted,$3.src}
        sync.nop                             null                             {Compacted,$15.dst}
        sync.allrd                           ($6,$13)                
        add (1|M0)               r103.0<1>:q   r4.4<0;1,0>:q     r126.1<0;1,0>:q  {Compacted,@4,$4.dst}
        add (1|M0)               r121.0<1>:q   r4.4<0;1,0>:q     r101.1<0;1,0>:q  {Compacted,@4,$0.src}
        add (1|M0)               r37.0<1>:q    r4.4<0;1,0>:q     r73.1<0;1,0>:q   {Compacted,I@4}
        mach (1|M0)              r38.0<1>:d    r102.0<0;1,0>:d   r4.2<0;1,0>:d    {Compacted}
        send.ugm (1|M0)          null     r103  r122:1  0x0            0x0200D584           {A@3,$7} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r121  r109:1  0x0            0x0200D584           {A@2,$14} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r37  r120:1  0x0            0x0200D584           {A@1,$9} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                  {$9.src}
        mul (1|M0)               acc0.0<1>:d   r126.0<0;1,0>:d   r4.4<0;1,0>:uw  
        mov (1|M0)               r126.3<1>:d   r38.0<0;1,0>:d                   {I@3}
        mach (1|M0)              r38.0<1>:d    r126.0<0;1,0>:d   r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r126.2<1>:d   r37.0<0;1,0>:d                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r127.3<1>:d   r38.0<0;1,0>:d                   {I@3}
        mov (1|M0)               r127.2<1>:d   r37.0<0;1,0>:d                   {Compacted,I@2}
        shl (1|M0)               r126.1<1>:q   r126.1<0;1,0>:q   2:w              
        shl (1|M0)               r127.1<1>:q   r127.1<0;1,0>:q   2:w               {I@2}
        mul (16|M0)              r39.0<1>:f    r78.0<0;1,0>:f    r87.0<1;1,0>:f   {Compacted}
        mul (16|M0)              r118.0<1>:f   r78.0<0;1,0>:f    r84.0<1;1,0>:f   {Compacted,$4.src}
        add (1|M0)               r119.0<1>:q   r4.4<0;1,0>:q     r126.1<0;1,0>:q  {Compacted,I@2}
        add (1|M0)               r79.0<1>:q    r4.4<0;1,0>:q     r127.1<0;1,0>:q  {I@2}
        send.ugm (1|M0)          null     r119  r39:1  0x0            0x0200D584           {A@2,$13} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r79  r118:1  0x0            0x0200D584           {A@1,$1} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&f2.0) jmpi                                L37872                                
L15744:
        mul (1|M0)               acc0.0<1>:d   r127.0<0;1,0>:d   r4.4<0;1,0>:uw  
        mach (1|M0)              r38.0<1>:d    r127.0<0;1,0>:d   r4.2<0;1,0>:d    {Compacted}
        mul (16|M0)              r79.0<1>:f    r78.0<0;1,0>:f    r85.0<1;1,0>:f   {Compacted,$1.src}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r103.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@2,$7.src}
        mov (1|M0)               r103.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@2}
        shl (1|M0)               r103.0<1>:q   r103.0<0;1,0>:q   2:w               {Compacted,A@1}
        sync.allrd                           ($3,$8)                
        add (1|M0)               r117.0<1>:q   r4.4<0;1,0>:q     r103.0<0;1,0>:q  {Compacted,@1,$7.dst}
        send.ugm (1|M0)          null     r117  r79:1  0x0            0x0200D584           {I@1,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f1.1) jmpi                               L37872                                
L15872:
(W)     send.ugm (1|M0)          r37      r73  null:0  0x80400000:a0.1        0x4210D500           {$5} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        mul (16|M0)              r116.0<1>:f   r78.0<0;1,0>:f    r75.0<1;1,0>:f   {Compacted,$9.src}
        mul (1|M0)               acc0.0<1>:d   r37.0<0;1,0>:d    r4.4<0;1,0>:uw   {$5.dst}
        mach (1|M0)              r38.0<1>:d    r37.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        sync.nop                             null                             {Compacted,$3.src}
        mov (1|M0)               r110.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@2,$0.src}
        mov (1|M0)               r110.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@2}
        shl (1|M0)               r110.0<1>:q   r110.0<0;1,0>:q   2:w               {Compacted,A@1}
        add (1|M0)               r117.0<1>:q   r4.4<0;1,0>:q     r110.0<0;1,0>:q  {@1,$2.src}
        send.ugm (1|M0)          null     r117  r116:1  0x0            0x0200D584           {I@1,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f2.1) jmpi                               L37872                                
L16016:
        sync.nop                             null                             {Compacted,$3.src}
        mov (16|M0)              r94.0<1>:f    r76.0<1;1,0>:f                   {Compacted,$12.src}
(W)     jmpi                                 L37712                                
L16048:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r78.6<0;1,0>:d    4:w              
(W)     mov (1|M0)               r73.2<1>:hf   0x1:hf                             
        sync.allrd                           ($0,$2,$3,$7,$12)                
        mov (32|M0)              r93.0<1>:f    0.0:f                               {Compacted,$1.dst}
        sync.nop                             null                             {Compacted,F@2}
        sync.nop                             null                             {$13.src}
(f3.0)  sel (1|M0)               r103.0<1>:uw  r73.2<0;1,0>:uw   0x0:uw              {$6.src}
(f1.1)  sel (1|M0)               r79.2<1>:uw   r73.2<0;1,0>:uw   0x0:uw             
        mov (32|M0)              r75.0<1>:f    0.0:f                               {$6.dst}
        and (1|M0)    (ne)f2.0   null<1>:uw    r79.2<0;1,0>:uw   r103.0<0;1,0>:uw {I@1}
(f2.0)  sel (1|M0)               r104.0<1>:d   r102.0<0;1,0>:d   r79.0<0;1,0>:d  
        sync.nop                             null                             {Compacted,$3.dst}
        sync.allrd                           ($9,$10)                
        asr (1|M0)               r105.0<1>:d   r104.0<0;1,0>:d   31:w               {Compacted,@1,$13.dst}
        shr (1|M0)               r105.0<1>:ud  r105.0<0;1,0>:ud  0x1D:uw              {Compacted,I@1}
        add (1|M0)               r105.0<1>:d   r104.0<0;1,0>:d   r105.0<0;1,0>:d  {Compacted,I@1}
        asr (1|M0)               r105.0<1>:d   r105.0<0;1,0>:d   3:w               {I@1}
(~f0.0) mov (1|M0)               r104.0<1>:f   r105.0<0;1,0>:f                  {I@1}
        mul (1|M0)               acc0.0<1>:d   r104.0<0;1,0>:d   r3.24<0;1,0>:uw  {F@1}
        mach (1|M0)              r38.0<1>:d    r104.0<0;1,0>:d   r3.12<0;1,0>:d  
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r78.3<1>:d    r38.0<0;1,0>:d                   {I@2}
        mov (1|M0)               r78.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@2}
        shl (1|M0)               r78.1<1>:q    r78.1<0;1,0>:q    1:w               {I@1}
        add (1|M0)               r105.0<1>:q   r3.5<0;1,0>:q     r78.1<0;1,0>:q   {Compacted,I@1}
(W&~f0.1) jmpi                               L23664                                
L16400:
(W)     mov (1|M0)               r119.0<1>:uq  r4.2<0;1,0>:uq                   {Compacted,$13.src}
(W)     mov (1|M0)               r118.0<1>:uq  r3.2<0;1,0>:uq                   {Compacted}
        sync.allrd                           ($3,$8)                
(W)     mov (1|M0)               r117.0<1>:uq  r4.3<0;1,0>:uq                   {Compacted,$7.dst}
(W)     mov (1|M0)               r116.0<1>:uq  r73.1<0;1,0>:uq                  {Compacted,$9.src}
        sync.nop                             null                             {Compacted,$5.dst}
        sync.nop                             null                             {Compacted,$6.src}
(W)     mov (1|M0)               r115.0<1>:uq  r4.7<0;1,0>:uq                   {Compacted,$8.dst}
(W)     mov (1|M0)               r114.0<1>:uq  r4.6<0;1,0>:uq                   {Compacted,$4.src}
        send.ugm (1|M0)          r103     r105  null:0  0x0            0x0220E580           {I@7,$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r41      r119  null:0  0x0            0x024AF580           {I@6,$14} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r37      r118  null:0  0x0            0x024AF580           {I@5,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r106     r117  null:0  0x0            0x0210D580           {I@4,$8} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.nop                             null                             {$0.dst}
        send.ugm (1|M0)          r95      r116  null:0  0x0            0x0220E580           {I@3,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r97      r115  null:0  0x0            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.allwr                           ($3,$9,$14)                
        send.ugm (1|M0)          r99      r114  null:0  0x0            0x0220E580           {I@1,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W&f1.0) jmpi                                L16880                                
L16640:
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$12.src}
(W)     mov (1|M0)               r113.0<1>:uq  r3.1<0;1,0>:uq                   {Compacted,$9.dst}
(W)     mov (1|M0)               r112.0<1>:uq  r3.0<0;1,0>:uq                   {Compacted,$11.src}
(W)     mov (1|M0)               r111.0<1>:uq  r4.3<0;1,0>:uq                   {Compacted}
(W)     mov (1|M0)               r110.0<1>:uq  r73.1<0;1,0>:uq                  {Compacted,$0.src}
(W)     mov (1|M0)               r109.0<1>:uq  r4.7<0;1,0>:uq                   {Compacted,$15.src}
        sync.nop                             null                             {Compacted,$13.dst}
        sync.nop                             null                             {Compacted,$7.src}
(W)     mov (1|M0)               r108.0<1>:uq  r4.6<0;1,0>:uq                   {Compacted,$12.dst}
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r49      r105  null:0  0x80000            0x0220E580           {$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r33      r113  null:0  0x0            0x024AF580           {I@6,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r29      r112  null:0  0x0            0x024AF580           {I@5,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r82      r111  null:0  0x40000            0x0210D580           {I@4,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$3.dst}
        send.ugm (1|M0)          r55      r110  null:0  0x80000            0x0220E580           {I@3,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {$4.dst}
        send.ugm (1|M0)          r53      r109  null:0  0x80000            0x0220E580           {I@2,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r51      r108  null:0  0x80000            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L16880:
        mov (2|M0)               r73.8<1>:d    0x1:v                              
        mov (1|M0)               r73.2<1>:q    0:w                              
L16912:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r73.5<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r73.4<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r73.5<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f1.1) jmpi                               L20256                                
L16976:
        sync.nop                             null                             {$8.dst}
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x4:uw              {$14.dst}
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$14.src}
(W)     mov (1|M0)               r111.0<1>:f   0xE000E00:f                               {$15.src}
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$6.src}
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@2}
        sync.nop                             null                             {A@1}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r111.0<0>:ud     {$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$1.src}
        shl (16|M0)              r117.0<1>:d   r41.0<1;1,0>:d    12:w              
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$11.src}
        and (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r116.0<1>:d   r41.0<1;1,0>:d    9:w               {$9.src}
        and (16|M0)              r117.0<1>:d   r117.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r119.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x8:uw             
        sync.nop                             null                             {$11.src}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r117.0<1;0>:ud    r116.0<1;0>:ud    r111.0<0>:ud     {@3,$10.src} // s0|s1&s2
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r116.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r122.0<1>:d   r42.0<1;1,0>:d    12:w               {$9.src}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r117.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r115.0<1>:d   r42.0<1;1,0>:d    9:w               {$6.src}
        and (16|M0)              r122.0<1>:d   r122.0<1;1,0>:d   -2147450880:d               {I@4}
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$4.src}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r122.0<1;0>:ud    r115.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r115.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r114.0<1;1,0>:ud  0x80008000:ud              {I@3}
        and (16|M0)              r118.0<1>:d   r41.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r117.0<1>:d   r42.0<1;1,0>:d    -2147450880:d              
        sync.nop                             null                             {$2.dst}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r115.0<1;0>:ud    r111.0<0>:ud     {@4,$1.dst} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x3:uw             
        sync.allwr                           ($9,$13)                
        sync.nop                             null                             {Compacted,$7.src}
        mov (32|M0)              r107.0<1>:f   r95.0<1;1,0>:f                   {Compacted,$12.dst}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {Compacted,F@1}
        mov (8|M0)               r107.8<1>:d   r97.0<1;1,0>:d                   {$6.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r108.0<1>:f   r99.0<1;1,0>:f                   {$4.dst}
        sync.nop                             null                             {Compacted,$11.dst}
        mov (8|M0)               r108.8<1>:d   r103.0<1;1,0>:d                 
        bfn.0xEA (16|M0)         r91.0<1>:ud   r117.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        sync.nop                             null                             {Compacted,A@1}
        sync.allrd                           ($0,$5)                
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$2}
        and (16|M0)              r114.0<1>:w   r106.0<1;1,0>:ub  127:w              
        mov (16|M0)              r89.0<1>:d    r114.0<2;1,0>:ub                 {@1,$2.src}
        shl (16|M0)              r89.0<1>:d    r89.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r89.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$2.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r109.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r107.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r108.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r126.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r115.0<1>:d   r43.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r127.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x8:uw             
        sync.nop                             null                             {Compacted,$12.src}
        shl (16|M0)              r113.0<1>:d   r43.0<1;1,0>:d    9:w              
        and (16|M0)              r115.0<1>:d   r115.0<1;1,0>:d   -2147450880:d               {I@4}
        sync.nop                             null                             {$15.src}
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$6.src}
        shl (16|M0)              r125.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$10.src}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r115.0<1;0>:ud    r113.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              acc0.0<1>:ud  r124.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r113.0<1>:d   r44.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r116.0<1>:d   r43.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r112.0<1>:d   r44.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r115.0<1>:d   r44.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r125.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        and (16|M0)              r113.0<1>:d   r113.0<1;1,0>:d   -2147450880:d               {I@5}
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r116.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r107.0<1>:d   r95.8<1;1,0>:d                  
        mov (8|M0)               r107.8<1>:f   r97.8<1;1,0>:f                  
        mov (8|M0)               r108.0<1>:d   r99.8<1;1,0>:d                  
        mov (8|M0)               r108.8<1>:f   r103.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r88.0<1>:ud   r113.0<1;0>:ud    r112.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r115.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     // s0|s1&s2
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$3}
        and (16|M0)              r111.2<1>:w   r106.16<1;1,0>:ub  127:w             
        mov (16|M0)              r88.0<1>:d    r111.4<2;1,0>:ub                 {@1,$3.src}
        shl (16|M0)              r88.0<1>:d    r88.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r88.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f      {Compacted}
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {$10.dst}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw              {$1.dst}
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r121.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r122.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r119.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r120.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r114.0<1>:d   r37.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r115.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r108.0<1>:d   r37.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r114.0<1>:d   r114.0<1;1,0>:d   -2147450880:d               {I@5}
        shl (16|M0)              r123.0<1>:d   r38.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r115.0<1;1,0>:ud  0x80008000:ud              {I@5}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r114.0<1;0>:ud    r108.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        and (16|M0)              r114.0<1>:d   r37.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r113.0<1>:d   r38.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r107.0<1>:d   r38.0<1;1,0>:d    9:w              
        and (16|M0)              r123.0<1>:d   r123.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r116.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r114.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r108.0<1>:f   r100.0<1;1,0>:f                 
        mov (8|M0)               r108.8<1>:d   r104.0<1;1,0>:d                 
        bfn.0xEA (16|M0)         r88.0<1>:ud   r123.0<1;0>:ud    r107.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r113.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     // s0|s1&s2
        mov (8|M0)               r107.0<1>:f   r96.0<1;1,0>:f                   {I@2}
        mov (8|M0)               r107.8<1>:d   r98.0<1;1,0>:d                  
        and (16|M0)              r78.2<1>:w    r106.32<1;1,0>:ub  127:w             
        sync.nop                             null                             {A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$1}
        mov (16|M0)              r87.0<1>:d    r78.4<2;1,0>:ub                  {@1,$1.src}
        shl (16|M0)              r87.0<1>:d    r87.0<1;1,0>:d    20:w               {Compacted,I@1}
        shl (16|M0)              r113.0<1>:d   r39.0<1;1,0>:d    12:w               {Compacted}
        mul (16|M0)              acc0.0<1>:f   r87.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$1.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r127.0<1>:d   r39.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r113.0<1>:d   r113.0<1;1,0>:d   -2147450880:d               {I@3}
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r113.0<1;0>:ud    r127.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r112.0<1;1,0>:ud  0x80008000:ud              {I@3}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r113.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r109.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:d   r40.0<1;1,0>:d    12:w              
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r107.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r126.0<1>:d   r40.0<1;1,0>:d    9:w              
        and (16|M0)              r114.0<1>:d   r114.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r108.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r88.0<1>:ud   r114.0<1;0>:ud    r126.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r126.0<1;1,0>:ud  0x80008000:ud              {I@2}
        add (1|M0)               r73.3<1>:q    r73.2<0;1,0>:q    2:w              
        and (16|M0)              r112.0<1>:d   r39.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r110.0<1>:d   r40.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r127.0<1;0>:ud    r111.0<0>:ud     {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x3:uw             
        cmp (1|M0)    (eq)f3.1   null<1>:d     r73.7<0;1,0>:d    r4.11<0;1,0>:d   {I@5}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r112.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r107.0<1>:d   r96.8<1;1,0>:d                  
        mov (8|M0)               r107.8<1>:f   r98.8<1;1,0>:f                  
        mov (8|M0)               r108.0<1>:d   r100.8<1;1,0>:d                 
        mov (8|M0)               r108.8<1>:f   r104.8<1;1,0>:f                 
        bfn.0xEA (16|M0)         r91.0<1>:ud   r110.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        sync.nop                             null                             {A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$4}
        and (16|M0)              r125.0<1>:w   r106.48<1;1,0>:ub  127:w             
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r73.6<0;1,0>:ud   r4.10<0;1,0>:ud 
        mov (16|M0)              r91.0<1>:d    r125.0<2;1,0>:ub                 {@2,$4.src}
        shl (16|M0)              r91.0<1>:d    r91.0<1;1,0>:d    20:w               {Compacted,I@1}
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r73.7<0;1,0>:d    r4.11<0;1,0>:d  
        mul (16|M0)              acc0.0<1>:f   r91.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$4.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f      {Compacted}
(W&~f3.1) jmpi                               L20256                                
L20048:
        shl (1|M0)               r84.0<1>:q    r73.3<0;1,0>:q    9:w               {Compacted}
        shl (1|M0)               r124.0<1>:q   r73.3<0;1,0>:q    6:w               {Compacted}
        add (1|M0)               r84.0<1>:q    r4.2<0;1,0>:q     r84.0<0;1,0>:q   {I@2}
        shl (1|M0)               r73.3<1>:q    r73.3<0;1,0>:q    7:w              
        send.ugm (1|M0)          r41      r84  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r123.0<1>:q   r4.3<0;1,0>:q     r124.0<0;1,0>:q  {Compacted}
        add (1|M0)               r84.0<1>:q    r84.0<0;1,0>:q    256:w               {Compacted,$8.src}
        add (1|M0)               r122.0<1>:q   r73.1<0;1,0>:q    r73.3<0;1,0>:q   {Compacted,I@3}
        add (1|M0)               r121.0<1>:q   r4.7<0;1,0>:q     r73.3<0;1,0>:q   {Compacted}
        add (1|M0)               r120.0<1>:q   r4.6<0;1,0>:q     r73.3<0;1,0>:q   {Compacted}
        add (1|M0)               r119.0<1>:q   r105.0<0;1,0>:q   r73.3<0;1,0>:q   {Compacted}
        send.ugm (1|M0)          r106     r123  null:0  0x0            0x0210D580           {I@6,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r37      r84  null:0  0x0            0x024AF580           {I@5,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r95      r122  null:0  0x0            0x0220E580           {I@4,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r97      r121  null:0  0x0            0x0220E580           {I@3,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r99      r120  null:0  0x0            0x0220E580           {I@2,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r103     r119  null:0  0x0            0x0220E580           {I@1,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L20256:
        or (2|M0)                r111.0<1>:d   r73.4<1;1,0>:d    r73.8<1;1,0>:d   {$15.src}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r111.1<0;1,0>:d   r4.11<0;1,0>:d   {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r111.0<0;1,0>:ud  r4.10<0;1,0>:ud 
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r111.1<0;1,0>:d   r4.11<0;1,0>:d  
(W&~f3.0) jmpi                               L23584                                
L20336:
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$2.dst}
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x4:uw              {$12.dst}
        sync.allrd                           ($9,$11,$13)                
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$15.src}
(W)     mov (1|M0)               r111.0<1>:f   0xE000E00:f                               {I@5}
        sync.nop                             null                             {$5.src}
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$6.src}
        and (16|M0)              acc0.0<1>:ud  r123.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r124.0<1;0>:ud    r111.0<0>:ud     {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$6.src}
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r121.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r122.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$14.src}
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$14.src}
        and (16|M0)              acc0.0<1>:ud  r119.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r125.0<1>:d   r34.0<1;1,0>:d    12:w               {Compacted,$10.src}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r120.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r118.0<1>:d   r34.0<1;1,0>:d    9:w               {Compacted,$1.src}
        and (16|M0)              r125.0<1>:d   r125.0<1;1,0>:d   -2147450880:d               {I@4}
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$8.src}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r125.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,$14.dst}
        shl (16|M0)              r112.0<1>:d   r33.0<1;1,0>:d    12:w               {Compacted,$9.dst}
        and (16|M0)              r109.0<1>:d   r33.0<1;1,0>:d    -2147450880:d              
        sync.nop                             null                             {Compacted,$13.dst}
        sync.nop                             null                             {Compacted,$7.src}
        and (16|M0)              r108.0<1>:d   r34.0<1;1,0>:d    -2147450880:d               {$12.dst}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r111.0<0>:ud     {@5,$1.dst} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x3:uw             
        shl (16|M0)              r110.0<1>:d   r33.0<1;1,0>:d    9:w               {$0.src}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@6}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r109.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r91.0<1>:ud   r108.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        sync.nop                             null                             {Compacted,I@1}
        sync.nop                             null                             {Compacted,$3.dst}
        mov (32|M0)              r107.0<1>:f   r55.0<1;1,0>:f                   {Compacted,$0.dst}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r112.0<1;0>:ud    r110.0<1;0>:ud    r111.0<0>:ud     {$10.src} // s0|s1&s2
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {$4.dst}
        mov (8|M0)               r107.8<1>:d   r53.0<1;1,0>:d                   {$5.dst}
        mov (8|M0)               r108.0<1>:f   r51.0<1;1,0>:f                   {$7.dst}
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r108.8<1>:d   r49.0<1;1,0>:d                   {$10.dst}
        and (16|M0)              r117.0<1>:w   r82.0<1;1,0>:ub   127:w               {$15.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$7}
        mov (16|M0)              r86.0<1>:d    r117.0<2;1,0>:ub                 {@1,$7.src}
        shl (16|M0)              r86.0<1>:d    r86.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r86.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$7.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f     
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r113.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r114.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r110.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r109.0<1>:d   r35.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r112.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r116.0<1>:d   r35.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r109.0<1>:d   r109.0<1;1,0>:d   -2147450880:d               {I@4}
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r109.0<1;0>:ud    r116.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@3}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r127.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r116.0<1>:d   r36.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              r107.0<1>:d   r35.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r115.0<1>:d   r36.0<1;1,0>:d    9:w               {Compacted,$6.src}
        and (16|M0)              r127.0<1>:d   r36.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r116.0<1>:d   r116.0<1;1,0>:d   -2147450880:d               {I@5}
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r107.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r108.0<1>:d   r51.8<1;1,0>:d                  
        mov (8|M0)               r108.8<1>:f   r49.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r88.0<1>:ud   r116.0<1;0>:ud    r115.0<1;0>:ud    r111.0<0>:ud     {I@5} // s0|s1&s2
        mov (8|M0)               r107.0<1>:d   r55.8<1;1,0>:d                  
        mov (8|M0)               r107.8<1>:f   r53.8<1;1,0>:f                   {I@5}
        bfn.0xEA (16|M0)         r91.0<1>:ud   r127.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     // s0|s1&s2
        sync.nop                             null                             {A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$5}
        and (16|M0)              r114.0<1>:w   r82.16<1;1,0>:ub  127:w              
        mov (16|M0)              r85.0<1>:d    r114.0<2;1,0>:ub                 {@1,$5.src}
        shl (16|M0)              r85.0<1>:d    r85.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r85.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$5.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f      {Compacted}
        sync.nop                             null                             {F@1}
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x4:uw              {$11.dst}
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r125.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r124.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r125.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r123.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r126.0<1>:d   r30.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r112.0<1>:d   r30.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r126.0<1>:d   r126.0<1;1,0>:d   -2147450880:d               {I@5}
        shl (16|M0)              r108.0<1>:d   r29.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x80008000:ud              {I@5}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r126.0<1;0>:ud    r112.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        and (16|M0)              r126.0<1>:d   r29.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r113.0<1>:d   r29.0<1;1,0>:d    9:w              
        and (16|M0)              r125.0<1>:d   r30.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r108.0<1>:d   r108.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r119.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r126.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r107.0<1>:f   r56.0<1;1,0>:f                  
        mov (8|M0)               r107.8<1>:d   r54.0<1;1,0>:d                  
        bfn.0xEA (16|M0)         r84.0<1>:ud   r108.0<1;0>:ud    r113.0<1;0>:ud    r111.0<0>:ud     {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r125.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     // s0|s1&s2
        mov (8|M0)               r108.0<1>:f   r52.0<1;1,0>:f                   {I@2}
        mov (8|M0)               r108.8<1>:d   r50.0<1;1,0>:d                  
        and (16|M0)              r111.2<1>:w   r82.32<1;1,0>:ub  127:w              
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$13}
        mov (16|M0)              r84.0<1>:d    r111.4<2;1,0>:ub                 {@1,$13.src}
        shl (16|M0)              r84.0<1>:d    r84.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r84.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$13.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f     
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r115.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r115.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r116.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r113.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r114.0<1;0>:ud    r111.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r107.0<1>:d   r31.0<1;1,0>:d    12:w              
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r110.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r108.0<1>:d   r31.0<1;1,0>:d    9:w              
        and (16|M0)              r107.0<1>:d   r107.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r112.0<1;0>:ud    r111.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r107.0<1;0>:ud    r108.0<1;0>:ud    r111.0<0>:ud     {I@3} // s0|s1&s2
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r117.0<1>:d   r32.0<1;1,0>:d    12:w              
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@3}
        add (1|M0)               r127.1<1>:q   r73.2<0;1,0>:q    3:w              
        and (16|M0)              r124.0<1>:d   r31.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r123.0<1>:d   r32.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r107.0<1>:d   r32.0<1;1,0>:d    9:w              
        and (16|M0)              r117.0<1>:d   r117.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x3:uw             
        cmp (1|M0)    (eq)f2.1   null<1>:d     r127.3<0;1,0>:d   r4.11<0;1,0>:d   {I@7}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r124.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r108.0<1>:d   r52.8<1;1,0>:d                  
        mov (8|M0)               r108.8<1>:f   r50.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r88.0<1>:ud   r117.0<1;0>:ud    r107.0<1;0>:ud    r111.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r123.0<1;0>:ud    acc0.0<1;0>:ud    r111.0<0>:ud     // s0|s1&s2
        mov (8|M0)               r107.0<1>:d   r56.8<1;1,0>:d                  
        mov (8|M0)               r107.8<1>:f   r54.8<1;1,0>:f                   {I@3}
        and (16|M0)              r78.2<1>:w    r82.48<1;1,0>:ub  127:w              
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x4 (16|M0)         r107:f        null:f            r84:hf            r107.0:hf        {$7}
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r127.2<0;1,0>:ud  r4.10<0;1,0>:ud 
        mov (16|M0)              r90.0<1>:d    r78.4<2;1,0>:ub                  {@2,$7.src}
        shl (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    20:w               {Compacted,I@1}
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r127.3<0;1,0>:d   r4.11<0;1,0>:d  
        mul (16|M0)              acc0.0<1>:f   r90.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r107.0<1>:f      {Compacted,$7.dst}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r108.0<1>:f      {Compacted}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r109.0<1>:f      {Compacted}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r110.0<1>:f     
(W&~f2.1) jmpi                               L23584                                
L23376:
        shl (1|M0)               r127.0<1>:q   r127.1<0;1,0>:q   9:w               {Compacted}
        shl (1|M0)               r73.3<1>:q    r127.1<0;1,0>:q   6:w              
        add (1|M0)               r127.0<1>:q   r4.2<0;1,0>:q     r127.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r127.1<1>:q   r127.1<0;1,0>:q   7:w              
        send.ugm (1|M0)          r33      r127  null:0  0x0            0x024AF580           {I@1,$2} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   256:w               {Compacted,$2.src}
        add (1|M0)               r51.0<1>:q    r4.3<0;1,0>:q     r73.3<0;1,0>:q   {Compacted}
        send.ugm (1|M0)          r29      r127  null:0  0x0            0x024AF580           {I@2,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r50.0<1>:q    r73.1<0;1,0>:q    r127.1<0;1,0>:q  {Compacted}
        add (1|M0)               r49.0<1>:q    r4.7<0;1,0>:q     r127.1<0;1,0>:q  {Compacted}
        add (1|M0)               r126.0<1>:q   r105.0<0;1,0>:q   r127.1<0;1,0>:q  {Compacted}
        add (1|M0)               r127.0<1>:q   r4.6<0;1,0>:q     r127.1<0;1,0>:q  {Compacted,$1.src}
        send.ugm (1|M0)          r82      r51  null:0  0x0            0x0210D580           {I@5,$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r55      r50  null:0  0x0            0x0220E580           {I@4,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r53      r49  null:0  0x0            0x0220E580           {I@3,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r51      r127  null:0  0x0            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r49      r126  null:0  0x0            0x0220E580           {$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L23584:
        add (1|M0)               r73.2<1>:q    r73.2<0;1,0>:q    2:w              
        cmp (1|M0)    (eq)f1.1   null<1>:d     r73.5<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r73.4<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r73.5<0;1,0>:d    r4.11<0;1,0>:d  
(W&f1.1) jmpi                                L16912                                
L23664:
        mul (1|M0)               acc0.0<1>:d   r79.0<0;1,0>:d    r4.4<0;1,0>:uw   {F@1}
        sync.nop                             null                             {Compacted,$10.dst}
        mach (1|M0)              r38.0<1>:d    r79.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted,$1.dst}
        mul (16|M0)              r125.0<1>:f   r78.0<0;1,0>:f    r93.0<1;1,0>:f   {$11.src}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r92.0<0;1,0>:d    r4.4<0;1,0>:uw  
        mov (1|M0)               r73.3<1>:d    r38.0<0;1,0>:d                   {I@3}
        mach (1|M0)              r38.0<1>:d    r92.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r73.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r101.0<0;1,0>:d   r4.4<0;1,0>:uw  
        mov (1|M0)               r78.3<1>:d    r38.0<0;1,0>:d                   {I@4}
        mach (1|M0)              r38.0<1>:d    r101.0<0;1,0>:d   r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r78.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mov (1|M0)               r102.3<1>:d   r38.0<0;1,0>:d                   {I@3}
        mov (1|M0)               r102.2<1>:d   r37.0<0;1,0>:d                   {Compacted,I@2}
        shl (1|M0)               r73.1<1>:q    r73.1<0;1,0>:q    2:w              
        shl (1|M0)               r78.1<1>:q    r78.1<0;1,0>:q    2:w              
        shl (1|M0)               r102.1<1>:q   r102.1<0;1,0>:q   2:w               {I@3}
        sync.nop                             null                             {Compacted,$11.src}
        mul (16|M0)              r39.0<1>:f    r78.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted,$13.src}
        sync.allrd                           ($9,$13)                
        mul (16|M0)              r123.0<1>:f   r78.0<0;1,0>:f    r75.0<1;1,0>:f   {Compacted,$15.src}
        sync.nop                             null                             {Compacted,$11.dst}
        add (1|M0)               r103.0<1>:q   r4.4<0;1,0>:q     r73.1<0;1,0>:q   {Compacted,@3,$13.dst}
        sync.nop                             null                             {Compacted,$5.src}
        add (1|M0)               r124.0<1>:q   r4.4<0;1,0>:q     r78.1<0;1,0>:q   {Compacted,@3,$6.src}
        add (1|M0)               r109.0<1>:q   r4.4<0;1,0>:q     r102.1<0;1,0>:q  {@3}
        send.ugm (1|M0)          null     r103  r125:1  0x0            0x0200D584           {A@3,$6} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r124  r39:1  0x0            0x0200D584           {A@2,$11} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r109  r123:1  0x0            0x0200D584           {A@1,$15} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f2.0) jmpi                               L37872                                
L24080:
        mov (1|M0)               r79.0<1>:d    r102.0<0;1,0>:d                  {Compacted}
        mov (16|M0)              r94.0<1>:f    r76.0<1;1,0>:f                   {Compacted}
(W)     send.ugm (1|M0)          null     r73  r79:1  0x80000000:a0.1        0x4200D504           {I@1,$13} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
(W)     jmpi                                 L37712                                
L24128:
        asr (1|M0)               r119.0<1>:d   r79.0<0;1,0>:d    31:w               {Compacted,$13.src}
        sync.nop                             null                             {Compacted,$5.dst}
        sync.nop                             null                             {Compacted,$6.src}
        asr (1|M0)               r115.0<1>:d   r92.0<0;1,0>:d    31:w               {Compacted,$8.dst}
        shr (1|M0)               r119.0<1>:ud  r119.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        shr (1|M0)               r115.0<1>:ud  r115.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        add (1|M0)               r119.0<1>:d   r79.0<0;1,0>:d    r119.0<0;1,0>:d  {Compacted,I@2}
        add (1|M0)               r115.0<1>:d   r92.0<0;1,0>:d    r115.0<0;1,0>:d  {Compacted,I@2}
        asr (1|M0)               r119.0<1>:d   r119.0<0;1,0>:d   3:w               {Compacted,I@2}
(f0.0)  mov (1|M0)               r119.0<1>:f   r79.0<0;1,0>:f                   {I@1}
        asr (1|M0)               r115.0<1>:d   r115.0<0;1,0>:d   3:w               {Compacted}
        mul (1|M0)               acc0.0<1>:d   r119.0<0;1,0>:d   r3.24<0;1,0>:uw  {F@1}
(f0.0)  mov (1|M0)               r115.0<1>:f   r92.0<0;1,0>:f                   {I@2}
        mach (1|M0)              r38.0<1>:d    r119.0<0;1,0>:d   r3.12<0;1,0>:d   {$12.dst}
        sync.allrd                           ($4,$9)                
        mov (32|M0)              r75.0<1>:f    0.0:f                               {$6.dst}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r115.0<0;1,0>:d   r3.24<0;1,0>:uw  {F@2}
        sync.nop                             null                             {Compacted,$13.dst}
        sync.allrd                           ($0,$1,$7)                
        mov (1|M0)               r108.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@3,$12.dst}
        mach (1|M0)              r38.0<1>:d    r115.0<0;1,0>:d   r3.12<0;1,0>:d  
        mov (1|M0)               r108.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@4}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                  {F@1}
        mov (1|M0)               r78.3<1>:d    r38.0<0;1,0>:d                   {I@2}
        mov (1|M0)               r78.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@2}
        shl (1|M0)               r108.0<1>:q   r108.0<0;1,0>:q   1:w              
        shl (1|M0)               r78.1<1>:q    r78.1<0;1,0>:q    1:w               {I@2}
        sync.nop                             null                             {Compacted,$2.src}
        add (1|M0)               r97.0<1>:q    r3.5<0;1,0>:q     r108.0<0;1,0>:q  {Compacted,@2,$10.src}
        add (1|M0)               r98.0<1>:q    r3.5<0;1,0>:q     r78.1<0;1,0>:q   {Compacted,@2,$8.src}
(W&~f0.1) jmpi                               L31056                                
L24504:
(W)     mov (1|M0)               r107.0<1>:uq  r4.2<0;1,0>:uq                   {Compacted}
        sync.allwr                           ($3,$8)                
(W)     mov (1|M0)               r106.0<1>:uq  r3.2<0;1,0>:uq                   {Compacted,$13.dst}
        sync.nop                             null                             {Compacted,$9.src}
(W)     mov (1|M0)               r105.0<1>:uq  r4.3<0;1,0>:uq                   {Compacted,$10.src}
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r93      r97  null:0  0x0            0x0220E580           {I@6,$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.allwr                           ($0,$9)                
        sync.nop                             null                             {Compacted,$13.src}
        send.ugm (1|M0)          r95      r98  null:0  0x0            0x0220E580           {I@5,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$14.src}
        send.ugm (1|M0)          r41      r107  null:0  0x0            0x024AF580           {I@3,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r37      r106  null:0  0x0            0x024AF580           {I@2,$14} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.allwr                           ($4,$14)                
        send.ugm (1|M0)          r99      r105  null:0  0x0            0x0210D580           {I@1,$9} // wr:1+0, rd:1; load.ugm.d32x16t.a64
(W&f1.0) jmpi                                L24848                                
L24704:
(W)     mov (1|M0)               r104.0<1>:uq  r3.1<0;1,0>:uq                   {Compacted,$7.src}
        sync.allrd                           ($6,$13)                
(W)     mov (1|M0)               r103.0<1>:uq  r3.0<0;1,0>:uq                   {Compacted,$7.src}
(W)     mov (1|M0)               r102.0<1>:uq  r4.3<0;1,0>:uq                   {Compacted}
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r47      r97  null:0  0x80000            0x0220E580           {$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$11.dst}
        send.ugm (1|M0)          r45      r98  null:0  0x80000            0x0220E580           {$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$5.dst}
        send.ugm (1|M0)          r17      r104  null:0  0x0            0x024AF580           {I@3,$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r13      r103  null:0  0x0            0x024AF580           {I@2,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r81      r102  null:0  0x40000            0x0210D580           {I@1,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
L24848:
        mov (2|M0)               r73.4<1>:d    0x1:v                              
        mov (1|M0)               r4.6<1>:q     0:w                              
L24880:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r4.12<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f1.1) jmpi                               L27904                                
L24944:
        sync.nop                             null                             {$12.dst}
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x4:uw              {$1.dst}
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$0.src}
        shl (16|M0)              r107.0<1>:d   r41.0<1;1,0>:d    12:w               {Compacted}
(W)     mov (1|M0)               r100.0<1>:f   0xE000E00:f                              
        sync.nop                             null                             {Compacted,$4.src}
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$15.src}
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r106.0<1>:d   r41.0<1;1,0>:d    9:w               {$14.src}
        and (16|M0)              r107.0<1>:d   r107.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r100.0<0>:ud     {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r107.0<1;0>:ud    r106.0<1;0>:ud    r100.0<0>:ud     {@3,$11.src} // s0|s1&s2
        shl (16|M0)              r106.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r106.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r104.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$7.src}
        shl (16|M0)              r105.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$9.src}
        and (16|M0)              acc0.0<1>:ud  r104.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r105.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$15.src}
        sync.nop                             null                             {Compacted,$3.src}
        shl (16|M0)              r110.0<1>:d   r42.0<1;1,0>:d    12:w               {Compacted,$0.src}
        sync.allrd                           ($6,$13)                
        shl (16|M0)              r103.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$7.src}
        and (16|M0)              acc0.0<1>:ud  r102.0<1;1,0>:ud  0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,$14.dst}
        and (16|M0)              r113.0<1>:d   r41.0<1;1,0>:d    -2147450880:d               {$9.dst}
        shl (16|M0)              r122.0<1>:d   r42.0<1;1,0>:d    9:w               {Compacted,$11.src}
        and (16|M0)              r112.0<1>:d   r42.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@6}
        sync.nop                             null                             {$2.dst}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r103.0<1;0>:ud    r100.0<0>:ud     {@6,$1.dst} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r113.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r42.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {$4.dst}
        mov (8|M0)               r111.0<1>:f   r93.0<1;1,0>:f                  
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r111.8<1>:d   r95.0<1;1,0>:d                   {$8.dst}
        and (16|M0)              r121.0<1>:w   r99.0<1;1,0>:ub   127:w               {$3.dst}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r110.0<1;0>:ud    r122.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r112.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r111.0:hf        {$3}
        mov (16|M0)              r86.0<1>:d    r121.0<2;1,0>:ub                 {$3.src}
        shl (16|M0)              r86.0<1>:d    r86.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r86.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r126.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r127.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x4:uw             
        sync.nop                             null                             {Compacted,$15.src}
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$5.src}
        sync.nop                             null                             {Compacted,$10.src}
        shl (16|M0)              r125.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$11.src}
        and (16|M0)              acc0.0<1>:ud  r124.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r125.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r105.0<1>:d   r43.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$9.src}
        and (16|M0)              acc0.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r120.0<1>:d   r43.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r105.0<1>:d   r105.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r123.0<1;0>:ud    r100.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r105.0<1;0>:ud    r120.0<1;0>:ud    r100.0<0>:ud     {I@3} // s0|s1&s2
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r101.0<1>:d   r44.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@3}
        and (16|M0)              r110.0<1>:d   r43.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r119.0<1>:d   r44.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r109.0<1>:d   r44.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@6}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r43.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r110.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r44.0<1;1,0>:ud   0x3:uw             
        and (16|M0)              r118.0<1>:w   r99.16<1;1,0>:ub  127:w              
        mov (8|M0)               r108.0<1>:d   r93.8<1;1,0>:d                  
        mov (8|M0)               r108.8<1>:f   r95.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r88.0<1>:ud   r101.0<1;0>:ud    r119.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r109.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r108.0:hf        {$11}
        mov (16|M0)              r85.0<1>:d    r118.0<2;1,0>:ub                 {$11.src}
        sync.nop                             null                             {Compacted,$6.dst}
        shl (16|M0)              r104.0<1>:d   r37.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r85.0<1>:d    r85.0<1;1,0>:d    20:w               {Compacted,I@2}
        sync.nop                             null                             {Compacted,$3.src}
        shl (16|M0)              r117.0<1>:d   r37.0<1;1,0>:d    9:w               {Compacted,$7.dst}
        and (16|M0)              r104.0<1>:d   r104.0<1;1,0>:d   -2147450880:d               {I@3}
        mul (16|M0)              acc0.0<1>:f   r85.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@3}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$11.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw              {F@1}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r104.0<1;0>:ud    r117.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r119.0<1>:d   r38.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r100.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r116.0<1>:d   r38.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r119.0<1>:d   r119.0<1;1,0>:d   -2147450880:d               {I@4}
        shl (16|M0)              r115.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        bfn.0xEA (16|M0)         r88.0<1>:ud   r119.0<1;0>:ud    r116.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r115.0<1;1,0>:ud  0x80008000:ud              {I@3}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r116.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r113.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r114.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r107.0<1>:d   r37.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r106.0<1>:d   r38.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r112.0<1;0>:ud    r100.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r107.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r105.0<1>:f   r94.0<1;1,0>:f                  
        mov (8|M0)               r105.8<1>:d   r96.0<1;1,0>:d                  
        and (16|M0)              r115.0<1>:w   r99.32<1;1,0>:ub  127:w              
        bfn.0xEA (16|M0)         r91.0<1>:ud   r106.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r105.0:hf        {$2}
        mov (16|M0)              r84.0<1>:d    r115.0<2;1,0>:ub                 {$2.src}
        shl (16|M0)              r84.0<1>:d    r84.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r84.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$2.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f     
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r106.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r106.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r104.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r105.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r104.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r103.0<1>:d   r39.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r105.0<1;0>:ud    r100.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x8:uw             
        add (1|M0)               r124.0<1>:q   r4.6<0;1,0>:q     2:w               {Compacted}
        shl (16|M0)              r114.0<1>:d   r39.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r103.0<1>:d   r103.0<1;1,0>:d   -2147450880:d               {I@5}
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:d   r40.0<1;1,0>:d    12:w              
        cmp (1|M0)    (eq)f3.1   null<1>:d     r124.1<0;1,0>:d   r4.11<0;1,0>:d   {I@5}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r103.0<1;0>:ud    r114.0<1;0>:ud    r100.0<0>:ud     {I@4} // s0|s1&s2
        shl (16|M0)              r103.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r102.0<1;1,0>:ud  0x80008000:ud              {I@5}
        and (16|M0)              r104.0<1>:d   r39.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r113.0<1>:d   r40.0<1;1,0>:d    9:w              
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r103.0<1;0>:ud    r100.0<0>:ud     {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x3:uw             
        and (16|M0)              r103.0<1>:d   r40.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r87.0<1>:ud   r104.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r117.0<1>:d   r94.8<1;1,0>:d                  
        mov (8|M0)               r117.8<1>:f   r96.8<1;1,0>:f                  
        and (16|M0)              r112.0<1>:w   r99.48<1;1,0>:ub  127:w              
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r124.0<0;1,0>:ud  r4.10<0;1,0>:ud 
        bfn.0xEA (16|M0)         r88.0<1>:ud   r110.0<1;0>:ud    r113.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r103.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        mov (16|M0)              r102.0<1>:d   r112.0<2;1,0>:ub                 {I@4}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r100:f        null:f            r84:hf            r117.0:hf        {$8}
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r124.1<0;1,0>:d   r4.11<0;1,0>:d  
        shl (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   20:w               {Compacted,I@2}
        mul (16|M0)              acc0.0<1>:f   r102.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r100.0<1>:f      {Compacted,$8.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted}
(W&~f3.1) jmpi                               L27904                                
L27752:
        shl (1|M0)               r127.0<1>:q   r124.0<0;1,0>:q   9:w               {Compacted}
        shl (1|M0)               r111.0<1>:q   r124.0<0;1,0>:q   6:w               {Compacted}
        add (1|M0)               r127.0<1>:q   r4.2<0;1,0>:q     r127.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r124.0<1>:q   r124.0<0;1,0>:q   7:w               {Compacted}
        send.ugm (1|M0)          r41      r127  null:0  0x0            0x024AF580           {I@2,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r110.0<1>:q   r4.3<0;1,0>:q     r111.0<0;1,0>:q  {Compacted}
        add (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   256:w               {Compacted,$12.src}
        add (1|M0)               r109.0<1>:q   r97.0<0;1,0>:q    r124.0<0;1,0>:q  {Compacted,I@3}
        add (1|M0)               r108.0<1>:q   r98.0<0;1,0>:q    r124.0<0;1,0>:q 
        send.ugm (1|M0)          r99      r110  null:0  0x0            0x0210D580           {I@4,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r37      r127  null:0  0x0            0x024AF580           {I@3,$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r93      r109  null:0  0x0            0x0220E580           {I@2,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r95      r108  null:0  0x0            0x0220E580           {I@1,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L27904:
        or (2|M0)                r92.1<1>:d    r4.12<1;1,0>:d    r73.4<1;1,0>:d  
        cmp (1|M0)    (eq)f3.0   null<1>:d     r92.2<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r92.1<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r92.2<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f3.0) jmpi                               L30976                                
L27984:
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$5.dst}
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x4:uw              {$7.dst}
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$13.src}
(W)     mov (1|M0)               r100.0<1>:f   0xE000E00:f                              
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$6.src}
        and (16|M0)              acc0.0<1>:ud  r126.0<1;1,0>:ud  0x80008000:ud              {I@2}
        sync.nop                             null                             {A@1}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r127.0<1;0>:ud    r100.0<0>:ud     {$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x4:uw             
        sync.allrd                           ($11,$15)                
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$6.src}
        sync.nop                             null                             {$6.src}
        shl (16|M0)              r125.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc0.0<1>:ud  r124.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r125.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$7.src}
        shl (16|M0)              r101.0<1>:d   r17.0<1;1,0>:d    12:w              
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$9.src}
        and (16|M0)              acc0.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,$2.dst}
        shl (16|M0)              r91.0<1>:d    r17.0<1;1,0>:d    9:w               {Compacted,$1.dst}
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r123.0<1;0>:ud    r100.0<0>:ud     {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r101.0<1;0>:ud    r91.0<1;0>:ud     r100.0<0>:ud     {I@3} // s0|s1&s2
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r101.0<1>:d   r18.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r107.0<1>:d   r18.0<1;1,0>:d    9:w               {Compacted,$1.src}
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud             
        and (16|M0)              r102.0<1>:d   r17.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r88.0<1>:ud   r101.0<1;0>:ud    r107.0<1;0>:ud    r100.0<0>:ud     {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        and (16|M0)              r101.0<1>:d   r18.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r102.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {Compacted,$14.src}
        and (16|M0)              r106.0<1>:w   r81.0<1;1,0>:ub   127:w               {$15.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        mov (8|M0)               r127.0<1>:f   r47.0<1;1,0>:f                   {$10.dst}
        sync.nop                             null                             {Compacted,$11.dst}
        mov (8|M0)               r127.8<1>:d   r45.0<1;1,0>:d                  
        bfn.0xEA (16|M0)         r91.0<1>:ud   r101.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r127.0:hf        {$14}
        mov (16|M0)              r127.0<1>:d   r106.0<2;1,0>:ub                 {$14.src}
        shl (16|M0)              r127.0<1>:d   r127.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r127.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$14.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f      {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x4:uw              {F@1}
        sync.nop                             null                             {$3.src}
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$7.dst}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r117.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r118.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r115.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r115.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r116.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x8:uw             
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$12.src}
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r113.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r114.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r90.0<1>:d    r19.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r105.0<1>:d   r19.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r119.0<1>:d   r20.0<1;1,0>:d    12:w              
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    -2147450880:d               {I@5}
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@5}
        and (16|M0)              r126.0<1>:d   r19.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r104.0<1>:d   r20.0<1;1,0>:d    9:w              
        and (16|M0)              r125.0<1>:d   r20.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r119.0<1>:d   r119.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r90.0<1;0>:ud     r105.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r112.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r126.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x3:uw             
        and (16|M0)              r103.0<1>:w   r81.16<1;1,0>:ub  127:w               {$13.src}
        mov (8|M0)               r124.0<1>:d   r47.8<1;1,0>:d                  
        mov (8|M0)               r124.8<1>:f   r45.8<1;1,0>:f                  
        bfn.0xEA (16|M0)         r88.0<1>:ud   r119.0<1;0>:ud    r104.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r125.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        mov (16|M0)              r126.0<1>:d   r103.0<2;1,0>:ub                 {I@4}
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r124.0:hf        {$2}
        shl (16|M0)              r126.0<1>:d   r126.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r126.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$2.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f      {Compacted}
        sync.nop                             null                             {F@1}
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x4:uw              {$13.dst}
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$0.src}
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$4.src}
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r89.0<1>:d    r13.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r106.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:d   r13.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r89.0<1>:d    r89.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              acc0.0<1>:ud  r106.0<1;1,0>:ud  0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r89.0<1;0>:ud     r102.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r104.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r105.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r104.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r105.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:d   r14.0<1;1,0>:d    12:w               {$0.src}
        shl (16|M0)              r103.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r102.0<1;1,0>:ud  0x80008000:ud              {I@3}
        and (16|M0)              r123.0<1>:d   r13.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r122.0<1>:d   r14.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r101.0<1>:d   r14.0<1;1,0>:d    9:w              
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@6}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r103.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r123.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x3:uw             
        and (16|M0)              r92.2<1>:w    r81.32<1;1,0>:ub  127:w              
        mov (8|M0)               r121.0<1>:f   r48.0<1;1,0>:f                  
        mov (8|M0)               r121.8<1>:d   r46.0<1;1,0>:d                  
        bfn.0xEA (16|M0)         r88.0<1>:ud   r110.0<1;0>:ud    r101.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r122.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        mov (16|M0)              r125.0<1>:d   r92.4<2;1,0>:ub                  {I@4}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r101:f        null:f            r84:hf            r121.0:hf        {$3}
        shl (16|M0)              r125.0<1>:d   r125.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r125.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r102.0<1>:f     
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x4:uw              {F@1}
        shl (16|M0)              r125.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r125.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r126.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r124.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r123.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r124.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r121.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r122.0<1;0>:ud    r100.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        add (1|M0)               r123.1<1>:q   r4.6<0;1,0>:q     3:w              
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r119.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r88.0<1>:d    r15.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r101.0<1>:d   r16.0<1;1,0>:d    12:w               {Compacted}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r123.3<0;1,0>:d   r4.11<0;1,0>:d   {I@5}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r120.0<1;0>:ud    r100.0<0>:ud     {I@5} // s0|s1&s2
        and (16|M0)              r120.0<1>:d   r15.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r127.0<1>:d   r16.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r84.0<1>:d    r15.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r119.0<1>:d   r16.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r88.0<1>:d    r88.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@7}
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r120.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x3:uw             
        mov (8|M0)               r116.0<1>:d   r48.8<1;1,0>:d                  
        mov (8|M0)               r116.8<1>:f   r46.8<1;1,0>:f                  
        and (16|M0)              r126.0<1>:w   r81.48<1;1,0>:ub  127:w              
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r123.2<0;1,0>:ud  r4.10<0;1,0>:ud 
        bfn.0xEA (16|M0)         r84.0<1>:ud   r88.0<1;0>:ud     r84.0<1;0>:ud     r100.0<0>:ud     {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r119.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<0>:ud     // s0|s1&s2
        bfn.0xEA (16|M0)         r88.0<1>:ud   r101.0<1;0>:ud    r127.0<1;0>:ud    r100.0<0>:ud     {I@7} // s0|s1&s2
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r100:f        null:f            r84:hf            r116.0:hf        {$0}
        mov (16|M0)              r87.0<1>:d    r126.0<2;1,0>:ub                 {$0.src}
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r123.3<0;1,0>:d   r4.11<0;1,0>:d  
        shl (16|M0)              r87.0<1>:d    r87.0<1;1,0>:d    20:w               {Compacted,I@2}
        mul (16|M0)              acc0.0<1>:f   r87.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r75.0<1>:f    r75.0<1;0>:f      acc0.0<1;0>:f     r100.0<1>:f      {Compacted,$0.dst}
        mad (16|M0)              r76.0<1>:f    r76.0<1;0>:f      acc0.0<1;0>:f     r101.0<1>:f      {Compacted}
(W&~f2.1) jmpi                               L30976                                
L30816:
        shl (1|M0)               r126.0<1>:q   r123.1<0;1,0>:q   9:w               {Compacted}
        shl (1|M0)               r125.0<1>:q   r123.1<0;1,0>:q   6:w               {Compacted}
        add (1|M0)               r126.0<1>:q   r4.2<0;1,0>:q     r126.0<0;1,0>:q  {I@2}
        shl (1|M0)               r123.1<1>:q   r123.1<0;1,0>:q   7:w              
        send.ugm (1|M0)          r17      r126  null:0  0x0            0x024AF580           {I@2,$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r124.0<1>:q   r4.3<0;1,0>:q     r125.0<0;1,0>:q  {Compacted}
        add (1|M0)               r126.0<1>:q   r126.0<0;1,0>:q   256:w               {Compacted,$5.src}
        add (1|M0)               r123.0<1>:q   r97.0<0;1,0>:q    r123.1<0;1,0>:q  {Compacted,I@3}
        add (1|M0)               r122.0<1>:q   r98.0<0;1,0>:q    r123.1<0;1,0>:q  {Compacted}
        send.ugm (1|M0)          r81      r124  null:0  0x0            0x0210D580           {I@4,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r13      r126  null:0  0x0            0x024AF580           {I@3,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r47      r123  null:0  0x0            0x0220E580           {I@2,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r45      r122  null:0  0x0            0x0220E580           {I@1,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L30976:
        add (1|M0)               r4.6<1>:q     r4.6<0;1,0>:q     2:w              
        cmp (1|M0)    (eq)f2.0   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r4.12<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d  
(W&f2.0) jmpi                                L24880                                
L31056:
        mul (1|M0)               acc0.0<1>:d   r79.0<0;1,0>:d    r4.4<0;1,0>:uw   {F@1}
        sync.nop                             null                             {Compacted,$6.dst}
        mach (1|M0)              r38.0<1>:d    r79.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted,$14.dst}
        mul (16|M0)              r121.0<1>:f   r78.0<0;1,0>:f    r75.0<1;1,0>:f  
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        sync.allrd                           ($9,$13,$14)                
        mov (1|M0)               r73.3<1>:d    r38.0<0;1,0>:d                   {@2,$0.src}
        mov (1|M0)               r73.2<1>:d    r37.0<0;1,0>:d                   {Compacted,I@2}
        sync.nop                             null                             {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$3.src}
        mov (16|M0)              r94.0<1>:f    r76.0<1;1,0>:f                   {Compacted,$2.dst}
        shl (1|M0)               r73.1<1>:q    r73.1<0;1,0>:q    2:w               {I@1}
        mov (1|M0)               r76.0<1>:f    r92.0<0;1,0>:f                   {Compacted}
        add (1|M0)               r107.0<1>:q   r4.4<0;1,0>:q     r73.1<0;1,0>:q   {Compacted,@1,$1.src}
(W)     send.ugm (1|M0)          null     r73  r76:1  0x80000000:a0.1        0x4200D504           {F@1,$4} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
        send.ugm (1|M0)          null     r107  r121:1  0x0            0x0200D584           {I@1,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     jmpi                                 L37712                                
L31264:
        asr (1|M0)               r118.0<1>:d   r79.0<0;1,0>:d    31:w               {Compacted,$7.dst}
        sync.allrd                           ($3,$12)                
        mov (16|M0)              r94.0<1>:f    0.0:f                               {Compacted,$9.src}
        shr (1|M0)               r118.0<1>:ud  r118.0<0;1,0>:ud  0x1D:uw              {Compacted,I@1}
        add (1|M0)               r118.0<1>:d   r79.0<0;1,0>:d    r118.0<0;1,0>:d  {Compacted,I@1}
        asr (1|M0)               r118.0<1>:d   r118.0<0;1,0>:d   3:w               {Compacted,I@1}
(f0.0)  mov (1|M0)               r118.0<1>:f   r79.0<0;1,0>:f                   {I@1}
        mul (1|M0)               acc0.0<1>:d   r118.0<0;1,0>:d   r3.24<0;1,0>:uw  {F@1}
        sync.nop                             null                             {Compacted,$5.dst}
        mach (1|M0)              r38.0<1>:d    r118.0<0;1,0>:d   r3.12<0;1,0>:d   {$12.dst}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        sync.allwr                           ($3,$8)                
        mov (1|M0)               r106.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@2,$13.dst}
        mov (1|M0)               r106.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@2}
        shl (1|M0)               r106.0<1>:q   r106.0<0;1,0>:q   1:w               {Compacted,A@1}
        add (1|M0)               r92.0<1>:q    r3.5<0;1,0>:q     r106.0<0;1,0>:q  {Compacted,I@1}
(W&~f0.1) jmpi                               L37568                                
L31456:
(W)     mov (1|M0)               r101.0<1>:uq  r4.2<0;1,0>:uq                   {Compacted,$12.dst}
        sync.nop                             null                             {Compacted,$14.dst}
(W)     mov (1|M0)               r100.0<1>:uq  r3.2<0;1,0>:uq                   {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$3.dst}
        sync.nop                             null                             {Compacted,$1.src}
(W)     mov (1|M0)               r99.0<1>:uq   r4.3<0;1,0>:uq                   {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$9.src}
        send.ugm (1|M0)          r75      r92  null:0  0x0            0x0220E580           {I@5,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r37      r101  null:0  0x0            0x024AF580           {I@3,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$0.src}
        send.ugm (1|M0)          r41      r100  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r93      r99  null:0  0x0            0x0210D580           {I@1,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a64
(W&f1.0) jmpi                                L31776                                
L31600:
        sync.allrd                           ($5,$7,$8)                
(W)     mov (1|M0)               r98.0<1>:uq   r3.1<0;1,0>:uq                   {Compacted,$6.dst}
        sync.allrd                           ($2,$10)                
(W)     mov (1|M0)               r97.0<1>:uq   r3.0<0;1,0>:uq                   {Compacted,$1.src}
        sync.allwr                           ($0,$8)                
        sync.nop                             null                             {Compacted,$14.src}
(W)     mov (1|M0)               r96.0<1>:uq   r4.3<0;1,0>:uq                   {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$11.dst}
        send.ugm (1|M0)          r1       r92  null:0  0x80000            0x0220E580           {$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r9       r98  null:0  0x0            0x024AF580           {I@3,$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r5       r97  null:0  0x0            0x024AF580           {I@2,$2} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$15.dst}
        send.ugm (1|M0)          r80      r96  null:0  0x40000            0x0210D580           {I@1,$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
L31776:
        mov (2|M0)               r73.4<1>:d    0x1:v                               {$13.src}
        mov (1|M0)               r4.6<1>:q     0:w                              
L31808:
        cmp (1|M0)    (eq)f3.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r4.12<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f3.1) jmpi                               L34656                                
L31872:
        sync.nop                             null                             {$5.dst}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw              {$12.dst}
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$0.src}
        sync.allwr                           ($0,$8)                
(W)     mov (1|M0)               r95.0<1>:f    0xE000E00:f                               {$9.dst}
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r110.0<1;1,0>:ud  0x80008000:ud              {I@2}
        sync.nop                             null                             {A@1}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r95.0<0>:ud      {$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        sync.nop                             null                             {$13.dst}
        sync.allrd                           ($1,$7)                
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$12.dst}
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r106.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$6.src}
        and (16|M0)              acc0.0<1>:ud  r106.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r104.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        and (16|M0)              r119.0<1>:w   r93.0<1;1,0>:ub   127:w               {$1.dst}
        shl (16|M0)              r105.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc0.0<1>:ud  r104.0<1;1,0>:ud  0x80008000:ud              {I@3}
        sync.nop                             null                             {$3.src}
        mov (16|M0)              r116.0<1>:d   r119.0<2;1,0>:ub                 {@3,$7.dst}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r105.0<1;0>:ud    r95.0<0>:ud      {@3,$2.dst} // s0|s1&s2
        and (16|M0)              r105.0<1>:d   r37.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r104.0<1>:d   r38.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r116.0<1>:d   r116.0<1;1,0>:d   20:w               {I@4}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        shl (16|M0)              r118.0<1>:d   r37.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$11.src}
        shl (16|M0)              r112.0<1>:d   r38.0<1;1,0>:d    12:w               {Compacted,$9.dst}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r105.0<1;0>:ud    acc0.0<1;0>:ud    r95.0<0>:ud      {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r91.0<1>:ud   r104.0<1;0>:ud    acc0.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r116.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        shr (16|M0)              acc2.0<1>:ud  r39.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r117.0<1>:d   r37.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r120.0<1>:d   r38.0<1;1,0>:d    9:w              
        and (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   -2147450880:d              
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r102.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r103.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw              {$6.src}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r118.0<1;0>:ud    r117.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r88.0<1>:ud   r112.0<1;0>:ud    r120.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        and (16|M0)              acc2.0<1>:ud  r102.0<1;1,0>:ud  0x80008000:ud              {I@4}
        sync.nop                             null                             {I@2}
        dpas.8x1 (16|M0)         r96:f         null:f            r84:hf            r75.0:hf         {$6}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r103.0<1;0>:ud    r95.0<0>:ud      {$6.src} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r40.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r101.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r101.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r39.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r98.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r99.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r98.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r99.0<1;0>:ud     r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r40.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r127.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:d   r39.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r104.0<1>:d   r40.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {$2.src}
        shl (16|M0)              r97.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc2.0<1>:ud  r127.0<1;1,0>:ud  0x80008000:ud              {I@4}
        and (16|M0)              r103.0<1>:d   r39.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r116.0<1>:w   r93.16<1;1,0>:ub  127:w               {F@1}
        shl (16|M0)              r118.0<1>:d   r39.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r117.0<1>:d   r40.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r102.0<1>:d   r40.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@7}
        and (16|M0)              r104.0<1>:d   r104.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r97.0<1;0>:ud     r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r39.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r103.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r40.0<1;1,0>:ud   0x3:uw             
        mov (16|M0)              r109.0<1>:d   r116.0<2;1,0>:ub                 {I@7}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r110.0<1;0>:ud    r118.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r88.0<1>:ud   r104.0<1;0>:ud    r117.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r102.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      // s0|s1&s2
        shl (16|M0)              r109.0<1>:d   r109.0<1;1,0>:d   20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r115:f        null:f            r84:hf            r75.16:hf        {$0}
        mul (16|M0)              acc1.0<1>:f   r109.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              acc0.0<1>:f   r94.0<1;0>:f      acc0.0<1;0>:f     r96.0<1>:f       {Compacted,$6.dst}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r115.0<1>:f      {$0.dst}
        shr (16|M0)              acc2.0<1>:ud  r41.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r101.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r101.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r102.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r42.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r99.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r100.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r99.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r100.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r41.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r98.0<1;0>:ud     r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r42.0<1;1,0>:ud   0x8:uw             
        and (16|M0)              r113.0<1>:w   r93.32<1;1,0>:ub  127:w               {$12.src}
        shl (16|M0)              r94.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw              {F@2}
        shl (16|M0)              r96.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        mov (16|M0)              r123.0<1>:d   r113.0<2;1,0>:ub                 {@3,$15.src}
        and (16|M0)              acc2.0<1>:ud  r94.0<1;1,0>:ud   0x80008000:ud              {I@3}
        and (16|M0)              r109.0<1>:d   r41.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r108.0<1>:d   r42.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r123.0<1>:d   r123.0<1;1,0>:d   20:w               {Compacted,I@4}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r96.0<1;0>:ud     r95.0<0>:ud      // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r41.0<1;1,0>:ud   0x3:uw             
        shl (16|M0)              r124.0<1>:d   r41.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r103.0<1>:d   r42.0<1;1,0>:d    12:w              
        bfn.0xEA (16|M0)         r87.0<1>:ud   r109.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r42.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r91.0<1>:ud   r108.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r123.0<1;1,0>:f   1.329228e+36:f               {I@7}
        shr (16|M0)              acc2.0<1>:ud  r43.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r114.0<1>:d   r42.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r115.0<1>:d   r41.0<1;1,0>:d    9:w               {Compacted,F@2}
        and (16|M0)              r124.0<1>:d   r124.0<1;1,0>:d   -2147450880:d               {I@7}
        and (16|M0)              r103.0<1>:d   r103.0<1;1,0>:d   -2147450880:d               {I@7}
        shl (16|M0)              r99.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r100.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r124.0<1;0>:ud    r115.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r88.0<1>:ud   r103.0<1;0>:ud    r114.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        and (16|M0)              acc2.0<1>:ud  r99.0<1;1,0>:ud   0x80008000:ud              {I@4}
        sync.nop                             null                             {I@2}
        dpas.8x1 (16|M0)         r96:f         null:f            r84:hf            r76.0:hf         {$15}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r100.0<1;0>:ud    r95.0<0>:ud      {$15.src} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r97.0<1>:ud   acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r98.0<1;0>:ud     r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r43.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r127.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r94.0<1>:ud   acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r127.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r94.0<1;0>:ud     r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x8:uw             
        add (1|M0)               r108.1<1>:q   r4.6<0;1,0>:q     2:w              
        shl (16|M0)              r125.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw              {$10.src}
        shl (16|M0)              r101.0<1>:d   r44.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r115.0<1>:d   r43.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r126.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        cmp (1|M0)    (eq)f2.1   null<1>:d     r108.3<0;1,0>:d   r4.11<0;1,0>:d   {I@5}
        and (16|M0)              acc2.0<1>:ud  r125.0<1;1,0>:ud  0x80008000:ud              {I@5}
        and (16|M0)              r127.0<1>:d   r43.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r111.0<1>:d   r44.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r112.0<1>:d   r43.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r110.0<1>:w   r93.48<1;1,0>:ub  127:w              
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@7}
        and (16|M0)              r115.0<1>:d   r115.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r126.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r43.0<1;1,0>:ud   0x3:uw             
        and (16|M0)              r126.0<1>:d   r44.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r87.0<1>:ud   r127.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r44.0<1;1,0>:ud   0x3:uw             
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r108.2<0;1,0>:ud  r4.10<0;1,0>:ud 
        mov (16|M0)              r122.0<1>:d   r110.0<2;1,0>:ub                 {I@7}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r101.0<1;0>:ud    r111.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r84.0<1>:ud   r115.0<1;0>:ud    r112.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r126.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shl (16|M0)              r122.0<1>:d   r122.0<1;1,0>:d   20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r94:f         null:f            r84:hf            r76.16:hf        {$9}
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r108.3<0;1,0>:d   r4.11<0;1,0>:d  
        mul (16|M0)              acc2.0<1>:f   r122.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r96.0<1>:f       {Compacted,$15.dst}
        mad (16|M0)              r94.0<1>:f    acc0.0<1;0>:f     acc2.0<1;0>:f     r94.0<1>:f       {Compacted,$9.dst}
(W&~f2.1) jmpi                               L34656                                
L34520:
        shl (1|M0)               r108.0<1>:q   r108.1<0;1,0>:q   9:w               {Compacted}
        shl (1|M0)               r109.0<1>:q   r108.1<0;1,0>:q   6:w               {Compacted}
        add (1|M0)               r108.0<1>:q   r4.2<0;1,0>:q     r108.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r108.1<1>:q   r108.1<0;1,0>:q   7:w              
        send.ugm (1|M0)          r37      r108  null:0  0x0            0x024AF580           {I@1,$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r108.0<1>:q   r108.0<0;1,0>:q   256:w               {Compacted,$5.src}
        add (1|M0)               r107.0<1>:q   r92.0<0;1,0>:q    r108.1<0;1,0>:q  {Compacted}
        send.ugm (1|M0)          r41      r108  null:0  0x0            0x024AF580           {I@2,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r108.0<1>:q   r4.3<0;1,0>:q     r109.0<0;1,0>:q  {$13.src}
        send.ugm (1|M0)          r75      r107  null:0  0x0            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r93      r108  null:0  0x0            0x0210D580           {I@1,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a64
L34656:
        sync.allrd                           ($6,$10)                
        or (2|M0)                r125.0<1>:d   r4.12<1;1,0>:d    r73.4<1;1,0>:d   {$11.src}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r125.1<0;1,0>:d   r4.11<0;1,0>:d   {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r125.0<0;1,0>:ud  r4.10<0;1,0>:ud 
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r125.1<0;1,0>:d   r4.11<0;1,0>:d  
(W&~f2.0) jmpi                               L37488                                
L34752:
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$0.dst}
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x4:uw              {$7.dst}
        sync.allrd                           ($9,$11)                
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$7.src}
        sync.nop                             null                             {$8.dst}
(W)     mov (1|M0)               r95.0<1>:f    0xE000E00:f                               {$9.dst}
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$15.src}
        and (16|M0)              acc0.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc0.0<1;0>:ud    r123.0<1;0>:ud    r95.0<0>:ud      {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$13.src}
        and (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc0.0<1;0>:ud    r119.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x8:uw             
        sync.nop                             null                             {Compacted,$5.src}
        shl (16|M0)              r124.0<1>:d   r10.0<1;1,0>:d    12:w               {Compacted,$6.src}
        sync.nop                             null                             {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$10.src}
        and (16|M0)              r105.0<1>:w   r80.0<1;1,0>:ub   127:w               {$14.dst}
        sync.nop                             null                             {$3.src}
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$7.dst}
        shl (16|M0)              r106.0<1>:d   r10.0<1;1,0>:d    9:w              
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r124.0<1>:d   r124.0<1;1,0>:d   -2147450880:d               {I@5}
        mov (16|M0)              r112.0<1>:d   r105.0<2;1,0>:ub                 {@5,$9.dst}
        and (16|M0)              acc0.0<1>:ud  r116.0<1;1,0>:ud  0x80008000:ud              {I@5}
        and (16|M0)              r125.0<1>:d   r9.0<1;1,0>:d     -2147450880:d              
        bfn.0xEA (16|M0)         r88.0<1>:ud   r124.0<1;0>:ud    r106.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        shl (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,$2.dst}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r117.0<1;0>:ud    r95.0<0>:ud      {$1.dst} // s0|s1&s2
        and (16|M0)              r124.0<1>:d   r10.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x3:uw             
        sync.nop                             null                             {Compacted,$5.dst}
        shl (16|M0)              r114.0<1>:d   r9.0<1;1,0>:d     12:w               {Compacted}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r125.0<1;0>:ud    acc0.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r91.0<1>:ud   r124.0<1;0>:ud    acc0.0<1;0>:ud    r95.0<0>:ud      {I@5} // s0|s1&s2
        mul (16|M0)              acc0.0<1>:f   r112.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        shr (16|M0)              acc2.0<1>:ud  r11.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r113.0<1>:d   r9.0<1;1,0>:d     9:w               {Compacted,$12.src}
        and (16|M0)              r114.0<1>:d   r114.0<1;1,0>:d   -2147450880:d              
        shl (16|M0)              r124.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r125.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r114.0<1;0>:ud    r113.0<1;0>:ud    r95.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              acc2.0<1>:ud  r124.0<1;1,0>:ud  0x80008000:ud              {I@3}
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$10.dst}
        dpas.8x1 (16|M0)         r96:f         null:f            r84:hf            r1.0:hf          {$11}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r125.0<1;0>:ud    r95.0<0>:ud      {$11.src} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r12.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r122.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r123.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r123.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r11.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r120.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r121.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r121.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r12.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r118.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:d    r11.0<1;1,0>:d    12:w               {Compacted,$6.dst}
        shl (16|M0)              r126.0<1>:d   r12.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r119.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r118.0<1;1,0>:ud  0x80008000:ud              {I@4}
        and (16|M0)              r115.0<1>:d   r11.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r104.0<1>:d   r11.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r103.0<1>:d   r12.0<1;1,0>:d    9:w               {Compacted,$13.src}
        and (16|M0)              r102.0<1>:w   r80.16<1;1,0>:ub  127:w              
        and (16|M0)              r114.0<1>:d   r12.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r126.0<1>:d   r126.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r119.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r11.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r115.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r12.0<1;1,0>:ud   0x3:uw             
        mov (16|M0)              r97.0<1>:d    r102.0<2;1,0>:ub                 {@7}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r98.0<1;0>:ud     r104.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r88.0<1>:ud   r126.0<1;0>:ud    r103.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r114.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      // s0|s1&s2
        shl (16|M0)              r97.0<1>:d    r97.0<1;1,0>:d    20:w               {Compacted,I@4}
        sync.nop                             null                             {Compacted,I@2}
        dpas.8x1 (16|M0)         r114:f        null:f            r84:hf            r1.16:hf         {$4}
        shl (16|M0)              r121.0<1>:d   r5.0<1;1,0>:d     12:w               {Compacted}
        mul (16|M0)              acc1.0<1>:f   r97.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@2}
        mad (16|M0)              acc0.0<1>:f   r94.0<1;0>:f      acc0.0<1;0>:f     r96.0<1>:f       {Compacted,$11.dst}
        shl (16|M0)              r101.0<1>:d   r5.0<1;1,0>:d     9:w               {Compacted,$12.src}
        and (16|M0)              r121.0<1>:d   r121.0<1;1,0>:d   -2147450880:d               {I@2}
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r114.0<1>:f      {$4.dst}
        shr (16|M0)              acc2.0<1>:ud  r5.0<1;1,0>:ud    0x4:uw             
        bfn.0xEA (16|M0)         r84.0<1>:ud   r121.0<1;0>:ud    r101.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r121.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r122.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r121.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r122.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r6.0<1;1,0>:ud    0x4:uw             
        shl (16|M0)              r119.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r119.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r120.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r5.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r117.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r118.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r117.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r118.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r6.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r115.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        and (16|M0)              r99.0<1>:w    r80.32<1;1,0>:ub  127:w               {$1.src}
        shl (16|M0)              r123.0<1>:d   r6.0<1;1,0>:d     12:w               {Compacted}
        shl (16|M0)              r116.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r115.0<1;1,0>:ud  0x80008000:ud              {I@4}
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r107.0<1>:d   r5.0<1;1,0>:d     -2147450880:d               {$12.dst}
        mov (16|M0)              r120.0<1>:d   r99.0<2;1,0>:ub                  {I@5}
        shl (16|M0)              r100.0<1>:d   r6.0<1;1,0>:d     9:w               {Compacted}
        shl (16|M0)              r111.0<1>:d   r7.0<1;1,0>:d     12:w               {Compacted}
        and (16|M0)              r106.0<1>:d   r6.0<1;1,0>:d     -2147450880:d              
        and (16|M0)              r123.0<1>:d   r123.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r116.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r5.0<1;1,0>:ud    0x3:uw             
        shl (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   20:w               {I@7}
        bfn.0xEA (16|M0)         r87.0<1>:ud   r107.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r6.0<1;1,0>:ud    0x3:uw             
        shl (16|M0)              r98.0<1>:d    r7.0<1;1,0>:d     9:w              
        and (16|M0)              r111.0<1>:d   r111.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r123.0<1;0>:ud    r100.0<1;0>:ud    r95.0<0>:ud      {I@7} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   r106.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      // s0|s1&s2
        mul (16|M0)              acc1.0<1>:f   r120.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@7}
        shr (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x4:uw             
        sync.nop                             null                             {Compacted,A@2}
        dpas.8x1 (16|M0)         r96:f         null:f            r84:hf            r2.0:hf          {$12}
        bfn.0xEA (16|M0)         r84.0<1>:ud   r111.0<1;0>:ud    r98.0<1;0>:ud     r95.0<0>:ud      {$12.src} // s0|s1&s2
        shl (16|M0)              r111.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r112.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r85.0<1>:ud   acc2.0<1;0>:ud    r112.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x4:uw             
        shl (16|M0)              r109.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r109.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r89.0<1>:ud   acc2.0<1;0>:ud    r110.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r107.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r108.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc2.0<1>:ud  r107.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r86.0<1>:ud   acc2.0<1;0>:ud    r108.0<1;0>:ud    r95.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r113.0<1>:d   r8.0<1;1,0>:d     12:w               {Compacted}
        shl (16|M0)              r105.0<1>:ud  acc2.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r97.0<1>:d    r8.0<1;1,0>:d     9:w               {Compacted}
        shl (16|M0)              r106.0<1>:ud  acc2.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r113.0<1>:d   r113.0<1;1,0>:d   -2147450880:d               {I@4}
        and (16|M0)              acc2.0<1>:ud  r105.0<1;1,0>:ud  0x80008000:ud              {I@4}
        and (16|M0)              r114.0<1>:d   r7.0<1;1,0>:d     -2147450880:d               {F@2}
        bfn.0xEA (16|M0)         r88.0<1>:ud   r113.0<1;0>:ud    r97.0<1;0>:ud     r95.0<0>:ud      {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc2.0<1;0>:ud    r106.0<1;0>:ud    r95.0<0>:ud      // s0|s1&s2
        and (16|M0)              r113.0<1>:d   r8.0<1;1,0>:d     -2147450880:d              
        shr (16|M0)              acc2.0<1>:ud  r7.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r87.0<1>:ud   r114.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@5} // s0|s1&s2
        shr (16|M0)              acc2.0<1>:ud  r8.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r91.0<1>:ud   r113.0<1;0>:ud    acc2.0<1;0>:ud    r95.0<0>:ud      {I@4} // s0|s1&s2
        and (16|M0)              r95.0<1>:w    r80.48<1;1,0>:ub  127:w              
        mov (16|M0)              r119.0<1>:d   r95.0<2;1,0>:ub                  {I@1}
        add (1|M0)               r95.0<1>:q    r4.6<0;1,0>:q     3:w              
        dpas.8x1 (16|M0)         r94:f         null:f            r84:hf            r2.16:hf         {$8}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r95.1<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
        shl (16|M0)              r119.0<1>:d   r119.0<1;1,0>:d   20:w               {Compacted}
        mul (16|M0)              acc2.0<1>:f   r119.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r95.0<0;1,0>:ud   r4.10<0;1,0>:ud 
        mad (16|M0)              acc0.0<1>:f   acc0.0<1;0>:f     acc1.0<1;0>:f     r96.0<1>:f       {Compacted,$12.dst}
        mad (16|M0)              r94.0<1>:f    acc0.0<1;0>:f     acc2.0<1;0>:f     r94.0<1>:f       {Compacted,$8.dst}
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r95.1<0;1,0>:d    r4.11<0;1,0>:d  
(W&~f1.1) jmpi                               L37488                                
L37360:
        shl (1|M0)               r103.0<1>:q   r95.0<0;1,0>:q    9:w               {Compacted}
        shl (1|M0)               r92.1<1>:q    r95.0<0;1,0>:q    6:w               {Compacted,$6.src}
        add (1|M0)               r103.0<1>:q   r4.2<0;1,0>:q     r103.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r95.0<1>:q    r95.0<0;1,0>:q    7:w               {Compacted}
        send.ugm (1|M0)          r9       r103  null:0  0x0            0x024AF580           {I@2,$0} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r85.0<1>:q    r4.3<0;1,0>:q     r92.1<0;1,0>:q   {Compacted}
        add (1|M0)               r103.0<1>:q   r103.0<0;1,0>:q   256:w               {Compacted,$0.src}
        add (1|M0)               r84.0<1>:q    r92.0<0;1,0>:q    r95.0<0;1,0>:q   {I@3}
        send.ugm (1|M0)          r80      r85  null:0  0x0            0x0210D580           {I@3,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r5       r103  null:0  0x0            0x024AF580           {I@2,$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r1       r84  null:0  0x0            0x0220E580           {I@1,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L37488:
        add (1|M0)               r4.6<1>:q     r4.6<0;1,0>:q     2:w              
        cmp (1|M0)    (eq)f3.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d   {I@1}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r4.12<0;1,0>:ud   r4.10<0;1,0>:ud 
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r4.13<0;1,0>:d    r4.11<0;1,0>:d  
(W&f3.1) jmpi                                L31808                                
L37568:
        cmp (1|M0)    (eq)f3.1   null<1>:d     r78.6<0;1,0>:d    1:w              
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$12.src}
(W)     mov (1|M0)               r113.0<1>:hf  0x1:hf                              {$9.dst}
(f3.0)  sel (1|M0)               r102.0<1>:uw  r113.0<0;1,0>:uw  0x0:uw              {F@1}
(f3.1)  sel (1|M0)               r105.0<1>:uw  r113.0<0;1,0>:uw  0x0:uw              {$10.src}
        and (1|M0)    (ne)f3.1   null<1>:uw    r105.0<0;1,0>:uw  r102.0<0;1,0>:uw {I@1}
(W&~f3.1) jmpi                               L37872                                
L37680:
        sync.nop                             null                             {Compacted,$9.src}
        mov (1|M0)               r75.0<1>:f    r79.0<0;1,0>:f                   {Compacted,$6.dst}
(W)     send.ugm (1|M0)          null     r73  r75:1  0x80000000:a0.1        0x4200D504           {F@1,$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
L37712:
        sync.allwr                           ($1,$2,$8,$12,$14)                
(W)     send.ugm (1|M0)          r43      r73  null:0  0x80000000:a0.1        0x4210D500           {$13} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
        sync.nop                             null                             {Compacted,$5.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mul (16|M0)              r39.0<1>:f    r78.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted}
        mul (1|M0)               acc0.0<1>:d   r43.0<0;1,0>:d    r4.4<0;1,0>:uw   {$13.dst}
        mach (1|M0)              r38.0<1>:d    r43.0<0;1,0>:d    r4.2<0;1,0>:d    {Compacted}
        mov (1|M0)               r37.0<1>:d    acc0.0<0;1,0>:d                 
        sync.nop                             null                             {Compacted,$4.src}
        mov (1|M0)               r114.1<1>:d   r38.0<0;1,0>:d                   {Compacted,@2}
        mov (1|M0)               r114.0<1>:f   r37.0<0;1,0>:f                   {Compacted,I@2}
        shl (1|M0)               r114.0<1>:q   r114.0<0;1,0>:q   2:w               {Compacted,A@1}
        add (1|M0)               r79.0<1>:q    r4.4<0;1,0>:q     r114.0<0;1,0>:q  {@1,$13.src}
        send.ugm (1|M0)          null     r79  r39:1  0x0            0x0200D584           {I@1,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a64
L37872:
        add (1|M0)               r3.7<1>:q     r3.7<0;1,0>:q     8:w              
        sync.allrd                           ($3,$6)                
        mov (1|M0)               r121.0<1>:q   r77.1<0;1,0>:ud                  {$14.src}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r3.15<0;1,0>:d    r121.1<0;1,0>:d  {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r3.14<0;1,0>:ud   r121.0<0;1,0>:ud
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:ud    r3.15<0;1,0>:ud   r121.1<0;1,0>:ud
(W&f1.1) jmpi                                L1520                                
L37984:
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$11.src}
(W)     mov (16|M0)              r112.0<1>:f   r74.0<1;1,0>:f                   {$9.dst}
(W)     send.gtwy (1|M0)         null     r112  null:0  0x0            0x02000010           {EOT,F@1,$10} // wr:1+0, rd:0; end of thread
L38032:
        mov (2|M0)               r126.0<1>:d   0x1:v                              
        mov (1|M0)               r125.4<1>:d   63:w                              
        mov (1|M0)               r122.2<1>:q   0:w                              
        mov (1|M0)               r122.3<1>:q   0:w                              
L38096:
        mov (1|M0)               r101.2<1>:q   r125.4<0;1,0>:ud                 {I@3}
        shl (1|M0)               r122.2<1>:q   r122.2<0;1,0>:q   1:w               {I@3}
        shr (1|M0)               r5.0<1>:uq    r123.0<0;1,0>:uq  r101.2<0;1,0>:uq {I@2}
(W)     mov (1|M0)               r127.0<1>:hf  0x1:hf                             
        bfn.0xEA (2|M0)          r5.0<1>:ud    r122.4<1;0>:ud    r5.0<1;0>:ud      r126.0<1>:ud     {I@1} // s0|s1&s2
        cmp (1|M0)    (eq)f3.0   null<1>:d     r125.4<0;1,0>:d   0:w              
        cmp (1|M0)    (lt)f2.0   null<1>:ud    r5.0<0;1,0>:ud    r123.2<0;1,0>:ud {I@2}
        cmp (1|M0)    (lt)f2.1   null<1>:ud    r5.1<0;1,0>:ud    r123.3<0;1,0>:ud
        shl (1|M0)               r101.2<1>:uq  r127.0<0;1,0>:uw  r101.2<0;1,0>:uq {F@1}
        add (1|M0)               r6.2<1>:ud    r125.4<0;1,0>:ud  0xFFFFFFFF:ud             
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r5.1<0;1,0>:d     r123.3<0;1,0>:d 
(f2.1)  sel (1|M0)               r101.4<1>:uw  r127.0<0;1,0>:uw  0x0:uw             
        add (1|M0)               r122.2<1>:q   r5.0<0;1,0>:q     -r123.1<0;1,0>:q
        or (2|M0)                r101.4<1>:d   r101.4<1;1,0>:d   r122.6<1;1,0>:d  {I@5}
(f2.0)  sel (1|M0)               r4.6<1>:uw    r127.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r4.6<0;1,0>:uw    r101.4<0;1,0>:uw {I@1}
(f3.1)  mov (1|M0)               r122.4<1>:ud  r5.0<0;1,0>:d                   
(f3.1)  mov (1|M0)               r122.5<1>:ud  r5.1<0;1,0>:d                   
(f3.1)  mov (1|M0)               r101.4<1>:ud  r122.6<0;1,0>:d                 
(f3.1)  mov (1|M0)               r101.5<1>:ud  r122.7<0;1,0>:d                 
(W&f3.0) jmpi                                L38480                                
L38432:
        mov (1|M0)               r125.4<1>:d   r6.2<0;1,0>:d                   
        mov (1|M0)               r122.3<1>:q   r101.2<0;1,0>:q                  {I@3}
(W)     jmpi                                 L38096                                
L38480:
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
        ret (32|M0)                          r101.0                           {A@1}
L38528:
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
        illegal                
