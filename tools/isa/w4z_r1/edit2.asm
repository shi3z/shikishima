L0:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                              {A@1}
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud             
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw             
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x360:ud              {I@2}
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1}
(W)     send.ugm (1|M0)          r1       r127  null:0  0xFF000000            0x6219D500           {A@1,$0} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255]
        nop                    
        nop                    
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src}
(W)     send.ugm (1|M0)          r2       r127  null:0  0xFF000000            0x6249F500           {A@1,$1} // wr:1+0, rd:4; load.ugm.d32x64t.a32.ca.cc.bti[255]
(W)     send.ugm (1|M0)          r6       r127  null:0  0xFF100000            0x6249F500           {$2} // wr:1+0, rd:4; load.ugm.d32x64t.a32.ca.cc.bti[255][A+0x100]
(W)     send.ugm (1|M0)          r10      r127  null:0  0xFF200000            0x6249F500           {$3} // wr:1+0, rd:4; load.ugm.d32x64t.a32.ca.cc.bti[255][A+0x200]
(W)     send.ugm (1|M0)          r14      r127  null:0  0xFF300000            0x6219D500           {$4} // wr:1+0, rd:1; load.ugm.d32x16t.a32.ca.cc.bti[255][A+0x300]
(W)     send.ugm (1|M0)          r15      r127  null:0  0xFF340000            0x6219C500           {$5} // wr:1+0, rd:1; load.ugm.d32x8t.a32.ca.cc.bti[255][A+0x340]
(W)     mov (16|M0)              r72.0<1>:ud   r0.0<1;1,0>:ud                  
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743040:d               {A@1}
(W)     mov (1|M0)               f2.0<1>:ud    0xFFFFFFCF:ud                              {A@1}
        sync.nop                             null                             {$2.dst}
        mov (16|M0)              r2.0<1>:q     r8.2<0;1,0>:q                    {$1.dst}
(W)     mov (1|M0)               f1.0<1>:ud    0xFFFFFF3F:ud                             
(W)     mov (1|M0)               f0.0<1>:ud    0xFFFF3FFF:ud                             
        mov (1|M0)               r74.0<1>:q    r8.0<0;1,0>:q                   
        mov (1|M0)               r74.1<1>:q    r8.1<0;1,0>:q                   
        mov (16|M0)              r4.0<1>:q     r8.3<0;1,0>:q                   
(W)     mov (1|M0)               f3.0<1>:ud    0xFFFCFFFF:ud                             
(~f2.0) mov (32|M0)              r74.0<1>:f    r2.0<1;1,0>:f                    {I@3}
        mov (16|M0)              r6.0<1>:q     r8.7<0;1,0>:q                   
(W)     mov (1|M0)               f2.0<1>:ud    0xFFF3FFFF:ud                              {F@1}
        mov (16|M0)              r16.0<1>:q    r9.0<0;1,0>:q                   
(~f1.0) mov (32|M0)              r74.0<1>:f    r4.0<1;1,0>:f                    {I@5}
        mov (16|M0)              r18.0<1>:q    r9.1<0;1,0>:q                   
(~f0.0) mov (32|M0)              r74.0<1>:f    r6.0<1;1,0>:f                    {I@4}
(W)     mov (1|M0)               f1.0<1>:ud    0xFFCFFFFF:ud                              {F@2}
(~f3.0) mov (32|M0)              r74.0<1>:f    r16.0<1;1,0>:f                   {I@3}
(W)     mov (1|M0)               f0.0<1>:ud    0xCFFFFFFF:ud                              {F@2}
        mov (16|M0)              r20.0<1>:q    r9.2<0;1,0>:q                   
(~f2.0) mov (32|M0)              r74.0<1>:f    r18.0<1;1,0>:f                   {I@4}
(W)     mov (1|M0)               f3.0<1>:ud    0x3FFFFFFF:ud                              {F@2}
        mov (16|M0)              r22.0<1>:q    r9.6<0;1,0>:q                   
(W)     mov (1|M0)               f2.0<1>:ud    0xFFFFFFFC:ud                              {F@1}
        mov (16|M0)              r24.0<1>:q    r9.7<0;1,0>:q                   
(~f1.0) mov (32|M0)              r74.0<1>:f    r20.0<1;1,0>:f                   {I@5}
(~f0.0) mov (32|M0)              r74.0<1>:f    r22.0<1;1,0>:f                   {I@3}
(W)     mov (1|M0)               f1.0<1>:ud    0xFFFFFFF3:ud                              {F@2}
(~f3.0) mov (32|M0)              r74.0<1>:f    r24.0<1;1,0>:f                   {I@2}
(W)     mov (1|M0)               f0.0<1>:ud    0xFFFFF3FF:ud                              {F@2}
        mov (16|M0)              r76.0<1>:q    r10.0<0;1,0>:q                   {$3.dst}
        mov (16|M0)              r26.0<1>:q    r10.1<0;1,0>:q                  
(W)     mov (1|M0)               f3.0<1>:ud    0xFFFFCFFF:ud                              {F@1}
(f2.0)  mov (32|M0)              r76.0<1>:d    0:w                              
        mov (16|M0)              r28.0<1>:q    r10.5<0;1,0>:q                  
(W)     mov (1|M0)               f2.0<1>:ud    0xFFFF3FFF:ud                             
        mov (16|M0)              r30.0<1>:q    r10.6<0;1,0>:q                  
(~f1.0) mov (32|M0)              r76.0<1>:f    r26.0<1;1,0>:f                   {I@4}
        mov (16|M0)              r32.0<1>:q    r10.7<0;1,0>:q                  
(~f0.0) mov (32|M0)              r76.0<1>:f    r28.0<1;1,0>:f                   {I@4}
(W)     mov (1|M0)               f1.0<1>:ud    0xFFFCFFFF:ud                              {F@2}
(~f3.0) mov (32|M0)              r76.0<1>:d    r30.0<1;1,0>:d                   {A@1}
(W)     mov (1|M0)               f0.0<1>:ud    0xFCFFFFFF:ud                             
        mov (16|M0)              r34.0<1>:q    r11.0<0;1,0>:q                  
(~f2.0) mov (32|M0)              r76.0<1>:d    r32.0<1;1,0>:d                   {I@5}
(W)     mov (1|M0)               f3.0<1>:ud    0xF3FFFFFF:ud                             
        mov (16|M0)              r36.0<1>:q    r11.4<0;1,0>:q                  
(W)     mov (1|M0)               f2.0<1>:ud    0xCFFFFFFF:ud                             
        mov (16|M0)              r38.0<1>:q    r11.5<0;1,0>:q                  
(~f1.0) mov (32|M0)              r76.0<1>:d    r34.0<1;1,0>:d                   {I@6}
        mov (16|M0)              r40.0<1>:q    r11.6<0;1,0>:q                  
(~f0.0) mov (32|M0)              r76.0<1>:d    r36.0<1;1,0>:d                   {I@5}
(W)     mov (1|M0)               f1.0<1>:ud    0x3FFFFFFF:ud                             
(~f3.0) mov (32|M0)              r76.0<1>:d    r38.0<1;1,0>:d                   {I@5}
(W)     mov (1|M0)               f0.0<1>:ud    0xFFFFFF3F:ud                             
        mov (16|M0)              r42.0<1>:q    r11.7<0;1,0>:q                  
(~f2.0) mov (32|M0)              r76.0<1>:d    r40.0<1;1,0>:d                   {I@6}
(W)     mov (1|M0)               f3.0<1>:ud    0xFFFFFCFF:ud                             
(W)     mov (1|M0)               f2.0<1>:ud    0xFFFFF3FF:ud                             
        mov (16|M0)              r44.0<1>:q    r12.4<0;1,0>:q                  
