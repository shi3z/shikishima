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
(W)     mov (16|M0)              r71.0<1>:ud   r0.0<1;1,0>:ud                  
(W)     and (1|M0)               r4.5<1>:ud    r71.5<0;1,0>:ud   0xFFFFFC00:ud              {@1,$2.dst}
(W)     mov (1|M0)               r69.0<1>:f    9.18355e-41:f                              
        mov (1|M0)               r6.0<1>:uq    r3.4<0;1,0>:uq                   {$1.dst}
(W)     shr (1|M0)               a0.1<1>:ud    r4.5<0;1,0>:ud    0x4:ud              {A@1}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
        mul (1|M0)               acc0.0<1>:ud  r2.3<0;1,0>:ud    r0.2<0;1,0>:uw   {A@1}
        mach (1|M0)              r114.0<1>:ud  r2.3<0;1,0>:ud    r0.1<0;1,0>:ud  
        cmp (1|M0)    (eq)f0.1   null<1>:d     r2.8<0;1,0>:d     1:w              
        mov (1|M0)               r113.0<1>:ud  acc0.0<0;1,0>:ud                 {Compacted}
        mov (1|M0)               r119.1<1>:d   r114.0<0;1,0>:d                  {Compacted,I@3}
        mov (1|M0)               r119.0<1>:f   r113.0<0;1,0>:f                  {I@2}
        and (1|M0)               r112.0<2>:b   r2.52<0;1,0>:b    1:w              
        and (1|M0)               r1.6<2>:b     r4.4<0;1,0>:b     1:w               {$0.dst}
        add (1|M0)               r119.0<1>:q   r119.0<0;1,0>:q   r1.0<0;1,0>:uw   {A@1}
(W&f0.1) jmpi                                L688                                
L432:
        mov (1|M0)               r124.1<1>:q   r2.8<0;1,0>:ud                  
        mul (1|M0)               acc0.0<1>:ud  r119.0<0;1,0>:ud  r124.4<0;1,0>:uw {I@1}
        mach (1|M0)              r111.0<1>:ud  r119.0<0;1,0>:ud  r124.2<0;1,0>:ud {Compacted}
        mov (1|M0)               r110.0<1>:ud  acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r119.0<0;1,0>:d   r124.6<0;1,0>:uw
        macl (1|M0)              r124.0<1>:d   r119.0<0;1,0>:d   r124.3<0;1,0>:d 
(W)     mul (1|M0)               acc0.0<1>:d   r119.1<0;1,0>:d   r124.4<0;1,0>:uw
        macl (1|M0)              r1.0<1>:d     r119.1<0;1,0>:d   r124.2<0;1,0>:d  {Compacted}
        mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r2.6<0;1,0>:uw  
        mach (1|M0)              r118.0<1>:ud  r2.0<0;1,0>:ud    r2.3<0;1,0>:ud   {Compacted}
        mov (1|M0)               r121.0<1>:f   r110.0<0;1,0>:f                  {Compacted,I@7}
        mov (1|M0)               r117.0<1>:ud  acc0.0<0;1,0>:ud                 {Compacted}
        add3 (1|M0)              r121.1<1>:d   r1.0<0;0>:d       r111.0<0;0>:d     r124.0<0>:d      {I@4}
        mov (1|M0)               r6.3<1>:d     r118.0<0;1,0>:d                  {I@3}
        mov (1|M0)               r6.2<1>:d     r117.0<0;1,0>:d                  {I@3}
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
(W)     call (32|M0)             r73.0         L56512                                 {A@1}
L672:
(W)     jmpi                                 L704                                
L688:
        mov (1|M0)               r88.0<1>:q    r119.0<0;1,0>:q                 
L704:
        cmp (1|M0)    (eq)f2.1   null<1>:d     r2.11<0;1,0>:d    0:w              
(W)     mov (1|M0)               r4.2<1>:uw    f2.1<0;1,0>:uw                  
(W)     mov (1|M0)               f2.0<1>:uw    r4.2<0;1,0>:uw                   {I@1}
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r2.10<0;1,0>:d    0:w              
(W)     mov (1|M0)               r4.2<1>:uw    f2.0<0;1,0>:uw                  
(W&f2.0) jmpi                                L832                                
L800:
        mov (2|M0)               r4.8<1>:d     tm0.0<1;1,0>:ud                  {A@1}
(W)     jmpi                                 L848                                 {A@1}
L832:
        mov (1|M0)               r4.4<1>:q     0:w                              
L848:
        cmp (1|M0)    (ne)f1.0   null<1>:d     r2.11<0;1,0>:d    0:w              
(W)     mov (1|M0)               r125.0<1>:hf  0x1:hf                             
        shl (1|M0)               r119.0<1>:q   r119.0<0;1,0>:q   6:w              
(W)     mov (1|M0)               r4.3<1>:uw    f1.0<0;1,0>:uw                  
        add (1|M0)               r4.5<1>:q     r2.5<0;1,0>:q     r119.0<0;1,0>:q  {I@2}
(W)     mov (1|M0)               f0.1<1>:uw    r4.3<0;1,0>:uw                   {I@2}
        add (1|M0)               r4.6<1>:q     r4.5<0;1,0>:q     16:w               {I@2}
(~f0.1) cmp (1|M0)    (ne)f0.1   null<1>:d     r2.10<0;1,0>:d    0:w              
(W)     mov (1|M0)               r4.3<1>:uw    f0.1<0;1,0>:uw                  
        cmp (1|M0)    (ne)f0.1   null<1>:d     r2.12<0;1,0>:d    144:w              
(f0.1)  sel (1|M0)               r111.0<1>:uw  r125.0<0;1,0>:uw  0x0:uw              {F@1}
(f0.1)  sel (1|M0)               r4.28<1>:uw   r125.0<0;1,0>:uw  0x0:uw             
        xor (1|M0)    (ne)f3.1   null<1>:uw    r111.0<0;1,0>:uw  0x1:uw              {I@2}
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:w     r112.0<0;1,0>:b   0:w              
(f3.1)  sel (1|M0)               r112.0<1>:uw  r125.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f0.0   null<1>:uw    r4.28<0;1,0>:uw   r112.0<0;1,0>:uw {I@1}
(W&f0.0) jmpi                                L1200                                
L1120:
(W)     mul (1|M0)               acc0.0<1>:ud  r88.0<0;1,0>:ud   0x8E39:uw             
        mach (1|M0)              r126.0<1>:ud  r88.0<0;1,0>:ud   0x38E38E39:ud             
        shr (1|M0)               r126.0<1>:ud  r126.0<0;1,0>:ud  0x5:uw              {Compacted,I@1}
        mul (1|M0)               r109.1<1>:d   r126.0<0;1,0>:d   -144:w               {Compacted,I@1}
        add (1|M0)               r109.1<1>:d   r109.1<0;1,0>:d   r88.0<0;1,0>:d   {I@1}
(W)     jmpi                                 L1432                                
L1200:
        mov (1|M0)               r88.1<1>:q    r2.12<0;1,0>:d                  
        mov (2|M0)               r124.0<1>:q   r88.0<1;1,0>:q                   {I@1}
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
(W)     call (32|M0)             r72.0         L56880                                 {A@1}
L1280:
        mul (1|M0)               acc0.0<1>:ud  r120.0<0;1,0>:ud  r88.4<0;1,0>:uw 
        mach (1|M0)              r90.0<1>:ud   r120.0<0;1,0>:ud  r88.2<0;1,0>:ud  {Compacted}
        mov (1|M0)               r89.0<1>:ud   acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r120.0<0;1,0>:d   r88.6<0;1,0>:uw 
        macl (1|M0)              r1.0<1>:d     r120.0<0;1,0>:d   r88.3<0;1,0>:d  
(W)     mul (1|M0)               acc0.0<1>:d   r120.1<0;1,0>:d   r88.4<0;1,0>:uw 
        macl (1|M0)              r127.0<1>:d   r120.1<0;1,0>:d   r88.2<0;1,0>:d   {Compacted}
        mov (1|M0)               r126.0<1>:f   r89.0<0;1,0>:f                   {Compacted,I@5}
        add3 (1|M0)              r126.1<1>:d   r127.0<0;0>:d     r90.0<0;0>:d      r1.0<0>:d        {I@1}
        add (1|M0)               r88.0<1>:q    r88.0<0;1,0>:q    -r126.0<0;1,0>:q {A@1}
        mov (1|M0)               r126.0<1>:f   r120.0<0;1,0>:f                  {Compacted,I@1}
        mov (1|M0)               r109.1<1>:d   r88.0<0;1,0>:ud                 
L1432:
        shl (1|M0)               r126.0<1>:d   r126.0<0;1,0>:d   4:w               {Compacted,F@1}
(W)     mov (1|M0)               f0.0<1>:uw    r4.3<0;1,0>:uw                  
        shl (1|M0)               r4.7<1>:q     r126.0<0;1,0>:ud  2:w               {I@2}
(W)     mov (1|M0)               r125.0<1>:hf  0x1:hf                             
        add (1|M0)               r2.0<1>:q     r2.7<0;1,0>:q     r4.7<0;1,0>:q    {Compacted,I@1}
        send.ugm (1|M0)          r74      r2  null:0  0x0            0x0210D580           {I@1,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.nop                             null                             {Compacted,F@1}
(f0.0)  sel (1|M0)               r2.0<1>:uw    r125.0<0;1,0>:uw  0x0:uw              {$3.src}
        cmp (1|M0)    (ne)f1.0   null<1>:d     r74.1<0;1,0>:d    2143363909:d               {$3.dst}
(f1.0)  sel (1|M0)               r110.0<1>:uw  r125.0<0;1,0>:uw  0x0:uw             
        and (1|M0)    (ne)f3.1   null<1>:uw    r2.0<0;1,0>:uw    r110.0<0;1,0>:uw {I@1}
(W&~f3.1) jmpi                               L1648                                
L1600:
        mov (2|M0)               r86.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r5.0<1>:uq    r4.5<0;1,0>:uq                   {A@1}
        send.ugm (1|M0)          null     r5  r86:2  0x30000            0x04000784           {I@1,$4} // wr:2+2, rd:0; store.ugm.d64.a64.flat[A+0x30]
L1648:
        cmp (1|M0)    (lt)f3.0   null<1>:d     r74.1<0;1,0>:d    1:w              
(W&f3.0) jmpi                                L56480                                
L1680:
        mov (1|M0)               r127.0<1>:f   r74.0<0;1,0>:f                  
        mov (1|M0)               r123.1<1>:q   r3.2<0;1,0>:d                   
        mul (1|M0)               acc0.0<1>:d   r127.0<0;1,0>:d   r2.24<0;1,0>:uw  {F@1}
        mach (1|M0)              r116.0<1>:d   r127.0<0;1,0>:d   r2.12<0;1,0>:d  
(W)     mov (1|M0)               f3.1<1>:uw    r4.3<0;1,0>:uw                  
        mov (1|M0)               r115.0<1>:d   acc0.0<0;1,0>:d                 
        mov (1|M0)               r125.1<1>:d   r116.0<0;1,0>:d                  {Compacted,I@3}
        mov (1|M0)               r125.0<1>:f   r115.0<0;1,0>:f                  {Compacted,I@2}
(W)     mov (1|M0)               r69.2<1>:hf   0x1:hf                             
        add (1|M0)               r125.0<1>:q   r125.0<0;1,0>:q   r109.1<0;1,0>:ud {A@1}
(f3.1)  sel (1|M0)               r1.0<1>:uw    r69.2<0;1,0>:uw   0x0:uw              {F@1}
        mul (1|M0)               acc0.0<1>:ud  r125.0<0;1,0>:ud  r123.4<0;1,0>:uw {I@2}
        mach (1|M0)              r92.0<1>:ud   r125.0<0;1,0>:ud  r123.2<0;1,0>:ud {Compacted}
        mov (1|M0)               r91.0<1>:ud   acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r125.0<0;1,0>:d   r123.6<0;1,0>:uw
        macl (1|M0)              r123.0<1>:d   r125.0<0;1,0>:d   r123.3<0;1,0>:d  {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r125.1<0;1,0>:d   r123.4<0;1,0>:uw
        macl (1|M0)              r109.0<1>:d   r125.1<0;1,0>:d   r123.2<0;1,0>:d  {Compacted}
        mov (1|M0)               r127.0<1>:f   r91.0<0;1,0>:f                   {Compacted,I@5}
        add3 (1|M0)              r127.1<1>:d   r109.0<0;0>:d     r92.0<0;0>:d      r123.0<0>:d      {I@1}
        send.ugm (1|M0)          r125     r6  null:0  0x0            0x04100580           {$5} // wr:2+0, rd:1; load.ugm.d32.a64
        shl (1|M0)               r4.7<1>:q     r127.0<0;1,0>:q   9:w               {A@1}
        shl (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   6:w               {Compacted}
        add (1|M0)               r4.7<1>:q     r3.0<0;1,0>:q     r4.7<0;1,0>:q    {I@2}
        add (1|M0)               r69.1<1>:q    r3.2<0;1,0>:q     r127.0<0;1,0>:q  {I@2}
        shl (1|M0)               r127.0<1>:q   r74.0<0;1,0>:d    2:w              
        add (1|M0)               r126.0<1>:q   r3.3<0;1,0>:q     r127.0<0;1,0>:q  {I@1}
        send.ugm (1|M0)          r75      r126  null:0  0x0            0x04100580           {I@1,$6} // wr:2+0, rd:1; load.ugm.d32.a64
        math.inv (1|M0)          r113.0<1>:f   r125.0<0;1,0>:f                  {$5.dst}
        sync.nop                             null                             {Compacted,M@1}
        mul (1|M0)               r75.0<1>:f    r75.0<0;1,0>:f    r113.0<0;1,0>:f  {Compacted,$6.dst}
        mul (1|M0)               r75.0<1>:f    r75.0<0;1,0>:f    16384.0:f               {F@1}
        cmp (1|M0)    (ne)f0.1   null<1>:d     r75.0<0;1,0>:d    2143363909:d               {F@1}
(f0.1)  sel (1|M0)               r109.0<1>:uw  r69.2<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r1.0<0;1,0>:uw    r109.0<0;1,0>:uw {I@1}
(W&~f2.1) jmpi                               L2224                                
L2176:
        sync.nop                             null                             {Compacted,A@1}
        mov (2|M0)               r87.0<1>:d    tm0.0<1;1,0>:ud                  {$4.src}
(W)     mov (1|M0)               r2.0<1>:uq    r4.5<0;1,0>:uq                   {Compacted,A@1}
        send.ugm (1|M0)          null     r2  r87:2  0x38000            0x04000784           {I@1,$7} // wr:2+2, rd:0; store.ugm.d64.a64.flat[A+0x38]
L2224:
        mul (1|M0)               r122.1<1>:d   r3.3<0;1,0>:d     3:w              
        asr (1|M0)               r124.0<1>:d   r3.3<0;1,0>:d     31:w               {Compacted}
        asr (1|M0)               r75.1<1>:d    r122.1<0;1,0>:d   31:w               {I@2}
        shl (1|M0)               r109.1<1>:ud  r109.1<0;1,0>:ud  0x4:uw             
        shr (1|M0)               r122.2<1>:ud  r124.0<0;1,0>:ud  0x1E:uw              {Compacted,I@3}
        shr (1|M0)               r75.1<1>:ud   r75.1<0;1,0>:ud   0x1E:uw              {I@3}
        shr (1|M0)               r124.0<1>:ud  r124.0<0;1,0>:ud  0x1F:uw             
        cmp (1|M0)    (eq)f3.0   null<1>:d     r4.7<0;1,0>:d     4:w              
        cmp (1|M0)    (eq)f2.0   null<1>:d     r4.7<0;1,0>:d     1:w              
        cmp (1|M0)    (eq)f1.1   null<1>:d     r3.3<0;1,0>:d     1:w              
        cmp (1|M0)    (gt)f0.0   null<1>:d     r3.3<0;1,0>:d     0:w              
        cmp (1|M0)    (eq)f2.1   null<1>:w     r1.6<0;1,0>:b     0:w              
        mov (1|M0)               r69.2<1>:q    r109.1<0;1,0>:ud                 {I@7}
        add (1|M0)               r122.2<1>:d   r3.3<0;1,0>:d     r122.2<0;1,0>:d  {I@7}
        add (1|M0)               r122.1<1>:d   r122.1<0;1,0>:d   r75.1<0;1,0>:d   {I@7}
        add (1|M0)               r124.0<1>:d   r3.3<0;1,0>:d     r124.0<0;1,0>:d  {I@7}
        and (1|M0)               r122.0<1>:d   r4.7<0;1,0>:d     -2:w              
(W)     mov (1|M0)               r104.0<1>:hf  -qnan(0x1FF):hf                             
        shl (1|M0)               r69.2<1>:q    r69.2<0;1,0>:q    2:w               {I@5}
        asr (1|M0)               r122.2<1>:d   r122.2<0;1,0>:d   2:w               {I@5}
        asr (1|M0)               r122.1<1>:d   r122.1<0;1,0>:d   2:w               {I@5}
        asr (1|M0)               r124.0<1>:d   r124.0<0;1,0>:d   1:w               {I@5}
        mov (1|M0)               r69.7<1>:q    r3.3<0;1,0>:d                   
        add (1|M0)               r69.5<1>:q    r4.7<0;1,0>:q     256:w              
        add (1|M0)               r69.4<1>:q    r4.7<0;1,0>:q     512:w              
        add (1|M0)               r69.3<1>:q    r4.7<0;1,0>:q     768:w              
        mov (1|M0)               r69.6<1>:q    0:w                              
        cmp (1|M0)    (eq)f0.1   null<1>:d     r4.7<0;1,0>:d     3:w              
(W)     mov (1|M0)               r69.2<1>:uw   f3.0<0;1,0>:uw                  
(W)     mov (1|M0)               r70.16<1>:uw  f2.0<0;1,0>:uw                  
(W)     mov (1|M0)               r70.17<1>:uw  f1.1<0;1,0>:uw                  
(W)     mov (1|M0)               r70.18<1>:uw  f0.0<0;1,0>:uw                  
(W)     mov (1|M0)               r70.19<1>:uw  f2.1<0;1,0>:uw                  
        cmp (1|M0)    (eq)f1.0   null<1>:d     r122.0<0;1,0>:d   2:w              
(f3.0)  sel (1|M0)               r69.3<1>:w    r104.0<0;1,0>:w   0:w               {F@1}
        add (1|M0)               r69.2<1>:q    r4.1<0;1,0>:q     r69.2<0;1,0>:q  
        mov (1|M0)               r70.3<1>:q    r122.2<0;1,0>:ud                
        mov (1|M0)               r70.1<1>:q    r122.1<0;1,0>:ud                
        mov (1|M0)               r70.2<1>:q    r124.0<0;1,0>:ud                
L2832:
        cmp (1|M0)    (eq)f0.0   null<1>:d     r69.12<0;1,0>:d   0:w              
        add (1|M0)               r84.1<1>:q    r74.1<0;1,0>:ud   -r69.6<0;1,0>:q 
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r69.13<0;1,0>:d   0:w              
(W&f0.0) jmpi                                L4752                                
L2896:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r84.3<0;1,0>:d    0:w               {I@3}
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r84.2<0;1,0>:ud   0x1:uw             
(W)     mov (1|M0)               r6.4<1>:hf    0x1:hf                              {$4.src}
        mov (1|M0)               r84.0<1>:f    r74.0<0;1,0>:f                  
(f1.1)  sel (1|M0)               r95.1<1>:uw   r6.4<0;1,0>:uw    0x0:uw              {F@2}
(f3.1)  sel (1|M0)               r95.0<1>:uw   r6.4<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f0.0   null<1>:d     r84.3<0;1,0>:d    0:w              
        and (1|M0)    (ne)f2.0   null<1>:uw    r95.1<0;1,0>:uw   r95.0<0;1,0>:uw  {I@2}
        mul (1|M0)               acc0.0<1>:d   r84.0<0;1,0>:d    r3.24<0;1,0>:uw  {F@1}
        mach (1|M0)              r6.0<1>:d     r84.0<0;1,0>:d    r3.12<0;1,0>:d  
        sync.nop                             null                             {$5.src}
(f0.0)  sel (1|M0)               r96.0<1>:uw   r6.4<0;1,0>:uw    0x0:uw              {$11.src}
        sync.allrd                           ($8,$15)                
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {$0.src}
(f2.0)  sel (1|M0)               r96.1<1>:uw   r6.4<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r84.2<0;1,0>:ud   0x2:uw             
        mov (1|M0)               r124.3<1>:d   r6.0<0;1,0>:d                    {@5,$10.src}
        mov (1|M0)               r124.2<1>:d   r5.0<0;1,0>:d                    {I@4}
        or (1|M0)     (ne)f3.0   null<1>:uw    r96.1<0;1,0>:uw   r96.0<0;1,0>:uw  {I@4}
        sync.allwr                           ($0,$3)                
(W)     mov (1|M0)               r103.0<1>:hf  0x1:hf                              {$5.dst}
        shl (1|M0)               r124.1<1>:q   r124.1<0;1,0>:q   2:w               {I@2}
        shl (1|M0)               r124.0<1>:q   r69.6<0;1,0>:q    2:w               {Compacted}
        sync.nop                             null                             {Compacted,$12.src}
        mov (1|M0)               r112.1<1>:d   0:w                               {$10.src}
(f1.1)  sel (1|M0)               r127.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw              {$7.src}
(f2.1)  sel (1|M0)               r97.0<1>:uw   r6.4<0;1,0>:uw    0x0:uw              {$1.src}
        add (1|M0)               r124.1<1>:q   r3.5<0;1,0>:q     r124.1<0;1,0>:q  {I@5}
(f3.0)  sel (1|M0)               r112.0<1>:d   r103.0<0;1,0>:w   0:w               {F@1}
        and (1|M0)    (ne)f3.1   null<1>:uw    r127.0<0;1,0>:uw  r97.0<0;1,0>:uw  {I@3}
        add (1|M0)               r70.0<1>:q    r124.1<0;1,0>:q   r124.0<0;1,0>:q  {Compacted,@3,$14.src}
        shl (1|M0)               r112.0<1>:q   r112.0<0;1,0>:q   2:w               {Compacted,I@3}
(f1.1)  sel (1|M0)               r116.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw              {$2.src}
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r112.0<0;1,0>:q  {Compacted,I@2}
        sync.allwr                           ($5,$12)                
(f0.0)  sel (1|M0)               r100.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r89      r6  null:0  0x0            0x04100580           {I@2,$8} // wr:2+0, rd:1; load.ugm.d32.a64
(f3.1)  sel (1|M0)               r6.0<1>:uw    r6.4<0;1,0>:uw    0x0:uw              {$8.src}
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r84.2<0;1,0>:ud   0x3:uw             
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r84.2<0;1,0>:ud   0x4:uw             
(W)     mov (1|M0)               r101.0<1>:hf  0x3:hf                             
(f1.1)  sel (1|M0)               r90.2<1>:uw   r6.4<0;1,0>:uw    0x0:uw              {$14.dst}
        sync.allwr                           ($6,$13)                
        sync.nop                             null                             {$7.src}
(f3.1)  sel (1|M0)               r99.0<1>:uw   r6.4<0;1,0>:uw    0x0:uw              {$15.dst}
(f0.0)  sel (1|M0)               r98.0<1>:uw   r6.4<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f3.0   null<1>:uw    r116.0<0;1,0>:uw  r99.0<0;1,0>:uw  {I@2}
        or (1|M0)     (ne)f2.0   null<1>:uw    r6.0<0;1,0>:uw    r98.0<0;1,0>:uw  {I@2}
(W)     mov (1|M0)               r102.0<1>:hf  0x2:hf                             
        mov (1|M0)               r103.1<1>:d   0:w                              
(f3.0)  sel (1|M0)               r117.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw              {$8.src}
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r84.2<0;1,0>:ud   0x5:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r117.0<0;1,0>:uw  r100.0<0;1,0>:uw {I@2}
(f2.0)  sel (1|M0)               r103.0<1>:d   r102.0<0;1,0>:w   0:w               {F@1}
(f0.0)  sel (1|M0)               r102.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        shl (1|M0)               r103.0<1>:q   r103.0<0;1,0>:q   2:w               {I@2}
(f3.0)  sel (1|M0)               r91.2<1>:d    r101.0<0;1,0>:w   0:w              
(f2.1)  sel (1|M0)               r101.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        sync.nop                             null                             {$14.dst}
(f1.1)  sel (1|M0)               r105.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r90.2<0;1,0>:uw   r101.0<0;1,0>:uw {I@2}
(W)     mov (1|M0)               r100.0<1>:hf  0x4:hf                             
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r103.0<0;1,0>:q 
(f1.1)  sel (1|M0)               r103.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f2.1)  sel (1|M0)               r91.2<1>:uw   r6.4<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r84.2<0;1,0>:ud   0x6:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r91.2<0;1,0>:uw   r102.0<0;1,0>:uw {I@2}
(f3.1)  sel (1|M0)               r103.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f0.0)  sel (1|M0)               r104.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f2.1)  sel (1|M0)               r105.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f2.0)  sel (1|M0)               r123.0<1>:d   r100.0<0;1,0>:w   0:w               {F@1}
        and (1|M0)    (ne)f2.0   null<1>:uw    r103.1<0;1,0>:uw  r103.0<0;1,0>:uw {I@4}
        and (1|M0)    (ne)f3.1   null<1>:uw    r105.1<0;1,0>:uw  r105.0<0;1,0>:uw {I@3}
        sync.nop                             null                             {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$1.src}
(f1.1)  sel (1|M0)               r107.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw              {$2.dst}
(W)     mov (1|M0)               r99.0<1>:hf   0x5:hf                             
(f2.0)  sel (1|M0)               r104.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r106.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r84.2<0;1,0>:ud   0x7:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r104.1<0;1,0>:uw  r104.0<0;1,0>:uw {I@3}
        mov (1|M0)               r91.3<1>:d    0:w                              
(f0.0)  sel (1|M0)               r106.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r107.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        sync.nop                             null                             {F@1}
(f3.0)  sel (1|M0)               r122.0<1>:d   r99.0<0;1,0>:w    0:w              
        and (1|M0)    (ne)f3.0   null<1>:uw    r107.1<0;1,0>:uw  r107.0<0;1,0>:uw {I@2}
        mov (1|M0)               r123.1<1>:d   0:w                               {Compacted}
        sync.nop                             null                             {Compacted,$1.dst}
(f0.0)  sel (1|M0)               r108.0<1>:uw  r6.4<0;1,0>:uw    0x0:uw              {$2.dst}
        shl (1|M0)               r91.1<1>:q    r91.1<0;1,0>:q    2:w              
        or (1|M0)     (ne)f2.0   null<1>:uw    r106.1<0;1,0>:uw  r106.0<0;1,0>:uw
(f3.0)  sel (1|M0)               r108.1<1>:uw  r6.4<0;1,0>:uw    0x0:uw             
        send.ugm (1|M0)          r91      r6  null:0  0x0            0x04100580           {I@3,$13} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r122.1<1>:d   0:w                              
(W)     mov (1|M0)               r98.0<1>:hf   0x6:hf                             
        shl (1|M0)               r123.0<1>:q   r123.0<0;1,0>:q   2:w               {Compacted}
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r91.1<0;1,0>:q   {Compacted,$13.dst}
        or (1|M0)     (ne)f1.1   null<1>:uw    r108.1<0;1,0>:uw  r108.0<0;1,0>:uw {I@4}
        send.ugm (1|M0)          r90      r6  null:0  0x0            0x04100580           {I@2,$14} // wr:2+0, rd:1; load.ugm.d32.a64
        mov (1|M0)               r121.1<1>:d   0:w                               {Compacted}
(W)     mov (1|M0)               r97.0<1>:hf   4.172325e-07:hf                             
        shl (1|M0)               r122.0<1>:q   r122.0<0;1,0>:q   2:w               {Compacted}
(f2.0)  sel (1|M0)               r121.0<1>:d   r98.0<0;1,0>:w    0:w               {F@2}
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r123.0<0;1,0>:q  {$14.src}
        mov (1|M0)               r89.3<1>:d    0:w                               {$8.dst}
        sync.allwr                           ($8,$10,$11)                
        send.ugm (1|M0)          r79      r6  null:0  0x0            0x04100580           {I@2,$12} // wr:2+0, rd:1; load.ugm.d32.a64
