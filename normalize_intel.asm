0000000000001870 <normalizeNOAVX>:
    1870:	f3 0f 1e fa          	endbr64 
    1874:	55                   	push   rbp
    1875:	8d 2c 76             	lea    ebp,[rsi+rsi*2]
    1878:	53                   	push   rbx
    1879:	48 83 ec 28          	sub    rsp,0x28
    187d:	85 ed                	test   ebp,ebp
    187f:	7e 70                	jle    18f1 <normalizeNOAVX+0x81>
    1881:	f3 0f 10 2d 8f 08 00 	movss  xmm5,DWORD PTR [rip+0x88f]        # 2118 <_IO_stdin_used+0x118>
    1888:	00 
    1889:	31 db                	xor    ebx,ebx
    188b:	66 0f ef f6          	pxor   xmm6,xmm6
    188f:	90                   	nop
    1890:	f3 0f 10 1f          	movss  xmm3,DWORD PTR [rdi]
    1894:	f3 0f 10 57 04       	movss  xmm2,DWORD PTR [rdi+0x4]
    1899:	f3 0f 10 4f 08       	movss  xmm1,DWORD PTR [rdi+0x8]
    189e:	0f 28 c3             	movaps xmm0,xmm3
    18a1:	0f 28 e2             	movaps xmm4,xmm2
    18a4:	f3 0f 59 e2          	mulss  xmm4,xmm2
    18a8:	f3 0f 59 c3          	mulss  xmm0,xmm3
    18ac:	f3 0f 58 c4          	addss  xmm0,xmm4
    18b0:	0f 28 e1             	movaps xmm4,xmm1
    18b3:	f3 0f 59 e1          	mulss  xmm4,xmm1
    18b7:	f3 0f 58 c4          	addss  xmm0,xmm4
    18bb:	0f 2e f0             	ucomiss xmm6,xmm0
    18be:	77 38                	ja     18f8 <normalizeNOAVX+0x88>
    18c0:	f3 0f 51 c0          	sqrtss xmm0,xmm0
    18c4:	0f 28 e5             	movaps xmm4,xmm5
    18c7:	83 c3 03             	add    ebx,0x3
    18ca:	48 83 c7 0c          	add    rdi,0xc
    18ce:	f3 0f 5e e0          	divss  xmm4,xmm0
    18d2:	f3 0f 59 dc          	mulss  xmm3,xmm4
    18d6:	f3 0f 59 d4          	mulss  xmm2,xmm4
    18da:	f3 0f 59 cc          	mulss  xmm1,xmm4
    18de:	f3 0f 11 5f f4       	movss  DWORD PTR [rdi-0xc],xmm3
    18e3:	f3 0f 11 57 f8       	movss  DWORD PTR [rdi-0x8],xmm2
    18e8:	f3 0f 11 4f fc       	movss  DWORD PTR [rdi-0x4],xmm1
    18ed:	39 eb                	cmp    ebx,ebp
    18ef:	7c 9f                	jl     1890 <normalizeNOAVX+0x20>
    18f1:	48 83 c4 28          	add    rsp,0x28
    18f5:	5b                   	pop    rbx
    18f6:	5d                   	pop    rbp
    18f7:	c3                   	ret    
    18f8:	48 89 7c 24 18       	mov    QWORD PTR [rsp+0x18],rdi
    18fd:	f3 0f 11 4c 24 14    	movss  DWORD PTR [rsp+0x14],xmm1
    1903:	f3 0f 11 54 24 10    	movss  DWORD PTR [rsp+0x10],xmm2
    1909:	f3 0f 11 5c 24 0c    	movss  DWORD PTR [rsp+0xc],xmm3
    190f:	e8 2c f8 ff ff       	call   1140 <sqrtf@plt>
    1914:	48 8b 7c 24 18       	mov    rdi,QWORD PTR [rsp+0x18]
    1919:	66 0f ef f6          	pxor   xmm6,xmm6
    191d:	f3 0f 10 2d f3 07 00 	movss  xmm5,DWORD PTR [rip+0x7f3]        # 2118 <_IO_stdin_used+0x118>
    1924:	00 
    1925:	f3 0f 10 4c 24 14    	movss  xmm1,DWORD PTR [rsp+0x14]
    192b:	f3 0f 10 54 24 10    	movss  xmm2,DWORD PTR [rsp+0x10]
    1931:	f3 0f 10 5c 24 0c    	movss  xmm3,DWORD PTR [rsp+0xc]
    1937:	eb 8b                	jmp    18c4 <normalizeNOAVX+0x54>
    1939:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001940 <normalizeAVX>:
    1940:	f3 0f 1e fa          	endbr64 
    1944:	8d 14 76             	lea    edx,[rsi+rsi*2] # 3*Nvecs, so rsi = Nvecs
    # (wtf? Why does it compute them like addresses, rather than just normal integers??)
    1947:	85 d2                	test   edx,edx
    1949:	0f 8e 89 00 00 00    	jle    19d8 <normalizeAVX+0x98>
    194f:	31 c0                	xor    eax,eax                          # int i = 0
    1951:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]              # What's that?
    1958:	0f 28 07             	movaps xmm0,XMMWORD PTR [rdi]           # xmm0 = {x0, y0, z0, x1} This's __m128 reg0
    195b:	0f 28 5f 10          	movaps xmm3,XMMWORD PTR [rdi+0x10]      # xmm3 = {y1, z1, x2, y2}
    195f:	0f c6 5f 20 9e       	shufps xmm3,XMMWORD PTR [rdi+0x20],0x9e # xmm3 = {x2, y2, x3, y3} This's __m128 rreg
    # In the line above:
    # xmm3 = _mm_shuffle_ps({y1, z1, x2, y2}, {z2, x3, y3, z3}, ShuffleMask(2,3,1,2)),
    # because 0x9e=0b 10 01 11 10
    1964:	83 c0 0c             	add    eax,0xc                          # i += 12
    1967:	48 83 c7 30          	add    rdi,0x30                         # <address> += sizeof(float)*12
    196b:	0f 28 d0             	movaps xmm2,xmm0                        # now xmm2 = {x0, y0, z0, x1}
    196e:	0f c6 57 e0 49       	shufps xmm2,XMMWORD PTR [rdi-0x20],0x49 # xmm2 = {y0, z0, y1, z1} This' __m128 lreg
    # In the line above:
    # xmm2 = _mm_shuffle_ps({x0, y0, z0, x1}, {y1, z1, x2, y2}, ShuffleMask(1,2,0,1)),
    # because 0x49=0b 01 00 10 01
    1973:	0f 28 ca             	movaps xmm1,xmm2                        # xmm1 = {y0, z0, y1, z1} Again, this's __m128 lreg
    1976:	0f c6 c3 8c          	shufps xmm0,xmm3,0x8c                   # xmm0 = {x0, x1, x2, x3} This's __m128 xs
    # In the line above:
    # xmm0 = _mm_shuffle_ps({x0, y0, z0, x1}, {x2, y2, x3, y3}, ShuffleMask(0,3,0,2)),
    # because 0x8c=0b 10 00 11 00
    197a:	0f c6 cb d8          	shufps xmm1,xmm3,0xd8                   # xmm1 = {y0, y1, y2, y3} This's __m128 ys
    # In the line above:
    # xmm1 = _mm_shuffle_ps({y0, z0, y1, z1}, {x2, y2, x3, y3}, ShuffleMask(0,2,1,3)),
    # because 0xd8=0b 11 01 10 00
    197e:	0f 28 d8             	movaps xmm3,xmm0                        # xmm3 = xs = {x0, x1, x2, x3}
    1981:	0f 28 e1             	movaps xmm4,xmm1                        # xmm4 = ys = {y0, y1, y2, y3}
    1984:	0f c6 57 f0 cd       	shufps xmm2,XMMWORD PTR [rdi-0x10],0xcd # xmm2 = {z0, z1, z2, z3} This's __m128 zs
    # In the line above:
    # xmm2 = _mm_shuffle_ps({y0, z0, y1, z1}, {z2, x3, y3, z3}, ShuffleMask(1,3,0,3)),
    # because 0xcd=0b 11 00 11 01

    # So, at that current moment:
    # xmm3 = xmm0 = xs = {x0, x1, x2, x3}
    # xmm4 = xmm1 = ys = {y0, y1, y2, y3}
    # xmm2 = zs = {z0, z1, z2, z3}
    1989:	0f 59 e1             	mulps  xmm4,xmm1 # xmm4 = ys*ys
    198c:	0f 59 d8             	mulps  xmm3,xmm0 # xmm3 = xs*xs
    198f:	0f 58 dc             	addps  xmm3,xmm4 # xmm3 = xs*xs + ys*ys

    1992:	0f 28 e2             	movaps xmm4,xmm2 # xmm4 = zs
    1995:	0f 59 e2             	mulps  xmm4,xmm2 # xmm4 = zs * zs
    1998:	0f 58 dc             	addps  xmm3,xmm4 # xmm3 = xs*xs + ys*ys + zs*zs (Sums of squares)
    199b:	0f 51 db             	sqrtps xmm3,xmm3 # xmm3 = sqrt(xs*xs + ys*ys + zs*zs) (Norms of vectors)

    199e:	0f 5e d3             	divps  xmm2,xmm3 # xmm2 = zs / norms (New zs)
    19a1:	0f 5e c3             	divps  xmm0,xmm3 # xmm0 = xs / norms (New xs)
    19a4:	0f 5e cb             	divps  xmm1,xmm3 # xmm1 = ys / norms (New ys)

    19a7:	0f 28 da             	movaps xmm3,xmm2                   # xmm3 = zs
    19aa:	0f c6 d8 d8          	shufps xmm3,xmm0,0xd8              # xmm3 = {z0, z2, x1, x3} This's __m128 creg
    # In the line above:
    # xmm3 = _mm_shuffle_ps({z0, z1, z2, z3}, {x0, x1, x2, x3}, ShuffleMask(0,2,1,3)),
    # because 0xd8=0b 11 01 10 00
    19ae:	0f c6 c1 88          	shufps xmm0,xmm1,0x88              # xmm0 = {x0, x2, y0, y2} This's __m128 lreg
    # In the line above:
    # xmm0 = _mm_shuffle_ps({x0, x1, x2, x3}, {y0, y1, y2, y3}, ShuffleMask(0,2,0,2)),
    # because 0x88=0b 10 00 10 00
    19b2:	0f c6 ca dd          	shufps xmm1,xmm2,0xdd              # xmm1 = {y1, y3, z1, z3} This's __m128 rreg
    # In the line above:
    # xmm1 = _mm_shuffle_ps({y0, y1, y2, y3}, {z0, z1, z2, z3}, ShuffleMask(1,3,1,3)),
    # because 0xdd=0b 11 01 11 01
    19b6:	0f 28 e0             	movaps xmm4,xmm0                   # xmm4 = {x0, x2, y0, y2} Again, this's __m128 lreg
    19b9:	0f 28 d1             	movaps xmm2,xmm1                   # xmm2 = {y1, y3, z1, z3} Again, this's __m128 rreg
    19bc:	0f c6 e3 88          	shufps xmm4,xmm3,0x88              # xmm4 = {x0, y0, z0, x1} This's __m128 reg0
    # In the line above:
    # xmm4 = _mm_shuffle_ps({x0, x2, y0, y2}, {z0, z2, x1, x3}, ShuffleMask(0,2,0,2)),
    # because 0x88=0b 10 00 10 00
    19c0:	0f c6 d0 d8          	shufps xmm2,xmm0,0xd8              # xmm2 = {y1, z1, x2, y2} This's __m128 reg1
    # In the line above:
    # xmm2 = _mm_shuffle_ps({y1, y3, z1, z3}, {x0, x2, y0, y2}, ShuffleMask(0,2,1,3)),
    # because 0xd8=0b 11 01 10 00
    19c4:	0f c6 d9 dd          	shufps xmm3,xmm1,0xdd              # xmm3 = {z2, x3, y3, z3}
    # In the line above:
    # xmm3 = _mm_shuffle_ps({z0, z2, x1, x3}, {y1, y3, z1, z3}, ShuffleMask(1,3,1,3)),
    # because 0xdd=0b 11 01 11 01

    19c8:	0f 29 67 d0          	movaps XMMWORD PTR [rdi-0x30],xmm4 # _mm_store(array    , reg0 = {x0, y0, z0, x1})
    19cc:	0f 29 57 e0          	movaps XMMWORD PTR [rdi-0x20],xmm2 # _mm_store(array + 4, reg1 = {y1, z1, x2, y2})
    19d0:	0f 29 5f f0          	movaps XMMWORD PTR [rdi-0x10],xmm3 # _mm_store(array + 8, reg2 = {z2, x3, y3, z3})

    19d4:	39 d0                	cmp    eax,edx                     # if i < 3*Nvecs
    19d6:	7c 80                	jl     1958 <normalizeAVX+0x18>    # <go next iteration>
    19d8:	c3                   	ret    