(~f1.0) mov (32|M0)              r76.0<1>:d    r42.0<1;1,0>:d                   {I@5}
        mov (16|M0)              r78.0<1>:q    r12.3<0;1,0>:q                  
        mov (16|M0)              r46.0<1>:q    r12.5<0;1,0>:q                  
(W)     mov (1|M0)               f1.0<1>:ud    0xFFFFCFFF:ud                             
(f0.0)  mov (32|M0)              r78.0<1>:d    0:w                              
(~f3.0) mov (32|M0)              r78.0<1>:d    r44.0<1;1,0>:d                   {I@6}
(W)     mov (1|M0)               f0.0<1>:ud    0xFFCFFFFF:ud                             
        mov (16|M0)              r48.0<1>:q    r12.6<0;1,0>:q                  
(~f2.0) mov (32|M0)              r78.0<1>:d    r46.0<1;1,0>:d                   {I@6}
(W)     mov (1|M0)               f3.0<1>:ud    0xFF3FFFFF:ud                             
        mov (16|M0)              r50.0<1>:q    r13.2<0;1,0>:q                  
(W)     mov (1|M0)               f2.0<1>:ud    0xFCFFFFFF:ud                             
        mov (16|M0)              r52.0<1>:q    r13.3<0;1,0>:q                  
(~f1.0) mov (32|M0)              r78.0<1>:d    r48.0<1;1,0>:d                   {I@6}
        mov (16|M0)              r54.0<1>:q    r13.4<0;1,0>:q                  
(~f0.0) mov (32|M0)              r78.0<1>:d    r50.0<1;1,0>:d                   {I@5}
(~f3.0) mov (32|M0)              r78.0<1>:d    r52.0<1;1,0>:d                   {I@4}
(~f2.0) mov (32|M0)              r78.0<1>:d    r54.0<1;1,0>:d                   {I@3}
        cmp (1|M0)    (lt)f2.0   null<1>:d     r15.0<0;1,0>:d    2:w               {$5.dst}
(W)     mov (1|M0)               r62.0<1>:uw   0x1:uw                             
        mov (1|M0)               r73.4<1>:d    r0.1<0;1,0>:ud                  
(W)     mov (1|M0)               f1.0<1>:ud    0xF3FFFFFF:ud                             
(f2.0)  sel (1|M0)               r63.0<1>:uw   r62.0<0;1,0>:uw   0x0:uw              {I@3}
(W)     mov (1|M0)               f0.0<1>:uw    0xF3:uw                             
        xor (1|M0)    (ne)f2.1   null<1>:uw    r63.0<0;1,0>:uw   0x1:uw              {I@2}
(W)     mov (1|M0)               f3.1<1>:uw    0xCF:uw                             
(f2.0)  sel (1|M0)               r64.0<1>:uw   r62.0<0;1,0>:uw   0x0:uw             
        mov (16|M0)              r56.0<1>:q    r13.5<0;1,0>:q                  
(f2.1)  cmp (1|M0)    (gt)f2.1   null<1>:d     r9.11<0;1,0>:d    r73.4<0;1,0>:d  
        mov (4|M0)               r58.0<1>:q    r14.1<0;1,0>:q                   {$4.dst}
        mov (4|M0)               r60.0<1>:q    r14.2<0;1,0>:q                  
(W)     mov (1|M0)               f3.0<1>:uw    0x3F:uw                             
(f2.1)  sel (1|M0)               r65.0<1>:uw   r62.0<0;1,0>:uw   0x0:uw             
(~f1.0) mov (32|M0)              r78.0<1>:d    r56.0<1;1,0>:d                   {I@6}
        or (1|M0)     (ne)f2.1   null<1>:uw    r64.0<0;1,0>:uw   r65.0<0;1,0>:uw  {I@2}
        mov (4|M0)               r61.0<1>:q    r14.3<0;1,0>:q                  
(~f0.0) sel (8|M0)               r59.0<1>:d    r58.0<1;1,0>:d    0:w              
(~f3.1) mov (8|M0)               r59.0<1>:d    r60.0<1;1,0>:d                  
        and (1|M0)               r73.0<2>:b    r15.8<0;1,0>:b    1:w              
        mov (1|M0)               r81.0<1>:q    r74.0<0;1,0>:q                  
(W)     mov (4|M0)               r81.8<1>:ud   r74.2<1;1,0>:ud                 
        mov (1|M0)               r73.1<1>:q    r74.3<0;1,0>:q                  
(f3.0)  sel (8|M0)               r80.0<1>:d    r59.0<1;1,0>:d    r61.0<1;1,0>:d   {I@5}
(W&f2.1) jmpi                                L2016                                
L1936:
        mov (1|M0)               r81.0<1>:q    r74.7<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r75.0<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r75.1<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r75.2<0;1,0>:q                  
(W)     jmpi                                 L2112                                
L2016:
        mov (1|M0)               r9.6<1>:d     r8.8<0;1,0>:d                   
        mov (1|M0)               r9.7<1>:d     r8.9<0;1,0>:d                   
        mov (1|M0)               r9.8<1>:d     r8.10<0;1,0>:d                  
        mov (1|M0)               r9.9<1>:d     r8.11<0;1,0>:d                  
        mov (1|M0)               r9.10<1>:d    r8.12<0;1,0>:d                  
        mov (1|M0)               r9.11<1>:d    r8.13<0;1,0>:d                  
L2112:
        cmp (1|M0)    (lt)f1.1   null<1>:d     r15.0<0;1,0>:d    3:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                              {$0.dst}
(f1.1)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f1.1)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f2.0   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f2.0)  cmp (1|M0)    (gt)f2.0   null<1>:d     r10.9<0;1,0>:d    r73.4<0;1,0>:d  
(f2.0)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f2.0   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f2.0) jmpi                                L2336                                
L2256:
        mov (1|M0)               r81.0<1>:q    r75.6<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r75.7<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r76.0<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r76.1<0;1,0>:q                  
(W)     jmpi                                 L2432                                
L2336:
        mov (1|M0)               r10.4<1>:d    r9.6<0;1,0>:d                   
        mov (1|M0)               r10.5<1>:d    r9.7<0;1,0>:d                   
        mov (1|M0)               r10.6<1>:d    r9.8<0;1,0>:d                   
        mov (1|M0)               r10.7<1>:d    r9.9<0;1,0>:d                   
        mov (1|M0)               r10.8<1>:d    r9.10<0;1,0>:d                  
        mov (1|M0)               r10.9<1>:d    r9.11<0;1,0>:d                  
L2432:
        cmp (1|M0)    (lt)f1.0   null<1>:d     r15.0<0;1,0>:d    4:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f1.0)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f1.0)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f1.1   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f1.1)  cmp (1|M0)    (gt)f1.1   null<1>:d     r11.7<0;1,0>:d    r73.4<0;1,0>:d  
(f1.1)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f1.1   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f1.1) jmpi                                L2656                                
L2576:
        mov (1|M0)               r81.0<1>:q    r76.5<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r76.6<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r76.7<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r77.0<0;1,0>:q                  
(W)     jmpi                                 L2752                                
L2656:
        mov (1|M0)               r11.2<1>:d    r10.4<0;1,0>:d                  
        mov (1|M0)               r11.3<1>:d    r10.5<0;1,0>:d                  
        mov (1|M0)               r11.4<1>:d    r10.6<0;1,0>:d                  
        mov (1|M0)               r11.5<1>:d    r10.7<0;1,0>:d                  
        mov (1|M0)               r11.6<1>:d    r10.8<0;1,0>:d                  
        mov (1|M0)               r11.7<1>:d    r10.9<0;1,0>:d                  