(f1.1)  sel (1|M0)               r89.2<1>:d    r97.0<0;1,0>:w    0:w               {F@1}
        shl (1|M0)               r121.0<1>:q   r121.0<0;1,0>:q   2:w               {Compacted}
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r122.0<0;1,0>:q  {Compacted,$12.src}
        shl (1|M0)               r89.1<1>:q    r89.1<0;1,0>:q    2:w               {I@3}
        send.ugm (1|M0)          r78      r6  null:0  0x0            0x04100580           {I@2,$11} // wr:2+0, rd:1; load.ugm.d32.a64
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r121.0<0;1,0>:q  {$11.src}
        send.ugm (1|M0)          r84      r70  null:0  0x0            0x04100580           {$1} // wr:2+0, rd:1; load.ugm.d32.a64
        send.ugm (1|M0)          r119     r6  null:0  0x0            0x04100580           {I@1,$10} // wr:2+0, rd:1; load.ugm.d32.a64
        add (1|M0)               r6.0<1>:q     r70.0<0;1,0>:q    r89.1<0;1,0>:q   {$10.src}
        send.ugm (1|M0)          r118     r6  null:0  0x0            0x04100580           {I@1,$9} // wr:2+0, rd:1; load.ugm.d32.a64
(W)     send.ugm (1|M0)          null     r69  r79:1  0x80800000:a0.1        0x4200D504           {$12} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF00]
(W)     send.ugm (1|M0)          null     r69  r78:1  0x80A00000:a0.1        0x4200D504           {$11} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFEC0]
(W)     send.ugm (1|M0)          null     r69  r119:1  0x80000000:a0.1        0x4200D504           {$10} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
(W)     send.ugm (1|M0)          null     r69  r118:1  0x80200000:a0.1        0x4200D504           {$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
(W)     jmpi                                 L4896                                
L4752:
        sync.allrd                           ($0,$8,$15)                
        mov (1|M0)               r5.0<1>:d     r74.6<0;1,0>:d                   {Compacted,$4.src}
        mov (1|M0)               r6.0<1>:d     r74.7<0;1,0>:d                  
        mov (1|M0)               r84.0<1>:d    r74.2<0;1,0>:d                   {Compacted}
(W)     send.ugm (1|M0)          null     r69  r5:2  0x80800000:a0.1        0x4200E504           {I@2,$4} // wr:1+2, rd:0; store.ugm.d32x32t.a32.ss[a0.1][A-0xFF00]
        mov (1|M0)               r5.0<1>:d     r74.8<0;1,0>:d                   {Compacted,$4.src}
        mov (1|M0)               r6.0<1>:d     r74.9<0;1,0>:d                   {Compacted}
        mov (1|M0)               r89.0<1>:d    r74.3<0;1,0>:d                   {Compacted}
(W)     send.ugm (1|M0)          null     r69  r5:2  0x80000000:a0.1        0x4200E504           {I@2,$0} // wr:1+2, rd:0; store.ugm.d32x32t.a32.ss[a0.1][A-0x10000]
        mov (1|M0)               r91.0<1>:d    r74.4<0;1,0>:d                   {Compacted,$13.src}
        sync.allrd                           ($0,$5)                
        mov (1|M0)               r90.0<1>:d    r74.5<0;1,0>:d                   {$14.dst}
L4896:
        cmp (1|M0)    (eq)f0.0   null<1>:d     r84.3<0;1,0>:d    0:w               {$1.dst}
        cmp (1|M0)    (lt)f2.0   null<1>:ud    r84.2<0;1,0>:ud   0x2:uw             
(W)     mov (1|M0)               r126.0<1>:hf  0x1:hf                             
        sync.nop                             null                             {F@1}
        sync.allrd                           ($1,$12)                
(f0.0)  sel (1|M0)               r115.0<1>:uw  r126.0<0;1,0>:uw  0x0:uw              {$5.src}
(f2.0)  sel (1|M0)               r94.0<1>:uw   r126.0<0;1,0>:uw  0x0:uw             
        and (1|M0)    (ne)f1.1   null<1>:uw    r115.0<0;1,0>:uw  r94.0<0;1,0>:uw  {I@1}
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r84.3<0;1,0>:d    0:w              
(W&f1.1) jmpi                                L45880                                
L5056:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r84.2<0;1,0>:d    2:w              
(W)     mov (1|M0)               r125.0<1>:hf  0x1:hf                             
        sync.nop                             null                             {Compacted,F@1}
(f0.0)  sel (1|M0)               r93.0<1>:uw   r125.0<0;1,0>:uw  0x0:uw              {$1.src}
        sync.nop                             null                             {Compacted,$7.src}
(f1.1)  sel (1|M0)               r114.0<1>:uw  r125.0<0;1,0>:uw  0x0:uw              {$3.src}
        and (1|M0)    (ne)f2.1   null<1>:uw    r114.0<0;1,0>:uw  r93.0<0;1,0>:uw  {I@1}
(W&f2.1) jmpi                                L34848                                
L5168:
        sync.allwr                           ($0,$3)                
        asr (1|M0)               r102.0<1>:d   r84.0<0;1,0>:d    31:w               {Compacted,$5.dst}
(W)     mov (1|M0)               f2.0<1>:uw    r70.19<0;1,0>:uw                
        shr (1|M0)               r102.0<1>:ud  r102.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        asr (1|M0)               r84.1<1>:d    r89.0<0;1,0>:d    31:w               {Compacted}
        cmp (1|M0)    (lt)f3.1   null<1>:ud    r84.2<0;1,0>:ud   0x5:uw             
        add (1|M0)               r102.0<1>:d   r84.0<0;1,0>:d    r102.0<0;1,0>:d  {Compacted,I@3}
        shr (1|M0)               r84.1<1>:ud   r84.1<0;1,0>:ud   0x1D:uw              {I@3}
(W)     mov (1|M0)               r124.0<1>:hf  0x1:hf                              {$10.src}
        sync.nop                             null                             {Compacted,$14.src}
        asr (1|M0)               r119.0<1>:d   r91.0<0;1,0>:d    31:w               {Compacted,$10.src}
        asr (1|M0)               r102.0<1>:d   r102.0<0;1,0>:d   3:w               {I@3}
(f2.0)  mov (1|M0)               r102.0<1>:f   r84.0<0;1,0>:f                   {I@1}
        add (1|M0)               r84.1<1>:d    r89.0<0;1,0>:d    r84.1<0;1,0>:d   {Compacted}
        sync.nop                             null                             {Compacted,F@2}
(f3.1)  sel (1|M0)               r92.0<1>:uw   r124.0<0;1,0>:uw  0x0:uw              {$10.src}
        shr (1|M0)               r119.0<1>:ud  r119.0<0;1,0>:ud  0x1D:uw             
        mul (1|M0)               acc0.0<1>:d   r102.0<0;1,0>:d   r4.0<0;1,0>:uw   {F@1}
(W)     mov (1|M0)               f3.1<1>:uw    r70.19<0;1,0>:uw                
        asr (1|M0)               r84.1<1>:d    r84.1<0;1,0>:d    3:w               {I@5}
        mach (1|M0)              r6.0<1>:d     r102.0<0;1,0>:d   r4.0<0;1,0>:d   
(f2.0)  mov (1|M0)               r84.1<1>:d    r89.0<0;1,0>:d                  
        add (1|M0)               r119.0<1>:d   r91.0<0;1,0>:d    r119.0<0;1,0>:d  {Compacted,I@6}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r84.1<0;1,0>:d    r4.0<0;1,0>:uw   {I@3}
        sync.nop                             null                             {Compacted,$9.src}
        mov (1|M0)               r120.1<1>:d   r6.0<0;1,0>:d                    {Compacted,$15.src}
        asr (1|M0)               r119.0<1>:d   r119.0<0;1,0>:d   3:w               {Compacted,I@4}
        mach (1|M0)              r6.0<1>:d     r84.1<0;1,0>:d    r4.0<0;1,0>:d    {Compacted}
(f3.1)  mov (1|M0)               r119.0<1>:f   r91.0<0;1,0>:f                   {I@2}
        mov (1|M0)               r120.0<1>:f   r5.0<0;1,0>:f                    {Compacted}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mul (1|M0)               acc0.0<1>:d   r119.0<0;1,0>:d   r4.0<0;1,0>:uw  
        mov (1|M0)               r112.1<1>:d   r6.0<0;1,0>:d                    {Compacted,@3,$12.src}
        mach (1|M0)              r6.0<1>:d     r119.0<0;1,0>:d   r4.0<0;1,0>:d    {Compacted}
(f0.0)  sel (1|M0)               r113.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw              {$13.src}
        mov (1|M0)               r112.0<1>:f   r5.0<0;1,0>:f                    {I@5}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mov (1|M0)               r84.5<1>:d    r6.0<0;1,0>:d                    {I@3}
        and (1|M0)    (ne)f2.1   null<1>:uw    r113.0<0;1,0>:uw  r92.0<0;1,0>:uw  {I@3}
        mov (1|M0)               r84.4<1>:d    r5.0<0;1,0>:d                    {Compacted,I@3}
        shl (1|M0)               r120.0<1>:q   r120.0<0;1,0>:q   1:w               {Compacted}
        shl (1|M0)               r112.0<1>:q   r112.0<0;1,0>:q   1:w              
        shl (1|M0)               r84.2<1>:q    r84.2<0;1,0>:q    1:w               {I@3}
        add (1|M0)               r70.5<1>:q    r3.7<0;1,0>:q     r120.0<0;1,0>:q  {I@3}
        add (1|M0)               r70.6<1>:q    r3.7<0;1,0>:q     r112.0<0;1,0>:q  {I@3}
        add (1|M0)               r70.7<1>:q    r3.7<0;1,0>:q     r84.2<0;1,0>:q   {I@3}
(W&f2.1) jmpi                                L22464                                
L5792:
        sync.allwr                           ($5,$9)                
(W)     send.ugm (1|M0)          r7       r69  null:0  0x80800000:a0.1        0x4210D500           {$8} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF00]
        sync.nop                             null                             {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$12.src}
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80A00000:a0.1        0x4210D500           {$7} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFEC0]
(W)     send.ugm (1|M0)          r115     r69  null:0  0x80000000:a0.1        0x4210D500           {$6} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
        sync.allrd                           ($2,$8)                
        asr (1|M0)               r111.0<1>:d   r90.0<0;1,0>:d    31:w               {Compacted,$14.dst}
(W)     mov (1|M0)               f3.0<1>:uw    r70.19<0;1,0>:uw                
        shr (1|M0)               r111.0<1>:ud  r111.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
(W)     send.ugm (1|M0)          r114     r69  null:0  0x80200000:a0.1        0x4210D500           {$2} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        add (1|M0)               r111.0<1>:d   r90.0<0;1,0>:d    r111.0<0;1,0>:d  {I@1}
(W)     mov (1|M0)               r84.2<1>:hf   0x1:hf                             
        asr (1|M0)               r111.0<1>:d   r111.0<0;1,0>:d   3:w               {Compacted,I@1}
(f3.0)  mov (1|M0)               r111.0<1>:f   r90.0<0;1,0>:f                   {I@1}
        sync.nop                             null                             {Compacted,F@2}
(f0.0)  sel (1|M0)               r127.0<1>:uw  r84.2<0;1,0>:uw   0x0:uw              {$3.src}
(W)     mov (1|M0)               f2.0<1>:uw    r70.19<0;1,0>:uw                
        sync.nop                             null                             {$12.dst}
(f0.0)  sel (1|M0)               r101.0<1>:uw  r84.2<0;1,0>:uw   0x0:uw              {$3.dst}
(W)     mov (1|M0)               f1.1<1>:uw    r70.19<0;1,0>:uw                
(f0.0)  sel (1|M0)               r90.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        mul (1|M0)               acc0.0<1>:d   r111.0<0;1,0>:d   r4.0<0;1,0>:uw   {F@1}
        mach (1|M0)              r6.0<1>:d     r111.0<0;1,0>:d   r4.0<0;1,0>:d    {Compacted}
        mov (32|M0)              r87.0<1>:f    0.0:f                               {Compacted,$7.src}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r93.1<1>:d    r6.0<0;1,0>:d                    {Compacted,I@2}
        mov (1|M0)               r93.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r93.0<1>:q    r93.0<0;1,0>:q    1:w               {Compacted,A@1}
        add (1|M0)               r75.6<1>:q    r3.7<0;1,0>:q     r93.0<0;1,0>:q   {I@1}
        asr (1|M0)               r92.0<1>:d    r7.0<0;1,0>:d     31:w               {Compacted,$8.dst}
        shr (1|M0)               r92.0<1>:ud   r92.0<0;1,0>:ud   0x1D:uw              {Compacted,I@1}
        add (1|M0)               r92.0<1>:d    r7.0<0;1,0>:d     r92.0<0;1,0>:d   {Compacted,I@1}
        asr (1|M0)               r92.0<1>:d    r92.0<0;1,0>:d    3:w               {Compacted,I@1}
(f3.0)  mov (1|M0)               r92.0<1>:f    r7.0<0;1,0>:f                    {I@1}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r84.2<0;1,0>:d    5:w               {F@1}
        mul (1|M0)               acc0.0<1>:d   r92.0<0;1,0>:d    r4.0<0;1,0>:uw  
        mach (1|M0)              r6.0<1>:d     r92.0<0;1,0>:d    r4.0<0;1,0>:d    {Compacted}
(f3.0)  sel (1|M0)               r127.1<1>:uw  r84.2<0;1,0>:uw   0x0:uw             
        cmp (1|M0)    (gt)f3.0   null<1>:ud    r84.2<0;1,0>:ud   0x6:uw             
        and (1|M0)    (ne)f3.1   null<1>:uw    r127.1<0;1,0>:uw  r127.0<0;1,0>:uw {I@2}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r75.3<1>:d    r6.0<0;1,0>:d                   
(f3.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        sync.nop                             null                             {$0.dst}
(f3.1)  sel (1|M0)               r105.0<1>:d   r84.0<0;1,0>:d    r72.0<0;1,0>:d   {$7.dst}
(W)     mov (1|M0)               r75.18<1>:uw  f3.1<0;1,0>:uw                  
        sync.allwr                           ($3,$4,$6)                
        asr (1|M0)               r106.0<1>:d   r105.0<0;1,0>:d   31:w               {Compacted,@2,$2.dst}
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r84.3<0;1,0>:ud   0x0:uw             
        shr (1|M0)               r106.0<1>:ud  r106.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        mov (1|M0)               r75.2<1>:d    r5.0<0;1,0>:d                    {Compacted}
        add (1|M0)               r106.0<1>:d   r105.0<0;1,0>:d   r106.0<0;1,0>:d  {Compacted,I@2}
(f3.1)  sel (1|M0)               r89.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        asr (1|M0)               r106.0<1>:d   r106.0<0;1,0>:d   3:w               {I@2}
(f3.1)  sel (1|M0)               r91.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(~f2.0) mov (1|M0)               r105.0<1>:f   r106.0<0;1,0>:f                  {I@2}
        and (1|M0)    (ne)f2.0   null<1>:uw    r101.0<0;1,0>:uw  r84.3<0;1,0>:uw  {F@1}
(W)     mov (1|M0)               f3.1<1>:uw    r70.19<0;1,0>:uw                
        mul (1|M0)               acc0.0<1>:d   r105.0<0;1,0>:d   r4.0<0;1,0>:uw  
        mach (1|M0)              r6.0<1>:d     r105.0<0;1,0>:d   r4.0<0;1,0>:d    {Compacted}
(f2.0)  sel (1|M0)               r102.0<1>:uw  r84.2<0;1,0>:uw   0x0:uw             
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        or (1|M0)     (ne)f2.1   null<1>:uw    r102.0<0;1,0>:uw  r89.2<0;1,0>:uw  {I@2}
        mov (1|M0)               r104.1<1>:d   r6.0<0;1,0>:d                    {Compacted}
        mov (1|M0)               r104.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@3}
        shl (1|M0)               r75.1<1>:q    r75.1<0;1,0>:q    1:w              
        sync.nop                             null                             {Compacted,$13.dst}
(f2.1)  sel (1|M0)               r99.0<1>:d    r115.0<0;1,0>:d   r84.0<0;1,0>:d  
(W)     mov (1|M0)               r75.19<1>:uw  f2.1<0;1,0>:uw                  
        asr (1|M0)               r100.0<1>:d   r99.0<0;1,0>:d    31:w               {Compacted,@2}
        cmp (1|M0)    (gt)f2.1   null<1>:ud    r84.2<0;1,0>:ud   0x7:uw             
        shr (1|M0)               r100.0<1>:ud  r100.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        shl (1|M0)               r104.0<1>:q   r104.0<0;1,0>:q   1:w               {Compacted,F@1}
        add (1|M0)               r100.0<1>:d   r99.0<0;1,0>:d    r100.0<0;1,0>:d  {Compacted,I@2}
(f2.1)  sel (1|M0)               r90.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        asr (1|M0)               r100.0<1>:d   r100.0<0;1,0>:d   3:w               {I@2}
        add (1|M0)               r75.7<1>:q    r3.7<0;1,0>:q     r75.1<0;1,0>:q  
(~f1.1) mov (1|M0)               r99.0<1>:f    r100.0<0;1,0>:f                  {I@2}
        and (1|M0)    (ne)f1.1   null<1>:uw    r90.3<0;1,0>:uw   r90.2<0;1,0>:uw  {F@1}
        mul (1|M0)               acc0.0<1>:d   r99.0<0;1,0>:d    r4.0<0;1,0>:uw  
        mach (1|M0)              r6.0<1>:d     r99.0<0;1,0>:d    r4.0<0;1,0>:d   
        add (1|M0)               r84.2<1>:q    r3.7<0;1,0>:q     r104.0<0;1,0>:q 
(f1.1)  sel (1|M0)               r91.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        or (1|M0)     (ne)f1.1   null<1>:uw    r91.3<0;1,0>:uw   r91.2<0;1,0>:uw  {I@2}
        mov (1|M0)               r89.3<1>:d    r6.0<0;1,0>:d                   
        mov (1|M0)               r89.2<1>:d    r5.0<0;1,0>:d                    {I@3}
(f1.1)  sel (1|M0)               r97.0<1>:d    r114.0<0;1,0>:d   r84.0<0;1,0>:d   {$2.dst}
        shl (1|M0)               r89.1<1>:q    r89.1<0;1,0>:q    1:w               {I@2}
        asr (1|M0)               r98.0<1>:d    r97.0<0;1,0>:d    31:w               {Compacted,@2,$7.src}
(W)     mov (1|M0)               r75.20<1>:uw  f1.1<0;1,0>:uw                  
        shr (1|M0)               r98.0<1>:ud   r98.0<0;1,0>:ud   0x1D:uw              {Compacted,I@2}
        add (1|M0)               r84.3<1>:q    r3.7<0;1,0>:q     r89.1<0;1,0>:q  
        add (1|M0)               r98.0<1>:d    r97.0<0;1,0>:d    r98.0<0;1,0>:d   {Compacted,I@2}
        asr (1|M0)               r98.0<1>:d    r98.0<0;1,0>:d    3:w               {Compacted,I@1}
(~f3.1) mov (1|M0)               r97.0<1>:f    r98.0<0;1,0>:f                   {I@1}
(W)     mov (1|M0)               f3.1<1>:uw    r70.18<0;1,0>:uw                 {F@1}
        mul (1|M0)               acc0.0<1>:d   r97.0<0;1,0>:d    r4.0<0;1,0>:uw  
        mach (1|M0)              r6.0<1>:d     r97.0<0;1,0>:d    r4.0<0;1,0>:d    {Compacted}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r84.3<1>:d    r6.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r84.2<1>:d    r5.0<0;1,0>:d                    {Compacted,I@2}
        shl (1|M0)               r84.1<1>:q    r84.1<0;1,0>:q    1:w               {I@1}
        add (1|M0)               r84.4<1>:q    r3.7<0;1,0>:q     r84.1<0;1,0>:q   {I@1}
(W&f3.1) jmpi                                L7280                                
L7216:
        mov (32|M0)              r94.0<1>:ud   r87.0<1;1,0>:ud                  {Compacted}
        mov (32|M0)              r92.0<1>:ud   r87.0<1;1,0>:ud                  {Compacted}
        mov (32|M0)              r85.0<1>:f    r87.0<1;1,0>:f                   {Compacted}
        mov (16|M0)              r113.0<1>:f   0.0:f                               {Compacted}
(W)     send.ugm (1|M0)          null     r69  r113:1  0x80400000:a0.1        0x4200D504           {F@1,$14} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W)     jmpi                                 L21392                                
L7280:
(W)     mov (1|M0)               r72.0<1>:uq   r70.6<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r127.0<1>:uq  r4.7<0;1,0>:uq                   {Compacted}
        send.ugm (1|M0)          r98      r72  null:0  0x0            0x0220E580           {I@2,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r70.7<0;1,0>:uq                  {Compacted,$15.src}
(W)     mov (1|M0)               r126.0<1>:uq  r69.5<0;1,0>:uq                  {Compacted}
        send.ugm (1|M0)          r100     r72  null:0  0x0            0x0220E580           {I@2,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r75.6<0;1,0>:uq                  {Compacted,$3.src}
(W)     mov (1|M0)               r125.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted}
        send.ugm (1|M0)          r102     r72  null:0  0x0            0x0220E580           {I@2,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r75.7<0;1,0>:uq                  {Compacted,$14.src}
(W)     mov (1|M0)               r124.0<1>:uq  r70.5<0;1,0>:uq                  {Compacted}
        send.ugm (1|M0)          r104     r72  null:0  0x0            0x0220E580           {I@2,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r84.2<0;1,0>:uq                  {$5.src}
        send.ugm (1|M0)          r5       r127  null:0  0x0            0x024AF580           {$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r106     r72  null:0  0x0            0x0220E580           {I@1,$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r84.3<0;1,0>:uq                  {Compacted,$2.src}
        sync.allwr                           ($8,$10,$11,$14)                
        sync.nop                             null                             {Compacted,$12.src}
        send.ugm (1|M0)          r76      r126  null:0  0x0            0x024AF580           {$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.allwr                           ($1,$2,$12)                
        send.ugm (1|M0)          r108     r72  null:0  0x0            0x0220E580           {I@1,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               r72.0<1>:uq   r84.4<0;1,0>:uq                  {$0.src}
        send.ugm (1|M0)          r112     r125  null:0  0x0            0x0210D580           {$7} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r96      r124  null:0  0x0            0x0220E580           {$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r110     r72  null:0  0x0            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               f3.0<1>:uw    r70.17<0;1,0>:uw                
(W)     send.ugm (1|M0)          null     r69  r112:1  0x80600000:a0.1        0x4200D504           {$7} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
(W&f3.0) jmpi                                L8000                                
L7648:
        sync.nop                             null                             {Compacted,$4.dst}
(W)     mov (1|M0)               r53.0<1>:uq   r70.6<0;1,0>:uq                  {Compacted,$14.dst}
(W)     mov (1|M0)               r123.0<1>:uq  r69.4<0;1,0>:uq                  {$11.src}
        send.ugm (1|M0)          r65      r53  null:0  0x80000            0x0220E580           {I@2,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
(W)     mov (1|M0)               r53.0<1>:uq   r70.7<0;1,0>:uq                  {Compacted,$9.src}
(W)     mov (1|M0)               r122.0<1>:uq  r69.3<0;1,0>:uq                  {Compacted,$14.src}
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r63      r53  null:0  0x80000            0x0220E580           {I@2,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
(W)     mov (1|M0)               r53.0<1>:uq   r75.6<0;1,0>:uq                  {Compacted,$10.src}
(W)     mov (1|M0)               r121.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted,$0.src}
        sync.nop                             null                             {Compacted,$14.dst}
        send.ugm (1|M0)          r61      r53  null:0  0x80000            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
(W)     mov (1|M0)               r53.0<1>:uq   r75.7<0;1,0>:uq                  {Compacted,$6.src}
(W)     mov (1|M0)               r120.0<1>:uq  r70.5<0;1,0>:uq                  {Compacted}
        sync.nop                             null                             {$13.dst}
        send.ugm (1|M0)          r59      r53  null:0  0x80000            0x0220E580           {I@2,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
(W)     mov (1|M0)               r53.0<1>:uq   r84.2<0;1,0>:uq                  {Compacted,$1.src}
(W)     mov (1|M0)               r72.0<1>:uq   r84.4<0;1,0>:uq                  {Compacted,$12.src}
        sync.nop                             null                             {Compacted,$10.dst}
        send.ugm (1|M0)          r57      r53  null:0  0x80000            0x0220E580           {I@2,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
(W)     mov (1|M0)               r53.0<1>:uq   r84.3<0;1,0>:uq                  {Compacted,$11.src}
        send.ugm (1|M0)          r29      r123  null:0  0x0            0x024AF580           {$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$5.dst}
        send.ugm (1|M0)          r25      r122  null:0  0x0            0x024AF580           {$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$8.dst}
        send.ugm (1|M0)          r83      r121  null:0  0x40000            0x0210D580           {$7} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r67      r120  null:0  0x80000            0x0220E580           {$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r55      r53  null:0  0x80000            0x0220E580           {I@1,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r53      r72  null:0  0x80000            0x0220E580           {$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L8000:
        mov (32|M0)              r94.0<1>:ud   r87.0<1;1,0>:ud                  {Compacted}
        mov (32|M0)              r92.0<1>:f    r87.0<1;1,0>:f                   {Compacted}
        mov (32|M0)              r85.0<1>:f    r87.0<1;1,0>:f                   {Compacted}
        sync.nop                             null                             {Compacted,$14.src}
        mov (16|M0)              r72.0<1>:d    0:w                               {$12.src}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$15} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        mov (1|M0)               r84.5<1>:q    0:w                              
L8080:
(W)     mov (1|M0)               f2.1<1>:uw    r70.16<0;1,0>:uw                
(W&f2.1) jmpi                                L19504                                
L8112:
        sync.allwr                           ($1,$11)                
        sync.nop                             null                             {Compacted,$7.src}
        shl (16|M0)              r112.0<1>:d   r5.0<1;1,0>:d     12:w               {Compacted,$8.dst}
        sync.allrd                           ($3,$4,$9,$10)                
        shl (16|M0)              r72.0<1>:d    r5.0<1;1,0>:d     9:w               {Compacted,$15.src}
        sync.nop                             null                             {Compacted,$0.dst}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                               {$13.dst}
        shl (16|M0)              r120.0<1>:d   r6.0<1;1,0>:d     12:w               {Compacted,$13.src}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r6.0<1;1,0>:d     9:w               {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {@2,$2.src} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r6.0<1;1,0>:ud    0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {@2,$15.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r6.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r5.0<1;1,0>:d     -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r6.0<1;1,0>:d     -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r6.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L9136                                
L8704:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80600000:a0.1        0x4210D500           {I@2,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        sync.allwr                           ($12,$14)                
        mov (8|M0)               r120.0<1>:f   r96.0<1;1,0>:f                   {$4.dst}
        sync.allwr                           ($6,$13)                
        mov (8|M0)               r120.8<1>:d   r98.0<1;1,0>:d                   {$15.dst}
        sync.nop                             null                             {$5.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r100.0<1;1,0>:d                  {$3.dst}
        mov (8|M0)               r121.8<1>:d   r102.0<1;1,0>:d                  {$7.dst}
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r122.0<1>:d   r104.0<1;1,0>:d                 
        sync.allwr                           ($3,$4)                
        mov (8|M0)               r122.8<1>:d   r106.0<1;1,0>:d                  {$2.dst}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r108.0<1;1,0>:d                 
        sync.nop                             null                             {$10.dst}
        mov (8|M0)               r123.8<1>:d   r110.0<1;1,0>:d                  {$8.dst}
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$5}
        and (16|M0)              r75.2<1>:w    r72.0<1;1,0>:ub   127:w              
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$5.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L9360                                
L9136:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$2} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$2.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$0} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L9360                                
L9248:
        sync.nop                             null                             {$0.src}
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4220E500           {$9} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ss[a0.1][A-0xFF80]
        and (16|M0)              r75.2<1>:w    r73.0<1;1,0>:ub   127:w               {$9.dst}
        mov (16|M0)              r112.0<1>:d   r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r112.0<1>:f   r112.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r112.0<1;1,0>:ud {F@1}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$10} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L9360:
        shl (16|M0)              r112.0<1>:d   r7.0<1;1,0>:d     12:w               {Compacted}
        sync.nop                             null                             {Compacted,$10.src}
        shl (16|M0)              r72.0<1>:d    r7.0<1;1,0>:d     9:w               {Compacted,$0.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r8.0<1;1,0>:d     12:w               {Compacted}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r8.0<1;1,0>:d     9:w              
        shr (16|M0)              acc0.0<1>:ud  r7.0<1;1,0>:ud    0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r8.0<1;1,0>:ud    0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r7.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r8.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r7.0<1;1,0>:d     -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r7.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r8.0<1;1,0>:d     -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r8.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L10352                                
L9920:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80600000:a0.1        0x4210D500           {I@2,$6} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        sync.allwr                           ($12,$14)                
        mov (8|M0)               r120.0<1>:d   r96.8<1;1,0>:d                   {$4.dst}
        sync.allwr                           ($6,$13)                
        mov (8|M0)               r120.8<1>:f   r98.8<1;1,0>:f                   {$15.dst}
        sync.nop                             null                             {$5.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r100.8<1;1,0>:d                  {$3.dst}
        mov (8|M0)               r121.8<1>:d   r102.8<1;1,0>:d                  {$7.dst}
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r122.0<1>:d   r104.8<1;1,0>:d                 
        sync.allwr                           ($3,$4)                
        mov (8|M0)               r122.8<1>:d   r106.8<1;1,0>:d                  {$2.dst}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r108.8<1;1,0>:d                 
        sync.nop                             null                             {$10.dst}
        mov (8|M0)               r123.8<1>:d   r110.8<1;1,0>:d                  {$8.dst}
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$1}
        and (16|M0)              r75.2<1>:w    r72.16<1;1,0>:ub  127:w              
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$1.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L10576                                
L10352:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$11} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$11.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$12} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L10576                                
L10464:
        sync.nop                             null                             {$12.src}
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4220E500           {$4} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ss[a0.1][A-0xFF80]
        and (16|M0)              r75.2<1>:w    r73.16<1;1,0>:ub  127:w               {$4.dst}
        mov (16|M0)              r112.0<1>:d   r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r112.0<1>:f   r112.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r112.0<1;1,0>:ud {F@1}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$7} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L10576:
        sync.allwr                           ($4,$11)                
        shl (16|M0)              r112.0<1>:d   r76.0<1;1,0>:d    12:w               {Compacted,$13.dst}
        sync.nop                             null                             {Compacted,$7.src}
        shl (16|M0)              r72.0<1>:d    r76.0<1;1,0>:d    9:w               {$12.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r77.0<1;1,0>:d    12:w              
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r77.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r76.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r77.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L11584                                
L11168:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80600000:a0.1        0x4210D500           {I@2,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        sync.allwr                           ($12,$14)                
        mov (8|M0)               r120.0<1>:f   r97.0<1;1,0>:f                   {$4.dst}
        sync.allwr                           ($6,$13)                
        mov (8|M0)               r120.8<1>:d   r99.0<1;1,0>:d                   {$15.dst}
        sync.nop                             null                             {$5.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r101.0<1;1,0>:d                  {$3.dst}
        mov (8|M0)               r121.8<1>:d   r103.0<1;1,0>:d                  {$7.dst}
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r122.0<1>:d   r105.0<1;1,0>:d                 
        sync.allwr                           ($3,$4)                
        mov (8|M0)               r122.8<1>:d   r107.0<1;1,0>:d                  {$2.dst}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r109.0<1;1,0>:d                 
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r123.8<1>:d   r111.0<1;1,0>:d                  {$8.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$14}
        and (16|M0)              r75.2<1>:w    r72.32<1;1,0>:ub  127:w              
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$14.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L11800                                
L11584:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$15.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$8} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L11800                                
L11696:
        sync.nop                             null                             {$8.src}
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4220E500           {$2} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ss[a0.1][A-0xFF80]
        and (16|M0)              r75.2<1>:w    r73.32<1;1,0>:ub  127:w               {$2.dst}
        mov (16|M0)              r112.0<1>:d   r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r112.0<1>:f   r112.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r112.0<1;1,0>:ud {Compacted,F@1}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$0} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L11800:
        shl (16|M0)              r112.0<1>:d   r78.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,$0.src}
        shl (16|M0)              r72.0<1>:d    r78.0<1;1,0>:d    9:w               {Compacted,$8.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r79.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r79.0<1;1,0>:d    9:w               {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r78.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r79.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L12784                                
L12352:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80600000:a0.1        0x4210D500           {I@2,$4} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        sync.allwr                           ($12,$14)                
        mov (8|M0)               r120.0<1>:d   r97.8<1;1,0>:d                   {$4.dst}
        sync.allwr                           ($6,$13)                
        mov (8|M0)               r120.8<1>:f   r99.8<1;1,0>:f                   {$15.dst}
        sync.nop                             null                             {$5.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r101.8<1;1,0>:d                  {$3.dst}
        mov (8|M0)               r121.8<1>:d   r103.8<1;1,0>:d                  {$7.dst}
        sync.nop                             null                             {$0.dst}
        mov (8|M0)               r122.0<1>:d   r105.8<1;1,0>:d                 
        sync.allwr                           ($3,$4)                
        mov (8|M0)               r122.8<1>:d   r107.8<1;1,0>:d                  {$2.dst}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r109.8<1;1,0>:d                 
        sync.nop                             null                             {$10.dst}
        mov (8|M0)               r123.8<1>:d   r111.8<1;1,0>:d                  {$8.dst}
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$7}
        and (16|M0)              r75.2<1>:w    r72.48<1;1,0>:ub  127:w              
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$7.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L13008                                
L12784:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$13.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L13008                                
L12896:
        sync.nop                             null                             {$3.src}
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4220E500           {$14} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ss[a0.1][A-0xFF80]
        and (16|M0)              r75.2<1>:w    r73.48<1;1,0>:ub  127:w               {$14.dst}
        mov (16|M0)              r112.0<1>:d   r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r112.0<1>:f   r112.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r112.0<1;1,0>:ud {F@1}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L13008:
(W)     mov (1|M0)               f2.0<1>:uw    r4.3<0;1,0>:uw                  
(W&~f2.0) jmpi                               L13664                                
L13040:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r84.10<0;1,0>:d   0:w              
        cmp (1|M0)    (eq)f2.1   null<1>:d     r84.10<0;1,0>:d   r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f2.0   null<1>:d     r84.10<0;1,0>:d   r70.4<0;1,0>:d  
(W)     mov (1|M0)               r84.2<1>:hf   0x1:hf                             
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r84.11<0;1,0>:d   0:w              
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r84.11<0;1,0>:d   r70.7<0;1,0>:d  
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r84.11<0;1,0>:d   r70.5<0;1,0>:d  
        cmp (1|M0)    (eq)f0.0   null<1>:d     r84.10<0;1,0>:d   r70.2<0;1,0>:d  
(f3.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw              {F@1}
(f2.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(f2.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r84.11<0;1,0>:d   r70.3<0;1,0>:d  
(f3.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(f3.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        xor (1|M0)    (ne)f1.1   null<1>:uw    r75.2<0;1,0>:uw   0x1:uw              {I@1}
(W)     mov (1|M0)               r84.3<1>:uw   f1.1<0;1,0>:uw                  
(f1.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(f0.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f0.0   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(f3.1)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(f0.0)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f0.0   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(W&~f0.0) jmpi                               L13664                                
L13440:
        cmp (1|M0)    (eq)f3.1   null<1>:d     r87.0<0;1,0>:d    2143363909:d              
(W&f3.1) jmpi                                L13664                                
L13472:
        sync.nop                             null                             {Compacted,A@1}
        sync.nop                             null                             {Compacted,$9.src}
        mov (2|M0)               r72.0<1>:d    tm0.0<1;1,0>:ud                  {$3.src}
(W)     mov (1|M0)               r75.2<1>:hf   0x2:hf                              {A@1}
(f2.0)  sel (1|M0)               r72.2<1>:d    r75.2<0;1,0>:w    3:w               {F@1}
(W)     mov (1|M0)               r75.2<1>:hf   0.0:hf                              {I@1}
(f2.1)  mov (1|M0)               r72.2<1>:d    1:w                              
(f2.1)  sel (1|M0)               r72.3<1>:d    r75.2<0;1,0>:w    0:w               {F@1}
(f3.0)  mov (1|M0)               r72.2<1>:d    0:w                              
(f3.0)  mov (1|M0)               r72.3<1>:d    0:w                              
        shl (1|M0)               r72.1<1>:q    r72.1<0;1,0>:q    3:w               {I@1}
        add (1|M0)               r70.0<1>:q    r4.6<0;1,0>:q     r72.1<0;1,0>:q   {I@1}
        send.ugm (1|M0)          null     r70  r72:2  0x0            0x04000784           {I@1,$10} // wr:2+2, rd:0; store.ugm.d64.a64
L13664:
        add (1|M0)               r84.1<1>:q    r84.5<0;1,0>:q    2:w              
        cmp (1|M0)    (eq)f3.0   null<1>:d     r84.3<0;1,0>:d    r69.15<0;1,0>:d  {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r84.2<0;1,0>:ud   r69.14<0;1,0>:ud
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r84.3<0;1,0>:d    r69.15<0;1,0>:d 
(W&~f3.0) jmpi                               L14160                                
L13744:
        sync.allrd                           ($9,$10)                
        shl (1|M0)               r72.0<1>:q    r84.1<0;1,0>:q    9:w               {Compacted,$3.src}
        shl (1|M0)               r75.1<1>:q    r84.1<0;1,0>:q    6:w              
        add (1|M0)               r72.0<1>:q    r4.7<0;1,0>:q     r72.0<0;1,0>:q   {Compacted,I@2}
        shl (1|M0)               r84.1<1>:q    r84.1<0;1,0>:q    7:w              
        send.ugm (1|M0)          r5       r72  null:0  0x0            0x024AF580           {I@2,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r72.0<1>:q    r72.0<0;1,0>:q    256:w               {Compacted,$1.src}
        send.ugm (1|M0)          r76      r72  null:0  0x0            0x024AF580           {I@1,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r72.0<1>:q    r69.1<0;1,0>:q    r75.1<0;1,0>:q   {Compacted,$11.src}
        send.ugm (1|M0)          r72      r72  null:0  0x0            0x0210D580           {I@1,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80600000:a0.1        0x4200D504           {$15} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        add (1|M0)               r72.0<1>:q    r70.5<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$15.src}
        sync.allwr                           ($4,$14)                
        send.ugm (1|M0)          r96      r72  null:0  0x0            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r70.6<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$12.src}
        sync.allwr                           ($13,$15)                
        send.ugm (1|M0)          r98      r72  null:0  0x0            0x0220E580           {I@1,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r70.7<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$6.src}
        sync.allwr                           ($3,$12)                
        send.ugm (1|M0)          r100     r72  null:0  0x0            0x0220E580           {I@1,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r75.6<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$5.src}
        send.ugm (1|M0)          r102     r72  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r75.7<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$7.src}
        sync.nop                             null                             {Compacted,$5.dst}
        send.ugm (1|M0)          r104     r72  null:0  0x0            0x0220E580           {I@1,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.2<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$0.src}
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r106     r72  null:0  0x0            0x0220E580           {I@1,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.3<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$4.src}
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r108     r72  null:0  0x0            0x0220E580           {I@1,$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.4<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$2.src}
        sync.nop                             null                             {Compacted,$10.dst}
        send.ugm (1|M0)          r110     r72  null:0  0x0            0x0220E580           {I@1,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L14160:
        mov (2|M0)               r84.12<1>:d   0x1:v                              
        or (2|M0)                r84.12<1>:d   r84.10<1;1,0>:d   r84.12<1;1,0>:d  {I@1}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r84.12<0;1,0>:ud  r69.14<0;1,0>:ud
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d 
(W&~f2.1) jmpi                               L21312                                
L14256:
        sync.nop                             null                             {Compacted,$6.dst}
        shl (16|M0)              r112.0<1>:d   r29.0<1;1,0>:d    12:w               {Compacted,$12.dst}
        sync.allrd                           ($8,$9,$10)                
        shl (16|M0)              r72.0<1>:d    r29.0<1;1,0>:d    9:w               {Compacted,$3.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r30.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r30.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r29.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r29.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r30.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r30.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L15216                                
L14832:
        sync.nop                             null                             {$1.dst}
        mov (8|M0)               r120.0<1>:f   r67.0<1;1,0>:f                   {$13.dst}
        mov (8|M0)               r120.8<1>:d   r65.0<1;1,0>:d                   {$9.dst}
        sync.nop                             null                             {$15.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r63.0<1;1,0>:d                   {$10.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r121.8<1>:d   r61.0<1;1,0>:d                   {$6.dst}
        sync.nop                             null                             {Compacted,$13.dst}
        mov (8|M0)               r122.0<1>:d   r59.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r122.8<1>:d   r57.0<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r55.0<1;1,0>:d                   {$8.dst}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r123.8<1>:d   r53.0<1;1,0>:d                  
        and (16|M0)              r75.2<1>:w    r83.0<1;1,0>:ub   127:w              
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$13}
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$13.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L15424                                
L15216:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$3.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$14} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L15424                                
L15328:
        sync.nop                             null                             {$8.dst}
        and (16|M0)              r75.2<1>:w    r83.0<1;1,0>:ub   127:w               {$7.dst}
        mov (16|M0)              r73.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r73.0<1>:d    r73.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r73.0<1>:f    r73.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        sync.nop                             null                             {Compacted,F@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r73.0<1;1,0>:ud  {Compacted,$14.src}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L15424:
        shl (16|M0)              r112.0<1>:d   r31.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,$9.src}
        shl (16|M0)              r72.0<1>:d    r31.0<1;1,0>:d    9:w               {Compacted,$14.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r32.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r32.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r31.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r31.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r32.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L16368                                
L15984:
        sync.nop                             null                             {$1.dst}
        mov (8|M0)               r120.0<1>:d   r67.8<1;1,0>:d                   {$13.dst}
        mov (8|M0)               r120.8<1>:f   r65.8<1;1,0>:f                   {$9.dst}
        sync.nop                             null                             {$15.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r63.8<1;1,0>:d                   {$10.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r121.8<1>:d   r61.8<1;1,0>:d                   {$6.dst}
        sync.nop                             null                             {Compacted,$13.dst}
        mov (8|M0)               r122.0<1>:d   r59.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r122.8<1>:d   r57.8<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r55.8<1;1,0>:d                   {$8.dst}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r123.8<1>:d   r53.8<1;1,0>:d                  
        and (16|M0)              r75.2<1>:w    r83.16<1;1,0>:ub  127:w              
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$10}
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$10.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L16576                                
L16368:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$1.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$15} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L16576                                
L16480:
        sync.nop                             null                             {$8.dst}
        and (16|M0)              r75.2<1>:w    r83.16<1;1,0>:ub  127:w               {$7.dst}
        mov (16|M0)              r73.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r73.0<1>:d    r73.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r73.0<1>:f    r73.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        sync.nop                             null                             {Compacted,F@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r73.0<1;1,0>:ud  {Compacted,$15.src}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$12} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L16576:
        sync.nop                             null                             {Compacted,$5.dst}
        shl (16|M0)              r112.0<1>:d   r25.0<1;1,0>:d    12:w               {Compacted,$4.dst}
        sync.nop                             null                             {Compacted,$12.src}
        shl (16|M0)              r72.0<1>:d    r25.0<1;1,0>:d    9:w               {Compacted,$15.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r26.0<1;1,0>:d    12:w              
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r26.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r25.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r25.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r26.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r26.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L17520                                
L17152:
        sync.nop                             null                             {Compacted,$1.dst}
        mov (8|M0)               r120.0<1>:f   r68.0<1;1,0>:f                   {$13.dst}
        mov (8|M0)               r120.8<1>:d   r66.0<1;1,0>:d                   {$9.dst}
        sync.nop                             null                             {Compacted,$15.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r64.0<1;1,0>:d                   {$10.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r121.8<1>:d   r62.0<1;1,0>:d                   {$6.dst}
        sync.nop                             null                             {Compacted,$13.dst}
        mov (8|M0)               r122.0<1>:d   r60.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r122.8<1>:d   r58.0<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r56.0<1;1,0>:d                   {$8.dst}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r123.8<1>:d   r54.0<1;1,0>:d                  
        and (16|M0)              r75.2<1>:w    r83.32<1;1,0>:ub  127:w              
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$6}
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$6.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L17728                                
L17520:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$8} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$8.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$5} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L17728                                
L17632:
        sync.nop                             null                             {$8.dst}
        and (16|M0)              r75.2<1>:w    r83.32<1;1,0>:ub  127:w               {$7.dst}
        mov (16|M0)              r73.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r73.0<1>:d    r73.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r73.0<1>:f    r73.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        sync.nop                             null                             {Compacted,F@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r73.0<1;1,0>:ud  {Compacted,$5.src}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L17728:
        shl (16|M0)              r112.0<1>:d   r27.0<1;1,0>:d    12:w               {Compacted}
        sync.nop                             null                             {Compacted,$2.src}
        shl (16|M0)              r72.0<1>:d    r27.0<1;1,0>:d    9:w               {Compacted,$5.src}
(W)     mov (1|M0)               r73.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r120.0<1>:d   r28.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r112.0<1>:d   r112.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r112.0<1>:ud  r112.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r72.0<1>:d    r28.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r116.0<1>:ud  r120.0<1;0>:ud    r72.0<1;0>:ud     r73.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r113.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r117.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r114.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r72.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r72.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r72.0<1>:d    r27.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r118.0<1>:ud  acc0.0<1;0>:ud    r120.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r27.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r115.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r72.0<1>:d    r28.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r28.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r119.0<1>:ud  r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L18672                                
L18288:
        sync.nop                             null                             {$1.dst}
        mov (8|M0)               r120.0<1>:d   r68.8<1;1,0>:d                   {$13.dst}
        mov (8|M0)               r120.8<1>:f   r66.8<1;1,0>:f                   {$9.dst}
        sync.nop                             null                             {$15.dst}
        sync.allrd                           ($4,$7)                
        mov (8|M0)               r121.0<1>:d   r64.8<1;1,0>:d                   {$10.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r121.8<1>:d   r62.8<1;1,0>:d                   {$6.dst}
        sync.nop                             null                             {Compacted,$13.dst}
        mov (8|M0)               r122.0<1>:d   r60.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$10.dst}
        mov (8|M0)               r122.8<1>:d   r58.8<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$11.src}
        mov (8|M0)               r123.0<1>:d   r56.8<1;1,0>:d                   {$8.dst}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r123.8<1>:d   r54.8<1;1,0>:d                  
        and (16|M0)              r75.2<1>:w    r83.48<1;1,0>:ub  127:w              
        sync.nop                             null                             {A@1}
        dpas.8x8 (16|M0)         r120:f        null:f            r112:hf           r120.0:hf        {$9}
        mov (16|M0)              r72.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r72.0<1>:d    r72.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r72.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r87.0<1>:f    r87.0<1;0>:f      acc0.0<1;0>:f     r120.0<1>:f      {Compacted,$9.dst}
        mad (16|M0)              r88.0<1>:f    r88.0<1;0>:f      acc0.0<1;0>:f     r121.0<1>:f      {Compacted}
        mad (16|M0)              r94.0<1>:f    r94.0<1;0>:f      acc0.0<1;0>:f     r122.0<1>:f      {Compacted}
        mad (16|M0)              r95.0<1>:f    r95.0<1;0>:f      acc0.0<1;0>:f     r123.0<1>:f      {Compacted}
        mad (16|M0)              r92.0<1>:f    r92.0<1;0>:f      acc0.0<1;0>:f     r124.0<1>:f      {Compacted}
        mad (16|M0)              r93.0<1>:f    r93.0<1;0>:f      acc0.0<1;0>:f     r125.0<1>:f      {Compacted}
        mad (16|M0)              r85.0<1>:f    r85.0<1;0>:f      acc0.0<1;0>:f     r126.0<1>:f      {Compacted}
        mad (16|M0)              r86.0<1>:f    r86.0<1;0>:f      acc0.0<1;0>:f     r127.0<1>:f      {Compacted}
(W)     jmpi                                 L18880                                
L18672:
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {F@7,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r114.0<1;0>:ud    r112.0<1;0>:ud    r113.0<1>:ud     {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r116.0<1;0>:ud    acc0.0<1;0>:ud    r115.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r118.0<1;0>:ud    acc0.0<1;0>:ud    r117.0<1>:ud     // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r119.0<1>:ud     {$1.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$11} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f0.1) jmpi                               L18880                                
L18784:
        sync.nop                             null                             {$8.dst}
        and (16|M0)              r75.2<1>:w    r83.48<1;1,0>:ub  127:w               {$7.dst}
        mov (16|M0)              r73.0<1>:d    r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r73.0<1>:d    r73.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r73.0<1>:f    r73.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        sync.nop                             null                             {Compacted,F@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r73.0<1;1,0>:ud  {Compacted,$11.src}
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$4} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
L18880:
(W)     mov (1|M0)               f2.1<1>:uw    r4.3<0;1,0>:uw                  
(W&~f2.1) jmpi                               L19408                                
L18912:
        cmp (1|M0)    (eq)f3.1   null<1>:d     r84.12<0;1,0>:d   r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f3.0   null<1>:d     r84.12<0;1,0>:d   r70.4<0;1,0>:d  
(W)     mov (1|M0)               r84.2<1>:hf   0x1:hf                             
        cmp (1|M0)    (eq)f0.0   null<1>:d     r84.12<0;1,0>:d   r70.2<0;1,0>:d  
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:d     r84.13<0;1,0>:d   r70.7<0;1,0>:d  
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r84.13<0;1,0>:d   r70.5<0;1,0>:d  
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r84.13<0;1,0>:d   r70.3<0;1,0>:d  
(f3.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw              {F@1}
(f3.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f1.1   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(f0.0)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(f1.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        xor (1|M0)    (ne)f2.0   null<1>:uw    r75.2<0;1,0>:uw   0x1:uw              {I@1}
(f2.0)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(f1.1)  sel (1|M0)               r84.3<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
(f2.1)  sel (1|M0)               r75.2<1>:uw   r84.2<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f1.1   null<1>:uw    r84.3<0;1,0>:uw   r75.2<0;1,0>:uw  {I@1}
(W&~f1.1) jmpi                               L19408                                
L19216:
        cmp (1|M0)    (eq)f0.0   null<1>:d     r87.0<0;1,0>:d    2143363909:d              
(W&f0.0) jmpi                                L19408                                
L19248:
        sync.nop                             null                             {Compacted,A@1}
        sync.nop                             null                             {Compacted,$4.src}
        mov (2|M0)               r72.0<1>:d    tm0.0<1;1,0>:ud                  {$11.src}
(W)     mov (1|M0)               r75.2<1>:hf   0x2:hf                              {A@1}
(f3.0)  sel (1|M0)               r72.2<1>:d    r75.2<0;1,0>:w    3:w               {F@1}
(W)     mov (1|M0)               r75.2<1>:hf   0.0:hf                              {I@1}
(f3.1)  mov (1|M0)               r72.2<1>:d    1:w                              
(f3.1)  sel (1|M0)               r72.3<1>:d    r75.2<0;1,0>:w    0:w               {F@1}
        shl (1|M0)               r72.1<1>:q    r72.1<0;1,0>:q    3:w               {I@1}
        add (1|M0)               r70.0<1>:q    r4.6<0;1,0>:q     r72.1<0;1,0>:q   {I@1}
        send.ugm (1|M0)          null     r70  r72:2  0x0            0x04000784           {I@1,$7} // wr:2+2, rd:0; store.ugm.d64.a64
L19408:
        add (1|M0)               r84.6<1>:q    r84.5<0;1,0>:q    3:w              
        cmp (1|M0)    (eq)f2.0   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r84.12<0;1,0>:ud  r69.14<0;1,0>:ud
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d 
(W&f2.0) jmpi                                L20816                                
L19488:
(W)     jmpi                                 L21312                                
L19504:
        sync.allwr                           ($1,$11)                
        sync.allrd                           ($3,$4,$7,$9,$10,$15)                
        xor (16|M0)              r72.0<1>:d    r5.0<1;1,0>:d     r6.0<1;1,0>:d    {$8.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r8.0<1;0>:ud      r72.0<1;0>:ud     r7.0<1>:ud       {I@1} // s0^s1^s2
        sync.allwr                           ($0,$13)                
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4220E500           {I@1,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a32.ss[a0.1][A-0xFF80]
        sync.nop                             null                             {$4.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r77.0<1;0>:ud     acc0.0<1;0>:ud    r76.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r79.0<1;0>:ud     acc0.0<1;0>:ud    r78.0<1>:ud      // s0^s1^s2
        sync.allwr                           ($12,$14)                
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r97.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$6.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r99.0<1;0>:ud     acc0.0<1;0>:ud    r98.0<1>:ud      {$15.dst} // s0^s1^s2
        add (1|M0)               r84.1<1>:q    r84.5<0;1,0>:q    2:w              
        sync.nop                             null                             {$5.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<1>:ud     {$3.dst} // s0^s1^s2
        cmp (1|M0)    (eq)f1.1   null<1>:d     r84.3<0;1,0>:d    r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r103.0<1;0>:ud    acc0.0<1;0>:ud    r102.0<1>:ud     {$7.dst} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r105.0<1;0>:ud    acc0.0<1;0>:ud    r104.0<1>:ud     // s0^s1^s2
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r84.2<0;1,0>:ud   r69.14<0;1,0>:ud
        sync.nop                             null                             {$3.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r107.0<1;0>:ud    acc0.0<1;0>:ud    r106.0<1>:ud     {$2.dst} // s0^s1^s2
        sync.nop                             null                             {$2.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r108.0<1>:ud     // s0^s1^s2
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r84.3<0;1,0>:d    r69.15<0;1,0>:d 
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r111.0<1;0>:ud    acc0.0<1;0>:ud    r110.0<1>:ud     {$10.dst} // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<1>:ud      {$8.dst} // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$10} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f1.1) jmpi                               L20304                                
L19968:
        shl (1|M0)               r72.0<1>:q    r84.1<0;1,0>:q    9:w               {Compacted,$10.src}
        shl (1|M0)               r75.1<1>:q    r84.1<0;1,0>:q    6:w              
        add (1|M0)               r72.0<1>:q    r4.7<0;1,0>:q     r72.0<0;1,0>:q   {Compacted,I@2}
        shl (1|M0)               r84.1<1>:q    r84.1<0;1,0>:q    7:w              
        send.ugm (1|M0)          r5       r72  null:0  0x0            0x024AF580           {I@2,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r72.0<1>:q    r72.0<0;1,0>:q    256:w               {Compacted,$11.src}
        send.ugm (1|M0)          r76      r72  null:0  0x0            0x024AF580           {I@1,$4} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r72.0<1>:q    r69.1<0;1,0>:q    r75.1<0;1,0>:q   {Compacted,$4.src}
        send.ugm (1|M0)          r72      r72  null:0  0x0            0x0210D580           {I@1,$9} // wr:1+0, rd:1; load.ugm.d32x16t.a64
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80600000:a0.1        0x4200D504           {$9} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF40]
        add (1|M0)               r72.0<1>:q    r70.5<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$9.src}
        send.ugm (1|M0)          r96      r72  null:0  0x0            0x0220E580           {I@1,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r70.6<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$14.src}
        send.ugm (1|M0)          r98      r72  null:0  0x0            0x0220E580           {I@1,$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r70.7<0;1,0>:q    r84.1<0;1,0>:q   {$13.src}
        send.ugm (1|M0)          r100     r72  null:0  0x0            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r75.6<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$12.src}
        send.ugm (1|M0)          r102     r72  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r75.7<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$7.src}
        send.ugm (1|M0)          r104     r72  null:0  0x0            0x0220E580           {I@1,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.2<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$0.src}
        send.ugm (1|M0)          r106     r72  null:0  0x0            0x0220E580           {I@1,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.3<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$3.src}
        send.ugm (1|M0)          r108     r72  null:0  0x0            0x0220E580           {I@1,$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r72.0<1>:q    r84.4<0;1,0>:q    r84.1<0;1,0>:q   {$2.src}
        send.ugm (1|M0)          r110     r72  null:0  0x0            0x0220E580           {I@1,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L20304:
        mov (2|M0)               r75.16<1>:w   0x1010101:v                              
        or (2|M0)                r84.1<1>:d    r84.10<1;1,0>:d   r75.16<1;1,0>:w  {I@1}
        cmp (1|M0)    (eq)f0.0   null<1>:d     r84.2<0;1,0>:d    r69.15<0;1,0>:d  {I@1}
(f0.0)  cmp (1|M0)    (lt)f0.0   null<1>:ud    r84.1<0;1,0>:ud   r69.14<0;1,0>:ud
(~f0.0) cmp (1|M0)    (lt)f0.0   null<1>:d     r84.2<0;1,0>:d    r69.15<0;1,0>:d 
(W&~f0.0) jmpi                               L21312                                
L20400:
        sync.nop                             null                             {Compacted,$6.dst}
        sync.nop                             null                             {Compacted,$10.src}
        xor (16|M0)              r72.0<1>:d    r29.0<1;1,0>:d    r30.0<1;1,0>:d   {Compacted,$12.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r32.0<1;0>:ud     r72.0<1;0>:ud     r31.0<1>:ud      {I@1} // s0^s1^s2
(W)     send.ugm (1|M0)          r72      r69  null:0  0x80400000:a0.1        0x4210D500           {I@1,$9} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        sync.nop                             null                             {Compacted,$5.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r26.0<1;0>:ud     acc0.0<1;0>:ud    r25.0<1>:ud      {$4.dst} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r28.0<1;0>:ud     acc0.0<1;0>:ud    r27.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$1.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r68.0<1;0>:ud     acc0.0<1;0>:ud    r67.0<1>:ud      {$13.dst} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r66.0<1;0>:ud     acc0.0<1;0>:ud    r65.0<1>:ud      {$9.dst} // s0^s1^s2
        add (1|M0)               r84.6<1>:q    r84.5<0;1,0>:q    3:w              
        sync.nop                             null                             {$15.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r64.0<1;0>:ud     acc0.0<1;0>:ud    r63.0<1>:ud      {$10.dst} // s0^s1^s2
        cmp (1|M0)    (eq)f3.1   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r62.0<1;0>:ud     acc0.0<1;0>:ud    r61.0<1>:ud      {$14.dst} // s0^s1^s2
        sync.nop                             null                             {Compacted,$13.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r60.0<1;0>:ud     acc0.0<1;0>:ud    r59.0<1>:ud      // s0^s1^s2
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r84.12<0;1,0>:ud  r69.14<0;1,0>:ud
        sync.nop                             null                             {Compacted,$10.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r58.0<1;0>:ud     acc0.0<1;0>:ud    r57.0<1>:ud      {$11.dst} // s0^s1^s2
        sync.nop                             null                             {Compacted,$7.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r56.0<1;0>:ud     acc0.0<1;0>:ud    r55.0<1>:ud      {$8.dst} // s0^s1^s2
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r84.13<0;1,0>:d   r69.15<0;1,0>:d 
        sync.nop                             null                             {Compacted,$4.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r54.0<1;0>:ud     acc0.0<1;0>:ud    r53.0<1>:ud      {$14.dst} // s0^s1^s2
        sync.nop                             null                             {$9.dst}
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r83.0<1>:ud      // s0^s1^s2
(W)     send.ugm (1|M0)          null     r69  r72:1  0x80400000:a0.1        0x4200D504           {I@1,$15} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
(W&~f3.1) jmpi                               L21312                                
L20816:
        sync.nop                             null                             {Compacted,$4.dst}
        shl (1|M0)               r53.0<1>:q    r84.6<0;1,0>:q    9:w               {Compacted,$14.dst}
        shl (1|M0)               r84.1<1>:q    r84.6<0;1,0>:q    6:w              
        add (1|M0)               r53.0<1>:q    r4.7<0;1,0>:q     r53.0<0;1,0>:q   {I@2}
        shl (1|M0)               r84.6<1>:q    r84.6<0;1,0>:q    7:w              
        send.ugm (1|M0)          r29      r53  null:0  0x0            0x024AF580           {I@2,$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r53.0<1>:q    r53.0<0;1,0>:q    256:w               {$6.src}
        sync.allrd                           ($7,$15)                
        add (1|M0)               r72.0<1>:q    r84.4<0;1,0>:q    r84.6<0;1,0>:q   {@2,$11.src}
        send.ugm (1|M0)          r25      r53  null:0  0x0            0x024AF580           {I@2,$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r53.0<1>:q    r69.1<0;1,0>:q    r84.1<0;1,0>:q   {Compacted,$5.src}
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r83      r53  null:0  0x0            0x0210D580           {I@1,$8} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        add (1|M0)               r53.0<1>:q    r70.5<0;1,0>:q    r84.6<0;1,0>:q   {$8.src}
        sync.nop                             null                             {$13.dst}
        send.ugm (1|M0)          r67      r53  null:0  0x0            0x0220E580           {I@1,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r70.6<0;1,0>:q    r84.6<0;1,0>:q   {$1.src}
        send.ugm (1|M0)          r65      r53  null:0  0x0            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r70.7<0;1,0>:q    r84.6<0;1,0>:q   {$9.src}
        sync.nop                             null                             {$10.dst}
        send.ugm (1|M0)          r63      r53  null:0  0x0            0x0220E580           {I@1,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r75.6<0;1,0>:q    r84.6<0;1,0>:q   {$15.src}
        sync.nop                             null                             {Compacted,$6.dst}
        send.ugm (1|M0)          r61      r53  null:0  0x0            0x0220E580           {I@1,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r75.7<0;1,0>:q    r84.6<0;1,0>:q   {$14.src}
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r59      r53  null:0  0x0            0x0220E580           {I@1,$13} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r84.2<0;1,0>:q    r84.6<0;1,0>:q   {$13.src}
        sync.nop                             null                             {$11.dst}
        send.ugm (1|M0)          r57      r53  null:0  0x0            0x0220E580           {I@1,$10} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r53.0<1>:q    r84.3<0;1,0>:q    r84.6<0;1,0>:q   {$10.src}
        sync.nop                             null                             {$8.dst}
        send.ugm (1|M0)          r55      r53  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r53      r72  null:0  0x0            0x0220E580           {$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L21312:
        add (1|M0)               r84.5<1>:q    r84.5<0;1,0>:q    2:w              
        cmp (1|M0)    (eq)f3.0   null<1>:d     r84.11<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r84.10<0;1,0>:ud  r69.14<0;1,0>:ud
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r84.11<0;1,0>:d   r69.15<0;1,0>:d 
(W&f3.0) jmpi                                L8080                                
L21392:
(W)     mov (1|M0)               f2.0<1>:uw    r69.2<0;1,0>:uw                 
(W&f2.0) jmpi                                L21480                                
L21424:
(W)     send.ugm (1|M0)          r92      r69  null:0  0x80400000:a0.1        0x4210D500           {$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF80]
        mov (16|M0)              r87.0<1>:ud   r92.0<1;1,0>:ud                  {Compacted,$0.dst}
        mov (16|M0)              r88.0<1>:ud   r92.0<1;1,0>:ud                  {Compacted}
        mov (32|M0)              r94.0<1>:ud   r87.0<1;1,0>:ud                  {Compacted,I@1}
        mov (32|M0)              r92.0<1>:f    r87.0<1;1,0>:f                   {Compacted}
        mov (32|M0)              r85.0<1>:f    r87.0<1;1,0>:f                   {Compacted}
L21480:
        mul (1|M0)               acc0.0<1>:d   r84.0<0;1,0>:d    r4.12<0;1,0>:uw 
        sync.nop                             null                             {Compacted,$11.dst}
        mach (1|M0)              r6.0<1>:d     r84.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted,$1.dst}
        mul (16|M0)              r123.0<1>:f   r75.0<0;1,0>:f    r87.0<1;1,0>:f   {Compacted,$12.src}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r89.0<0;1,0>:d    r4.12<0;1,0>:uw 
        sync.nop                             null                             {Compacted,$7.src}
        mov (1|M0)               r70.1<1>:d    r6.0<0;1,0>:d                    {Compacted,@3,$10.src}
        mach (1|M0)              r6.0<1>:d     r89.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r70.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@4}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mul (1|M0)               acc0.0<1>:d   r91.0<0;1,0>:d    r4.12<0;1,0>:uw 
        sync.nop                             null                             {Compacted,$7.dst}
        mov (1|M0)               r103.1<1>:d   r6.0<0;1,0>:d                    {Compacted,@3,$14.dst}
        mach (1|M0)              r6.0<1>:d     r91.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        shl (1|M0)               r70.0<1>:q    r70.0<0;1,0>:q    2:w               {Compacted}
        mov (1|M0)               r103.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@5}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mul (1|M0)               acc0.0<1>:d   r90.0<0;1,0>:d    r4.12<0;1,0>:uw 
        sync.nop                             null                             {Compacted,$12.dst}
        sync.nop                             null                             {Compacted,$5.src}
        add (1|M0)               r96.0<1>:q    r69.2<0;1,0>:q    r70.0<0;1,0>:q   {Compacted,@3,$4.dst}
        mov (1|M0)               r70.1<1>:d    r6.0<0;1,0>:d                    {Compacted}
        mach (1|M0)              r6.0<1>:d     r90.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r70.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@3}
        mov (1|M0)               r91.1<1>:d    r6.0<0;1,0>:d                    {Compacted,I@1}
(W)     send.ugm (1|M0)          r6       r69  null:0  0x80800000:a0.1        0x4210D500           {I@1,$3} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFF00]
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        shl (1|M0)               r103.0<1>:q   r103.0<0;1,0>:q   2:w               {Compacted}
        mov (1|M0)               r91.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@2}
        mul (16|M0)              r7.0<1>:f     r75.0<0;1,0>:f    r88.0<1;1,0>:f   {Compacted}
(W)     mov (1|M0)               f1.1<1>:uw    r75.18<0;1,0>:uw                
        shl (1|M0)               r70.0<1>:q    r70.0<0;1,0>:q    2:w               {Compacted}
        sync.nop                             null                             {Compacted,$14.src}
        add (1|M0)               r122.0<1>:q   r69.2<0;1,0>:q    r103.0<0;1,0>:q  {Compacted,@3,$4.src}
        shl (1|M0)               r91.0<1>:q    r91.0<0;1,0>:q    2:w               {Compacted,F@2}
        send.ugm (1|M0)          null     r96  r123:1  0x0            0x0200D584           {$11} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r122  r7:1  0x0            0x0200D584           {A@1,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        sync.nop                             null                             {Compacted,$0.src}
        mul (16|M0)              r121.0<1>:f   r75.0<0;1,0>:f    r94.0<1;1,0>:f   {Compacted,$4.src}
        mul (16|M0)              r119.0<1>:f   r75.0<0;1,0>:f    r92.0<1;1,0>:f   {Compacted}
        sync.allrd                           ($8,$9,$10,$15)                
        add (1|M0)               r72.0<1>:q    r69.2<0;1,0>:q    r70.0<0;1,0>:q   {Compacted,$3.src}
        add (1|M0)               r120.0<1>:q   r69.2<0;1,0>:q    r91.0<0;1,0>:q   {Compacted,@2,$13.src}
        mul (16|M0)              r7.0<1>:f     r75.0<0;1,0>:f    r95.0<1;1,0>:f   {$2.src}
        send.ugm (1|M0)          null     r72  r121:1  0x0            0x0200D584           {A@2,$12} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r120  r7:1  0x0            0x0200D584           {A@1,$15} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        mul (1|M0)               acc0.0<1>:d   r6.0<0;1,0>:d     r4.12<0;1,0>:uw  {$3.dst}
        mach (1|M0)              r6.0<1>:d     r6.0<0;1,0>:d     r4.6<0;1,0>:d   
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        sync.allwr                           ($4,$8,$10,$14)                
        mov (1|M0)               r77.1<1>:d    r6.0<0;1,0>:d                    {Compacted,@2,$11.dst}
        mov (1|M0)               r77.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r77.0<1>:q    r77.0<0;1,0>:q    2:w               {Compacted,A@1}
        sync.nop                             null                             {Compacted,$11.src}
        add (1|M0)               r110.0<1>:q   r69.2<0;1,0>:q    r77.0<0;1,0>:q   {@1}
        send.ugm (1|M0)          null     r110  r119:1  0x0            0x0200D584           {I@1,$14} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&f1.1) jmpi                                L56224                                
L22128:
(W)     send.ugm (1|M0)          r5       r69  null:0  0x80A00000:a0.1        0x4210D500           {$9} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFEC0]
(W)     mov (1|M0)               f0.0<1>:uw    r75.19<0;1,0>:uw                
        mul (16|M0)              r76.0<1>:f    r75.0<0;1,0>:f    r93.0<1;1,0>:f   {Compacted,$0.src}
        mul (1|M0)               acc0.0<1>:d   r5.0<0;1,0>:d     r4.12<0;1,0>:uw  {$9.dst}
        mach (1|M0)              r6.0<1>:d     r5.0<0;1,0>:d     r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r118.1<1>:d   r6.0<0;1,0>:d                    {Compacted,@2,$9.src}
        mov (1|M0)               r118.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r118.0<1>:q   r118.0<0;1,0>:q   2:w               {Compacted,A@1}
        add (1|M0)               r118.0<1>:q   r69.2<0;1,0>:q    r118.0<0;1,0>:q  {Compacted,I@1}
        send.ugm (1|M0)          null     r118  r76:1  0x0            0x0200D584           {I@1,$0} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f0.0) jmpi                               L56224                                
L22272:
(W)     send.ugm (1|M0)          r87      r69  null:0  0x80000000:a0.1        0x4210D500           {$7} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0x10000]
(W)     mov (1|M0)               f3.1<1>:uw    r75.20<0;1,0>:uw                
        sync.nop                             null                             {Compacted,$15.src}
        mul (16|M0)              r117.0<1>:f   r75.0<0;1,0>:f    r85.0<1;1,0>:f   {Compacted,$1.src}
        mul (1|M0)               acc0.0<1>:d   r87.0<0;1,0>:d    r4.12<0;1,0>:uw  {$7.dst}
        mach (1|M0)              r6.0<1>:d     r87.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        sync.allwr                           ($5,$12)                
        mov (1|M0)               r101.1<1>:d   r6.0<0;1,0>:d                    {Compacted,@2,$3.dst}
        mov (1|M0)               r101.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r101.0<1>:q   r101.0<0;1,0>:q   2:w               {Compacted,A@1}
        add (1|M0)               r111.0<1>:q   r69.2<0;1,0>:q    r101.0<0;1,0>:q  {Compacted,I@1}
        send.ugm (1|M0)          null     r111  r117:1  0x0            0x0200D584           {I@1,$8} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f3.1) jmpi                               L56224                                
L22440:
        mov (16|M0)              r5.0<1>:f     r86.0<1;1,0>:f                   {Compacted}
(W)     jmpi                                 L56088                                
L22464:
        cmp (1|M0)    (eq)f2.1   null<1>:d     r84.2<0;1,0>:d    4:w              
(W)     mov (1|M0)               r89.2<1>:hf   0x1:hf                             
(W)     mov (1|M0)               f2.0<1>:uw    r70.18<0;1,0>:uw                
(f0.0)  sel (1|M0)               r126.0<1>:uw  r89.2<0;1,0>:uw   0x0:uw              {F@1}
(f2.1)  sel (1|M0)               r126.1<1>:uw  r89.2<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f3.0   null<1>:uw    r126.1<0;1,0>:uw  r126.0<0;1,0>:uw {I@1}
(f3.0)  sel (1|M0)               r6.0<1>:d     r90.0<0;1,0>:d    r84.0<0;1,0>:d   {$14.dst}
(W)     mov (1|M0)               r6.4<1>:uw    f3.0<0;1,0>:uw                  
        asr (1|M0)               r75.1<1>:d    r6.0<0;1,0>:d     31:w               {Compacted,I@2}
(W)     mov (1|M0)               f3.0<1>:uw    r70.19<0;1,0>:uw                
        shr (1|M0)               r75.1<1>:ud   r75.1<0;1,0>:ud   0x1D:uw              {I@2}
        add (1|M0)               r75.1<1>:d    r6.0<0;1,0>:d     r75.1<0;1,0>:d   {Compacted,I@1}
        asr (1|M0)               r75.1<1>:d    r75.1<0;1,0>:d    3:w               {I@1}
(~f3.0) mov (1|M0)               r6.0<1>:d     r75.1<0;1,0>:d                   {I@1}
        mul (1|M0)               acc0.0<1>:d   r6.0<0;1,0>:d     r4.0<0;1,0>:uw   {I@1}
        sync.nop                             null                             {Compacted,$9.dst}
        mach (1|M0)              r8.0<1>:d     r6.0<0;1,0>:d     r4.0<0;1,0>:d    {Compacted,$5.dst}
        mov (1|M0)               r7.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r90.3<1>:d    r8.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r90.2<1>:d    r7.0<0;1,0>:d                    {Compacted,I@2}
        mov (32|M0)              r7.0<1>:f     0.0:f                               {Compacted,I@1}
        shl (1|M0)               r90.1<1>:q    r90.1<0;1,0>:q    1:w              
        add (1|M0)               r6.2<1>:q     r3.7<0;1,0>:q     r90.1<0;1,0>:q   {I@1}
(W&f2.0) jmpi                                L22880                                
L22800:
        sync.nop                             null                             {Compacted,F@1}
        sync.allwr                           ($0,$7,$13)                
        sync.nop                             null                             {Compacted,$12.src}
        mov (32|M0)              r72.0<1>:ud   r7.0<1;1,0>:ud                   {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$1.src}
        mov (16|M0)              r109.0<1>:f   0.0:f                               {Compacted}
(W)     jmpi                                 L34320                                
L22880:
(W)     mov (1|M0)               r119.0<1>:uq  r4.7<0;1,0>:uq                   {Compacted}
        sync.nop                             null                             {Compacted,$0.src}
(W)     mov (1|M0)               r118.0<1>:uq  r69.5<0;1,0>:uq                  {$9.src}
        sync.allrd                           ($1,$15)                
(W)     mov (1|M0)               r117.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted,$8.src}
(W)     mov (1|M0)               r116.0<1>:uq  r70.5<0;1,0>:uq                  {Compacted,$2.src}
(W)     mov (1|M0)               r115.0<1>:uq  r70.6<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r114.0<1>:uq  r70.7<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r6.0<1>:uq    r6.2<0;1,0>:uq                   {I@7}
        sync.allwr                           ($8,$10,$11,$14)                
        send.ugm (1|M0)          r76      r119  null:0  0x0            0x024AF580           {I@7,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r85      r118  null:0  0x0            0x024AF580           {I@6,$15} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.allwr                           ($0,$2,$12)                
        send.ugm (1|M0)          r108     r117  null:0  0x0            0x0210D580           {I@5,$1} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.allwr                           ($3,$5)                
        send.ugm (1|M0)          r100     r116  null:0  0x0            0x0220E580           {I@4,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r102     r115  null:0  0x0            0x0220E580           {I@3,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.allwr                           ($5,$14)                
        send.ugm (1|M0)          r104     r114  null:0  0x0            0x0220E580           {I@2,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.allwr                           ($3,$4,$15)                
        send.ugm (1|M0)          r106     r6  null:0  0x0            0x0220E580           {I@1,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               f1.1<1>:uw    r70.17<0;1,0>:uw                
(W&f1.1) jmpi                                L23448                                
L23200:
(W)     mov (1|M0)               r113.0<1>:uq  r69.4<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r112.0<1>:uq  r69.3<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r111.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted,$2.src}
        sync.nop                             null                             {Compacted,$9.src}
(W)     mov (1|M0)               r110.0<1>:uq  r70.5<0;1,0>:uq                  {Compacted,$11.src}
        sync.nop                             null                             {Compacted,F@1}
(W)     mov (1|M0)               r109.0<1>:uq  r70.6<0;1,0>:uq                  {Compacted,$1.src}
        sync.allwr                           ($6,$13)                
        sync.nop                             null                             {Compacted,$7.src}
(W)     mov (1|M0)               r99.0<1>:uq   r70.7<0;1,0>:uq                  {Compacted,$15.dst}
(W)     mov (1|M0)               r6.0<1>:uq    r6.2<0;1,0>:uq                   {Compacted}
        sync.nop                             null                             {Compacted,$11.dst}
        send.ugm (1|M0)          r37      r113  null:0  0x0            0x024AF580           {I@7,$13} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r33      r112  null:0  0x0            0x024AF580           {I@6,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r82      r111  null:0  0x40000            0x0210D580           {I@5,$2} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r51      r110  null:0  0x80000            0x0220E580           {I@4,$11} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        send.ugm (1|M0)          r49      r109  null:0  0x80000            0x0220E580           {I@3,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r47      r99  null:0  0x80000            0x0220E580           {I@2,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$8.dst}
        send.ugm (1|M0)          r45      r6  null:0  0x80000            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L23448:
        sync.allwr                           ($0,$7,$13)                
        sync.nop                             null                             {Compacted,$12.src}
        mov (32|M0)              r72.0<1>:ud   r7.0<1;1,0>:ud                   {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$1.src}
        mov (16|M0)              r109.0<1>:d   0:w                               {Compacted,$4.src}
        sync.nop                             null                             {Compacted,$9.src}
        mov (1|M0)               r6.3<1>:q     0:w                               {$6.src}
L23520:
(W)     mov (1|M0)               f0.0<1>:uw    r70.16<0;1,0>:uw                
(W&f0.0) jmpi                                L33040                                
L23552:
        sync.allwr                           ($1,$8)                
        shl (16|M0)              r92.0<1>:d    r76.0<1;1,0>:d    12:w               {Compacted,$12.dst}
        sync.nop                             null                             {Compacted,$15.src}
        shl (16|M0)              r5.0<1>:d     r76.0<1;1,0>:d    9:w               {Compacted,$0.src}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        sync.nop                             null                             {Compacted,$9.src}
        shl (16|M0)              r110.0<1>:d   r77.0<1;1,0>:d    12:w               {Compacted,$11.src}
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r77.0<1;1,0>:d    9:w               {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x4:uw             
        sync.nop                             null                             {$5.src}
        bfn.0xEA (16|M0)         r96.0<1>:ud   r110.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {@2,$11.src} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {@2,$3.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r76.0<1;1,0>:d    -2147450880:d              
        sync.allwr                           ($6,$13)                
        sync.nop                             null                             {$7.src}
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {@3,$15.dst} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {@3,$4.src} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r77.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {@2} // s0|s1&s2
(W&f1.0) jmpi                                L24448                                
L24176:
        sync.allwr                           ($1,$4)                
        sync.nop                             null                             {Compacted,$2.src}
        mov (32|M0)              r110.0<1>:f   r100.0<1;1,0>:f                  {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,F@1}
        sync.allwr                           ($0,$3)                
        mov (8|M0)               r110.8<1>:d   r102.0<1;1,0>:d                  {$5.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        mov (8|M0)               r111.0<1>:d   r104.0<1;1,0>:d                 
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r111.8<1>:d   r106.0<1;1,0>:d                  {$6.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.0<1;1,0>:ub  127:w              
        sync.nop                             null                             {Compacted,I@2}
        sync.allrd                           ($5,$10,$13)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$0}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$0.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f     
(W)     jmpi                                 L24592                                
L24448:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L24592                                
L24528:
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.0<1;1,0>:ub  127:w               {$1.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L24592:
        shl (16|M0)              r92.0<1>:d    r78.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r5.0<1>:d     r78.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r110.0<1>:d   r79.0<1;1,0>:d    12:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r79.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r110.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r78.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r79.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L25424                                
L25152:
        sync.allwr                           ($1,$4)                
        mov (8|M0)               r110.0<1>:d   r100.8<1;1,0>:d                  {$14.dst}
        sync.allwr                           ($0,$3)                
        mov (8|M0)               r110.8<1>:f   r102.8<1;1,0>:f                  {$5.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$2.src}
        mov (8|M0)               r111.0<1>:d   r104.8<1;1,0>:d                 
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r111.8<1>:d   r106.8<1;1,0>:d                  {$6.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.16<1;1,0>:ub  127:w             
        sync.nop                             null                             {A@1}
        sync.allrd                           ($5,$10,$13)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$8}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$8.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f      {Compacted}
(W)     jmpi                                 L25576                                
L25424:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L25576                                
L25504:
        sync.nop                             null                             {$12.dst}
        and (16|M0)              r75.2<1>:w    r108.16<1;1,0>:ub  127:w              {$1.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L25576:
        sync.allwr                           ($5,$10)                
        shl (16|M0)              r92.0<1>:d    r85.0<1;1,0>:d    12:w               {Compacted,$15.dst}
        shl (16|M0)              r5.0<1>:d     r85.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r110.0<1>:d   r86.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r86.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r110.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r85.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r86.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L26416                                
L26144:
        sync.allwr                           ($1,$4)                
        mov (8|M0)               r110.0<1>:f   r101.0<1;1,0>:f                  {$14.dst}
        sync.allwr                           ($0,$3)                
        mov (8|M0)               r110.8<1>:d   r103.0<1;1,0>:d                  {$5.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$2.src}
        mov (8|M0)               r111.0<1>:d   r105.0<1;1,0>:d                 
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r111.8<1>:d   r107.0<1;1,0>:d                  {$6.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.32<1;1,0>:ub  127:w             
        sync.nop                             null                             {A@1}
        sync.allrd                           ($10,$13)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$15}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$15.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f      {Compacted}
(W)     jmpi                                 L26560                                
L26416:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L26560                                
L26496:
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.32<1;1,0>:ub  127:w              {$1.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L26560:
        shl (16|M0)              r92.0<1>:d    r87.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r5.0<1>:d     r87.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r110.0<1>:d   r88.0<1;1,0>:d    12:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r110.0<1>:d   r110.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r88.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r110.0<1;0>:ud    r5.0<1;0>:ud      r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r87.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r88.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L27392                                
L27120:
        sync.allwr                           ($1,$4)                
        mov (8|M0)               r110.0<1>:d   r101.8<1;1,0>:d                  {$14.dst}
        sync.allwr                           ($0,$3)                
        mov (8|M0)               r110.8<1>:f   r103.8<1;1,0>:f                  {$5.dst}
        sync.nop                             null                             {Compacted,$14.dst}
        sync.nop                             null                             {Compacted,$2.src}
        mov (8|M0)               r111.0<1>:d   r105.8<1;1,0>:d                 
        sync.nop                             null                             {Compacted,$15.dst}
        mov (8|M0)               r111.8<1>:d   r107.8<1;1,0>:d                  {$6.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.48<1;1,0>:ub  127:w             
        sync.nop                             null                             {Compacted,A@1}
        sync.allrd                           ($10,$13)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$6}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$6.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f     
(W)     jmpi                                 L27536                                
L27392:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L27536                                
L27472:
        sync.nop                             null                             {Compacted,$12.dst}
        and (16|M0)              r75.2<1>:w    r108.48<1;1,0>:ub  127:w              {$1.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L27536:
(W)     mov (1|M0)               f3.1<1>:uw    r4.3<0;1,0>:uw                  
(W&~f3.1) jmpi                               L28160                                
L27568:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.6<0;1,0>:d     0:w              
        cmp (1|M0)    (eq)f0.0   null<1>:d     r6.6<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f3.1   null<1>:d     r6.6<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r6.0<1>:hf    0x1:hf                             
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r6.7<0;1,0>:d     0:w              
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r6.7<0;1,0>:d     r70.7<0;1,0>:d  
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:d     r6.7<0;1,0>:d     r70.5<0;1,0>:d  
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.6<0;1,0>:d     r70.2<0;1,0>:d  
(f1.1)  sel (1|M0)               r6.1<1>:uw    r6.0<0;1,0>:uw    0x0:uw              {F@1}
(f0.0)  sel (1|M0)               r75.2<1>:uw   r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r6.1<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(f3.1)  sel (1|M0)               r6.1<1>:uw    r6.0<0;1,0>:uw    0x0:uw             
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r6.7<0;1,0>:d     r70.3<0;1,0>:d  
(f2.0)  sel (1|M0)               r75.2<1>:uw   r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r6.1<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(f2.0)  sel (1|M0)               r75.2<1>:uw   r6.0<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f3.0   null<1>:uw    r75.2<0;1,0>:uw   0x1:uw              {I@1}
(W)     mov (1|M0)               r6.1<1>:uw    f3.0<0;1,0>:uw                  
(f3.0)  sel (1|M0)               r75.2<1>:uw   r6.0<0;1,0>:uw    0x0:uw             
(f2.1)  sel (1|M0)               r6.1<1>:uw    r6.0<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r6.1<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(f2.0)  sel (1|M0)               r6.1<1>:uw    r6.0<0;1,0>:uw    0x0:uw             
(f2.1)  sel (1|M0)               r75.2<1>:uw   r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r6.1<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(W&~f2.1) jmpi                               L28160                                
L27968:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r7.0<0;1,0>:d     2143363909:d              
(W&f2.0) jmpi                                L28160                                
L28000:
        mov (2|M0)               r92.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r75.2<1>:hf   0x2:hf                              {A@1}
(f3.1)  sel (1|M0)               r6.0<1>:d     r75.2<0;1,0>:w    3:w               {F@1}
(W)     mov (1|M0)               r75.2<1>:hf   0.0:hf                              {I@1}
(f0.0)  mov (1|M0)               r6.0<1>:d     1:w                              
(f0.0)  sel (1|M0)               r6.1<1>:d     r75.2<0;1,0>:w    0:w               {F@1}
(f1.1)  mov (1|M0)               r6.0<1>:d     0:w                              
(f1.1)  mov (1|M0)               r6.1<1>:d     0:w                              
        shl (1|M0)               r6.0<1>:q     r6.0<0;1,0>:q     3:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r6.0<0;1,0>:q    {Compacted,I@1}
        send.ugm (1|M0)          null     r6  r92:2  0x0            0x04000784           {I@1,$13} // wr:2+2, rd:0; store.ugm.d64.a64
L28160:
        add (1|M0)               r6.4<1>:q     r6.3<0;1,0>:q     2:w               {$13.src}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r6.8<0;1,0>:ud    r69.14<0;1,0>:ud
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d 
(W&~f2.1) jmpi                               L28528                                
L28240:
        sync.nop                             null                             {Compacted,$12.src}
        shl (1|M0)               r112.0<1>:q   r6.4<0;1,0>:q     9:w               {Compacted,$10.src}
        shl (1|M0)               r116.0<1>:q   r6.4<0;1,0>:q     6:w               {Compacted,$14.src}
        shl (1|M0)               r6.4<1>:q     r6.4<0;1,0>:q     7:w              
        add (1|M0)               r112.0<1>:q   r4.7<0;1,0>:q     r112.0<0;1,0>:q  {Compacted,I@3}
        add (1|M0)               r6.0<1>:q     r70.6<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (1|M0)          r76      r112  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.allwr                           ($0,$5)                
        send.ugm (1|M0)          r102     r6  null:0  0x0            0x0220E580           {I@1,$3} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r115.0<1>:q   r69.1<0;1,0>:q    r116.0<0;1,0>:q  {Compacted}
        sync.nop                             null                             {Compacted,$1.src}
        add (1|M0)               r114.0<1>:q   r70.5<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,$3.src}
        add (1|M0)               r5.0<1>:q     r6.2<0;1,0>:q     r6.4<0;1,0>:q    {Compacted}
        add (1|M0)               r112.0<1>:q   r112.0<0;1,0>:q   256:w               {Compacted,$8.src}
        add (1|M0)               r6.0<1>:q     r70.7<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,$3.src}
        sync.nop                             null                             {Compacted,$1.dst}
        send.ugm (1|M0)          r108     r115  null:0  0x0            0x0210D580           {I@5,$12} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.allwr                           ($4,$14)                
        send.ugm (1|M0)          r100     r114  null:0  0x0            0x0220E580           {I@4,$1} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.allwr                           ($6,$15)                
        send.ugm (1|M0)          r106     r5  null:0  0x0            0x0220E580           {I@3,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r85      r112  null:0  0x0            0x024AF580           {I@2,$5} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$3.dst}
        send.ugm (1|M0)          r104     r6  null:0  0x0            0x0220E580           {I@1,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L28528:
        mov (2|M0)               r6.0<1>:d     0x1:v                               {$14.src}
        or (2|M0)                r6.0<1>:d     r6.6<1;1,0>:d     r6.0<1;1,0>:d    {I@1}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r6.0<0;1,0>:ud    r69.14<0;1,0>:ud
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d 
(W&~f2.0) jmpi                               L34240                                
L28624:
        sync.nop                             null                             {Compacted,$11.dst}
        shl (16|M0)              r92.0<1>:d    r37.0<1;1,0>:d    12:w               {Compacted,$13.dst}
        shl (16|M0)              r5.0<1>:d     r37.0<1;1,0>:d    9:w               {Compacted,$0.src}
(W)     mov (1|M0)               r110.0<1>:f   0xE000E00:f                              
        sync.nop                             null                             {Compacted,$4.src}
        shl (16|M0)              r111.0<1>:d   r38.0<1;1,0>:d    12:w               {Compacted,$2.src}
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r111.0<1>:d   r111.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r110.0<0>:ud     {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r38.0<1;1,0>:d    9:w               {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r111.0<1;0>:ud    r5.0<1;0>:ud      r110.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r37.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r37.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r38.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r38.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L29440                                
L29184:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$7.dst}
        mov (32|M0)              r110.0<1>:f   r51.0<1;1,0>:f                   {Compacted,$11.dst}
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r110.8<1>:d   r49.0<1;1,0>:d                   {$4.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        mov (8|M0)               r111.0<1>:d   r47.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$8.dst}
        mov (8|M0)               r111.8<1>:d   r45.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.0<1;1,0>:ub   127:w               {$2.dst}
        sync.nop                             null                             {Compacted,I@2}
        sync.allrd                           ($5,$10,$12)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$9}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$9.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f     
(W)     jmpi                                 L29584                                
L29440:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L29584                                
L29520:
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.0<1;1,0>:ub   127:w               {$2.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L29584:
        shl (16|M0)              r92.0<1>:d    r39.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r5.0<1>:d     r39.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r110.0<1>:f   0xE000E00:f                              
        shl (16|M0)              r111.0<1>:d   r40.0<1;1,0>:d    12:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r111.0<1>:d   r111.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r110.0<0>:ud     {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r40.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r111.0<1;0>:ud    r5.0<1;0>:ud      r110.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r39.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r39.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r40.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L30400                                
L30144:
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r110.0<1>:d   r51.8<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r110.8<1>:f   r49.8<1;1,0>:f                   {$4.dst}
        sync.nop                             null                             {$9.dst}
        mov (8|M0)               r111.0<1>:d   r47.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$8.dst}
        mov (8|M0)               r111.8<1>:d   r45.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.16<1;1,0>:ub  127:w               {$2.dst}
        sync.nop                             null                             {Compacted,A@1}
        sync.allrd                           ($5,$10,$12)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$7}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$7.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f     
(W)     jmpi                                 L30544                                
L30400:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L30544                                
L30480:
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.16<1;1,0>:ub  127:w               {$2.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L30544:
        sync.nop                             null                             {Compacted,$2.dst}
        shl (16|M0)              r92.0<1>:d    r33.0<1;1,0>:d    12:w               {Compacted,$10.dst}
        shl (16|M0)              r5.0<1>:d     r33.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r110.0<1>:f   0xE000E00:f                              
        shl (16|M0)              r111.0<1>:d   r34.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r111.0<1>:d   r111.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r110.0<0>:ud     {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r34.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r111.0<1;0>:ud    r5.0<1;0>:ud      r110.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r33.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r34.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r34.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L31360                                
L31104:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r110.0<1>:f   r52.0<1;1,0>:f                   {$11.dst}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r110.8<1>:d   r50.0<1;1,0>:d                   {$4.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        mov (8|M0)               r111.0<1>:d   r48.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$8.dst}
        mov (8|M0)               r111.8<1>:d   r46.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.32<1;1,0>:ub  127:w               {$2.dst}
        sync.nop                             null                             {Compacted,A@1}
        sync.allrd                           ($5,$12)                
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$13}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$13.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f     
(W)     jmpi                                 L31504                                
L31360:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L31504                                
L31440:
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.32<1;1,0>:ub  127:w               {$2.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L31504:
        shl (16|M0)              r92.0<1>:d    r35.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r5.0<1>:d     r35.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r110.0<1>:f   0xE000E00:f                              
        shl (16|M0)              r111.0<1>:d   r36.0<1;1,0>:d    12:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@3}
        and (16|M0)              r111.0<1>:d   r111.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   r92.0<1;0>:ud     r5.0<1;0>:ud      r110.0<0>:ud     {A@1} // s0|s1&s2
        shl (16|M0)              r5.0<1>:d     r36.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r111.0<1;0>:ud    r5.0<1;0>:ud      r110.0<0>:ud     {I@2} // s0|s1&s2
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r93.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r97.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r5.0<1>:ud    acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r5.0<1;1,0>:ud    0x80008000:ud              {I@2}
        and (16|M0)              r5.0<1>:d     r35.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r98.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r35.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@3} // s0|s1&s2
        and (16|M0)              r5.0<1>:d     r36.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r36.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<1;0>:ud      acc0.0<1;0>:ud    r110.0<0>:ud     {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L32304                                
L32064:
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r110.0<1>:d   r52.8<1;1,0>:d                   {$11.dst}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r110.8<1>:f   r50.8<1;1,0>:f                   {$4.dst}
        sync.nop                             null                             {$9.dst}
        mov (8|M0)               r111.0<1>:d   r48.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$8.dst}
        mov (8|M0)               r111.8<1>:d   r46.8<1;1,0>:d                  
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.48<1;1,0>:ub  127:w               {$2.dst}
        sync.nop                             null                             {Compacted,A@1}
        sync.nop                             null                             {Compacted,$12.src}
        dpas.8x4 (16|M0)         r110:f        null:f            r92:hf            r110.0:hf        {$5}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r110.0<1>:f      {Compacted,$5.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r111.0<1>:f      {Compacted}
        mad (16|M0)              r72.0<1>:f    r72.0<1;0>:f      acc0.0<1;0>:f     r112.0<1>:f      {Compacted}
        mad (16|M0)              r73.0<1>:f    r73.0<1;0>:f      acc0.0<1;0>:f     r113.0<1>:f      {Compacted}
(W)     jmpi                                 L32448                                
L32304:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     r92.0<1;0>:ud     r93.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r98.0<1;0>:ud     acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r99.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L32448                                
L32384:
        sync.nop                             null                             {Compacted,$13.dst}
        and (16|M0)              r75.2<1>:w    r82.48<1;1,0>:ub  127:w               {$2.dst}
        mov (16|M0)              r5.0<1>:d     r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r5.0<1>:d     r5.0<1;1,0>:d     20:w               {Compacted,I@1}
        mul (16|M0)              r5.0<1>:f     r5.0<1;1,0>:f     1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r109.0<1>:ud  r109.0<1;1,0>:ud  r5.0<1;1,0>:ud   {Compacted,F@1}
L32448:
(W)     mov (1|M0)               f2.0<1>:uw    r4.3<0;1,0>:uw                  
(W&~f2.0) jmpi                               L32944                                
L32480:
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.0<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.0<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r6.5<1>:hf    0x1:hf                             
        cmp (1|M0)    (eq)f3.0   null<1>:d     r6.0<0;1,0>:d     r70.2<0;1,0>:d  
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r6.1<0;1,0>:d     r70.7<0;1,0>:d  
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r6.1<0;1,0>:d     r70.5<0;1,0>:d  
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r6.1<0;1,0>:d     r70.3<0;1,0>:d  
(f2.1)  sel (1|M0)               r75.2<1>:uw   r6.5<0;1,0>:uw    0x0:uw              {F@1}
(f2.0)  sel (1|M0)               r6.6<1>:uw    r6.5<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r6.6<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(f3.0)  sel (1|M0)               r6.0<1>:uw    r6.5<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r75.2<1>:uw   r6.5<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f1.1   null<1>:uw    r75.2<0;1,0>:uw   0x1:uw              {I@1}
(f1.1)  sel (1|M0)               r75.2<1>:uw   r6.5<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f0.0   null<1>:uw    r6.0<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(f3.1)  sel (1|M0)               r6.0<1>:uw    r6.5<0;1,0>:uw    0x0:uw             
(f0.0)  sel (1|M0)               r75.2<1>:uw   r6.5<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r6.0<0;1,0>:uw    r75.2<0;1,0>:uw  {I@1}
(W&~f3.0) jmpi                               L32944                                
L32784:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r7.0<0;1,0>:d     2143363909:d              
(W&f1.1) jmpi                                L32944                                
L32816:
        mov (2|M0)               r92.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r75.2<1>:hf   0x2:hf                              {A@1}
(f2.0)  sel (1|M0)               r6.0<1>:d     r75.2<0;1,0>:w    3:w               {F@1}
(W)     mov (1|M0)               r75.2<1>:hf   0.0:hf                              {I@1}
(f2.1)  mov (1|M0)               r6.0<1>:d     1:w                              
(f2.1)  sel (1|M0)               r6.1<1>:d     r75.2<0;1,0>:w    0:w               {F@1}
        shl (1|M0)               r6.0<1>:q     r6.0<0;1,0>:q     3:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r6.0<0;1,0>:q    {Compacted,I@1}
        send.ugm (1|M0)          null     r6  r92:2  0x0            0x04000784           {I@1,$3} // wr:2+2, rd:0; store.ugm.d64.a64
L32944:
        add (1|M0)               r6.4<1>:q     r6.3<0;1,0>:q     3:w               {$3.src}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r6.8<0;1,0>:ud    r69.14<0;1,0>:ud
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d 
(W&f1.1) jmpi                                L33976                                
L33024:
(W)     jmpi                                 L34240                                
L33040:
        sync.allwr                           ($1,$8)                
        sync.allrd                           ($0,$15)                
        xor (16|M0)              r5.0<1>:d     r76.0<1;1,0>:d    r77.0<1;1,0>:d   {$12.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r79.0<1;0>:ud     r5.0<1;0>:ud      r78.0<1>:ud      {I@1} // s0^s1^s2
        add (1|M0)               r6.4<1>:q     r6.3<0;1,0>:q     2:w              
        sync.allwr                           ($5,$10)                
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r86.0<1;0>:ud     acc0.0<1;0>:ud    r85.0<1>:ud      {$15.dst} // s0^s1^s2
        cmp (1|M0)    (eq)f0.0   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r88.0<1;0>:ud     acc0.0<1;0>:ud    r87.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$4.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r100.0<1>:ud     {$14.dst} // s0^s1^s2
(f0.0)  cmp (1|M0)    (lt)f0.0   null<1>:ud    r6.8<0;1,0>:ud    r69.14<0;1,0>:ud
        sync.allwr                           ($0,$3)                
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r103.0<1;0>:ud    acc0.0<1;0>:ud    r102.0<1>:ud     // s0^s1^s2
        sync.nop                             null                             {$14.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r105.0<1;0>:ud    acc0.0<1;0>:ud    r104.0<1>:ud     // s0^s1^s2
(~f0.0) cmp (1|M0)    (lt)f0.0   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d 
        sync.nop                             null                             {Compacted,$15.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r107.0<1;0>:ud    acc0.0<1;0>:ud    r106.0<1>:ud     {$6.dst} // s0^s1^s2
        sync.nop                             null                             {Compacted,$12.dst}
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r108.0<1>:ud     // s0^s1^s2
(W&~f0.0) jmpi                               L33584                                
L33376:
        shl (1|M0)               r111.0<1>:q   r6.4<0;1,0>:q     9:w               {Compacted,$2.src}
        shl (1|M0)               r113.0<1>:q   r6.4<0;1,0>:q     6:w               {Compacted,$13.src}
        add (1|M0)               r111.0<1>:q   r4.7<0;1,0>:q     r111.0<0;1,0>:q  {I@2}
        shl (1|M0)               r6.4<1>:q     r6.4<0;1,0>:q     7:w              
        send.ugm (1|M0)          r76      r111  null:0  0x0            0x024AF580           {I@2,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r111.0<1>:q   r111.0<0;1,0>:q   256:w               {Compacted,$1.src}
        add (1|M0)               r6.0<1>:q     r70.6<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,I@2}
        send.ugm (1|M0)          r85      r111  null:0  0x0            0x024AF580           {I@2,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r102     r6  null:0  0x0            0x0220E580           {I@1,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r112.0<1>:q   r69.1<0;1,0>:q    r113.0<0;1,0>:q  {Compacted,$10.src}
        add (1|M0)               r5.0<1>:q     r6.2<0;1,0>:q     r6.4<0;1,0>:q    {Compacted}
        add (1|M0)               r111.0<1>:q   r70.5<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,$10.src}
        add (1|M0)               r6.0<1>:q     r70.7<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,$0.src}
        send.ugm (1|M0)          r108     r112  null:0  0x0            0x0210D580           {I@4,$12} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r106     r5  null:0  0x0            0x0220E580           {I@3,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r100     r111  null:0  0x0            0x0220E580           {I@2,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r104     r6  null:0  0x0            0x0220E580           {I@1,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L33584:
        mov (2|M0)               r75.16<1>:w   0x1010101:v                              
        or (2|M0)                r6.0<1>:d     r6.6<1;1,0>:d     r75.16<1;1,0>:w  {@1,$14.src}
        cmp (1|M0)    (eq)f3.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r6.0<0;1,0>:ud    r69.14<0;1,0>:ud
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d 
(W&~f3.1) jmpi                               L34240                                
L33680:
        sync.nop                             null                             {Compacted,$11.dst}
        sync.nop                             null                             {Compacted,$15.src}
        xor (16|M0)              r5.0<1>:d     r37.0<1;1,0>:d    r38.0<1;1,0>:d   {$13.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r40.0<1;0>:ud     r5.0<1;0>:ud      r39.0<1>:ud      {I@1} // s0^s1^s2
        add (1|M0)               r6.4<1>:q     r6.3<0;1,0>:q     3:w              
        sync.nop                             null                             {$2.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r34.0<1;0>:ud     acc0.0<1;0>:ud    r33.0<1>:ud      {$10.dst} // s0^s1^s2
        cmp (1|M0)    (eq)f3.0   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r36.0<1;0>:ud     acc0.0<1;0>:ud    r35.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {Compacted,$7.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r52.0<1;0>:ud     acc0.0<1;0>:ud    r51.0<1>:ud      // s0^s1^s2
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r6.8<0;1,0>:ud    r69.14<0;1,0>:ud
        sync.nop                             null                             {Compacted,$6.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r50.0<1;0>:ud     acc0.0<1;0>:ud    r49.0<1>:ud      {$4.dst} // s0^s1^s2
        sync.nop                             null                             {Compacted,$9.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r48.0<1;0>:ud     acc0.0<1;0>:ud    r47.0<1>:ud      // s0^s1^s2
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r6.9<0;1,0>:d     r69.15<0;1,0>:d 
        sync.nop                             null                             {Compacted,$8.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r46.0<1;0>:ud     acc0.0<1;0>:ud    r45.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {Compacted,$13.dst}
        bfn.0x96 (16|M0)         r109.0<1>:ud  r109.0<1;0>:ud    acc0.0<1;0>:ud    r82.0<1>:ud      // s0^s1^s2
(W&~f3.0) jmpi                               L34240                                
L33976:
        shl (1|M0)               r110.0<1>:q   r6.4<0;1,0>:q     9:w               {Compacted,$9.src}
        add (1|M0)               r110.0<1>:q   r4.7<0;1,0>:q     r110.0<0;1,0>:q  {Compacted,I@1}
        send.ugm (1|M0)          r37      r110  null:0  0x0            0x024AF580           {I@1,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r110.0<1>:q   r110.0<0;1,0>:q   256:w               {Compacted,$11.src}
        send.ugm (1|M0)          r33      r110  null:0  0x0            0x024AF580           {I@1,$2} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        shl (1|M0)               r110.0<1>:q   r6.4<0;1,0>:q     6:w               {$2.src}
        shl (1|M0)               r6.4<1>:q     r6.4<0;1,0>:q     7:w              
        sync.allwr                           ($6,$13)                
        add (1|M0)               r99.0<1>:q    r69.1<0;1,0>:q    r110.0<0;1,0>:q  {Compacted,@2,$15.dst}
        add (1|M0)               r6.0<1>:q     r70.6<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,I@2}
        add (1|M0)               r98.0<1>:q    r70.5<0;1,0>:q    r6.4<0;1,0>:q    {Compacted}
        sync.nop                             null                             {Compacted,$4.dst}
        send.ugm (1|M0)          r49      r6  null:0  0x0            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        add (1|M0)               r5.0<1>:q     r6.2<0;1,0>:q     r6.4<0;1,0>:q    {Compacted}
        add (1|M0)               r6.0<1>:q     r70.7<0;1,0>:q    r6.4<0;1,0>:q    {Compacted,$6.src}
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r82      r99  null:0  0x0            0x0210D580           {$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.nop                             null                             {Compacted,$11.dst}
        send.ugm (1|M0)          r51      r98  null:0  0x0            0x0220E580           {I@3,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r45      r5  null:0  0x0            0x0220E580           {I@2,$8} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r47      r6  null:0  0x0            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L34240:
        add (1|M0)               r6.3<1>:q     r6.3<0;1,0>:q     2:w               {$9.src}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.7<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r6.6<0;1,0>:ud    r69.14<0;1,0>:ud
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r6.7<0;1,0>:d     r69.15<0;1,0>:d 
(W&f2.1) jmpi                                L23520                                
L34320:
(W)     mov (1|M0)               f1.1<1>:uw    r69.2<0;1,0>:uw                 
(W&f1.1) jmpi                                L34376                                
L34352:
        mov (16|M0)              r7.0<1>:ud    r109.0<1;1,0>:ud                 {Compacted}
        mov (16|M0)              r8.0<1>:ud    r109.0<1;1,0>:ud                 {Compacted}
        mov (32|M0)              r72.0<1>:f    r7.0<1;1,0>:f                    {Compacted,I@1}
L34376:
        mul (1|M0)               acc0.0<1>:d   r84.0<0;1,0>:d    r4.12<0;1,0>:uw 
        sync.allwr                           ($1,$10,$11,$14)                
        mach (1|M0)              r77.0<1>:d    r84.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted,$8.dst}
        mul (16|M0)              r97.0<1>:f    r75.0<0;1,0>:f    r7.0<1;1,0>:f    {Compacted,$3.src}
        sync.nop                             null                             {Compacted,$5.src}
        mov (1|M0)               r76.0<1>:d    acc0.0<0;1,0>:d                  {$0.src}
        mul (1|M0)               acc0.0<1>:d   r89.0<0;1,0>:d    r4.12<0;1,0>:uw 
        mov (1|M0)               r89.2<1>:d    r76.0<0;1,0>:d                   {Compacted,I@2}
        mul (16|M0)              r76.0<1>:f    r75.0<0;1,0>:f    r8.0<1;1,0>:f    {Compacted,I@1}
        mach (1|M0)              r8.0<1>:d     r89.0<0;1,0>:d    r4.6<0;1,0>:d    {F@1}
        mov (1|M0)               r89.3<1>:d    r77.0<0;1,0>:d                  
        mov (1|M0)               r7.0<1>:d     acc0.0<0;1,0>:d                 
        mul (1|M0)               acc0.0<1>:d   r91.0<0;1,0>:d    r4.12<0;1,0>:uw 
        mov (1|M0)               r109.1<1>:d   r8.0<0;1,0>:d                    {Compacted,I@4}
        mach (1|M0)              r8.0<1>:d     r91.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r109.0<1>:f   r7.0<0;1,0>:f                    {Compacted,I@4}
        mov (1|M0)               r7.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mov (1|M0)               r75.3<1>:d    r8.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r75.2<1>:d    r7.0<0;1,0>:d                    {Compacted,I@2}
(W)     mov (1|M0)               f0.0<1>:uw    r6.4<0;1,0>:uw                  
        shl (1|M0)               r89.1<1>:q    r89.1<0;1,0>:q    2:w              
        shl (1|M0)               r109.0<1>:q   r109.0<0;1,0>:q   2:w               {Compacted}
        shl (1|M0)               r75.1<1>:q    r75.1<0;1,0>:q    2:w               {I@4}
        mul (16|M0)              r95.0<1>:f    r75.0<0;1,0>:f    r72.0<1;1,0>:f   {Compacted,$4.src}
        add (1|M0)               r127.0<1>:q   r69.2<0;1,0>:q    r89.1<0;1,0>:q   {Compacted,I@3}
        add (1|M0)               r96.0<1>:q    r69.2<0;1,0>:q    r109.0<0;1,0>:q  {Compacted,I@3}
        sync.allwr                           ($4,$5,$12)                
        sync.nop                             null                             {Compacted,$15.src}
        add (1|M0)               r100.0<1>:q   r69.2<0;1,0>:q    r75.1<0;1,0>:q   {Compacted,@3,$3.dst}
        send.ugm (1|M0)          null     r127  r97:1  0x0            0x0200D584           {I@3,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r96  r76:1  0x0            0x0200D584           {I@2,$5} // wr:1+1, rd:0; store.ugm.d32x16t.a64
        send.ugm (1|M0)          null     r100  r95:1  0x0            0x0200D584           {A@1,$4} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W&~f0.0) jmpi                               L56224                                
L34784:
        mov (1|M0)               r97.0<1>:d    r90.0<0;1,0>:d                   {Compacted,$3.src}
        sync.allrd                           ($8,$15)                
        mov (16|M0)              r5.0<1>:f     r73.0<1;1,0>:f                   {Compacted,$0.src}
(W)     send.ugm (1|M0)          null     r69  r97:1  0x80200000:a0.1        0x4200D504           {I@1,$11} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
(W)     jmpi                                 L56088                                
L34848:
        asr (1|M0)               r75.1<1>:d    r84.0<0;1,0>:d    31:w              
(W)     mov (1|M0)               f2.1<1>:uw    r70.19<0;1,0>:uw                
        shr (1|M0)               r75.1<1>:ud   r75.1<0;1,0>:ud   0x1D:uw              {I@2}
        sync.nop                             null                             {Compacted,$7.src}
        asr (1|M0)               r127.0<1>:d   r89.0<0;1,0>:d    31:w               {Compacted,$3.src}
        add (1|M0)               r75.1<1>:d    r84.0<0;1,0>:d    r75.1<0;1,0>:d   {Compacted,I@2}
        shr (1|M0)               r127.0<1>:ud  r127.0<0;1,0>:ud  0x1D:uw              {Compacted,I@2}
        asr (1|M0)               r75.1<1>:d    r75.1<0;1,0>:d    3:w               {I@2}
(f2.1)  mov (1|M0)               r75.1<1>:d    r84.0<0;1,0>:d                  
        add (1|M0)               r127.0<1>:d   r89.0<0;1,0>:d    r127.0<0;1,0>:d  {Compacted,I@3}
        mul (1|M0)               acc0.0<1>:d   r75.1<0;1,0>:d    r4.0<0;1,0>:uw   {I@2}
        mach (1|M0)              r6.0<1>:d     r75.1<0;1,0>:d    r4.0<0;1,0>:d    {Compacted,$0.src}
        asr (1|M0)               r127.0<1>:d   r127.0<0;1,0>:d   3:w               {I@3}
(f2.1)  mov (1|M0)               r127.0<1>:f   r89.0<0;1,0>:f                   {I@1}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@2}
        mul (1|M0)               acc0.0<1>:d   r127.0<0;1,0>:d   r4.0<0;1,0>:uw   {F@1}
        sync.nop                             null                             {Compacted,$9.dst}
        mach (1|M0)              r8.0<1>:d     r127.0<0;1,0>:d   r4.0<0;1,0>:d    {Compacted,$5.dst}
        mov (1|M0)               r70.0<1>:f    0.0:f                               {Compacted,$14.src}
        mov (1|M0)               r7.0<1>:d     acc0.0<0;1,0>:d                  {$15.src}
(W)     mov (1|M0)               f3.1<1>:uw    r70.18<0;1,0>:uw                
        mov (1|M0)               r110.1<1>:d   r6.0<0;1,0>:d                    {Compacted,$11.src}
        mov (1|M0)               r110.0<1>:f   r5.0<0;1,0>:f                    {I@6}
        sync.allwr                           ($6,$13)                
        mov (1|M0)               r99.1<1>:d    r8.0<0;1,0>:d                    {Compacted,@4,$15.dst}
        mov (1|M0)               r99.0<1>:f    r7.0<0;1,0>:f                    {Compacted,I@4}
        mov (32|M0)              r7.0<1>:f     r70.0<0;1,0>:f                   {Compacted,A@1}
        shl (1|M0)               r110.0<1>:q   r110.0<0;1,0>:q   1:w               {Compacted,F@3}
        shl (1|M0)               r99.0<1>:q    r99.0<0;1,0>:q    1:w               {F@2}
        add (1|M0)               r6.1<1>:q     r3.7<0;1,0>:q     r110.0<0;1,0>:q  {I@2}
        add (1|M0)               r6.2<1>:q     r3.7<0;1,0>:q     r99.0<0;1,0>:q   {I@2}
(W&f3.1) jmpi                                L35288                                
L35248:
        sync.allwr                           ($5,$12)                
        mov (16|M0)              r101.0<1>:f   r70.0<0;1,0>:f                   {Compacted,$3.dst}
(W)     jmpi                                 L45632                                
L35288:
(W)     mov (1|M0)               r98.0<1>:uq   r4.7<0;1,0>:uq                   {Compacted,$7.src}
(W)     mov (1|M0)               r97.0<1>:uq   r69.5<0;1,0>:uq                  {Compacted}
        sync.nop                             null                             {Compacted,$5.src}
(W)     mov (1|M0)               r96.0<1>:uq   r69.1<0;1,0>:uq                  {Compacted,$11.src}
(W)     mov (1|M0)               r95.0<1>:uq   r6.1<0;1,0>:uq                   {Compacted,@7,$4.src}
(W)     mov (1|M0)               r94.0<1>:uq   r6.2<0;1,0>:uq                   {Compacted,I@7}
        sync.allwr                           ($8,$11,$14)                
        sync.nop                             null                             {Compacted,$12.src}
        send.ugm (1|M0)          r76      r98  null:0  0x0            0x024AF580           {I@5,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r85      r97  null:0  0x0            0x024AF580           {I@4,$2} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r5       r96  null:0  0x0            0x0210D580           {I@3,$6} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.allwr                           ($0,$7,$13)                
        send.ugm (1|M0)          r72      r95  null:0  0x0            0x0220E580           {I@2,$15} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r98      r94  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               f3.0<1>:uw    r70.17<0;1,0>:uw                
(W&f3.0) jmpi                                L35648                                
L35488:
(W)     mov (1|M0)               r93.0<1>:uq   r69.4<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r92.0<1>:uq   r69.3<0;1,0>:uq                  {Compacted,$10.src}
(W)     mov (1|M0)               r91.0<1>:uq   r69.1<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r90.0<1>:uq   r6.1<0;1,0>:uq                   {Compacted,$14.dst}
(W)     mov (1|M0)               r70.0<1>:uq   r6.2<0;1,0>:uq                   {Compacted,F@1}
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r21      r93  null:0  0x0            0x024AF580           {I@5,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r17      r92  null:0  0x0            0x024AF580           {I@4,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r81      r91  null:0  0x40000            0x0210D580           {I@3,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$6.dst}
        send.ugm (1|M0)          r43      r90  null:0  0x80000            0x0220E580           {I@2,$0} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
        sync.nop                             null                             {Compacted,$12.dst}
        send.ugm (1|M0)          r41      r70  null:0  0x80000            0x0220E580           {I@1,$14} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L35648:
        sync.allwr                           ($5,$12)                
        mov (16|M0)              r101.0<1>:d   0:w                               {$3.dst}
        mov (1|M0)               r6.3<1>:q     0:w                              
L35696:
(W)     mov (1|M0)               f2.1<1>:uw    r70.16<0;1,0>:uw                
(W&f2.1) jmpi                                L44592                                
L35728:
        sync.allwr                           ($0,$3,$10,$11)                
        sync.nop                             null                             {Compacted,$8.src}
        shl (16|M0)              r102.0<1>:d   r77.0<1;1,0>:d    12:w               {Compacted,$5.dst}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r100.0<1>:d   r77.0<1;1,0>:d    9:w               {Compacted,$15.src}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x4:uw             
        sync.nop                             null                             {Compacted,A@1}
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {$7.src} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {@2,$13.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {@2,$12.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        sync.allwr                           ($4,$6,$15)                
        shl (16|M0)              r106.0<1>:d   r76.0<1;1,0>:d    12:w               {$2.dst}
        and (16|M0)              r100.0<1>:d   r76.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x3:uw             
        sync.nop                             null                             {Compacted,$14.dst}
        shl (16|M0)              r105.0<1>:d   r76.0<1;1,0>:d    9:w               {Compacted,$5.dst}
        and (16|M0)              r106.0<1>:d   r106.0<1;1,0>:d   -2147450880:d               {I@5}
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {@5,$1.src} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r77.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r90.0<1>:ud   r106.0<1;0>:ud    r105.0<1;0>:ud    r6.0<0>:ud       {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {@3,$2.src} // s0|s1&s2
(W&f1.0) jmpi                                L36512                                
L36336:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r100.0<1>:f   r72.0<1;1,0>:f                   {$15.dst}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r100.8<1>:d   r98.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$8}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$8.src}
        and (16|M0)              r94.0<1>:w    r5.0<1;1,0>:ub    127:w               {$6.dst}
        mov (16|M0)              r104.0<1>:d   r94.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r104.0<1>:d   r104.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r104.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$8.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L36664                                
L36512:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L36664                                
L36592:
        sync.nop                             null                             {$2.dst}
        and (16|M0)              r93.0<1>:w    r5.0<1;1,0>:ub    127:w               {$6.dst}
        mov (16|M0)              r123.0<1>:d   r93.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r123.0<1>:d   r123.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r123.0<1>:f   r123.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r123.0<1;1,0>:ud {Compacted,F@1}
L36664:
        shl (16|M0)              r100.0<1>:d   r78.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r97.0<1>:d    r78.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r102.0<1>:d   r79.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r100.0<1>:d   r100.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   r100.0<1;0>:ud    r97.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r100.0<1>:d   r79.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r78.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r79.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L37392                                
L37216:
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r100.0<1>:d   r72.8<1;1,0>:d                   {$15.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$4.dst}
        mov (8|M0)               r100.8<1>:f   r98.8<1;1,0>:f                  
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$9}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {Compacted,$9.src}
        and (16|M0)              r92.0<1>:w    r5.16<1;1,0>:ub   127:w               {$6.dst}
        mov (16|M0)              r96.0<1>:d    r92.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r96.0<1>:d    r96.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r96.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$9.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L37544                                
L37392:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L37544                                
L37472:
        sync.nop                             null                             {$2.dst}
        and (16|M0)              r91.0<1>:w    r5.16<1;1,0>:ub   127:w               {$6.dst}
        mov (16|M0)              r122.0<1>:d   r91.0<2;1,0>:ub                  {@1,$14.src}
        shl (16|M0)              r122.0<1>:d   r122.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r122.0<1>:f   r122.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r122.0<1;1,0>:ud {Compacted,F@1}
L37544:
        sync.nop                             null                             {Compacted,$8.dst}
        shl (16|M0)              r95.0<1>:d    r85.0<1;1,0>:d    12:w               {Compacted,$2.dst}
        shl (16|M0)              r102.0<1>:d   r86.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r94.0<1>:d    r85.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r100.0<1>:d   r86.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r95.0<1>:d    r95.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@4}
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r90.0<1>:ud   r95.0<1;0>:ud     r94.0<1;0>:ud     r6.0<0>:ud       {A@1} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r85.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r86.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L38288                                
L38096:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r100.0<1>:f   r73.0<1;1,0>:f                   {$15.dst}
        sync.nop                             null                             {$4.dst}
        mov (8|M0)               r100.8<1>:d   r99.0<1;1,0>:d                  
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$3}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.nop                             null                             {$3.src}
        and (16|M0)              r90.0<1>:w    r5.32<1;1,0>:ub   127:w               {$6.dst}
        mov (16|M0)              r93.0<1>:d    r90.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L38440                                
L38288:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L38440                                
L38368:
        sync.nop                             null                             {Compacted,$2.dst}
        and (16|M0)              r89.2<1>:w    r5.32<1;1,0>:ub   127:w               {$6.dst}
        sync.nop                             null                             {Compacted,$4.src}
        mov (16|M0)              r121.0<1>:d   r89.4<2;1,0>:ub                  {@1,$12.src}
        shl (16|M0)              r121.0<1>:d   r121.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r121.0<1>:f   r121.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r121.0<1;1,0>:ud {Compacted,F@1}
L38440:
        shl (16|M0)              r102.0<1>:d   r88.0<1;1,0>:d    12:w               {Compacted}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r100.0<1>:d   r88.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r92.0<1>:d    r87.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {A@1} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r91.0<1>:d    r87.0<1;1,0>:d    9:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r90.0<1>:ud   r92.0<1;0>:ud     r91.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r87.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r88.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L39168                                
L38992:
        sync.nop                             null                             {Compacted,$7.dst}
        mov (8|M0)               r100.0<1>:d   r73.8<1;1,0>:d                   {$15.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {$4.dst}
        mov (8|M0)               r100.8<1>:f   r99.8<1;1,0>:f                  
        sync.nop                             null                             {Compacted,$2.dst}
        and (16|M0)              r84.2<1>:w    r5.48<1;1,0>:ub   127:w               {$6.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$5}
        mov (16|M0)              r90.0<1>:d    r84.4<2;1,0>:ub                  {@1,$5.src}
        shl (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r90.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$5.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L39312                                
L39168:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L39312                                
L39248:
        sync.nop                             null                             {Compacted,$2.dst}
        and (16|M0)              r75.2<1>:w    r5.48<1;1,0>:ub   127:w               {$6.dst}
        mov (16|M0)              r120.0<1>:d   r75.4<2;1,0>:ub                  {I@1}
        shl (16|M0)              r120.0<1>:d   r120.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r120.0<1>:f   r120.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r120.0<1;1,0>:ud {Compacted,F@1}
L39312:
(W)     mov (1|M0)               f2.0<1>:uw    r4.3<0;1,0>:uw                  
(W&~f2.0) jmpi                               L39984                                
L39344:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r6.6<0;1,0>:d     0:w              
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.6<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.6<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r6.0<1>:hf    0x1:hf                             
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r6.7<0;1,0>:d     0:w              
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r6.7<0;1,0>:d     r70.7<0;1,0>:d  
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r6.7<0;1,0>:d     r70.5<0;1,0>:d  
        cmp (1|M0)    (eq)f0.0   null<1>:d     r6.6<0;1,0>:d     r70.2<0;1,0>:d  
        sync.nop                             null                             {Compacted,F@1}
        sync.nop                             null                             {Compacted,$4.src}
(f3.0)  sel (1|M0)               r121.1<1>:uw  r6.0<0;1,0>:uw    0x0:uw              {$12.src}
(f2.1)  sel (1|M0)               r121.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(f2.0)  sel (1|M0)               r122.1<1>:uw  r6.0<0;1,0>:uw    0x0:uw              {$14.src}
        or (1|M0)     (ne)f3.1   null<1>:uw    r121.1<0;1,0>:uw  r121.0<0;1,0>:uw {I@2}
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r6.7<0;1,0>:d     r70.3<0;1,0>:d  
(f3.1)  sel (1|M0)               r122.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(f0.0)  sel (1|M0)               r124.1<1>:uw  r6.0<0;1,0>:uw    0x0:uw              {$10.src}
        or (1|M0)     (ne)f3.1   null<1>:uw    r122.1<0;1,0>:uw  r122.0<0;1,0>:uw {I@2}
(f3.1)  sel (1|M0)               r123.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r125.1<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f1.1   null<1>:uw    r123.0<0;1,0>:uw  0x1:uw              {I@2}
(f1.1)  sel (1|M0)               r124.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(W)     mov (1|M0)               r107.0<1>:uw  f1.1<0;1,0>:uw                   {$1.src}
        and (1|M0)    (ne)f0.0   null<1>:uw    r124.1<0;1,0>:uw  r124.0<0;1,0>:uw {I@2}
(f0.0)  sel (1|M0)               r125.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f0.0   null<1>:uw    r125.1<0;1,0>:uw  r125.0<0;1,0>:uw {I@1}
(W&~f0.0) jmpi                               L39984                                
L39760:
        cmp (1|M0)    (eq)f3.1   null<1>:d     r7.0<0;1,0>:d     2143363909:d              
(W&f3.1) jmpi                                L39984                                
L39792:
        sync.nop                             null                             {A@1}
        mov (2|M0)               r70.0<1>:d    tm0.0<1;1,0>:ud                  {$14.src}
(W)     mov (1|M0)               r96.0<1>:hf   0x2:hf                              {A@1}
(W)     mov (1|M0)               r95.0<1>:hf   0.0:hf                             
        sync.nop                             null                             {F@2}
(f2.0)  sel (1|M0)               r127.0<1>:d   r96.0<0;1,0>:w    3:w               {$7.src}
(f2.1)  mov (1|M0)               r127.0<1>:d   1:w                              
(f2.1)  sel (1|M0)               r127.1<1>:d   r95.0<0;1,0>:w    0:w               {F@1}
(f3.0)  mov (1|M0)               r127.0<1>:d   0:w                              
(f3.0)  mov (1|M0)               r127.1<1>:d   0:w                              
        shl (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   3:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r127.0<0;1,0>:q  {Compacted,I@1}
        send.ugm (1|M0)          null     r6  r70:2  0x0            0x04000784           {I@1,$4} // wr:2+2, rd:0; store.ugm.d64.a64
L39984:
        add (1|M0)               r127.1<1>:q   r6.3<0;1,0>:q     2:w               {$7.src}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r127.3<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r127.2<0;1,0>:ud  r69.14<0;1,0>:ud
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r127.3<0;1,0>:d   r69.15<0;1,0>:d 
(W&~f2.0) jmpi                               L40256                                
L40064:
        shl (1|M0)               r127.0<1>:q   r127.1<0;1,0>:q   9:w               {Compacted}
        sync.nop                             null                             {Compacted,$4.src}
        shl (1|M0)               r70.0<1>:q    r127.1<0;1,0>:q   6:w               {Compacted,$14.src}
        add (1|M0)               r127.0<1>:q   r4.7<0;1,0>:q     r127.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r127.1<1>:q   r127.1<0;1,0>:q   7:w              
        send.ugm (1|M0)          r76      r127  null:0  0x0            0x024AF580           {I@1,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   256:w               {Compacted,$10.src}
        add (1|M0)               r6.0<1>:q     r69.1<0;1,0>:q    r70.0<0;1,0>:q   {Compacted}
        send.ugm (1|M0)          r85      r127  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r126.0<1>:q   r6.2<0;1,0>:q     r127.1<0;1,0>:q  {Compacted,$7.src}
        add (1|M0)               r127.0<1>:q   r6.1<0;1,0>:q     r127.1<0;1,0>:q  {Compacted,$8.src}
        sync.nop                             null                             {$2.dst}
        send.ugm (1|M0)          r5       r6  null:0  0x0            0x0210D580           {I@3,$6} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.nop                             null                             {Compacted,$4.dst}
        send.ugm (1|M0)          r98      r126  null:0  0x0            0x0220E580           {I@2,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r72      r127  null:0  0x0            0x0220E580           {I@1,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L40256:
        sync.nop                             null                             {$6.src}
        mov (2|M0)               r6.0<1>:d     0x1:v                               {$4.src}
        or (2|M0)                r6.0<1>:d     r6.6<1;1,0>:d     r6.0<1;1,0>:d    {I@1}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r6.0<0;1,0>:ud    r69.14<0;1,0>:ud
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d 
(W&~f1.1) jmpi                               L45552                                
L40368:
        sync.nop                             null                             {Compacted,$0.dst}
        shl (16|M0)              r102.0<1>:d   r22.0<1;1,0>:d    12:w               {Compacted,$1.dst}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                               {$14.src}
        shl (16|M0)              r100.0<1>:d   r22.0<1;1,0>:d    9:w              
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        shl (16|M0)              r106.0<1>:d   r21.0<1;1,0>:d    12:w              
        and (16|M0)              r100.0<1>:d   r21.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r21.0<1;1,0>:ud   0x3:uw             
        shl (16|M0)              r105.0<1>:d   r21.0<1;1,0>:d    9:w              
        and (16|M0)              r106.0<1>:d   r106.0<1;1,0>:d   -2147450880:d               {I@5}
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@5} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r22.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r22.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r90.0<1>:ud   r106.0<1;0>:ud    r105.0<1;0>:ud    r70.0<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
(W&f1.0) jmpi                                L41120                                
L40944:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r100.0<1>:f   r43.0<1;1,0>:f                   {$0.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        mov (8|M0)               r100.8<1>:d   r41.0<1;1,0>:d                   {$14.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        and (16|M0)              r125.0<1>:w   r81.0<1;1,0>:ub   127:w               {$13.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$14}
        mov (16|M0)              r104.0<1>:d   r125.0<2;1,0>:ub                 {I@1}
        shl (16|M0)              r104.0<1>:d   r104.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r104.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$14.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f     
(W)     jmpi                                 L41272                                
L41120:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L41272                                
L41200:
        sync.nop                             null                             {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$10.src}
        and (16|M0)              r124.0<1>:w   r81.0<1;1,0>:ub   127:w               {$13.dst}
        mov (16|M0)              r118.0<1>:d   r124.0<2;1,0>:ub                 {@1,$0.src}
        shl (16|M0)              r118.0<1>:d   r118.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r118.0<1>:f   r118.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r118.0<1;1,0>:ud {Compacted,F@1}
L41272:
        shl (16|M0)              r100.0<1>:d   r23.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r97.0<1>:d    r23.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r102.0<1>:d   r24.0<1;1,0>:d    12:w               {Compacted}
        and (16|M0)              r100.0<1>:d   r100.0<1;1,0>:d   -2147450880:d               {I@3}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   r100.0<1;0>:ud    r97.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r100.0<1>:d   r24.0<1;1,0>:d    9:w              
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r23.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r23.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r24.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r24.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L42000                                
L41824:
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r100.0<1>:d   r43.8<1;1,0>:d                   {$0.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$12.dst}
        mov (8|M0)               r100.8<1>:f   r41.8<1;1,0>:f                   {$14.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        and (16|M0)              r123.0<1>:w   r81.16<1;1,0>:ub  127:w               {$13.dst}
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$13}
        mov (16|M0)              r96.0<1>:d    r123.0<2;1,0>:ub                 {@1,$13.src}
        shl (16|M0)              r96.0<1>:d    r96.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r96.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$13.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L42168                                
L42000:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L42168                                
L42080:
        sync.nop                             null                             {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$14.src}
        and (16|M0)              r122.0<1>:w   r81.16<1;1,0>:ub  127:w               {$13.dst}
        sync.allrd                           ($1,$15)                
        mov (16|M0)              r117.0<1>:d   r122.0<2;1,0>:ub                 {@1,$8.src}
        shl (16|M0)              r117.0<1>:d   r117.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r117.0<1>:f   r117.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r117.0<1;1,0>:ud {Compacted,F@1}
L42168:
        sync.nop                             null                             {Compacted,$15.dst}
        shl (16|M0)              r95.0<1>:d    r17.0<1;1,0>:d    12:w               {Compacted,$12.dst}
        shl (16|M0)              r102.0<1>:d   r18.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r94.0<1>:d    r17.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r100.0<1>:d   r18.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r95.0<1>:d    r95.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@4}
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r90.0<1>:ud   r95.0<1;0>:ud     r94.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r17.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r17.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r18.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r18.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L42896                                
L42720:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r100.0<1>:f   r44.0<1;1,0>:f                   {$0.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        mov (8|M0)               r100.8<1>:d   r42.0<1;1,0>:d                   {$14.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$4.src}
        and (16|M0)              r121.0<1>:w   r81.32<1;1,0>:ub  127:w               {$13.dst}
        sync.nop                             null                             {Compacted,A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$3}
        mov (16|M0)              r93.0<1>:d    r121.0<2;1,0>:ub                 {@1,$3.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$3.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L43048                                
L42896:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L43048                                
L42976:
        sync.nop                             null                             {$9.dst}
        and (16|M0)              r120.0<1>:w   r81.32<1;1,0>:ub  127:w               {$13.dst}
        mov (16|M0)              r116.0<1>:d   r120.0<2;1,0>:ub                 {@1,$2.src}
        shl (16|M0)              r116.0<1>:d   r116.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r116.0<1>:f   r116.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r116.0<1;1,0>:ud {Compacted,F@1}
L43048:
        shl (16|M0)              r102.0<1>:d   r20.0<1;1,0>:d    12:w               {Compacted}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r100.0<1>:d   r20.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r102.0<1>:d   r102.0<1;1,0>:d   -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r92.0<1>:d    r19.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r94.0<1>:ud   r102.0<1;0>:ud    r100.0<1;0>:ud    r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r91.0<1>:d    r19.0<1;1,0>:d    9:w              
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r90.0<1>:ud   r92.0<1;0>:ud     r91.0<1;0>:ud     r70.0<0>:ud      {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r92.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r19.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r96.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r19.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        and (16|M0)              r100.0<1>:d   r20.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r20.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r97.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@2} // s0|s1&s2
(W&f1.0) jmpi                                L43792                                
L43600:
        sync.nop                             null                             {Compacted,$6.dst}
        mov (8|M0)               r100.0<1>:d   r44.8<1;1,0>:d                   {$0.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {$12.dst}
        mov (8|M0)               r100.8<1>:f   r42.8<1;1,0>:f                   {$14.dst}
        sync.nop                             null                             {Compacted,$9.dst}
        sync.nop                             null                             {Compacted,$10.src}
        and (16|M0)              r119.0<1>:w   r81.48<1;1,0>:ub  127:w               {$13.dst}
        sync.nop                             null                             {A@1}
        dpas.8x2 (16|M0)         r102:f        null:f            r90:hf            r100.0:hf        {$14}
        mov (16|M0)              r90.0<1>:d    r119.0<2;1,0>:ub                 {@1,$14.src}
        shl (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r90.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r7.0<1>:f     r7.0<1;0>:f       acc0.0<1;0>:f     r102.0<1>:f      {Compacted,$14.dst}
        mad (16|M0)              r8.0<1>:f     r8.0<1;0>:f       acc0.0<1;0>:f     r103.0<1>:f      {Compacted}
(W)     jmpi                                 L43952                                
L43792:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r92.0<1;0>:ud     r90.0<1;0>:ud     r91.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r94.0<1;0>:ud     acc0.0<1;0>:ud    r93.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r96.0<1;0>:ud     acc0.0<1;0>:ud    r95.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r97.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L43952                                
L43872:
        sync.nop                             null                             {Compacted,$13.dst}
        sync.nop                             null                             {Compacted,$0.src}
        and (16|M0)              r118.0<1>:w   r81.48<1;1,0>:ub  127:w               {$9.dst}
        mov (16|M0)              r115.0<1>:d   r118.0<2;1,0>:ub                 {@1,$2.src}
        shl (16|M0)              r115.0<1>:d   r115.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r115.0<1>:f   r115.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r101.0<1>:ud  r101.0<1;1,0>:ud  r115.0<1;1,0>:ud {F@1}
L43952:
(W)     mov (1|M0)               f3.1<1>:uw    r4.3<0;1,0>:uw                  
(W&~f3.1) jmpi                               L44504                                
L43984:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.0<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f0.0   null<1>:d     r6.0<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r6.16<1>:hf   0x1:hf                             
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.0<0;1,0>:d     r70.2<0;1,0>:d  
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r6.1<0;1,0>:d     r70.7<0;1,0>:d  
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r6.1<0;1,0>:d     r70.5<0;1,0>:d  
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r6.1<0;1,0>:d     r70.3<0;1,0>:d  
        sync.nop                             null                             {F@1}
        sync.allrd                           ($1,$15)                
(f1.1)  sel (1|M0)               r117.0<1>:uw  r6.16<0;1,0>:uw   0x0:uw              {$8.src}
(f0.0)  sel (1|M0)               r6.17<1>:uw   r6.16<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r6.17<0;1,0>:uw   r117.0<0;1,0>:uw {I@1}
(f2.0)  sel (1|M0)               r119.1<1>:uw  r6.16<0;1,0>:uw   0x0:uw              {$10.src}
        sync.nop                             null                             {$0.src}
(f2.1)  sel (1|M0)               r118.0<1>:uw  r6.16<0;1,0>:uw   0x0:uw              {$9.src}
(f2.1)  sel (1|M0)               r120.1<1>:uw  r6.16<0;1,0>:uw   0x0:uw             
        xor (1|M0)    (ne)f3.1   null<1>:uw    r118.0<0;1,0>:uw  0x1:uw              {I@2}
(f3.1)  sel (1|M0)               r119.0<1>:uw  r6.16<0;1,0>:uw   0x0:uw             
        and (1|M0)    (ne)f2.0   null<1>:uw    r119.1<0;1,0>:uw  r119.0<0;1,0>:uw {I@1}
(f2.0)  sel (1|M0)               r120.0<1>:uw  r6.16<0;1,0>:uw   0x0:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r120.1<0;1,0>:uw  r120.0<0;1,0>:uw {I@1}
(W&~f2.1) jmpi                               L44504                                
L44336:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r7.0<0;1,0>:d     2143363909:d              
(W&f2.0) jmpi                                L44504                                
L44368:
        mov (2|M0)               r70.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r94.0<1>:hf   0x2:hf                              {A@1}
(W)     mov (1|M0)               r93.0<1>:hf   0.0:hf                             
        sync.nop                             null                             {Compacted,F@2}
(f0.0)  sel (1|M0)               r126.0<1>:d   r94.0<0;1,0>:w    3:w               {$7.src}
(f1.1)  mov (1|M0)               r126.0<1>:d   1:w                              
(f1.1)  sel (1|M0)               r126.1<1>:d   r93.0<0;1,0>:w    0:w               {F@1}
        shl (1|M0)               r126.0<1>:q   r126.0<0;1,0>:q   3:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r126.0<0;1,0>:q  {Compacted,I@1}
        send.ugm (1|M0)          null     r6  r70:2  0x0            0x04000784           {I@1,$10} // wr:2+2, rd:0; store.ugm.d64.a64
L44504:
        add (1|M0)               r125.0<1>:q   r6.3<0;1,0>:q     3:w               {Compacted}
        cmp (1|M0)    (eq)f0.0   null<1>:d     r125.1<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f0.0)  cmp (1|M0)    (lt)f0.0   null<1>:ud    r125.0<0;1,0>:ud  r69.14<0;1,0>:ud
(~f0.0) cmp (1|M0)    (lt)f0.0   null<1>:d     r125.1<0;1,0>:d   r69.15<0;1,0>:d 
(W&f0.0) jmpi                                L45344                                
L44576:
(W)     jmpi                                 L45552                                
L44592:
        add (1|M0)               r126.0<1>:q   r6.3<0;1,0>:q     2:w               {Compacted,$7.src}
        sync.nop                             null                             {Compacted,$11.dst}
        sync.allrd                           ($1,$8,$15)                
        xor (16|M0)              r117.0<1>:d   r76.0<1;1,0>:d    r77.0<1;1,0>:d   {Compacted,$10.dst}
        cmp (1|M0)    (eq)f3.1   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r79.0<1;0>:ud     r117.0<1;0>:ud    r78.0<1>:ud      {I@2} // s0^s1^s2
        sync.nop                             null                             {Compacted,$8.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r86.0<1;0>:ud     acc0.0<1;0>:ud    r85.0<1>:ud      {$2.dst} // s0^s1^s2
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r126.0<0;1,0>:ud  r69.14<0;1,0>:ud
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r88.0<1;0>:ud     acc0.0<1;0>:ud    r87.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$7.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r73.0<1;0>:ud     acc0.0<1;0>:ud    r72.0<1>:ud      {$15.dst} // s0^s1^s2
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d 
        sync.nop                             null                             {$4.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r99.0<1;0>:ud     acc0.0<1;0>:ud    r98.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r5.0<1>:ud       {$6.dst} // s0^s1^s2
(W&~f3.1) jmpi                               L44992                                
L44832:
        sync.allwr                           ($0,$3)                
        shl (1|M0)               r102.0<1>:q   r126.0<0;1,0>:q   9:w               {Compacted,$5.dst}
        shl (1|M0)               r116.0<1>:q   r126.0<0;1,0>:q   6:w               {Compacted,$2.src}
        add (1|M0)               r102.0<1>:q   r4.7<0;1,0>:q     r102.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r126.0<1>:q   r126.0<0;1,0>:q   7:w               {Compacted}
        send.ugm (1|M0)          r76      r102  null:0  0x0            0x024AF580           {I@2,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r115.0<1>:q   r69.1<0;1,0>:q    r116.0<0;1,0>:q  {Compacted}
        add (1|M0)               r102.0<1>:q   r102.0<0;1,0>:q   256:w               {Compacted,$11.src}
        add (1|M0)               r114.0<1>:q   r6.1<0;1,0>:q     r126.0<0;1,0>:q  {Compacted,I@3}
        add (1|M0)               r113.0<1>:q   r6.2<0;1,0>:q     r126.0<0;1,0>:q  {Compacted,$13.src}
        send.ugm (1|M0)          r5       r115  null:0  0x0            0x0210D580           {I@4,$2} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r85      r102  null:0  0x0            0x024AF580           {I@3,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r72      r114  null:0  0x0            0x0220E580           {I@2,$7} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        send.ugm (1|M0)          r98      r113  null:0  0x0            0x0220E580           {I@1,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L44992:
        sync.nop                             null                             {$10.src}
        mov (2|M0)               r92.0<1>:w    0x1010101:v                               {$12.src}
        or (2|M0)                r119.0<1>:d   r6.6<1;1,0>:d     r92.0<1;1,0>:w   {@1}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r119.1<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r119.0<0;1,0>:ud  r69.14<0;1,0>:ud
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r119.1<0;1,0>:d   r69.15<0;1,0>:d 
(W&~f3.0) jmpi                               L45552                                
L45104:
        add (1|M0)               r125.0<1>:q   r6.3<0;1,0>:q     3:w               {Compacted}
        sync.nop                             null                             {Compacted,$0.dst}
        sync.allrd                           ($10,$12)                
        xor (16|M0)              r112.0<1>:d   r21.0<1;1,0>:d    r22.0<1;1,0>:d   {Compacted,$1.dst}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r125.1<0;1,0>:d   r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r24.0<1;0>:ud     r112.0<1;0>:ud    r23.0<1>:ud      {I@2} // s0^s1^s2
        sync.nop                             null                             {Compacted,$15.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r18.0<1;0>:ud     acc0.0<1;0>:ud    r17.0<1>:ud      {$12.dst} // s0^s1^s2
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r125.0<0;1,0>:ud  r69.14<0;1,0>:ud
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r20.0<1;0>:ud     acc0.0<1;0>:ud    r19.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$6.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r44.0<1;0>:ud     acc0.0<1;0>:ud    r43.0<1>:ud      // s0^s1^s2
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r125.1<0;1,0>:d   r69.15<0;1,0>:d 
        sync.nop                             null                             {Compacted,$12.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r42.0<1;0>:ud     acc0.0<1;0>:ud    r41.0<1>:ud      {$14.dst} // s0^s1^s2
        sync.nop                             null                             {Compacted,$9.dst}
        bfn.0x96 (16|M0)         r101.0<1>:ud  r101.0<1;0>:ud    acc0.0<1;0>:ud    r81.0<1>:ud      {$13.dst} // s0^s1^s2
(W&~f2.1) jmpi                               L45552                                
L45344:
        shl (1|M0)               r100.0<1>:q   r125.0<0;1,0>:q   9:w               {Compacted}
        sync.nop                             null                             {Compacted,$2.src}
        shl (1|M0)               r111.0<1>:q   r125.0<0;1,0>:q   6:w               {Compacted,$8.src}
        add (1|M0)               r100.0<1>:q   r4.7<0;1,0>:q     r100.0<0;1,0>:q  {Compacted,I@2}
        shl (1|M0)               r125.0<1>:q   r125.0<0;1,0>:q   7:w               {Compacted}
        send.ugm (1|M0)          r21      r100  null:0  0x0            0x024AF580           {I@2,$0} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r110.0<1>:q   r69.1<0;1,0>:q    r111.0<0;1,0>:q  {Compacted,$9.src}
        add (1|M0)               r100.0<1>:q   r100.0<0;1,0>:q   256:w               {Compacted,$0.src}
        sync.nop                             null                             {Compacted,$2.dst}
        sync.allrd                           ($1,$6)                
        add (1|M0)               r109.0<1>:q   r6.1<0;1,0>:q     r125.0<0;1,0>:q  {Compacted,@3,$0.dst}
        sync.nop                             null                             {Compacted,$12.dst}
        add (1|M0)               r108.0<1>:q   r6.2<0;1,0>:q     r125.0<0;1,0>:q  {Compacted,$1.dst}
        sync.nop                             null                             {Compacted,$13.dst}
        send.ugm (1|M0)          r81      r110  null:0  0x0            0x0210D580           {I@4,$9} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r17      r100  null:0  0x0            0x024AF580           {I@3,$15} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r43      r109  null:0  0x0            0x0220E580           {I@2,$6} // wr:1+0, rd:2; load.ugm.d32x32t.a64
        sync.nop                             null                             {Compacted,$14.dst}
        send.ugm (1|M0)          r41      r108  null:0  0x0            0x0220E580           {I@1,$12} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L45552:
        add (1|M0)               r6.3<1>:q     r6.3<0;1,0>:q     2:w               {$10.src}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.7<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r6.6<0;1,0>:ud    r69.14<0;1,0>:ud
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r6.7<0;1,0>:d     r69.15<0;1,0>:d 
(W&f2.0) jmpi                                L35696                                
L45632:
(W)     mov (1|M0)               f3.0<1>:uw    r69.2<0;1,0>:uw                 
(W&f3.0) jmpi                                L45680                                
L45664:
        mov (16|M0)              r7.0<1>:ud    r101.0<1;1,0>:ud                 {Compacted}
        mov (16|M0)              r8.0<1>:f     r101.0<1;1,0>:f                  {Compacted}
L45680:
        mul (1|M0)               acc0.0<1>:d   r84.0<0;1,0>:d    r4.12<0;1,0>:uw 
        mach (1|M0)              r6.0<1>:d     r84.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        sync.nop                             null                             {Compacted,I@3}
        sync.allwr                           ($0,$3,$4,$6,$15)                
        sync.nop                             null                             {Compacted,$1.src}
        mul (16|M0)              r107.0<1>:f   r75.0<0;1,0>:f    r7.0<1;1,0>:f    {Compacted,$2.dst}
        sync.nop                             null                             {$2.dst}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r98.1<1>:d    r6.0<0;1,0>:d                    {Compacted,@2,$7.dst}
        mov (1|M0)               r98.0<1>:f    r5.0<0;1,0>:f                    {Compacted,I@2}
        sync.nop                             null                             {Compacted,$5.src}
        mov (1|M0)               r96.0<1>:f    r89.0<0;1,0>:f                   {Compacted,$11.src}
        shl (1|M0)               r98.0<1>:q    r98.0<0;1,0>:q    2:w               {Compacted,A@1}
        mov (16|M0)              r5.0<1>:f     r8.0<1;1,0>:f                    {Compacted}
        add (1|M0)               r109.0<1>:q   r69.2<0;1,0>:q    r98.0<0;1,0>:q   {Compacted,@1}
(W)     send.ugm (1|M0)          null     r69  r96:1  0x80200000:a0.1        0x4200D504           {F@2,$2} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        send.ugm (1|M0)          null     r109  r107:1  0x0            0x0200D584           {I@1,$1} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     jmpi                                 L56088                                
L45880:
        asr (1|M0)               r70.0<1>:d    r84.0<0;1,0>:d    31:w               {Compacted,$14.src}
(W)     mov (1|M0)               f1.1<1>:uw    r70.19<0;1,0>:uw                
        shr (1|M0)               r70.0<1>:ud   r70.0<0;1,0>:ud   0x1D:uw              {Compacted,I@2}
(W)     mov (1|M0)               f2.1<1>:uw    r70.18<0;1,0>:uw                
        add (1|M0)               r70.0<1>:d    r84.0<0;1,0>:d    r70.0<0;1,0>:d   {Compacted,I@2}
        asr (1|M0)               r70.0<1>:d    r70.0<0;1,0>:d    3:w               {I@1}
(f1.1)  mov (1|M0)               r70.0<1>:f    r84.0<0;1,0>:f                   {I@1}
        mul (1|M0)               acc0.0<1>:d   r70.0<0;1,0>:d    r4.0<0;1,0>:uw   {F@1}
        mach (1|M0)              r6.0<1>:d     r70.0<0;1,0>:d    r4.0<0;1,0>:d    {$0.src}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                 
        sync.allwr                           ($1,$2,$12)                
        mov (1|M0)               r108.1<1>:d   r6.0<0;1,0>:d                    {Compacted,@2,$0.dst}
        mov (1|M0)               r108.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@2}
        mov (16|M0)              r5.0<1>:f     0.0:f                               {Compacted}
        shl (1|M0)               r108.0<1>:q   r108.0<0;1,0>:q   1:w               {Compacted,A@1}
        add (1|M0)               r6.1<1>:q     r3.7<0;1,0>:q     r108.0<0;1,0>:q  {I@1}
(W&f2.1) jmpi                                L46136                                
L46096:
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$12.src}
        mov (16|M0)              r72.0<1>:f    r5.0<1;1,0>:f                    {Compacted,@1,$15.dst}
(W)     jmpi                                 L55872                                
L46136:
(W)     mov (1|M0)               r6.0<1>:uq    r4.7<0;1,0>:uq                   {Compacted}
        sync.nop                             null                             {Compacted,$7.src}
(W)     mov (1|M0)               r127.0<1>:uq  r69.5<0;1,0>:uq                  {Compacted,$3.src}
(W)     mov (1|M0)               r126.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted}
(W)     mov (1|M0)               r125.0<1>:uq  r6.1<0;1,0>:uq                   {Compacted,I@6}
        sync.allwr                           ($8,$10,$14)                
        sync.nop                             null                             {$12.src}
        send.ugm (1|M0)          r76      r6  null:0  0x0            0x024AF580           {I@4,$11} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r85      r127  null:0  0x0            0x024AF580           {I@3,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.allwr                           ($0,$7,$15)                
        send.ugm (1|M0)          r73      r126  null:0  0x0            0x0210D580           {I@2,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          r7       r125  null:0  0x0            0x0220E580           {I@1,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
(W)     mov (1|M0)               f2.0<1>:uw    r70.17<0;1,0>:uw                
(W&f2.0) jmpi                                L46464                                
L46328:
(W)     mov (1|M0)               r124.0<1>:uq  r69.4<0;1,0>:uq                  {Compacted,$10.src}
(W)     mov (1|M0)               r123.0<1>:uq  r69.3<0;1,0>:uq                  {Compacted,$11.src}
(W)     mov (1|M0)               r122.0<1>:uq  r69.1<0;1,0>:uq                  {Compacted,$14.src}
        sync.nop                             null                             {Compacted,$4.src}
(W)     mov (1|M0)               r121.0<1>:uq  r6.1<0;1,0>:uq                   {Compacted,$12.src}
        sync.nop                             null                             {Compacted,$7.dst}
        send.ugm (1|M0)          r13      r124  null:0  0x0            0x024AF580           {I@4,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$10.dst}
        send.ugm (1|M0)          r9       r123  null:0  0x0            0x024AF580           {I@3,$3} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {Compacted,$15.dst}
        send.ugm (1|M0)          r80      r122  null:0  0x40000            0x0210D580           {I@2,$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        sync.nop                             null                             {Compacted,$2.dst}
        send.ugm (1|M0)          r1       r121  null:0  0x80000            0x0220E580           {I@1,$4} // wr:1+0, rd:2; load.ugm.d32x32t.a64.flat[A+0x80]
L46464:
        sync.nop                             null                             {Compacted,F@1}
        mov (16|M0)              r72.0<1>:d    0:w                               {Compacted,$12.src}
        mov (1|M0)               r6.2<1>:q     0:w                               {$11.src}
L46496:
(W)     mov (1|M0)               f1.1<1>:uw    r70.16<0;1,0>:uw                
(W&f1.1) jmpi                                L54960                                
L46528:
        sync.allwr                           ($8,$14)                
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x4:uw              {$11.dst}
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$13.src}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r114.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$3.src}
        and (16|M0)              acc0.0<1>:ud  r113.0<1;1,0>:ud  0x80008000:ud              {I@2}
        sync.nop                             null                             {$5.src}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r114.0<1;0>:ud    r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$2.src}
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc0.0<1>:ud  r111.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r112.0<1;0>:ud    r6.0<0>:ud       {@2,$6.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$1.src}
        sync.nop                             null                             {$9.src}
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$11.src}
        and (16|M0)              acc0.0<1>:ud  r109.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r110.0<1;0>:ud    r6.0<0>:ud       {@2,$13.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x8:uw             
        sync.allwr                           ($0,$3,$4,$6,$15)                
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$2.dst}
        sync.allwr                           ($5,$12)                
        shl (16|M0)              r101.0<1>:d   r76.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r115.0<1>:d   r77.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r107.0<1;1,0>:ud  0x80008000:ud              {I@4}
        and (16|M0)              r123.0<1>:d   r76.0<1;1,0>:d    -2147450880:d               {$11.src}
        shl (16|M0)              r100.0<1>:d   r76.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r106.0<1>:d   r77.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r122.0<1>:d   r77.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r101.0<1>:d   r101.0<1;1,0>:d   -2147450880:d               {I@7}
        and (16|M0)              r115.0<1>:d   r115.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r108.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r76.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r123.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r77.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r89.0<1>:ud   r101.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r93.0<1>:ud   r115.0<1;0>:ud    r106.0<1;0>:ud    r6.0<0>:ud       {@6,$1.src} // s0|s1&s2
        bfn.0xEA (16|M0)         r96.0<1>:ud   r122.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
(W&f1.0) jmpi                                L47280                                
L47152:
        sync.allwr                           ($0,$3,$13,$14)                
        and (16|M0)              r105.0<1>:w   r73.0<1;1,0>:ub   127:w               {$5.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$9.dst}
        dpas.8x1 (16|M0)         r106:f        null:f            r89:hf            r7.0:hf          {$5}
        mov (16|M0)              r93.0<1>:d    r105.0<2;1,0>:ub                 {@1,$5.src}
        shl (16|M0)              r93.0<1>:d    r93.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r93.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r106.0<1>:f      {$5.dst}
(W)     jmpi                                 L47456                                
L47280:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L47456                                
L47360:
        sync.allwr                           ($0,$3,$13,$14)                
        and (16|M0)              r104.0<1>:w   r73.0<1;1,0>:ub   127:w               {$5.dst}
        sync.nop                             null                             {Compacted,$6.dst}
        sync.nop                             null                             {Compacted,$7.src}
        mov (16|M0)              r98.0<1>:d    r104.0<2;1,0>:ub                 {@1,$15.dst}
        shl (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r98.0<1>:f    r98.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r98.0<1;1,0>:ud  {F@1}
L47456:
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r101.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        sync.allwr                           ($6,$13)                
        sync.nop                             null                             {Compacted,$7.src}
        shl (16|M0)              r99.0<1>:d    r78.0<1;1,0>:d    12:w               {Compacted,$15.dst}
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        sync.allwr                           ($0,$3)                
        shl (16|M0)              r102.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$5.dst}
        and (16|M0)              acc0.0<1>:ud  r101.0<1;1,0>:ud  0x80008000:ud              {I@3}
        shl (16|M0)              r98.0<1>:d    r78.0<1;1,0>:d    9:w              
        and (16|M0)              r99.0<1>:d    r99.0<1;1,0>:d    -2147450880:d               {I@4}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r102.0<1;0>:ud    r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r89.0<1>:ud   r99.0<1;0>:ud     r98.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shl (16|M0)              r99.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r100.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r99.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r126.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        sync.nop                             null                             {Compacted,$14.dst}
        shl (16|M0)              r104.0<1>:d   r79.0<1;1,0>:d    12:w               {Compacted,$5.dst}
        shl (16|M0)              r127.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$8.src}
        and (16|M0)              acc0.0<1>:ud  r126.0<1;1,0>:ud  0x80008000:ud              {I@3}
        and (16|M0)              r121.0<1>:d   r78.0<1;1,0>:d    -2147450880:d               {$4.src}
        shl (16|M0)              r103.0<1>:d   r79.0<1;1,0>:d    9:w               {Compacted}
        sync.nop                             null                             {Compacted,$9.src}
        and (16|M0)              r120.0<1>:d   r79.0<1;1,0>:d    -2147450880:d               {$15.src}
        and (16|M0)              r104.0<1>:d   r104.0<1;1,0>:d   -2147450880:d               {I@6}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r127.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r78.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r121.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r79.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r104.0<1;0>:ud    r103.0<1;0>:ud    r6.0<0>:ud       {I@5} // s0|s1&s2
        bfn.0xEA (16|M0)         r96.0<1>:ud   r120.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
(W&f1.0) jmpi                                L48192                                
L48064:
        sync.nop                             null                             {Compacted,$0.dst}
        and (16|M0)              r102.0<1>:w   r73.16<1;1,0>:ub  127:w               {$13.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {$9.dst}
        dpas.8x1 (16|M0)         r125:f        null:f            r89:hf            r7.16:hf         {$5}
        mov (16|M0)              r92.0<1>:d    r102.0<2;1,0>:ub                 {@1,$5.src}
        shl (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r92.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r125.0<1>:f      {$5.dst}
(W)     jmpi                                 L48336                                
L48192:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L48336                                
L48272:
        sync.nop                             null                             {Compacted,$0.dst}
        and (16|M0)              r101.0<1>:w   r73.16<1;1,0>:ub  127:w               {$13.dst}
        mov (16|M0)              r97.0<1>:d    r101.0<2;1,0>:ub                 {I@1}
        shl (16|M0)              r97.0<1>:d    r97.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r97.0<1>:f    r97.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r97.0<1;1,0>:ud  {Compacted,F@1}
L48336:
        sync.allwr                           ($6,$12)                
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x4:uw              {$8.dst}
        shl (16|M0)              r122.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r123.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r122.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r123.0<1;0>:ud    r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r120.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r121.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r120.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r121.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x8:uw             
        sync.nop                             null                             {$0.src}
        shl (16|M0)              r118.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$9.src}
        shl (16|M0)              r119.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$10.src}
        and (16|M0)              acc0.0<1>:ud  r118.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r119.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r116.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw              {$2.src}
        shl (16|M0)              r97.0<1>:d    r85.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r124.0<1>:d   r86.0<1;1,0>:d    12:w               {Compacted,$10.src}
        shl (16|M0)              r117.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw              {$15.src}
        and (16|M0)              acc0.0<1>:ud  r116.0<1;1,0>:ud  0x80008000:ud              {I@4}
        and (16|M0)              r119.0<1>:d   r85.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r96.0<1>:d    r85.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r100.0<1>:d   r86.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r118.0<1>:d   r86.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r97.0<1>:d    r97.0<1;1,0>:d    -2147450880:d               {I@7}
        and (16|M0)              r124.0<1>:d   r124.0<1;1,0>:d   -2147450880:d               {I@7}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r117.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r85.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r119.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@7} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r86.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r89.0<1>:ud   r97.0<1;0>:ud     r96.0<1;0>:ud     r6.0<0>:ud       {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r93.0<1>:ud   r124.0<1;0>:ud    r100.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        bfn.0xEA (16|M0)         r96.0<1>:ud   r118.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
(W&f1.0) jmpi                                L49040                                
L48912:
        sync.nop                             null                             {Compacted,$0.dst}
        and (16|M0)              r99.0<1>:w    r73.32<1;1,0>:ub  127:w               {$13.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {$9.dst}
        dpas.8x1 (16|M0)         r115:f        null:f            r89:hf            r8.0:hf          {$5}
        mov (16|M0)              r91.0<1>:d    r99.0<2;1,0>:ub                  {@1,$5.src}
        shl (16|M0)              r91.0<1>:d    r91.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r91.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r115.0<1>:f      {$5.dst}
(W)     jmpi                                 L49200                                
L49040:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L49200                                
L49120:
        sync.nop                             null                             {$0.dst}
        and (16|M0)              r98.0<1>:w    r73.32<1;1,0>:ub  127:w               {$13.dst}
        mov (16|M0)              r96.0<1>:d    r98.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r96.0<1>:d    r96.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r96.0<1>:f    r96.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r96.0<1;1,0>:ud  {F@1}
L49200:
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r112.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
(W)     mov (1|M0)               r6.0<1>:f     0xE000E00:f                              
        shl (16|M0)              r113.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r112.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r113.0<1;0>:ud    r6.0<0>:ud       {A@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r95.0<1>:d    r87.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r110.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r94.0<1>:d    r87.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r111.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r95.0<1>:d    r95.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              acc0.0<1>:ud  r110.0<1;1,0>:ud  0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r89.0<1>:ud   r95.0<1;0>:ud     r94.0<1;0>:ud     r6.0<0>:ud       {I@2} // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r111.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r108.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r109.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r108.0<1;1,0>:ud  0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r109.0<1;0>:ud    r6.0<0>:ud       {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r106.0<1>:ud  acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r114.0<1>:d   r88.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r107.0<1>:ud  acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r106.0<1;1,0>:ud  0x80008000:ud              {I@3}
        and (16|M0)              r117.0<1>:d   r87.0<1;1,0>:d    -2147450880:d              
        shl (16|M0)              r97.0<1>:d    r88.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r116.0<1>:d   r88.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r114.0<1>:d   r114.0<1;1,0>:d   -2147450880:d               {I@6}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r107.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r87.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r117.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       {I@6} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r88.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r114.0<1;0>:ud    r97.0<1;0>:ud     r6.0<0>:ud       {I@5} // s0|s1&s2
        bfn.0xEA (16|M0)         r96.0<1>:ud   r116.0<1;0>:ud    acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
(W&f1.0) jmpi                                L49872                                
L49744:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$9.dst}
        dpas.8x1 (16|M0)         r105:f        null:f            r89:hf            r8.16:hf         {$5}
        sync.nop                             null                             {Compacted,$0.dst}
        sync.nop                             null                             {Compacted,$5.src}
        and (16|M0)              r94.0<1>:w    r73.48<1;1,0>:ub  127:w               {$13.dst}
        mov (16|M0)              r90.0<1>:d    r94.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r90.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r105.0<1>:f      {$5.dst}
(W)     jmpi                                 L50032                                
L49872:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L50032                                
L49952:
        sync.nop                             null                             {$0.dst}
        and (16|M0)              r93.0<1>:w    r73.48<1;1,0>:ub  127:w               {$13.dst}
        mov (16|M0)              r95.0<1>:d    r93.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r95.0<1>:d    r95.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r95.0<1>:f    r95.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r95.0<1;1,0>:ud  {F@1}
L50032:
(W)     mov (1|M0)               f3.1<1>:uw    r4.3<0;1,0>:uw                  
(W&~f3.1) jmpi                               L50712                                
L50064:
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.4<0;1,0>:d     0:w              
        cmp (1|M0)    (eq)f2.0   null<1>:d     r6.4<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.4<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r6.0<1>:hf    0x1:hf                             
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r6.5<0;1,0>:d     0:w              
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r6.5<0;1,0>:d     r70.7<0;1,0>:d  
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r6.5<0;1,0>:d     r70.5<0;1,0>:d  
(f2.1)  sel (1|M0)               r126.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw              {F@1}
(f2.0)  sel (1|M0)               r112.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(f1.1)  sel (1|M0)               r127.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r126.0<0;1,0>:uw  r112.0<0;1,0>:uw {I@2}
(f3.0)  sel (1|M0)               r113.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.0   null<1>:uw    r127.0<0;1,0>:uw  r113.0<0;1,0>:uw {I@1}
(W)     mov (1|M0)               r114.1<1>:uw  f3.0<0;1,0>:uw                  
        cmp (1|M0)    (eq)f3.0   null<1>:d     r6.4<0;1,0>:d     r70.2<0;1,0>:d  
(W)     mov (1|M0)               f3.1<1>:uw    r114.1<0;1,0>:uw                 {I@2}
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r6.5<0;1,0>:d     r70.3<0;1,0>:d  
(f3.1)  sel (1|M0)               r114.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f3.1   null<1>:uw    r114.0<0;1,0>:uw  0x1:uw              {I@1}
(f3.0)  sel (1|M0)               r125.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw              {$5.src}
(W)     mov (1|M0)               f3.0<1>:uw    r114.1<0;1,0>:uw                
(f3.1)  sel (1|M0)               r115.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
(W)     mov (1|M0)               r114.0<1>:uw  f3.1<0;1,0>:uw                  
        and (1|M0)    (ne)f3.1   null<1>:uw    r125.0<0;1,0>:uw  r115.0<0;1,0>:uw {I@2}
(f3.0)  sel (1|M0)               r6.1<1>:uw    r6.0<0;1,0>:uw    0x0:uw             
(f3.1)  sel (1|M0)               r116.0<1>:uw  r6.0<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r6.1<0;1,0>:uw    r116.0<0;1,0>:uw {I@1}
(W&~f3.1) jmpi                               L50712                                
L50512:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r5.0<0;1,0>:d     2143363909:d              
(W&f3.0) jmpi                                L50712                                
L50544:
        mov (2|M0)               r70.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r91.0<1>:hf   0x2:hf                              {A@1}
(W)     mov (1|M0)               r90.0<1>:hf   0.0:hf                             
(f1.1)  sel (1|M0)               r93.0<1>:d    r91.0<0;1,0>:w    3:w               {F@2}
(f2.0)  mov (1|M0)               r93.0<1>:d    1:w                              
(f2.0)  sel (1|M0)               r93.1<1>:d    r90.0<0;1,0>:w    0:w               {F@1}
(f2.1)  mov (1|M0)               r93.0<1>:d    0:w                              
(f2.1)  mov (1|M0)               r93.1<1>:d    0:w                              
        shl (1|M0)               r93.0<1>:q    r93.0<0;1,0>:q    3:w               {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r93.0<0;1,0>:q   {Compacted,I@1}
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          null     r6  r70:2  0x0            0x04000784           {I@1,$5} // wr:2+2, rd:0; store.ugm.d64.a64
L50712:
        add (1|M0)               r97.0<1>:q    r6.2<0;1,0>:q     2:w               {Compacted}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r97.1<0;1,0>:d    r69.15<0;1,0>:d  {I@1}
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r97.0<0;1,0>:ud   r69.14<0;1,0>:ud
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r97.1<0;1,0>:d    r69.15<0;1,0>:d 
(W&~f2.0) jmpi                               L50928                                
L50784:
        shl (1|M0)               r94.0<1>:q    r97.0<0;1,0>:q    9:w               {Compacted}
        shl (1|M0)               r92.0<1>:q    r97.0<0;1,0>:q    6:w               {Compacted}
        add (1|M0)               r94.0<1>:q    r4.7<0;1,0>:q     r94.0<0;1,0>:q   {Compacted,I@2}
        shl (1|M0)               r97.0<1>:q    r97.0<0;1,0>:q    7:w               {Compacted}
        send.ugm (1|M0)          r76      r94  null:0  0x0            0x024AF580           {I@2,$8} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r91.0<1>:q    r69.1<0;1,0>:q    r92.0<0;1,0>:q   {Compacted}
        add (1|M0)               r94.0<1>:q    r94.0<0;1,0>:q    256:w               {Compacted,$8.src}
        add (1|M0)               r90.0<1>:q    r6.1<0;1,0>:q     r97.0<0;1,0>:q   {Compacted,I@3}
        sync.nop                             null                             {Compacted,$0.dst}
        send.ugm (1|M0)          r73      r91  null:0  0x0            0x0210D580           {I@3,$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r85      r94  null:0  0x0            0x024AF580           {I@2,$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$9.dst}
        send.ugm (1|M0)          r7       r90  null:0  0x0            0x0220E580           {I@1,$5} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L50928:
        mov (2|M0)               r6.0<1>:d     0x1:v                               {$5.src}
        or (2|M0)                r6.0<1>:d     r6.4<1;1,0>:d     r6.0<1;1,0>:d    {I@1}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r6.0<0;1,0>:ud    r69.14<0;1,0>:ud
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r6.1<0;1,0>:d     r69.15<0;1,0>:d 
(W&~f1.1) jmpi                               L55792                                
L51024:
        sync.nop                             null                             {Compacted,$7.dst}
        shl (16|M0)              r98.0<1>:d    r14.0<1;1,0>:d    12:w               {Compacted,$10.dst}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r97.0<1>:d    r14.0<1;1,0>:d    9:w              
        and (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r98.0<1;0>:ud     r97.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {@2,$5.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {@2,$6.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {@2,$13.src} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r96.0<1>:d    r13.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r95.0<1>:d    r13.0<1;1,0>:d    9:w               {Compacted}
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r96.0<1>:d    r96.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@4}
        and (16|M0)              r104.0<1>:d   r13.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r103.0<1>:d   r14.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r89.0<1>:ud   r96.0<1;0>:ud     r95.0<1;0>:ud     r70.0<0>:ud      {I@4} // s0|s1&s2
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r13.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r104.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@5} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r14.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r103.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@6} // s0|s1&s2
(W&f1.0) jmpi                                L51712                                
L51584:
        sync.nop                             null                             {Compacted,I@2}
        sync.nop                             null                             {Compacted,$4.dst}
        dpas.8x1 (16|M0)         r97:f         null:f            r89:hf            r1.0:hf          {$2}
        sync.nop                             null                             {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$2.src}
        and (16|M0)              r89.0<1>:w    r80.0<1;1,0>:ub   127:w               {$14.dst}
        mov (16|M0)              r92.0<1>:d    r89.0<2;1,0>:ub                  {I@1}
        shl (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r92.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r97.0<1>:f       {$2.dst}
(W)     jmpi                                 L51856                                
L51712:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L51856                                
L51792:
        sync.nop                             null                             {Compacted,$15.dst}
        and (16|M0)              r84.8<1>:w    r80.0<1;1,0>:ub   127:w               {$14.dst}
        mov (16|M0)              r89.0<1>:d    r84.16<2;1,0>:ub                 {I@1}
        shl (16|M0)              r89.0<1>:d    r89.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              r89.0<1>:f    r89.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r89.0<1;1,0>:ud  {Compacted,F@1}
L51856:
        shl (16|M0)              r94.0<1>:d    r15.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r98.0<1>:d    r16.0<1;1,0>:d    12:w               {Compacted}
        shl (16|M0)              r93.0<1>:d    r15.0<1;1,0>:d    9:w               {Compacted}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r97.0<1>:d    r16.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r94.0<1>:d    r94.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    -2147450880:d               {I@4}
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r89.0<1>:ud   r94.0<1;0>:ud     r93.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        bfn.0xEA (16|M0)         r93.0<1>:ud   r98.0<1;0>:ud     r97.0<1;0>:ud     r70.0<0>:ud      {I@3} // s0|s1&s2
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r102.0<1>:d   r15.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r101.0<1>:d   r16.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r15.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r102.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r16.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r101.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@5} // s0|s1&s2
(W&f1.0) jmpi                                L52528                                
L52400:
        sync.nop                             null                             {$15.dst}
        and (16|M0)              r75.2<1>:w    r80.16<1;1,0>:ub  127:w               {$14.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$4.dst}
        dpas.8x1 (16|M0)         r97:f         null:f            r89:hf            r1.16:hf         {$2}
        mov (16|M0)              r91.0<1>:d    r75.4<2;1,0>:ub                  {@1,$2.src}
        shl (16|M0)              r91.0<1>:d    r91.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r91.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r97.0<1>:f       {$2.dst}
(W)     jmpi                                 L52672                                
L52528:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L52672                                
L52608:
        sync.nop                             null                             {Compacted,$15.dst}
        and (16|M0)              r6.12<1>:w    r80.16<1;1,0>:ub  127:w               {$14.dst}
        mov (16|M0)              r127.0<1>:d   r6.24<2;1,0>:ub                  {I@1}
        shl (16|M0)              r127.0<1>:d   r127.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r127.0<1>:f   r127.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r127.0<1;1,0>:ud {Compacted,F@1}
L52672:
        sync.nop                             null                             {Compacted,$10.dst}
        shl (16|M0)              r98.0<1>:d    r10.0<1;1,0>:d    12:w               {Compacted,$3.dst}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r97.0<1>:d    r10.0<1;1,0>:d    9:w              
        and (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x4:uw             
        bfn.0xEA (16|M0)         r93.0<1>:ud   r98.0<1;0>:ud     r97.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x8:uw             
        shl (16|M0)              r92.0<1>:d    r9.0<1;1,0>:d     12:w               {Compacted}
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r91.0<1>:d    r9.0<1;1,0>:d     9:w               {Compacted}
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              r92.0<1>:d    r92.0<1;1,0>:d    -2147450880:d               {I@4}
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r89.0<1>:ud   r92.0<1;0>:ud     r91.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        and (16|M0)              r100.0<1>:d   r9.0<1;1,0>:d     -2147450880:d              
        and (16|M0)              r99.0<1>:d    r10.0<1;1,0>:d    -2147450880:d              
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r9.0<1;1,0>:ud    0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r100.0<1;0>:ud    acc0.0<1;0>:ud    r70.0<0>:ud      {I@4} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r10.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r99.0<1;0>:ud     acc0.0<1;0>:ud    r70.0<0>:ud      {I@5} // s0|s1&s2
(W&f1.0) jmpi                                L53360                                
L53232:
        sync.nop                             null                             {$15.dst}
        and (16|M0)              r127.0<1>:w   r80.32<1;1,0>:ub  127:w               {$14.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$4.dst}
        dpas.8x1 (16|M0)         r97:f         null:f            r89:hf            r2.0:hf          {$2}
        mov (16|M0)              r90.0<1>:d    r127.0<2;1,0>:ub                 {@1,$2.src}
        shl (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r90.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r97.0<1>:f       {$2.dst}
(W)     jmpi                                 L53504                                
L53360:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L53504                                
L53440:
        sync.nop                             null                             {Compacted,$15.dst}
        and (16|M0)              r126.0<1>:w   r80.32<1;1,0>:ub  127:w               {$14.dst}
        mov (16|M0)              r126.0<1>:d   r126.0<2;1,0>:ub                 {I@1}
        shl (16|M0)              r126.0<1>:d   r126.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r126.0<1>:f   r126.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r126.0<1;1,0>:ud {Compacted,F@1}
L53504:
        shl (16|M0)              r98.0<1>:d    r12.0<1;1,0>:d    12:w               {Compacted}
(W)     mov (1|M0)               r70.0<1>:f    0xE000E00:f                              
        shl (16|M0)              r97.0<1>:d    r12.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r98.0<1>:d    r98.0<1;1,0>:d    -2147450880:d               {I@2}
        shr (16|M0)              acc0.0<1>:ud  r11.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r90.0<1>:d    r11.0<1;1,0>:d    12:w               {Compacted}
        bfn.0xEA (16|M0)         r93.0<1>:ud   r98.0<1;0>:ud     r97.0<1;0>:ud     r70.0<0>:ud      {A@1} // s0|s1&s2
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r89.0<1>:d    r11.0<1;1,0>:d    9:w               {Compacted}
        and (16|M0)              r90.0<1>:d    r90.0<1;1,0>:d    -2147450880:d               {I@4}
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@4}
        bfn.0xEA (16|M0)         r89.0<1>:ud   r90.0<1;0>:ud     r89.0<1;0>:ud     r70.0<0>:ud      {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r90.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r12.0<1;1,0>:ud   0x4:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r94.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r11.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r91.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r12.0<1;1,0>:ud   0x8:uw             
        shl (16|M0)              r97.0<1>:ud   acc0.0<1;1,0>:ud  0xC:uw             
        shl (16|M0)              r98.0<1>:ud   acc0.0<1;1,0>:ud  0x9:uw             
        and (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x80008000:ud              {I@2}
        bfn.0xEA (16|M0)         r95.0<1>:ud   acc0.0<1;0>:ud    r98.0<1;0>:ud     r70.0<0>:ud      {I@2} // s0|s1&s2
        and (16|M0)              r98.0<1>:d    r11.0<1;1,0>:d    -2147450880:d              
        and (16|M0)              r97.0<1>:d    r12.0<1;1,0>:d    -2147450880:d              
        shr (16|M0)              acc0.0<1>:ud  r11.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r92.0<1>:ud   r98.0<1;0>:ud     acc0.0<1;0>:ud    r70.0<0>:ud      {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r12.0<1;1,0>:ud   0x3:uw             
        bfn.0xEA (16|M0)         r96.0<1>:ud   r97.0<1;0>:ud     acc0.0<1;0>:ud    r70.0<0>:ud      {I@4} // s0|s1&s2
(W&f1.0) jmpi                                L54176                                
L54048:
        sync.nop                             null                             {Compacted,$15.dst}
        sync.nop                             null                             {Compacted,$5.src}
        and (16|M0)              r125.0<1>:w   r80.48<1;1,0>:ub  127:w               {$14.dst}
        sync.nop                             null                             {Compacted,I@3}
        sync.nop                             null                             {Compacted,$4.dst}
        dpas.8x1 (16|M0)         r97:f         null:f            r89:hf            r2.16:hf         {$2}
        mov (16|M0)              r89.0<1>:d    r125.0<2;1,0>:ub                 {@1,$2.src}
        shl (16|M0)              r89.0<1>:d    r89.0<1;1,0>:d    20:w               {Compacted,I@1}
        mul (16|M0)              acc0.0<1>:f   r89.0<1;1,0>:f    1.329228e+36:f               {Compacted,I@1}
        mad (16|M0)              r5.0<1>:f     r5.0<1;0>:f       acc0.0<1;0>:f     r97.0<1>:f       {$2.dst}
(W)     jmpi                                 L54336                                
L54176:
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r91.0<1;0>:ud     r89.0<1;0>:ud     r90.0<1>:ud      {F@1} // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r93.0<1;0>:ud     acc0.0<1;0>:ud    r92.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r95.0<1;0>:ud     acc0.0<1;0>:ud    r94.0<1>:ud      // s0^s1^s2
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r96.0<1>:ud      // s0^s1^s2
(W&~f0.1) jmpi                               L54336                                
L54256:
        sync.nop                             null                             {$15.dst}
        and (16|M0)              r124.0<1>:w   r80.48<1;1,0>:ub  127:w               {$14.dst}
        mov (16|M0)              r125.0<1>:d   r124.0<2;1,0>:ub                 {@1,$5.src}
        shl (16|M0)              r125.0<1>:d   r125.0<1;1,0>:d   20:w               {Compacted,I@1}
        mul (16|M0)              r125.0<1>:f   r125.0<1;1,0>:f   1.329228e+36:f               {Compacted,I@1}
        xor (16|M0)              r72.0<1>:ud   r72.0<1;1,0>:ud   r125.0<1;1,0>:ud {F@1}
L54336:
(W)     mov (1|M0)               f3.1<1>:uw    r4.3<0;1,0>:uw                  
(W&~f3.1) jmpi                               L54864                                
L54368:
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.0<0;1,0>:d     r70.6<0;1,0>:d  
        cmp (1|M0)    (eq)f3.1   null<1>:d     r6.0<0;1,0>:d     r70.4<0;1,0>:d  
(W)     mov (1|M0)               r124.0<1>:hf  0x1:hf                             
        cmp (1|M0)    (eq)f2.1   null<1>:d     r6.0<0;1,0>:d     r70.2<0;1,0>:d  
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r6.1<0;1,0>:d     r70.7<0;1,0>:d  
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:d     r6.1<0;1,0>:d     r70.5<0;1,0>:d  
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r6.1<0;1,0>:d     r70.3<0;1,0>:d  
(f1.1)  sel (1|M0)               r108.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw              {F@1}
(f3.1)  sel (1|M0)               r124.1<1>:uw  r124.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r124.1<0;1,0>:uw  r108.0<0;1,0>:uw {I@1}
(f2.0)  sel (1|M0)               r109.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw             
(f2.0)  sel (1|M0)               r125.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw              {$5.src}
        xor (1|M0)    (ne)f3.0   null<1>:uw    r109.0<0;1,0>:uw  0x1:uw              {I@2}
(W)     mov (1|M0)               r124.1<1>:uw  f3.0<0;1,0>:uw                  
(f3.0)  sel (1|M0)               r110.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw             
(f2.1)  sel (1|M0)               r124.1<1>:uw  r124.0<0;1,0>:uw  0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r124.1<0;1,0>:uw  r110.0<0;1,0>:uw {I@1}
(f2.1)  sel (1|M0)               r111.0<1>:uw  r124.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f2.1   null<1>:uw    r125.0<0;1,0>:uw  r111.0<0;1,0>:uw {I@1}
(W&~f2.1) jmpi                               L54864                                
L54688:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r5.0<0;1,0>:d     2143363909:d              
(W&f2.0) jmpi                                L54864                                
L54720:
        mov (2|M0)               r70.0<1>:d    tm0.0<1;1,0>:ud                  {A@1}
(W)     mov (1|M0)               r89.0<1>:hf   0x2:hf                              {A@1}
(W)     mov (1|M0)               r84.2<1>:hf   0.0:hf                             
(f3.1)  sel (1|M0)               r70.10<1>:d   r89.0<0;1,0>:w    3:w               {F@2}
(f1.1)  mov (1|M0)               r70.10<1>:d   1:w                              
(f1.1)  sel (1|M0)               r70.11<1>:d   r84.2<0;1,0>:w    0:w               {F@1}
        shl (1|M0)               r70.5<1>:q    r70.5<0;1,0>:q    3:w               {I@1}
        add (1|M0)               r6.0<1>:q     r4.6<0;1,0>:q     r70.5<0;1,0>:q   {Compacted,I@1}
        sync.nop                             null                             {Compacted,$9.dst}
        send.ugm (1|M0)          null     r6  r70:2  0x0            0x04000784           {I@1,$5} // wr:2+2, rd:0; store.ugm.d64.a64
L54864:
        add (1|M0)               r126.0<1>:q   r6.2<0;1,0>:q     3:w              
        cmp (1|M0)    (eq)f3.1   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d  {I@1}
(f3.1)  cmp (1|M0)    (lt)f3.1   null<1>:ud    r126.0<0;1,0>:ud  r69.14<0;1,0>:ud
(~f3.1) cmp (1|M0)    (lt)f3.1   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d 
(W&f3.1) jmpi                                L55632                                
L54944:
(W)     jmpi                                 L55792                                
L54960:
        add (1|M0)               r127.0<1>:q   r6.2<0;1,0>:q     2:w               {$8.src}
        sync.allwr                           ($8,$14)                
        sync.nop                             null                             {Compacted,$3.src}
        xor (16|M0)              r123.0<1>:d   r76.0<1;1,0>:d    r77.0<1;1,0>:d   {Compacted,$11.dst}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r127.1<0;1,0>:d   r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r79.0<1;0>:ud     r123.0<1;0>:ud    r78.0<1>:ud      {I@2} // s0^s1^s2
        sync.allwr                           ($6,$12)                
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r86.0<1;0>:ud     acc0.0<1;0>:ud    r85.0<1>:ud      // s0^s1^s2
(f3.0)  cmp (1|M0)    (lt)f3.0   null<1>:ud    r127.0<0;1,0>:ud  r69.14<0;1,0>:ud
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r88.0<1;0>:ud     acc0.0<1;0>:ud    r87.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {Compacted,$9.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r8.0<1;0>:ud      acc0.0<1;0>:ud    r7.0<1>:ud       {$5.dst} // s0^s1^s2
(~f3.0) cmp (1|M0)    (lt)f3.0   null<1>:d     r127.1<0;1,0>:d   r69.15<0;1,0>:d 
        sync.nop                             null                             {Compacted,$0.dst}
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r73.0<1>:ud      {$13.dst} // s0^s1^s2
(W&~f3.0) jmpi                               L55312                                
L55184:
        shl (1|M0)               r93.0<1>:q    r127.0<0;1,0>:q   9:w               {Compacted,$1.src}
        shl (1|M0)               r122.0<1>:q   r127.0<0;1,0>:q   6:w               {Compacted,$14.src}
        add (1|M0)               r93.0<1>:q    r4.7<0;1,0>:q     r93.0<0;1,0>:q   {Compacted,I@2}
        shl (1|M0)               r127.0<1>:q   r127.0<0;1,0>:q   7:w               {Compacted}
        send.ugm (1|M0)          r76      r93  null:0  0x0            0x024AF580           {I@2,$14} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r121.0<1>:q   r69.1<0;1,0>:q    r122.0<0;1,0>:q  {Compacted,$4.src}
        add (1|M0)               r93.0<1>:q    r93.0<0;1,0>:q    256:w               {Compacted,$14.src}
        add (1|M0)               r120.0<1>:q   r6.1<0;1,0>:q     r127.0<0;1,0>:q  {@3,$15.src}
        send.ugm (1|M0)          r73      r121  null:0  0x0            0x0210D580           {I@3,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r85      r93  null:0  0x0            0x024AF580           {I@2,$12} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        send.ugm (1|M0)          r7       r120  null:0  0x0            0x0220E580           {I@1,$9} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L55312:
        mov (2|M0)               r75.16<1>:w   0x1010101:v                              
        or (2|M0)                r94.0<1>:d    r6.4<1;1,0>:d     r75.16<1;1,0>:w  {I@1}
        cmp (1|M0)    (eq)f2.1   null<1>:d     r94.1<0;1,0>:d    r69.15<0;1,0>:d  {I@1}
(f2.1)  cmp (1|M0)    (lt)f2.1   null<1>:ud    r94.0<0;1,0>:ud   r69.14<0;1,0>:ud
(~f2.1) cmp (1|M0)    (lt)f2.1   null<1>:d     r94.1<0;1,0>:d    r69.15<0;1,0>:d 
(W&~f2.1) jmpi                               L55792                                
L55408:
        add (1|M0)               r126.0<1>:q   r6.2<0;1,0>:q     3:w               {Compacted}
        sync.nop                             null                             {Compacted,$7.dst}
        sync.nop                             null                             {Compacted,$14.src}
        xor (16|M0)              r119.0<1>:d   r13.0<1;1,0>:d    r14.0<1;1,0>:d   {Compacted,$10.dst}
        cmp (1|M0)    (eq)f2.0   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d  {I@2}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r16.0<1;0>:ud     r119.0<1;0>:ud    r15.0<1>:ud      {I@2} // s0^s1^s2
        sync.nop                             null                             {$10.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r10.0<1;0>:ud     acc0.0<1;0>:ud    r9.0<1>:ud       {$3.dst} // s0^s1^s2
(f2.0)  cmp (1|M0)    (lt)f2.0   null<1>:ud    r126.0<0;1,0>:ud  r69.14<0;1,0>:ud
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r12.0<1;0>:ud     acc0.0<1;0>:ud    r11.0<1>:ud      // s0^s1^s2
        sync.nop                             null                             {$2.dst}
        bfn.0x96 (16|M0)         acc0.0<1>:ud  r2.0<1;0>:ud      acc0.0<1;0>:ud    r1.0<1>:ud       {$4.dst} // s0^s1^s2
(~f2.0) cmp (1|M0)    (lt)f2.0   null<1>:d     r126.1<0;1,0>:d   r69.15<0;1,0>:d 
        sync.nop                             null                             {$15.dst}
        bfn.0x96 (16|M0)         r72.0<1>:ud   r72.0<1;0>:ud     acc0.0<1;0>:ud    r80.0<1>:ud      {$14.dst} // s0^s1^s2
(W&~f2.0) jmpi                               L55792                                
L55632:
        shl (1|M0)               r92.0<1>:q    r126.0<0;1,0>:q   9:w               {Compacted}
        sync.nop                             null                             {Compacted,$0.src}
        shl (1|M0)               r118.0<1>:q   r126.0<0;1,0>:q   6:w               {Compacted,$9.src}
        add (1|M0)               r92.0<1>:q    r4.7<0;1,0>:q     r92.0<0;1,0>:q   {Compacted,I@2}
        shl (1|M0)               r126.0<1>:q   r126.0<0;1,0>:q   7:w              
        send.ugm (1|M0)          r13      r92  null:0  0x0            0x024AF580           {I@2,$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        add (1|M0)               r117.0<1>:q   r69.1<0;1,0>:q    r118.0<0;1,0>:q  {Compacted,$8.src}
        add (1|M0)               r92.0<1>:q    r92.0<0;1,0>:q    256:w               {Compacted,$7.src}
        add (1|M0)               r116.0<1>:q   r6.1<0;1,0>:q     r126.0<0;1,0>:q  {Compacted,I@3}
        sync.nop                             null                             {Compacted,$14.dst}
        send.ugm (1|M0)          r80      r117  null:0  0x0            0x0210D580           {I@3,$15} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        send.ugm (1|M0)          r9       r92  null:0  0x0            0x024AF580           {I@2,$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.st.uc
        sync.nop                             null                             {$4.dst}
        send.ugm (1|M0)          r1       r116  null:0  0x0            0x0220E580           {I@1,$2} // wr:1+0, rd:2; load.ugm.d32x32t.a64
L55792:
        add (1|M0)               r6.2<1>:q     r6.2<0;1,0>:q     2:w               {$5.src}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r6.5<0;1,0>:d     r69.15<0;1,0>:d  {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r6.4<0;1,0>:ud    r69.14<0;1,0>:ud
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:d     r6.5<0;1,0>:d     r69.15<0;1,0>:d 
(W&f1.1) jmpi                                L46496                                
L55872:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r84.2<0;1,0>:d    1:w              
(W)     mov (1|M0)               r125.0<1>:hf  0x1:hf                              {$5.src}
(W)     mov (1|M0)               r70.0<1>:uw   r69.3<0;1,0>:uw                 
        sync.nop                             null                             {F@1}
        sync.allwr                           ($0,$3,$4,$6,$15)                
        sync.nop                             null                             {$1.src}
(f0.0)  sel (1|M0)               r107.0<1>:uw  r125.0<0;1,0>:uw  0x0:uw              {$2.dst}
(f2.0)  sel (1|M0)               r107.1<1>:uw  r125.0<0;1,0>:uw  0x0:uw             
(W)     mov (1|M0)               f3.1<1>:uw    r70.0<0;1,0>:uw                  {I@3}
        and (1|M0)    (ne)f0.0   null<1>:uw    r107.1<0;1,0>:uw  r107.0<0;1,0>:uw {I@2}
(~f3.1) mov (16|M0)              r5.0<1>:f     r72.0<1;1,0>:f                  
(W&~f0.0) jmpi                               L56224                                
L56064:
        mov (1|M0)               r95.0<1>:f    r84.0<0;1,0>:f                   {Compacted,$4.src}
(W)     send.ugm (1|M0)          null     r69  r95:1  0x80200000:a0.1        0x4200D504           {F@1,$11} // wr:1+1, rd:0; store.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
L56088:
(W)     send.ugm (1|M0)          r84      r69  null:0  0x80200000:a0.1        0x4210D500           {$3} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ss[a0.1][A-0xFFC0]
        sync.nop                             null                             {Compacted,$11.src}
        mul (16|M0)              r97.0<1>:f    r75.0<0;1,0>:f    r5.0<1;1,0>:f    {$3.src}
        mul (1|M0)               acc0.0<1>:d   r84.0<0;1,0>:d    r4.12<0;1,0>:uw  {$3.dst}
        mach (1|M0)              r6.0<1>:d     r84.0<0;1,0>:d    r4.6<0;1,0>:d    {Compacted}
        mov (1|M0)               r5.0<1>:d     acc0.0<0;1,0>:d                  {F@1}
        mov (1|M0)               r126.1<1>:d   r6.0<0;1,0>:d                    {Compacted,I@2}
        mov (1|M0)               r126.0<1>:f   r5.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r126.0<1>:q   r126.0<0;1,0>:q   2:w               {Compacted,A@1}
        sync.nop                             null                             {Compacted,$12.src}
        add (1|M0)               r115.0<1>:q   r69.2<0;1,0>:q    r126.0<0;1,0>:q  {Compacted,@1,$5.src}
        send.ugm (1|M0)          null     r115  r97:1  0x0            0x0200D584           {I@1,$1} // wr:1+1, rd:0; store.ugm.d32x16t.a64
L56224:
        sync.allrd                           ($2,$7,$9,$10,$11,$14)                
        add (1|M0)               r69.6<1>:q    r69.6<0;1,0>:q    8:w               {$12.src}
        sync.allwr                           ($6,$8,$10,$12)                
        mov (1|M0)               r85.0<1>:q    r74.1<0;1,0>:ud                  {$5.dst}
        cmp (1|M0)    (eq)f1.1   null<1>:d     r69.13<0;1,0>:d   r85.1<0;1,0>:d   {I@1}
(f1.1)  cmp (1|M0)    (lt)f1.1   null<1>:ud    r69.12<0;1,0>:ud  r85.0<0;1,0>:ud 
(~f1.1) cmp (1|M0)    (lt)f1.1   null<1>:ud    r69.13<0;1,0>:ud  r85.1<0;1,0>:ud 
(W&f1.1) jmpi                                L2832                                
L56352:
(W)     mov (1|M0)               f3.0<1>:uw    r4.2<0;1,0>:uw                  
(W&f3.0) jmpi                                L56480                                
L56384:
        mov (1|M0)               r70.0<1>:q    r4.4<0;1,0>:q                    {$14.src}
        sync.nop                             null                             {Compacted,A@1}
        sync.nop                             null                             {Compacted,$7.src}
        mov (2|M0)               r114.0<1>:d   tm0.0<1;1,0>:ud                  {$3.src}
        mov (1|M0)               r70.1<1>:q    r114.0<0;1,0>:q                  {A@1}
        sync.nop                             null                             {Compacted,$9.src}
(W)     mov (1|M0)               r120.0<1>:uq  r4.5<0;1,0>:uq                   {Compacted,$15.src}
        send.ugm (1|M0)          null     r120  r70:1  0x0            0x02009784           {I@1,$1} // wr:1+1, rd:0; store.ugm.d64x2t.a64
L56480:
        sync.nop                             null                             {Compacted,$12.src}
(W)     mov (16|M0)              r112.0<1>:f   r71.0<1;1,0>:f                   {Compacted,$10.src}
(W)     send.gtwy (1|M0)         null     r112  null:0  0x0            0x02000010           {EOT,F@1,$2} // wr:1+0, rd:0; end of thread
L56512:
        mov (2|M0)               r70.0<1>:d    0x1:v                              
        mov (1|M0)               r69.1<1>:d    63:w                               {Compacted}
        mov (1|M0)               r88.0<1>:q    0:w                              
L56552:
        shr (1|M0)               r89.0<1>:uq   r121.0<0;1,0>:uq  r69.1<0;1,0>:ud  {I@2}
        shl (1|M0)               r88.0<1>:q    r88.0<0;1,0>:q    1:w               {Compacted,I@2}
(W)     mov (1|M0)               r123.0<1>:hf  0x1:hf                             
        bfn.0xEA (2|M0)          r89.0<1>:ud   r88.0<1;0>:ud     r89.0<1;0>:ud     r70.0<1>:ud      {I@1} // s0|s1&s2
        add (1|M0)               r126.0<1>:ud  r69.1<0;1,0>:ud   0xFFFFFFFF:ud             
        cmp (1|M0)    (lt)f3.0   null<1>:ud    r89.0<0;1,0>:ud   r6.2<0;1,0>:ud   {I@2}
        cmp (1|M0)    (lt)f1.0   null<1>:ud    r89.1<0;1,0>:ud   r6.3<0;1,0>:ud  
        add (1|M0)               r88.0<1>:q    r89.0<0;1,0>:q    -r6.1<0;1,0>:q  
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r89.1<0;1,0>:d    r6.3<0;1,0>:d   
(f1.0)  sel (1|M0)               r106.0<1>:uw  r123.0<0;1,0>:uw  0x0:uw              {F@1}
(f3.0)  sel (1|M0)               r73.4<1>:uw   r123.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r73.4<0;1,0>:uw   r106.0<0;1,0>:uw {I@1}
(f3.1)  mov (1|M0)               r88.0<1>:f    r89.0<0;1,0>:f                  
(f3.1)  mov (1|M0)               r88.1<1>:f    r89.1<0;1,0>:f                  
        cmp (1|M0)    (eq)f3.1   null<1>:d     r69.1<0;1,0>:d    0:w               {F@1}
(W&f3.1) jmpi                                L56832                                
L56800:
        mov (1|M0)               r69.1<1>:d    r126.0<0;1,0>:d                 
(W)     jmpi                                 L56552                                
L56832:
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
        ret (32|M0)                          r73.0                            {A@1}
L56880:
        mov (2|M0)               r126.0<1>:d   0x1:v                              
        mov (1|M0)               r125.0<1>:d   63:w                               {Compacted}
        mov (1|M0)               r123.0<1>:q   0:w                              
        mov (1|M0)               r123.1<1>:q   0:w                              
L56936:
        mov (1|M0)               r120.0<1>:q   r125.0<0;1,0>:ud                 {I@3}
        shl (1|M0)               r123.0<1>:q   r123.0<0;1,0>:q   1:w               {Compacted,I@3}
        shr (1|M0)               r5.0<1>:uq    r124.0<0;1,0>:uq  r120.0<0;1,0>:uq {I@2}
(W)     mov (1|M0)               r127.0<1>:hf  0x1:hf                             
        bfn.0xEA (2|M0)          r5.0<1>:ud    r123.0<1;0>:ud    r5.0<1;0>:ud      r126.0<1>:ud     {I@1} // s0|s1&s2
        cmp (1|M0)    (eq)f3.0   null<1>:d     r125.0<0;1,0>:d   0:w              
        cmp (1|M0)    (lt)f2.1   null<1>:ud    r5.0<0;1,0>:ud    r124.2<0;1,0>:ud {I@2}
        cmp (1|M0)    (lt)f0.1   null<1>:ud    r5.1<0;1,0>:ud    r124.3<0;1,0>:ud
        shl (1|M0)               r120.0<1>:uq  r127.0<0;1,0>:uw  r120.0<0;1,0>:uq {F@1}
        add (1|M0)               r88.4<1>:ud   r125.0<0;1,0>:ud  0xFFFFFFFF:ud             
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r5.1<0;1,0>:d     r124.3<0;1,0>:d 
(f0.1)  sel (1|M0)               r105.0<1>:uw  r127.0<0;1,0>:uw  0x0:uw             
        add (1|M0)               r123.0<1>:q   r5.0<0;1,0>:q     -r124.1<0;1,0>:q
        or (2|M0)                r120.0<1>:d   r120.0<1;1,0>:d   r123.2<1;1,0>:d  {I@5}
(f2.1)  sel (1|M0)               r1.0<1>:uw    r127.0<0;1,0>:uw  0x0:uw             
        or (1|M0)     (ne)f1.0   null<1>:uw    r1.0<0;1,0>:uw    r105.0<0;1,0>:uw {I@1}
(f1.0)  mov (1|M0)               r123.0<1>:f   r5.0<0;1,0>:f                   
(f1.0)  mov (1|M0)               r123.1<1>:f   r5.1<0;1,0>:f                   
(f1.0)  mov (1|M0)               r120.0<1>:ud  r123.2<0;1,0>:d                 
(f1.0)  mov (1|M0)               r120.1<1>:ud  r123.3<0;1,0>:d                 
(W&f3.0) jmpi                                L57312                                
L57264:
        mov (1|M0)               r125.0<1>:d   r88.4<0;1,0>:d                  
        mov (1|M0)               r123.1<1>:q   r120.0<0;1,0>:q                  {I@3}
(W)     jmpi                                 L56936                                
L57312:
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
        ret (32|M0)                          r72.0                            {A@1}
L57360:
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