L2752:
        cmp (1|M0)    (lt)f0.1   null<1>:d     r15.0<0;1,0>:d    5:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f0.1)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f0.1)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f1.0   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f1.0)  cmp (1|M0)    (gt)f1.0   null<1>:d     r12.5<0;1,0>:d    r73.4<0;1,0>:d  
(f1.0)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f1.0   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f1.0) jmpi                                L2976                                
L2896:
        mov (1|M0)               r81.0<1>:q    r77.4<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r77.5<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r77.6<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r77.7<0;1,0>:q                  
(W)     jmpi                                 L3072                                
L2976:
        mov (1|M0)               r12.0<1>:d    r11.2<0;1,0>:d                  
        mov (1|M0)               r12.1<1>:d    r11.3<0;1,0>:d                  
        mov (1|M0)               r12.2<1>:d    r11.4<0;1,0>:d                  
        mov (1|M0)               r12.3<1>:d    r11.5<0;1,0>:d                  
        mov (1|M0)               r12.4<1>:d    r11.6<0;1,0>:d                  
        mov (1|M0)               r12.5<1>:d    r11.7<0;1,0>:d                  
L3072:
        cmp (1|M0)    (lt)f0.0   null<1>:d     r15.0<0;1,0>:d    6:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f0.0)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f0.0)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f0.1   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f0.1)  cmp (1|M0)    (gt)f0.1   null<1>:d     r13.3<0;1,0>:d    r73.4<0;1,0>:d  
(f0.1)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f0.1   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f0.1) jmpi                                L3296                                
L3216:
        mov (1|M0)               r81.0<1>:q    r78.3<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r78.4<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r78.5<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r78.6<0;1,0>:q                  
(W)     jmpi                                 L3392                                
L3296:
        mov (1|M0)               r12.14<1>:d   r12.0<0;1,0>:d                  
        mov (1|M0)               r12.15<1>:d   r12.1<0;1,0>:d                  
        mov (1|M0)               r13.0<1>:d    r12.2<0;1,0>:d                  
        mov (1|M0)               r13.1<1>:d    r12.3<0;1,0>:d                  
        mov (1|M0)               r13.2<1>:d    r12.4<0;1,0>:d                  
        mov (1|M0)               r13.3<1>:d    r12.5<0;1,0>:d                  
L3392:
        cmp (1|M0)    (lt)f3.1   null<1>:d     r15.0<0;1,0>:d    7:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f3.1)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f3.1)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f0.0   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f0.0)  cmp (1|M0)    (gt)f0.0   null<1>:d     r14.1<0;1,0>:d    r73.4<0;1,0>:d  
(f0.0)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f0.0   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f0.0) jmpi                                L3616                                
L3536:
        mov (1|M0)               r81.0<1>:q    r79.2<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r79.3<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r79.4<0;1,0>:q                  
        mov (1|M0)               r73.1<1>:q    r79.5<0;1,0>:q                  
(W)     jmpi                                 L3712                                
L3616:
        mov (1|M0)               r13.12<1>:d   r12.14<0;1,0>:d                 
        mov (1|M0)               r13.13<1>:d   r12.15<0;1,0>:d                 
        mov (1|M0)               r13.14<1>:d   r13.0<0;1,0>:d                  
        mov (1|M0)               r13.15<1>:d   r13.1<0;1,0>:d                  
        mov (1|M0)               r14.0<1>:d    r13.2<0;1,0>:d                  
        mov (1|M0)               r14.1<1>:d    r13.3<0;1,0>:d                  
L3712:
        cmp (1|M0)    (lt)f3.0   null<1>:d     r15.0<0;1,0>:d    8:w              
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
(f3.0)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@1}
(f3.0)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        xor (1|M0)    (ne)f3.1   null<1>:uw    r2.0<0;1,0>:uw    0x1:uw              {I@2}
(f3.1)  cmp (1|M0)    (gt)f3.1   null<1>:d     r14.15<0;1,0>:d   r73.4<0;1,0>:d  
(f3.1)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        or (1|M0)     (ne)f3.1   null<1>:uw    r3.0<0;1,0>:uw    r4.0<0;1,0>:uw   {I@1}
(W&f3.1) jmpi                                L3920                                
L3856:
        mov (1|M0)               r81.0<1>:q    r80.1<0;1,0>:q                  
        mov (1|M0)               r81.4<1>:q    r80.2<0;1,0>:q                  
        mov (1|M0)               r81.5<1>:q    r80.3<0;1,0>:q                  
(W)     jmpi                                 L4032                                
L3920:
        mov (1|M0)               r14.4<1>:uq   r73.1<0;1,0>:uq                 
        mov (1|M0)               r14.10<1>:d   r13.12<0;1,0>:d                 
        mov (1|M0)               r14.11<1>:d   r13.13<0;1,0>:d                 
        mov (1|M0)               r14.12<1>:d   r13.14<0;1,0>:d                 
        mov (1|M0)               r14.13<1>:d   r13.15<0;1,0>:d                 
        mov (1|M0)               r14.14<1>:d   r14.0<0;1,0>:d                  
        mov (1|M0)               r14.15<1>:d   r14.1<0;1,0>:d                  
L4032:
        mov (1|M0)               r73.1<1>:d    r1.0<0;1,0>:uw                  
        add (1|M0)               r73.4<1>:d    r73.4<0;1,0>:d    -r14.15<0;1,0>:d {I@2}
        mov (1|M0)               r81.13<1>:d   768:w                              
        mov (1|M0)               r81.12<1>:d   r14.11<0;1,0>:d                 
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
(W)     call (32|M0)             r81.14        L10128                                 {A@1}
L4144:
        asr (1|M0)               r73.7<1>:d    r14.10<0;1,0>:d   31:w              
        cmp (1|M0)    (eq)f3.0   null<1>:w     r73.0<0;1,0>:b    0:w              
        shr (1|M0)               r73.7<1>:ud   r73.7<0;1,0>:ud   0x1C:uw              {I@2}
        mul (1|M0)               r73.6<1>:d    r73.5<0;1,0>:d    r1.0<0;1,0>:uw  
        add (1|M0)               r73.7<1>:d    r14.10<0;1,0>:d   r73.7<0;1,0>:d   {I@2}
        mov (1|M0)               r73.4<1>:q    r73.4<0;1,0>:d                  
        asr (1|M0)               r73.7<1>:d    r73.7<0;1,0>:d    4:w               {I@2}
        mov (1|M0)               r81.1<1>:q    r73.7<0;1,0>:d                   {I@1}
        shl (1|M0)               r73.7<1>:q    r81.1<0;1,0>:q    7:w               {I@1}
(f3.0)  mov (1|M0)               r73.14<1>:d   128:w                              
(f3.0)  mov (1|M0)               r73.15<1>:d   0:w                              
        shl (1|M0)               r81.1<1>:q    r81.1<0;1,0>:q    4:w              
(f3.0)  mov (1|M0)               r81.2<1>:d    16:w                              
(f3.0)  mov (1|M0)               r81.3<1>:d    0:w                              
(W&f3.0) jmpi                                L4512                                
L4384:
        mul (1|M0)               acc0.0<1>:d   r73.6<0;1,0>:d    r73.14<0;1,0>:uw
        mach (1|M0)              r3.0<1>:d     r73.6<0;1,0>:d    r73.7<0;1,0>:d  
        mov (1|M0)               r2.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r73.11<1>:d   r3.0<0;1,0>:d                    {I@2}
        mov (1|M0)               r73.10<1>:d   r2.0<0;1,0>:d                    {I@2}
        add (1|M0)               r73.5<1>:q    r73.5<0;1,0>:q    r73.4<0;1,0>:d   {I@1}
        shl (1|M0)               r4.0<1>:q     r73.5<0;1,0>:q    9:w               {Compacted,I@1}
        add (1|M0)               r81.0<1>:q    r81.0<0;1,0>:q    r4.0<0;1,0>:q    {Compacted,I@1}
(W)     jmpi                                 L4864                                
L4512:
        asr (1|M0)               r1.2<1>:d     r14.11<0;1,0>:d   31:w              
        shl (1|M0)               r3.0<1>:q     r73.6<0;1,0>:d    9:w              
        shr (1|M0)               r2.0<1>:ud    r1.2<0;1,0>:ud    0x1A:uw              {Compacted,I@2}
        shr (1|M0)               r1.2<1>:ud    r1.2<0;1,0>:ud    0x1B:uw             
        add (1|M0)               r2.0<1>:d     r14.11<0;1,0>:d   r2.0<0;1,0>:d    {Compacted,I@2}
        add (1|M0)               r1.2<1>:d     r14.11<0;1,0>:d   r1.2<0;1,0>:d    {I@2}
        asr (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     6:w               {I@2}
        asr (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     5:w               {I@2}
        add (1|M0)               r81.0<1>:q    r81.0<0;1,0>:q    r3.0<0;1,0>:q    {Compacted}
        shl (1|M0)               r4.0<1>:q     r1.2<0;1,0>:d     8:w               {I@2}
        mul (1|M0)               acc0.0<1>:ud  r4.0<0;1,0>:ud    r73.16<0;1,0>:uw {I@1}
        mach (1|M0)              r7.0<1>:ud    r4.0<0;1,0>:ud    r73.8<0;1,0>:ud  {Compacted}
        mov (1|M0)               r6.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r4.0<0;1,0>:d     r73.18<0;1,0>:uw
        macl (1|M0)              r16.0<1>:d    r4.0<0;1,0>:d     r73.9<0;1,0>:d   {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r4.1<0;1,0>:d     r73.16<0;1,0>:uw
        macl (1|M0)              r17.0<1>:d    r4.1<0;1,0>:d     r73.8<0;1,0>:d  
        mul (1|M0)               acc0.0<1>:d   r73.4<0;1,0>:d    r2.0<0;1,0>:uw  
        mach (1|M0)              r20.0<1>:d    r73.4<0;1,0>:d    r2.0<0;1,0>:d    {Compacted}
        mov (1|M0)               r18.0<1>:f    r6.0<0;1,0>:f                    {Compacted,I@7}
        mov (1|M0)               r19.0<1>:d    acc0.0<0;1,0>:d                 
        add3 (1|M0)              r18.1<1>:d    r17.0<0;0>:d      r7.0<0;0>:d       r16.0<0>:d       {I@4}
        mov (1|M0)               r73.11<1>:d   r20.0<0;1,0>:d                   {I@3}
        mov (1|M0)               r73.10<1>:d   r19.0<0;1,0>:d                   {I@3}
        add (1|M0)               r81.0<1>:q    r81.0<0;1,0>:q    r18.0<0;1,0>:q   {A@1}
        add (1|M0)               r73.5<1>:q    r73.5<0;1,0>:q    r73.6<0;1,0>:d   {I@2}
L4864:
        shl (1|M0)               r73.5<1>:q    r73.5<0;1,0>:q    6:w               {I@1}
        send.ugm (1|M0)          r83      r81  null:0  0x0            0x0240F580           {$6} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        add (1|M0)               r82.0<1>:q    r81.4<0;1,0>:q    r73.5<0;1,0>:q   {I@1}
        send.ugm (1|M0)          r87      r81  null:0  0x100000            0x0240F580           {$7} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r91      r82  null:0  0x0            0x0210D580           {I@1,$8} // wr:1+0, rd:1; load.ugm.d32x16t.a64
        mul (1|M0)               acc0.0<1>:d   r14.12<0;1,0>:d   r15.6<0;1,0>:uw 
        mach (1|M0)              r3.0<1>:d     r14.12<0;1,0>:d   r15.3<0;1,0>:d  
        cmp (1|M0)    (gt)f3.0   null<1>:d     r14.11<0;1,0>:d   767:w              
        mov (1|M0)               r2.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r4.1<1>:d     r3.0<0;1,0>:d                    {Compacted,I@3}
        mov (1|M0)               r4.0<1>:f     r2.0<0;1,0>:f                    {Compacted,I@2}
        mov (16|M0)              r101.0<1>:f   0.0:f                               {Compacted}
        shl (1|M0)               r4.0<1>:q     r4.0<0;1,0>:q     2:w               {Compacted,A@1}
        add (1|M0)               r81.5<1>:q    r81.5<0;1,0>:q    r4.0<0;1,0>:q    {@1,$7.src}
(W&~f3.0) jmpi                               L7632                                
L5072:
        mov (1|M0)               r73.6<1>:q    r73.5<0;1,0>:ud                 
        mov (1|M0)               r81.2<1>:q    0:w                              
L5104:
        add (1|M0)               r81.3<1>:q    r81.2<0;1,0>:q    1:w               {I@1}
(W)     mov (1|M0)               r1.3<1>:hf    0x1:hf                             
        cmp (1|M0)    (eq)f0.0   null<1>:d     r81.7<0;1,0>:d    r73.13<0;1,0>:d  {I@1}
        cmp (1|M0)    (lt)f0.1   null<1>:ud    r81.6<0;1,0>:ud   r73.12<0;1,0>:ud
        cmp (1|M0)    (lt)f1.0   null<1>:ud    r81.7<0;1,0>:ud   r73.13<0;1,0>:ud
        sync.nop                             null                             {Compacted,$9.dst}
        mov (16|M0)              r93.0<1>:f    r83.0<1;1,0>:f                   {Compacted,$6.dst}
(f0.0)  sel (1|M0)               r2.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw              {F@2}
(f0.1)  sel (1|M0)               r3.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
(f1.0)  sel (1|M0)               r5.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        and (1|M0)    (ne)f2.1   null<1>:uw    r2.0<0;1,0>:uw    r3.0<0;1,0>:uw   {I@2}
        mov (16|M0)              r94.0<1>:f    r84.0<1;1,0>:f                   {Compacted}
        mov (16|M0)              r95.0<1>:f    r85.0<1;1,0>:f                   {Compacted}
(f2.1)  sel (1|M0)               r4.0<1>:uw    r1.3<0;1,0>:uw    0x0:uw             
        mov (16|M0)              r96.0<1>:f    r86.0<1;1,0>:f                  
        or (1|M0)     (ne)f3.1   null<1>:uw    r4.0<0;1,0>:uw    r5.0<0;1,0>:uw   {I@1}
        sync.nop                             null                             {Compacted,$10.dst}
        mov (16|M0)              r97.0<1>:f    r87.0<1;1,0>:f                   {Compacted,$7.dst}
        mov (16|M0)              r98.0<1>:f    r88.0<1;1,0>:f                   {Compacted}
        mov (16|M0)              r99.0<1>:f    r89.0<1;1,0>:f                   {Compacted}
        mov (16|M0)              r100.0<1>:d   r90.0<1;1,0>:d                  
(W&f3.1) jmpi                                L5416                                
L5392:
        mov (16|M0)              r92.0<1>:d    r91.0<1;1,0>:d                   {Compacted,$8.dst}
(W)     jmpi                                 L5728                                
L5416:
        mul (1|M0)               acc0.0<1>:ud  r81.6<0;1,0>:ud   r73.28<0;1,0>:uw
        mach (1|M0)              r3.0<1>:ud    r81.6<0;1,0>:ud   r73.14<0;1,0>:ud {Compacted}
        mov (1|M0)               r2.0<1>:ud    acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r81.6<0;1,0>:d    r73.30<0;1,0>:uw
        macl (1|M0)              r4.0<1>:d     r81.6<0;1,0>:d    r73.15<0;1,0>:d  {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r81.7<0;1,0>:d    r73.28<0;1,0>:uw
        macl (1|M0)              r5.0<1>:d     r81.7<0;1,0>:d    r73.14<0;1,0>:d 
        mul (1|M0)               acc0.0<1>:ud  r81.6<0;1,0>:ud   r81.4<0;1,0>:uw 
        mach (1|M0)              r17.0<1>:ud   r81.6<0;1,0>:ud   r81.2<0;1,0>:ud  {Compacted}
        mov (1|M0)               r6.0<1>:f     r2.0<0;1,0>:f                    {Compacted,I@7}
        mov (1|M0)               r16.0<1>:ud   acc0.0<0;1,0>:ud                 {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r81.6<0;1,0>:d    r81.6<0;1,0>:uw 
        macl (1|M0)              r18.0<1>:d    r81.6<0;1,0>:d    r81.3<0;1,0>:d   {Compacted}
(W)     mul (1|M0)               acc0.0<1>:d   r81.7<0;1,0>:d    r81.4<0;1,0>:uw 
        macl (1|M0)              r19.0<1>:d    r81.7<0;1,0>:d    r81.2<0;1,0>:d  
        add3 (1|M0)              r6.1<1>:d     r5.0<0;0>:d       r3.0<0;0>:d       r4.0<0>:d        {I@7}
        mov (1|M0)               r20.0<1>:f    r16.0<0;1,0>:f                   {I@6}
        add3 (1|M0)              r20.1<1>:d    r19.0<0;0>:d      r17.0<0;0>:d      r18.0<0>:d       {I@2}
        shl (1|M0)               r6.0<1>:q     r6.0<0;1,0>:q     2:w               {Compacted,A@2}
        shl (1|M0)               r20.0<1>:q    r20.0<0;1,0>:q    2:w               {Compacted,A@1}
        add (1|M0)               r7.0<1>:q     r81.0<0;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@2}
        add (1|M0)               r21.0<1>:q    r82.0<0;1,0>:q    r20.0<0;1,0>:q   {Compacted,I@2}
        send.ugm (1|M0)          r83      r7  null:0  0x0            0x0240F580           {I@2,$9} // wr:1+0, rd:4; load.ugm.d32x64t.a64
        send.ugm (1|M0)          r87      r7  null:0  0x100000            0x0240F580           {$10} // wr:1+0, rd:4; load.ugm.d32x64t.a64.flat[A+0x100]
        send.ugm (1|M0)          r92      r21  null:0  0x0            0x0210D580           {I@1,$11} // wr:1+0, rd:1; load.ugm.d32x16t.a64
L5728:
        add (1|M0)               r81.2<1>:q    r81.2<0;1,0>:q    r73.6<0;1,0>:ud 
        shr (16|M0)              r2.0<1>:ud    r91.0<1;1,0>:ud   0x10:uw              {$8.dst}
        shl (1|M0)               r81.2<1>:q    r81.2<0;1,0>:q    8:w               {I@2}
(W)     mov (1|M0)               r5.0<1>:f     9.473556e+21:f                              
        add (1|M0)               r3.0<1>:q     r81.5<0;1,0>:q    r81.2<0;1,0>:q   {I@1}
(W)     mov (1|M0)               r6.0<1>:f     1.377553e-39:f                              
        send.ugm (1|M0)          r29      r3  null:0  0x0            0x0210D580           {I@1,$12} // wr:1+0, rd:1; load.ugm.d32x16t.a64
(W)     mul (16|M0)              acc0.0<1>:ud  r2.0<1;1,0>:ud    0x1:uw             
        send.ugm (1|M0)          r47      r3  null:0  0x40000            0x0210D580           {$13} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x40]
        macl (16|M0)             r2.0<1>:ud    r2.0<1;1,0>:ud    0x10001:ud             
        shr (16|M0)              acc0.0<1>:ud  r93.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r16.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       {F@1} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r93.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r17.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r94.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r7.0<1>:ud    r5.0<0;0>:ud      r93.0<1;0>:ud     r6.0<0>:ud       {$10.src} // s0|s1&s2
        bfn.0xEA (16|M0)         r18.0<1>:ud   r5.0<0;0>:ud      r94.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r19.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              r93.0<1>:ud   r93.0<1;1,0>:ud   0xC:uw              {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r94.0<1;1,0>:ud   0x8:uw             
        shr (16|M0)              r94.0<1>:ud   r94.0<1;1,0>:ud   0xC:uw              {Compacted}
        send.ugm (1|M0)          r64      r3  null:0  0x80000            0x0210D580           {$14} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0x80]
        send.ugm (1|M0)          r110      r3  null:0  0xC0000            0x0210D580           {$0} // wr:1+0, rd:1; load.ugm.d32x16t.a64.flat[A+0xC0]
        bfn.0xEA (16|M0)         r93.0<1>:ud   r5.0<0;0>:ud      r93.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r20.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r94.0<1>:ud   r5.0<0;0>:ud      r94.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        add (32|M0)              r22.0<1>:hf   r16.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r23.0<1>:hf   r17.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r21.0<1>:hf   r7.0<1;1,0>:hf    -r2.0<1;1,0>:hf  {$11.src}
        add (32|M0)              r25.0<1>:hf   r18.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r26.0<1>:hf   r19.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r24.0<1>:hf   r93.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@3}
        add (32|M0)              r27.0<1>:hf   r20.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@2}
        add (32|M0)              r28.0<1>:hf   r94.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@1}
        mov (16|M0)              r30.0<1>:hf   r29.0<1;1,0>:f                   {$12.dst}
        sync.nop                             null                             {F@1}
        dpas.8x1 (16|M0)         r32:f         null:f            r21:hf            r30.0:hf         {$15}
        sync.nop                             null                             {$15.src}
        shr (16|M0)              acc0.0<1>:ud  r95.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r34.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r95.0<1;1,0>:ud   0x8:uw             
        bfn.0xEA (16|M0)         r35.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r96.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r33.0<1>:ud   r5.0<0;0>:ud      r95.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r36.0<1>:ud   r5.0<0;0>:ud      r96.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r37.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              r95.0<1>:ud   r95.0<1;1,0>:ud   0xC:uw             
        shr (16|M0)              acc0.0<1>:ud  r96.0<1;1,0>:ud   0x8:uw             
        shr (16|M0)              r96.0<1>:ud   r96.0<1;1,0>:ud   0xC:uw             
        bfn.0xEA (16|M0)         r95.0<1>:ud   r5.0<0;0>:ud      r95.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r38.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r96.0<1>:ud   r5.0<0;0>:ud      r96.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r51.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r97.0<1;1,0>:ud   0x8:uw             
        add (32|M0)              r40.0<1>:hf   r34.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r41.0<1>:hf   r35.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r39.0<1>:hf   r33.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r43.0<1>:hf   r36.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r44.0<1>:hf   r37.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r42.0<1>:hf   r95.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@6}
        add (32|M0)              r45.0<1>:hf   r38.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@5}
        add (32|M0)              r46.0<1>:hf   r96.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@4}
        bfn.0xEA (16|M0)         r52.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r98.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r50.0<1>:ud   r5.0<0;0>:ud      r97.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r53.0<1>:ud   r5.0<0;0>:ud      r98.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        mov (16|M0)              r49.0<1>:hf   r47.0<1;1,0>:f                   {$13.dst}
        bfn.0xEA (16|M0)         r54.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              r97.0<1>:ud   r97.0<1;1,0>:ud   0xC:uw              {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r98.0<1;1,0>:ud   0x8:uw             
        shr (16|M0)              r98.0<1>:ud   r98.0<1;1,0>:ud   0xC:uw              {Compacted}
        sync.nop                             null                             {Compacted,F@1}
        dpas.8x1 (16|M0)         r32:f         r32:f             r39:hf            r49.0:hf         {Compacted,$15}
        bfn.0xEA (16|M0)         r97.0<1>:ud   r5.0<0;0>:ud      r97.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r55.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r98.0<1>:ud   r5.0<0;0>:ud      r98.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r99.0<1;1,0>:ud   0x4:uw             
        bfn.0xEA (16|M0)         r67.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r99.0<1;1,0>:ud   0x8:uw             
        add (32|M0)              r57.0<1>:hf   r51.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r58.0<1>:hf   r52.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r56.0<1>:hf   r50.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r60.0<1>:hf   r53.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r61.0<1>:hf   r54.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r59.0<1>:hf   r97.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@6}
        add (32|M0)              r62.0<1>:hf   r55.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@5}
        add (32|M0)              r63.0<1>:hf   r98.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@4}
        bfn.0xEA (16|M0)         r68.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x4:uw             
        bfn.0xEA (16|M0)         r66.0<1>:ud   r5.0<0;0>:ud      r99.0<1;0>:ud     r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r69.0<1>:ud   r5.0<0;0>:ud      r100.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        mov (16|M0)              r65.0<1>:hf   r64.0<1;1,0>:f                   {$14.dst}
        bfn.0xEA (16|M0)         r70.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        shr (16|M0)              r99.0<1>:ud   r99.0<1;1,0>:ud   0xC:uw              {Compacted}
        shr (16|M0)              acc0.0<1>:ud  r100.0<1;1,0>:ud  0x8:uw             
        shr (16|M0)              r100.0<1>:ud  r100.0<1;1,0>:ud  0xC:uw              {Compacted}
        sync.nop                             null                             {Compacted,F@1}
        dpas.8x1 (16|M0)         r32:f         r32:f             r56:hf            r65.0:hf         {Compacted,$15}
        bfn.0xEA (16|M0)         r99.0<1>:ud   r5.0<0;0>:ud      r99.0<1;0>:ud     r6.0<0>:ud       {I@3} // s0|s1&s2
        bfn.0xEA (16|M0)         r71.0<1>:ud   r5.0<0;0>:ud      acc0.0<1;0>:ud    r6.0<0>:ud       // s0|s1&s2
        bfn.0xEA (16|M0)         r100.0<1>:ud  r5.0<0;0>:ud      r100.0<1;0>:ud    r6.0<0>:ud       {I@3} // s0|s1&s2
        add (32|M0)              r19.0<1>:hf   r67.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r20.0<1>:hf   r68.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r18.0<1>:hf   r66.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r22.0<1>:hf   r69.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r23.0<1>:hf   r70.0<1;1,0>:hf   -r2.0<1;1,0>:hf 
        add (32|M0)              r21.0<1>:hf   r99.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@3}
        add (32|M0)              r24.0<1>:hf   r71.0<1;1,0>:hf   -r2.0<1;1,0>:hf  {I@2}
        add (32|M0)              r25.0<1>:hf   r100.0<1;1,0>:hf  -r2.0<1;1,0>:hf  {I@1}
        mov (16|M0)              r27.0<1>:hf   r110.0<1;1,0>:f                   {$0.dst}
        sync.nop                             null                             {Compacted,F@1}
        dpas.8x1 (16|M0)         r32:f         r32:f             r18:hf            r27.0:hf         {Compacted,$15}
        cmp (1|M0)    (eq)f3.0   null<1>:d     r81.6<0;1,0>:d    r73.12<0;1,0>:d 
        mov (16|M0)              r28.0<1>:uw   r91.0<2;1,0>:uw                 
(W)     mov (1|M0)               r30.0<1>:hf   0x1:hf                             
        mov (16|M0)              r29.0<1>:f    r28.0<1;1,0>:hf                  {I@1}
(f3.0)  sel (1|M0)               r31.0<1>:uw   r30.0<0;1,0>:uw   0x0:uw              {F@2}
        mad (16|M0)              r101.0<1>:f   r101.0<1;0>:f     r29.0<1;0>:f      r32.0<1>:f       {@1,$15.dst}
(f0.0)  sel (1|M0)               r32.0<1>:uw   r30.0<0;1,0>:uw   0x0:uw              {F@1}
        and (1|M0)    (ne)f2.0   null<1>:uw    r31.0<0;1,0>:uw   r32.0<0;1,0>:uw  {I@1}
(W&f2.0) jmpi                                L7632                                
L7584:
        mov (16|M0)              r91.0<1>:d    r92.0<1;1,0>:d                   {$11.dst}
        mov (1|M0)               r81.2<1>:q    r81.3<0;1,0>:q                  
(W)     jmpi                                 L5104                                
L7632:
        shl (1|M0)               r2.0<1>:d     r73.1<0;1,0>:d    6:w               {Compacted}
        send.slm (1|M0)          null     r2  r101:1  0x0            0x0200C704           {I@1,$1} // wr:1+1, rd:0; store.slm.d64x8t.a32
(W)     send.slm (1|M0)          r3       r72  null:0  0x0            0x0210001F           {$2} // wr:1+0, rd:1; fence.slm.none.group
(W)     mov (1|M0)               r4.2<1>:f     0.0:f                               {Compacted}
(W)     mov (2|M0)               r4.10<1>:ub   r72.11<0;1,0>:ub                 {F@1}
(W)     mov (8|M0)               null<1>:ud    r3.0<1;1,0>:ud                   {$2.dst}
(W)     send.gtwy (1|M0)         null     r4  null:0  0x0            0x02000004           {I@2,$3} // wr:1+0, rd:0; signal barrier
(W)     sync.bar                             0x0                                
        cmp (1|M0)    (eq)f1.1   null<1>:w     r1.0<0;1,0>:w     0:w              
(W&~f1.1) jmpi                               L10096                                
L7776:
        mov (1|M0)               r2.0<1>:d     0:w                               {Compacted,$1.src}
        mov (1|M0)               r3.0<1>:d     64:w                               {Compacted}
        send.slm (1|M0)          r102     r2  null:0  0x0            0x0210C700           {I@2,$4} // wr:1+0, rd:1; load.slm.d64x8t.a32
        sync.nop                             null                             {Compacted,$3.src}
        send.slm (1|M0)          r4       r3  null:0  0x0            0x0210C700           {I@1,$5} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r5.0<1>:d     128:w                               {Compacted}
        mov (1|M0)               r7.0<1>:d     192:w                              
        send.slm (1|M0)          r6       r5  null:0  0x0            0x0210C700           {I@2,$12} // wr:1+0, rd:1; load.slm.d64x8t.a32
        send.slm (1|M0)          r16      r7  null:0  0x0            0x0210C700           {I@1,$13} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r17.0<1>:d    256:w                               {Compacted}
        mov (1|M0)               r19.0<1>:d    320:w                               {Compacted}
        send.slm (1|M0)          r18      r17  null:0  0x0            0x0210C700           {I@2,$14} // wr:1+0, rd:1; load.slm.d64x8t.a32
        sync.nop                             null                             {Compacted,$5.dst}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r4.0<1;1,0>:f    {Compacted,$4.dst}
        send.slm (1|M0)          r20      r19  null:0  0x0            0x0210C700           {I@1,$15} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r21.0<1>:d    384:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r6.0<1;1,0>:f    {Compacted,@1,$12.dst}
        send.slm (1|M0)          r22      r21  null:0  0x0            0x0210C700           {I@1,$0} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r23.0<1>:d    448:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r16.0<1;1,0>:f   {Compacted,@1,$13.dst}
        send.slm (1|M0)          r24      r23  null:0  0x0            0x0210C700           {I@1,$2} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r25.0<1>:d    512:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r18.0<1;1,0>:f   {Compacted,@1,$14.dst}
        send.slm (1|M0)          r26      r25  null:0  0x0            0x0210C700           {I@1,$1} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r27.0<1>:d    576:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r20.0<1;1,0>:f   {Compacted,@1,$15.dst}
        send.slm (1|M0)          r28      r27  null:0  0x0            0x0210C700           {I@1,$6} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r29.0<1>:d    640:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r22.0<1;1,0>:f   {Compacted,@1,$0.dst}
        send.slm (1|M0)          r30      r29  null:0  0x0            0x0210C700           {I@1,$7} // wr:1+0, rd:1; load.slm.d64x8t.a32
        mov (1|M0)               r31.0<1>:d    704:w                               {Compacted}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r24.0<1;1,0>:f   {Compacted,@1,$2.dst}
        send.slm (1|M0)          r32      r31  null:0  0x0            0x0210C700           {I@1,$8} // wr:1+0, rd:1; load.slm.d64x8t.a32
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r26.0<1;1,0>:f   {Compacted,@1,$1.dst}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r28.0<1;1,0>:f   {Compacted,@1,$6.dst}
        cmp (1|M0)    (eq)f1.0   null<1>:d     r14.14<0;1,0>:d   0:w              
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r30.0<1;1,0>:f   {Compacted,@1,$7.dst}
        add (16|M0)              r102.0<1>:f   r102.0<1;1,0>:f   r32.0<1;1,0>:f   {Compacted,@1,$8.dst}
(W&f1.0) jmpi                                L8304                                
L8208:
        shr (16|M0)              r2.0<1>:ud    r102.0<1;1,0>:ud  0x10:uw              {F@1}
        and (16|M0)              r3.0<2>:w     r2.0<2;1,0>:w     1:w               {I@1}
        mov (16|M0)              r4.0<1>:w     r3.0<2;1,0>:w                    {I@1}
        mov (16|M0)              r6.0<1>:hf    r4.0<1;1,0>:hf                   {I@1}
        add3 (16|M0)             r102.0<1>:ud  r102.0<1;0>:ud    r6.0<1;0>:uw      32767:w               {F@1}
        and (16|M0)              r102.0<1>:ud  r102.0<1;1,0>:ud  0xFFFF0000:ud              {I@1}
L8304:
        cmp (1|M0)    (gt)f0.1   null<1>:d     r15.4<0;1,0>:d    0:w              
(W&~f0.1) jmpi                               L10096                                
L8336:
        shl (1|M0)               r73.4<1>:d    r73.4<0;1,0>:d    4:w              
        add (1|M0)               r1.2<1>:d     r73.4<0;1,0>:d    16:w               {I@1}
        cmp (1|M0)    (gt)f0.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&f0.0) jmpi                                L8544                                
L8400:
        mul (1|M0)               acc0.0<1>:d   r14.13<0;1,0>:d   r15.6<0;1,0>:uw 
        mach (1|M0)              r3.0<1>:d     r14.13<0;1,0>:d   r15.3<0;1,0>:d  
        shl (1|M0)               r5.0<1>:q     r73.4<0;1,0>:d    2:w              
        mov (1|M0)               r2.0<1>:d     acc0.0<0;1,0>:d                 
        mov (1|M0)               r4.1<1>:d     r3.0<0;1,0>:d                    {Compacted,I@3}
        mov (1|M0)               r4.0<1>:f     r2.0<0;1,0>:f                    {Compacted,I@2}
        shl (1|M0)               r4.0<1>:q     r4.0<0;1,0>:q     2:w               {Compacted,A@1}
        add (1|M0)               r4.0<1>:q     r14.4<0;1,0>:q    r4.0<0;1,0>:q    {Compacted,I@1}
        add (1|M0)               r6.0<1>:q     r4.0<0;1,0>:q     r5.0<0;1,0>:q    {I@1}
        send.ugm (1|M0)          null     r6  r102:1  0x0            0x0200D584           {I@1,$3} // wr:1+1, rd:0; store.ugm.d32x16t.a64
(W)     jmpi                                 L10096                                
L8544:
        mul (1|M0)               acc0.0<1>:d   r14.13<0;1,0>:d   r15.6<0;1,0>:uw 
        mach (1|M0)              r3.0<1>:d     r14.13<0;1,0>:d   r15.3<0;1,0>:d  
        shl (1|M0)               r1.1<1>:q     r73.4<0;1,0>:d    2:w              
        mov (1|M0)               r2.0<1>:d     acc0.0<0;1,0>:d                 
        cmp (1|M0)    (lt)f3.1   null<1>:d     r73.4<0;1,0>:d    r14.10<0;1,0>:d 
        mov (1|M0)               r4.1<1>:d     r3.0<0;1,0>:d                    {Compacted,I@4}
        mov (1|M0)               r4.0<1>:f     r2.0<0;1,0>:f                    {Compacted,I@3}
        add (1|M0)               r1.1<1>:q     r14.4<0;1,0>:q    r1.1<0;1,0>:q   
        shl (1|M0)               r4.0<1>:q     r4.0<0;1,0>:q     2:w               {Compacted,A@1}
        add (1|M0)               r104.0<1>:q   r1.1<0;1,0>:q     r4.0<0;1,0>:q    {Compacted,I@1}
(W&~f3.1) jmpi                               L8704                                
L8688:
        send.ugm (1|M0)          null     r104  r102:1  0x0            0x04000584           {I@2,$4} // wr:2+1, rd:0; store.ugm.d32.a64
L8704:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    1:w              
        cmp (1|M0)    (lt)f3.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f3.0) jmpi                               L8784                                
L8752:
        mov (1|M0)               r2.0<1>:f     r102.1<0;1,0>:f                 
        send.ugm (1|M0)          null     r104  r2:1  0x4000            0x04000584           {F@1,$5} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x4]
L8784:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    2:w              
        cmp (1|M0)    (lt)f2.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f2.1) jmpi                               L8864                                
L8832:
        mov (1|M0)               r2.0<1>:f     r102.2<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x8000            0x04000584           {F@1,$12} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x8]
L8864:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    3:w              
        cmp (1|M0)    (lt)f2.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f2.0) jmpi                               L8944                                
L8912:
        sync.nop                             null                             {Compacted,$12.src}
        mov (1|M0)               r2.0<1>:f     r102.3<0;1,0>:f                  {Compacted,$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0xC000            0x04000584           {F@1,$13} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0xC]
L8944:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    4:w              
        cmp (1|M0)    (lt)f1.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f1.1) jmpi                               L9040                                
L8992:
        sync.allrd                           ($12,$13)                
        mov (1|M0)               r2.0<1>:f     r102.4<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x10000            0x04000584           {F@1,$14} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x10]
L9040:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    5:w              
        cmp (1|M0)    (lt)f1.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f1.0) jmpi                               L9136                                
L9088:
        sync.allrd                           ($12,$13,$14)                
        mov (1|M0)               r2.0<1>:f     r102.5<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x14000            0x04000584           {F@1,$15} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x14]
L9136:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    6:w              
        cmp (1|M0)    (lt)f0.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f0.1) jmpi                               L9232                                
L9184:
        sync.allrd                           ($12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.6<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x18000            0x04000584           {F@1,$0} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x18]
L9232:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    7:w              
        cmp (1|M0)    (lt)f0.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f0.0) jmpi                               L9328                                
L9280:
        sync.allrd                           ($0,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.7<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x1C000            0x04000584           {F@1,$1} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x1C]
L9328:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    8:w              
        cmp (1|M0)    (lt)f3.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f3.1) jmpi                               L9424                                
L9376:
        sync.allrd                           ($0,$1,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.8<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x20000            0x04000584           {F@1,$2} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x20]
L9424:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    9:w              
        cmp (1|M0)    (lt)f3.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f3.0) jmpi                               L9520                                
L9472:
        sync.allrd                           ($0,$1,$2,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.9<0;1,0>:f                  {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x24000            0x04000584           {F@1,$3} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x24]
L9520:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    10:w              
        cmp (1|M0)    (lt)f2.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f2.1) jmpi                               L9616                                
L9568:
        sync.allrd                           ($0,$1,$2,$3,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.10<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x28000            0x04000584           {F@1,$9} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x28]
L9616:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    11:w              
        cmp (1|M0)    (lt)f2.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f2.0) jmpi                               L9712                                
L9664:
        sync.allrd                           ($0,$1,$2,$3,$9,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.11<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x2C000            0x04000584           {F@1,$10} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x2C]
L9712:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    12:w              
        cmp (1|M0)    (lt)f1.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f1.1) jmpi                               L9808                                
L9760:
        sync.allrd                           ($0,$1,$2,$3,$9,$10,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.12<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x30000            0x04000584           {F@1,$11} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x30]
L9808:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    13:w              
        cmp (1|M0)    (lt)f1.0   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f1.0) jmpi                               L9904                                
L9856:
        sync.allrd                           ($0,$1,$2,$3,$9,$10,$11,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.13<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x34000            0x04000584           {F@1,$6} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x34]
L9904:
        or (1|M0)                r1.2<1>:d     r73.4<0;1,0>:d    14:w              
        cmp (1|M0)    (lt)f0.1   null<1>:d     r1.2<0;1,0>:d     r14.10<0;1,0>:d  {I@1}
(W&~f0.1) jmpi                               L10000                                
L9952:
        sync.allrd                           ($0,$1,$2,$3,$6,$9,$10,$11,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.14<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x38000            0x04000584           {F@1,$7} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x38]
L10000:
        or (1|M0)                r73.4<1>:d    r73.4<0;1,0>:d    15:w              
        cmp (1|M0)    (lt)f0.0   null<1>:d     r73.4<0;1,0>:d    r14.10<0;1,0>:d  {I@1}
(W&~f0.0) jmpi                               L10096                                
L10048:
        sync.allrd                           ($0,$1,$2,$3,$6,$7,$9,$10,$11,$12,$13,$14,$15)                
        mov (1|M0)               r2.0<1>:f     r102.15<0;1,0>:f                 {$5.src}
        send.ugm (1|M0)          null     r104  r2:1  0x3C000            0x04000584           {F@1,$5} // wr:2+1, rd:0; store.ugm.d32.a64.flat[A+0x3C]
L10096:
(W)     mov (16|M0)              r127.0<1>:f   r72.0<1;1,0>:f                  
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,F@1,$12} // wr:1+0, rd:0; end of thread
L10128:
        mov (1|M0)               r1.2<1>:d     cr0.0<0;1,0>:ud                  {A@1}
        and (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   -1073743089:d               {A@1}
        or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   1073743088:d               {A@1}
        mov (1|M0)               r4.0<1>:f     (abs)r81.13<0;1,0>:d             {A@1}
        mov (1|M0)               r19.0<1>:f    0xB4C00000:f                              
        math.inv (1|M0)          r18.0<1>:f    r4.0<0;1,0>:f                    {F@2}
        mov (1|M0)               r7.0<1>:f     (abs)r81.12<0;1,0>:d            
        mad (1|M0)               r18.0<1>:f    r18.0<0;0>:f      r19.0<0;0>:f      r18.0<0>:f       {A@1}
        mov (2|M0)               r2.0<1>:d     (abs)r81.12<1;1,0>:d            
        mov (1|M0)               r5.0<1>:ud    r4.0<0;1,0>:f                   
        mov (1|M0)               r15.1<1>:ud   r7.0<0;1,0>:f                    {F@2}
        mul (1|M0)               r20.0<1>:f    r18.0<0;1,0>:f    r7.0<0;1,0>:f    {F@1}
        add (1|M0)               r5.0<1>:ud    r2.1<0;1,0>:ud    -r5.0<0;1,0>:ud  {I@2}
        add (1|M0)               r15.1<1>:ud   r2.0<0;1,0>:ud    -r15.1<0;1,0>:ud {I@2}
        mov (1|M0)               r21.0<1>:ud   r20.0<0;1,0>:f                   {F@1}
        mov (1|M0)               r6.0<1>:f     r5.0<0;1,0>:ud                   {I@3}
        mov (1|M0)               r16.0<1>:f    r15.1<0;1,0>:ud                  {I@2}
        mov (1|M0)               r23.0<1>:f    r21.0<0;1,0>:ud                  {I@1}
(W)     mov (1|M0)               r26.0<1>:hf   0x1:hf                             
        mad (1|M0)               r7.0<1>:f     r7.0<0;0>:f       r23.0<0;0>:f      -r4.0<0>:f       {F@2}
        mad (1|M0)               r23.0<1>:f    r16.0<0;0>:f      r23.0<0;0>:f      -r6.0<0>:f      
        xor (1|M0)               r81.13<1>:d   r81.13<0;1,0>:d   r81.12<0;1,0>:d 
        add (1|M0)               r7.0<1>:f     r7.0<0;1,0>:f     r23.0<0;1,0>:f   {F@1}
        asr (1|M0)               r81.13<1>:d   r81.13<0;1,0>:d   31:w               {I@1}
        mul (1|M0)               r18.0<1>:f    r18.0<0;1,0>:f    r7.0<0;1,0>:f    {Compacted,F@1}
        mov (1|M0)               r24.0<1>:ud   r18.0<0;1,0>:f                   {F@1}
        add (1|M0)               r21.0<1>:ud   r21.0<0;1,0>:ud   r24.0<0;1,0>:ud  {Compacted,I@1}
(W)     mul (1|M0)               acc0.0<1>:ud  r21.0<0;1,0>:ud   r2.2<0;1,0>:uw   {I@1}
        macl (1|M0)              r25.0<1>:ud   r21.0<0;1,0>:ud   r2.1<0;1,0>:ud  
        add (1|M0)               r2.0<1>:ud    r2.0<0;1,0>:ud    -r25.0<0;1,0>:ud {I@1}
        cmp (1|M0)    (ge)f2.1   null<1>:ud    r2.0<0;1,0>:ud    r2.1<0;1,0>:ud   {I@1}
(f2.1)  sel (1|M0)               r28.0<1>:d    r26.0<0;1,0>:w    0:w              
        add3 (1|M0)              r21.0<1>:d    r21.0<0;0>:d      r81.13<0;0>:d     r28.0<0>:d       {I@1}
        xor (1|M0)               r73.5<1>:d    r21.0<0;1,0>:d    r81.13<0;1,0>:d  {I@1}
        mov (1|M0)               cr0.0<1>:ud   r1.2<0;1,0>:d                    {A@1}
        sync.allrd                           null                             {A@1}
        sync.allwr                           null                            
        ret (32|M0)                          r81.14                           {A@1}
