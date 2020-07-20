                           ; 6502bench SourceGen v1.6.0
                           ASCII_ESCAPE        .eq   $1b    {const}
                           STACK_PTR           .eq   $3f    {const}
                           ASCII2_RETURN       .eq   $8d    {const}
                           ASCII2_ESCAPE       .eq   $9b    {const}
                           ASCII2_SPACE        .eq   $a0    {const}
                           NOP                 .eq   $ea    {const}
                           MON_WNDLEFT         .eq   $20                                     ;left column of scroll window
                           MON_WNDWDTH         .eq   $21                                     ;width of scroll window
                           MON_BASL            .eq   $28                                     ;base address for text output (lo)
                           MON_BASH            .eq   $29                                     ;base address for text output (hi)
                           MON_H2              .eq   $2c                                     ;right end of horizontal line drawn by HLINE
                           MON_V2              .eq   $2d                                     ;bottom of vertical line drawn by VLINE
                           MON_RNDL            .eq   $4e                                     ;low byte of KEYIN "random" value
                           MON_RNDH            .eq   $4f                                     ;high byte of KEYIN "random" value
                           Level               .eq   $1407                                   ;might be 0-based
                           ShootingDir         .eq   $1416  {addr/1}                         ;00-0F, centre/right/left/down/down right/down left/up/up right/up left
                           ControllerType      .eq   $1417
                           MovementDir         .eq   $1506  {addr/1}
                           UsedPaddle?         .eq   $1508
                           Lives               .eq   $1509
                           Score0              .eq   $150a
                           Score1              .eq   $150b
                           Score2              .eq   $150c
                           KBD                 .eq   $c000                                   ;R last key pressed + 128
                           KBDSTRB             .eq   $c010                                   ;RW keyboard strobe
                           SPKR                .eq   $c030                                   ;RW toggle speaker
                           TXTCLR              .eq   $c050                                   ;RW display graphics
                           MIXCLR              .eq   $c052                                   ;RW display full screen
                           TXTPAGE1            .eq   $c054                                   ;RW display page 1
                           HIRES               .eq   $c057                                   ;RW display hi-res graphics
                           BUTN0               .eq   $c061                                   ;R switch input 0 / open-apple
                           BUTN1               .eq   $c062                                   ;R switch input 1 / closed-apple
                           MON_PREAD           .eq   $fb1e                                   ;read paddle specifed by X-reg, return in Y-reg
                           MON_WAIT            .eq   $fca8                                   ;delay for (26 + 27*Acc + 5*(Acc*Acc))/2 cycles

                                               .org  $2dfd
+000000 2dfd: 4c 00 40                         jmp   mainEntryPoint

                                               .org  $0800
+000003 0800: 00 00 10 20+ L0800               .bulk 00001020ffff304050601020ffff3040
+000013 0810: ff ff ff ff+                     .bulk ffffffffffffffff50601020ffff3040
+000023 0820: 7a 7a 7a 7a+ L0820               .bulk 7a7a7a7affff7a7a7a7a7a7affff7a7a
+000033 0830: ff ff ff ff+                     .bulk ffffffffffffffff7a7a7a7affff7a7a
+000043 0840: d0 d0 e0 f0+ L0840               .bulk d0d0e0f0ffff00102030e0f0ffff0010
+000053 0850: ff ff ff ff+                     .bulk ffffffffff00ffff2030e0f0ffff0010
+000063 0860: 7b 7b 7b 7b+ L0860               .bulk 7b7b7b7bffff7c7c7c7c7b7bffff7c7c
+000073 0870: ff ff ff ff+                     .bulk ffffffffffffffff7c7c7b7bffff7c7c
+000083 0880: 70 80 ff ff  L0880               .bulk 7080ffff
+000087 0884: 7a 7a ff ff  L0884               .bulk 7a7affff
+00008b 0888: 40 50 ff ff  L0888               .bulk 4050ffff
+00008f 088c: 7c 7c ff ff  L088C               .bulk 7c7cffff
+000093 0890: e0 d0 00 f0+ L0890               .bulk e0d000f020102010
+00009b 0898: 7a 7a 7b 7a+ L0898               .bulk 7a7a7b7a7b7b7b7b
+0000a3 08a0: 10 20 30 40+ L08A0               .bulk 1020304090a0b0c0708090a0ffffffff
+0000b3 08b0: 7a 7a 7a 7a+ L08B0               .bulk 7a7a7a7a7a7a7a7a7d7d7d7dffffffff
+0000c3 08c0: 60 50 40 30+ L08C0               .bulk 60504030ffffffff
+0000cb 08c8: 7c 7b 7b 7b+ L08C8               .bulk 7c7b7b7bffffffff
+0000d3 08d0: 60 ff ff ff  L08D0               .bulk 60ffffff
+0000d7 08d4: 7b ff ff ff  L08D4               .bulk 7bffffff
+0000db 08d8: 70 80 ff ff  L08D8               .bulk 7080ffff
+0000df 08dc: 7b 7b ff ff  L08DC               .bulk 7b7bffff
+0000e3 08e0: 90 a0 b0 c0+ L08E0               .bulk 90a0b0c0ffffffff
+0000eb 08e8: 7b 7b 7b 7b+ L08E8               .bulk 7b7b7b7bffffffff
+0000f3 08f0: 70 80 90 90+ L08F0               .bulk 70809090a0b0c0c0b0c0d0d0ffffffff
+000103 0900: 7c 7c 7c 7c+ L0900               .bulk 7c7c7c7c7c7c7c7c7d7d7d7dffffffff
+000113 0910: 40 30 20 10+ L0910               .bulk 40302010ffffffff
+00011b 0918: 7d 7d 7d 7d+ L0918               .bulk 7d7d7d7dffffffff
+000123 0920: d0 e0 f0 00+ L0920               .bulk d0e0f000ffffffff
+00012b 0928: 7c 7c 7c 7d+ L0928               .bulk 7c7c7c7dffffffff
+000133 0930: 50 60 ff ff  L0930               .bulk 5060ffff
+000137 0934: 7d 7d ff ff+ L0934               .bulk 7d7dffffffffffffffffffff
+000143 0940: 00 10 20 30+ L0940               .bulk 001020304090a0ff
+00014b 0948: 7f 7f 7f 7f+ L0948               .bulk 7f7f7f7f7f7f7fff
+000153 0950: 80 70 60 50+ L0950               .bulk 80706050ffffffff
+00015b 0958: 7f 7f 7f 7f+ L0958               .bulk 7f7f7f7fffffffff
+000163 0960: f0 e0 ff ff  L0960               .bulk f0e0ffff
+000167 0964: 7f 7f ff ff+ L0964               .bulk 7f7fffffffffffffffffffffffffffff
+000177 0974: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000187 0984: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000197 0994: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001a7 09a4: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001b7 09b4: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001c7 09c4: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001d7 09d4: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001e7 09e4: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0001f7 09f4: ff ff ff ff+                     .bulk ffffffffffffffffffffffff
                           ; NW: map keyboard controls to movement direction
+000203 0a00: ff ff ff ff+ kbdMovementDir      .bulk ffffffffffffffffffffffffffffffff
+000213 0a10: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000223 0a20: 00 ff ff ff+                     .bulk 00ffffffffffffffffffffffffffffff
+000233 0a30: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000243 0a40: ff 03 ff 05+                     .bulk ff03ff05010dffffffffffffffffffff
+000253 0a50: ff 0f ff 00+                     .bulk ff0fff00ffffff0c04ff07ffffffffff
+000263 0a60: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000273 0a70: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
                           ; NW: map keyboard controls to shooting direction
+000283 0a80: ff ff ff ff+ kbdShootingDir      .bulk ffffffffffffffffffffffffffffffff
+000293 0a90: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0002a3 0aa0: 00 ff ff ff+                     .bulk 00ffffffffffffffffffffff07ff0405
+0002b3 0ab0: ff ff ff ff+                     .bulk ffffffffffffffffffffff01ffffffff
+0002c3 0ac0: ff ff ff ff+                     .bulk ffffffffffffffffff0fff0300ffff0c
+0002d3 0ad0: 0d ff ff ff+                     .bulk 0dffffffffffffffffffffffffffffff
+0002e3 0ae0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0002f3 0af0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
                           ; NW: map whole keyboard shooting controls to shooting direction
+000303 0b00: 00 00 00 00+ kbd2ShootingDir     .bulk 00000000000000000000000000000000
+000313 0b10: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000323 0b20: 04 00 00 00+                     .bulk 04000000000000000000000005000505
+000333 0b30: 0d 0f 0f 0f+                     .bulk 0d0f0f0f0f0c0c0c0d0d0d0500000000
+000343 0b40: 00 07 07 07+                     .bulk 00070707070307070501050505050501
+000353 0b50: 01 03 03 07+                     .bulk 01030307030107030701070000000000
+000363 0b60: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000373 0b70: 00 00 00 00+                     .bulk 00000000000000000000000000000000
                           ; maybe unused
+000383 0b80: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000393 0b90: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003a3 0ba0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003b3 0bb0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003c3 0bc0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003d3 0bd0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003e3 0be0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0003f3 0bf0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
                           ; NW: static constants
+000403 0c00: 08           L0C00               .dd1  $08
+000404 0c01: 78           L0C01               .dd1  $78
+000405 0c02: 10           L0C02               .dd1  $10
+000406 0c03: 20           L0C03               .dd1  $20
+000407 0c04: 30           L0C04               .dd1  $30
+000408 0c05: 04           L0C05               .dd1  $04
+000409 0c06: 04           L0C06               .dd1  $04
+00040a 0c07: 08           L0C07               .dd1  $08
+00040b 0c08: 05           L0C08               .dd1  $05
+00040c 0c09: 04           L0C09               .dd1  $04
+00040d 0c0a: 18           L0C0A               .dd1  $18
+00040e 0c0b: 08           L0C0B               .dd1  $08
+00040f 0c0c: 18           L0C0C               .dd1  $18
+000410 0c0d: 06           L0C0D               .dd1  $06
+000411 0c0e: 20           L0C0E               .dd1  $20
+000412 0c0f: 0d           L0C0F               .dd1  $0d
+000413 0c10: a8           L0C10               .dd1  $a8
+000414 0c11: 61           L0C11               .dd1  $61
+000415 0c12: 00           L0C12               .dd1  $00
+000416 0c13: 03           L0C13               .dd1  $03
+000417 0c14: 28           L0C14               .dd1  $28
+000418 0c15: 0c           L0C15               .dd1  $0c
+000419 0c16: 1c           L0C16               .dd1  $1c
+00041a 0c17: 0a           L0C17               .dd1  $0a
+00041b 0c18: 01           L0C18               .dd1  $01
+00041c 0c19: 01           L0C19               .dd1  $01
+00041d 0c1a: 01           L0C1A               .dd1  $01
+00041e 0c1b: 10           L0C1B               .dd1  $10
+00041f 0c1c: 07           L0C1C               .dd1  $07
+000420 0c1d: ff           L0C1D               .dd1  $ff
+000421 0c1e: 08           L0C1E               .dd1  $08
+000422 0c1f: 10                               .dd1  $10
+000423 0c20: f0           L0C20               .dd1  $f0
+000424 0c21: 60           L0C21               .dd1  $60
+000425 0c22: 08           L0C22               .dd1  $08
+000426 0c23: 20           L0C23               .dd1  $20
+000427 0c24: 04           L0C24               .dd1  $04
+000428 0c25: 04           L0C25               .dd1  $04
+000429 0c26: 2c           L0C26               .dd1  $2c
+00042a 0c27: a0           L0C27               .dd1  $a0
+00042b 0c28: 30           L0C28               .dd1  $30
+00042c 0c29: 30           L0C29               .dd1  $30
+00042d 0c2a: 06           L0C2A               .dd1  $06
+00042e 0c2b: 18           L0C2B               .dd1  $18
+00042f 0c2c: 20           L0C2C               .dd1  $20
+000430 0c2d: 04           L0C2D               .dd1  $04
+000431 0c2e: 07           L0C2E               .dd1  $07
+000432 0c2f: a0           L0C2F               .dd1  $a0
+000433 0c30: 18           L0C30               .dd1  $18
+000434 0c31: ff           L0C31               .dd1  $ff
+000435 0c32: 02           L0C32               .dd1  $02
+000436 0c33: ff                               .dd1  $ff
+000437 0c34: 60           L0C34               .dd1  $60
+000438 0c35: 06           L0C35               .dd1  $06
+000439 0c36: 06           L0C36               .dd1  $06
+00043a 0c37: 60           L0C37               .dd1  $60
+00043b 0c38: 02           L0C38               .dd1  $02
+00043c 0c39: 20           L0C39               .dd1  $20
+00043d 0c3a: d0           L0C3A               .dd1  $d0
+00043e 0c3b: f0           L0C3B               .dd1  $f0
+00043f 0c3c: ff                               .dd1  $ff
+000440 0c3d: ff           L0C3D               .dd1  $ff
+000441 0c3e: 00           L0C3E               .dd1  $00
+000442 0c3f: 60           L0C3F               .dd1  $60
+000443 0c40: 01                               .dd1  $01
+000444 0c41: 00           L0C41               .dd1  $00
+000445 0c42: ff                               .dd1  $ff
+000446 0c43: 08           L0C43               .dd1  $08
+000447 0c44: 04           L0C44               .dd1  $04
+000448 0c45: 0d           L0C45               .dd1  $0d
+000449 0c46: 40           L0C46               .dd1  $40
+00044a 0c47: 03           L0C47               .dd1  $03
+00044b 0c48: 10           L0C48               .dd1  $10
+00044c 0c49: 40           L0C49               .dd1  $40
+00044d 0c4a: 10           L0C4A               .dd1  $10
+00044e 0c4b: 18           L0C4B               .dd1  $18
+00044f 0c4c: 28           L0C4C               .dd1  $28
+000450 0c4d: 02           L0C4D               .dd1  $02
+000451 0c4e: 02           L0C4E               .dd1  $02
+000452 0c4f: 01           L0C4F               .dd1  $01
+000453 0c50: 30           L0C50               .dd1  $30
+000454 0c51: 06           L0C51               .dd1  $06
+000455 0c52: 08           L0C52               .dd1  $08
+000456 0c53: 01           L0C53               .dd1  $01
+000457 0c54: 20           L0C54               .dd1  $20
+000458 0c55: 80           L0C55               .dd1  $80
+000459 0c56: e0           L0C56               .dd1  $e0
+00045a 0c57: 03           L0C57               .dd1  $03
+00045b 0c58: 10           L0C58               .dd1  $10
+00045c 0c59: 1c           L0C59               .dd1  $1c
+00045d 0c5a: 04           L0C5A               .dd1  $04
+00045e 0c5b: 30           L0C5B               .dd1  $30
+00045f 0c5c: f8                               .dd1  $f8
+000460 0c5d: 08                               .dd1  $08
+000461 0c5e: 06           L0C5E               .dd1  $06
+000462 0c5f: 02           L0C5F               .dd1  $02
+000463 0c60: 03           L0C60               .dd1  $03
+000464 0c61: 0b           L0C61               .dd1  $0b
+000465 0c62: 00                               .dd1  $00
+000466 0c63: 03           L0C63               .dd1  $03
+000467 0c64: 90           L0C64               .dd1  $90
+000468 0c65: 0a           L0C65               .dd1  $0a
+000469 0c66: 60           L0C66               .dd1  $60
+00046a 0c67: 80           L0C67               .dd1  $80
+00046b 0c68: c0           L0C68               .dd1  $c0
+00046c 0c69: 17           L0C69               .dd1  $17
+00046d 0c6a: 05           L0C6A               .dd1  $05
+00046e 0c6b: 0c ff ff ff+ L0C6B               .bulk 0cffffffffffffffffffffffffffffff
+00047e 0c7b: ff ff ff ff+                     .bulk ffffffffff
+000483 0c80: 12 01 08 0a+ L0C80               .bulk 1201080a0614041e022800ff1301080a
+000493 0c90: 06 14 04 1e+                     .bulk 0614041e022800ff1401401030202030
+0004a3 0ca0: 18 ff ff ff+                     .bulk 18ffffffffffffffffffffffffffffff
+0004b3 0cb0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0004c3 0cc0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0004d3 0cd0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0004e3 0ce0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0004f3 0cf0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000503 0d00: 00 02 12 fe  L0D00               .bulk 000212fe
+000507 0d04: 03 fd 07 f9+ L0D04               .bulk 03fd07f90cf410f0
+00050f 0d0c: ff ff be be+ L0D0C               .bulk ffffbebe9c9c8c8c
+000517 0d14: 04 fc 00 00  L0D14               .bulk 04fc0000
+00051b 0d18: 00 00 04 fc  L0D18               .bulk 000004fc
+00051f 0d1c: 02 fe        L0D1C               .bulk 02fe
                           ; NW: direction of fire table
+000521 0d1e: 0c 0d 01 05+ fireDirection       .bulk 0c0d01050407030f
+000529 0d26: 7f 3f 3e 1e+ L0D26               .bulk 7f3f3e1e1c0c7f3f3e1e1c0c
+000535 0d32: 02 04 06 08+ L0D32               .bulk 020406080a0cfefcfaf8f6f4
+000541 0d3e: 06 fa 00 00  L0D3E               .bulk 06fa0000
+000545 0d42: 00 00 06 fa  L0D42               .bulk 000006fa
+000549 0d46: ff ff ff ff+ L0D46               .bulk ffffffffffffffffd8d8d800ffffffd8
+000559 0d56: d8 b4 b4 80+                     .bulk d8b4b48080800000
                           ; NW: direction of fire rotation table
+000561 0d5e: ea 02 ea 06+ fireRotation        .bulk ea02ea060403ea05eaeaeaea0001ea07
+000571 0d6e: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000581 0d7e: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000591 0d8e: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005a1 0d9e: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005b1 0dae: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005c1 0dbe: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005d1 0dce: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005e1 0dde: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0005f1 0dee: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+000601 0dfe: ff ff                            .bulk ffff
+000603 0e00: 0b 12 15 19+ L0E00               .bulk 0b1215190c1500151e0f190019191119
+000613 0e10: 00 1a 24 11+                     .bulk 001a24111900191d1219001928131d00
+000623 0e20: 20 1d 14 1d+                     .bulk 201d141d00202b140101010101010101
+000633 0e30: 28 00 01 00+                     .bulk 28000100000000000000000000000000
+000643 0e40: 00 00 10 01+                     .bulk 00001001000000800009000000002800
+000653 0e50: 00 00 01 01+                     .bulk 00000101000100002800000000000014
+000663 0e60: 00 10 80 01+                     .bulk 00108001000000000000000000000000
+000673 0e70: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000683 0e80: 00 04 05 05+ L0E80               .bulk 00040505000608060200070907100007
+000693 0e90: 0a 08 02 00+                     .bulk 0a080200070a070703090a020904070b
+0006a3 0ea0: 07 10 04 09+                     .bulk 07100409030909040101011001010100
+0006b3 0eb0: 00 00 10 00+                     .bulk 00001000000000000000000000000100
+0006c3 0ec0: 00 00 00 00+                     .bulk 00000000000000001000100000000000
+0006d3 0ed0: 00 00 00 10+                     .bulk 00000010010000000000000000100000
+0006e3 0ee0: 10 02 10 00+                     .bulk 10021000000000000000000000000000
+0006f3 0ef0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000703 0f00: 01 03 03 03+ L0F00               .bulk 0103030300030504020e050505070006
+000713 0f10: 07 03 06 05+                     .bulk 070306050607060600060306070f0705
+000723 0f20: 07 06 00 03+                     .bulk 07060003050707060101010101010105
+000733 0f30: 05 00 00 10+                     .bulk 05000010000000000001001000000101
+000743 0f40: 00 05 00 00+                     .bulk 00050000000010000000000001010000
+000753 0f50: 00 00 00 05+                     .bulk 00000005100000090001000001000000
+000763 0f60: 00 00 05 01+                     .bulk 00000501000000000000000000000000
+000773 0f70: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000783 0f80: 01 02 03 03+ L0F80               .bulk 010203030c0505040200040504060005
+000793 0f90: 06 02 05 06+                     .bulk 06020506060706060f06030607000605
+0007a3 0fa0: 06 08 01 03+                     .bulk 0608010305070706010101010e010105
+0007b3 0fb0: 05 00 00 00+                     .bulk 05000000100000000000010001000100
+0007c3 0fc0: 10 05 05 00+                     .bulk 10050500101000000000000001010000
+0007d3 0fd0: 00 00 00 05+                     .bulk 00000005000000000000010001060000
+0007e3 0fe0: 00 00 05 01+                     .bulk 00000501000000000000000000000000
+0007f3 0ff0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000803 1000: 00 01 02 02+ L1000               .bulk 00010202010202020000020202021002
+000813 1010: 02 01 02 05+                     .bulk 02010205020202020102010202000202
+000823 1020: 02 02 0f 01+                     .bulk 02020f01020202040101010101010106
+000833 1030: 06 00 00 00+                     .bulk 06000000001000000000000000100500
+000843 1040: 00 06 00 00+                     .bulk 000600000000000000001010000e000e
+000853 1050: 00 00 00 06+                     .bulk 00000006000000000000000101000000
+000863 1060: 00 00 06 01+                     .bulk 00000601000000000000000000000000
+000873 1070: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000883 1080: 00 03 06 09+ L1080               .bulk 00030609030900090906090009060609
+000893 1090: 00 09 0a 07+                     .bulk 00090a0709000c0c0709070c0b0c0c00
+0008a3 10a0: 0c 0c 0c 0c+                     .bulk 0c0c0c0c0a0f0b0f0101010101010100
+0008b3 10b0: 00 00 00 00+                     .bulk 00000000000050000005050000000500
+0008c3 10c0: 00 00 00 00+                     .bulk 000000000100000000000000000a0000
+0008d3 10d0: 00 01 00 00+                     .bulk 00010000000000000000000000000000
+0008e3 10e0: 00 00 50 00+                     .bulk 00005000000000000000000000000000
+0008f3 10f0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000903 1100: 00 00 00 00+ L1100               .bulk 000000000a000000000b000000000c00
+000913 1110: 00 00 00 0c+                     .bulk 0000000c000000000d000000000e0000
+000923 1120: 00 00 0e 00+                     .bulk 00000e000000000e0101010110010100
+000933 1130: 00 10 00 01+                     .bulk 00100001010100100000000110000000
+000943 1140: 00 00 00 00+                     .bulk 0000000000010000000010000000000a
+000953 1150: 00 00 00 00+                     .bulk 00000000010000010001010100001000
+000963 1160: 00 00 10 00+                     .bulk 00001000000000000000000000000000
+000973 1170: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+000983 1180: 00 00 00 00+ L1180               .bulk 00000000000006000000000700000000
+000993 1190: 08 00 00 00+                     .bulk 08000000000900000000050101000009
+0009a3 11a0: 01 00 00 01+                     .bulk 01000001070202010106010101010700
+0009b3 11b0: 00 00 00 00+                     .bulk 00000000000000001000000000010110
+0009c3 11c0: 01 00 04 00+                     .bulk 01000400000001000800000001010004
+0009d3 11d0: 01 00 00 00+                     .bulk 01000000010003010000000010011000
+0009e3 11e0: 10 01 10 00+                     .bulk 10011000000000000000000000000000
+0009f3 11f0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
                           ; NW: hires lookup table (low bytes)
+000a03 1200: 00 00 00 00+ hiresLookupL        .bulk 00000000000000008080808080808080
+000a13 1210: 00 00 00 00+                     .bulk 00000000000000008080808080808080
+000a23 1220: 00 00 00 00+                     .bulk 00000000000000008080808080808080
+000a33 1230: 00 00 00 00+                     .bulk 00000000000000008080808080808080
+000a43 1240: 28 28 28 28+                     .bulk 2828282828282828a8a8a8a8a8a8a8a8
+000a53 1250: 28 28 28 28+                     .bulk 2828282828282828a8a8a8a8a8a8a8a8
+000a63 1260: 28 28 28 28+                     .bulk 2828282828282828a8a8a8a8a8a8a8a8
+000a73 1270: 28 28 28 28+                     .bulk 2828282828282828a8a8a8a8a8a8a8a8
+000a83 1280: 50 50 50 50+                     .bulk 5050505050505050d0d0d0d0d0d0d0d0
+000a93 1290: 50 50 50 50+                     .bulk 5050505050505050d0d0d0d0d0d0d0d0
+000aa3 12a0: 50 50 50 50+                     .bulk 5050505050505050d0d0d0d0d0d0d0d0
+000ab3 12b0: 50 50 50 50+                     .bulk 5050505050505050d0d0d0d0d0d0d0d0
+000ac3 12c0: d0 d0 d0 d0+                     .bulk d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0
+000ad3 12d0: d0 d0 d0 d0+                     .bulk d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0
+000ae3 12e0: d0 d0 d0 d0+                     .bulk d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0
+000af3 12f0: d0 d0 d0 d0+                     .bulk d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0
                           ; NW: hires lookup table (high bytes)
+000b03 1300: 20 24 28 2c+ hiresLookupH        .bulk 2024282c3034383c2024282c3034383c
+000b13 1310: 21 25 29 2d+                     .bulk 2125292d3135393d2125292d3135393d
+000b23 1320: 22 26 2a 2e+                     .bulk 22262a2e32363a3e22262a2e32363a3e
+000b33 1330: 23 27 2b 2f+                     .bulk 23272b2f33373b3f23272b2f33373b3f
+000b43 1340: 20 24 28 2c+                     .bulk 2024282c3034383c2024282c3034383c
+000b53 1350: 21 25 29 2d+                     .bulk 2125292d3135393d2125292d3135393d
+000b63 1360: 22 26 2a 2e+                     .bulk 22262a2e32363a3e22262a2e32363a3e
+000b73 1370: 23 27 2b 2f+                     .bulk 23272b2f33373b3f23272b2f33373b3f
+000b83 1380: 20 24 28 2c+                     .bulk 2024282c3034383c2024282c3034383c
+000b93 1390: 21 25 29 2d+                     .bulk 2125292d3135393d2125292d3135393d
+000ba3 13a0: 22 26 2a 2e+                     .bulk 22262a2e32363a3e22262a2e32363a3e
+000bb3 13b0: 23 27 2b 2f+                     .bulk 23272b2f33373b3f23272b2f33373b3f
+000bc3 13c0: 1f 1f 1f 1f+                     .bulk 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
+000bd3 13d0: 1f 1f 1f 1f+                     .bulk 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
+000be3 13e0: 1f 1f 1f 1f+                     .bulk 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
+000bf3 13f0: 1f 1f 1f 1f+                     .bulk 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f

                                               .org  $0100
                           ; stack page begins here
+000c03 0100: 00 00 00 00+                     .fill 64,$00

                           ********************************************************************************
                           *                                                                              *
                           * story exposition + tutorial                                                  *
                           *                                                                              *
                           ********************************************************************************
+000c43 0140: 4c 58 01     storyPart1_jmp      jmp   storyPart1

+000c46 0143: 4c 4f 03     storyPart3_jmp      jmp   storyPart3

+000c49 0146: 4c 8e 02     storyPart2_jmp      jmp   storyPart2

+000c4c 0149: 4c b4 03     storyPart4_jmp      jmp   storyPart4

+000c4f 014c: 4c fe 03     storyPart5_jmp      jmp   storyPart5

+000c52 014f: 4c 74 04     storyPart6_jmp      jmp   storyPart6

+000c55 0152: 4c e9 04     S0152               jmp   L04E9

+000c58 0155: 4c 4a 05     doShowWilliams      jmp   showWilliams

+000c5b 0158: 20 d3 04     storyPart1          jsr   printStoryPart
+000c5e 015b: 0d                               .dd1  $0d
+000c5f 015c: 03                               .dd1  3
+000c60 015d: 18                               .dd1  24
+000c61 015e: 49 4e 53 50+                     .str  “INSPIRED BY HIS NEVER-ENDING QUEST”
+000c83 0180: 0d                               .dd1  $0d
+000c84 0181: 03                               .dd1  3
+000c85 0182: 28                               .dd1  40
+000c86 0183: 46 4f 52 20+                     .str  “FOR PROGRESS, IN 2084 MAN PERFECTS”
+000ca8 01a5: 0d                               .dd1  $0d
+000ca9 01a6: 03                               .dd1  3
+000caa 01a7: 38                               .dd1  56
+000cab 01a8: 54 48 45 20+                     .str  “THE ROBOTRONS:”
+000cb9 01b6: 02                               .dd1  $02
+000cba 01b7: 08                               .dd1  $08
+000cbb 01b8: 0d                               .dd1  $0d
+000cbc 01b9: 03                               .dd1  3
+000cbd 01ba: 50                               .dd1  80
+000cbe 01bb: 41 20 52 4f+                     .str  “A ROBOT SPECIES SO ADVANCED THAT MAN”
+000ce2 01df: 0d                               .dd1  $0d
+000ce3 01e0: 03                               .dd1  3
+000ce4 01e1: 60                               .dd1  96
+000ce5 01e2: 49 53 20 49+                     .str  “IS INFERIOR TO HIS OWN CREATION.”
+000d05 0202: 02                               .dd1  $02
+000d06 0203: 08                               .dd1  $08
+000d07 0204: 0d                               .dd1  $0d
+000d08 0205: 03                               .dd1  3
+000d09 0206: 78                               .dd1  120
+000d0a 0207: 47 55 49 44+                     .str  “GUIDED BY THEIR INFALLIBLE LOGIC,”
+000d2b 0228: 0d                               .dd1  $0d
+000d2c 0229: 03                               .dd1  3
+000d2d 022a: 88                               .dd1  136
+000d2e 022b: 54 48 45 20+                     .str  “THE ROBOTRONS CONCLUDE:”
+000d45 0242: 02                               .dd1  $02
+000d46 0243: 08                               .dd1  $08
+000d47 0244: 0d                               .dd1  $0d
+000d48 0245: 03                               .dd1  3
+000d49 0246: a0                               .dd1  160
+000d4a 0247: 54 48 45 20+                     .str  “THE HUMAN RACE IS INEFFICIENT, AND”
+000d6c 0269: 0d                               .dd1  $0d
+000d6d 026a: 03                               .dd1  3
+000d6e 026b: b0                               .dd1  176
+000d6f 026c: 54 48 45 52+                     .str  “THEREFORE MUST BE DESTROYED.”
+000d8b 0288: 02                               .dd1  $02
+000d8c 0289: 60                               .dd1  $60
+000d8d 028a: 02                               .dd1  $02
+000d8e 028b: 01                               .dd1  $01
+000d8f 028c: 00                               .dd1  $00

+000d90 028d: 60                               rts

+000d91 028e: 20 d3 04     storyPart2          jsr   printStoryPart
+000d94 0291: 0d                               .dd1  $0d
+000d95 0292: 03                               .dd1  3
+000d96 0293: 18                               .dd1  24
+000d97 0294: 59 4f 55 20+                     .str  “YOU ARE THE LAST HOPE OF MANKIND.”
+000db8 02b5: 02                               .dd1  $02
+000db9 02b6: 08                               .dd1  $08                                     ;ascii bell?
+000dba 02b7: 0d                               .dd1  $0d
+000dbb 02b8: 03                               .dd1  3
+000dbc 02b9: 30                               .dd1  48
+000dbd 02ba: 44 55 45 20+                     .str  “DUE TO A GENETIC ENGINEERING ERROR,”
+000de0 02dd: 0d                               .dd1  $0d
+000de1 02de: 03                               .dd1  3
+000de2 02df: 40                               .dd1  64
+000de3 02e0: 59 4f 55 20+                     .str  “YOU POSSESS SUPERHUMAN POWERS.”
+000e01 02fe: 02                               .dd1  $02
+000e02 02ff: 08                               .dd1  $08
+000e03 0300: 0d                               .dd1  $0d
+000e04 0301: 03                               .dd1  3
+000e05 0302: 58                               .dd1  88
+000e06 0303: 59 4f 55 52+                     .str  “YOUR MISSION IS TO STOP THE”
+000e21 031e: 0d                               .dd1  $0d
+000e22 031f: 03                               .dd1  3
+000e23 0320: 68                               .dd1  104
+000e24 0321: 52 4f 42 4f+                     .str  “ROBOTRONS, AND SAVE THE LAST”
+000e40 033d: 0d                               .dd1  $0d
+000e41 033e: 03                               .dd1  3
+000e42 033f: 78                               .dd1  120
+000e43 0340: 48 55 4d 41+                     .str  “HUMAN FAMILY.”
+000e50 034d: 00                               .dd1  $00

+000e51 034e: 60                               rts

+000e52 034f: 20 d3 04     storyPart3          jsr   printStoryPart
+000e55 0352: 0d                               .dd1  $0d
+000e56 0353: 03                               .dd1  3
+000e57 0354: 28                               .dd1  40
+000e58 0355: 54 48 45 20+                     .str  “THE FORCE OF GROUND ROVING UNIT”
+000e77 0374: 0d                               .dd1  $0d
+000e78 0375: 03                               .dd1  3
+000e79 0376: 38                               .dd1  56
+000e7a 0377: 4e 45 54 57+                     .str  “NETWORK TERMINATOR (GRUNT)”
+000e94 0391: 0d                               .dd1  $0d
+000e95 0392: 03                               .dd1  3
+000e96 0393: 48                               .dd1  72
+000e97 0394: 52 4f 42 4f+                     .str  “ROBOTRONS SEEK TO DESTROY YOU.”
+000eb5 03b2: 00                               .dd1  $00

+000eb6 03b3: 60                               rts

+000eb7 03b4: 20 d3 04     storyPart4          jsr   printStoryPart
+000eba 03b7: 0d                               .dd1  $0d
+000ebb 03b8: 03                               .dd1  3
+000ebc 03b9: 38                               .dd1  56
+000ebd 03ba: 54 48 45 20+                     .str  “THE HULK ROBOTRONS SEEK OUT AND”
+000edc 03d9: 0d                               .dd1  $0d
+000edd 03da: 03                               .dd1  3
+000ede 03db: 48                               .dd1  72
+000edf 03dc: 45 4c 49 4d+                     .str  “ELIMINATE THE LAST HUMAN FAMILY.”
+000eff 03fc: 00                               .dd1  $00

+000f00 03fd: 60                               rts

+000f01 03fe: 20 d3 04     storyPart5          jsr   printStoryPart
+000f04 0401: 0d                               .dd1  $0d
+000f05 0402: 03                               .dd1  3
+000f06 0403: 28                               .dd1  40
+000f07 0404: 42 45 57 41+                     .str  “BEWARE OF THE INGENIOUS”
+000f1e 041b: 0d                               .dd1  $0d
+000f1f 041c: 03                               .dd1  3
+000f20 041d: 38                               .dd1  56
+000f21 041e: 42 52 41 49+                     .str  “BRAIN ROBOTRONS, THAT POSSESS”
+000f3e 043b: 0d                               .dd1  $0d
+000f3f 043c: 03                               .dd1  3
+000f40 043d: 48                               .dd1  72
+000f41 043e: 54 48 45 20+                     .str  “THE POWER TO REPROGRAM HUMANS”
+000f5e 045b: 0d                               .dd1  $0d
+000f5f 045c: 03                               .dd1  3
+000f60 045d: 58                               .dd1  88
+000f61 045e: 49 4e 54 4f+                     .str  “INTO SINISTER PROGS.”
+000f75 0472: 00                               .dd1  $00

+000f76 0473: 60                               rts

+000f77 0474: 20 d3 04     storyPart6          jsr   printStoryPart
+000f7a 0477: 0d                               .dd1  $0d
+000f7b 0478: 03                               .dd1  3
+000f7c 0479: 38                               .dd1  56
+000f7d 047a: 54 48 45 20+                     .str  “THE SPHEROIDS AND QUARKS”
+000f95 0492: 0d                               .dd1  $0d
+000f96 0493: 03                               .dd1  3
+000f97 0494: 48                               .dd1  72
+000f98 0495: 41 52 45 20+                     .str  “ARE PROGRAMMED TO MANUFACTURE”
+000fb5 04b2: 0d                               .dd1  $0d
+000fb6 04b3: 03                               .dd1  3
+000fb7 04b4: 58                               .dd1  88
+000fb8 04b5: 45 4e 46 4f+                     .str  “ENFORCER AND TANK ROBOTRONS.”
+000fd4 04d1: 00                               .dd1  $00

+000fd5 04d2: 60                               rts

                           ; NW: print text following JSR and animate attract mode intro screens
+000fd6 04d3: 68           printStoryPart      pla
+000fd7 04d4: 85 28                            sta   MON_BASL
+000fd9 04d6: 68                               pla
+000fda 04d7: 85 29                            sta   MON_BASH
+000fdc 04d9: a9 00                            lda   #$00
+000fde 04db: 85 2a                            sta   $2a
+000fe0 04dd: a9 ff                            lda   #$ff
+000fe2 04df: 85 2b                            sta   $2b
+000fe4 04e1: 85 2c                            sta   MON_H2
+000fe6 04e3: a2 01                            ldx   #$01
+000fe8 04e5: 20 40 05                         jsr   @check7
+000feb 04e8: 60                               rts

+000fec 04e9: a0 00        L04E9               ldy   #$00
+000fee 04eb: b1 28                            lda   (MON_BASL),y
+000ff0 04ed: d0 01                            bne   @check1
+000ff2 04ef: 60                               rts

+000ff3 04f0: a6 2a        @check1             ldx   $2a
+000ff5 04f2: f0 03                            beq   @check2
+000ff7 04f4: c6 2a                            dec   $2a
+000ff9 04f6: 60                               rts

+000ffa 04f7: c9 01        @check2             cmp   #$01
+000ffc 04f9: d0 0a                            bne   @check3
+000ffe 04fb: c8                               iny
+000fff 04fc: b1 28                            lda   (MON_BASL),y
+001001 04fe: 85 2b                            sta   $2b
+001003 0500: a2 02                            ldx   #$02
+001005 0502: 4c 40 05                         jmp   @check7

+001008 0505: c9 02        @check3             cmp   #$02
+00100a 0507: d0 0a                            bne   @check4
+00100c 0509: c8                               iny
+00100d 050a: b1 28                            lda   (MON_BASL),y
+00100f 050c: 85 2a                            sta   $2a
+001011 050e: a2 02                            ldx   #$02
+001013 0510: 4c 40 05                         jmp   @check7

+001016 0513: c9 0d        @check4             cmp   #$0d
+001018 0515: d0 0f                            bne   @check5
+00101a 0517: c8                               iny
+00101b 0518: b1 28                            lda   (MON_BASL),y
+00101d 051a: 85 2d                            sta   MON_V2
+00101f 051c: c8                               iny
+001020 051d: b1 28                            lda   (MON_BASL),y
+001022 051f: 85 2e                            sta   $2e
+001024 0521: a2 03                            ldx   #$03
+001026 0523: 4c 40 05                         jmp   @check7

+001029 0526: a6 2d        @check5             ldx   MON_V2
+00102b 0528: a4 2e                            ldy   $2e
+00102d 052a: 48                               pha
+00102e 052b: 20 08 51                         jsr   printChar
+001031 052e: 68                               pla
+001032 052f: c9 20                            cmp   #$20
+001034 0531: f0 09                            beq   @check6
+001036 0533: a5 2f                            lda   $2f
+001038 0535: c9 60                            cmp   #$60
+00103a 0537: f0 03                            beq   @check6
+00103c 0539: ad 30 c0                         lda   SPKR                                    ;SPKR in story is simple clicking
+00103f 053c: e6 2d        @check6             inc   MON_V2
+001041 053e: a2 01                            ldx   #$01
+001043 0540: e6 28        @check7             inc   MON_BASL
+001045 0542: d0 02                            bne   @check8
+001047 0544: e6 29                            inc   MON_BASH
+001049 0546: ca           @check8             dex
+00104a 0547: d0 f7                            bne   @check7
+00104c 0549: 60                               rts

+00104d 054a: 20 b8 51     showWilliams        jsr   showText                                ;NW: copyright notice
+001050 054d: 0d                               .dd1  $0d
+001051 054e: 03                               .dd1  3
+001052 054f: a0                               .dd1  160
+001053 0550: 24 20 31 39+                     .str  “$ 1982 WILLIAMS ELECTRONICS, INC.”
+001074 0571: 0d                               .dd1  $0d
+001075 0572: 0a                               .dd1  10
+001076 0573: ab                               .dd1  171
+001077 0574: 24 20 31 39+                     .str  “$ 1983 ATARI, INC.”
+001089 0586: 00                               .dd1  $00

+00108a 0587: 60                               rts

+00108b 0588: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+00109b 0598: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+0010ab 05a8: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+0010bb 05b8: 00 00 00 00+                     .bulk 0000000000000000808080cc81808080
+0010cb 05c8: 80 80 80 ce+                     .bulk 808080ce83808080808080cb86808080
+0010db 05d8: 80 80 c0 c9+                     .bulk 8080c0c98c8080808080e0c898808080
+0010eb 05e8: 80 80 b0 c8+                     .bulk 8080b0c8b0808080808098c8e0808080
+0010fb 05f8: 80 80 8c c8+                     .bulk 80808cc8c4818080808086c98c838080
+00110b 0608: 80 80 c3 c9+                     .bulk 8080c3c99c8680808080e1c9b4848080
+00111b 0618: fe 9f b1 c9+                     .bulk fe9fb1c9e484c087829099c9c484c084
+00112b 0628: 82 90 89 c9+                     .bulk 829089c9c484c084e29f89c9c484c084
+00113b 0638: c6 81 89 c9+                     .bulk c68189c9c484c0848c8389c9c484c084
+00114b 0648: 98 86 89 c9+                     .bulk 988689c9c4e4ff84b08c89c9fca48084
+00115b 0658: e0 98 89 c9+                     .bulk e09889c980a48084c09189c980a4fe84
+00116b 0668: 80 93 89 c9+                     .bulk 809389c9fca4c2849e9289c9c4a4c284
+00117b 0678: a2 91 89 c9+                     .bulk a29189c9c4a4c284e29189c9c4a4c284
+00118b 0688: 86 98 89 c9+                     .bulk 869889c9c4a4c2848c8c89c9c4a4c284
+00119b 0698: 98 86 89 c9+                     .bulk 988689c9c4a4c284b08399c9e4a4c284
+0011ab 06a8: e0 81 b1 c9+                     .bulk e081b1c9b4e4c3878080e3c99c868080
+0011bb 06b8: 80 80 c6 c9+                     .bulk 8080c6c98c83808080808cc9c4818080
+0011cb 06c8: 80 80 98 c8+                     .bulk 808098c8e08080808080b0c8b0808080
+0011db 06d8: 80 80 e0 c8+                     .bulk 8080e0c8988080808080c0c98c808080
+0011eb 06e8: 80 80 80 cb+                     .bulk 808080cb86808080808080ce83808080
+0011fb 06f8: 80 80 80 cc+                     .bulk 808080cc81808080

                                               .org  $4000
+001203 4000: a2 3f        mainEntryPoint      ldx   #STACK_PTR                              ;force stack pointer
+001205 4002: 9a                               txs
+001206 4003: a9 2e                            lda   #$2e
+001208 4005: a2 0c                            ldx   #$0c
+00120a 4007: a0 08                            ldy   #$08
+00120c 4009: 20 9d 44                         jsr   copyPagesAtoY                           ;copy #$0c pages from $2e00 to $0800
+00120f 400c: a9 3a                            lda   #$3a
+001211 400e: a2 06                            ldx   #$06
+001213 4010: a0 01                            ldy   #$01
+001215 4012: 20 9d 44                         jsr   copyPagesAtoY                           ;copy 6 pages from $3a00 to $0100 (overwrites stack!)
+001218 4015: a2 3f                            ldx   #STACK_PTR                              ;needs to re-force stack pointer (why?)
+00121a 4017: 9a                               txs
+00121b 4018: 20 2f 51                         jsr   init01_GenerateShapeTables
                           ; overwrite entry, because we don't want to relocate multiple times
+00121e 401b: a9 ea                            lda   #NOP
+001220 401d: a2 14                            ldx   #$14
+001222 401f: 9d 00 40     @loop               sta   mainEntryPoint,x
+001225 4022: ca                               dex
+001226 4023: 10 fa                            bpl   @loop
                           ; initialize something
                           ; probably hires pointers
                           ; $1200 in $fc, $1300 in $fe
                           PixelLine           .var  $06    {addr/2}
                           Sprite              .var  $08    {addr/2}
                           PixelLineBaseL      .var  $fc    {addr/2}
                           PixelLineBaseH      .var  $fe    {addr/2}

+001228 4025: a9 12                            lda   #$12
+00122a 4027: 85 fd                            sta   PixelLineBaseL+1
+00122c 4029: a9 13                            lda   #$13
+00122e 402b: 85 ff                            sta   PixelLineBaseH+1
                           ; initialize hires
+001230 402d: ad 50 c0                         lda   TXTCLR
+001233 4030: ad 52 c0                         lda   MIXCLR
+001236 4033: ad 54 c0                         lda   TXTPAGE1
+001239 4036: ad 57 c0                         lda   HIRES
                           ; initialize other stuff
+00123c 4039: a9 00                            lda   #$00
+00123e 403b: 8d 07 14                         sta   Level
+001241 403e: 8d 0c 15                         sta   Score2
+001244 4041: 8d 32 14                         sta   $1432
+001247 4044: 8d 33 14                         sta   $1433
+00124a 4047: 8d 34 14                         sta   $1434
+00124d 404a: ad 10 0c                         lda   L0C10                                   ;$0c10
+001250 404d: 8d 0a 15                         sta   Score0
+001253 4050: ad 11 0c                         lda   L0C11                                   ;$0c11
+001256 4053: 8d 0b 15                         sta   Score1
+001259 4056: a9 01                            lda   #$01                                    ;default controller is keyboard
+00125b 4058: 8d 17 14                         sta   ControllerType
+00125e 405b: a9 06                            lda   #$06                                    ;NW: will be overwritten later
+001260 405d: 8d 09 15                         sta   Lives
                           ********************************************************************************
                           *                                                                              *
                           * startScreen                                                                  *
                           * * show "Atari presents:"                                                     *
                           * * show right stats                                                           *
                           * * show Robotron noise                                                        *
                           * (and probably (c) as well)                                                   *
                           *                                                                              *
                           * We jump here if no valid ControllerType selected                             *
                           *                                                                              *
                           * NW: attract mode/game mode outer loop                                        *
                           *                                                                              *
                           ********************************************************************************
+001263 4060: a2 3f        startScreen         ldx   #STACK_PTR
+001265 4062: 9a                               txs
+001266 4063: 20 04 45                         jsr   startAttractMode                        ;NW: attract mode
+001269 4066: 20 67 4b                         jsr   chooseControls                          ;NW: print select controls screen
+00126c 4069: ad 6a 0c                         lda   L0C6A                                   ;NW: (5), start w/ 5 lives
+00126f 406c: 8d 09 15                         sta   Lives
+001272 406f: a9 00                            lda   #$00
+001274 4071: 8d 07 14                         sta   Level
+001277 4074: 8d 0a 15                         sta   Score0
+00127a 4077: 8d 0b 15                         sta   Score1
+00127d 407a: 8d 0c 15                         sta   Score2
+001280 407d: ae 10 0c                         ldx   L0C10
+001283 4080: ca                               dex
+001284 4081: 8e 0d 15                         stx   $150d
+001287 4084: ae 11 0c                         ldx   L0C11
+00128a 4087: 8e 0e 15                         stx   $150e
                           ; main outer game loop
+00128d 408a: 20 2a 44     levelEntryPoint1    jsr   B442A
+001290 408d: 20 c0 43     LevelEntryPoint2    jsr   S43C0
                           ; main inner game loop
+001293 4090: a2 3f        LevelEntryPoint3    ldx   #STACK_PTR                              ;entry point after last level completed
+001295 4092: 9a                               txs                                           ;ASSUMPTION: resetting STACK_PTR cancels all dangling JSRs
+001296 4093: 20 6b 42                         jsr   checkLevelCompleted                     ;indicates still in level with CLC
+001299 4096: 90 14                            bcc   @stillInLevel
+00129b 4098: 20 4a 4d                         jsr   L4D4A                                   ;no, done with level
+00129e 409b: ee 07 14                         inc   Level                                   ;determine next level
+0012a1 409e: ad 07 14                         lda   Level
+0012a4 40a1: c9 64                            cmp   #$64                                    ;NW: Level 100
+0012a6 40a3: 90 e5                            bcc   levelEntryPoint1                        ;level < #$64?
+0012a8 40a5: a9 00                            lda   #$00                                    ;no, start over with level 0
+0012aa 40a7: 8d 07 14                         sta   Level
+0012ad 40aa: f0 de                            beq   levelEntryPoint1                        ;always branch

                           NOTE: ideas: "box jsr stretch"
                           * here: the consecutive JSRs until (and not including) the bcc
                           * assumption (from the disassembler tracing): the JSRs are executed
                           consecutively
                           => box should check this, probably by 
                           ** tracking the SP ("don't rts to outside the box")
                           ** checking for reentry inside the box ("don't jump into the box")

                           * memory layout, as text, or in Excel
                           * mark code areas which are executed together (using label crossings)
+0012af 40ac: 20 0e 43     @stillInLevel       jsr   S430E
+0012b2 40af: 20 10 41                         jsr   checkKbdAndBtn
+0012b5 40b2: 20 5b 42                         jsr   speaker_1411?
+0012b8 40b5: 20 10 41                         jsr   checkKbdAndBtn
+0012bb 40b8: 20 71 41                         jsr   checkJoystAndPdl
+0012be 40bb: 20 09 52                         jsr   L5209
+0012c1 40be: 20 1b 5a                         jsr   L5A1B
+0012c4 40c1: 20 06 52                         jsr   L5206
+0012c7 40c4: 20 03 52                         jsr   L5203
+0012ca 40c7: 90 0e                            bcc   @levelCompleted
+0012cc 40c9: 20 f1 4e                         jsr   xorScreen7x                             ;we died, but maybe more lives left
+0012cf 40cc: ce 09 15                         dec   Lives                                   ;one live less
+0012d2 40cf: d0 bc                            bne   LevelEntryPoint2                        ;more lives left?
+0012d4 40d1: 20 15 62                         jsr   PreRestart                              ;no, NW: go back to attract mode
+0012d7 40d4: 4c 60 40                         jmp   startScreen

+0012da 40d7: 20 1e 5a     @levelCompleted     jsr   L5A1E
+0012dd 40da: 20 10 41                         jsr   checkKbdAndBtn
+0012e0 40dd: 20 09 5a                         jsr   L5A09
+0012e3 40e0: 20 0c 5a                         jsr   L5A0C
+0012e6 40e3: 20 0f 5a                         jsr   L5A0F
+0012e9 40e6: 20 10 41                         jsr   checkKbdAndBtn
+0012ec 40e9: 20 03 62                         jsr   L6203
+0012ef 40ec: 20 06 62                         jsr   L6206
+0012f2 40ef: 20 09 62                         jsr   L6209
+0012f5 40f2: 20 10 41                         jsr   checkKbdAndBtn
+0012f8 40f5: 20 03 70                         jsr   L7003
+0012fb 40f8: 20 06 70                         jsr   L7006
+0012fe 40fb: 20 09 70                         jsr   L7009
+001301 40fe: 20 09 70                         jsr   L7009
+001304 4101: 20 10 41                         jsr   checkKbdAndBtn
+001307 4104: 20 03 69                         jsr   L6903
+00130a 4107: 20 06 69                         jsr   L6906
+00130d 410a: 20 09 69                         jsr   L6909
+001310 410d: 4c 90 40                         jmp   LevelEntryPoint3

                           ; check keyboard and button controls
+001313 4110: ad 17 14     checkKbdAndBtn      lda   ControllerType                          ;NW: keyboard controls?
+001316 4113: c9 01                            cmp   #$01
+001318 4115: d0 14                            bne   @notKeyboard
+00131a 4117: 20 e3 41                         jsr   readKbd                                 ;Controller is keyboard, NW: yes, get key or return if none pressed
+00131d 411a: b9 00 0a                         lda   kbdMovementDir,y                        ;NW: map key to movement direction
+001320 411d: 30 03                            bmi   B4122
+001322 411f: 8d 06 15                         sta   MovementDir
+001325 4122: b9 80 0a     B4122               lda   kbdShootingDir,y                        ;NW: map key to shooting direction
+001328 4125: 30 03                            bmi   @rts
+00132a 4127: 8d 16 14                         sta   ShootingDir
+00132d 412a: 60           @rts                rts

+00132e 412b: aa           @notKeyboard        tax                                           ;NW: no, joystick controls?
+00132f 412c: d0 40                            bne   @rts
+001331 412e: ad 62 c0                         lda   BUTN1                                   ;NW: yes, button 1 pressed?
+001334 4131: 10 1d                            bpl   B4150
+001336 4133: ad 35 14                         lda   $1435                                   ;NW: yes, rotate shooting direction [warum $1435?]
+001339 4136: 18                               clc
+00133a 4137: 6d 6b 0c                         adc   L0C6B                                   ;NW: =$0C
+00133d 413a: 8d 35 14                         sta   $1435
+001340 413d: 90 11                            bcc   B4150
+001342 413f: ae 36 14                         ldx   $1436
+001345 4142: bd 5e 0d                         lda   fireRotation,x                          ;NW: get next direction
+001348 4145: 69 00                            adc   #$00
+00134a 4147: 29 07                            and   #$07
+00134c 4149: aa                               tax
+00134d 414a: bd 1e 0d                         lda   fireDirection,x                         ;NW: translate to direction of shooting
+001350 414d: 8d 36 14                         sta   $1436
+001353 4150: a9 00        B4150               lda   #$00
+001355 4152: ac 61 c0                         ldy   BUTN0                                   ;NW: button 0 pressed?
+001358 4155: 10 11                            bpl   B4168
+00135a 4157: ad 36 14                         lda   $1436                                   ;NW: yes,
+00135d 415a: ae 31 14                         ldx   $1431
+001360 415d: 30 09                            bmi   B4168
+001362 415f: ae 06 15                         ldx   MovementDir
+001365 4162: f0 04                            beq   B4168
+001367 4164: 8e 36 14                         stx   $1436
+00136a 4167: 8a                               txa
+00136b 4168: 8d 16 14     B4168               sta   ShootingDir
+00136e 416b: 8c 31 14                         sty   $1431
+001371 416e: 4c 6e 4c     @rts                jmp   doSpeaker                               ;speaker tail call, NW: click the speaker if needed and return

                           ; check joystick and paddle controls
+001374 4171: ad 17 14     checkJoystAndPdl    lda   ControllerType                          ;NW: controls selectoin
+001377 4174: c9 03                            cmp   #$03                                    ;NW: joystick and keyboard controls?
+001379 4176: d0 3c                            bne   @notJoyAndKbd
+00137b 4178: 20 85 41                         jsr   joystickControls                        ;Controller is joystick & keyboard, NW: yes, check joystick
+00137e 417b: 20 e3 41                         jsr   readKbd                                 ;NW: get key or return if none pressed
+001381 417e: b9 00 0b                         lda   kbd2ShootingDir,y                       ;NW: map key to shooting direction
+001384 4181: 8d 16 14                         sta   ShootingDir
+001387 4184: 60                               rts

                           ; joystick controls (one paddle)
+001388 4185: a9 03        joystickControls    lda   #$03                                    ;NW: 1 paddle
+00138a 4187: ae 08 15                         ldx   UsedPaddle?                             ;NW: current paddle (alternates 0/1)
+00138d 418a: d0 02                            bne   B418E
+00138f 418c: 49 0f                            eor   #$0f
+001391 418e: 2d 06 15     B418E               and   MovementDir
+001394 4191: 8d 06 15                         sta   MovementDir
+001397 4194: 20 1e fb                         jsr   MON_PREAD                               ;NW: read paddle X
+00139a 4197: a2 00                            ldx   #$00
+00139c 4199: c0 c0                            cpy   #$c0
+00139e 419b: 90 01                            bcc   B419E
+0013a0 419d: e8                               inx
+0013a1 419e: c0 40        B419E               cpy   #$40
+0013a3 41a0: b0 01                            bcs   B41A3
+0013a5 41a2: ca                               dex
+0013a6 41a3: 8a           B41A3               txa
+0013a7 41a4: 29 03                            and   #$03
+0013a9 41a6: ae 08 15                         ldx   UsedPaddle?                             ;"NW: current paddle (alternates 0/1)" - - TODO: comment übertragen
+0013ac 41a9: f0 02                            beq   B41AD
+0013ae 41ab: 0a                               asl   A
+0013af 41ac: 0a                               asl   A
+0013b0 41ad: 0d 06 15     B41AD               ora   MovementDir
+0013b3 41b0: 8d 06 15                         sta   MovementDir
+0013b6 41b3: 60                               rts

                           ; paddle controls (one paddle)
+0013b7 41b4: c9 02        @notJoyAndKbd       cmp   #$02                                    ;NW: paddle controls? (one paddle)
+0013b9 41b6: d0 21                            bne   @notPaddles
+0013bb 41b8: ae 08 15                         ldx   UsedPaddle?                             ;Controller is paddles, NW: yes, paddles; current paddle (alternates 0/1)
+0013be 41bb: 20 1e fb                         jsr   MON_PREAD                               ;read paddle X (0-3) into Y, NW: read paddle X
+0013c1 41be: 98                               tya
+0013c2 41bf: 4a                               lsr   A                                       ;distinguish between left and right?
+0013c3 41c0: 4a                               lsr   A
+0013c4 41c1: 4a                               lsr   A
+0013c5 41c2: 4a                               lsr   A
+0013c6 41c3: 4a                               lsr   A
+0013c7 41c4: a8                               tay
+0013c8 41c5: b9 1e 0d                         lda   fireDirection,y                         ;NW: translate to direction of fire
+0013cb 41c8: ae 08 15                         ldx   UsedPaddle?
+0013ce 41cb: d0 05                            bne   B41D2                                   ;NW: paddle 0?
+0013d0 41cd: 8d 06 15                         sta   MovementDir                             ;NW: yes, update movement direction
+0013d3 41d0: f0 03                            beq   B41D5

+0013d5 41d2: 8d 16 14     B41D2               sta   ShootingDir                             ;NW: no, paddle 1, so update shooting direction
+0013d8 41d5: 20 e3 41     B41D5               jsr   readKbd                                 ;NW: get key or return if none pressed   <- TODO:
+0013db 41d8: 60                               rts

                           ; joystick controls?
+0013dc 41d9: aa           @notPaddles         tax                                           ;joystick controls?
+0013dd 41da: d0 06                            bne   @rts
+0013df 41dc: 20 85 41                         jsr   joystickControls                        ;NW: yes, check joystick controls
+0013e2 41df: 20 e3 41                         jsr   readKbd
+0013e5 41e2: 60           @rts                rts

                           ; readKbd
+0013e6 41e3: ad 00 c0     readKbd             lda   KBD
+0013e9 41e6: 30 03                            bmi   B41EB                                   ;key pressed?
+0013eb 41e8: 68           @plaPlaRts          pla                                           ;NW: no, return from parent subroutine
+0013ec 41e9: 68                               pla
+0013ed 41ea: 60                               rts

+0013ee 41eb: 20 42 42     B41EB               jsr   waitForKey                              ;yes, key was pressed => waitForKey doesn't have to wait, will return immediately, NW: yes, get key with high bit cleared
+0013f1 41ee: c0 1b                            cpy   #ASCII_ESCAPE
+0013f3 41f0: d0 07                            bne   @notEscape
                           ; escape? (pause)
+0013f5 41f2: ad 00 c0     @peekKBD            lda   KBD                                     ;ESC in the game freezes the screen until any key is pressed
+0013f8 41f5: 10 fb                            bpl   @peekKBD                                ;NW: loop till key pressed
+0013fa 41f7: 30 ef                            bmi   @plaPlaRts                              ;NW: then return from parent subroutine

                           ; Ctrl-S? (toggle sound)
+0013fc 41f9: c0 13        @notEscape          cpy   #$13                                    ;key #$13 = Ctrl-S
+0013fe 41fb: d0 0a                            bne   @notCtrlS
+001400 41fd: ad 6e 4c                         lda   doSpeaker                               ;yes, toggle sound
+001403 4200: 49 c5                            eor   #$c5
+001405 4202: 8d 6e 4c                         sta   doSpeaker
+001408 4205: d0 e1                            bne   @plaPlaRts
                           ; Ctrl-R? (select level)
+00140a 4207: c0 12        @notCtrlS           cpy   #$12                                    ;keys #$12 = Ctrl-R
+00140c 4209: d0 2b                            bne   @notCtrlR
+00140e 420b: 20 4e 42                         jsr   waitForKey2                             ;NW: yes, wait for first keypress
+001411 420e: b0 d8                            bcs   @plaPlaRts                              ;NW: digit?
+001413 4210: 85 07                            sta   PixelLine+1                             ;NW: yes,
+001415 4212: a2 0a                            ldx   #$0a
+001417 4214: 20 4f 4c                         jsr   multiplyAX
+00141a 4217: 86 06                            stx   PixelLine
+00141c 4219: 20 4e 42                         jsr   waitForKey2                             ;NW: wait for second keypress
+00141f 421c: d0 04                            bne   B4222
+001421 421e: a5 07                            lda   PixelLine+1
+001423 4220: 10 05                            bpl   B4227
+001425 4222: b0 c4        B4222               bcs   @plaPlaRts
+001427 4224: 18                               clc
+001428 4225: 65 06                            adc   PixelLine
+00142a 4227: 38           B4227               sec
+00142b 4228: e9 01                            sbc   #$01
+00142d 422a: 90 bc                            bcc   @plaPlaRts
+00142f 422c: 8d 07 14                         sta   Level
+001432 422f: 68                               pla
+001433 4230: 68                               pla
+001434 4231: 68                               pla
+001435 4232: 68                               pla
+001436 4233: 4c 8a 40                         jmp   levelEntryPoint1                        ;levelEntryPoint1 resets pointer, so why 4x PLA?

                           ; Ctrl-Q? (quit game)
+001439 4236: c9 11        @notCtrlR           cmp   #$11                                    ;; key #$11 = Ctrl-Q
+00143b 4238: d0 07                            bne   @rts
+00143d 423a: 68                               pla                                           ;NW: yes, quit game, go to attract mode
+00143e 423b: 68                               pla
+00143f 423c: 68                               pla
+001440 423d: 68                               pla
+001441 423e: 4c 60 40                         jmp   startScreen                             ;startScreen resets pointer, so why 4x PLA?

+001444 4241: 60           @rts                rts

                           ; NW: wait for keypress and return it (with high bit off)
+001445 4242: ad 00 c0     waitForKey          lda   KBD                                     ;$C000 is tested repeatedly until presence of the sign
+001448 4245: 10 fb                            bpl   waitForKey
+00144a 4247: 8d 10 c0                         sta   KBDSTRB                                 ;remove info that key was pressed
+00144d 424a: 29 7f                            and   #$7f                                    ;Apple II ASCII has high bit set, remove it
+00144f 424c: a8                               tay                                           ;return key in Y
+001450 424d: 60                               rts

                           ; NW: wait for keypress, check for digits
+001451 424e: 20 42 42     waitForKey2         jsr   waitForKey
+001454 4251: c9 0d                            cmp   #$0d                                    ;return?
+001456 4253: f0 05                            beq   @rts
+001458 4255: 38                               sec                                           ;NW: no, subtract #$30
+001459 4256: e9 30                            sbc   #$30
+00145b 4258: c9 0a                            cmp   #$0a                                    ;NW: C is clear if [TODO: ?]
+00145d 425a: 60           @rts                rts

                           NOTE: This is a nice test routine to check speaker action.
                           install guard on $1411 (assumption: #0)
                           check how the speaker changes pith if we change the #$40
+00145e 425b: ae 11 14     speaker_1411?       ldx   $1411                                   ;assumption: $1411 = #0
+001461 425e: e8                               inx
+001462 425f: a0 40        @loopOuter          ldy   #$40
+001464 4261: 88           @loopInner          dey
+001465 4262: d0 fd                            bne   @loopInner
+001467 4264: 20 6e 4c                         jsr   doSpeaker
+00146a 4267: ca                               dex
+00146b 4268: d0 f5                            bne   @loopOuter
+00146d 426a: 60                               rts

+00146e 426b: ce 04 14     checkLevelCompleted dec   $1404
+001471 426e: 30 02                            bmi   B4272
+001473 4270: 18                               clc                                           ;CLC signals still in level
+001474 4271: 60                               rts

+001475 4272: a9 0a        B4272               lda   #$0a
+001477 4274: 8d 04 14                         sta   $1404
+00147a 4277: ad 02 14                         lda   $1402
+00147d 427a: ae 03 14                         ldx   $1403
+001480 427d: 20 00 4c                         jsr   divideAX
+001483 4280: 0a                               asl   A
+001484 4281: 85 00                            sta   $00
+001486 4283: ad 0e 14                         lda   $140e
+001489 4286: 6d 0f 14                         adc   $140f
+00148c 4289: 6d 1b 14                         adc   $141b
+00148f 428c: 6d 1d 14                         adc   $141d
+001492 428f: 0a                               asl   A
+001493 4290: 65 00                            adc   $00
+001495 4292: 85 00                            sta   $00
+001497 4294: ad 09 14                         lda   $1409
+00149a 4297: 6d 10 14                         adc   $1410
+00149d 429a: 6d 18 14                         adc   $1418
+0014a0 429d: 6d 27 14                         adc   $1427
+0014a3 42a0: 6d 28 14                         adc   $1428
+0014a6 42a3: 6d 29 14                         adc   $1429
+0014a9 42a6: 65 00                            adc   $00
+0014ab 42a8: 85 00                            sta   $00
+0014ad 42aa: ad 0a 14                         lda   $140a
+0014b0 42ad: 4a                               lsr   A
+0014b1 42ae: 18                               clc
+0014b2 42af: 65 00                            adc   $00
+0014b4 42b1: ae 1c 14                         ldx   $141c
+0014b7 42b4: f0 03                            beq   B42B9
+0014b9 42b6: 6d 18 14                         adc   $1418
+0014bc 42b9: 85 00        B42B9               sta   $00
+0014be 42bb: a5 00                            lda   $00
+0014c0 42bd: ae 57 0c                         ldx   L0C57
+0014c3 42c0: 20 4f 4c                         jsr   multiplyAX
+0014c6 42c3: 86 00                            stx   $00
+0014c8 42c5: ad 01 0c                         lda   L0C01
+0014cb 42c8: 38                               sec
+0014cc 42c9: e5 00                            sbc   $00
+0014ce 42cb: b0 02                            bcs   B42CF
+0014d0 42cd: a9 00                            lda   #$00
+0014d2 42cf: 8d 11 14     B42CF               sta   $1411
+0014d5 42d2: ad 03 14                         lda   $1403
+0014d8 42d5: cd 0d 0c                         cmp   L0C0D
+0014db 42d8: 90 03                            bcc   B42DD
+0014dd 42da: ce 03 14                         dec   $1403
+0014e0 42dd: ad 14 0c     B42DD               lda   L0C14
+0014e3 42e0: ae 0f 14                         ldx   $140f
+0014e6 42e3: e8                               inx
+0014e7 42e4: 20 00 4c                         jsr   divideAX
+0014ea 42e7: 8d 25 14                         sta   $1425
+0014ed 42ea: ad 55 0c                         lda   L0C55
+0014f0 42ed: ae 28 14                         ldx   $1428
+0014f3 42f0: e8                               inx
+0014f4 42f1: 20 00 4c                         jsr   divideAX
+0014f7 42f4: 8d 2b 14                         sta   $142b
+0014fa 42f7: 18                               clc
+0014fb 42f8: ad 02 14                         lda   $1402
+0014fe 42fb: 0d 0f 14                         ora   $140f
+001501 42fe: 0d 0e 14                         ora   $140e
+001504 4301: 0d 18 14                         ora   $1418
+001507 4304: 0d 27 14                         ora   $1427
+00150a 4307: 0d 28 14                         ora   $1428
+00150d 430a: d0 01                            bne   @rts
+00150f 430c: 38                               sec
+001510 430d: 60           @rts                rts

+001511 430e: a2 00        S430E               ldx   #$00
+001513 4310: ad 06 14                         lda   Level-1
+001516 4313: cd 23 14                         cmp   $1423
+001519 4316: 90 07                            bcc   B431F
+00151b 4318: ed 22 14                         sbc   $1422
+00151e 431b: 8d 06 14                         sta   Level-1
+001521 431e: aa                               tax
+001522 431f: ad 12 14     B431F               lda   $1412
+001525 4322: 30 06                            bmi   B432A
+001527 4324: ce 12 14                         dec   $1412
+00152a 4327: ae 13 14                         ldx   $1413
+00152d 432a: ad 14 14     B432A               lda   $1414
+001530 432d: 30 0d                            bmi   B433C
+001532 432f: ce 14 14                         dec   $1414
+001535 4332: ad 15 14                         lda   ShootingDir-1
+001538 4335: 6d 21 0c                         adc   L0C21
+00153b 4338: 8d 15 14                         sta   ShootingDir-1
+00153e 433b: aa                               tax
+00153f 433c: ad 2e 14     B433C               lda   $142e
+001542 433f: 30 1a                            bmi   B435B_
+001544 4341: ad 2f 14     B434B               lda   $142f
+001547 4344: aa                               tax
+001548 4345: ed 65 0c                         sbc   L0C65
+00154b 4348: 8d 2f 14                         sta   $142f
+00154e 434b: cd 66 0c                         cmp   L0C66
+001551 434e: b0 0b                            bcs   B435B_
+001553 4350: ad 64 0c                         lda   L0C64
+001556 4353: 8d 2f 14                         sta   $142f
+001559 4356: ce 2e 14                         dec   $142e
+00155c 4359: 10 e6                            bpl   B434B
+00155e 435b: ad 1e 14     B435B_              lda   $141e
+001561 435e: f0 1e                            beq   B437E_
+001563 4360: ad 1f 14                         lda   $141f
+001566 4363: ed 30 0c                         sbc   L0C30
+001569 4366: 8d 1f 14                         sta   $141f
+00156c 4369: cd 3f 0c                         cmp   L0C3F
+00156f 436c: b0 0f                            bcs   B437D
+001571 436e: ce 1e 14                         dec   $141e
+001574 4371: f0 0b                            beq   B437E_
+001576 4373: ad 31 0c                         lda   L0C31
+001579 4376: 38                               sec
+00157a 4377: ed 2c 0c                         sbc   L0C2C
+00157d 437a: 8d 1f 14                         sta   $141f
+001580 437d: aa           B437D               tax
+001581 437e: ad 19 14     B437E_              lda   $1419
+001584 4381: f0 0d                            beq   B4390
+001586 4383: ce 19 14                         dec   $1419
+001589 4386: ad 1a 14                         lda   $141a
+00158c 4389: 4d 27 0c                         eor   L0C27
+00158f 438c: 8d 1a 14                         sta   $141a
+001592 438f: aa                               tax
+001593 4390: ad 0b 14     B4390               lda   $140b
+001596 4393: 10 06                            bpl   B439B
+001598 4395: 69 06                            adc   #$06
+00159a 4397: 8d 0b 14                         sta   $140b
+00159d 439a: aa                               tax
+00159e 439b: ad 0c 14     B439B               lda   $140c
+0015a1 439e: c9 c0                            cmp   #$c0
+0015a3 43a0: 90 06                            bcc   B43A8
+0015a5 43a2: e9 02                            sbc   #$02
+0015a7 43a4: 8d 0c 14                         sta   $140c
+0015aa 43a7: aa                               tax
+0015ab 43a8: ad 1c 14     B43A8               lda   $141c
+0015ae 43ab: f0 03                            beq   B43B0
+0015b0 43ad: 49 ff                            eor   #$ff
+0015b2 43af: aa                               tax
+0015b3 43b0: ac 30 14     B43B0               ldy   $1430
+0015b6 43b3: 30 06                            bmi   B43BB
+0015b8 43b5: be 46 0d                         ldx   L0D46,y
+0015bb 43b8: ce 30 14                         dec   $1430
+0015be 43bb: 86 ca        B43BB               stx   $ca
+0015c0 43bd: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+0015c3 43c0: 20 42 4f     S43C0               jsr   showRightStats
+0015c6 43c3: a2 00                            ldx   #$00
+0015c8 43c5: bc 80 0c     B43C5               ldy   L0C80,x
+0015cb 43c8: 30 1b                            bmi   B43EB
+0015cd 43ca: e8                               inx
+0015ce 43cb: bd 80 0c     B43CB               lda   L0C80,x
+0015d1 43ce: e8                               inx
+0015d2 43cf: c9 80                            cmp   #$80
+0015d4 43d1: b0 f2                            bcs   B43C5
+0015d6 43d3: e9 00                            sbc   #$00
+0015d8 43d5: cd 07 14                         cmp   Level
+0015db 43d8: f0 02                            beq   B43DC
+0015dd 43da: b0 06                            bcs   B43E2
+0015df 43dc: bd 80 0c     B43DC               lda   L0C80,x
+0015e2 43df: 99 00 0c                         sta   L0C00,y
+0015e5 43e2: e8           B43E2               inx
+0015e6 43e3: 10 e6                            bpl   B43CB
+0015e8 43e5: a9 00        B43EB               lda   #$00
+0015ea 43e7: 8d 00 14                         sta   $1400
+0015ed 43ea: 85 ca                            sta   $ca
+0015ef 43ec: 8d 06 14                         sta   Level-1
+0015f2 43ef: 8d 01 14                         sta   $1401
+0015f5 43f2: 8d 16 14                         sta   ShootingDir
+0015f8 43f5: 8d 04 14                         sta   $1404
+0015fb 43f8: 8d 35 14                         sta   $1435
+0015fe 43fb: a9 0c                            lda   #$0c
+001600 43fd: 8d 36 14                         sta   $1436
+001603 4400: a9 ff                            lda   #$ff
+001605 4402: 8d 12 14                         sta   $1412
+001608 4405: 8d 30 14                         sta   $1430
+00160b 4408: 20 00 52                         jsr   L5200
+00160e 440b: 20 00 5a                         jsr   L5A00
+001611 440e: 20 00 70                         jsr   L7000
+001614 4411: ad 02 0c                         lda   L0C02
+001617 4414: cd 21 14                         cmp   $1421
+00161a 4417: 90 05                            bcc   B441E
+00161c 4419: 69 00                            adc   #$00
+00161e 441b: 8d 21 14                         sta   $1421
+001621 441e: 20 03 5a     B441E               jsr   L5A03
+001624 4421: 20 06 5a                         jsr   L5A06
+001627 4424: 20 00 62                         jsr   L6200
+00162a 4427: 4c 00 69                         jmp   L6900

+00162d 442a: ac 07 14     B442A               ldy   Level
+001630 442d: b9 00 0e                         lda   L0E00,y
+001633 4430: 8d 02 14                         sta   $1402
+001636 4433: b9 80 0e                         lda   L0E80,y
+001639 4436: 8d 09 14                         sta   $1409
+00163c 4439: b9 80 0f                         lda   L0F80,y
+00163f 443c: 85 01                            sta   $01
+001641 443e: b9 00 10                         lda   L1000,y
+001644 4441: 85 02                            sta   $02
+001646 4443: be 00 0f                         ldx   L0F00,y
+001649 4446: a0 00                            ldy   #$00
+00164b 4448: 98                               tya
+00164c 4449: ca           B4449               dex
+00164d 444a: 30 06                            bmi   B4452
+00164f 444c: 99 90 19                         sta   $1990,y
+001652 444f: c8                               iny
+001653 4450: 10 f7                            bpl   B4449
+001655 4452: a6 01        B4452               ldx   $01
+001657 4454: a9 01                            lda   #$01
+001659 4456: ca           B4456               dex
+00165a 4457: 30 06                            bmi   B445F
+00165c 4459: 99 90 19                         sta   $1990,y
+00165f 445c: c8                               iny
+001660 445d: 10 f7                            bpl   B4456
+001662 445f: a6 02        B445F               ldx   $02
+001664 4461: a9 02                            lda   #$02
+001666 4463: ca           B4463               dex
+001667 4464: 30 06                            bmi   B446C
+001669 4466: 99 90 19                         sta   $1990,y
+00166c 4469: c8                               iny
+00166d 446a: 10 f7                            bpl   B4463
+00166f 446c: 8c 0a 14     B446C               sty   $140a
+001672 446f: ac 07 14                         ldy   Level
+001675 4472: b9 80 10                         lda   L1080,y
+001678 4475: 8d 0f 14                         sta   $140f
+00167b 4478: a9 00                            lda   #$00
+00167d 447a: 8d 0e 14                         sta   $140e
+001680 447d: b9 00 11                         lda   L1100,y
+001683 4480: 8d 18 14                         sta   $1418
+001686 4483: b9 80 11                         lda   L1180,y
+001689 4486: 8d 27 14                         sta   $1427
+00168c 4489: a2 00                            ldx   #$00
+00168e 448b: ad 51 0c                         lda   L0C51
+001691 448e: 9d 40 1d     B448E               sta   $1d40,x
+001694 4491: e8                               inx
+001695 4492: ec 27 14                         cpx   $1427
+001698 4495: 90 f7                            bcc   B448E
+00169a 4497: a9 00                            lda   #$00
+00169c 4499: 8d 28 14                         sta   $1428
+00169f 449c: 60                               rts

                           NOTE: continue here w/ L -> B, S, J
                           ; copy X pages from page A to page Y
                           ; source: $06, $07 <- A
                           ; dest:   $08, $09 <- Y
+0016a0 449d: 85 07        copyPagesAtoY       sta   PixelLine+1                             ;$07, TODO: hat nichts mit "PixelLine" oder "Sprite" zu tun
+0016a2 449f: 84 09                            sty   Sprite+1                                ;$09
+0016a4 44a1: a0 00                            ldy   #$00
+0016a6 44a3: 84 06                            sty   PixelLine
+0016a8 44a5: 84 08                            sty   Sprite
+0016aa 44a7: 68                               pla                                           ;save return address from to $00 (if overwritten)
+0016ab 44a8: 85 01                            sta   $01
+0016ad 44aa: 68                               pla
+0016ae 44ab: 85 00                            sta   $00
+0016b0 44ad: b1 06        @loop               lda   (PixelLine),y
+0016b2 44af: 91 08                            sta   (Sprite),y
+0016b4 44b1: c8                               iny
+0016b5 44b2: d0 f9                            bne   @loop
+0016b7 44b4: e6 07                            inc   PixelLine+1                             ;next source page
+0016b9 44b6: e6 09                            inc   Sprite+1                                ;next dest page
+0016bb 44b8: ca                               dex                                           ;NW: number of pages to move
+0016bc 44b9: d0 f2                            bne   @loop
+0016be 44bb: a5 00                            lda   $00                                     ;restore return address to stack
+0016c0 44bd: 48                               pha
+0016c1 44be: a5 01                            lda   $01
+0016c3 44c0: 48                               pha
+0016c4 44c1: 60                               rts

+0016c5 44c2: 20 6b 42     displayYou          jsr   checkLevelCompleted
+0016c8 44c5: 20 5b 42                         jsr   speaker_1411?
+0016cb 44c8: 20 09 52                         jsr   L5209
+0016ce 44cb: 20 1b 5a                         jsr   L5A1B
+0016d1 44ce: 20 06 52                         jsr   L5206
+0016d4 44d1: 20 03 52                         jsr   L5203
+0016d7 44d4: 20 1e 5a                         jsr   L5A1E
+0016da 44d7: 20 09 5a                         jsr   L5A09
+0016dd 44da: 20 0c 5a                         jsr   L5A0C
+0016e0 44dd: 20 0f 5a                         jsr   L5A0F
+0016e3 44e0: 20 03 62                         jsr   L6203
+0016e6 44e3: 20 06 62                         jsr   L6206
+0016e9 44e6: 20 09 62                         jsr   L6209
+0016ec 44e9: 20 03 70                         jsr   L7003
+0016ef 44ec: 20 06 70                         jsr   L7006
+0016f2 44ef: 20 09 70                         jsr   L7009
+0016f5 44f2: 20 09 70                         jsr   L7009
+0016f8 44f5: 20 03 69                         jsr   L6903
+0016fb 44f8: 20 06 69                         jsr   L6906
+0016fe 44fb: 20 09 69                         jsr   L6909
+001701 44fe: 20 52 01                         jsr   S0152
+001704 4501: 4c 3d 45                         jmp   peekKey                                 ;peekKey tail call

                           ********************************************************************************
                           *                                                                              *
                           * Intro                                                                        *
                           *                                                                              *
                           * NW: attract mode                                                             *
                           *                                                                              *
                           ********************************************************************************
+001707 4504: 8d 10 c0     startAttractMode    sta   KBDSTRB
+00170a 4507: ad 6e 4c                         lda   doSpeaker                               ;save first byte of doSpeaker (lda?)
+00170d 450a: 85 2f                            sta   $2f                                     ;why save the byte instead of just assuming LDA? (see STX below)
+00170f 450c: a9 60                            lda   #$60
+001711 450e: 8d 6e 4c                         sta   doSpeaker                               ;disable doSpeaker by putting an rts as first byte
+001714 4511: 8d d0 4d                         sta   detectCollision                         ;disable collision detection
+001717 4514: 20 22 45                         jsr   attractModeLoop
+00171a 4517: a5 2f                            lda   $2f                                     ;restore doSpeaker functionality
+00171c 4519: 8d 6e 4c                         sta   doSpeaker
+00171f 451c: a9 86                            lda   #$86                                    ;restore STX
+001721 451e: 8d d0 4d                         sta   detectCollision
+001724 4521: 60                               rts

                           ********************************************************************************
                           *                                                                              *
                           * NW: attract mode loop                                                        *
                           *                                                                              *
                           ********************************************************************************
+001725 4522: 20 5e 45     attractModeLoop     jsr   runIntro
+001728 4525: 20 2a 46                         jsr   introStory1
+00172b 4528: 20 28 47                         jsr   introStory2
+00172e 452b: 20 7f 46                         jsr   introStory3
+001731 452e: 20 bc 47                         jsr   introStory4
+001734 4531: 20 88 48                         jsr   introStory5
+001737 4534: 20 52 4a                         jsr   introStory6
+00173a 4537: 20 3e 48     introJustControls   jsr   introStory7                             ;explains controls
+00173d 453a: 4c 22 45                         jmp   attractModeLoop

                           ; NW: attract mode check for keypress
+001740 453d: ac 00 c0     peekKey             ldy   KBD                                     ;high bit set if key pressed (negative), NW: key pressed?
+001743 4540: 10 1b                            bpl   @rts                                    ;if not pressed (positive) then exit
+001745 4542: 8c 10 c0                         sty   KBDSTRB                                 ;strobe, i.e. clear buffer
+001748 4545: 68                               pla                                           ;throw away return address, NW: yes, prepare to exit parent routine
+001749 4546: 68                               pla
+00174a 4547: c0 8d                            cpy   #ASCII2_RETURN                          ;return?
+00174c 4549: d0 01                            bne   @notReturn
+00174e 454b: 60                               rts                                           ;show intro cutscreens? NW: yes, RETURN, skip to next intro segment

+00174f 454c: 68           @notReturn          pla
+001750 454d: 68                               pla
+001751 454e: c0 a0                            cpy   #ASCII2_SPACE                           ;space?
+001753 4550: d0 01                            bne   @notSpace
+001755 4552: 60                               rts                                           ;show controller selection? NW: yes, return and select controls

+001756 4553: c0 9b        @notSpace           cpy   #ASCII2_ESCAPE                          ;escape?
+001758 4555: d0 03                            bne   @notEscape
+00175a 4557: 4c 37 45                         jmp   introJustControls                       ;show help screen, or restart intro, NW: yes, skip to intro 7 - controls

+00175d 455a: 4c 22 45     @notEscape          jmp   attractModeLoop

+001760 455d: 60           @rts                rts

+001761 455e: 20 42 4f     runIntro            jsr   showRightStats
+001764 4561: ad 32 14                         lda   $1432
+001767 4564: 0d 33 14                         ora   $1433
+00176a 4567: f0 03                            beq   atariPresents
+00176c 4569: 20 18 62                         jsr   L6218
+00176f 456c: 20 b8 51     atariPresents       jsr   showText
+001772 456f: 0d                               .dd1  $0d
+001773 4570: 0c                               .dd1  12
+001774 4571: 12                               .dd1  18
+001775 4572: 41 54 41 52+                     .str  “ATARI PRESENTS:”
+001784 4581: 00                               .dd1  $00

+001785 4582: a9 03        doneAtari           lda   #$03
+001787 4584: 8d 5a 0c                         sta   L0C5A
+00178a 4587: a9 28                            lda   #$28
+00178c 4589: 8d 5b 0c                         sta   L0C5B
+00178f 458c: a2 00                            ldx   #$00
+001791 458e: 20 81 50                         jsr   initRoboNoise                           ;NW: set up E6-E9 [TODO: ?]
+001794 4591: a9 ff                            lda   #$ff
+001796 4593: 85 0a                            sta   $0a
+001798 4595: 20 c5 50     roboNoises          jsr   roboNoise                               ;NW: animate Robotron logo fade-in
+00179b 4598: 20 3d 45                         jsr   peekKey
+00179e 459b: a5 0a                            lda   $0a
+0017a0 459d: f0 0d                            beq   postRobotron
+0017a2 459f: 38                               sec
+0017a3 45a0: e9 06                            sbc   #$06
+0017a5 45a2: 85 0a                            sta   $0a
+0017a7 45a4: b0 ef                            bcs   roboNoises
+0017a9 45a6: a9 00                            lda   #$00
+0017ab 45a8: 85 0a                            sta   $0a
+0017ad 45aa: f0 e9                            beq   roboNoises

                           ; NW: after Robotron logo fade-in
+0017af 45ac: a9 0f        postRobotron        lda   #$0f
+0017b1 45ae: 8d 5a 0c                         sta   L0C5A
+0017b4 45b1: a9 60                            lda   #$60
+0017b6 45b3: 8d 5b 0c                         sta   L0C5B
+0017b9 45b6: a2 01                            ldx   #$01
+0017bb 45b8: 20 81 50                         jsr   initRoboNoise
+0017be 45bb: a9 ff                            lda   #$ff
+0017c0 45bd: a0 00                            ldy   #$00
+0017c2 45bf: 99 00 07     L45BF               sta   $0700,y
+0017c5 45c2: c8                               iny
+0017c6 45c3: d0 fa                            bne   L45BF
+0017c8 45c5: 20 ca 50                         jsr   L50CA
+0017cb 45c8: a9 03                            lda   #$03
+0017cd 45ca: 8d 5a 0c                         sta   L0C5A
+0017d0 45cd: a9 28                            lda   #$28
+0017d2 45cf: 8d 5b 0c                         sta   L0C5B
+0017d5 45d2: a2 00                            ldx   #$00
+0017d7 45d4: 20 81 50                         jsr   initRoboNoise
+0017da 45d7: 20 55 01                         jsr   doShowWilliams
+0017dd 45da: a2 05                            ldx   #$05
+0017df 45dc: a9 00        L45DC               lda   #$00
+0017e1 45de: 20 a8 fc                         jsr   MON_WAIT
+0017e4 45e1: ca                               dex
+0017e5 45e2: d0 f8                            bne   L45DC
+0017e7 45e4: a9 80                            lda   #$80
+0017e9 45e6: 85 fa                            sta   $fa
+0017eb 45e8: a9 00                            lda   #$00
+0017ed 45ea: 85 0a                            sta   $0a
                           ; 
                           ; NW: loop to flash Robotron logo
+0017ef 45ec: a6 0a        loopRobotronFlash   ldx   $0a
+0017f1 45ee: bd 1e 46                         lda   L461E,x                                 ;NW: colour pairs for Robotron logo flash routine
+0017f4 45f1: 85 00                            sta   $00
+0017f6 45f3: bc 1f 46                         ldy   L461E+1,x
+0017f9 45f6: a2 00                            ldx   #$00
+0017fb 45f8: a5 00        L45F8               lda   $00
+0017fd 45fa: 9d 00 07                         sta   $0700,x
+001800 45fd: 98                               tya
+001801 45fe: 9d 01 07                         sta   $0701,x
+001804 4601: e8                               inx
+001805 4602: e8                               inx
+001806 4603: d0 f3                            bne   L45F8
+001808 4605: 20 ca 50                         jsr   L50CA
+00180b 4608: e6 0a                            inc   $0a
+00180d 460a: e6 0a                            inc   $0a
+00180f 460c: a5 0a                            lda   $0a
+001811 460e: c9 0c                            cmp   #$0c
+001813 4610: d0 04                            bne   L4616
+001815 4612: a9 00                            lda   #$00
+001817 4614: 85 0a                            sta   $0a
+001819 4616: 20 3d 45     L4616               jsr   peekKey
+00181c 4619: c6 fa                            dec   $fa
+00181e 461b: d0 cf                            bne   loopRobotronFlash
+001820 461d: 60                               rts                                           ;NW: return after flashing Robotron logo

+001821 461e: 55 2a 2a 55+ L461E               .bulk 552a2a557f7fd5aaaad5ffff                ;NW: colour pairs for Robotron logo flash routine

                           ********************************************************************************
                           * NW: intro 1 - first text of Robotron story                                   *
                           ********************************************************************************
+00182d 462a: 20 66 46     introStory1         jsr   showRobotron2084
+001830 462d: 20 40 01                         jsr   storyPart1_jmp
+001833 4630: 20 6b 42     @loop               jsr   checkLevelCompleted
+001836 4633: 20 5b 42                         jsr   speaker_1411?
+001839 4636: 20 3d 45                         jsr   peekKey
+00183c 4639: 20 52 01                         jsr   S0152
+00183f 463c: a0 00                            ldy   #$00
+001841 463e: b1 28                            lda   (MON_BASL),y
+001843 4640: d0 ee                            bne   @loop
+001845 4642: 60                               rts

                           NOTE: mark implicit target labels with leading B, S, J
                           ; ==========
+001846 4643: a9 00        S4643               lda   #$00
+001848 4645: 8d 02 14                         sta   $1402
+00184b 4648: 8d 09 14                         sta   $1409
+00184e 464b: 8d 0a 14                         sta   $140a
+001851 464e: 8d 0e 14                         sta   $140e
+001854 4651: 8d 0f 14                         sta   $140f
+001857 4654: 8d 18 14                         sta   $1418
+00185a 4657: 8d 27 14                         sta   $1427
+00185d 465a: 8d 28 14                         sta   $1428
+001860 465d: 20 c0 43                         jsr   S43C0
+001863 4660: a9 00                            lda   #$00
+001865 4662: 8d 21 14                         sta   $1421
+001868 4665: 60                               rts

+001869 4666: 20 43 46     showRobotron2084    jsr   S4643
+00186c 4669: 20 b8 51                         jsr   showText
+00186f 466c: 0d                               .dd1  $0d
+001870 466d: 0d                               .dd1  13
+001871 466e: 00                               .dd1  0
+001872 466f: 52 4f 42 4f+                     .str  “ROBOTRON: 2084”
+001880 467d: 00                               .dd1  $00

+001881 467e: 60                               rts

                           ********************************************************************************
                           * NW: intro 3 - GRUNTS                                                         *
                           ********************************************************************************
+001882 467f: 20 66 46     introStory3         jsr   showRobotron2084
+001885 4682: 20 43 01                         jsr   storyPart3_jmp
+001888 4685: a0 90                            ldy   #$90
+00188a 4687: a2 06                            ldx   #$06
+00188c 4689: 20 31 48                         jsr   save_1500_1503
+00188f 468c: a0 14                            ldy   #$14
+001891 468e: 8c 02 14                         sty   $1402
+001894 4691: 8c 08 14                         sty   $1408
+001897 4694: ad 0c 0c                         lda   L0C0C
+00189a 4697: 8d 03 14                         sta   $1403
+00189d 469a: 88           L469A               dey
+00189e 469b: 30 28                            bmi   L46C5
+0018a0 469d: a9 56                            lda   #$56
+0018a2 469f: 20 4b 4c                         jsr   multiplyRndX
+0018a5 46a2: 69 60                            adc   #$60
+0018a7 46a4: 99 f0 15                         sta   $15f0,y
+0018aa 46a7: a9 10                            lda   #$10
+0018ac 46a9: 20 4b 4c                         jsr   multiplyRndX
+0018af 46ac: 18                               clc
+0018b0 46ad: 69 e8                            adc   #$e8
+0018b2 46af: 29 fe                            and   #$fe
+0018b4 46b1: 99 70 15                         sta   $1570,y
+0018b7 46b4: 98                               tya
+0018b8 46b5: a2 08                            ldx   #$08
+0018ba 46b7: 20 4f 4c                         jsr   multiplyAX
+0018bd 46ba: 8a                               txa
+0018be 46bb: 99 f0 16                         sta   $16f0,y
+0018c1 46be: a9 00                            lda   #$00
+0018c3 46c0: 99 70 16                         sta   $1670,y
+0018c6 46c3: f0 d5                            beq   L469A

+0018c8 46c5: a2 dc        L46C5               ldx   #$dc
+0018ca 46c7: a9 46                            lda   #$46
+0018cc 46c9: 20 24 48                         jsr   init_stash_FA_FB
+0018cf 46cc: 20 06 47     L46CC               jsr   saveDirections
+0018d2 46cf: 20 c2 44                         jsr   displayYou
+0018d5 46d2: a9 68                            lda   #$68
+0018d7 46d4: a2 c0                            ldx   #$c0
+0018d9 46d6: 20 e9 46                         jsr   L46E9
+0018dc 46d9: 4c cc 46                         jmp   L46CC

+0018df 46dc: 38 01 30 00+                     .bulk 38013000348120010c80100400

+0018ec 46e9: 85 06        L46E9               sta   PixelLine
+0018ee 46eb: 86 07                            stx   PixelLine+1
+0018f0 46ed: ac 05 14                         ldy   $1405
+0018f3 46f0: 88           L46F0               dey
+0018f4 46f1: 30 12                            bmi   L4705
+0018f6 46f3: b9 70 17                         lda   $1770,y
+0018f9 46f6: c5 06                            cmp   PixelLine
+0018fb 46f8: 90 04                            bcc   L46FE
+0018fd 46fa: c5 07                            cmp   PixelLine+1
+0018ff 46fc: 90 f2                            bcc   L46F0
+001901 46fe: a9 01        L46FE               lda   #$01
+001903 4700: 99 b0 18                         sta   $18b0,y
+001906 4703: 10 eb                            bpl   L46F0

+001908 4705: 60           L4705               rts

                           ; ==========
                           _stashIntroStoryPtr .var  $22    {addr/2}
                           __FA                .var  $fa    {addr/1}
                           _stashOffs          .var  $fb    {addr/1}

+001909 4706: c6 fa        saveDirections      dec   __FA                                    ;__FA stores something between invocations of saveDirections
+00190b 4708: d0 1d                            bne   @rts
+00190d 470a: a4 fb                            ldy   _stashOffs
+00190f 470c: b1 22                            lda   (_stashIntroStoryPtr),y
+001911 470e: d0 03                            bne   @save
+001913 4710: 68                               pla                                           ;encountered #0 in stash, exit to (which?) intro screen
+001914 4711: 68                               pla
+001915 4712: 60                               rts

+001916 4713: 85 fa        @save               sta   __FA
+001918 4715: c8                               iny
+001919 4716: b1 22                            lda   (_stashIntroStoryPtr),y
+00191b 4718: 10 07                            bpl   @saveMovementDir
+00191d 471a: 29 0f                            and   #$0f
+00191f 471c: 8d 16 14                         sta   ShootingDir
+001922 471f: 10 03                            bpl   @nextOffs

+001924 4721: 8d 06 15     @saveMovementDir    sta   MovementDir
+001927 4724: c8           @nextOffs           iny
+001928 4725: 84 fb                            sty   _stashOffs
+00192a 4727: 60           @rts                rts

                           ********************************************************************************
                           * NW: intro 2 - mutant protagonist                                             *
                           ********************************************************************************
+00192b 4728: 20 66 46     introStory2         jsr   showRobotron2084
+00192e 472b: 20 46 01                         jsr   storyPart2_jmp
+001931 472e: a0 a0                            ldy   #$a0
+001933 4730: a2 78                            ldx   #$78
+001935 4732: 20 31 48                         jsr   save_1500_1503
+001938 4735: a9 6d                            lda   #$6d
+00193a 4737: 85 20                            sta   MON_WNDLEFT
+00193c 4739: a9 47                            lda   #$47
+00193e 473b: 85 21                            sta   MON_WNDWDTH
+001940 473d: 20 82 47                         jsr   L4782
+001943 4740: a2 50                            ldx   #$50
+001945 4742: a9 47                            lda   #$47
+001947 4744: 20 24 48                         jsr   init_stash_FA_FB
+00194a 4747: 20 06 47     @loop               jsr   saveDirections
+00194d 474a: 20 c2 44                         jsr   displayYou
+001950 474d: 4c 47 47                         jmp   @loop

+001953 4750: 20 00 20 03+                     .bulk 2000200306070c0d2f010c051703060f
+001963 4760: 0c 00 10 81+                     .bulk 0c00108110831081108320800010b000
+001973 4770: 01 60 90 01+                     .bulk 01609001007c900002e0a00101f0b001
+001983 4780: 02 00                            .bulk 0200

                           ; ==========
+001985 4782: a2 00        L4782               ldx   #$00
+001987 4784: a0 00                            ldy   #$00
+001989 4786: a9 0a                            lda   #$0a
+00198b 4788: 8d 0d 14                         sta   $140d
+00198e 478b: b1 20        L478B               lda   (MON_WNDLEFT),y
+001990 478d: d0 04                            bne   L4793
+001992 478f: 8e 0a 14                         stx   $140a
+001995 4792: 60                               rts

+001996 4793: 9d 50 19     L4793               sta   $1950,x
+001999 4796: c8                               iny
+00199a 4797: b1 20                            lda   (MON_WNDLEFT),y
+00199c 4799: 9d 60 19                         sta   $1960,x
+00199f 479c: c8                               iny
+0019a0 479d: b1 20                            lda   (MON_WNDLEFT),y
+0019a2 479f: 9d 70 19                         sta   $1970,x
+0019a5 47a2: c8                               iny
+0019a6 47a3: b1 20                            lda   (MON_WNDLEFT),y
+0019a8 47a5: 9d 90 19                         sta   $1990,x
+0019ab 47a8: c8                               iny
+0019ac 47a9: a9 00                            lda   #$00
+0019ae 47ab: 9d 80 19                         sta   $1980,x
+0019b1 47ae: 8a                               txa
+0019b2 47af: 29 03                            and   #$03
+0019b4 47b1: 9d a0 19                         sta   $19a0,x
+0019b7 47b4: a9 7f                            lda   #$7f
+0019b9 47b6: 9d b0 19                         sta   $19b0,x
+0019bc 47b9: e8                               inx
+0019bd 47ba: 10 cf                            bpl   L478B                                   ;NW: does this ever fall through?
                           ********************************************************************************
                           * NW: intro 4 - HULKS                                                          *
                           ********************************************************************************
+0019bf 47bc: 20 66 46     introStory4         jsr   showRobotron2084
+0019c2 47bf: 20 49 01                         jsr   storyPart4_jmp
+0019c5 47c2: a2 f0                            ldx   #$f0
+0019c7 47c4: a0 b0                            ldy   #$b0
+0019c9 47c6: 20 31 48                         jsr   save_1500_1503
+0019cc 47c9: a9 17                            lda   #$17
+0019ce 47cb: 85 20                            sta   MON_WNDLEFT
+0019d0 47cd: a9 48                            lda   #$48
+0019d2 47cf: 85 21                            sta   MON_WNDWDTH
+0019d4 47d1: 20 82 47                         jsr   L4782
+0019d7 47d4: a2 fe                            ldx   #$fe
+0019d9 47d6: a9 47                            lda   #$47
+0019db 47d8: 20 24 48                         jsr   init_stash_FA_FB
+0019de 47db: a9 09                            lda   #$09
+0019e0 47dd: 8d 00 19                         sta   $1900
+0019e3 47e0: a9 90                            lda   #$90
+0019e5 47e2: 8d 10 19                         sta   $1910
+0019e8 47e5: a9 00                            lda   #$00
+0019ea 47e7: 8d 20 19                         sta   $1920
+0019ed 47ea: 8d 30 19                         sta   $1930
+0019f0 47ed: a9 7f                            lda   #$7f
+0019f2 47ef: 8d 40 19                         sta   $1940
+0019f5 47f2: ee 09 14                         inc   $1409
+0019f8 47f5: 20 06 47     @loop               jsr   saveDirections
+0019fb 47f8: 20 c2 44                         jsr   displayYou
+0019fe 47fb: 4c f5 47                         jmp   @loop

+001a01 47fe: 58 00 10 0f+                     .bulk 5800100f010070830803010409801003
+001a11 480e: 0a 0c 01 00+                     .bulk 0a0c0100108120800030900001509000
+001a21 481e: 00 70 90 00+                     .bulk 007090000200

                           ; ==========
+001a27 4824: 86 22        init_stash_FA_FB    stx   _stashIntroStoryPtr
+001a29 4826: 85 23                            sta   _stashIntroStoryPtr+1
+001a2b 4828: a9 01                            lda   #$01
+001a2d 482a: 85 fa                            sta   __FA
+001a2f 482c: a9 00                            lda   #$00
+001a31 482e: 85 fb                            sta   _stashOffs
+001a33 4830: 60                               rts

                           ; ==========
+001a34 4831: 8e 00 15     save_1500_1503      stx   $1500                                   ;X -> $150[02]
+001a37 4834: 8e 02 15                         stx   $1502
+001a3a 4837: 8c 01 15                         sty   $1501                                   ;Y -> $150[13]
+001a3d 483a: 8c 03 15                         sty   $1503
+001a40 483d: 60                               rts

                           ********************************************************************************
                           * NW: intro 7 - controls                                                       *
                           ********************************************************************************
+001a41 483e: 20 43 46     introStory7         jsr   S4643
+001a44 4841: 20 30 49                         jsr   explainControls
+001a47 4844: a2 08                            ldx   #$08
+001a49 4846: a0 08                            ldy   #$08
+001a4b 4848: 20 31 48                         jsr   save_1500_1503
+001a4e 484b: a2 5f                            ldx   #$5f                                    ;stash address
+001a50 484d: a9 48                            lda   #$48
+001a52 484f: 20 24 48                         jsr   init_stash_FA_FB
+001a55 4852: 20 06 47     @loop               jsr   saveDirections
+001a58 4855: a9 7f                            lda   #$7f                                    ;looks like a page, inside the sprite table, but unused
+001a5a 4857: 85 2a                            sta   $2a
+001a5c 4859: 20 c2 44                         jsr   displayYou
+001a5f 485c: 4c 52 48     BP_YouDrawn         jmp   @loop

+001a62 485f: 19 01 19 04+                     .bulk 190119041a01120c0901080010811083
+001a72 486f: 10 81 10 83+                     .bulk 1081108302800a0112041c01180c1001
+001a82 487f: 18 04 72 03+                     .bulk 18047203190c200000

                           ********************************************************************************
                           * NW: intro 5 - BRAINS, PROGS                                                  *
                           ********************************************************************************
+001a8b 4888: 20 66 46     introStory5         jsr   showRobotron2084
+001a8e 488b: 20 4c 01                         jsr   storyPart5_jmp
+001a91 488e: a2 f0                            ldx   #$f0
+001a93 4890: a0 a0                            ldy   #$a0
+001a95 4892: 20 31 48                         jsr   save_1500_1503
+001a98 4895: a9 2b                            lda   #$2b
+001a9a 4897: 85 20                            sta   MON_WNDLEFT
+001a9c 4899: a9 49                            lda   #$49
+001a9e 489b: 85 21                            sta   MON_WNDWDTH
+001aa0 489d: 20 82 47                         jsr   L4782
+001aa3 48a0: a2 10                            ldx   #$10
+001aa5 48a2: a9 49                            lda   #$49
+001aa7 48a4: 20 24 48                         jsr   init_stash_FA_FB
+001aaa 48a7: a9 08                            lda   #$08
+001aac 48a9: 8d 20 1b                         sta   $1b20
+001aaf 48ac: a9 a0                            lda   #$a0
+001ab1 48ae: 8d 30 1b                         sta   $1b30
+001ab4 48b1: a9 00                            lda   #$00
+001ab6 48b3: 8d 40 1b                         sta   $1b40
+001ab9 48b6: 8d 60 1b                         sta   $1b60
+001abc 48b9: 8d 70 1b                         sta   $1b70
+001abf 48bc: a9 7f                            lda   #$7f
+001ac1 48be: 8d 80 1b                         sta   $1b80
+001ac4 48c1: a9 ff                            lda   #$ff
+001ac6 48c3: 8d 90 1b                         sta   $1b90
+001ac9 48c6: ee 18 14                         inc   $1418
+001acc 48c9: 20 06 47     L48C9               jsr   saveDirections
+001acf 48cc: 20 c2 44                         jsr   displayYou
+001ad2 48cf: a9 80                            lda   #$80
+001ad4 48d1: a2 c0                            ldx   #$c0
+001ad6 48d3: 20 e9 46                         jsr   L46E9
+001ad9 48d6: ad 1d 14                         lda   $141d
+001adc 48d9: d0 32                            bne   L490D
+001ade 48db: a5 fb                            lda   _stashOffs
+001ae0 48dd: c9 0a                            cmp   #$0a
+001ae2 48df: d0 2c                            bne   L490D
+001ae4 48e1: a2 01                            ldx   #$01
+001ae6 48e3: ad 20 1b     L48E3               lda   $1b20
+001ae9 48e6: 18                               clc
+001aea 48e7: 69 06                            adc   #$06
+001aec 48e9: 9d 70 1c                         sta   $1c70,x
+001aef 48ec: ad 30 1b                         lda   $1b30
+001af2 48ef: 9d 80 1c                         sta   $1c80,x
+001af5 48f2: a9 02                            lda   #$02
+001af7 48f4: 9d 90 1c                         sta   $1c90,x
+001afa 48f7: a9 00                            lda   #$00
+001afc 48f9: 9d a0 1c                         sta   $1ca0,x
+001aff 48fc: a9 7f                            lda   #$7f
+001b01 48fe: 9d b0 1c                         sta   $1cb0,x
+001b04 4901: ca                               dex
+001b05 4902: f0 df                            beq   L48E3
+001b07 4904: ad 2e 0c                         lda   L0C2E
+001b0a 4907: 8d c1 1c                         sta   $1cc1
+001b0d 490a: ee 1d 14                         inc   $141d
+001b10 490d: 4c c9 48     L490D               jmp   L48C9

+001b13 4910: 80 00 60 00+                     .bulk 80006000018320801000020f05000183
+001b23 4920: 10 80 2a 03+                     .bulk 10802a0301830b8020000022a0000100

                           ********************************************************************************
                           * NW: print the controls screen                                                *
                           ********************************************************************************
+001b33 4930: 20 b8 51     explainControls     jsr   showText
+001b36 4933: 0d                               .dd1  $0d
+001b37 4934: 0f                               .dd1  15
+001b38 4935: 00                               .dd1  0
+001b39 4936: 4b 45 59 42+                     .str  “KEYBOARD”
+001b41 493e: 0d                               .dd1  $0d
+001b42 493f: 0f                               .dd1  15
+001b43 4940: 08                               .dd1  8
+001b44 4941: 3d 3d 3d 3d+                     .str  “========”
+001b4c 4949: 0d                               .dd1  $0d
+001b4d 494a: 0a                               .dd1  10
+001b4e 494b: 10                               .dd1  16
+001b4f 494c: 4d 4f 56 45+                     .str  “MOVE:”
+001b54 4951: 0d                               .dd1  $0d
+001b55 4952: 17                               .dd1  23
+001b56 4953: 10                               .dd1  16
+001b57 4954: 53 48 4f 4f+                     .str  “SHOOT:”
+001b5d 495a: 0d                               .dd1  $0d
+001b5e 495b: 0a                               .dd1  10
+001b5f 495c: 1f                               .dd1  31
+001b60 495d: 51 20 57 20+                     .str  “Q W E”
+001b65 4962: 0d                               .dd1  $0d
+001b66 4963: 17                               .dd1  23
+001b67 4964: 1f                               .dd1  31
+001b68 4965: 49 20 4f 20+                     .str  “I O P”
+001b6d 496a: 0d                               .dd1  $0d
+001b6e 496b: 0a                               .dd1  10
+001b6f 496c: 28                               .dd1  40
+001b70 496d: 41 20 20 20+                     .str  “A   D”
+001b75 4972: 0d                               .dd1  $0d
+001b76 4973: 17                               .dd1  23
+001b77 4974: 28                               .dd1  40
+001b78 4975: 4b 20 20 20+                     .str  “K   ;”
+001b7d 497a: 0d                               .dd1  $0d
+001b7e 497b: 0a                               .dd1  10
+001b7f 497c: 31                               .dd1  49
+001b80 497d: 5a 20 58 20+                     .str  “Z X C”
+001b85 4982: 0d                               .dd1  $0d
+001b86 4983: 17                               .dd1  23
+001b87 4984: 31                               .dd1  49
+001b88 4985: 2c 20 2e 20+                     .str  “, . /”
+001b8d 498a: 0d                               .dd1  $0d
+001b8e 498b: 0f                               .dd1  15
+001b8f 498c: 48                               .dd1  72
+001b90 498d: 4a 4f 59 53+                     .str  “JOYSTICK”
+001b98 4995: 0d                               .dd1  $0d
+001b99 4996: 0f                               .dd1  15
+001b9a 4997: 50                               .dd1  80
+001b9b 4998: 3d 3d 3d 3d+                     .str  “========”
+001ba3 49a0: 0d                               .dd1  $0d
+001ba4 49a1: 01                               .dd1  1
+001ba5 49a2: 58                               .dd1  88
+001ba6 49a3: 4d 4f 56 45+                     .str  “MOVE:JOYSTICK   SHOOT:BUTTONS 0 AND 1”
+001bcb 49c8: 0d                               .dd1  $0d
+001bcc 49c9: 0f                               .dd1  15
+001bcd 49ca: 70                               .dd1  112
+001bce 49cb: 50 41 44 44+                     .str  “PADDLES”
+001bd5 49d2: 0d                               .dd1  $0d
+001bd6 49d3: 0f                               .dd1  15
+001bd7 49d4: 78                               .dd1  120
+001bd8 49d5: 3d 3d 3d 3d+                     .str  “=======”
+001bdf 49dc: 0d                               .dd1  $0d
+001be0 49dd: 04                               .dd1  4
+001be1 49de: 80                               .dd1  128
+001be2 49df: 4d 4f 56 45+                     .str  “MOVE:PADDLE 0   SHOOT:PADDLE 1”
+001c00 49fd: 0d                               .dd1  $0d
+001c01 49fe: 09                               .dd1  9
+001c02 49ff: 98                               .dd1  152
+001c03 4a00: 4a 4f 59 53+                     .str  “JOYSTICK + KEYBOARD”
+001c16 4a13: 0d                               .dd1  $0d
+001c17 4a14: 09                               .dd1  9
+001c18 4a15: a0                               .dd1  160
+001c19 4a16: 3d 3d 3d 3d+                     .str  “===================”
+001c2c 4a29: 0d                               .dd1  $0d
+001c2d 4a2a: 01                               .dd1  1
+001c2e 4a2b: a8                               .dd1  168
+001c2f 4a2c: 4d 4f 56 45+                     .str  “MOVE:JOYSTICK   SHOOT:WHOLE KEYBOARD”
+001c53 4a50: 00                               .dd1  $00

+001c54 4a51: 60                               rts

                           ********************************************************************************
                           * NW: intro 6 - SPHEROIDS, QUARKS, ENFORCERS, TANKS                            *
                           ********************************************************************************
+001c55 4a52: 20 66 46     introStory6         jsr   showRobotron2084
+001c58 4a55: 20 4f 01                         jsr   storyPart6_jmp
+001c5b 4a58: a2 08                            ldx   #$08
+001c5d 4a5a: a0 08                            ldy   #$08
+001c5f 4a5c: 20 31 48                         jsr   save_1500_1503
+001c62 4a5f: a2 42                            ldx   #$42
+001c64 4a61: a9 4b                            lda   #$4b
+001c66 4a63: 20 24 48                         jsr   init_stash_FA_FB
+001c69 4a66: a9 f1                            lda   #$f1
+001c6b 4a68: 8d c0 19                         sta   $19c0
+001c6e 4a6b: a9 f0                            lda   #$f0
+001c70 4a6d: 8d e0 1c                         sta   $1ce0
+001c73 4a70: a9 90                            lda   #$90
+001c75 4a72: 8d d0 19                         sta   $19d0
+001c78 4a75: a9 a7                            lda   #$a7
+001c7a 4a77: 8d f0 1c                         sta   $1cf0
+001c7d 4a7a: a9 00                            lda   #$00
+001c7f 4a7c: 8d e0 19                         sta   $19e0
+001c82 4a7f: 8d f0 19                         sta   $19f0
+001c85 4a82: 8d 00 1d                         sta   $1d00
+001c88 4a85: 8d 10 1d                         sta   $1d10
+001c8b 4a88: 8d 00 1a                         sta   $1a00
+001c8e 4a8b: 8d 20 1d                         sta   $1d20
+001c91 4a8e: 8d 40 1a                         sta   $1a40
+001c94 4a91: 8d 60 1d                         sta   $1d60
+001c97 4a94: 8d c1 19                         sta   $19c1
+001c9a 4a97: 8d e1 1c                         sta   $1ce1
+001c9d 4a9a: a9 7f                            lda   #$7f
+001c9f 4a9c: 8d 20 1a                         sta   $1a20
+001ca2 4a9f: 8d 50 1d                         sta   $1d50
+001ca5 4aa2: 8d 30 1d                         sta   $1d30
+001ca8 4aa5: ee 0e 14                         inc   $140e
+001cab 4aa8: ee 27 14                         inc   $1427
+001cae 4aab: 20 06 47     L4AAB               jsr   saveDirections
+001cb1 4aae: ad 30 1d                         lda   $1d30
+001cb4 4ab1: c9 10                            cmp   #$10
+001cb6 4ab3: b0 05                            bcs   L4ABA
+001cb8 4ab5: a9 7f                            lda   #$7f
+001cba 4ab7: 8d 30 1d                         sta   $1d30
+001cbd 4aba: a9 7f        L4ABA               lda   #$7f
+001cbf 4abc: 8d 10 1a                         sta   $1a10
+001cc2 4abf: 8d 24 14                         sta   $1424
+001cc5 4ac2: 8d 2a 14                         sta   $142a
+001cc8 4ac5: a5 fb                            lda   _stashOffs
+001cca 4ac7: c9 06                            cmp   #$06
+001ccc 4ac9: d0 05                            bne   L4AD0
+001cce 4acb: a9 fc                            lda   #$fc
+001cd0 4acd: 8d e0 19                         sta   $19e0
+001cd3 4ad0: ad 0f 14     L4AD0               lda   $140f
+001cd6 4ad3: d0 23                            bne   L4AF8
+001cd8 4ad5: ad c0 19                         lda   $19c0
+001cdb 4ad8: c9 c1                            cmp   #$c1
+001cdd 4ada: d0 1c                            bne   L4AF8
+001cdf 4adc: 18                               clc
+001ce0 4add: 69 08                            adc   #$08
+001ce2 4adf: 8d 50 1a                         sta   $1a50
+001ce5 4ae2: ad d0 19                         lda   $19d0
+001ce8 4ae5: 8d 60 1a                         sta   $1a60
+001ceb 4ae8: a9 00                            lda   #$00
+001ced 4aea: 8d 70 1a                         sta   $1a70
+001cf0 4aed: 8d 90 1a                         sta   $1a90
+001cf3 4af0: a9 fe                            lda   #$fe
+001cf5 4af2: 8d 80 1a                         sta   $1a80
+001cf8 4af5: ee 0f 14                         inc   $140f
+001cfb 4af8: a5 fb        L4AF8               lda   _stashOffs
+001cfd 4afa: c9 18                            cmp   #$18
+001cff 4afc: d0 05                            bne   L4B03
+001d01 4afe: a9 fc                            lda   #$fc
+001d03 4b00: 8d 00 1d                         sta   $1d00
+001d06 4b03: ad 28 14     L4B03               lda   $1428
+001d09 4b06: d0 2d                            bne   L4B35
+001d0b 4b08: ad e0 1c                         lda   $1ce0
+001d0e 4b0b: c9 c0                            cmp   #$c0
+001d10 4b0d: d0 26                            bne   L4B35
+001d12 4b0f: 18                               clc
+001d13 4b10: 69 08                            adc   #$08
+001d15 4b12: 09 01                            ora   #$01
+001d17 4b14: 8d 70 1d                         sta   $1d70
+001d1a 4b17: ad f0 1c                         lda   $1cf0
+001d1d 4b1a: 8d 90 1d                         sta   $1d90
+001d20 4b1d: a9 00                            lda   #$00
+001d22 4b1f: 8d f0 1d                         sta   $1df0
+001d25 4b22: 8d d0 1d                         sta   $1dd0
+001d28 4b25: 8d 30 1e                         sta   $1e30
+001d2b 4b28: a9 fe                            lda   #$fe
+001d2d 4b2a: 8d b0 1d                         sta   $1db0
+001d30 4b2d: a9 7f                            lda   #$7f
+001d32 4b2f: 8d 10 1e                         sta   $1e10
+001d35 4b32: ee 28 14                         inc   $1428
+001d38 4b35: 20 c2 44     L4B35               jsr   displayYou
+001d3b 4b38: a9 80                            lda   #$80
+001d3d 4b3a: a2 b0                            ldx   #$b0
+001d3f 4b3c: 20 e9 46                         jsr   L46E9
+001d42 4b3f: 4c ab 4a                         jmp   L4AAB

+001d45 4b42: 44 04 01 00+                     .bulk 440401005000040101810f8001810b80
+001d55 4b52: 20 03 0c 04+                     .bulk 20030c0401005000040101811f800181
+001d65 4b62: 14 80 20 00+                     .bulk 1480200000

                           ********************************************************************************
                           * NW: print select controls screen                                             *
                           ********************************************************************************
+001d6a 4b67: 20 25 4f     chooseControls      jsr   clearScreen
+001d6d 4b6a: 20 b8 51                         jsr   showText
+001d70 4b6d: 0d                               .dd1  $0d
+001d71 4b6e: 09                               .dd1  9
+001d72 4b6f: 28                               .dd1  40
+001d73 4b70: 43 48 4f 4f+                     .str  “CHOOSE CONTROLS:”
+001d83 4b80: 0d                               .dd1  $0d
+001d84 4b81: 09                               .dd1  9
+001d85 4b82: 40                               .dd1  64
+001d86 4b83: 31 29 20 4a+                     .str  “1) JOYSTICK”
+001d91 4b8e: 0d                               .dd1  $0d
+001d92 4b8f: 09                               .dd1  9
+001d93 4b90: 50                               .dd1  80
+001d94 4b91: 32 29 20 4b+                     .str  “2) KEYBOARD”
+001d9f 4b9c: 0d                               .dd1  $0d
+001da0 4b9d: 09                               .dd1  9
+001da1 4b9e: 60                               .dd1  96
+001da2 4b9f: 33 29 20 50+                     .str  “3) PADDLES”
+001dac 4ba9: 0d                               .dd1  $0d
+001dad 4baa: 09                               .dd1  9
+001dae 4bab: 70                               .dd1  112
+001daf 4bac: 34 29 20 4a+                     .str  “4) JOYSTICK AND KEYBOARD”
+001dc7 4bc4: 0d                               .dd1  $0d
+001dc8 4bc5: 09                               .dd1  9
+001dc9 4bc6: 90                               .dd1  144
+001dca 4bc7: 57 48 49 43+                     .str  “WHICH?”
+001dd0 4bcd: 00                               .dd1  $00

+001dd1 4bce: 20 42 42                         jsr   waitForKey                              ;returns ASCII w/ high-bit cleared
+001dd4 4bd1: c9 20                            cmp   #$20                                    ;ASCII_SPACE ($A0) w/o high bit
+001dd6 4bd3: f0 19                            beq   @rts                                    ;SPACE = use default (i.e. ControllerType unchanged), then game starts, NW: yes, start game last used controls (default is keyboard)
+001dd8 4bd5: a2 00                            ldx   #$00                                    ;NW: no, check for valid control selection keys
+001dda 4bd7: dd ef 4b     @nextType           cmp   ASCII_1234,x                            ;NW: control selection number keys
+001ddd 4bda: f0 0f                            beq   @save                                   ;if "2" (keyboard) then ControllerType = 1
+001ddf 4bdc: dd f3 4b                         cmp   ASCII_JKPamp,x                          ;NW: alternate control selection keys
+001de2 4bdf: f0 0a                            beq   @save                                   ;alternatively, we can press "K" for keyboard
+001de4 4be1: e8                               inx
+001de5 4be2: e0 04                            cpx   #$04
+001de7 4be4: 90 f1                            bcc   @nextType                               ;branch while X < 4, NW: valid key matached?
+001de9 4be6: 68                               pla                                           ;"exception", thus remove caller from stack..., NW: no, go back to attract mode
+001dea 4be7: 68                               pla
+001deb 4be8: 4c 60 40                         jmp   startScreen                             ;... and start over (?)

+001dee 4beb: 8e 17 14     @save               stx   ControllerType                          ;NW: yes, record control selection
+001df1 4bee: 60           @rts                rts

+001df2 4bef: 31 32 33 34  ASCII_1234          .str  “1234”                                  ;NW: 1, 2, 3, 4 - valid control selection number keys
+001df6 4bf3: 4a 4b 50 26  ASCII_JKPamp        .str  “JKP&”                                  ;NW: J, K, P, & - valid alternate control selection keys
+001dfa 4bf7: 02                               .dd1  $02
+001dfb 4bf8: bb                               .dd1  $bb
+001dfc 4bf9: 5a                               .dd1  $5a
+001dfd 4bfa: 30                               .dd1  $30
+001dfe 4bfb: 5f                               .dd1  $5f
+001dff 4bfc: ee                               .dd1  $ee
+001e00 4bfd: 3d                               .dd1  $3d
+001e01 4bfe: a8                               .dd1  $a8
+001e02 4bff: ff                               .dd1  $ff

                           NOTE: compact function, calculation only
                           track input and output
                           might need a BP @ entry and exit
                           how to group those 2 breakpoints together? how to save the params?
                           maybe have a function data object
                           ********************************************************************************
                           * divideAX - 8-bit division (?)                                                *
                           *                                                                              *
                           * A -> __E0                                                                    *
                           * X -> __E1                                                                    *
                           *                                                                              *
                           * returns: A (Quotient?), X (Rest)                                             *
                           *                                                                              *
                           * http://6502org.wikidot.com/software-math-intdiv                              *
                           * https://wiki.nesdev.com/w/index.php/8-bit_Divide                             *
                           * http://forum.6502.org/viewtopic.php?t=1249                                   *
                           * http://forum.6502.org/viewtopic.php?f=2&t=5322                               *
                           * http://forum.6502.org/viewtopic.php?f=9&t=1652                               *
                           * http://wilsonminesco.com/16bitMathTables/index.html                          *
                           * http://nparker.llx.com/a2/mult.html                                          *
                           * https://codebase64.org/doku.php?id=base:6502_6510_maths                      *
                           ********************************************************************************
                           _Dividend           .var  $e0    {addr/1}
                           _Divisor            .var  $e1    {addr/1}
                           _Quotient           .var  $e2    {addr/1}

+001e03 4c00: 85 e0        divideAX            sta   _Dividend
+001e05 4c02: 86 e1                            stx   _Divisor
+001e07 4c04: a9 00                            lda   #$00
+001e09 4c06: 85 e2                            sta   _Quotient
+001e0b 4c08: a2 08                            ldx   #$08
+001e0d 4c0a: 06 e0        @nextBit            asl   _Dividend
+001e0f 4c0c: 2a                               rol   A
+001e10 4c0d: c5 e1                            cmp   _Divisor
+001e12 4c0f: 90 02                            bcc   @lessThan
+001e14 4c11: e5 e1                            sbc   _Divisor
+001e16 4c13: 26 e2        @lessThan           rol   _Quotient
+001e18 4c15: ca                               dex
+001e19 4c16: d0 f2                            bne   @nextBit
+001e1b 4c18: aa                               tax
+001e1c 4c19: a5 e2                            lda   _Quotient
+001e1e 4c1b: 60           divideAX_RTS        rts

                           ; ==========
+001e1f 4c1c: 85 e0        divdeA7             sta   _Dividend
+001e21 4c1e: a9 00                            lda   #$00
+001e23 4c20: 85 e2                            sta   _Quotient
+001e25 4c22: a2 08                            ldx   #$08
+001e27 4c24: 06 e0        @nextBit            asl   _Dividend
+001e29 4c26: 2a                               rol   A
+001e2a 4c27: c9 07                            cmp   #$07
+001e2c 4c29: 90 02                            bcc   @lessThan
+001e2e 4c2b: e9 07                            sbc   #$07
+001e30 4c2d: 26 e2        @lessThan           rol   _Quotient
+001e32 4c2f: ca                               dex
+001e33 4c30: d0 f2                            bne   @nextBit
+001e35 4c32: aa                               tax
+001e36 4c33: a5 e2                            lda   _Quotient
+001e38 4c35: 60                               rts

                           NOTE: idea: fake result from random number generator
                           ********************************************************************************
                           * generate random number                                                       *
                           *                                                                              *
                           * A: random number                                                             *
                           * MON_RND[LH]: 16bit random number (TOCHECK)                                   *
                           * MON_RNDL := A                                                                *
                           *                                                                              *
                           * MON_RND usually changed by KEYIN (see Peeled), but we don't call KEYIN       *
                           * anywhere in Robotron.                                                        *
                           ********************************************************************************
+001e39 4c36: a5 4f        randomA             lda   MON_RNDH
+001e3b 4c38: 0a                               asl   A
+001e3c 4c39: 65 fc                            adc   PixelLineBaseL                          ;last pixel line is very random (but data range?)
+001e3e 4c3b: 45 4e                            eor   MON_RNDL
+001e40 4c3d: 48                               pha                                           ;1 random byte, saved in MON_RNDL, returned in A
+001e41 4c3e: e6 4e                            inc   MON_RNDL
+001e43 4c40: a5 4e                            lda   MON_RNDL
+001e45 4c42: 4d 0a 15                         eor   Score0                                  ;score lowbyte is also pretty random (also data range?)
+001e48 4c45: 85 4f                            sta   MON_RNDH                                ;1 other random byte, saved in MON_RNDL
+001e4a 4c47: 68                               pla
+001e4b 4c48: 85 4e                            sta   MON_RNDL
+001e4d 4c4a: 60                               rts

+001e4e 4c4b: aa           multiplyRndX        tax
+001e4f 4c4c: 20 36 4c                         jsr   randomA                                 ;NW: get random number in A? [TODO: ich glaube nicht]
                           NOTE: multiplyRndX multiplies and falls through into yet another multiply
                           this generates a lot of cycles
                           hidden throttling of execution?
                           ********************************************************************************
                           * multiplyAX                                                                   *
                           *                                                                              *
                           * The two 8-bit operands are provided in A and X                               *
                           * X: result                                                                    *
                           * A: workspace (?)                                                             *
                           * Y: untouched                                                                 *
                           ********************************************************************************
                           _mult1              .var  $e0    {addr/1}
                           _mult2              .var  $e1    {addr/1}
                           _workspace          .var  $e2    {addr/1}

+001e52 4c4f: 85 e0        multiplyAX          sta   _mult1
+001e54 4c51: 86 e1                            stx   _mult2
+001e56 4c53: a9 00                            lda   #$00
+001e58 4c55: 85 e2                            sta   _workspace                              ;workspace, starts w/ 0
+001e5a 4c57: a2 08                            ldx   #$08
                           ; 
+001e5c 4c59: 0a           @nextBit            asl   A                                       ;The loop structure consists of the three instructions LDX #8 ; […] ; DEX ; BNE .L8 (backwards branch) and encompasses the majority of the subroutine body. This is an idiom that you should learn to recognise instantly.
+001e5d 4c5a: 26 e2                            rol   _workspace                              ;This is a two-byte multiprecision left shift, effectively transferring the top bit of A into the bottom bit of $E2 via the Carry flag, and the former top bit of $E2 ends up in the Carry flag. This is further confirmation that they're being treated as a single wide value. But on the first iteration both are still zero, and remain so for the time being.
+001e5f 4c5c: 06 e0                            asl   _mult1                                  ;The following ASL $E0 is where the real action begins. Recall that $E0 contains the former value of A on entry; we've just popped out the top bit of it into the Carry. The very next instruction branches on the Carry, skipping all the rest of the loop body if it is cleared. Clearly the individual bits of the first operand, most-significant first, are crucial to the algorithm.
+001e61 4c5e: 90 07                            bcc   @noOverflow
                           ; 
+001e63 4c60: 18                               clc
+001e64 4c61: 65 e1                            adc   _mult2                                  ;So one operand is added to the shifted workspace for each set bit in the other operand; this is a classic multiplication algorithm!
+001e66 4c63: 90 02                            bcc   @noOverflow                             ;The Carry flag now indicates unsigned overflow from the addition, and there is a branch testing it immediately afterwards - which happens to be always-taken for the moment. But the sensible thing to do if the Carry is set is to propagate it into the high half of the workspace at $E2 ...
                           ; 
+001e68 4c65: e6 e2                            inc   _workspace                              ;... which can be done with INC $E2
+001e6a 4c67: ca           @noOverflow         dex
+001e6b 4c68: d0 ef                            bne   @nextBit
                           ; 
+001e6d 4c6a: aa                               tax
+001e6e 4c6b: a5 e2                            lda   _workspace
+001e70 4c6d: 60                               rts

                           ********************************************************************************
                           * NW: click the speaker if needed                                              *
                           ********************************************************************************
+001e71 4c6e: a5 ca        doSpeaker           lda   $ca                                     ;this is sometimes set to #$60 (rts)
+001e73 4c70: f0 09                            beq   @rts
+001e75 4c72: 65 cb                            adc   $cb
+001e77 4c74: 85 cb                            sta   $cb
+001e79 4c76: 90 03                            bcc   @rts
+001e7b 4c78: ad 30 c0                         lda   SPKR
+001e7e 4c7b: 60           @rts                rts

+001e7f 4c7c: 84 fc        fetchSprite         sty   PixelLineBaseL                          ;passed pixel line in Y, but we don't need it locally
+001e81 4c7e: 84 fe                            sty   PixelLineBaseH
+001e83 4c80: 86 05                            stx   $05                                     ;x coord (measured in what?)
+001e85 4c82: a9 00                            lda   #$00
+001e87 4c84: 85 04                            sta   $04
+001e89 4c86: a2 08                            ldx   #$08                                    ;goes from #$08 to #$01 (see BNE below)
+001e8b 4c88: 06 05        @loop               asl   $05
+001e8d 4c8a: 2a                               rol   A
+001e8e 4c8b: c9 07                            cmp   #$07
+001e90 4c8d: 90 02                            bcc   L4C91
+001e92 4c8f: e9 07                            sbc   #$07
+001e94 4c91: 26 04        L4C91               rol   $04
+001e96 4c93: ca                               dex
+001e97 4c94: d0 f2                            bne   @loop
+001e99 4c96: 69 01                            adc   #$01
+001e9b 4c98: 0a                               asl   A                                       ;A = offset into strobing catalog
+001e9c 4c99: a8                               tay                                           ;... now in Y
+001e9d 4c9a: b1 06                            lda   (PixelLine),y                           ;#$00 <- $7a00+04
+001e9f 4c9c: 85 08                            sta   Sprite
+001ea1 4c9e: c8                               iny
+001ea2 4c9f: b1 06                            lda   (PixelLine),y                           ;#$90 <- $7a05
+001ea4 4ca1: 85 09                            sta   Sprite+1                                ;... ($08) = sprite
+001ea6 4ca3: a0 01                            ldy   #$01
+001ea8 4ca5: b1 06                            lda   (PixelLine),y                           ;#$0a <- $7a01
+001eaa 4ca7: a8                               tay                                           ;Y = height of sprite ...
+001eab 4ca8: 88                               dey                                           ;... now Y is ubound of sprite lines
+001eac 4ca9: a2 00                            ldx   #$00                                    ;needed for (zp),X access into sprite bytes
+001eae 4cab: 60                               rts

                           ********************************************************************************
                           * NW: draw shape to screen (used for family)                                   *
                           ********************************************************************************
+001eaf 4cac: 20 7c 4c     drawFamily          jsr   fetchSprite
+001eb2 4caf: b1 fc        L4CAF               lda   (PixelLineBaseL),y
+001eb4 4cb1: 85 06                            sta   PixelLine
+001eb6 4cb3: b1 fe                            lda   (PixelLineBaseH),y
+001eb8 4cb5: 85 07                            sta   PixelLine+1
+001eba 4cb7: 84 05                            sty   $05
+001ebc 4cb9: a4 04                            ldy   $04
+001ebe 4cbb: a1 08                            lda   (Sprite,x)
+001ec0 4cbd: 91 06                            sta   (PixelLine),y
+001ec2 4cbf: e6 08                            inc   Sprite
+001ec4 4cc1: c8                               iny
+001ec5 4cc2: a1 08                            lda   (Sprite,x)
+001ec7 4cc4: 91 06                            sta   (PixelLine),y
+001ec9 4cc6: e6 08                            inc   Sprite
+001ecb 4cc8: a4 05                            ldy   $05
+001ecd 4cca: 88                               dey
+001ece 4ccb: 10 e2                            bpl   L4CAF
+001ed0 4ccd: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: erase shape from screen (used for family)                                *
                           ********************************************************************************
+001ed3 4cd0: 86 fc        eraseFamily         stx   PixelLineBaseL
+001ed5 4cd2: 86 fe                            stx   PixelLineBaseH
+001ed7 4cd4: 20 1c 4c                         jsr   divdeA7
+001eda 4cd7: 85 04                            sta   $04
+001edc 4cd9: 88                               dey
+001edd 4cda: a2 00                            ldx   #$00
+001edf 4cdc: b1 fc        L4CDC               lda   (PixelLineBaseL),y
+001ee1 4cde: 85 06                            sta   PixelLine
+001ee3 4ce0: b1 fe                            lda   (PixelLineBaseH),y
+001ee5 4ce2: 85 07                            sta   PixelLine+1
+001ee7 4ce4: 84 05                            sty   $05
+001ee9 4ce6: a4 04                            ldy   $04
+001eeb 4ce8: 8a                               txa
+001eec 4ce9: 91 06                            sta   (PixelLine),y
+001eee 4ceb: c8                               iny
+001eef 4cec: 91 06                            sta   (PixelLine),y
+001ef1 4cee: a4 05                            ldy   $05
+001ef3 4cf0: 88                               dey
+001ef4 4cf1: 10 e9                            bpl   L4CDC
+001ef6 4cf3: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: store 3-byte-wide shape to screen (used for hulks)                       *
                           ********************************************************************************
+001ef9 4cf6: 20 7c 4c     drawHulk            jsr   fetchSprite
+001efc 4cf9: b1 fc        L4CF9               lda   (PixelLineBaseL),y
+001efe 4cfb: 85 06                            sta   PixelLine
+001f00 4cfd: b1 fe                            lda   (PixelLineBaseH),y
+001f02 4cff: 85 07                            sta   PixelLine+1
+001f04 4d01: 84 05                            sty   $05
+001f06 4d03: a4 04                            ldy   $04
+001f08 4d05: a1 08                            lda   (Sprite,x)
+001f0a 4d07: 91 06                            sta   (PixelLine),y
+001f0c 4d09: e6 08                            inc   Sprite
+001f0e 4d0b: c8                               iny
+001f0f 4d0c: a1 08                            lda   (Sprite,x)
+001f11 4d0e: 91 06                            sta   (PixelLine),y
+001f13 4d10: e6 08                            inc   Sprite
+001f15 4d12: c8                               iny
+001f16 4d13: a1 08                            lda   (Sprite,x)
+001f18 4d15: 91 06                            sta   (PixelLine),y
+001f1a 4d17: e6 08                            inc   Sprite
+001f1c 4d19: a4 05                            ldy   $05
+001f1e 4d1b: 88                               dey
+001f1f 4d1c: 10 db                            bpl   L4CF9
+001f21 4d1e: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: erase 3-byte-wide shape from screen (used for hulks)                     *
                           ********************************************************************************
+001f24 4d21: 86 fc        eraseHulk           stx   PixelLineBaseL
+001f26 4d23: 86 fe                            stx   PixelLineBaseH
+001f28 4d25: 20 1c 4c                         jsr   divdeA7
+001f2b 4d28: 85 04                            sta   $04
+001f2d 4d2a: 88                               dey
+001f2e 4d2b: a2 00                            ldx   #$00
+001f30 4d2d: b1 fc        L4D2D               lda   (PixelLineBaseL),y
+001f32 4d2f: 85 06                            sta   PixelLine
+001f34 4d31: b1 fe                            lda   (PixelLineBaseH),y
+001f36 4d33: 85 07                            sta   PixelLine+1
+001f38 4d35: 84 05                            sty   $05
+001f3a 4d37: a4 04                            ldy   $04
+001f3c 4d39: 8a                               txa
+001f3d 4d3a: 91 06                            sta   (PixelLine),y
+001f3f 4d3c: c8                               iny
+001f40 4d3d: 91 06                            sta   (PixelLine),y
+001f42 4d3f: c8                               iny
+001f43 4d40: 91 06                            sta   (PixelLine),y
+001f45 4d42: a4 05                            ldy   $05
+001f47 4d44: 88                               dey
+001f48 4d45: 10 e6                            bpl   L4D2D
+001f4a 4d47: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+001f4d 4d4a: a2 0b        L4D4A               ldx   #$0b
+001f4f 4d4c: 20 36 4c     L4D4C               jsr   randomA
+001f52 4d4f: 9d 00 07                         sta   $0700,x
+001f55 4d52: 20 36 4c                         jsr   randomA
+001f58 4d55: 9d 80 07                         sta   $0780,x
+001f5b 4d58: ca                               dex
+001f5c 4d59: d0 f1                            bne   L4D4C
+001f5e 4d5b: 86 00                            stx   $00
+001f60 4d5d: 86 fc                            stx   PixelLineBaseL
+001f62 4d5f: 86 fe                            stx   PixelLineBaseH
+001f64 4d61: 8e 00 07                         stx   $0700
+001f67 4d64: 8e 80 07                         stx   $0780
+001f6a 4d67: a5 00        L4D67               lda   $00
+001f6c 4d69: 85 01                            sta   $01
+001f6e 4d6b: 18                               clc
+001f6f 4d6c: 69 60                            adc   #$60
+001f71 4d6e: a2 ff                            ldx   #$ff
+001f73 4d70: 20 4f 4c                         jsr   multiplyAX
+001f76 4d73: 85 ca                            sta   $ca
+001f78 4d75: a5 01        L4D75               lda   $01
+001f7a 4d77: 38                               sec
+001f7b 4d78: e5 00                            sbc   $00
+001f7d 4d7a: 4a                               lsr   A
+001f7e 4d7b: 4a                               lsr   A
+001f7f 4d7c: 4a                               lsr   A
+001f80 4d7d: aa                               tax
+001f81 4d7e: a9 60                            lda   #$60
+001f83 4d80: 18                               clc
+001f84 4d81: 65 01                            adc   $01
+001f86 4d83: 20 a2 4d                         jsr   L4DA2
+001f89 4d86: a9 5f                            lda   #$5f
+001f8b 4d88: 38                               sec
+001f8c 4d89: e5 01                            sbc   $01
+001f8e 4d8b: 20 a2 4d                         jsr   L4DA2
+001f91 4d8e: a5 01                            lda   $01
+001f93 4d90: 18                               clc
+001f94 4d91: 69 08                            adc   #$08
+001f96 4d93: 85 01                            sta   $01
+001f98 4d95: c9 60                            cmp   #$60
+001f9a 4d97: 90 dc                            bcc   L4D75
+001f9c 4d99: e6 00                            inc   $00
+001f9e 4d9b: a5 00                            lda   $00
+001fa0 4d9d: c9 60                            cmp   #$60
+001fa2 4d9f: 90 c6                            bcc   L4D67
+001fa4 4da1: 60                               rts

+001fa5 4da2: a8           L4DA2               tay
+001fa6 4da3: b1 fc                            lda   (PixelLineBaseL),y
+001fa8 4da5: 85 06                            sta   PixelLine
+001faa 4da7: b1 fe                            lda   (PixelLineBaseH),y
+001fac 4da9: 85 07                            sta   PixelLine+1
+001fae 4dab: a0 26                            ldy   #$26
+001fb0 4dad: bd 00 07                         lda   $0700,x
+001fb3 4db0: 91 06        L4DB0               sta   (PixelLine),y
+001fb5 4db2: 88                               dey
+001fb6 4db3: 88                               dey
+001fb7 4db4: 10 fa                            bpl   L4DB0
+001fb9 4db6: 20 6e 4c                         jsr   doSpeaker
+001fbc 4db9: a0 27                            ldy   #$27
+001fbe 4dbb: bd 80 07                         lda   $0780,x
+001fc1 4dbe: 91 06        L4DBE               sta   (PixelLine),y
+001fc3 4dc0: 88                               dey
+001fc4 4dc1: 88                               dey
+001fc5 4dc2: 10 fa                            bpl   L4DBE
+001fc7 4dc4: 20 6e 4c                         jsr   doSpeaker
+001fca 4dc7: a0 ff                            ldy   #$ff
+001fcc 4dc9: 88           L4DC9               dey
+001fcd 4dca: d0 fd                            bne   L4DC9
+001fcf 4dcc: 20 6e 4c                         jsr   doSpeaker                               ;optimise speaker tail call?
+001fd2 4dcf: 60                               rts

                           ********************************************************************************
                           * NW: collision detection? (disabled for attract mode)                         *
                           ********************************************************************************
+001fd3 4dd0: 86 06        detectCollision     stx   PixelLine                               ;sometimes deactivated w/ #$60 (rts)
+001fd5 4dd2: 85 07                            sta   PixelLine+1
+001fd7 4dd4: ad 0a 15                         lda   Score0
+001fda 4dd7: 18                               clc
+001fdb 4dd8: 65 06                            adc   PixelLine
+001fdd 4dda: 8d 0a 15                         sta   Score0
+001fe0 4ddd: ad 0b 15                         lda   Score1
+001fe3 4de0: 65 07                            adc   PixelLine+1
+001fe5 4de2: 8d 0b 15                         sta   Score1
+001fe8 4de5: ad 0c 15                         lda   Score2
+001feb 4de8: 69 00                            adc   #$00
+001fed 4dea: 8d 0c 15                         sta   Score2
+001ff0 4ded: ad 0d 15                         lda   $150d
+001ff3 4df0: 38                               sec
+001ff4 4df1: e5 06                            sbc   PixelLine
+001ff6 4df3: 8d 0d 15                         sta   $150d
+001ff9 4df6: ad 0e 15                         lda   $150e
+001ffc 4df9: e5 07                            sbc   PixelLine+1
+001ffe 4dfb: 8d 0e 15                         sta   $150e
+002001 4dfe: 10 1f                            bpl   showScore
+002003 4e00: ee 09 15                         inc   Lives
+002006 4e03: 20 4f 4e                         jsr   showLives
+002009 4e06: ad 0d 15                         lda   $150d
+00200c 4e09: 18                               clc
+00200d 4e0a: 6d 10 0c                         adc   L0C10
+002010 4e0d: 8d 0d 15                         sta   $150d
+002013 4e10: ad 0e 15                         lda   $150e
+002016 4e13: 6d 11 0c                         adc   L0C11
+002019 4e16: 8d 0e 15                         sta   $150e
+00201c 4e19: ad 69 0c                         lda   L0C69
+00201f 4e1c: 8d 30 14                         sta   $1430
+002022 4e1f: a9 38        showScore           lda   #$38
+002024 4e21: 85 fc                            sta   PixelLineBaseL
+002026 4e23: ad 0a 15                         lda   Score0
+002029 4e26: 85 00                            sta   $00
+00202b 4e28: ad 0b 15                         lda   Score1
+00202e 4e2b: 85 01                            sta   $01
+002030 4e2d: ad 0c 15                         lda   Score2
+002033 4e30: 85 02                            sta   $02
+002035 4e32: 20 c4 4e     L4E32               jsr   stats04
+002038 4e35: 18                               clc
+002039 4e36: 69 b0                            adc   #$b0
+00203b 4e38: a2 27                            ldx   #$27
+00203d 4e3a: a4 fc                            ldy   PixelLineBaseL
+00203f 4e3c: 20 08 51                         jsr   printChar
+002042 4e3f: a5 fc                            lda   PixelLineBaseL
+002044 4e41: 38                               sec
+002045 4e42: e9 08                            sbc   #$08
+002047 4e44: 85 fc                            sta   PixelLineBaseL
+002049 4e46: a5 00                            lda   $00
+00204b 4e48: 05 01                            ora   $01
+00204d 4e4a: 05 02                            ora   $02
+00204f 4e4c: d0 e4                            bne   L4E32
+002051 4e4e: 60                               rts

                           ********************************************************************************
                           * NW: draw shape to screen (used for men left at right)                        *
                           ********************************************************************************
+002052 4e4f: ad 00 08     showLives           lda   L0800
+002055 4e52: 85 06                            sta   PixelLine
+002057 4e54: ad 20 08                         lda   L0820
+00205a 4e57: 85 07                            sta   PixelLine+1
+00205c 4e59: a0 02                            ldy   #$02
+00205e 4e5b: b1 06                            lda   (PixelLine),y
+002060 4e5d: 85 0a                            sta   $0a
+002062 4e5f: c8                               iny
+002063 4e60: b1 06                            lda   (PixelLine),y
+002065 4e62: 85 0b                            sta   $0b
+002067 4e64: ae 09 15                         ldx   Lives
+00206a 4e67: ca                               dex
+00206b 4e68: 86 04                            stx   $04
+00206d 4e6a: a9 60                            lda   #$60
+00206f 4e6c: 85 fc                            sta   PixelLineBaseL
+002071 4e6e: 85 fe                            sta   PixelLineBaseH
+002073 4e70: c6 04        L4E70               dec   $04
+002075 4e72: 30 33                            bmi   L4EA7
+002077 4e74: a5 0a                            lda   $0a
+002079 4e76: 85 08                            sta   Sprite
+00207b 4e78: a5 0b                            lda   $0b
+00207d 4e7a: 85 09                            sta   Sprite+1
+00207f 4e7c: a0 09                            ldy   #$09
+002081 4e7e: a2 00                            ldx   #$00
+002083 4e80: b1 fc        L4E80               lda   (PixelLineBaseL),y
+002085 4e82: 85 06                            sta   PixelLine
+002087 4e84: b1 fe                            lda   (PixelLineBaseH),y
+002089 4e86: 85 07                            sta   PixelLine+1
+00208b 4e88: 84 05                            sty   $05
+00208d 4e8a: a0 27                            ldy   #$27
+00208f 4e8c: a1 08                            lda   (Sprite,x)
+002091 4e8e: 91 06                            sta   (PixelLine),y
+002093 4e90: e6 08                            inc   Sprite
+002095 4e92: e6 08                            inc   Sprite
+002097 4e94: a4 05                            ldy   $05
+002099 4e96: 88                               dey
+00209a 4e97: 10 e7                            bpl   L4E80
+00209c 4e99: a5 fc                            lda   PixelLineBaseL
+00209e 4e9b: 18                               clc
+00209f 4e9c: 69 0b                            adc   #$0b
+0020a1 4e9e: 85 fc                            sta   PixelLineBaseL
+0020a3 4ea0: 85 fe                            sta   PixelLineBaseH
+0020a5 4ea2: c9 a5                            cmp   #$a5
+0020a7 4ea4: 90 ca                            bcc   L4E70
+0020a9 4ea6: 60           @rts                rts

+0020aa 4ea7: a5 fc        L4EA7               lda   PixelLineBaseL
+0020ac 4ea9: c9 a5                            cmp   #$a5
+0020ae 4eab: b0 f9                            bcs   @rts
+0020b0 4ead: a0 09                            ldy   #$09
+0020b2 4eaf: a2 00                            ldx   #$00
+0020b4 4eb1: b1 fc        L4EB1               lda   (PixelLineBaseL),y
+0020b6 4eb3: 85 06                            sta   PixelLine
+0020b8 4eb5: b1 fe                            lda   (PixelLineBaseH),y
+0020ba 4eb7: 85 07                            sta   PixelLine+1
+0020bc 4eb9: a0 27                            ldy   #$27
+0020be 4ebb: 8a                               txa
+0020bf 4ebc: b1 06                            lda   (PixelLine),y
+0020c1 4ebe: a4 05                            ldy   $05
+0020c3 4ec0: 88                               dey
+0020c4 4ec1: 10 ee                            bpl   L4EB1
+0020c6 4ec3: 60                               rts

+0020c7 4ec4: a9 00        stats04             lda   #$00
+0020c9 4ec6: 85 03                            sta   $03
+0020cb 4ec8: 85 04                            sta   $04
+0020cd 4eca: 85 05                            sta   $05
+0020cf 4ecc: a2 18                            ldx   #$18
+0020d1 4ece: 06 00        L4ECE               asl   $00
+0020d3 4ed0: 26 01                            rol   $01
+0020d5 4ed2: 26 02                            rol   $02
+0020d7 4ed4: 2a                               rol   A
+0020d8 4ed5: c9 0a                            cmp   #$0a
+0020da 4ed7: 90 02                            bcc   L4EDB
+0020dc 4ed9: e9 0a                            sbc   #$0a
+0020de 4edb: 26 03        L4EDB               rol   $03
+0020e0 4edd: 26 04                            rol   $04
+0020e2 4edf: 26 05                            rol   $05
+0020e4 4ee1: ca                               dex
+0020e5 4ee2: d0 ea                            bne   L4ECE
+0020e7 4ee4: a6 03                            ldx   $03
+0020e9 4ee6: 86 00                            stx   $00
+0020eb 4ee8: a6 04                            ldx   $04
+0020ed 4eea: 86 01                            stx   $01
+0020ef 4eec: a6 05                            ldx   $05
+0020f1 4eee: 86 02                            stx   $02
+0020f3 4ef0: 60                               rts

                           ********************************************************************************
                           * NW: xor whole screen 7 times (used for protagonist death)                    *
                           ********************************************************************************
+0020f4 4ef1: a9 06        xorScreen7x         lda   #$06
+0020f6 4ef3: 85 00                            sta   $00
+0020f8 4ef5: 20 36 4c                         jsr   randomA                                 ;NW: get random number in A?
+0020fb 4ef8: 85 ca                            sta   $ca                                     ;NW: audio seed 1 [TODO: $ca, $cb sind 2 byte values oder 1 address?]
+0020fd 4efa: a0 00                            ldy   #$00
+0020ff 4efc: 84 fc                            sty   PixelLineBaseL
+002101 4efe: 84 fe                            sty   PixelLineBaseH
+002103 4f00: b1 fc        L4F00               lda   (PixelLineBaseL),y
+002105 4f02: 85 06                            sta   PixelLine
+002107 4f04: b1 fe                            lda   (PixelLineBaseH),y
+002109 4f06: 85 07                            sta   PixelLine+1
+00210b 4f08: a2 20                            ldx   #$20
+00210d 4f0a: 20 36 4c     L4F0A               jsr   randomA
+002110 4f0d: 85 cb                            sta   $cb                                     ;NW: audio seed 2
+002112 4f0f: b1 06        L4F0F               lda   (PixelLine),y
+002114 4f11: 49 ff                            eor   #$ff
+002116 4f13: 91 06                            sta   (PixelLine),y
+002118 4f15: 20 6e 4c                         jsr   doSpeaker
+00211b 4f18: c8                               iny
+00211c 4f19: d0 f4                            bne   L4F0F
+00211e 4f1b: e6 07                            inc   PixelLine+1
+002120 4f1d: ca                               dex
+002121 4f1e: d0 ea                            bne   L4F0A
+002123 4f20: c6 00                            dec   $00
+002125 4f22: d0 dc                            bne   L4F00
+002127 4f24: 60                               rts

                           ; ==========
+002128 4f25: a0 00        clearScreen         ldy   #$00
+00212a 4f27: 84 fc                            sty   PixelLineBaseL
+00212c 4f29: 84 fe                            sty   PixelLineBaseH
+00212e 4f2b: b1 fc                            lda   (PixelLineBaseL),y
+002130 4f2d: 85 06                            sta   PixelLine
+002132 4f2f: b1 fe                            lda   (PixelLineBaseH),y
+002134 4f31: 85 07                            sta   PixelLine+1
+002136 4f33: a2 20                            ldx   #$20
+002138 4f35: a9 00                            lda   #$00                                    ;clear all bits
+00213a 4f37: 91 06        @nextHorizontalByte sta   (PixelLine),y
+00213c 4f39: c8                               iny
+00213d 4f3a: d0 fb                            bne   @nextHorizontalByte
+00213f 4f3c: e6 07                            inc   PixelLine+1
+002141 4f3e: ca                               dex
+002142 4f3f: d0 f6                            bne   @nextHorizontalByte
+002144 4f41: 60                               rts

+002145 4f42: 20 25 4f     showRightStats      jsr   clearScreen
+002148 4f45: 20 1f 4e                         jsr   showScore
+00214b 4f48: 20 4f 4e                         jsr   showLives
+00214e 4f4b: ae 07 14                         ldx   Level                                   ;Level ist stored 0-based, shown 1-based
+002151 4f4e: e8                               inx
+002152 4f4f: 86 00                            stx   $00                                     ;3 temp vars: $00 (level), $01 (init 0), $02 (init 0)
+002154 4f51: a9 00                            lda   #$00
+002156 4f53: 85 01                            sta   $01
+002158 4f55: 85 02                            sta   $02
+00215a 4f57: a9 b8                            lda   #$b8
+00215c 4f59: 85 fc                            sta   PixelLineBaseL
+00215e 4f5b: 20 c4 4e     @loop               jsr   stats04
+002161 4f5e: 18                               clc
+002162 4f5f: 69 b0                            adc   #$b0
+002164 4f61: a4 fc                            ldy   PixelLineBaseL
+002166 4f63: a2 27                            ldx   #$27
+002168 4f65: 20 08 51                         jsr   printChar
+00216b 4f68: a5 fc                            lda   PixelLineBaseL
+00216d 4f6a: 38                               sec
+00216e 4f6b: e9 08                            sbc   #$08
+002170 4f6d: 85 fc                            sta   PixelLineBaseL
+002172 4f6f: a5 00                            lda   $00                                     ;something has happened to $00, doesn't look like a level anymore
+002174 4f71: d0 e8                            bne   @loop
+002176 4f73: 60                               rts

                           ; ==========
+002177 4f74: 48           L4F74               pha
+002178 4f75: ad 03 0c                         lda   L0C03
+00217b 4f78: 38                               sec
+00217c 4f79: ed 05 14                         sbc   $1405
+00217f 4f7c: cd 0b 0c                         cmp   L0C0B
+002182 4f7f: b0 02                            bcs   L4F83
+002184 4f81: 68                               pla
+002185 4f82: 60                               rts

+002186 4f83: 8a           L4F83               txa
+002187 4f84: 20 1c 4c                         jsr   divdeA7
+00218a 4f87: 85 04                            sta   $04
+00218c 4f89: 4a                               lsr   A
+00218d 4f8a: 68                               pla
+00218e 4f8b: 90 0f                            bcc   L4F9C
+002190 4f8d: 48                               pha
+002191 4f8e: 29 80                            and   #$80
+002193 4f90: 85 06                            sta   PixelLine
+002195 4f92: 68                               pla
+002196 4f93: 29 7f                            and   #$7f
+002198 4f95: 4a                               lsr   A
+002199 4f96: b0 02                            bcs   L4F9A
+00219b 4f98: 09 40                            ora   #$40
+00219d 4f9a: 05 06        L4F9A               ora   PixelLine
+00219f 4f9c: 85 06        L4F9C               sta   PixelLine
+0021a1 4f9e: 84 05                            sty   $05
+0021a3 4fa0: ac 0b 0c                         ldy   L0C0B
+0021a6 4fa3: 88                               dey
+0021a7 4fa4: ae 05 14                         ldx   $1405
+0021aa 4fa7: a5 05        L4FA7               lda   $05
+0021ac 4fa9: 9d 70 17                         sta   $1770,x
+0021af 4fac: a5 04                            lda   $04
+0021b1 4fae: 9d c0 17                         sta   $17c0,x
+0021b4 4fb1: a5 06                            lda   PixelLine
+0021b6 4fb3: 39 0c 0d                         and   L0D0C,y
+0021b9 4fb6: 9d 10 18                         sta   $1810,x
+0021bc 4fb9: b9 04 0d                         lda   L0D04,y
+0021bf 4fbc: 9d 60 18                         sta   $1860,x
+0021c2 4fbf: ad 07 0c                         lda   L0C07
+0021c5 4fc2: 9d b0 18                         sta   $18b0,x
+0021c8 4fc5: e8                               inx
+0021c9 4fc6: 88                               dey
+0021ca 4fc7: 10 de                            bpl   L4FA7
+0021cc 4fc9: 8e 05 14                         stx   $1405
+0021cf 4fcc: 60                               rts

                           ********************************************************************************
                           * NW: and 3-byte-wide shape mask to screen (used to erase grunt)               *
                           ********************************************************************************
+0021d0 4fcd: 20 7c 4c     eraseGrunt          jsr   fetchSprite
+0021d3 4fd0: b1 fc        L4FD0               lda   (PixelLineBaseL),y
+0021d5 4fd2: 85 06                            sta   PixelLine
+0021d7 4fd4: b1 fe                            lda   (PixelLineBaseH),y
+0021d9 4fd6: 85 07                            sta   PixelLine+1
+0021db 4fd8: 84 05                            sty   $05
+0021dd 4fda: a4 04                            ldy   $04
+0021df 4fdc: a1 08                            lda   (Sprite,x)
+0021e1 4fde: 31 06                            and   (PixelLine),y
+0021e3 4fe0: 91 06                            sta   (PixelLine),y
+0021e5 4fe2: e6 08                            inc   Sprite
+0021e7 4fe4: c8                               iny
+0021e8 4fe5: a1 08                            lda   (Sprite,x)
+0021ea 4fe7: 31 06                            and   (PixelLine),y
+0021ec 4fe9: 91 06                            sta   (PixelLine),y
+0021ee 4feb: e6 08                            inc   Sprite
+0021f0 4fed: c8                               iny
+0021f1 4fee: a1 08                            lda   (Sprite,x)
+0021f3 4ff0: 31 06                            and   (PixelLine),y
+0021f5 4ff2: 91 06                            sta   (PixelLine),y
+0021f7 4ff4: e6 08                            inc   Sprite
+0021f9 4ff6: a4 05                            ldy   $05
+0021fb 4ff8: 88                               dey
+0021fc 4ff9: 10 d5                            bpl   L4FD0
+0021fe 4ffb: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: store and or 3-byte-wide shape to screen (used to draw grunt)            *
                           ********************************************************************************
+002201 4ffe: 20 7c 4c     drawGrunt           jsr   fetchSprite
+002204 5001: b1 fc        L5001               lda   (PixelLineBaseL),y
+002206 5003: 85 06                            sta   PixelLine
+002208 5005: b1 fe                            lda   (PixelLineBaseH),y
+00220a 5007: 85 07                            sta   PixelLine+1
+00220c 5009: 84 05                            sty   $05
+00220e 500b: a4 04                            ldy   $04
+002210 500d: a1 08                            lda   (Sprite,x)
+002212 500f: 91 06                            sta   (PixelLine),y
+002214 5011: e6 08                            inc   Sprite
+002216 5013: c8                               iny
+002217 5014: a1 08                            lda   (Sprite,x)
+002219 5016: 11 06                            ora   (PixelLine),y
+00221b 5018: 91 06                            sta   (PixelLine),y
+00221d 501a: e6 08                            inc   Sprite
+00221f 501c: c8                               iny
+002220 501d: a1 08                            lda   (Sprite,x)
+002222 501f: 11 06                            ora   (PixelLine),y
+002224 5021: 91 06                            sta   (PixelLine),y
+002226 5023: e6 08                            inc   Sprite
+002228 5025: a4 05                            ldy   $05
+00222a 5027: 88                               dey
+00222b 5028: 10 d7                            bpl   L5001
+00222d 502a: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: xor 2-byte-wide shape mask to screen (used to erase protagonist)         *
                           ********************************************************************************
+002230 502d: 20 7c 4c     eraseYou            jsr   fetchSprite                             ;TODO: used to be named "outerDisplay"
+002233 5030: b1 fc        L5030               lda   (PixelLineBaseL),y
+002235 5032: 85 06                            sta   PixelLine                               ;we will use the pl as base, offset w/ sprite byte (left and right)
+002237 5034: b1 fe                            lda   (PixelLineBaseH),y
+002239 5036: 85 07                            sta   PixelLine+1
+00223b 5038: 84 05                            sty   $05                                     ;save current pl
+00223d 503a: a4 04                            ldy   $04                                     ;first is left sprite byte
+00223f 503c: a1 08                            lda   (Sprite,x)                              ;X is 0, set in fetchSprite before RTS
+002241 503e: 49 ff                            eor   #$ff
+002243 5040: 31 06                            and   (PixelLine),y
+002245 5042: 91 06                            sta   (PixelLine),y
+002247 5044: e6 08                            inc   Sprite
+002249 5046: c8                               iny                                           ;now right sprite byte
+00224a 5047: a1 08                            lda   (Sprite,x)
+00224c 5049: 49 ff                            eor   #$ff
+00224e 504b: 31 06                            and   (PixelLine),y
+002250 504d: 91 06                            sta   (PixelLine),y
+002252 504f: e6 08                            inc   Sprite
+002254 5051: a4 05                            ldy   $05                                     ;dec current pl
+002256 5053: 88                               dey
+002257 5054: 10 da                            bpl   L5030
+002259 5056: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           * NW: or 2-byte-wide shape to screen (used to draw protagonist)                *
                           ********************************************************************************
+00225c 5059: 20 7c 4c     drawYou             jsr   fetchSprite
+00225f 505c: b1 fc        L505C               lda   (PixelLineBaseL),y
+002261 505e: 85 06                            sta   PixelLine
+002263 5060: b1 fe                            lda   (PixelLineBaseH),y
+002265 5062: 85 07                            sta   PixelLine+1
+002267 5064: 84 05                            sty   $05
+002269 5066: a4 04                            ldy   $04
+00226b 5068: a1 08                            lda   (Sprite,x)
+00226d 506a: 11 06                            ora   (PixelLine),y
+00226f 506c: 91 06                            sta   (PixelLine),y
+002271 506e: e6 08                            inc   Sprite
+002273 5070: c8                               iny
+002274 5071: a1 08                            lda   (Sprite,x)
+002276 5073: 11 06                            ora   (PixelLine),y
+002278 5075: 91 06                            sta   (PixelLine),y
+00227a 5077: e6 08                            inc   Sprite
+00227c 5079: a4 05                            ldy   $05
+00227e 507b: 88                               dey
+00227f 507c: 10 de                            bpl   L505C
+002281 507e: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           *                                                                              *
                           * Robonoise                                                                    *
                           *                                                                              *
                           ********************************************************************************
+002284 5081: bd 60 09     initRoboNoise       lda   L0960,x
+002287 5084: 85 06                            sta   PixelLine
+002289 5086: bd 64 09                         lda   L0964,x
+00228c 5089: 85 07                            sta   PixelLine+1
+00228e 508b: a0 00                            ldy   #$00
+002290 508d: b1 06                            lda   (PixelLine),y
+002292 508f: 85 e6                            sta   $e6
+002294 5091: c8                               iny
+002295 5092: b1 06                            lda   (PixelLine),y
+002297 5094: 85 e7                            sta   $e7
+002299 5096: c8                               iny
+00229a 5097: b1 06                            lda   (PixelLine),y
+00229c 5099: 85 e8                            sta   $e8
+00229e 509b: c8                               iny
+00229f 509c: b1 06                            lda   (PixelLine),y
+0022a1 509e: 85 e9                            sta   $e9
+0022a3 50a0: 60                               rts

                           ; NW: randomize 700 to 700+Y, or 700-800 if Y==0
+0022a4 50a1: 84 07        roboNoise01         sty   PixelLine+1
+0022a6 50a3: a0 00                            ldy   #$00
+0022a8 50a5: 84 20                            sty   MON_WNDLEFT
+0022aa 50a7: a9 07                            lda   #$07
+0022ac 50a9: 85 21                            sta   MON_WNDWDTH
+0022ae 50ab: a5 4e        L50AB               lda   MON_RNDL
+0022b0 50ad: 85 06                            sta   PixelLine
+0022b2 50af: a2 07                            ldx   #$07
+0022b4 50b1: 20 36 4c     L50B1               jsr   randomA                                 ;NW: get random number in A?
+0022b7 50b4: c5 0a                            cmp   $0a                                     ;NW: generate random bit in C
+0022b9 50b6: 26 06                            rol   PixelLine                               ;NW: shift C into $06
+0022bb 50b8: ca                               dex                                           ;NW: 7 times
+0022bc 50b9: d0 f6                            bne   L50B1
+0022be 50bb: a5 06                            lda   PixelLine
+0022c0 50bd: 91 20                            sta   (MON_WNDLEFT),y
+0022c2 50bf: c8                               iny
+0022c3 50c0: c4 07                            cpy   PixelLine+1
+0022c5 50c2: d0 e7                            bne   L50AB
+0022c7 50c4: 60                               rts

                           ; NW: animate Robotron logo fade-in
+0022c8 50c5: a0 00        roboNoise           ldy   #$00
+0022ca 50c7: 20 a1 50                         jsr   roboNoise01                             ;NW: randomize 700 to 800
+0022cd 50ca: ad 5b 0c     L50CA               lda   L0C5B
+0022d0 50cd: 85 fc                            sta   PixelLineBaseL
+0022d2 50cf: 85 fe                            sta   PixelLineBaseH
+0022d4 50d1: a5 e8                            lda   $e8
+0022d6 50d3: 85 08                            sta   Sprite
+0022d8 50d5: a5 e9                            lda   $e9
+0022da 50d7: 85 09                            sta   Sprite+1
+0022dc 50d9: a4 e7                            ldy   $e7
+0022de 50db: 88                               dey
+0022df 50dc: a2 00                            ldx   #$00
+0022e1 50de: b1 fc        L50DE               lda   (PixelLineBaseL),y
+0022e3 50e0: 85 06                            sta   PixelLine
+0022e5 50e2: b1 fe                            lda   (PixelLineBaseH),y
+0022e7 50e4: 85 07                            sta   PixelLine+1
+0022e9 50e6: 84 01                            sty   $01
+0022eb 50e8: a5 e6                            lda   $e6
+0022ed 50ea: 85 00                            sta   $00
+0022ef 50ec: ac 5a 0c                         ldy   L0C5A
+0022f2 50ef: a1 08        L50EF               lda   (Sprite,x)
+0022f4 50f1: 21 20                            and   (MON_WNDLEFT,x)
+0022f6 50f3: 91 06                            sta   (PixelLine),y
+0022f8 50f5: e6 20                            inc   MON_WNDLEFT
+0022fa 50f7: e6 08                            inc   Sprite
+0022fc 50f9: d0 02                            bne   L50FD
+0022fe 50fb: e6 09                            inc   Sprite+1
+002300 50fd: c8           L50FD               iny
+002301 50fe: c6 00                            dec   $00
+002303 5100: d0 ed                            bne   L50EF
+002305 5102: a4 01                            ldy   $01
+002307 5104: 88                               dey
+002308 5105: 10 d7                            bpl   L50DE
+00230a 5107: 60                               rts

                           ********************************************************************************
                           * printChar                                                                    *
                           *                                                                              *
                           * X: TextCol                                                                   *
                           * Y: TextPixelLine                                                             *
                           *                                                                              *
                           * NW: store shape on screen (used for score etc)                               *
                           *                                                                              *
                           ********************************************************************************
                           _AsciiLineByteAddr  .var  $08    {addr/2}

+00230b 5108: 84 fc        printChar           sty   PixelLineBaseL                          ;Y has pixel line, saved to low nibble
+00230d 510a: 84 fe                            sty   PixelLineBaseH                          ;high bytes are set in initialisation routine
+00230f 510c: a0 40                            ldy   #$40                                    ;will be ROLd => $8000 first offset
+002311 510e: 84 09                            sty   _AsciiLineByteAddr+1
+002313 5110: 38                               sec
+002314 5111: e9 20                            sbc   #$20                                    ;ascii table begins w/ <space>
+002316 5113: 0a                               asl   A                                       ;A has char, each has 8 pixel lines
+002317 5114: 0a                               asl   A                                       ;3x ASL + ROL = x8 (2 bytes)
+002318 5115: 0a                               asl   A
+002319 5116: 26 09                            rol   _AsciiLineByteAddr+1                    ;(AsciiLineByteAddr) points to char pixel byte
+00231b 5118: 85 08                            sta   _AsciiLineByteAddr
+00231d 511a: a0 07                            ldy   #$07                                    ;each char has 8 pixel lines (BPL)
+00231f 511c: b1 fc        @loop               lda   (PixelLineBaseL),y                      ;determine offset into hires for line
+002321 511e: 8d 29 51                         sta   @savePoint+1
+002324 5121: b1 fe                            lda   (PixelLineBaseH),y
+002326 5123: 8d 2a 51                         sta   @savePoint+2
+002329 5126: b1 08                            lda   (_AsciiLineByteAddr),y                  ;load char pixel line byte
+00232b 5128: 9d ff ff     @savePoint          sta   $ffff,x                                 ;SELF-MODIFIED! - - X is TextCol
+00232e 512b: 88                               dey
+00232f 512c: 10 ee                            bpl   @loop                                   ;BPL goes from #$0-7, i.e. correct first offset
+002331 512e: 60                               rts

                           NOTE: think about isolating PC changes (maybe including branches?)

                           think about Ptr, Offs, Addr
                           uppercase variables or labels?
                           how to mark temp variables?
                           ********************************************************************************
                           * init01                                                                       *
                           *                                                                              *
                           * Looks like AsciiLineByteAddr has a different meaning here, maybe just a temp *
                           * variable                                                                     *
                           *                                                                              *
                           * pages $7A-$7D: sprite table                                                  *
                           * pages $7E-$89: shapes (strobe0)                                              *
                           * pages $90-$bf: strobe[1-6]                                                   *
                           *                                                                              *
                           * sprite table start w/ 2 bytes (width, height), then 6x strobe addr (strobe0  *
                           * = shape, strobe[1-6] shifted)                                                *
                           *                                                                              *
                           * TODO: check if #0 end marker after last entry                                *
                           *                                                                              *
                           ********************************************************************************
                           _spriteEntryPtr     .var  $00    {addr/2}                         ;read: width/height (first 2 bytes), ^shape(^strobe0); write: ^strobe1-^strobe6
                           _strobePtrOffs      .var  $02    {addr/1}
                           _length             .var  $04    {addr/1}
                           _ix                 .var  $05    {addr/1}
                           _strobePtr          .var  $06    {addr/2}                         ;maybe better "_shapePtr"?
                           _destPtr            .var  $08    {addr/2}
                           _colorBit           .var  $0a    {addr/1}

+002332 512f: a9 00        init01_GenerateShapeTables lda #$00
+002334 5131: 85 00                            sta   _spriteEntryPtr
+002336 5133: 85 08                            sta   _destPtr
+002338 5135: a9 7a                            lda   #$7a                                    ;sprite table starts at $7A00
+00233a 5137: 85 01                            sta   _spriteEntryPtr+1
+00233c 5139: a9 90                            lda   #$90                                    ;strobes 1-6 are starting at $9000
+00233e 513b: 85 09                            sta   _destPtr+1
                           ; 
                           ; this is basically a WHILE pattern
+002340 513d: a0 00        @loop1              ldy   #$00
+002342 513f: b1 00                            lda   (_spriteEntryPtr),y                     ;byte 0 = horizontal size in bytes (0 ends)
+002344 5141: 10 01                            bpl   @notExit
+002346 5143: 60                               rts

                           ; (mark: "only reached via branch")
+002347 5144: aa           @notExit            tax
+002348 5145: c8                               iny
+002349 5146: b1 00                            lda   (_spriteEntryPtr),y                     ;byte 1 = vertical size in pixel lines
                           ; 
+00234b 5148: 20 4f 4c                         jsr   multiplyAX                              ;get shape data size (X := width * size)
                           ; 
+00234e 514b: 86 04                            stx   _length
+002350 514d: a9 02                            lda   #$02
+002352 514f: 85 02                            sta   _strobePtrOffs                          ;index of first byte of strobe addresses := #2
                           ; 
                           ; (mark: load ptr from mem)
+002354 5151: a4 02        @loop2              ldy   _strobePtrOffs
+002356 5153: b1 00                            lda   (_spriteEntryPtr),y                     ;shape base addr, low
+002358 5155: 85 06                            sta   _strobePtr
+00235a 5157: c8                               iny
+00235b 5158: b1 00                            lda   (_spriteEntryPtr),y                     ;shape base addr, high
+00235d 515a: 85 07                            sta   _strobePtr+1
                           ; 
+00235f 515c: c8                               iny
+002360 515d: 84 02                            sty   _strobePtrOffs                          ;advance from shape (strobe0) to next strobe (strobe1 ff)
+002362 515f: c0 10                            cpy   #$10                                    ;NW: up to 0F, so $10 bytes per source shape
+002364 5161: 90 10                            bcc   @advanceToNextStrobe                    ;yes, handle this strobe
                           ; 
                           ; (mark: advance to next list entry)
+002366 5163: a5 00                            lda   _spriteEntryPtr                         ;no = done with strobes, do next sprite
+002368 5165: 18                               clc
+002369 5166: 69 10                            adc   #$10                                    ;move to first byte of next sprite entry
+00236b 5168: 85 00                            sta   _spriteEntryPtr
+00236d 516a: a5 01                            lda   _spriteEntryPtr+1
+00236f 516c: 69 00                            adc   #$00                                    ;page++ if ADC crossed page boundary
+002371 516e: 85 01                            sta   _spriteEntryPtr+1
                           ; 
+002373 5170: 38                               sec
+002374 5171: b0 ca                            bcs   @loop1                                  ;mark: SEC/BCS = always branch

+002376 5173: a5 08        @advanceToNextStrobe lda  _destPtr
+002378 5175: 18                               clc
+002379 5176: 65 04                            adc   _length                                 ;all strobes have the same length
+00237b 5178: 90 06                            bcc   @transferStrobePtr
                           ; 
+00237d 517a: e6 09                            inc   _destPtr+1
+00237f 517c: a9 00                            lda   #$00                                    ;strobes must not to extend across page boundaries (probably due to Y access)
+002381 517e: 85 08                            sta   _destPtr
                           ; 
+002383 5180: a5 08        @transferStrobePtr  lda   _destPtr
+002385 5182: 91 00                            sta   (_spriteEntryPtr),y                     ;NW: byte 4 = shifted shape data low
+002387 5184: c8                               iny
+002388 5185: a5 09                            lda   _destPtr+1
+00238a 5187: 91 00                            sta   (_spriteEntryPtr),y                     ;NW: byte 5 = shifted shape data high
                           ; 
+00238c 5189: a0 00                            ldy   #$00
+00238e 518b: 18                               clc
+00238f 518c: 08                               php
+002390 518d: a5 04                            lda   _length
+002392 518f: 85 05                            sta   _ix
                           ; 
+002394 5191: b1 06        @shift              lda   (_strobePtr),y                          ;save color bit
+002396 5193: 29 80                            and   #$80
+002398 5195: 85 0a                            sta   _colorBit
                           ; 
+00239a 5197: b1 06                            lda   (_strobePtr),y
+00239c 5199: 28                               plp
+00239d 519a: 2a                               rol   A
+00239e 519b: 0a                               asl   A
+00239f 519c: 08                               php
+0023a0 519d: 4a                               lsr   A
+0023a1 519e: 05 0a                            ora   _colorBit
+0023a3 51a0: 91 08                            sta   (_destPtr),y
+0023a5 51a2: c8                               iny
+0023a6 51a3: c6 05                            dec   _ix
+0023a8 51a5: d0 ea                            bne   @shift
                           ; 
+0023aa 51a7: 28                               plp                                           ;assumption: can be removed, status flags not used anywhere, so why restore them?
+0023ab 51a8: a5 08                            lda   _destPtr
+0023ad 51aa: 18                               clc
+0023ae 51ab: 65 04                            adc   _length                                 ;we create _length bytes
+0023b0 51ad: 85 08                            sta   _destPtr                                ;advance dest pointer (including boundary check, same as above)
+0023b2 51af: a5 09                            lda   _destPtr+1
+0023b4 51b1: 69 00                            adc   #$00
+0023b6 51b3: 85 09                            sta   _destPtr+1
+0023b8 51b5: 38                               sec
+0023b9 51b6: b0 99                            bcs   @loop2                                  ;NW: always

                           ; NW: 
                           ; print text following JSR
                           ReturnAddr          .var  $22    {addr/2}
                           TextCol             .var  $e0    {addr/1}
                           TextPixelLine       .var  $e1    {addr/1}

+0023bb 51b8: 68           showText            pla
+0023bc 51b9: 85 22                            sta   ReturnAddr                              ;will be incremented while reading chars
+0023be 51bb: 68                               pla
+0023bf 51bc: 85 23                            sta   ReturnAddr+1
+0023c1 51be: 20 e8 51     @mainLoop           jsr   readNextChar                            ;main loop, char in A, NW: get next parameter byte
+0023c4 51c1: aa                               tax                                           ;make sure we have Z flag set if A was #$00 (EOT)
+0023c5 51c2: d0 07                            bne   @isNotEOT                               ;is it 0? (End Of Text), NW: 0 == finished?
+0023c7 51c4: a5 23                            lda   ReturnAddr+1                            ;yes, we reached the end, NW: yes, return
+0023c9 51c6: 48                               pha                                           ;point stack to last byte of buffer (#$00)
+0023ca 51c7: a5 22                            lda   ReturnAddr
+0023cc 51c9: 48                               pha
+0023cd 51ca: 60                               rts                                           ;rts to the position after the stash (terminated w/ #$00)

+0023ce 51cb: c9 0d        @isNotEOT           cmp   #$0d                                    ;start new line?
+0023d0 51cd: d0 0d                            bne   @isNotNewLine                           ;NW: #$0D == set position?
+0023d2 51cf: 20 e8 51                         jsr   readNextChar                            ;NW: yes, get next parameter byte
+0023d5 51d2: 85 e0                            sta   TextCol                                 ;NW: X
+0023d7 51d4: 20 e8 51                         jsr   readNextChar                            ;NW: get next parameter byte
+0023da 51d7: 85 e1                            sta   TextPixelLine                           ;NW: Y
+0023dc 51d9: 4c be 51                         jmp   @mainLoop

+0023df 51dc: a6 e0        @isNotNewLine       ldx   TextCol                                 ;NW: get screen position
+0023e1 51de: a4 e1                            ldy   TextPixelLine
+0023e3 51e0: 20 08 51                         jsr   printChar                               ;NW: draw character on screen
+0023e6 51e3: e6 e0                            inc   TextCol
+0023e8 51e5: 4c be 51                         jmp   @mainLoop

                           ; NW: get next parameter byte
+0023eb 51e8: e6 22        readNextChar        inc   ReturnAddr
+0023ed 51ea: d0 02                            bne   L51EE
+0023ef 51ec: e6 23                            inc   ReturnAddr+1
+0023f1 51ee: a0 00        L51EE               ldy   #$00
+0023f3 51f0: b1 22                            lda   (ReturnAddr),y
+0023f5 51f2: 60                               rts

+0023f6 51f3: 10 10 10 10+                     .fill 12,$10
+002402 51ff: 70                               .dd1  $70

+002403 5200: 4c 0c 52     L5200               jmp   L520C

                           ; JSR entry point
                           ; do something
                           ; then signal with BCC that level is completed...
                           ; ... at least sometimes
+002406 5203: 4c 2e 52     L5203               jmp   showYou

+002409 5206: 4c 1d 55     L5206               jmp   L551D

+00240c 5209: 4c ec 53     L5209               jmp   L53EC

+00240f 520c: a9 78        L520C               lda   #$78
+002411 520e: 8d 00 15                         sta   $1500
+002414 5211: 8d 02 15                         sta   $1502
+002417 5214: a9 5a                            lda   #$5a
+002419 5216: 8d 01 15                         sta   $1501
+00241c 5219: 8d 03 15                         sta   $1503
+00241f 521c: a9 00                            lda   #$00
+002421 521e: 8d 04 15                         sta   $1504
+002424 5221: 8d 05 15                         sta   MovementDir-1
+002427 5224: 8d 06 15                         sta   MovementDir
+00242a 5227: 8d 07 15                         sta   UsedPaddle?-1
+00242d 522a: 8d 08 15                         sta   UsedPaddle?
+002430 522d: 60                               rts

+002431 522e: ad 21 14     showYou             lda   $1421
+002434 5231: f0 4a                            beq   L527D
+002436 5233: ce 21 14                         dec   $1421
+002439 5236: cd 02 0c                         cmp   L0C02
+00243c 5239: d0 40                            bne   L527B
+00243e 523b: ac 05 14                         ldy   $1405
+002441 523e: a9 0b                            lda   #$0b
+002443 5240: 85 00                            sta   _spriteEntryPtr
+002445 5242: ad 00 15                         lda   $1500
+002448 5245: 20 1c 4c                         jsr   divdeA7
+00244b 5248: 85 02                            sta   _strobePtrOffs
+00244d 524a: a5 02        L524A               lda   _strobePtrOffs
+00244f 524c: 99 c0 17                         sta   $17c0,y
+002452 524f: a6 00                            ldx   _spriteEntryPtr
+002454 5251: bd 26 0d                         lda   L0D26,x
+002457 5254: 99 10 18                         sta   $1810,y
+00245a 5257: bd 32 0d                         lda   L0D32,x
+00245d 525a: 99 60 18                         sta   $1860,y
+002460 525d: ae 02 0c                         ldx   L0C02
+002463 5260: 20 4f 4c                         jsr   multiplyAX                              ;NW: get shape data size (X)
+002466 5263: 86 06                            stx   _strobePtr
+002468 5265: a9 60                            lda   #$60
+00246a 5267: 38                               sec
+00246b 5268: e5 06                            sbc   _strobePtr
+00246d 526a: 99 70 17                         sta   $1770,y
+002470 526d: ad 02 0c                         lda   L0C02
+002473 5270: 99 b0 18                         sta   $18b0,y
+002476 5273: c8                               iny
+002477 5274: c6 00                            dec   _spriteEntryPtr
+002479 5276: 10 d2                            bpl   L524A
+00247b 5278: 8c 05 14                         sty   $1405
+00247e 527b: 18           L527B               clc
+00247f 527c: 60                               rts

+002480 527d: ad 06 15     L527D               lda   MovementDir
+002483 5280: 29 03                            and   #$03
+002485 5282: 8d 04 15                         sta   $1504                                   ;max #$03 (see above)
+002488 5285: ad 06 15                         lda   MovementDir
+00248b 5288: 4a                               lsr   A
+00248c 5289: 4a                               lsr   A
+00248d 528a: 8d 05 15                         sta   MovementDir-1
+002490 528d: ad 00 15                         lda   $1500
+002493 5290: ae 04 15                         ldx   $1504
+002496 5293: 18                               clc
+002497 5294: 7d 00 0d                         adc   L0D00,x
+00249a 5297: c9 05                            cmp   #$05
+00249c 5299: 90 04                            bcc   L529F
+00249e 529b: c9 f4                            cmp   #$f4
+0024a0 529d: 90 03                            bcc   L52A2
+0024a2 529f: ad 00 15     L529F               lda   $1500
+0024a5 52a2: 8d 02 15     L52A2               sta   $1502
+0024a8 52a5: ad 01 15                         lda   $1501                                   ;pixel line
+0024ab 52a8: ae 05 15                         ldx   MovementDir-1
+0024ae 52ab: 18                               clc
+0024af 52ac: 7d 00 0d                         adc   L0D00,x
+0024b2 52af: c9 05                            cmp   #$05
+0024b4 52b1: 90 04                            bcc   L52B7
+0024b6 52b3: c9 b1                            cmp   #$b1
+0024b8 52b5: 90 03                            bcc   L52BA
+0024ba 52b7: ad 01 15     L52B7               lda   $1501
+0024bd 52ba: 8d 03 15     L52BA               sta   $1503
+0024c0 52bd: ad 07 15                         lda   UsedPaddle?-1
+0024c3 52c0: 0a                               asl   A
+0024c4 52c1: 0d 08 15                         ora   UsedPaddle?
+0024c7 52c4: 48                               pha
+0024c8 52c5: aa                               tax
+0024c9 52c6: bd 00 08                         lda   L0800,x
+0024cc 52c9: 85 06                            sta   _strobePtr
+0024ce 52cb: bd 20 08                         lda   L0820,x
+0024d1 52ce: 85 07                            sta   _strobePtr+1                            ;=> ($06) = $7a00, param for fetchSprite (outerDisplay starts w/ call to innerDisplay)
+0024d3 52d0: ac 01 15                         ldy   $1501                                   ;param for fetchSprite, pixel line
+0024d6 52d3: ae 00 15                         ldx   $1500                                   ;param for fetchSprite, x coord (?)
+0024d9 52d6: 20 2d 50                         jsr   eraseYou
+0024dc 52d9: 68                               pla
+0024dd 52da: aa                               tax
+0024de 52db: bd 40 08                         lda   L0840,x                                 ;lookup independent of outerDisplay
+0024e1 52de: 85 06                            sta   _strobePtr
+0024e3 52e0: bd 60 08                         lda   L0860,x
+0024e6 52e3: 85 07                            sta   _strobePtr+1                            ;=> ($06) = $7bd0
+0024e8 52e5: ac 01 15                         ldy   $1501
+0024eb 52e8: 88                               dey
+0024ec 52e9: ae 00 15                         ldx   $1500
+0024ef 52ec: ca                               dex
+0024f0 52ed: ca                               dex
+0024f1 52ee: 20 7c 4c                         jsr   fetchSprite
+0024f4 52f1: b1 fc        L52F1               lda   (PixelLineBaseL),y
+0024f6 52f3: 85 06                            sta   _strobePtr
+0024f8 52f5: b1 fe                            lda   (PixelLineBaseH),y
+0024fa 52f7: 85 07                            sta   _strobePtr+1
+0024fc 52f9: 84 05                            sty   _ix                                     ;sprite pixel line
+0024fe 52fb: a4 04                            ldy   _length                                 ;screen byte
+002500 52fd: a1 08                            lda   (_destPtr,x)
+002502 52ff: 31 06                            and   (_strobePtr),y
+002504 5301: f0 03                            beq   L5306
+002506 5303: 20 8d 53                         jsr   L538D
+002509 5306: e6 08        L5306               inc   _destPtr
+00250b 5308: c8                               iny
+00250c 5309: a1 08                            lda   (_destPtr,x)
+00250e 530b: 31 06                            and   (_strobePtr),y
+002510 530d: f0 03                            beq   L5312
+002512 530f: 20 8d 53                         jsr   L538D
+002515 5312: e6 08        L5312               inc   _destPtr
+002517 5314: c8                               iny
+002518 5315: a1 08                            lda   (_destPtr,x)
+00251a 5317: 31 06                            and   (_strobePtr),y
+00251c 5319: f0 03                            beq   L531E
+00251e 531b: 20 8d 53                         jsr   L538D
+002521 531e: e6 08        L531E               inc   _destPtr
+002523 5320: a4 05                            ldy   _ix
+002525 5322: 88                               dey
+002526 5323: 10 cc                            bpl   L52F1
+002528 5325: 20 6e 4c                         jsr   doSpeaker
+00252b 5328: ad 08 15                         lda   UsedPaddle?
+00252e 532b: 49 01                            eor   #$01
+002530 532d: 8d 08 15                         sta   UsedPaddle?
+002533 5330: ad 06 15                         lda   MovementDir
+002536 5333: 8d 07 15                         sta   UsedPaddle?-1
+002539 5336: 0a                               asl   A
+00253a 5337: 0d 08 15                         ora   UsedPaddle?
+00253d 533a: aa                               tax
+00253e 533b: bd 00 08                         lda   L0800,x
+002541 533e: 85 06                            sta   _strobePtr
+002543 5340: bd 20 08                         lda   L0820,x
+002546 5343: 85 07                            sta   _strobePtr+1
+002548 5345: ac 03 15                         ldy   $1503                                   ;some pl (y-coord), starts w/ #$08
+00254b 5348: 8c 01 15                         sty   $1501                                   ;same as $1503
+00254e 534b: ae 02 15                         ldx   $1502                                   ;some x coord?
+002551 534e: 8e 00 15                         stx   $1500                                   ;same as $1502
+002554 5351: 20 7c 4c                         jsr   fetchSprite
+002557 5354: b1 fc        L5354               lda   (PixelLineBaseL),y
+002559 5356: 85 06                            sta   _strobePtr
+00255b 5358: b1 fe                            lda   (PixelLineBaseH),y
+00255d 535a: 85 07                            sta   _strobePtr+1
+00255f 535c: 84 05                            sty   _ix                                     ;ubound of sprite lines (0-based)
+002561 535e: a4 04                            ldy   _length                                 ;x-pos left byte (of sprite), #$01 at first
+002563 5360: b1 06                            lda   (_strobePtr),y                          ;check if any pixels will be overwritten
+002565 5362: 21 08                            and   (_destPtr,x)                            ;X ist immer 0
+002567 5364: f0 03                            beq   L5369
+002569 5366: 20 8d 53                         jsr   L538D
+00256c 5369: a1 08        L5369               lda   (_destPtr,x)
+00256e 536b: 11 06                            ora   (_strobePtr),y                          ;(.LoLoPL),Y = screen byte
+002570 536d: 91 06                            sta   (_strobePtr),y
+002572 536f: e6 08                            inc   _destPtr                                ;X = const (0) => needs to inc $08
+002574 5371: c8                               iny
+002575 5372: b1 06                            lda   (_strobePtr),y
+002577 5374: 21 08                            and   (_destPtr,x)
+002579 5376: f0 03                            beq   L537B
+00257b 5378: 20 8d 53                         jsr   L538D
+00257e 537b: a1 08        L537B               lda   (_destPtr,x)
+002580 537d: 11 06                            ora   (_strobePtr),y
+002582 537f: 91 06                            sta   (_strobePtr),y
+002584 5381: e6 08                            inc   _destPtr                                ;same here w/ $08; no page cross
+002586 5383: a4 05                            ldy   _ix
+002588 5385: 88                               dey
+002589 5386: 10 cc                            bpl   L5354                                   ;0, Y runs through sprite lines
+00258b 5388: 20 6e 4c                         jsr   doSpeaker                               ;no speaker tail call - optimise? (but CLC!)
+00258e 538b: 18                               clc
+00258f 538c: 60                               rts

+002590 538d: 48           L538D               pha
+002591 538e: 8e 00 07                         stx   $0700
+002594 5391: 8c 01 07                         sty   $0701
+002597 5394: a5 fc                            lda   PixelLineBaseL
+002599 5396: 8d 02 07                         sta   $0702
+00259c 5399: a2 05                            ldx   #$05
+00259e 539b: b5 04        L539B               lda   _length,x
+0025a0 539d: 9d 03 07                         sta   $0703,x
+0025a3 53a0: ca                               dex
+0025a4 53a1: 10 f8                            bpl   L539B
+0025a6 53a3: 68                               pla
+0025a7 53a4: 20 8d 59                         jsr   L598D
+0025aa 53a7: a9 01                            lda   #$01
+0025ac 53a9: 85 e8                            sta   $e8
+0025ae 53ab: 20 18 5a                         jsr   L5A18
+0025b1 53ae: b0 24                            bcs   L53D4
+0025b3 53b0: 20 b5 59                         jsr   L59B5
+0025b6 53b3: 90 1f                            bcc   L53D4
+0025b8 53b5: ad 07 15                         lda   UsedPaddle?-1
+0025bb 53b8: 0a                               asl   A
+0025bc 53b9: 0d 08 15                         ora   UsedPaddle?
+0025bf 53bc: aa                               tax
+0025c0 53bd: bd 00 08                         lda   L0800,x
+0025c3 53c0: 85 06                            sta   _strobePtr
+0025c5 53c2: bd 20 08                         lda   L0820,x
+0025c8 53c5: 85 07                            sta   _strobePtr+1
+0025ca 53c7: ae 02 15                         ldx   $1502
+0025cd 53ca: ac 03 15                         ldy   $1503
+0025d0 53cd: 20 59 50                         jsr   drawYou
+0025d3 53d0: 68                               pla
+0025d4 53d1: 68                               pla
+0025d5 53d2: 38                               sec
+0025d6 53d3: 60                               rts

+0025d7 53d4: a2 05        L53D4               ldx   #$05
+0025d9 53d6: bd 03 07     L53D6               lda   $0703,x
+0025dc 53d9: 95 04                            sta   _length,x
+0025de 53db: ca                               dex
+0025df 53dc: 10 f8                            bpl   L53D6
+0025e1 53de: ad 02 07                         lda   $0702
+0025e4 53e1: 85 fc                            sta   PixelLineBaseL
+0025e6 53e3: 85 fe                            sta   PixelLineBaseH
+0025e8 53e5: ac 01 07                         ldy   $0701
+0025eb 53e8: ae 00 07                         ldx   $0700
+0025ee 53eb: 60                               rts

+0025ef 53ec: ad 21 14     L53EC               lda   $1421
+0025f2 53ef: f0 01                            beq   L53F2
+0025f4 53f1: 60           L53F1               rts

+0025f5 53f2: ce 01 14     L53F2               dec   $1401
+0025f8 53f5: 10 fa                            bpl   L53F1
+0025fa 53f7: ee 01 14                         inc   $1401
+0025fd 53fa: ad 16 14                         lda   ShootingDir
+002600 53fd: f0 f2                            beq   L53F1
+002602 53ff: ac 00 14                         ldy   $1400
+002605 5402: cc 00 0c                         cpy   L0C00
+002608 5405: b0 ea                            bcs   L53F1
+00260a 5407: 99 30 15                         sta   $1530,y
+00260d 540a: aa                               tax
+00260e 540b: a9 01                            lda   #$01
+002610 540d: 99 40 15                         sta   $1540,y
+002613 5410: a9 02                            lda   #$02
+002615 5412: 8d 01 14                         sta   $1401
+002618 5415: ee 00 14                         inc   $1400
+00261b 5418: e0 01                            cpx   #$01
+00261d 541a: d0 20                            bne   L543C
+00261f 541c: ad 00 15                         lda   $1500
+002622 541f: 18                               clc
+002623 5420: 69 0b                            adc   #$0b
+002625 5422: 20 1c 4c                         jsr   divdeA7
+002628 5425: 99 20 15                         sta   $1520,y
+00262b 5428: a9 ff                            lda   #$ff
+00262d 542a: 0a           L542A               asl   A
+00262e 542b: ca                               dex
+00262f 542c: 10 fc                            bpl   L542A
+002631 542e: 4a                               lsr   A
+002632 542f: 99 50 15                         sta   $1550,y
+002635 5432: ad 01 15     L5432               lda   $1501
+002638 5435: 18                               clc
+002639 5436: 69 05                            adc   #$05
+00263b 5438: 99 10 15                         sta   $1510,y
+00263e 543b: 60                               rts

+00263f 543c: e0 03        L543C               cpx   #$03
+002641 543e: d0 2a                            bne   L546A
+002643 5440: ad 00 15                         lda   $1500
+002646 5443: 38                               sec
+002647 5444: e9 04                            sbc   #$04
+002649 5446: 20 1c 4c                         jsr   divdeA7
+00264c 5449: 99 20 15                         sta   $1520,y
+00264f 544c: 8a                               txa
+002650 544d: f0 0c                            beq   L545B
+002652 544f: a9 00                            lda   #$00
+002654 5451: 38           L5451               sec
+002655 5452: 2a                               rol   A
+002656 5453: ca                               dex
+002657 5454: 10 fb                            bpl   L5451
+002659 5456: 99 50 15                         sta   $1550,y
+00265c 5459: d0 d7                            bne   L5432
+00265e 545b: a9 7f        L545B               lda   #$7f
+002660 545d: 99 50 15                         sta   $1550,y
+002663 5460: be 20 15                         ldx   $1520,y
+002666 5463: ca                               dex
+002667 5464: 8a                               txa
+002668 5465: 99 20 15                         sta   $1520,y
+00266b 5468: 10 c8                            bpl   L5432
+00266d 546a: e0 04        L546A               cpx   #$04
+00266f 546c: d0 18                            bne   L5486
+002671 546e: ad 01 15                         lda   $1501
+002674 5471: 18                               clc
+002675 5472: 69 0e                            adc   #$0e
+002677 5474: 99 10 15                         sta   $1510,y
+00267a 5477: 20 1c 4c                         jsr   divdeA7
+00267d 547a: 86 00                            stx   _spriteEntryPtr
+00267f 547c: a9 06                            lda   #$06
+002681 547e: 38                               sec
+002682 547f: e5 00                            sbc   _spriteEntryPtr
+002684 5481: 99 60 15                         sta   $1560,y
+002687 5484: 10 1c                            bpl   L54A2
+002689 5486: e0 0c        L5486               cpx   #$0c
+00268b 5488: d0 2f                            bne   L54B9
+00268d 548a: ad 01 15                         lda   $1501
+002690 548d: 38                               sec
+002691 548e: e9 04                            sbc   #$04
+002693 5490: 20 1c 4c                         jsr   divdeA7
+002696 5493: 85 00                            sta   _spriteEntryPtr
+002698 5495: 0a                               asl   A
+002699 5496: 65 00                            adc   _spriteEntryPtr
+00269b 5498: 0a                               asl   A
+00269c 5499: 65 00                            adc   _spriteEntryPtr
+00269e 549b: 99 10 15                         sta   $1510,y
+0026a1 549e: 8a                               txa
+0026a2 549f: 99 60 15                         sta   $1560,y
+0026a5 54a2: ad 00 15     L54A2               lda   $1500
+0026a8 54a5: 18                               clc
+0026a9 54a6: 69 03                            adc   #$03
+0026ab 54a8: 20 1c 4c                         jsr   divdeA7
+0026ae 54ab: 99 20 15                         sta   $1520,y
+0026b1 54ae: a9 00                            lda   #$00
+0026b3 54b0: 38                               sec
+0026b4 54b1: 2a           L54B1               rol   A
+0026b5 54b2: ca                               dex
+0026b6 54b3: 10 fc                            bpl   L54B1
+0026b8 54b5: 99 50 15                         sta   $1550,y
+0026bb 54b8: 60                               rts

+0026bc 54b9: e0 05        L54B9               cpx   #$05
+0026be 54bb: d0 06                            bne   L54C3
+0026c0 54bd: 20 dd 54                         jsr   L54DD
+0026c3 54c0: 4c ef 54                         jmp   L54EF

+0026c6 54c3: e0 07        L54C3               cpx   #$07
+0026c8 54c5: d0 06                            bne   L54CD
+0026ca 54c7: 20 dd 54                         jsr   L54DD
+0026cd 54ca: 4c 06 55                         jmp   L5506

+0026d0 54cd: e0 0d        L54CD               cpx   #$0d
+0026d2 54cf: d0 06                            bne   L54D7
+0026d4 54d1: 20 e5 54                         jsr   L54E5
+0026d7 54d4: 4c ef 54                         jmp   L54EF

+0026da 54d7: 20 e5 54     L54D7               jsr   L54E5
+0026dd 54da: 4c 06 55                         jmp   L5506

+0026e0 54dd: ad 01 15     L54DD               lda   $1501
+0026e3 54e0: 18                               clc
+0026e4 54e1: 69 0c                            adc   #$0c
+0026e6 54e3: 90 06                            bcc   L54EB
+0026e8 54e5: ad 01 15     L54E5               lda   $1501
+0026eb 54e8: 38                               sec
+0026ec 54e9: e9 02                            sbc   #$02
+0026ee 54eb: 99 10 15     L54EB               sta   $1510,y
+0026f1 54ee: 60                               rts

+0026f2 54ef: ad 00 15     L54EF               lda   $1500
+0026f5 54f2: 18                               clc
+0026f6 54f3: 69 09                            adc   #$09
+0026f8 54f5: 20 1c 4c     L54F5               jsr   divdeA7
+0026fb 54f8: 99 20 15                         sta   $1520,y
+0026fe 54fb: a9 00                            lda   #$00
+002700 54fd: 38                               sec
+002701 54fe: 2a           L54FE               rol   A
+002702 54ff: ca                               dex
+002703 5500: 10 fc                            bpl   L54FE
+002705 5502: 99 50 15                         sta   $1550,y
+002708 5505: 60                               rts

+002709 5506: ad 00 15     L5506               lda   $1500
+00270c 5509: 38                               sec
+00270d 550a: e9 02                            sbc   #$02
+00270f 550c: 20 f5 54                         jsr   L54F5
+002712 550f: 4a                               lsr   A
+002713 5510: 90 0a                            bcc   L551C
+002715 5512: 98                               tya
+002716 5513: aa                               tax
+002717 5514: de 20 15                         dec   $1520,x
+00271a 5517: a9 40                            lda   #$40
+00271c 5519: 99 50 15                         sta   $1550,y
+00271f 551c: 60           L551C               rts

+002720 551d: ae 00 14     L551D               ldx   $1400
+002723 5520: ad 21 14                         lda   $1421
+002726 5523: d0 03                            bne   L5528
+002728 5525: ca           L5525               dex
+002729 5526: 10 01                            bpl   L5529
+00272b 5528: 60           L5528               rts

+00272c 5529: 86 00        L5529               stx   _spriteEntryPtr
+00272e 552b: bd 30 15                         lda   $1530,x
+002731 552e: c9 04                            cmp   #$04
+002733 5530: b0 5a                            bcs   L558C
+002735 5532: 49 03                            eor   #$03
+002737 5534: 85 04                            sta   _length
+002739 5536: c6 04                            dec   _length
+00273b 5538: bd 40 15                         lda   $1540,x
+00273e 553b: f0 05                            beq   L5542
+002740 553d: de 40 15                         dec   $1540,x
+002743 5540: 10 18                            bpl   L555A
+002745 5542: 20 37 58     L5542               jsr   drawYouHorizBullets
+002748 5545: a9 7f                            lda   #$7f
+00274a 5547: 9d 50 15                         sta   $1550,x
+00274d 554a: bd 20 15                         lda   $1520,x
+002750 554d: 18                               clc
+002751 554e: 65 04                            adc   _length
+002753 5550: 9d 20 15                         sta   $1520,x
+002756 5553: c9 25                            cmp   #$25
+002758 5555: 90 03                            bcc   L555A
+00275a 5557: 4c 59 59                         jmp   L5959

+00275d 555a: bd 10 15     L555A               lda   $1510,x
+002760 555d: 85 fc                            sta   PixelLineBaseL
+002762 555f: 85 fe                            sta   PixelLineBaseH
+002764 5561: a0 00                            ldy   #$00
+002766 5563: 84 05                            sty   _ix
+002768 5565: b1 fc                            lda   (PixelLineBaseL),y
+00276a 5567: 85 06                            sta   _strobePtr
+00276c 5569: b1 fe                            lda   (PixelLineBaseH),y
+00276e 556b: 85 07                            sta   _strobePtr+1
+002770 556d: bc 20 15                         ldy   $1520,x
+002773 5570: bd 50 15                         lda   $1550,x
+002776 5573: 31 06                            and   (_strobePtr),y
+002778 5575: f0 0b                            beq   L5582
+00277a 5577: 20 aa 59                         jsr   L59AA
+00277d 557a: 90 06                            bcc   L5582
+00277f 557c: 20 37 58                         jsr   drawYouHorizBullets
+002782 557f: 4c 59 59                         jmp   L5959

+002785 5582: bd 50 15     L5582               lda   $1550,x
+002788 5585: 11 06                            ora   (_strobePtr),y
+00278a 5587: 91 06                            sta   (_strobePtr),y
+00278c 5589: 4c 25 55                         jmp   L5525

+00278f 558c: c9 04        L558C               cmp   #$04
+002791 558e: d0 6b                            bne   L55FB
+002793 5590: bd 40 15                         lda   $1540,x
+002796 5593: f0 05                            beq   L559A
+002798 5595: de 40 15                         dec   $1540,x
+00279b 5598: 10 1b                            bpl   L55B5
+00279d 559a: 20 55 58     L559A               jsr   undrawYouVertBullets
+0027a0 559d: a6 00                            ldx   _spriteEntryPtr
+0027a2 559f: bd 10 15                         lda   $1510,x
+0027a5 55a2: 38                               sec
+0027a6 55a3: 7d 60 15                         adc   $1560,x
+0027a9 55a6: 9d 10 15                         sta   $1510,x
+0027ac 55a9: c9 bd                            cmp   #$bd
+0027ae 55ab: 90 03                            bcc   L55B0
+0027b0 55ad: 4c 59 59                         jmp   L5959

+0027b3 55b0: a9 06        L55B0               lda   #$06
+0027b5 55b2: 9d 60 15                         sta   $1560,x
+0027b8 55b5: bd 10 15     L55B5               lda   $1510,x
+0027bb 55b8: 85 fc                            sta   PixelLineBaseL
+0027bd 55ba: 85 fe                            sta   PixelLineBaseH
+0027bf 55bc: bc 60 15                         ldy   $1560,x
+0027c2 55bf: bd 20 15                         lda   $1520,x
+0027c5 55c2: 85 04                            sta   _length
+0027c7 55c4: bd 50 15                         lda   $1550,x
+0027ca 55c7: aa                               tax
+0027cb 55c8: b1 fc        L55C8               lda   (PixelLineBaseL),y
+0027cd 55ca: 85 06                            sta   _strobePtr
+0027cf 55cc: b1 fe                            lda   (PixelLineBaseH),y
+0027d1 55ce: 85 07                            sta   _strobePtr+1
+0027d3 55d0: 84 05                            sty   _ix
+0027d5 55d2: a4 04                            ldy   _length
+0027d7 55d4: 8a                               txa
+0027d8 55d5: 31 06                            and   (_strobePtr),y
+0027da 55d7: f0 13                            beq   L55EC
+0027dc 55d9: 86 01                            stx   _spriteEntryPtr+1
+0027de 55db: a6 00                            ldx   _spriteEntryPtr
+0027e0 55dd: 20 aa 59                         jsr   L59AA
+0027e3 55e0: 90 08                            bcc   L55EA
+0027e5 55e2: 20 55 58                         jsr   undrawYouVertBullets
+0027e8 55e5: a6 1f                            ldx   $1f
+0027ea 55e7: 4c 59 59                         jmp   L5959

+0027ed 55ea: a6 01        L55EA               ldx   _spriteEntryPtr+1
+0027ef 55ec: 8a           L55EC               txa
+0027f0 55ed: 11 06                            ora   (_strobePtr),y
+0027f2 55ef: 91 06                            sta   (_strobePtr),y
+0027f4 55f1: a4 05                            ldy   _ix
+0027f6 55f3: 88                               dey
+0027f7 55f4: 10 d2                            bpl   L55C8
+0027f9 55f6: a6 00                            ldx   _spriteEntryPtr
+0027fb 55f8: 4c 25 55                         jmp   L5525

+0027fe 55fb: c9 0c        L55FB               cmp   #$0c
+002800 55fd: d0 68                            bne   L5667
+002802 55ff: bd 40 15                         lda   $1540,x
+002805 5602: f0 05                            beq   L5609
+002807 5604: de 40 15                         dec   $1540,x
+00280a 5607: 10 18                            bpl   L5621
+00280c 5609: 20 55 58     L5609               jsr   undrawYouVertBullets
+00280f 560c: a6 00                            ldx   _spriteEntryPtr
+002811 560e: bd 10 15                         lda   $1510,x
+002814 5611: 38                               sec
+002815 5612: e9 07                            sbc   #$07
+002817 5614: 9d 10 15                         sta   $1510,x
+00281a 5617: b0 03                            bcs   L561C
+00281c 5619: 4c 59 59                         jmp   L5959

+00281f 561c: a9 06        L561C               lda   #$06
+002821 561e: 9d 60 15                         sta   $1560,x
+002824 5621: bd 10 15     L5621               lda   $1510,x
+002827 5624: 85 fc                            sta   PixelLineBaseL
+002829 5626: 85 fe                            sta   PixelLineBaseH
+00282b 5628: bc 60 15                         ldy   $1560,x
+00282e 562b: bd 20 15                         lda   $1520,x
+002831 562e: 85 04                            sta   _length
+002833 5630: bd 50 15                         lda   $1550,x
+002836 5633: aa                               tax
+002837 5634: b1 fc        L5634               lda   (PixelLineBaseL),y
+002839 5636: 85 06                            sta   _strobePtr
+00283b 5638: b1 fe                            lda   (PixelLineBaseH),y
+00283d 563a: 85 07                            sta   _strobePtr+1
+00283f 563c: 84 05                            sty   _ix
+002841 563e: a4 04                            ldy   _length
+002843 5640: 8a                               txa
+002844 5641: 31 06                            and   (_strobePtr),y
+002846 5643: f0 13                            beq   L5658
+002848 5645: 86 01                            stx   _spriteEntryPtr+1
+00284a 5647: a6 00                            ldx   _spriteEntryPtr
+00284c 5649: 20 aa 59                         jsr   L59AA
+00284f 564c: 90 08                            bcc   L5656
+002851 564e: 20 55 58                         jsr   undrawYouVertBullets
+002854 5651: a6 1f                            ldx   $1f
+002856 5653: 4c 59 59                         jmp   L5959

+002859 5656: a6 01        L5656               ldx   _spriteEntryPtr+1
+00285b 5658: 8a           L5658               txa
+00285c 5659: 11 06                            ora   (_strobePtr),y
+00285e 565b: 91 06                            sta   (_strobePtr),y
+002860 565d: a4 05                            ldy   _ix
+002862 565f: 88                               dey
+002863 5660: 10 d2                            bpl   L5634
+002865 5662: a6 00                            ldx   _spriteEntryPtr
+002867 5664: 4c 25 55                         jmp   L5525

+00286a 5667: c9 05        L5667               cmp   #$05
+00286c 5669: d0 77                            bne   L56E2
+00286e 566b: bd 40 15                         lda   $1540,x
+002871 566e: f0 05                            beq   L5675
+002873 5670: de 40 15                         dec   $1540,x
+002876 5673: 10 23                            bpl   L5698
+002878 5675: 20 83 58     L5675               jsr   undrawYouDiagDRBullets
+00287b 5678: a6 00                            ldx   _spriteEntryPtr
+00287d 567a: a9 01                            lda   #$01
+00287f 567c: 9d 50 15                         sta   $1550,x
+002882 567f: fe 20 15                         inc   $1520,x
+002885 5682: bd 20 15                         lda   $1520,x
+002888 5685: c9 25                            cmp   #$25
+00288a 5687: b0 0c                            bcs   L5695
+00288c 5689: 98                               tya
+00288d 568a: 18                               clc
+00288e 568b: 7d 10 15                         adc   $1510,x
+002891 568e: 9d 10 15                         sta   $1510,x
+002894 5691: c9 bd                            cmp   #$bd
+002896 5693: 90 03                            bcc   L5698
+002898 5695: 4c 59 59     L5695               jmp   L5959

+00289b 5698: bd 20 15     L5698               lda   $1520,x
+00289e 569b: 85 04                            sta   _length
+0028a0 569d: bd 10 15                         lda   $1510,x
+0028a3 56a0: 85 fc                            sta   PixelLineBaseL
+0028a5 56a2: 85 fe                            sta   PixelLineBaseH
+0028a7 56a4: bd 50 15                         lda   $1550,x
+0028aa 56a7: aa                               tax
+0028ab 56a8: a0 00                            ldy   #$00
+0028ad 56aa: b1 fc        L56AA               lda   (PixelLineBaseL),y
+0028af 56ac: 85 06                            sta   _strobePtr
+0028b1 56ae: b1 fe                            lda   (PixelLineBaseH),y
+0028b3 56b0: 85 07                            sta   _strobePtr+1
+0028b5 56b2: 84 05                            sty   _ix
+0028b7 56b4: a4 04                            ldy   _length
+0028b9 56b6: 8a                               txa
+0028ba 56b7: 31 06                            and   (_strobePtr),y
+0028bc 56b9: f0 13                            beq   L56CE
+0028be 56bb: 86 01                            stx   _spriteEntryPtr+1
+0028c0 56bd: a6 00                            ldx   _spriteEntryPtr
+0028c2 56bf: 20 aa 59                         jsr   L59AA
+0028c5 56c2: 90 08                            bcc   L56CC
+0028c7 56c4: 20 83 58                         jsr   undrawYouDiagDRBullets
+0028ca 56c7: a6 1f                            ldx   $1f
+0028cc 56c9: 4c 59 59                         jmp   L5959

+0028cf 56cc: a6 01        L56CC               ldx   _spriteEntryPtr+1
+0028d1 56ce: 8a           L56CE               txa
+0028d2 56cf: 11 06                            ora   (_strobePtr),y
+0028d4 56d1: 91 06                            sta   (_strobePtr),y
+0028d6 56d3: 8a                               txa
+0028d7 56d4: 0a                               asl   A
+0028d8 56d5: 30 06                            bmi   L56DD
+0028da 56d7: aa                               tax
+0028db 56d8: a4 05                            ldy   _ix
+0028dd 56da: c8                               iny
+0028de 56db: d0 cd                            bne   L56AA
+0028e0 56dd: a6 00        L56DD               ldx   _spriteEntryPtr
+0028e2 56df: 4c 25 55                         jmp   L5525

+0028e5 56e2: c9 07        L56E2               cmp   #$07
+0028e7 56e4: d0 71                            bne   L5757
+0028e9 56e6: bd 40 15                         lda   $1540,x
+0028ec 56e9: f0 05                            beq   L56F0
+0028ee 56eb: de 40 15                         dec   $1540,x
+0028f1 56ee: 10 1e                            bpl   L570E
+0028f3 56f0: 20 b9 58     L56F0               jsr   undrawYouDiagDLBullets
+0028f6 56f3: a6 00                            ldx   _spriteEntryPtr
+0028f8 56f5: a9 80                            lda   #$80
+0028fa 56f7: 9d 50 15                         sta   $1550,x
+0028fd 56fa: de 20 15                         dec   $1520,x
+002900 56fd: 30 0c                            bmi   L570B
+002902 56ff: 98                               tya
+002903 5700: 18                               clc
+002904 5701: 7d 10 15                         adc   $1510,x
+002907 5704: 9d 10 15                         sta   $1510,x
+00290a 5707: c9 bd                            cmp   #$bd
+00290c 5709: 90 03                            bcc   L570E
+00290e 570b: 4c 59 59     L570B               jmp   L5959

+002911 570e: bd 20 15     L570E               lda   $1520,x
+002914 5711: 85 04                            sta   _length
+002916 5713: bd 10 15                         lda   $1510,x
+002919 5716: 85 fc                            sta   PixelLineBaseL
+00291b 5718: 85 fe                            sta   PixelLineBaseH
+00291d 571a: bd 50 15                         lda   $1550,x
+002920 571d: aa                               tax
+002921 571e: a0 00                            ldy   #$00
+002923 5720: b1 fc        L5720               lda   (PixelLineBaseL),y
+002925 5722: 85 06                            sta   _strobePtr
+002927 5724: b1 fe                            lda   (PixelLineBaseH),y
+002929 5726: 85 07                            sta   _strobePtr+1
+00292b 5728: 84 05                            sty   _ix
+00292d 572a: a4 04                            ldy   _length
+00292f 572c: 8a                               txa
+002930 572d: 4a                               lsr   A
+002931 572e: b0 22                            bcs   L5752
+002933 5730: aa                               tax
+002934 5731: 31 06                            and   (_strobePtr),y
+002936 5733: f0 13                            beq   L5748
+002938 5735: 86 01                            stx   _spriteEntryPtr+1
+00293a 5737: a6 00                            ldx   _spriteEntryPtr
+00293c 5739: 20 aa 59                         jsr   L59AA
+00293f 573c: 90 08                            bcc   L5746
+002941 573e: 20 b9 58                         jsr   undrawYouDiagDLBullets
+002944 5741: a6 1f                            ldx   $1f
+002946 5743: 4c 59 59                         jmp   L5959

+002949 5746: a6 01        L5746               ldx   _spriteEntryPtr+1
+00294b 5748: 8a           L5748               txa
+00294c 5749: 11 06                            ora   (_strobePtr),y
+00294e 574b: 91 06                            sta   (_strobePtr),y
+002950 574d: a4 05                            ldy   _ix
+002952 574f: c8                               iny
+002953 5750: d0 ce                            bne   L5720
+002955 5752: a6 00        L5752               ldx   _spriteEntryPtr
+002957 5754: 4c 25 55                         jmp   L5525

+00295a 5757: c9 0d        L5757               cmp   #$0d
+00295c 5759: d0 71                            bne   L57CC
+00295e 575b: bd 40 15                         lda   $1540,x
+002961 575e: f0 05                            beq   L5765
+002963 5760: de 40 15                         dec   $1540,x
+002966 5763: 10 1d                            bpl   L5782
+002968 5765: 20 ee 58     L5765               jsr   undrawYouDiagURBullets
+00296b 5768: a6 00                            ldx   _spriteEntryPtr
+00296d 576a: a9 01                            lda   #$01
+00296f 576c: 9d 50 15                         sta   $1550,x
+002972 576f: fe 20 15                         inc   $1520,x
+002975 5772: bd 20 15                         lda   $1520,x
+002978 5775: c9 25                            cmp   #$25
+00297a 5777: b0 06                            bcs   L577F
+00297c 5779: 98                               tya
+00297d 577a: 9d 10 15                         sta   $1510,x
+002980 577d: d0 03                            bne   L5782
+002982 577f: 4c 59 59     L577F               jmp   L5959

+002985 5782: bd 20 15     L5782               lda   $1520,x
+002988 5785: 85 04                            sta   _length
+00298a 5787: a9 00                            lda   #$00
+00298c 5789: 85 fc                            sta   PixelLineBaseL
+00298e 578b: 85 fe                            sta   PixelLineBaseH
+002990 578d: bc 10 15                         ldy   $1510,x
+002993 5790: bd 50 15                         lda   $1550,x
+002996 5793: aa                               tax
+002997 5794: b1 fc        L5794               lda   (PixelLineBaseL),y
+002999 5796: 85 06                            sta   _strobePtr
+00299b 5798: b1 fe                            lda   (PixelLineBaseH),y
+00299d 579a: 85 07                            sta   _strobePtr+1
+00299f 579c: 84 05                            sty   _ix
+0029a1 579e: a4 04                            ldy   _length
+0029a3 57a0: 8a                               txa
+0029a4 57a1: 31 06                            and   (_strobePtr),y
+0029a6 57a3: f0 13                            beq   L57B8
+0029a8 57a5: 86 01                            stx   _spriteEntryPtr+1
+0029aa 57a7: a6 00                            ldx   _spriteEntryPtr
+0029ac 57a9: 20 aa 59                         jsr   L59AA
+0029af 57ac: 90 08                            bcc   L57B6
+0029b1 57ae: 20 ee 58                         jsr   undrawYouDiagURBullets
+0029b4 57b1: a6 1f                            ldx   $1f
+0029b6 57b3: 4c 59 59                         jmp   L5959

+0029b9 57b6: a6 01        L57B6               ldx   _spriteEntryPtr+1
+0029bb 57b8: 8a           L57B8               txa
+0029bc 57b9: 11 06                            ora   (_strobePtr),y
+0029be 57bb: 91 06                            sta   (_strobePtr),y
+0029c0 57bd: 8a                               txa
+0029c1 57be: 0a                               asl   A
+0029c2 57bf: 30 06                            bmi   L57C7
+0029c4 57c1: aa                               tax
+0029c5 57c2: a4 05                            ldy   _ix
+0029c7 57c4: 88                               dey
+0029c8 57c5: d0 cd                            bne   L5794
+0029ca 57c7: a6 00        L57C7               ldx   _spriteEntryPtr
+0029cc 57c9: 4c 25 55                         jmp   L5525

+0029cf 57cc: bd 40 15     L57CC               lda   $1540,x
+0029d2 57cf: f0 05                            beq   L57D6
+0029d4 57d1: de 40 15                         dec   $1540,x
+0029d7 57d4: 10 18                            bpl   L57EE
+0029d9 57d6: 20 24 59     L57D6               jsr   undrawYouDiagULBullets
+0029dc 57d9: a6 00                            ldx   _spriteEntryPtr
+0029de 57db: a9 80                            lda   #$80
+0029e0 57dd: 9d 50 15                         sta   $1550,x
+0029e3 57e0: de 20 15                         dec   $1520,x
+0029e6 57e3: 30 06                            bmi   L57EB
+0029e8 57e5: 98                               tya
+0029e9 57e6: 9d 10 15                         sta   $1510,x
+0029ec 57e9: d0 03                            bne   L57EE
+0029ee 57eb: 4c 59 59     L57EB               jmp   L5959

+0029f1 57ee: bd 20 15     L57EE               lda   $1520,x
+0029f4 57f1: 85 04                            sta   _length
+0029f6 57f3: a9 00                            lda   #$00
+0029f8 57f5: 85 fc                            sta   PixelLineBaseL
+0029fa 57f7: 85 fe                            sta   PixelLineBaseH
+0029fc 57f9: bc 10 15                         ldy   $1510,x
+0029ff 57fc: bd 50 15                         lda   $1550,x
+002a02 57ff: aa                               tax
+002a03 5800: b1 fc        L5800               lda   (PixelLineBaseL),y
+002a05 5802: 85 06                            sta   _strobePtr
+002a07 5804: b1 fe                            lda   (PixelLineBaseH),y
+002a09 5806: 85 07                            sta   _strobePtr+1
+002a0b 5808: 84 05                            sty   _ix
+002a0d 580a: a4 04                            ldy   _length
+002a0f 580c: 8a                               txa
+002a10 580d: 4a                               lsr   A
+002a11 580e: b0 22                            bcs   L5832
+002a13 5810: aa                               tax
+002a14 5811: 31 06                            and   (_strobePtr),y
+002a16 5813: f0 13                            beq   L5828
+002a18 5815: 86 01                            stx   _spriteEntryPtr+1
+002a1a 5817: a6 00                            ldx   _spriteEntryPtr
+002a1c 5819: 20 aa 59                         jsr   L59AA
+002a1f 581c: 90 08                            bcc   L5826
+002a21 581e: 20 24 59                         jsr   undrawYouDiagULBullets
+002a24 5821: a6 1f                            ldx   $1f
+002a26 5823: 4c 59 59                         jmp   L5959

+002a29 5826: a6 01        L5826               ldx   _spriteEntryPtr+1
+002a2b 5828: 8a           L5828               txa
+002a2c 5829: 11 06                            ora   (_strobePtr),y
+002a2e 582b: 91 06                            sta   (_strobePtr),y                          ;NW: draw protagonist's up-left bullets
+002a30 582d: a4 05                            ldy   _ix
+002a32 582f: 88                               dey
+002a33 5830: d0 ce                            bne   L5800
+002a35 5832: a6 00        L5832               ldx   _spriteEntryPtr
+002a37 5834: 4c 25 55                         jmp   L5525

                           ; NW: draw protagonist's horizontal bullets
+002a3a 5837: bd 10 15     drawYouHorizBullets lda   $1510,x
+002a3d 583a: 85 fc                            sta   PixelLineBaseL
+002a3f 583c: 85 fe                            sta   PixelLineBaseH
+002a41 583e: a0 00                            ldy   #$00
+002a43 5840: b1 fc                            lda   (PixelLineBaseL),y
+002a45 5842: 85 06                            sta   _strobePtr
+002a47 5844: b1 fe                            lda   (PixelLineBaseH),y
+002a49 5846: 85 07                            sta   _strobePtr+1
+002a4b 5848: bc 20 15                         ldy   $1520,x
+002a4e 584b: bd 50 15                         lda   $1550,x
+002a51 584e: 49 ff                            eor   #$ff
+002a53 5850: 31 06                            and   (_strobePtr),y
+002a55 5852: 91 06                            sta   (_strobePtr),y
+002a57 5854: 60                               rts

                           ; NW: undraw protagonist's vertical bullets
+002a58 5855: bd 10 15     undrawYouVertBullets lda  $1510,x
+002a5b 5858: 85 fc                            sta   PixelLineBaseL
+002a5d 585a: 85 fe                            sta   PixelLineBaseH
+002a5f 585c: bc 60 15                         ldy   $1560,x
+002a62 585f: bd 20 15                         lda   $1520,x
+002a65 5862: 85 04                            sta   _length
+002a67 5864: bd 50 15                         lda   $1550,x
+002a6a 5867: 49 ff                            eor   #$ff
+002a6c 5869: aa                               tax
+002a6d 586a: b1 fc        L586A               lda   (PixelLineBaseL),y
+002a6f 586c: 85 06                            sta   _strobePtr
+002a71 586e: b1 fe                            lda   (PixelLineBaseH),y
+002a73 5870: 85 07                            sta   _strobePtr+1
+002a75 5872: 84 05                            sty   _ix
+002a77 5874: a4 04                            ldy   _length
+002a79 5876: 8a                               txa
+002a7a 5877: 31 06                            and   (_strobePtr),y
+002a7c 5879: 91 06                            sta   (_strobePtr),y
+002a7e 587b: a4 05                            ldy   _ix
+002a80 587d: 88                               dey
+002a81 587e: 10 ea                            bpl   L586A
+002a83 5880: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ; NW: undraw protagonist's diagonal down-right bullets
+002a86 5883: bd 20 15     undrawYouDiagDRBullets lda $1520,x
+002a89 5886: 85 04                            sta   _length
+002a8b 5888: bd 10 15                         lda   $1510,x
+002a8e 588b: 85 fc                            sta   PixelLineBaseL
+002a90 588d: 85 fe                            sta   PixelLineBaseH
+002a92 588f: bd 50 15                         lda   $1550,x
+002a95 5892: 49 ff                            eor   #$ff
+002a97 5894: aa                               tax
+002a98 5895: a0 00                            ldy   #$00
+002a9a 5897: b1 fc        L5897               lda   (PixelLineBaseL),y
+002a9c 5899: 85 06                            sta   _strobePtr
+002a9e 589b: b1 fe                            lda   (PixelLineBaseH),y
+002aa0 589d: 85 07                            sta   _strobePtr+1
+002aa2 589f: 84 05                            sty   _ix
+002aa4 58a1: a4 04                            ldy   _length
+002aa6 58a3: 8a                               txa
+002aa7 58a4: 31 06                            and   (_strobePtr),y
+002aa9 58a6: 91 06                            sta   (_strobePtr),y
+002aab 58a8: 8a                               txa
+002aac 58a9: 38                               sec
+002aad 58aa: 2a                               rol   A
+002aae 58ab: 10 06                            bpl   L58B3
+002ab0 58ad: aa                               tax
+002ab1 58ae: a4 05                            ldy   _ix
+002ab3 58b0: c8                               iny
+002ab4 58b1: d0 e4                            bne   L5897
+002ab6 58b3: a4 05        L58B3               ldy   _ix
+002ab8 58b5: c8                               iny
+002ab9 58b6: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ; NW: undraw protagonist's diagonal down-left bullets
+002abc 58b9: bd 20 15     undrawYouDiagDLBullets lda $1520,x
+002abf 58bc: 85 04                            sta   _length
+002ac1 58be: bd 10 15                         lda   $1510,x
+002ac4 58c1: 85 fc                            sta   PixelLineBaseL
+002ac6 58c3: 85 fe                            sta   PixelLineBaseH
+002ac8 58c5: bd 50 15                         lda   $1550,x
+002acb 58c8: 49 ff                            eor   #$ff
+002acd 58ca: aa                               tax
+002ace 58cb: a0 00                            ldy   #$00
+002ad0 58cd: b1 fc        L58CD               lda   (PixelLineBaseL),y
+002ad2 58cf: 85 06                            sta   _strobePtr
+002ad4 58d1: b1 fe                            lda   (PixelLineBaseH),y
+002ad6 58d3: 85 07                            sta   _strobePtr+1
+002ad8 58d5: 84 05                            sty   _ix
+002ada 58d7: a4 04                            ldy   _length
+002adc 58d9: 8a                               txa
+002add 58da: 38                               sec
+002ade 58db: 6a                               ror   A
+002adf 58dc: 90 0a                            bcc   L58E8
+002ae1 58de: aa                               tax
+002ae2 58df: 31 06                            and   (_strobePtr),y
+002ae4 58e1: 91 06                            sta   (_strobePtr),y
+002ae6 58e3: a4 05                            ldy   _ix
+002ae8 58e5: c8                               iny
+002ae9 58e6: d0 e5                            bne   L58CD
+002aeb 58e8: a4 05        L58E8               ldy   _ix
+002aed 58ea: c8                               iny
+002aee 58eb: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ; NW: undraw protagonist's diagonal up-right bullets
+002af1 58ee: bd 20 15     undrawYouDiagURBullets lda $1520,x
+002af4 58f1: 85 04                            sta   _length
+002af6 58f3: a9 00                            lda   #$00
+002af8 58f5: 85 fc                            sta   PixelLineBaseL
+002afa 58f7: 85 fe                            sta   PixelLineBaseH
+002afc 58f9: bc 10 15                         ldy   $1510,x
+002aff 58fc: bd 50 15                         lda   $1550,x
+002b02 58ff: 49 ff                            eor   #$ff
+002b04 5901: aa                               tax
+002b05 5902: b1 fc        L5902               lda   (PixelLineBaseL),y
+002b07 5904: 85 06                            sta   _strobePtr
+002b09 5906: b1 fe                            lda   (PixelLineBaseH),y
+002b0b 5908: 85 07                            sta   _strobePtr+1
+002b0d 590a: 84 05                            sty   _ix
+002b0f 590c: a4 04                            ldy   _length
+002b11 590e: 8a                               txa
+002b12 590f: 31 06                            and   (_strobePtr),y
+002b14 5911: 91 06                            sta   (_strobePtr),y
+002b16 5913: 8a                               txa
+002b17 5914: 38                               sec
+002b18 5915: 2a                               rol   A
+002b19 5916: 10 06                            bpl   L591E
+002b1b 5918: aa                               tax
+002b1c 5919: a4 05                            ldy   _ix
+002b1e 591b: 88                               dey
+002b1f 591c: d0 e4                            bne   L5902
+002b21 591e: a4 05        L591E               ldy   _ix
+002b23 5920: 88                               dey
+002b24 5921: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ; NW: undraw protagonist's diagonal up-left bullets
+002b27 5924: bd 20 15     undrawYouDiagULBullets lda $1520,x
+002b2a 5927: 85 04                            sta   _length
+002b2c 5929: a9 00                            lda   #$00
+002b2e 592b: 85 fc                            sta   PixelLineBaseL
+002b30 592d: 85 fe                            sta   PixelLineBaseH
+002b32 592f: bc 10 15                         ldy   $1510,x
+002b35 5932: bd 50 15                         lda   $1550,x
+002b38 5935: 49 ff                            eor   #$ff
+002b3a 5937: aa                               tax
+002b3b 5938: b1 fc        L5938               lda   (PixelLineBaseL),y
+002b3d 593a: 85 06                            sta   _strobePtr
+002b3f 593c: b1 fe                            lda   (PixelLineBaseH),y
+002b41 593e: 85 07                            sta   _strobePtr+1
+002b43 5940: 84 05                            sty   _ix
+002b45 5942: a4 04                            ldy   _length
+002b47 5944: 8a                               txa
+002b48 5945: 38                               sec
+002b49 5946: 6a                               ror   A
+002b4a 5947: 90 0a                            bcc   L5953
+002b4c 5949: aa                               tax
+002b4d 594a: 31 06                            and   (_strobePtr),y
+002b4f 594c: 91 06                            sta   (_strobePtr),y
+002b51 594e: a4 05                            ldy   _ix
+002b53 5950: 88                               dey
+002b54 5951: d0 e5                            bne   L5938
+002b56 5953: a4 05        L5953               ldy   _ix
+002b58 5955: 88                               dey
+002b59 5956: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

                           ********************************************************************************
                           *                                                                              *
                           * something else                                                               *
                           *                                                                              *
                           ********************************************************************************
+002b5c 5959: ce 00 14     L5959               dec   $1400
+002b5f 595c: 8a                               txa
+002b60 595d: 48                               pha
+002b61 595e: bd 11 15     L595E               lda   $1511,x
+002b64 5961: 9d 10 15                         sta   $1510,x
+002b67 5964: bd 21 15                         lda   $1521,x
+002b6a 5967: 9d 20 15                         sta   $1520,x
+002b6d 596a: bd 31 15                         lda   $1531,x
+002b70 596d: 9d 30 15                         sta   $1530,x
+002b73 5970: bd 41 15                         lda   $1541,x
+002b76 5973: 9d 40 15                         sta   $1540,x
+002b79 5976: bd 51 15                         lda   $1551,x
+002b7c 5979: 9d 50 15                         sta   $1550,x
+002b7f 597c: bd 61 15                         lda   $1561,x
+002b82 597f: 9d 60 15                         sta   $1560,x
+002b85 5982: e8                               inx
+002b86 5983: ec 00 14                         cpx   $1400
+002b89 5986: 90 d6                            bcc   L595E
+002b8b 5988: 68                               pla
+002b8c 5989: aa                               tax
+002b8d 598a: 4c 25 55                         jmp   L5525

+002b90 598d: a2 ff        L598D               ldx   #$ff
+002b92 598f: e8           L598F               inx
+002b93 5990: 4a                               lsr   A
+002b94 5991: 90 fc                            bcc   L598F
+002b96 5993: 86 19                            stx   $19
+002b98 5995: 98                               tya
+002b99 5996: 85 1a                            sta   $1a
+002b9b 5998: 0a                               asl   A
+002b9c 5999: 65 1a                            adc   $1a
+002b9e 599b: 0a                               asl   A
+002b9f 599c: 65 1a                            adc   $1a
+002ba1 599e: 65 19                            adc   $19
+002ba3 59a0: 85 1c                            sta   $1c
+002ba5 59a2: a5 fc                            lda   PixelLineBaseL
+002ba7 59a4: 18                               clc
+002ba8 59a5: 65 05                            adc   _ix
+002baa 59a7: 85 1d                            sta   $1d
+002bac 59a9: 60                               rts

+002bad 59aa: 86 1f        L59AA               stx   $1f
+002baf 59ac: 84 1e                            sty   $1e
+002bb1 59ae: 20 8d 59                         jsr   L598D
+002bb4 59b1: a9 00                            lda   #$00
+002bb6 59b3: 85 e8                            sta   $e8
+002bb8 59b5: 20 12 5a     L59B5               jsr   L5A12
+002bbb 59b8: b0 32                            bcs   L59EC
+002bbd 59ba: 20 15 5a                         jsr   L5A15
+002bc0 59bd: b0 2d                            bcs   L59EC
+002bc2 59bf: 20 0c 62                         jsr   L620C
+002bc5 59c2: b0 28                            bcs   L59EC
+002bc7 59c4: 20 0f 62                         jsr   L620F
+002bca 59c7: b0 23                            bcs   L59EC
+002bcc 59c9: 20 12 62                         jsr   L6212
+002bcf 59cc: b0 1e                            bcs   L59EC
+002bd1 59ce: 20 0c 70                         jsr   L700C
+002bd4 59d1: b0 19                            bcs   L59EC
+002bd6 59d3: 20 0f 70                         jsr   L700F
+002bd9 59d6: b0 14                            bcs   L59EC
+002bdb 59d8: 20 12 70                         jsr   L7012
+002bde 59db: b0 0f                            bcs   L59EC
+002be0 59dd: 20 0c 69                         jsr   L690C
+002be3 59e0: b0 0a                            bcs   L59EC
+002be5 59e2: 20 0f 69                         jsr   L690F
+002be8 59e5: b0 05                            bcs   L59EC
+002bea 59e7: 20 12 69                         jsr   L6912
+002bed 59ea: b0 00                            bcs   L59EC
+002bef 59ec: a6 1f        L59EC               ldx   $1f
+002bf1 59ee: a4 1e                            ldy   $1e
+002bf3 59f0: 60                               rts

+002bf4 59f1: 10 10 10 10+                     .fill 14,$10
+002c02 59ff: 70                               .dd1  $70

                           ********************************************************************************
                           * jump table                                                                   *
                           * called from jsr                                                              *
                           ********************************************************************************
+002c03 5a00: 4c 2a 5a     L5A00               jmp   L5A2A

+002c06 5a03: 4c b1 5a     L5A03               jmp   L5AB1

+002c09 5a06: 4c 26 5b     L5A06               jmp   L5B26

+002c0c 5a09: 4c 7e 5b     L5A09               jmp   L5B7E

+002c0f 5a0c: 4c 9f 5c     L5A0C               jmp   L5C9F

+002c12 5a0f: 4c 60 5e     L5A0F               jmp   L5E60

+002c15 5a12: 4c f2 5b     L5A12               jmp   L5BF2

+002c18 5a15: 4c be 5d     L5A15               jmp   L5DBE

+002c1b 5a18: 4c 73 60     L5A18               jmp   L6073

+002c1e 5a1b: 4c 8a 5f     L5A1B               jmp   L5F8A

+002c21 5a1e: 4c e3 5f     L5A1E               jmp   L5FE3

+002c24 5a21: 4c 52 5f     L5A21               jmp   L5F52

+002c27 5a24: 4c 27 61     L5A24               jmp   L6127

+002c2a 5a27: 4c b9 61     L5A27               jmp   L61B9

+002c2d 5a2a: a9 00        L5A2A               lda   #$00                                    ;called from jump table only
+002c2f 5a2c: 8d 08 14                         sta   $1408
+002c32 5a2f: ac 02 14                         ldy   $1402
+002c35 5a32: 98                               tya
+002c36 5a33: 4a                               lsr   A
+002c37 5a34: 4a                               lsr   A
+002c38 5a35: 8d 21 14                         sta   $1421
+002c3b 5a38: 88           L5A38               dey
+002c3c 5a39: 10 16                            bpl   L5A51
+002c3e 5a3b: ad 07 14                         lda   Level
+002c41 5a3e: a2 0a                            ldx   #$0a
+002c43 5a40: 20 00 4c                         jsr   divideAX
+002c46 5a43: ad 0c 0c                         lda   L0C0C
+002c49 5a46: e0 08                            cpx   #$08
+002c4b 5a48: d0 03                            bne   L5A4D
+002c4d 5a4a: ad 0f 0c                         lda   L0C0F
+002c50 5a4d: 8d 03 14     L5A4D               sta   $1403
+002c53 5a50: 60                               rts

+002c54 5a51: 20 36 4c     L5A51               jsr   randomA
+002c57 5a54: c9 a0                            cmp   #$a0
+002c59 5a56: b0 24                            bcs   L5A7C
+002c5b 5a58: a9 f5                            lda   #$f5
+002c5d 5a5a: 20 4b 4c                         jsr   multiplyRndX
+002c60 5a5d: 29 fe                            and   #$fe
+002c62 5a5f: 99 70 15                         sta   $1570,y
+002c65 5a62: a9 22                            lda   #$22
+002c67 5a64: 20 4b 4c                         jsr   multiplyRndX
+002c6a 5a67: 85 00                            sta   _spriteEntryPtr
+002c6c 5a69: a2 00                            ldx   #$00
+002c6e 5a6b: 20 36 4c                         jsr   randomA
+002c71 5a6e: 10 02                            bpl   L5A72
+002c73 5a70: a2 90                            ldx   #$90
+002c75 5a72: 8a           L5A72               txa
+002c76 5a73: 18                               clc
+002c77 5a74: 65 00                            adc   _spriteEntryPtr
+002c79 5a76: 99 f0 15                         sta   $15f0,y
+002c7c 5a79: 38                               sec
+002c7d 5a7a: b0 21                            bcs   L5A9D

+002c7f 5a7c: a9 b2        L5A7C               lda   #$b2
+002c81 5a7e: 20 4b 4c                         jsr   multiplyRndX
+002c84 5a81: 99 f0 15                         sta   $15f0,y
+002c87 5a84: a9 45                            lda   #$45
+002c89 5a86: 20 4b 4c                         jsr   multiplyRndX
+002c8c 5a89: 85 00                            sta   _spriteEntryPtr
+002c8e 5a8b: a2 00                            ldx   #$00
+002c90 5a8d: 20 36 4c                         jsr   randomA
+002c93 5a90: 10 02                            bpl   L5A94
+002c95 5a92: a2 b0                            ldx   #$b0
+002c97 5a94: 8a           L5A94               txa
+002c98 5a95: 18                               clc
+002c99 5a96: 65 00                            adc   _spriteEntryPtr
+002c9b 5a98: 29 fe                            and   #$fe
+002c9d 5a9a: 99 70 15                         sta   $1570,y
+002ca0 5a9d: 20 36 4c     L5A9D               jsr   randomA
+002ca3 5aa0: 29 01                            and   #$01
+002ca5 5aa2: 99 70 16                         sta   $1670,y
+002ca8 5aa5: 98                               tya
+002ca9 5aa6: 4a                               lsr   A
+002caa 5aa7: 4a                               lsr   A
+002cab 5aa8: 18                               clc
+002cac 5aa9: 6d 07 0c                         adc   L0C07
+002caf 5aac: 99 f0 16                         sta   $16f0,y
+002cb2 5aaf: d0 87                            bne   L5A38
+002cb4 5ab1: ac 09 14     L5AB1               ldy   $1409
+002cb7 5ab4: 88           L5AB4               dey
+002cb8 5ab5: 10 01                            bpl   L5AB8
+002cba 5ab7: 60                               rts

+002cbb 5ab8: 20 36 4c     L5AB8               jsr   randomA
+002cbe 5abb: c9 a0                            cmp   #$a0
+002cc0 5abd: b0 25                            bcs   L5AE4
+002cc2 5abf: a9 e6                            lda   #$e6
+002cc4 5ac1: 20 4b 4c                         jsr   multiplyRndX
+002cc7 5ac4: 18                               clc
+002cc8 5ac5: 69 06                            adc   #$06
+002cca 5ac7: 09 01                            ora   #$01
+002ccc 5ac9: 99 00 19                         sta   $1900,y
+002ccf 5acc: a2 06                            ldx   #$06
+002cd1 5ace: 20 36 4c                         jsr   randomA
+002cd4 5ad1: 10 02                            bpl   L5AD5
+002cd6 5ad3: a2 90                            ldx   #$90
+002cd8 5ad5: 86 00        L5AD5               stx   _spriteEntryPtr
+002cda 5ad7: a9 1c                            lda   #$1c
+002cdc 5ad9: 20 4b 4c                         jsr   multiplyRndX
+002cdf 5adc: 18                               clc
+002ce0 5add: 65 00                            adc   _spriteEntryPtr
+002ce2 5adf: 99 10 19                         sta   $1910,y
+002ce5 5ae2: d0 23                            bne   L5B07
+002ce7 5ae4: a9 a6        L5AE4               lda   #$a6
+002ce9 5ae6: 20 4b 4c                         jsr   multiplyRndX
+002cec 5ae9: 18                               clc
+002ced 5aea: 69 06                            adc   #$06
+002cef 5aec: 99 10 19                         sta   $1910,y
+002cf2 5aef: a2 06                            ldx   #$06
+002cf4 5af1: 20 36 4c                         jsr   randomA
+002cf7 5af4: 10 02                            bpl   L5AF8
+002cf9 5af6: a2 c0                            ldx   #$c0
+002cfb 5af8: 86 00        L5AF8               stx   _spriteEntryPtr
+002cfd 5afa: a9 2c                            lda   #$2c
+002cff 5afc: 20 4b 4c                         jsr   multiplyRndX
+002d02 5aff: 18                               clc
+002d03 5b00: 65 00                            adc   _spriteEntryPtr
+002d05 5b02: 09 01                            ora   #$01
+002d07 5b04: 99 00 19                         sta   $1900,y
+002d0a 5b07: 20 36 4c     L5B07               jsr   randomA
+002d0d 5b0a: 29 01                            and   #$01
+002d0f 5b0c: 99 20 19                         sta   $1920,y
+002d12 5b0f: 98                               tya
+002d13 5b10: 29 03                            and   #$03
+002d15 5b12: 99 30 19                         sta   $1930,y
+002d18 5b15: ad 0e 0c                         lda   L0C0E
+002d1b 5b18: 20 4b 4c                         jsr   multiplyRndX
+002d1e 5b1b: 18                               clc
+002d1f 5b1c: 69 03                            adc   #$03
+002d21 5b1e: 09 01                            ora   #$01
+002d23 5b20: 99 40 19                         sta   $1940,y
+002d26 5b23: 4c b4 5a                         jmp   L5AB4

+002d29 5b26: ac 0a 14     L5B26               ldy   $140a
+002d2c 5b29: 88           L5B29               dey
+002d2d 5b2a: 10 19                            bpl   L5B45
+002d2f 5b2c: a9 00                            lda   #$00
+002d31 5b2e: 8d 0b 14                         sta   $140b
+002d34 5b31: 8d 0c 14                         sta   $140c
+002d37 5b34: a9 0a                            lda   #$0a
+002d39 5b36: 8d 0d 14                         sta   $140d
+002d3c 5b39: a9 00                            lda   #$00
+002d3e 5b3b: 8d 05 14                         sta   $1405
+002d41 5b3e: 8d 2c 14                         sta   $142c
+002d44 5b41: 8d 2d 14                         sta   $142d
+002d47 5b44: 60                               rts

+002d48 5b45: a9 f1        L5B45               lda   #$f1
+002d4a 5b47: 20 4b 4c                         jsr   multiplyRndX
+002d4d 5b4a: 18                               clc
+002d4e 5b4b: 69 04                            adc   #$04
+002d50 5b4d: 99 50 19                         sta   $1950,y
+002d53 5b50: a9 ae                            lda   #$ae
+002d55 5b52: 20 4b 4c                         jsr   multiplyRndX
+002d58 5b55: 18                               clc
+002d59 5b56: 69 04                            adc   #$04
+002d5b 5b58: 99 60 19                         sta   $1960,y
+002d5e 5b5b: 20 36 4c                         jsr   randomA
+002d61 5b5e: 29 01                            and   #$01
+002d63 5b60: 99 70 19                         sta   $1970,y
+002d66 5b63: a9 05                            lda   #$05
+002d68 5b65: 20 4b 4c                         jsr   multiplyRndX
+002d6b 5b68: 38                               sec
+002d6c 5b69: e9 02                            sbc   #$02
+002d6e 5b6b: 99 80 19                         sta   $1980,y
+002d71 5b6e: 98                               tya
+002d72 5b6f: 29 03                            and   #$03
+002d74 5b71: 99 a0 19                         sta   $19a0,y
+002d77 5b74: a9 20                            lda   #$20
+002d79 5b76: 20 4b 4c                         jsr   multiplyRndX
+002d7c 5b79: 99 b0 19                         sta   $19b0,y
+002d7f 5b7c: 10 ab                            bpl   L5B29
+002d81 5b7e: ae 02 14     L5B7E               ldx   $1402
+002d84 5b81: ca           L5B81               dex
+002d85 5b82: 10 03                            bpl   L5B87
+002d87 5b84: 4c 08 60                         jmp   L6008

+002d8a 5b87: de f0 16     L5B87               dec   $16f0,x
+002d8d 5b8a: 10 f5                            bpl   L5B81
+002d8f 5b8c: 86 00                            stx   _spriteEntryPtr
+002d91 5b8e: bc 70 16                         ldy   $1670,x
+002d94 5b91: b9 88 08                         lda   L0888,y
+002d97 5b94: 85 06                            sta   _strobePtr
+002d99 5b96: b9 8c 08                         lda   L088C,y
+002d9c 5b99: 85 07                            sta   _strobePtr+1
+002d9e 5b9b: bc f0 15                         ldy   $15f0,x
+002da1 5b9e: bd 70 15                         lda   $1570,x
+002da4 5ba1: aa                               tax
+002da5 5ba2: 20 cd 4f                         jsr   eraseGrunt
+002da8 5ba5: a6 00                            ldx   _spriteEntryPtr
+002daa 5ba7: bd 70 16                         lda   $1670,x
+002dad 5baa: 49 01                            eor   #$01
+002daf 5bac: 9d 70 16                         sta   $1670,x
+002db2 5baf: a8                               tay
+002db3 5bb0: b9 80 08                         lda   L0880,y
+002db6 5bb3: 85 06                            sta   _strobePtr
+002db8 5bb5: b9 84 08                         lda   L0884,y
+002dbb 5bb8: 85 07                            sta   _strobePtr+1
+002dbd 5bba: bd f0 15                         lda   $15f0,x
+002dc0 5bbd: cd 01 15                         cmp   $1501
+002dc3 5bc0: b0 05                            bcs   L5BC7
+002dc5 5bc2: 6d 09 0c                         adc   L0C09
+002dc8 5bc5: 90 03                            bcc   L5BCA
+002dca 5bc7: ed 09 0c     L5BC7               sbc   L0C09
+002dcd 5bca: 9d f0 15     L5BCA               sta   $15f0,x
+002dd0 5bcd: a8                               tay
+002dd1 5bce: bd 70 15                         lda   $1570,x
+002dd4 5bd1: cd 00 15                         cmp   $1500
+002dd7 5bd4: b0 05                            bcs   L5BDB
+002dd9 5bd6: 6d 09 0c                         adc   L0C09
+002ddc 5bd9: 90 03                            bcc   L5BDE
+002dde 5bdb: ed 09 0c     L5BDB               sbc   L0C09
+002de1 5bde: 9d 70 15     L5BDE               sta   $1570,x
+002de4 5be1: aa                               tax
+002de5 5be2: 20 fe 4f                         jsr   drawGrunt
+002de8 5be5: ad 03 14                         lda   $1403
+002deb 5be8: 20 4b 4c                         jsr   multiplyRndX
+002dee 5beb: a6 00                            ldx   _spriteEntryPtr
+002df0 5bed: 9d f0 16                         sta   $16f0,x
+002df3 5bf0: 10 8f                            bpl   L5B81
+002df5 5bf2: ae 02 14     L5BF2               ldx   $1402
+002df8 5bf5: a5 1c                            lda   $1c
+002dfa 5bf7: 38                               sec
+002dfb 5bf8: e9 0b                            sbc   #$0b
+002dfd 5bfa: b0 02                            bcs   L5BFE
+002dff 5bfc: a9 00                            lda   #$00
+002e01 5bfe: a8           L5BFE               tay
+002e02 5bff: a5 1c        L5BFF               lda   $1c
+002e04 5c01: ca           L5C01               dex
+002e05 5c02: 10 02                            bpl   L5C06
+002e07 5c04: 18                               clc
+002e08 5c05: 60                               rts

+002e09 5c06: dd 70 15     L5C06               cmp   $1570,x
+002e0c 5c09: 90 f6                            bcc   L5C01
+002e0e 5c0b: 98                               tya
+002e0f 5c0c: dd 70 15                         cmp   $1570,x
+002e12 5c0f: b0 ee                            bcs   L5BFF
+002e14 5c11: a5 1d                            lda   $1d
+002e16 5c13: dd f0 15                         cmp   $15f0,x
+002e19 5c16: 90 e7                            bcc   L5BFF
+002e1b 5c18: 38                               sec
+002e1c 5c19: e9 0e                            sbc   #$0e
+002e1e 5c1b: 90 05                            bcc   L5C22
+002e20 5c1d: dd f0 15                         cmp   $15f0,x
+002e23 5c20: b0 dd                            bcs   L5BFF
+002e25 5c22: a5 e8        L5C22               lda   $e8
+002e27 5c24: f0 02                            beq   L5C28
+002e29 5c26: 38                               sec
+002e2a 5c27: 60                               rts

+002e2b 5c28: 20 3f 5c     L5C28               jsr   L5C3F
+002e2e 5c2b: ad 04 0c                         lda   L0C04
+002e31 5c2e: 8d 06 14                         sta   Level-1
+002e34 5c31: ad 05 0c                         lda   L0C05
+002e37 5c34: 8d 22 14                         sta   $1422
+002e3a 5c37: ad 06 0c                         lda   L0C06
+002e3d 5c3a: 8d 23 14                         sta   $1423
+002e40 5c3d: 38                               sec
+002e41 5c3e: 60                               rts

+002e42 5c3f: 8a           L5C3F               txa
+002e43 5c40: 48                               pha
+002e44 5c41: aa                               tax
+002e45 5c42: bc 70 16                         ldy   $1670,x
+002e48 5c45: b9 88 08                         lda   L0888,y
+002e4b 5c48: 85 06                            sta   _strobePtr
+002e4d 5c4a: b9 8c 08                         lda   L088C,y
+002e50 5c4d: 85 07                            sta   _strobePtr+1
+002e52 5c4f: bc f0 15                         ldy   $15f0,x
+002e55 5c52: bd 70 15                         lda   $1570,x
+002e58 5c55: aa                               tax
+002e59 5c56: 20 cd 4f                         jsr   eraseGrunt
+002e5c 5c59: 68                               pla
+002e5d 5c5a: 48                               pha
+002e5e 5c5b: aa                               tax
+002e5f 5c5c: bd f0 15                         lda   $15f0,x
+002e62 5c5f: 18                               clc
+002e63 5c60: 69 07                            adc   #$07
+002e65 5c62: a8                               tay
+002e66 5c63: bd 70 15                         lda   $1570,x
+002e69 5c66: 18                               clc
+002e6a 5c67: 69 03                            adc   #$03
+002e6c 5c69: aa                               tax
+002e6d 5c6a: a9 aa                            lda   #$aa
+002e6f 5c6c: 20 74 4f                         jsr   L4F74
+002e72 5c6f: 68                               pla
+002e73 5c70: 48                               pha
+002e74 5c71: aa                               tax
+002e75 5c72: ce 02 14                         dec   $1402
+002e78 5c75: bd 71 15     L5C75               lda   $1571,x
+002e7b 5c78: 9d 70 15                         sta   $1570,x
+002e7e 5c7b: bd f1 15                         lda   $15f1,x
+002e81 5c7e: 9d f0 15                         sta   $15f0,x
+002e84 5c81: bd 71 16                         lda   $1671,x
+002e87 5c84: 9d 70 16                         sta   $1670,x
+002e8a 5c87: bd f1 16                         lda   $16f1,x
+002e8d 5c8a: 9d f0 16                         sta   $16f0,x
+002e90 5c8d: e8                               inx
+002e91 5c8e: ec 02 14                         cpx   $1402
+002e94 5c91: 90 e2                            bcc   L5C75
+002e96 5c93: a9 00                            lda   #$00
+002e98 5c95: a2 64                            ldx   #$64
+002e9a 5c97: 20 d0 4d                         jsr   detectCollision
+002e9d 5c9a: 68                               pla
+002e9e 5c9b: aa                               tax
+002e9f 5c9c: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+002ea2 5c9f: ae 09 14     L5C9F               ldx   $1409
+002ea5 5ca2: ca           L5CA2               dex
+002ea6 5ca3: 10 01                            bpl   L5CA6
+002ea8 5ca5: 60                               rts

+002ea9 5ca6: de 30 19     L5CA6               dec   $1930,x
+002eac 5ca9: 10 f7                            bpl   L5CA2
+002eae 5cab: 86 00                            stx   _spriteEntryPtr
+002eb0 5cad: a9 03                            lda   #$03
+002eb2 5caf: 9d 30 19                         sta   $1930,x
+002eb5 5cb2: de 40 19                         dec   $1940,x
+002eb8 5cb5: 10 28                            bpl   L5CDF
+002eba 5cb7: ad 21 14                         lda   $1421
+002ebd 5cba: d0 13                            bne   L5CCF
+002ebf 5cbc: bd 20 19                         lda   $1920,x
+002ec2 5cbf: 29 02                            and   #$02
+002ec4 5cc1: 49 02                            eor   #$02
+002ec6 5cc3: 85 06                            sta   _strobePtr
+002ec8 5cc5: 20 36 4c                         jsr   randomA
+002ecb 5cc8: 29 01                            and   #$01
+002ecd 5cca: 05 06                            ora   _strobePtr
+002ecf 5ccc: 9d 20 19                         sta   $1920,x
+002ed2 5ccf: ad 0e 0c     L5CCF               lda   L0C0E
+002ed5 5cd2: 20 4b 4c                         jsr   multiplyRndX
+002ed8 5cd5: 18                               clc
+002ed9 5cd6: 69 03                            adc   #$03
+002edb 5cd8: 09 01                            ora   #$01
+002edd 5cda: a4 00                            ldy   _spriteEntryPtr
+002edf 5cdc: 99 40 19                         sta   $1940,y
+002ee2 5cdf: a4 00        L5CDF               ldy   _spriteEntryPtr
+002ee4 5ce1: b9 00 19                         lda   $1900,y
+002ee7 5ce4: be 10 19                         ldx   $1910,y
+002eea 5ce7: a0 0e                            ldy   #$0e
+002eec 5ce9: 20 21 4d                         jsr   eraseHulk
+002eef 5cec: a4 00                            ldy   _spriteEntryPtr
+002ef1 5cee: ad 21 14                         lda   $1421
+002ef4 5cf1: f0 07                            beq   L5CFA
+002ef6 5cf3: b9 20 19                         lda   $1920,y
+002ef9 5cf6: 0a                               asl   A
+002efa 5cf7: aa                               tax
+002efb 5cf8: 10 63                            bpl   L5D5D
+002efd 5cfa: be 20 19     L5CFA               ldx   $1920,y
+002f00 5cfd: b9 00 19                         lda   $1900,y
+002f03 5d00: 18                               clc
+002f04 5d01: 7d 14 0d                         adc   L0D14,x
+002f07 5d04: c9 06                            cmp   #$06
+002f09 5d06: 90 04                            bcc   L5D0C
+002f0b 5d08: c9 ed                            cmp   #$ed
+002f0d 5d0a: 90 0c                            bcc   L5D18
+002f0f 5d0c: 20 36 4c     L5D0C               jsr   randomA
+002f12 5d0f: 29 01                            and   #$01
+002f14 5d11: 09 02                            ora   #$02
+002f16 5d13: 99 20 19                         sta   $1920,y
+002f19 5d16: d0 e2                            bne   L5CFA

+002f1b 5d18: 99 00 19     L5D18               sta   $1900,y
+002f1e 5d1b: 18                               clc
+002f1f 5d1c: 69 10                            adc   #$10
+002f21 5d1e: 85 1a                            sta   $1a
+002f23 5d20: e9 19                            sbc   #$19
+002f25 5d22: b0 02                            bcs   L5D26
+002f27 5d24: a9 00                            lda   #$00
+002f29 5d26: 85 1b        L5D26               sta   $1b
+002f2b 5d28: be 20 19     L5D28               ldx   $1920,y
+002f2e 5d2b: b9 10 19                         lda   $1910,y
+002f31 5d2e: 18                               clc
+002f32 5d2f: 7d 18 0d                         adc   L0D18,x
+002f35 5d32: c9 06                            cmp   #$06
+002f37 5d34: 90 04                            bcc   L5D3A
+002f39 5d36: c9 ac                            cmp   #$ac
+002f3b 5d38: 90 0a                            bcc   L5D44
+002f3d 5d3a: 20 36 4c     L5D3A               jsr   randomA
+002f40 5d3d: 29 01                            and   #$01
+002f42 5d3f: 99 20 19                         sta   $1920,y
+002f45 5d42: 10 e4                            bpl   L5D28

+002f47 5d44: 99 10 19     L5D44               sta   $1910,y
+002f4a 5d47: 18                               clc
+002f4b 5d48: 69 11                            adc   #$11
+002f4d 5d4a: 85 1c                            sta   $1c
+002f4f 5d4c: e9 1d                            sbc   #$1d
+002f51 5d4e: b0 02                            bcs   L5D52
+002f53 5d50: a9 00                            lda   #$00
+002f55 5d52: 85 1d        L5D52               sta   $1d
+002f57 5d54: b9 40 19                         lda   $1940,y
+002f5a 5d57: 4a                               lsr   A
+002f5b 5d58: b9 20 19                         lda   $1920,y
+002f5e 5d5b: 2a                               rol   A
+002f5f 5d5c: aa                               tax
+002f60 5d5d: bd 90 08     L5D5D               lda   L0890,x
+002f63 5d60: 85 06                            sta   _strobePtr
+002f65 5d62: bd 98 08                         lda   L0898,x
+002f68 5d65: 85 07                            sta   _strobePtr+1
+002f6a 5d67: be 00 19                         ldx   $1900,y
+002f6d 5d6a: b9 10 19                         lda   $1910,y
+002f70 5d6d: a8                               tay
+002f71 5d6e: 20 f6 4c                         jsr   drawHulk
+002f74 5d71: ad 21 14                         lda   $1421
+002f77 5d74: d0 43                            bne   L5DB9
+002f79 5d76: ae 0a 14                         ldx   $140a
+002f7c 5d79: a4 1b                            ldy   $1b
+002f7e 5d7b: a5 1a        L5D7B               lda   $1a
+002f80 5d7d: ca           L5D7D               dex
+002f81 5d7e: 30 39                            bmi   L5DB9
+002f83 5d80: dd 50 19                         cmp   $1950,x
+002f86 5d83: 90 f8                            bcc   L5D7D
+002f88 5d85: 98                               tya
+002f89 5d86: dd 50 19                         cmp   $1950,x
+002f8c 5d89: b0 f0                            bcs   L5D7B
+002f8e 5d8b: a5 1c                            lda   $1c
+002f90 5d8d: dd 60 19                         cmp   $1960,x
+002f93 5d90: 90 e9                            bcc   L5D7B
+002f95 5d92: a5 1d                            lda   $1d
+002f97 5d94: dd 60 19                         cmp   $1960,x
+002f9a 5d97: b0 e2                            bcs   L5D7B
+002f9c 5d99: 8a                               txa
+002f9d 5d9a: 48                               pha
+002f9e 5d9b: a8                               tay
+002f9f 5d9c: be 60 19                         ldx   $1960,y
+002fa2 5d9f: b9 50 19                         lda   $1950,y
+002fa5 5da2: a0 0a                            ldy   #$0a
+002fa7 5da4: 20 d0 4c                         jsr   eraseFamily
+002faa 5da7: 68                               pla
+002fab 5da8: aa                               tax
+002fac 5da9: 48                               pha
+002fad 5daa: bc 60 19                         ldy   $1960,x
+002fb0 5dad: bd 50 19                         lda   $1950,x
+002fb3 5db0: aa                               tax
+002fb4 5db1: 20 27 61                         jsr   L6127
+002fb7 5db4: 68                               pla
+002fb8 5db5: aa                               tax
+002fb9 5db6: 20 52 5f                         jsr   L5F52
+002fbc 5db9: a6 00        L5DB9               ldx   _spriteEntryPtr
+002fbe 5dbb: 4c a2 5c                         jmp   L5CA2

+002fc1 5dbe: ae 09 14     L5DBE               ldx   $1409
+002fc4 5dc1: a5 1c                            lda   $1c
+002fc6 5dc3: 38                               sec
+002fc7 5dc4: e9 0d                            sbc   #$0d
+002fc9 5dc6: b0 02                            bcs   L5DCA
+002fcb 5dc8: a9 00                            lda   #$00
+002fcd 5dca: a8           L5DCA               tay
+002fce 5dcb: a5 1c        L5DCB               lda   $1c
+002fd0 5dcd: ca           L5DCD               dex
+002fd1 5dce: 10 02                            bpl   L5DD2
+002fd3 5dd0: 18                               clc
+002fd4 5dd1: 60                               rts

+002fd5 5dd2: dd 00 19     L5DD2               cmp   $1900,x
+002fd8 5dd5: 90 f6                            bcc   L5DCD
+002fda 5dd7: 98                               tya
+002fdb 5dd8: dd 00 19                         cmp   $1900,x
+002fde 5ddb: b0 ee                            bcs   L5DCB
+002fe0 5ddd: a5 1d                            lda   $1d
+002fe2 5ddf: dd 10 19                         cmp   $1910,x
+002fe5 5de2: 90 e7                            bcc   L5DCB
+002fe7 5de4: 38                               sec
+002fe8 5de5: e9 0e                            sbc   #$0e
+002fea 5de7: 90 05                            bcc   L5DEE
+002fec 5de9: dd 10 19                         cmp   $1910,x
+002fef 5dec: b0 dd                            bcs   L5DCB
+002ff1 5dee: a5 e8        L5DEE               lda   $e8
+002ff3 5df0: f0 02                            beq   L5DF4
+002ff5 5df2: 38                               sec
+002ff6 5df3: 60                               rts

+002ff7 5df4: 8a           L5DF4               txa
+002ff8 5df5: 48                               pha
+002ff9 5df6: a8                               tay
+002ffa 5df7: be 10 19                         ldx   $1910,y
+002ffd 5dfa: b9 00 19                         lda   $1900,y
+003000 5dfd: a0 0e                            ldy   #$0e
+003002 5dff: 20 21 4d                         jsr   eraseHulk
+003005 5e02: 68                               pla
+003006 5e03: aa                               tax
+003007 5e04: 20 26 5e                         jsr   L5E26
+00300a 5e07: bd 40 19                         lda   $1940,x
+00300d 5e0a: 4a                               lsr   A
+00300e 5e0b: bd 20 19                         lda   $1920,x
+003011 5e0e: 2a                               rol   A
+003012 5e0f: a8                               tay
+003013 5e10: b9 90 08                         lda   L0890,y
+003016 5e13: 85 06                            sta   _strobePtr
+003018 5e15: b9 98 08                         lda   L0898,y
+00301b 5e18: 85 07                            sta   _strobePtr+1
+00301d 5e1a: bc 10 19                         ldy   $1910,x
+003020 5e1d: bd 00 19                         lda   $1900,x
+003023 5e20: aa                               tax
+003024 5e21: 20 f6 4c                         jsr   drawHulk
+003027 5e24: 38                               sec
+003028 5e25: 60                               rts

+003029 5e26: a4 1f        L5E26               ldy   $1f
+00302b 5e28: b9 30 15                         lda   $1530,y
+00302e 5e2b: 48                               pha
+00302f 5e2c: 29 03                            and   #$03
+003031 5e2e: a8                               tay
+003032 5e2f: bd 00 19                         lda   $1900,x
+003035 5e32: 18                               clc
+003036 5e33: 79 00 0d                         adc   L0D00,y
+003039 5e36: c9 06                            cmp   #$06
+00303b 5e38: b0 02                            bcs   L5E3C
+00303d 5e3a: 69 04                            adc   #$04
+00303f 5e3c: c9 ed        L5E3C               cmp   #$ed
+003041 5e3e: 90 02                            bcc   L5E42
+003043 5e40: e9 04                            sbc   #$04
+003045 5e42: 9d 00 19     L5E42               sta   $1900,x
+003048 5e45: 68                               pla
+003049 5e46: 4a                               lsr   A
+00304a 5e47: 4a                               lsr   A
+00304b 5e48: a8                               tay
+00304c 5e49: bd 10 19                         lda   $1910,x
+00304f 5e4c: 18                               clc
+003050 5e4d: 79 00 0d                         adc   L0D00,y
+003053 5e50: c9 06                            cmp   #$06
+003055 5e52: b0 02                            bcs   L5E56
+003057 5e54: 69 04                            adc   #$04
+003059 5e56: c9 ac        L5E56               cmp   #$ac
+00305b 5e58: 90 02                            bcc   L5E5C
+00305d 5e5a: e9 04                            sbc   #$04
+00305f 5e5c: 9d 10 19     L5E5C               sta   $1910,x
+003062 5e5f: 60                               rts

+003063 5e60: ae 0a 14     L5E60               ldx   $140a
+003066 5e63: ca           L5E63               dex
+003067 5e64: 10 03                            bpl   L5E69
+003069 5e66: 4c b0 60                         jmp   L60B0

+00306c 5e69: de a0 19     L5E69               dec   $19a0,x
+00306f 5e6c: 10 f5                            bpl   L5E63
+003071 5e6e: 86 00                            stx   _spriteEntryPtr
+003073 5e70: ad 08 0c                         lda   L0C08
+003076 5e73: 9d a0 19                         sta   $19a0,x
+003079 5e76: de b0 19                         dec   $19b0,x
+00307c 5e79: 10 1e                            bpl   L5E99
+00307e 5e7b: 20 36 4c                         jsr   randomA
+003081 5e7e: 29 01                            and   #$01
+003083 5e80: 9d 70 19                         sta   $1970,x
+003086 5e83: a9 05                            lda   #$05
+003088 5e85: 20 4b 4c                         jsr   multiplyRndX
+00308b 5e88: 38                               sec
+00308c 5e89: e9 02                            sbc   #$02
+00308e 5e8b: a4 00                            ldy   _spriteEntryPtr
+003090 5e8d: 99 80 19                         sta   $1980,y
+003093 5e90: ad 0a 0c                         lda   L0C0A
+003096 5e93: 20 4b 4c                         jsr   multiplyRndX
+003099 5e96: 99 b0 19                         sta   $19b0,y
+00309c 5e99: a4 00        L5E99               ldy   _spriteEntryPtr
+00309e 5e9b: be 60 19                         ldx   $1960,y
+0030a1 5e9e: b9 50 19                         lda   $1950,y
+0030a4 5ea1: a0 0a                            ldy   #$0a
+0030a6 5ea3: 20 d0 4c                         jsr   eraseFamily
+0030a9 5ea6: a4 00                            ldy   _spriteEntryPtr
+0030ab 5ea8: b9 50 19     L5EA8               lda   $1950,y
+0030ae 5eab: be 70 19                         ldx   $1970,y
+0030b1 5eae: 18                               clc
+0030b2 5eaf: 7d 1c 0d                         adc   L0D1C,x
+0030b5 5eb2: c9 04                            cmp   #$04
+0030b7 5eb4: 90 04                            bcc   L5EBA
+0030b9 5eb6: c9 f5                            cmp   #$f5
+0030bb 5eb8: 90 08                            bcc   L5EC2
+0030bd 5eba: 8a           L5EBA               txa
+0030be 5ebb: 49 01                            eor   #$01
+0030c0 5ebd: 99 70 19                         sta   $1970,y
+0030c3 5ec0: 10 e6                            bpl   L5EA8
+0030c5 5ec2: 99 50 19     L5EC2               sta   $1950,y
+0030c8 5ec5: b9 60 19                         lda   $1960,y
+0030cb 5ec8: 18                               clc
+0030cc 5ec9: 79 80 19                         adc   $1980,y
+0030cf 5ecc: c9 04                            cmp   #$04
+0030d1 5ece: 90 04                            bcc   L5ED4
+0030d3 5ed0: c9 b2                            cmp   #$b2
+0030d5 5ed2: 90 08                            bcc   L5EDC
+0030d7 5ed4: a9 00        L5ED4               lda   #$00
+0030d9 5ed6: 99 80 19                         sta   $1980,y
+0030dc 5ed9: b9 60 19                         lda   $1960,y
+0030df 5edc: 99 60 19     L5EDC               sta   $1960,y
+0030e2 5edf: b9 90 19                         lda   $1990,y
+0030e5 5ee2: 0a                               asl   A
+0030e6 5ee3: 19 70 19                         ora   $1970,y
+0030e9 5ee6: 0a                               asl   A
+0030ea 5ee7: 85 06                            sta   _strobePtr
+0030ec 5ee9: b9 b0 19                         lda   $19b0,y
+0030ef 5eec: 29 01                            and   #$01
+0030f1 5eee: 05 06                            ora   _strobePtr
+0030f3 5ef0: aa                               tax
+0030f4 5ef1: bd a0 08                         lda   L08A0,x
+0030f7 5ef4: 85 06                            sta   _strobePtr
+0030f9 5ef6: bd b0 08                         lda   L08B0,x
+0030fc 5ef9: 85 07                            sta   _strobePtr+1
+0030fe 5efb: be 50 19                         ldx   $1950,y
+003101 5efe: b9 60 19                         lda   $1960,y
+003104 5f01: a8                               tay
+003105 5f02: 20 ac 4c                         jsr   drawFamily
+003108 5f05: a6 00                            ldx   _spriteEntryPtr
+00310a 5f07: 4c 63 5e                         jmp   L5E63

+00310d 5f0a: bd 60 19     L5F0A               lda   $1960,x
+003110 5f0d: 18                               clc
+003111 5f0e: 69 02                            adc   #$02
+003113 5f10: 48                               pha
+003114 5f11: bd 50 19                         lda   $1950,x
+003117 5f14: 38                               sec
+003118 5f15: e9 04                            sbc   #$04
+00311a 5f17: 48                               pha
+00311b 5f18: 20 52 5f                         jsr   L5F52
+00311e 5f1b: ad 0d 14                         lda   $140d
+003121 5f1e: a2 0a                            ldx   #$0a
+003123 5f20: 20 00 4c                         jsr   divideAX
+003126 5f23: 38                               sec
+003127 5f24: e9 01                            sbc   #$01
+003129 5f26: 85 06                            sta   _strobePtr
+00312b 5f28: 68                               pla
+00312c 5f29: aa                               tax
+00312d 5f2a: 68                               pla
+00312e 5f2b: a8                               tay
+00312f 5f2c: a5 06                            lda   _strobePtr
+003131 5f2e: 20 b9 61                         jsr   L61B9
+003134 5f31: ad 0d 14                         lda   $140d
+003137 5f34: a2 64                            ldx   #$64
+003139 5f36: 20 4f 4c                         jsr   multiplyAX
+00313c 5f39: 20 d0 4d                         jsr   detectCollision
+00313f 5f3c: ad 0d 14                         lda   $140d
+003142 5f3f: 18                               clc
+003143 5f40: 69 0a                            adc   #$0a
+003145 5f42: c9 33                            cmp   #$33
+003147 5f44: b0 03                            bcs   L5F49
+003149 5f46: 8d 0d 14                         sta   $140d
+00314c 5f49: ad 68 0c     L5F49               lda   L0C68
+00314f 5f4c: 8d 0b 14                         sta   $140b
+003152 5f4f: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+003155 5f52: 8a           L5F52               txa
+003156 5f53: 48                               pha
+003157 5f54: ce 0a 14                         dec   $140a
+00315a 5f57: bd 51 19     L5F57               lda   $1951,x
+00315d 5f5a: 9d 50 19                         sta   $1950,x
+003160 5f5d: bd 61 19                         lda   $1961,x
+003163 5f60: 9d 60 19                         sta   $1960,x
+003166 5f63: bd 71 19                         lda   $1971,x
+003169 5f66: 9d 70 19                         sta   $1970,x
+00316c 5f69: bd 81 19                         lda   $1981,x
+00316f 5f6c: 9d 80 19                         sta   $1980,x
+003172 5f6f: bd 91 19                         lda   $1991,x
+003175 5f72: 9d 90 19                         sta   $1990,x
+003178 5f75: bd a1 19                         lda   $19a1,x
+00317b 5f78: 9d a0 19                         sta   $19a0,x
+00317e 5f7b: bd b1 19                         lda   $19b1,x
+003181 5f7e: 9d b0 19                         sta   $19b0,x
+003184 5f81: e8                               inx
+003185 5f82: ec 0a 14                         cpx   $140a
+003188 5f85: 90 d0                            bcc   L5F57
+00318a 5f87: 68                               pla
+00318b 5f88: aa                               tax
+00318c 5f89: 60                               rts

+00318d 5f8a: ae 05 14     L5F8A               ldx   $1405
+003190 5f8d: a9 00                            lda   #$00
+003192 5f8f: 85 fc                            sta   PixelLineBaseL
+003194 5f91: 85 fe                            sta   PixelLineBaseH
+003196 5f93: ca           L5F93               dex
+003197 5f94: 10 01                            bpl   L5F97
+003199 5f96: 60                               rts

+00319a 5f97: bc 70 17     L5F97               ldy   $1770,x
+00319d 5f9a: b1 fc                            lda   (PixelLineBaseL),y
+00319f 5f9c: 85 06                            sta   _strobePtr
+0031a1 5f9e: b1 fe                            lda   (PixelLineBaseH),y
+0031a3 5fa0: 85 07                            sta   _strobePtr+1
+0031a5 5fa2: bc c0 17                         ldy   $17c0,x
+0031a8 5fa5: a9 00                            lda   #$00
+0031aa 5fa7: 91 06                            sta   (_strobePtr),y
+0031ac 5fa9: bd 70 17                         lda   $1770,x
+0031af 5fac: 18                               clc
+0031b0 5fad: 7d 60 18                         adc   $1860,x
+0031b3 5fb0: 9d 70 17                         sta   $1770,x
+0031b6 5fb3: de b0 18                         dec   $18b0,x
+0031b9 5fb6: d0 db                            bne   L5F93
+0031bb 5fb8: 8a                               txa
+0031bc 5fb9: a8                               tay
+0031bd 5fba: ce 05 14                         dec   $1405
+0031c0 5fbd: b9 71 17     L5FBD               lda   $1771,y
+0031c3 5fc0: 99 70 17                         sta   $1770,y
+0031c6 5fc3: b9 c1 17                         lda   $17c1,y
+0031c9 5fc6: 99 c0 17                         sta   $17c0,y
+0031cc 5fc9: b9 11 18                         lda   $1811,y
+0031cf 5fcc: 99 10 18                         sta   $1810,y
+0031d2 5fcf: b9 61 18                         lda   $1861,y
+0031d5 5fd2: 99 60 18                         sta   $1860,y
+0031d8 5fd5: b9 b1 18                         lda   $18b1,y
+0031db 5fd8: 99 b0 18                         sta   $18b0,y
+0031de 5fdb: c8                               iny
+0031df 5fdc: cc 05 14                         cpy   $1405
+0031e2 5fdf: 90 dc                            bcc   L5FBD
+0031e4 5fe1: b0 b0                            bcs   L5F93

+0031e6 5fe3: ae 05 14     L5FE3               ldx   $1405
+0031e9 5fe6: a9 00                            lda   #$00
+0031eb 5fe8: 85 fc                            sta   PixelLineBaseL
+0031ed 5fea: 85 fe                            sta   PixelLineBaseH
+0031ef 5fec: ca           L5FEC               dex
+0031f0 5fed: 10 01                            bpl   L5FF0
+0031f2 5fef: 60                               rts

+0031f3 5ff0: bc 70 17     L5FF0               ldy   $1770,x
+0031f6 5ff3: b1 fc                            lda   (PixelLineBaseL),y
+0031f8 5ff5: 85 06                            sta   _strobePtr
+0031fa 5ff7: b1 fe                            lda   (PixelLineBaseH),y
+0031fc 5ff9: 85 07                            sta   _strobePtr+1
+0031fe 5ffb: bc c0 17                         ldy   $17c0,x
+003201 5ffe: bd 10 18                         lda   $1810,x
+003204 6001: 91 06                            sta   (_strobePtr),y
+003206 6003: d0 e7                            bne   L5FEC
+003208 6005: 4c ec 5f                         jmp   L5FEC

+00320b 6008: ac 08 14     L6008               ldy   $1408
+00320e 600b: cc 02 14                         cpy   $1402
+003211 600e: 90 01                            bcc   L6011
+003213 6010: 60                               rts

+003214 6011: 98           L6011               tya
+003215 6012: 18                               clc
+003216 6013: 69 04                            adc   #$04
+003218 6015: 8d 08 14                         sta   $1408
+00321b 6018: b9 f0 15                         lda   $15f0,y
+00321e 601b: 18                               clc
+00321f 601c: 69 07                            adc   #$07
+003221 601e: 85 05                            sta   _ix
+003223 6020: b9 70 15                         lda   $1570,y
+003226 6023: 18                               clc
+003227 6024: 69 03                            adc   #$03
+003229 6026: 20 1c 4c                         jsr   divdeA7
+00322c 6029: 85 04                            sta   _length
+00322e 602b: ac 0b 0c                         ldy   L0C0B
+003231 602e: 88                               dey
+003232 602f: ad 05 14                         lda   $1405
+003235 6032: aa                               tax
+003236 6033: 18                               clc
+003237 6034: 6d 0b 0c                         adc   L0C0B
+00323a 6037: 8d 05 14                         sta   $1405
+00323d 603a: ad 07 0c     L603A               lda   L0C07
+003240 603d: 9d b0 18                         sta   $18b0,x
+003243 6040: a5 04                            lda   _length
+003245 6042: 9d c0 17                         sta   $17c0,x
+003248 6045: 4a                               lsr   A
+003249 6046: a9 aa                            lda   #$aa
+00324b 6048: 90 02                            bcc   L604C
+00324d 604a: a9 d5                            lda   #$d5
+00324f 604c: 39 0c 0d     L604C               and   L0D0C,y
+003252 604f: 9d 10 18                         sta   $1810,x
+003255 6052: b9 04 0d                         lda   L0D04,y
+003258 6055: 9d 60 18                         sta   $1860,x
+00325b 6058: 86 00                            stx   _spriteEntryPtr
+00325d 605a: ae 07 0c                         ldx   L0C07
+003260 605d: 20 4f 4c                         jsr   multiplyAX
+003263 6060: 86 02                            stx   _strobePtrOffs
+003265 6062: a5 05                            lda   _ix
+003267 6064: 38                               sec
+003268 6065: e5 02                            sbc   _strobePtrOffs
+00326a 6067: a6 00                            ldx   _spriteEntryPtr
+00326c 6069: 9d 70 17                         sta   $1770,x
+00326f 606c: e8                               inx
+003270 606d: 88                               dey
+003271 606e: 10 ca                            bpl   L603A
+003273 6070: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+003276 6073: ae 0a 14     L6073               ldx   $140a
+003279 6076: a5 1c        L6076               lda   $1c
+00327b 6078: ca           L6078               dex
+00327c 6079: 10 02                            bpl   L607D
+00327e 607b: 18                               clc
+00327f 607c: 60                               rts

+003280 607d: dd 50 19     L607D               cmp   $1950,x
+003283 6080: 90 f6                            bcc   L6078
+003285 6082: e9 08                            sbc   #$08
+003287 6084: 90 05                            bcc   L608B
+003289 6086: dd 50 19                         cmp   $1950,x
+00328c 6089: b0 eb                            bcs   L6076
+00328e 608b: a5 1d        L608B               lda   $1d
+003290 608d: dd 60 19                         cmp   $1960,x
+003293 6090: 90 e4                            bcc   L6076
+003295 6092: e9 0b                            sbc   #$0b
+003297 6094: 90 05                            bcc   L609B
+003299 6096: dd 60 19                         cmp   $1960,x
+00329c 6099: b0 db                            bcs   L6076
+00329e 609b: 8a           L609B               txa
+00329f 609c: 48                               pha
+0032a0 609d: a8                               tay
+0032a1 609e: be 60 19                         ldx   $1960,y
+0032a4 60a1: b9 50 19                         lda   $1950,y
+0032a7 60a4: a0 0a                            ldy   #$0a
+0032a9 60a6: 20 d0 4c                         jsr   eraseFamily
+0032ac 60a9: 68                               pla
+0032ad 60aa: aa                               tax
+0032ae 60ab: 20 0a 5f                         jsr   L5F0A
+0032b1 60ae: 38                               sec
+0032b2 60af: 60                               rts

+0032b3 60b0: ae 2c 14     L60B0               ldx   $142c
+0032b6 60b3: ca           L60B3               dex
+0032b7 60b4: 10 03                            bpl   L60B9
+0032b9 60b6: 4c 50 61                         jmp   L6150

+0032bc 60b9: de d0 1e     L60B9               dec   $1ed0,x
+0032bf 60bc: 10 f5                            bpl   L60B3
+0032c1 60be: ad 5e 0c                         lda   L0C5E
+0032c4 60c1: 9d d0 1e                         sta   $1ed0,x
+0032c7 60c4: 86 00                            stx   _spriteEntryPtr
+0032c9 60c6: bc f0 1e                         ldy   $1ef0,x
+0032cc 60c9: b9 40 09                         lda   L0940,y
+0032cf 60cc: 85 06                            sta   _strobePtr
+0032d1 60ce: b9 48 09                         lda   L0948,y
+0032d4 60d1: 85 07                            sta   _strobePtr+1
+0032d6 60d3: bc c0 1e                         ldy   $1ec0,x
+0032d9 60d6: bd b0 1e                         lda   $1eb0,x
+0032dc 60d9: aa                               tax
+0032dd 60da: 20 f6 4c                         jsr   drawHulk
+0032e0 60dd: a6 00                            ldx   _spriteEntryPtr
+0032e2 60df: de e0 1e                         dec   $1ee0,x
+0032e5 60e2: 10 cf                            bpl   L60B3
+0032e7 60e4: a4 00                            ldy   _spriteEntryPtr
+0032e9 60e6: be c0 1e                         ldx   $1ec0,y
+0032ec 60e9: b9 f0 1e                         lda   $1ef0,y
+0032ef 60ec: c9 05                            cmp   #$05
+0032f1 60ee: b9 b0 1e                         lda   $1eb0,y
+0032f4 60f1: a0 05                            ldy   #$05
+0032f6 60f3: 90 02                            bcc   L60F7
+0032f8 60f5: a0 0d                            ldy   #$0d
+0032fa 60f7: 20 21 4d     L60F7               jsr   eraseHulk
+0032fd 60fa: a6 00                            ldx   _spriteEntryPtr
+0032ff 60fc: ce 2c 14                         dec   $142c
+003302 60ff: bd b1 1e     L60FF               lda   $1eb1,x
+003305 6102: 9d b0 1e                         sta   $1eb0,x
+003308 6105: bd c1 1e                         lda   $1ec1,x
+00330b 6108: 9d c0 1e                         sta   $1ec0,x
+00330e 610b: bd d1 1e                         lda   $1ed1,x
+003311 610e: 9d d0 1e                         sta   $1ed0,x
+003314 6111: bd e1 1e                         lda   $1ee1,x
+003317 6114: 9d e0 1e                         sta   $1ee0,x
+00331a 6117: bd f1 1e                         lda   $1ef1,x
+00331d 611a: 9d f0 1e                         sta   $1ef0,x
+003320 611d: e8                               inx
+003321 611e: ec 2c 14                         cpx   $142c
+003324 6121: 90 dc                            bcc   L60FF
+003326 6123: a6 00                            ldx   _spriteEntryPtr
+003328 6125: 10 8c                            bpl   L60B3
+00332a 6127: 88           L6127               dey
+00332b 6128: 98                               tya
+00332c 6129: ac 2d 14                         ldy   $142d
+00332f 612c: 99 10 1f                         sta   $1f10,y
+003332 612f: 8a                               txa
+003333 6130: 20 1c 4c                         jsr   divdeA7
+003336 6133: a2 07                            ldx   #$07
+003338 6135: 20 4f 4c                         jsr   multiplyAX
+00333b 6138: 8a                               txa
+00333c 6139: 99 00 1f                         sta   $1f00,y
+00333f 613c: a9 00                            lda   #$00
+003341 613e: 99 20 1f                         sta   $1f20,y
+003344 6141: ad 61 0c                         lda   L0C61
+003347 6144: 99 30 1f                         sta   $1f30,y
+00334a 6147: ee 2d 14                         inc   $142d
+00334d 614a: a9 ff                            lda   #$ff
+00334f 614c: 8d 0c 14                         sta   $140c
+003352 614f: 60                               rts

+003353 6150: ae 2d 14     L6150               ldx   $142d
+003356 6153: ca           L6153               dex
+003357 6154: 10 01                            bpl   L6157
+003359 6156: 60                               rts

+00335a 6157: de 20 1f     L6157               dec   $1f20,x
+00335d 615a: 10 f7                            bpl   L6153
+00335f 615c: 86 00                            stx   _spriteEntryPtr
+003361 615e: ad 60 0c                         lda   L0C60
+003364 6161: 9d 20 1f                         sta   $1f20,x
+003367 6164: bd 30 1f                         lda   $1f30,x
+00336a 6167: 29 03                            and   #$03
+00336c 6169: a8                               tay
+00336d 616a: b9 50 09                         lda   L0950,y
+003370 616d: 85 06                            sta   _strobePtr
+003372 616f: b9 58 09                         lda   L0958,y
+003375 6172: 85 07                            sta   _strobePtr+1
+003377 6174: bc 10 1f                         ldy   $1f10,x
+00337a 6177: bd 00 1f                         lda   $1f00,x
+00337d 617a: aa                               tax
+00337e 617b: 20 ac 4c                         jsr   drawFamily
+003381 617e: a6 00                            ldx   _spriteEntryPtr
+003383 6180: de 30 1f                         dec   $1f30,x
+003386 6183: 10 ce                            bpl   L6153
+003388 6185: a4 00                            ldy   _spriteEntryPtr
+00338a 6187: be 10 1f                         ldx   $1f10,y
+00338d 618a: b9 00 1f                         lda   $1f00,y
+003390 618d: a0 0c                            ldy   #$0c
+003392 618f: 20 d0 4c                         jsr   eraseFamily
+003395 6192: a6 00                            ldx   _spriteEntryPtr
+003397 6194: ce 2d 14                         dec   $142d
+00339a 6197: bd 01 1f     L6197               lda   $1f01,x
+00339d 619a: 9d 00 1f                         sta   $1f00,x
+0033a0 619d: bd 11 1f                         lda   $1f11,x
+0033a3 61a0: 9d 10 1f                         sta   $1f10,x
+0033a6 61a3: bd 21 1f                         lda   $1f21,x
+0033a9 61a6: 9d 20 1f                         sta   $1f20,x
+0033ac 61a9: bd 31 1f                         lda   $1f31,x
+0033af 61ac: 9d 30 1f                         sta   $1f30,x
+0033b2 61af: e8                               inx
+0033b3 61b0: ec 2d 14                         cpx   $142d
+0033b6 61b3: 90 e2                            bcc   L6197
+0033b8 61b5: a6 00                            ldx   _spriteEntryPtr
+0033ba 61b7: 10 9a                            bpl   L6153
+0033bc 61b9: 48           L61B9               pha
+0033bd 61ba: 8a                               txa
+0033be 61bb: 20 1c 4c                         jsr   divdeA7
+0033c1 61be: a2 07                            ldx   #$07
+0033c3 61c0: 20 4f 4c                         jsr   multiplyAX
+0033c6 61c3: 8a                               txa
+0033c7 61c4: ae 2c 14                         ldx   $142c
+0033ca 61c7: 9d b0 1e                         sta   $1eb0,x
+0033cd 61ca: 98                               tya
+0033ce 61cb: 9d c0 1e                         sta   $1ec0,x
+0033d1 61ce: 68                               pla
+0033d2 61cf: 9d f0 1e                         sta   $1ef0,x
+0033d5 61d2: c9 05                            cmp   #$05
+0033d7 61d4: a9 00                            lda   #$00
+0033d9 61d6: 9d d0 1e                         sta   $1ed0,x
+0033dc 61d9: ad 5f 0c                         lda   L0C5F
+0033df 61dc: 90 02                            bcc   L61E0
+0033e1 61de: a9 01                            lda   #$01
+0033e3 61e0: 9d e0 1e     L61E0               sta   $1ee0,x
+0033e6 61e3: ee 2c 14                         inc   $142c
+0033e9 61e6: 60                               rts

+0033ea 61e7: ff ff ff ff+                     .fill 25,$ff

+003403 6200: 4c 1b 62     L6200               jmp   L621B

+003406 6203: 4c be 62     L6203               jmp   L62BE

+003409 6206: 4c 36 64     L6206               jmp   L6436

+00340c 6209: 4c 23 65     L6209               jmp   L6523

+00340f 620c: 4c 9f 66     L620C               jmp   L669F

+003412 620f: 4c 0e 67     L620F               jmp   L670E

+003415 6212: 4c 43 66     L6212               jmp   L6643

+003418 6215: 4c 4e 68     PreRestart          jmp   L684E

+00341b 6218: 4c 6a 68     L6218               jmp   showHighScore

+00341e 621b: ae 0e 14     L621B               ldx   $140e
+003421 621e: a9 00                            lda   #$00
+003423 6220: 18                               clc
+003424 6221: ca           L6221               dex
+003425 6222: 30 05                            bmi   L6229
+003427 6224: 7d 30 1a                         adc   $1a30,x
+00342a 6227: 90 f8                            bcc   L6221
+00342c 6229: 6d 0f 14     L6229               adc   $140f
+00342f 622c: 85 00                            sta   _spriteEntryPtr
+003431 622e: a2 00                            ldx   #$00
+003433 6230: a0 05        L6230               ldy   #$05
+003435 6232: a5 00                            lda   _spriteEntryPtr
+003437 6234: f0 12                            beq   L6248
+003439 6236: 38                               sec
+00343a 6237: e9 05                            sbc   #$05
+00343c 6239: b0 04                            bcs   L623F
+00343e 623b: a4 00                            ldy   _spriteEntryPtr
+003440 623d: a9 00                            lda   #$00
+003442 623f: 85 00        L623F               sta   _spriteEntryPtr
+003444 6241: 98                               tya
+003445 6242: 9d 30 1a                         sta   $1a30,x
+003448 6245: e8                               inx
+003449 6246: d0 e8                            bne   L6230
+00344b 6248: 8e 0e 14     L6248               stx   $140e
+00344e 624b: ac 0e 14                         ldy   $140e
+003451 624e: 88           L624E               dey
+003452 624f: 10 0e                            bpl   L625F
+003454 6251: a9 00                            lda   #$00
+003456 6253: 8d 0f 14                         sta   $140f
+003459 6256: 8d 10 14                         sta   $1410
+00345c 6259: a9 ff                            lda   #$ff
+00345e 625b: 8d 14 14                         sta   $1414
+003461 625e: 60                               rts

+003462 625f: 20 36 4c     L625F               jsr   randomA
+003465 6262: 30 1a                            bmi   L627E
+003467 6264: a9 f3                            lda   #$f3
+003469 6266: 20 4b 4c                         jsr   multiplyRndX
+00346c 6269: 09 01                            ora   #$01
+00346e 626b: 99 c0 19                         sta   $19c0,y
+003471 626e: a2 00                            ldx   #$00
+003473 6270: 20 36 4c                         jsr   randomA
+003476 6273: 10 02                            bpl   L6277
+003478 6275: a2 b3                            ldx   #$b3
+00347a 6277: 8a           L6277               txa
+00347b 6278: 99 d0 19                         sta   $19d0,y
+00347e 627b: 38                               sec
+00347f 627c: b0 15                            bcs   L6293

+003481 627e: a9 b3        L627E               lda   #$b3
+003483 6280: 20 4b 4c                         jsr   multiplyRndX
+003486 6283: 99 d0 19                         sta   $19d0,y
+003489 6286: a2 01                            ldx   #$01
+00348b 6288: 20 36 4c                         jsr   randomA
+00348e 628b: 10 02                            bpl   L628F
+003490 628d: a2 f3                            ldx   #$f3
+003492 628f: 8a           L628F               txa
+003493 6290: 99 c0 19                         sta   $19c0,y
+003496 6293: a9 00        L6293               lda   #$00
+003498 6295: 99 e0 19                         sta   $19e0,y
+00349b 6298: 99 f0 19                         sta   $19f0,y
+00349e 629b: 99 40 1a                         sta   $1a40,y
+0034a1 629e: 99 00 1a                         sta   $1a00,y
+0034a4 62a1: ad 21 14                         lda   $1421
+0034a7 62a4: ae 18 0c                         ldx   L0C18
+0034aa 62a7: e8                               inx
+0034ab 62a8: 20 00 4c                         jsr   divideAX
+0034ae 62ab: 99 10 1a                         sta   $1a10,y
+0034b1 62ae: ad 13 0c                         lda   L0C13
+0034b4 62b1: 20 4b 4c                         jsr   multiplyRndX
+0034b7 62b4: 18                               clc
+0034b8 62b5: 6d 12 0c                         adc   L0C12
+0034bb 62b8: 99 20 1a                         sta   $1a20,y
+0034be 62bb: 38                               sec
+0034bf 62bc: b0 90                            bcs   L624E

+0034c1 62be: ae 0e 14     L62BE               ldx   $140e
+0034c4 62c1: ca           L62C1               dex
+0034c5 62c2: 10 01                            bpl   L62C5
+0034c7 62c4: 60                               rts

+0034c8 62c5: de 00 1a     L62C5               dec   $1a00,x
+0034cb 62c8: 10 f7                            bpl   L62C1
+0034cd 62ca: ad 18 0c                         lda   L0C18
+0034d0 62cd: 9d 00 1a                         sta   $1a00,x
+0034d3 62d0: 86 00                            stx   _spriteEntryPtr
+0034d5 62d2: a4 00                            ldy   _spriteEntryPtr
+0034d7 62d4: be d0 19                         ldx   $19d0,y
+0034da 62d7: b9 c0 19                         lda   $19c0,y
+0034dd 62da: a0 0d                            ldy   #$0d
+0034df 62dc: 20 21 4d                         jsr   eraseHulk
+0034e2 62df: a6 00                            ldx   _spriteEntryPtr
+0034e4 62e1: de 10 1a                         dec   $1a10,x
+0034e7 62e4: 10 3c                            bpl   L6322
+0034e9 62e6: ad 1b 0c                         lda   L0C1B
+0034ec 62e9: 20 4b 4c                         jsr   multiplyRndX
+0034ef 62ec: a4 00                            ldy   _spriteEntryPtr
+0034f1 62ee: 99 10 1a                         sta   $1a10,y
+0034f4 62f1: ad 17 0c                         lda   L0C17
+0034f7 62f4: 0a                               asl   A
+0034f8 62f5: 48                               pha
+0034f9 62f6: 20 4b 4c                         jsr   multiplyRndX
+0034fc 62f9: 38                               sec
+0034fd 62fa: ed 17 0c                         sbc   L0C17
+003500 62fd: 29 fe                            and   #$fe
+003502 62ff: 99 e0 19                         sta   $19e0,y
+003505 6302: 68                               pla
+003506 6303: 20 4b 4c                         jsr   multiplyRndX
+003509 6306: 38                               sec
+00350a 6307: ed 17 0c                         sbc   L0C17
+00350d 630a: 99 f0 19                         sta   $19f0,y
+003510 630d: a6 00                            ldx   _spriteEntryPtr
+003512 630f: de 20 1a                         dec   $1a20,x
+003515 6312: 10 0e                            bpl   L6322
+003517 6314: ad 13 0c                         lda   L0C13
+00351a 6317: 20 4b 4c                         jsr   multiplyRndX
+00351d 631a: 99 20 1a                         sta   $1a20,y
+003520 631d: a6 00                            ldx   _spriteEntryPtr
+003522 631f: 20 b3 63                         jsr   L63B3
+003525 6322: bd 20 1a     L6322               lda   $1a20,x
+003528 6325: d0 2c                            bne   L6353
+00352a 6327: bd 10 1a                         lda   $1a10,x
+00352d 632a: cd 1c 0c                         cmp   L0C1C
+003530 632d: b0 24                            bcs   L6353
+003532 632f: bd e0 19                         lda   $19e0,x
+003535 6332: 30 07                            bmi   L633B
+003537 6334: f0 08                            beq   L633E
+003539 6336: 38                               sec
+00353a 6337: e9 02                            sbc   #$02
+00353c 6339: b0 03                            bcs   L633E
+00353e 633b: 18           L633B               clc
+00353f 633c: 69 02                            adc   #$02
+003541 633e: 9d e0 19     L633E               sta   $19e0,x
+003544 6341: bd f0 19                         lda   $19f0,x
+003547 6344: 30 07                            bmi   L634D
+003549 6346: f0 08                            beq   L6350
+00354b 6348: 38                               sec
+00354c 6349: e9 02                            sbc   #$02
+00354e 634b: b0 03                            bcs   L6350
+003550 634d: 18           L634D               clc
+003551 634e: 69 02                            adc   #$02
+003553 6350: 9d f0 19     L6350               sta   $19f0,x
+003556 6353: de 40 1a     L6353               dec   $1a40,x
+003559 6356: 10 05                            bpl   L635D
+00355b 6358: a9 03                            lda   #$03
+00355d 635a: 9d 40 1a                         sta   $1a40,x
+003560 635d: bc 40 1a     L635D               ldy   $1a40,x
+003563 6360: b9 c0 08                         lda   L08C0,y
+003566 6363: 85 06                            sta   _strobePtr
+003568 6365: b9 c8 08                         lda   L08C8,y
+00356b 6368: 85 07                            sta   _strobePtr+1
+00356d 636a: bd c0 19                         lda   $19c0,x
+003570 636d: 18                               clc
+003571 636e: 7d e0 19                         adc   $19e0,x
+003574 6371: c9 f3                            cmp   #$f3
+003576 6373: 90 10                            bcc   L6385
+003578 6375: a9 00                            lda   #$00
+00357a 6377: bc e0 19                         ldy   $19e0,x
+00357d 637a: 9d e0 19                         sta   $19e0,x
+003580 637d: 30 04                            bmi   L6383
+003582 637f: a9 f1                            lda   #$f1
+003584 6381: 30 02                            bmi   L6385

+003586 6383: a9 01        L6383               lda   #$01
+003588 6385: 9d c0 19     L6385               sta   $19c0,x
+00358b 6388: bd d0 19                         lda   $19d0,x
+00358e 638b: 18                               clc
+00358f 638c: 7d f0 19                         adc   $19f0,x
+003592 638f: c9 b3                            cmp   #$b3
+003594 6391: 90 10                            bcc   L63A3
+003596 6393: a9 00                            lda   #$00
+003598 6395: bc f0 19                         ldy   $19f0,x
+00359b 6398: 9d f0 19                         sta   $19f0,x
+00359e 639b: 30 04                            bmi   L63A1
+0035a0 639d: a9 b2                            lda   #$b2
+0035a2 639f: 30 02                            bmi   L63A3

+0035a4 63a1: a9 00        L63A1               lda   #$00
+0035a6 63a3: 9d d0 19     L63A3               sta   $19d0,x
+0035a9 63a6: a8                               tay
+0035aa 63a7: bd c0 19                         lda   $19c0,x
+0035ad 63aa: aa                               tax
+0035ae 63ab: 20 f6 4c                         jsr   drawHulk
+0035b1 63ae: a6 00                            ldx   _spriteEntryPtr
+0035b3 63b0: 4c c1 62                         jmp   L62C1

+0035b6 63b3: ac 0f 14     L63B3               ldy   $140f
+0035b9 63b6: c0 10                            cpy   #$10
+0035bb 63b8: 90 01                            bcc   L63BB
+0035bd 63ba: 60                               rts

+0035be 63bb: bd c0 19     L63BB               lda   $19c0,x
+0035c1 63be: 99 50 1a                         sta   $1a50,y
+0035c4 63c1: bd d0 19                         lda   $19d0,x
+0035c7 63c4: 99 60 1a                         sta   $1a60,y
+0035ca 63c7: a9 01                            lda   #$01
+0035cc 63c9: 99 70 1a                         sta   $1a70,y
+0035cf 63cc: 86 00                            stx   _spriteEntryPtr
+0035d1 63ce: 98                               tya
+0035d2 63cf: aa                               tax
+0035d3 63d0: 20 b8 67                         jsr   L67B8
+0035d6 63d3: a6 00                            ldx   _spriteEntryPtr
+0035d8 63d5: ad 1e 0c                         lda   L0C1E
+0035db 63d8: 8d 12 14                         sta   $1412
+0035de 63db: ad 1d 0c                         lda   L0C1D
+0035e1 63de: 8d 13 14                         sta   $1413
+0035e4 63e1: ee 0f 14                         inc   $140f
+0035e7 63e4: de 30 1a                         dec   $1a30,x
+0035ea 63e7: f0 01                            beq   L63EA
+0035ec 63e9: 60                               rts

+0035ed 63ea: 20 f2 63     L63EA               jsr   L63F2
+0035f0 63ed: 68                               pla
+0035f1 63ee: 68                               pla
+0035f2 63ef: 4c c1 62                         jmp   L62C1

+0035f5 63f2: 8a           L63F2               txa
+0035f6 63f3: 48                               pha
+0035f7 63f4: ce 0e 14                         dec   $140e
+0035fa 63f7: bd c1 19     L63F7               lda   $19c1,x
+0035fd 63fa: 9d c0 19                         sta   $19c0,x
+003600 63fd: bd d1 19                         lda   $19d1,x
+003603 6400: 9d d0 19                         sta   $19d0,x
+003606 6403: bd e1 19                         lda   $19e1,x
+003609 6406: 9d e0 19                         sta   $19e0,x
+00360c 6409: bd f1 19                         lda   $19f1,x
+00360f 640c: 9d f0 19                         sta   $19f0,x
+003612 640f: bd 01 1a                         lda   $1a01,x
+003615 6412: 9d 00 1a                         sta   $1a00,x
+003618 6415: bd 11 1a                         lda   $1a11,x
+00361b 6418: 9d 10 1a                         sta   $1a10,x
+00361e 641b: bd 21 1a                         lda   $1a21,x
+003621 641e: 9d 20 1a                         sta   $1a20,x
+003624 6421: bd 31 1a                         lda   $1a31,x
+003627 6424: 9d 30 1a                         sta   $1a30,x
+00362a 6427: bd 41 1a                         lda   $1a41,x
+00362d 642a: 9d 40 1a                         sta   $1a40,x
+003630 642d: e8                               inx
+003631 642e: ec 0e 14                         cpx   $140e
+003634 6431: 90 c4                            bcc   L63F7
+003636 6433: 68                               pla
+003637 6434: aa                               tax
+003638 6435: 60                               rts

+003639 6436: ae 0f 14     L6436               ldx   $140f
+00363c 6439: d0 01                            bne   L643C
+00363e 643b: 60                               rts

+00363f 643c: ca           L643C               dex
+003640 643d: 10 03                            bpl   L6442
+003642 643f: 4c 89 67                         jmp   L6789

+003645 6442: de 70 1a     L6442               dec   $1a70,x
+003648 6445: 10 f5                            bpl   L643C
+00364a 6447: ad 19 0c                         lda   L0C19
+00364d 644a: 9d 70 1a                         sta   $1a70,x
+003650 644d: 86 00                            stx   _spriteEntryPtr
+003652 644f: a4 00                            ldy   _spriteEntryPtr
+003654 6451: be 60 1a                         ldx   $1a60,y
+003657 6454: b9 50 1a                         lda   $1a50,y
+00365a 6457: a0 0d                            ldy   #$0d
+00365c 6459: 20 21 4d                         jsr   eraseHulk
+00365f 645c: a6 00                            ldx   _spriteEntryPtr
+003661 645e: bd 50 1a                         lda   $1a50,x
+003664 6461: 18                               clc
+003665 6462: 7d 80 1a                         adc   $1a80,x
+003668 6465: bc 80 1a                         ldy   $1a80,x
+00366b 6468: 30 0a                            bmi   L6474
+00366d 646a: b0 04                            bcs   L6470
+00366f 646c: c9 f4                            cmp   #$f4
+003671 646e: 90 08                            bcc   L6478
+003673 6470: a9 f3        L6470               lda   #$f3
+003675 6472: 30 04                            bmi   L6478

+003677 6474: b0 02        L6474               bcs   L6478
+003679 6476: a9 00                            lda   #$00
+00367b 6478: 9d 50 1a     L6478               sta   $1a50,x
+00367e 647b: bd 60 1a                         lda   $1a60,x
+003681 647e: 18                               clc
+003682 647f: 7d 90 1a                         adc   $1a90,x
+003685 6482: c9 b3                            cmp   #$b3
+003687 6484: 90 09                            bcc   L648F
+003689 6486: a9 b2                            lda   #$b2
+00368b 6488: bc 90 1a                         ldy   $1a90,x
+00368e 648b: 10 02                            bpl   L648F
+003690 648d: a9 00                            lda   #$00
+003692 648f: 9d 60 1a     L648F               sta   $1a60,x
+003695 6492: a8                               tay
+003696 6493: bd 50 1a                         lda   $1a50,x
+003699 6496: aa                               tax
+00369a 6497: ad d0 08                         lda   L08D0
+00369d 649a: 85 06                            sta   _strobePtr
+00369f 649c: ad d4 08                         lda   L08D4
+0036a2 649f: 85 07                            sta   _strobePtr+1
+0036a4 64a1: 20 f6 4c                         jsr   drawHulk
+0036a7 64a4: a6 00                            ldx   _spriteEntryPtr
+0036a9 64a6: 10 94                            bpl   L643C
+0036ab 64a8: ac 10 14     L64A8               ldy   $1410
+0036ae 64ab: c0 10                            cpy   #$10
+0036b0 64ad: b0 50                            bcs   L64FF
+0036b2 64af: bd 60 1a                         lda   $1a60,x
+0036b5 64b2: 69 03                            adc   #$03
+0036b7 64b4: 99 b0 1a                         sta   $1ab0,y
+0036ba 64b7: bd 50 1a                         lda   $1a50,x
+0036bd 64ba: 69 04                            adc   #$04
+0036bf 64bc: 99 a0 1a                         sta   $1aa0,y
+0036c2 64bf: ae 00 15                         ldx   $1500
+0036c5 64c2: 20 00 65                         jsr   L6500
+0036c8 64c5: 99 c0 1a                         sta   $1ac0,y
+0036cb 64c8: b9 b0 1a                         lda   $1ab0,y
+0036ce 64cb: ae 01 15                         ldx   $1501
+0036d1 64ce: 20 00 65                         jsr   L6500
+0036d4 64d1: 99 d0 1a                         sta   $1ad0,y
+0036d7 64d4: ad 16 0c                         lda   L0C16
+0036da 64d7: 99 f0 1a                         sta   $1af0,y
+0036dd 64da: a5 4e                            lda   MON_RNDL
+0036df 64dc: 29 01                            and   #$01
+0036e1 64de: 99 e0 1a                         sta   $1ae0,y
+0036e4 64e1: a9 03                            lda   #$03
+0036e6 64e3: 20 4b 4c                         jsr   multiplyRndX
+0036e9 64e6: 38                               sec
+0036ea 64e7: e9 01                            sbc   #$01
+0036ec 64e9: 99 00 1b                         sta   $1b00,y
+0036ef 64ec: a9 03        L64EC               lda   #$03
+0036f1 64ee: 20 4b 4c                         jsr   multiplyRndX
+0036f4 64f1: 38                               sec
+0036f5 64f2: e9 01                            sbc   #$01
+0036f7 64f4: 99 10 1b                         sta   $1b10,y
+0036fa 64f7: 19 00 1b                         ora   $1b00,y
+0036fd 64fa: f0 f0                            beq   L64EC
+0036ff 64fc: ee 10 14                         inc   $1410
+003702 64ff: 60           L64FF               rts

+003703 6500: 4a           L6500               lsr   A
+003704 6501: 4a                               lsr   A
+003705 6502: 4a                               lsr   A
+003706 6503: 4a                               lsr   A
+003707 6504: 4a                               lsr   A
+003708 6505: 85 06                            sta   _strobePtr
+00370a 6507: 8a                               txa
+00370b 6508: 4a                               lsr   A
+00370c 6509: 4a                               lsr   A
+00370d 650a: 4a                               lsr   A
+00370e 650b: 4a                               lsr   A
+00370f 650c: 4a                               lsr   A
+003710 650d: 38                               sec
+003711 650e: e5 06                            sbc   _strobePtr
+003713 6510: 85 06                            sta   _strobePtr
+003715 6512: a9 05                            lda   #$05
+003717 6514: 20 4b 4c                         jsr   multiplyRndX
+00371a 6517: 38                               sec
+00371b 6518: e9 02                            sbc   #$02
+00371d 651a: 18                               clc
+00371e 651b: 65 06                            adc   _strobePtr
+003720 651d: d0 03                            bne   L6522
+003722 651f: 18                               clc
+003723 6520: 69 01                            adc   #$01
+003725 6522: 60           L6522               rts

+003726 6523: ae 10 14     L6523               ldx   $1410
+003729 6526: ca           L6526               dex
+00372a 6527: 10 01                            bpl   L652A
+00372c 6529: 60                               rts

+00372d 652a: de e0 1a     L652A               dec   $1ae0,x
+003730 652d: 10 f7                            bpl   L6526
+003732 652f: ad 1a 0c                         lda   L0C1A
+003735 6532: 9d e0 1a                         sta   $1ae0,x
+003738 6535: 86 00                            stx   _spriteEntryPtr
+00373a 6537: a4 00                            ldy   _spriteEntryPtr
+00373c 6539: be b0 1a                         ldx   $1ab0,y
+00373f 653c: b9 a0 1a                         lda   $1aa0,y
+003742 653f: a0 07                            ldy   #$07
+003744 6541: 20 d0 4c                         jsr   eraseFamily
+003747 6544: a6 00                            ldx   _spriteEntryPtr
+003749 6546: de f0 1a                         dec   $1af0,x
+00374c 6549: d0 06                            bne   L6551
+00374e 654b: 20 d9 65                         jsr   L65D9
+003751 654e: 4c 26 65                         jmp   L6526

+003754 6551: bd f0 1a     L6551               lda   $1af0,x
+003757 6554: 29 01                            and   #$01
+003759 6556: 85 08                            sta   _destPtr
+00375b 6558: a8                               tay
+00375c 6559: b9 d8 08                         lda   L08D8,y
+00375f 655c: 85 06                            sta   _strobePtr
+003761 655e: b9 dc 08                         lda   L08DC,y
+003764 6561: 85 07                            sta   _strobePtr+1
+003766 6563: bd b0 1a                         lda   $1ab0,x
+003769 6566: 18                               clc
+00376a 6567: 7d d0 1a                         adc   $1ad0,x
+00376d 656a: c9 b9                            cmp   #$b9
+00376f 656c: 90 0f                            bcc   L657D
+003771 656e: a9 b8                            lda   #$b8
+003773 6570: bc d0 1a                         ldy   $1ad0,x
+003776 6573: 10 02                            bpl   L6577
+003778 6575: a9 00                            lda   #$00
+00377a 6577: 9d b0 1a     L6577               sta   $1ab0,x
+00377d 657a: 48                               pha
+00377e 657b: 10 19                            bpl   L6596

+003780 657d: 9d b0 1a     L657D               sta   $1ab0,x
+003783 6580: 48                               pha
+003784 6581: a5 08                            lda   _destPtr
+003786 6583: f0 11                            beq   L6596
+003788 6585: bd d0 1a                         lda   $1ad0,x
+00378b 6588: 7d 10 1b                         adc   $1b10,x
+00378e 658b: c9 f6                            cmp   #$f6
+003790 658d: b0 04                            bcs   L6593
+003792 658f: c9 0a                            cmp   #$0a
+003794 6591: b0 03                            bcs   L6596
+003796 6593: 9d d0 1a     L6593               sta   $1ad0,x
+003799 6596: bd a0 1a     L6596               lda   $1aa0,x
+00379c 6599: 18                               clc
+00379d 659a: 7d c0 1a                         adc   $1ac0,x
+0037a0 659d: bc c0 1a                         ldy   $1ac0,x
+0037a3 65a0: 30 06                            bmi   L65A8
+0037a5 65a2: 90 0f                            bcc   L65B3
+0037a7 65a4: a9 f9                            lda   #$f9
+0037a9 65a6: 30 04                            bmi   L65AC

+0037ab 65a8: b0 09        L65A8               bcs   L65B3
+0037ad 65aa: a9 00                            lda   #$00
+0037af 65ac: 9d a0 1a     L65AC               sta   $1aa0,x
+0037b2 65af: 48                               pha
+0037b3 65b0: 38                               sec
+0037b4 65b1: b0 1a                            bcs   L65CD

+0037b6 65b3: 9d a0 1a     L65B3               sta   $1aa0,x
+0037b9 65b6: 48                               pha
+0037ba 65b7: a5 08                            lda   _destPtr
+0037bc 65b9: f0 12                            beq   L65CD
+0037be 65bb: bd c0 1a                         lda   $1ac0,x
+0037c1 65be: 18                               clc
+0037c2 65bf: 7d 00 1b                         adc   $1b00,x
+0037c5 65c2: c9 f6                            cmp   #$f6
+0037c7 65c4: b0 04                            bcs   L65CA
+0037c9 65c6: c9 0a                            cmp   #$0a
+0037cb 65c8: b0 03                            bcs   L65CD
+0037cd 65ca: 9d c0 1a     L65CA               sta   $1ac0,x
+0037d0 65cd: 68           L65CD               pla
+0037d1 65ce: aa                               tax
+0037d2 65cf: 68                               pla
+0037d3 65d0: a8                               tay
+0037d4 65d1: 20 ac 4c                         jsr   drawFamily
+0037d7 65d4: a6 00                            ldx   _spriteEntryPtr
+0037d9 65d6: 4c 26 65                         jmp   L6526

+0037dc 65d9: 8a           L65D9               txa
+0037dd 65da: 48                               pha
+0037de 65db: ce 10 14                         dec   $1410
+0037e1 65de: bd a1 1a     L65DE               lda   $1aa1,x
+0037e4 65e1: 9d a0 1a                         sta   $1aa0,x
+0037e7 65e4: bd b1 1a                         lda   $1ab1,x
+0037ea 65e7: 9d b0 1a                         sta   $1ab0,x
+0037ed 65ea: bd c1 1a                         lda   $1ac1,x
+0037f0 65ed: 9d c0 1a                         sta   $1ac0,x
+0037f3 65f0: bd d1 1a                         lda   $1ad1,x
+0037f6 65f3: 9d d0 1a                         sta   $1ad0,x
+0037f9 65f6: bd e1 1a                         lda   $1ae1,x
+0037fc 65f9: 9d e0 1a                         sta   $1ae0,x
+0037ff 65fc: bd f1 1a                         lda   $1af1,x
+003802 65ff: 9d f0 1a                         sta   $1af0,x
+003805 6602: bd 01 1b                         lda   $1b01,x
+003808 6605: 9d 00 1b                         sta   $1b00,x
+00380b 6608: bd 11 1b                         lda   $1b11,x
+00380e 660b: 9d 10 1b                         sta   $1b10,x
+003811 660e: e8                               inx
+003812 660f: ec 10 14                         cpx   $1410
+003815 6612: 90 ca                            bcc   L65DE
+003817 6614: 68                               pla
+003818 6615: aa                               tax
+003819 6616: 60                               rts

+00381a 6617: 8a           L6617               txa
+00381b 6618: 48                               pha
+00381c 6619: ce 0f 14                         dec   $140f
+00381f 661c: bd 51 1a     L661C               lda   $1a51,x
+003822 661f: 9d 50 1a                         sta   $1a50,x
+003825 6622: bd 61 1a                         lda   $1a61,x
+003828 6625: 9d 60 1a                         sta   $1a60,x
+00382b 6628: bd 71 1a                         lda   $1a71,x
+00382e 662b: 9d 70 1a                         sta   $1a70,x
+003831 662e: bd 81 1a                         lda   $1a81,x
+003834 6631: 9d 80 1a                         sta   $1a80,x
+003837 6634: bd 91 1a                         lda   $1a91,x
+00383a 6637: 9d 90 1a                         sta   $1a90,x
+00383d 663a: e8                               inx
+00383e 663b: ec 0f 14                         cpx   $140f
+003841 663e: 90 dc                            bcc   L661C
+003843 6640: 68                               pla
+003844 6641: aa                               tax
+003845 6642: 60                               rts

+003846 6643: ae 10 14     L6643               ldx   $1410
+003849 6646: a5 1c                            lda   $1c
+00384b 6648: 38                               sec
+00384c 6649: e9 07                            sbc   #$07
+00384e 664b: b0 02                            bcs   L664F
+003850 664d: a9 00                            lda   #$00
+003852 664f: a8           L664F               tay
+003853 6650: a5 1c        L6650               lda   $1c
+003855 6652: ca           L6652               dex
+003856 6653: 10 02                            bpl   L6657
+003858 6655: 18                               clc
+003859 6656: 60                               rts

+00385a 6657: dd a0 1a     L6657               cmp   $1aa0,x
+00385d 665a: 90 f6                            bcc   L6652
+00385f 665c: 98                               tya
+003860 665d: dd a0 1a                         cmp   $1aa0,x
+003863 6660: b0 ee                            bcs   L6650
+003865 6662: a5 1d                            lda   $1d
+003867 6664: dd b0 1a                         cmp   $1ab0,x
+00386a 6667: 90 e7                            bcc   L6650
+00386c 6669: e9 07                            sbc   #$07
+00386e 666b: 90 05                            bcc   L6672
+003870 666d: dd b0 1a                         cmp   $1ab0,x
+003873 6670: b0 de                            bcs   L6650
+003875 6672: a5 e8        L6672               lda   $e8
+003877 6674: f0 02                            beq   L6678
+003879 6676: 38                               sec
+00387a 6677: 60                               rts

+00387b 6678: 8a           L6678               txa
+00387c 6679: 48                               pha
+00387d 667a: a8                               tay
+00387e 667b: be b0 1a                         ldx   $1ab0,y
+003881 667e: b9 a0 1a                         lda   $1aa0,y
+003884 6681: a0 07                            ldy   #$07
+003886 6683: 20 d0 4c                         jsr   eraseFamily
+003889 6686: 68                               pla
+00388a 6687: aa                               tax
+00388b 6688: 20 d9 65                         jsr   L65D9
+00388e 668b: ad 20 0c                         lda   L0C20
+003891 668e: 8d 13 14                         sta   $1413
+003894 6691: a9 01                            lda   #$01
+003896 6693: 8d 12 14                         sta   $1412
+003899 6696: a9 00                            lda   #$00
+00389b 6698: a2 19                            ldx   #$19
+00389d 669a: 20 d0 4d                         jsr   detectCollision
+0038a0 669d: 38                               sec
+0038a1 669e: 60                               rts

+0038a2 669f: ae 0e 14     L669F               ldx   $140e
+0038a5 66a2: a5 1c                            lda   $1c
+0038a7 66a4: 38                               sec
+0038a8 66a5: e9 0d                            sbc   #$0d
+0038aa 66a7: b0 02                            bcs   L66AB
+0038ac 66a9: a9 00                            lda   #$00
+0038ae 66ab: a8           L66AB               tay
+0038af 66ac: a5 1c        L66AC               lda   $1c
+0038b1 66ae: ca           L66AE               dex
+0038b2 66af: 10 02                            bpl   L66B3
+0038b4 66b1: 18                               clc
+0038b5 66b2: 60                               rts

+0038b6 66b3: dd c0 19     L66B3               cmp   $19c0,x
+0038b9 66b6: 90 f6                            bcc   L66AE
+0038bb 66b8: 98                               tya
+0038bc 66b9: dd c0 19                         cmp   $19c0,x
+0038bf 66bc: b0 ee                            bcs   L66AC
+0038c1 66be: a5 1d                            lda   $1d
+0038c3 66c0: dd d0 19                         cmp   $19d0,x
+0038c6 66c3: 90 e7                            bcc   L66AC
+0038c8 66c5: e9 0d                            sbc   #$0d
+0038ca 66c7: 90 05                            bcc   L66CE
+0038cc 66c9: dd d0 19                         cmp   $19d0,x
+0038cf 66cc: b0 de                            bcs   L66AC
+0038d1 66ce: a5 e8        L66CE               lda   $e8
+0038d3 66d0: f0 02                            beq   L66D4
+0038d5 66d2: 38                               sec
+0038d6 66d3: 60                               rts

+0038d7 66d4: 8a           L66D4               txa
+0038d8 66d5: 48                               pha
+0038d9 66d6: a8                               tay
+0038da 66d7: be d0 19                         ldx   $19d0,y
+0038dd 66da: b9 c0 19                         lda   $19c0,y
+0038e0 66dd: a0 0d                            ldy   #$0d
+0038e2 66df: 20 21 4d                         jsr   eraseHulk
+0038e5 66e2: 68                               pla
+0038e6 66e3: 48                               pha
+0038e7 66e4: a8                               tay
+0038e8 66e5: b9 c0 19                         lda   $19c0,y
+0038eb 66e8: 18                               clc
+0038ec 66e9: 69 03                            adc   #$03
+0038ee 66eb: aa                               tax
+0038ef 66ec: b9 d0 19                         lda   $19d0,y
+0038f2 66ef: a8                               tay
+0038f3 66f0: a9 05                            lda   #$05
+0038f5 66f2: 20 27 5a                         jsr   L5A27
+0038f8 66f5: 68                               pla
+0038f9 66f6: aa                               tax
+0038fa 66f7: 20 f2 63                         jsr   L63F2
+0038fd 66fa: a9 03                            lda   #$03
+0038ff 66fc: a2 e8                            ldx   #$e8
+003901 66fe: 20 d0 4d                         jsr   detectCollision
+003904 6701: ad 22 0c                         lda   L0C22
+003907 6704: 8d 14 14                         sta   $1414
+00390a 6707: a9 00                            lda   #$00
+00390c 6709: 8d 15 14                         sta   ShootingDir-1
+00390f 670c: 38                               sec
+003910 670d: 60                               rts

+003911 670e: ae 0f 14     L670E               ldx   $140f
+003914 6711: a5 1c                            lda   $1c
+003916 6713: 38                               sec
+003917 6714: e9 0a                            sbc   #$0a
+003919 6716: b0 02                            bcs   L671A
+00391b 6718: a9 00                            lda   #$00
+00391d 671a: a8           L671A               tay
+00391e 671b: a5 1c        L671B               lda   $1c
+003920 671d: ca           L671D               dex
+003921 671e: 10 02                            bpl   L6722
+003923 6720: 18                               clc
+003924 6721: 60                               rts

+003925 6722: dd 50 1a     L6722               cmp   $1a50,x
+003928 6725: 90 f6                            bcc   L671D
+00392a 6727: 98                               tya
+00392b 6728: dd 50 1a                         cmp   $1a50,x
+00392e 672b: f0 02                            beq   L672F
+003930 672d: b0 ec                            bcs   L671B
+003932 672f: a5 1d        L672F               lda   $1d
+003934 6731: dd 60 1a                         cmp   $1a60,x
+003937 6734: 90 e5                            bcc   L671B
+003939 6736: e9 0d                            sbc   #$0d
+00393b 6738: 90 05                            bcc   L673F
+00393d 673a: dd 60 1a                         cmp   $1a60,x
+003940 673d: b0 dc                            bcs   L671B
+003942 673f: a5 e8        L673F               lda   $e8
+003944 6741: f0 02                            beq   L6745
+003946 6743: 38                               sec
+003947 6744: 60                               rts

+003948 6745: 8a           L6745               txa
+003949 6746: 48                               pha
+00394a 6747: a8                               tay
+00394b 6748: be 60 1a                         ldx   $1a60,y
+00394e 674b: b9 50 1a                         lda   $1a50,y
+003951 674e: a0 0d                            ldy   #$0d
+003953 6750: 20 21 4d                         jsr   eraseHulk
+003956 6753: 68                               pla
+003957 6754: aa                               tax
+003958 6755: 48                               pha
+003959 6756: bd 60 1a                         lda   $1a60,x
+00395c 6759: 18                               clc
+00395d 675a: 69 06                            adc   #$06
+00395f 675c: a8                               tay
+003960 675d: bd 50 1a                         lda   $1a50,x
+003963 6760: 18                               clc
+003964 6761: 69 03                            adc   #$03
+003966 6763: aa                               tax
+003967 6764: a9 55                            lda   #$55
+003969 6766: 20 74 4f                         jsr   L4F74
+00396c 6769: 68                               pla
+00396d 676a: aa                               tax
+00396e 676b: 20 17 66                         jsr   L6617
+003971 676e: a9 00                            lda   #$00
+003973 6770: a2 c8                            ldx   #$c8
+003975 6772: 20 d0 4d                         jsr   detectCollision
+003978 6775: ad 34 0c                         lda   L0C34
+00397b 6778: 8d 06 14                         sta   Level-1
+00397e 677b: ad 35 0c                         lda   L0C35
+003981 677e: 8d 22 14                         sta   $1422
+003984 6781: ad 36 0c                         lda   L0C36
+003987 6784: 8d 23 14                         sta   $1423
+00398a 6787: 38                               sec
+00398b 6788: 60                               rts

+00398c 6789: ce 24 14     L6789               dec   $1424
+00398f 678c: 30 01                            bmi   L678F
+003991 678e: 60                               rts

+003992 678f: ad 25 14     L678F               lda   $1425
+003995 6792: 20 4b 4c                         jsr   multiplyRndX
+003998 6795: 8d 24 14                         sta   $1424
+00399b 6798: ad 0f 14                         lda   $140f
+00399e 679b: 20 4b 4c                         jsr   multiplyRndX
+0039a1 679e: aa                               tax
+0039a2 679f: 20 a8 64                         jsr   L64A8
+0039a5 67a2: ad 0f 14                         lda   $140f
+0039a8 67a5: 20 4b 4c                         jsr   multiplyRndX
+0039ab 67a8: aa                               tax
+0039ac 67a9: 20 36 4c                         jsr   randomA
+0039af 67ac: cd 3a 0c                         cmp   L0C3A
+0039b2 67af: 90 07                            bcc   L67B8
+0039b4 67b1: cd 3b 0c                         cmp   L0C3B
+0039b7 67b4: 90 38                            bcc   L67EE
+0039b9 67b6: b0 19                            bcs   L67D1

+0039bb 67b8: bd 50 1a     L67B8               lda   $1a50,x
+0039be 67bb: ac 00 15                         ldy   $1500
+0039c1 67be: 20 32 68                         jsr   L6832
+0039c4 67c1: 9d 80 1a                         sta   $1a80,x
+0039c7 67c4: bd 60 1a                         lda   $1a60,x
+0039ca 67c7: ac 01 15                         ldy   $1501
+0039cd 67ca: 20 32 68                         jsr   L6832
+0039d0 67cd: 9d 90 1a                         sta   $1a90,x
+0039d3 67d0: 60                               rts

+0039d4 67d1: 8a           L67D1               txa
+0039d5 67d2: a8                               tay
+0039d6 67d3: ad 15 0c                         lda   L0C15
+0039d9 67d6: 0a                               asl   A
+0039da 67d7: 48                               pha
+0039db 67d8: 20 4b 4c                         jsr   multiplyRndX
+0039de 67db: 38                               sec
+0039df 67dc: ed 15 0c                         sbc   L0C15
+0039e2 67df: 99 80 1a                         sta   $1a80,y
+0039e5 67e2: 68                               pla
+0039e6 67e3: 20 4b 4c                         jsr   multiplyRndX
+0039e9 67e6: 38                               sec
+0039ea 67e7: ed 15 0c                         sbc   L0C15
+0039ed 67ea: 99 90 1a                         sta   $1a90,y
+0039f0 67ed: 60                               rts

+0039f1 67ee: bd 50 1a     L67EE               lda   $1a50,x
+0039f4 67f1: 85 02                            sta   _strobePtrOffs
+0039f6 67f3: ad 60 1a                         lda   $1a60
+0039f9 67f6: 85 03                            sta   $03
+0039fb 67f8: ad 00 15                         lda   $1500
+0039fe 67fb: 85 04                            sta   _length
+003a00 67fd: ad 01 15                         lda   $1501
+003a03 6800: 85 05                            sta   _ix
+003a05 6802: 46 02        L6802               lsr   _strobePtrOffs
+003a07 6804: 46 03                            lsr   $03
+003a09 6806: 46 04                            lsr   _length
+003a0b 6808: 46 05                            lsr   _ix
+003a0d 680a: a5 02                            lda   _strobePtrOffs
+003a0f 680c: e5 04                            sbc   _length
+003a11 680e: a8                               tay
+003a12 680f: b0 02                            bcs   L6813
+003a14 6811: 49 ff                            eor   #$ff
+003a16 6813: cd 15 0c     L6813               cmp   L0C15
+003a19 6816: b0 ea                            bcs   L6802
+003a1b 6818: 84 06                            sty   _strobePtr
+003a1d 681a: a5 03                            lda   $03
+003a1f 681c: e5 05                            sbc   _ix
+003a21 681e: a8                               tay
+003a22 681f: b0 02                            bcs   L6823
+003a24 6821: 49 ff                            eor   #$ff
+003a26 6823: cd 15 0c     L6823               cmp   L0C15
+003a29 6826: b0 da                            bcs   L6802
+003a2b 6828: a5 06                            lda   _strobePtr
+003a2d 682a: 9d 80 1a                         sta   $1a80,x
+003a30 682d: 98                               tya
+003a31 682e: 9d 90 1a                         sta   $1a90,x
+003a34 6831: 60                               rts

+003a35 6832: 85 03        L6832               sta   $03
+003a37 6834: 4a                               lsr   A
+003a38 6835: 4a                               lsr   A
+003a39 6836: 4a                               lsr   A
+003a3a 6837: 4a                               lsr   A
+003a3b 6838: 4a                               lsr   A
+003a3c 6839: 85 02                            sta   _strobePtrOffs
+003a3e 683b: 98                               tya
+003a3f 683c: 4a                               lsr   A
+003a40 683d: 4a                               lsr   A
+003a41 683e: 4a                               lsr   A
+003a42 683f: 4a                               lsr   A
+003a43 6840: 4a                               lsr   A
+003a44 6841: e5 02                            sbc   _strobePtrOffs
+003a46 6843: d0 08                            bne   L684D
+003a48 6845: a9 01                            lda   #$01
+003a4a 6847: c4 03                            cpy   $03
+003a4c 6849: b0 02                            bcs   L684D
+003a4e 684b: a9 ff                            lda   #$ff
+003a50 684d: 60           L684D               rts

+003a51 684e: a2 02        L684E               ldx   #$02
+003a53 6850: bd 0a 15     L6850               lda   Score0,x
+003a56 6853: dd 32 14                         cmp   $1432,x
+003a59 6856: 90 11                            bcc   L6869
+003a5b 6858: d0 06                            bne   L6860
+003a5d 685a: ca                               dex
+003a5e 685b: 10 f3                            bpl   L6850
+003a60 685d: 4c 69 68                         jmp   L6869

+003a63 6860: bd 0a 15     L6860               lda   Score0,x
+003a66 6863: 9d 32 14                         sta   $1432,x
+003a69 6866: ca                               dex
+003a6a 6867: 10 f7                            bpl   L6860
+003a6c 6869: 60           L6869               rts

                           ; NW: high score?
+003a6d 686a: 20 b8 51     showHighScore       jsr   showText
+003a70 686d: 0d                               .dd1  $0d
+003a71 686e: 0c                               .dd1  12
+003a72 686f: 00                               .dd1  0
+003a73 6870: 48 49 47 48+                     .str  “HIGH SCORE:”
+003a7e 687b: 00                               .dd1  $00

+003a7f 687c: a2 02                            ldx   #$02
+003a81 687e: bd 32 14     L687E               lda   $1432,x
+003a84 6881: 95 00                            sta   _spriteEntryPtr,x
+003a86 6883: ca                               dex
+003a87 6884: 10 f8                            bpl   L687E
+003a89 6886: a0 00                            ldy   #$00
+003a8b 6888: 20 c4 4e     L6888               jsr   stats04
+003a8e 688b: c8                               iny
+003a8f 688c: a5 00                            lda   _spriteEntryPtr
+003a91 688e: 05 01                            ora   _spriteEntryPtr+1
+003a93 6890: 05 02                            ora   _strobePtrOffs
+003a95 6892: d0 f4                            bne   L6888
+003a97 6894: 98                               tya
+003a98 6895: 18                               clc
+003a99 6896: 65 e0                            adc   TextCol
+003a9b 6898: 85 e0                            sta   TextCol
+003a9d 689a: a2 02                            ldx   #$02
+003a9f 689c: bd 32 14     L689C               lda   $1432,x
+003aa2 689f: 95 00                            sta   _spriteEntryPtr,x
+003aa4 68a1: ca                               dex
+003aa5 68a2: 10 f8                            bpl   L689C
+003aa7 68a4: c6 e0        L68A4               dec   TextCol
+003aa9 68a6: 20 c4 4e                         jsr   stats04
+003aac 68a9: 18                               clc
+003aad 68aa: 69 b0                            adc   #$b0
+003aaf 68ac: a6 e0                            ldx   TextCol
+003ab1 68ae: a4 e1                            ldy   TextPixelLine
+003ab3 68b0: 20 08 51                         jsr   printChar
+003ab6 68b3: a5 00                            lda   _spriteEntryPtr
+003ab8 68b5: 05 01                            ora   _spriteEntryPtr+1
+003aba 68b7: 05 02                            ora   _strobePtrOffs
+003abc 68b9: d0 e9                            bne   L68A4
+003abe 68bb: 60                               rts

+003abf 68bc: ff ff ff ff+                     .fill 68,$ff

+003b03 6900: 4c 15 69     L6900               jmp   L6915

+003b06 6903: 4c 0f 6a     L6903               jmp   L6A0F

+003b09 6906: 4c 7b 6b     L6906               jmp   L6B7B

+003b0c 6909: 4c 67 6c     L6909               jmp   L6C67

+003b0f 690c: 4c 34 6e     L690C               jmp   L6E34

+003b12 690f: 4c 98 6e     L690F               jmp   L6E98

+003b15 6912: 4c 13 6f     L6912               jmp   L6F13

+003b18 6915: ae 4d 0c     L6915               ldx   L0C4D
+003b1b 6918: e8                               inx
+003b1c 6919: ad 21 14                         lda   $1421
+003b1f 691c: 20 00 4c                         jsr   divideAX
+003b22 691f: 85 08                            sta   _destPtr
+003b24 6921: ac 27 14                         ldy   $1427
+003b27 6924: 88           @loop               dey
+003b28 6925: 10 03                            bpl   L692A
+003b2a 6927: 4c 7d 69                         jmp   L697D

+003b2d 692a: a9 02        L692A               lda   #$02
+003b2f 692c: 06 4e                            asl   MON_RNDL
+003b31 692e: a6 4f                            ldx   MON_RNDH
+003b33 6930: b0 17                            bcs   L6949
+003b35 6932: 10 02                            bpl   L6936
+003b37 6934: a9 b2                            lda   #$b2
+003b39 6936: 99 f0 1c     L6936               sta   $1cf0,y
+003b3c 6939: a9 f1                            lda   #$f1
+003b3e 693b: 20 4b 4c                         jsr   multiplyRndX
+003b41 693e: 18                               clc
+003b42 693f: 69 02                            adc   #$02
+003b44 6941: 29 fe                            and   #$fe
+003b46 6943: 99 e0 1c                         sta   $1ce0,y
+003b49 6946: 4c 58 69                         jmp   L6958

+003b4c 6949: 10 02        L6949               bpl   L694D
+003b4e 694b: a9 f2                            lda   #$f2
+003b50 694d: 99 e0 1c     L694D               sta   $1ce0,y
+003b53 6950: a9 b3                            lda   #$b3
+003b55 6952: 20 4b 4c                         jsr   multiplyRndX
+003b58 6955: 99 f0 1c                         sta   $1cf0,y
+003b5b 6958: a9 00        L6958               lda   #$00
+003b5d 695a: 99 00 1d                         sta   $1d00,y
+003b60 695d: 99 10 1d                         sta   $1d10,y
+003b63 6960: 99 60 1d                         sta   $1d60,y
+003b66 6963: 98                               tya
+003b67 6964: 29 01                            and   #$01
+003b69 6966: 99 20 1d                         sta   $1d20,y
+003b6c 6969: a5 08                            lda   _destPtr
+003b6e 696b: 99 30 1d                         sta   $1d30,y
+003b71 696e: ad 52 0c                         lda   L0C52
+003b74 6971: 20 4b 4c                         jsr   multiplyRndX
+003b77 6974: 18                               clc
+003b78 6975: 6d 53 0c                         adc   L0C53
+003b7b 6978: 99 50 1d                         sta   $1d50,y
+003b7e 697b: 10 a7                            bpl   @loop
+003b80 697d: ad 21 14     L697D               lda   $1421
+003b83 6980: ae 4e 0c                         ldx   L0C4E
+003b86 6983: e8                               inx
+003b87 6984: 20 00 4c                         jsr   divideAX
+003b8a 6987: 85 08                            sta   _destPtr
+003b8c 6989: ac 28 14                         ldy   $1428
+003b8f 698c: 88           L698C               dey
+003b90 698d: 10 15                            bpl   L69A4
+003b92 698f: a9 00                            lda   #$00
+003b94 6991: 8d 29 14                         sta   $1429
+003b97 6994: a9 ff                            lda   #$ff
+003b99 6996: 8d 2e 14                         sta   $142e
+003b9c 6999: ad 21 14                         lda   $1421
+003b9f 699c: 18                               clc
+003ba0 699d: 6d 59 0c                         adc   L0C59
+003ba3 69a0: 8d 2a 14                         sta   $142a
+003ba6 69a3: 60                               rts

+003ba7 69a4: 06 4e        L69A4               asl   MON_RNDL
+003ba9 69a6: a5 4f                            lda   MON_RNDH
+003bab 69a8: 30 22                            bmi   L69CC
+003bad 69aa: a9 10                            lda   #$10
+003baf 69ac: 90 02                            bcc   L69B0
+003bb1 69ae: a9 a0                            lda   #$a0
+003bb3 69b0: 85 06        L69B0               sta   _strobePtr
+003bb5 69b2: a9 3e                            lda   #$3e
+003bb7 69b4: 20 4b 4c                         jsr   multiplyRndX
+003bba 69b7: 18                               clc
+003bbb 69b8: 65 06                            adc   _strobePtr
+003bbd 69ba: 09 01                            ora   #$01
+003bbf 69bc: 99 70 1d                         sta   $1d70,y
+003bc2 69bf: a9 90                            lda   #$90
+003bc4 69c1: 20 4b 4c                         jsr   multiplyRndX
+003bc7 69c4: 18                               clc
+003bc8 69c5: 69 10                            adc   #$10
+003bca 69c7: 99 90 1d                         sta   $1d90,y
+003bcd 69ca: d0 20                            bne   L69EC
+003bcf 69cc: a9 10        L69CC               lda   #$10
+003bd1 69ce: 90 02                            bcc   L69D2
+003bd3 69d0: a9 80                            lda   #$80
+003bd5 69d2: 85 06        L69D2               sta   _strobePtr
+003bd7 69d4: a9 20                            lda   #$20
+003bd9 69d6: 20 4b 4c                         jsr   multiplyRndX
+003bdc 69d9: 18                               clc
+003bdd 69da: 65 06                            adc   _strobePtr
+003bdf 69dc: 99 90 1d                         sta   $1d90,y
+003be2 69df: a9 ce                            lda   #$ce
+003be4 69e1: 20 4b 4c                         jsr   multiplyRndX
+003be7 69e4: 18                               clc
+003be8 69e5: 69 10                            adc   #$10
+003bea 69e7: 09 01                            ora   #$01
+003bec 69e9: 99 70 1d                         sta   $1d70,y
+003bef 69ec: a9 00        L69EC               lda   #$00
+003bf1 69ee: 99 b0 1d                         sta   $1db0,y
+003bf4 69f1: 99 d0 1d                         sta   $1dd0,y
+003bf7 69f4: a5 08                            lda   _destPtr
+003bf9 69f6: 99 10 1e                         sta   $1e10,y
+003bfc 69f9: a2 00                            ldx   #$00
+003bfe 69fb: 20 36 4c                         jsr   randomA
+003c01 69fe: 10 02                            bpl   L6A02
+003c03 6a00: a2 03                            ldx   #$03
+003c05 6a02: 8a           L6A02               txa
+003c06 6a03: 99 30 1e                         sta   $1e30,y
+003c09 6a06: 98                               tya
+003c0a 6a07: 29 03                            and   #$03
+003c0c 6a09: 99 f0 1d                         sta   $1df0,y
+003c0f 6a0c: 4c 8c 69                         jmp   L698C

+003c12 6a0f: ae 27 14     L6A0F               ldx   $1427
+003c15 6a12: ca           L6A12               dex
+003c16 6a13: 10 01                            bpl   L6A16
+003c18 6a15: 60                               rts

+003c19 6a16: de 20 1d     L6A16               dec   $1d20,x
+003c1c 6a19: 10 f7                            bpl   L6A12
+003c1e 6a1b: ad 4d 0c                         lda   L0C4D
+003c21 6a1e: 9d 20 1d                         sta   $1d20,x
+003c24 6a21: 86 00                            stx   _spriteEntryPtr
+003c26 6a23: a4 00                            ldy   _spriteEntryPtr
+003c28 6a25: be f0 1c                         ldx   $1cf0,y
+003c2b 6a28: b9 e0 1c                         lda   $1ce0,y
+003c2e 6a2b: a0 0d                            ldy   #$0d
+003c30 6a2d: 20 21 4d                         jsr   eraseHulk
+003c33 6a30: a4 00                            ldy   _spriteEntryPtr
+003c35 6a32: b9 e0 1c                         lda   $1ce0,y
+003c38 6a35: 18                               clc
+003c39 6a36: 79 00 1d                         adc   $1d00,y
+003c3c 6a39: d0 02                            bne   L6A3D
+003c3e 6a3b: a9 02                            lda   #$02
+003c40 6a3d: c9 f3        L6A3D               cmp   #$f3
+003c42 6a3f: 90 10                            bcc   L6A51
+003c44 6a41: a9 f2                            lda   #$f2
+003c46 6a43: be 00 1d                         ldx   $1d00,y
+003c49 6a46: 10 02                            bpl   L6A4A
+003c4b 6a48: a9 02                            lda   #$02
+003c4d 6a4a: 48           L6A4A               pha
+003c4e 6a4b: a9 00                            lda   #$00
+003c50 6a4d: 99 00 1d                         sta   $1d00,y
+003c53 6a50: 68                               pla
+003c54 6a51: 99 e0 1c     L6A51               sta   $1ce0,y
+003c57 6a54: b9 f0 1c                         lda   $1cf0,y
+003c5a 6a57: 18                               clc
+003c5b 6a58: 79 10 1d                         adc   $1d10,y
+003c5e 6a5b: c9 b3                            cmp   #$b3
+003c60 6a5d: 90 10                            bcc   L6A6F
+003c62 6a5f: a9 b2                            lda   #$b2
+003c64 6a61: be 10 1d                         ldx   $1d10,y
+003c67 6a64: 10 02                            bpl   L6A68
+003c69 6a66: a9 00                            lda   #$00
+003c6b 6a68: 48           L6A68               pha
+003c6c 6a69: a9 00                            lda   #$00
+003c6e 6a6b: 99 10 1d                         sta   $1d10,y
+003c71 6a6e: 68                               pla
+003c72 6a6f: 99 f0 1c     L6A6F               sta   $1cf0,y
+003c75 6a72: b9 30 1d                         lda   $1d30,y
+003c78 6a75: 29 03                            and   #$03
+003c7a 6a77: aa                               tax
+003c7b 6a78: bd 10 09                         lda   L0910,x
+003c7e 6a7b: 85 06                            sta   _strobePtr
+003c80 6a7d: bd 18 09                         lda   L0918,x
+003c83 6a80: 85 07                            sta   _strobePtr+1
+003c85 6a82: be e0 1c                         ldx   $1ce0,y
+003c88 6a85: b9 f0 1c                         lda   $1cf0,y
+003c8b 6a88: a8                               tay
+003c8c 6a89: 20 f6 4c                         jsr   drawHulk
+003c8f 6a8c: a6 00                            ldx   _spriteEntryPtr
+003c91 6a8e: de 30 1d                         dec   $1d30,x
+003c94 6a91: 10 3f                            bpl   L6AD2
+003c96 6a93: ad 4a 0c                         lda   L0C4A
+003c99 6a96: 20 4b 4c                         jsr   multiplyRndX
+003c9c 6a99: 09 03                            ora   #$03
+003c9e 6a9b: a6 00                            ldx   _spriteEntryPtr
+003ca0 6a9d: 9d 30 1d                         sta   $1d30,x
+003ca3 6aa0: bd e0 1c                         lda   $1ce0,x
+003ca6 6aa3: ac 00 15                         ldy   $1500
+003ca9 6aa6: 20 3a 6b                         jsr   L6B3A
+003cac 6aa9: 9d 00 1d                         sta   $1d00,x
+003caf 6aac: bd f0 1c                         lda   $1cf0,x
+003cb2 6aaf: ac 01 15                         ldy   $1501
+003cb5 6ab2: 20 3a 6b                         jsr   L6B3A
+003cb8 6ab5: 9d 10 1d                         sta   $1d10,x
+003cbb 6ab8: a9 00                            lda   #$00
+003cbd 6aba: 9d 60 1d                         sta   $1d60,x
+003cc0 6abd: de 50 1d                         dec   $1d50,x
+003cc3 6ac0: 10 10                            bpl   L6AD2
+003cc5 6ac2: ad 52 0c                         lda   L0C52
+003cc8 6ac5: 20 4b 4c                         jsr   multiplyRndX
+003ccb 6ac8: a6 00                            ldx   _spriteEntryPtr
+003ccd 6aca: 9d 50 1d                         sta   $1d50,x
+003cd0 6acd: a9 01                            lda   #$01
+003cd2 6acf: 9d 60 1d                         sta   $1d60,x
+003cd5 6ad2: bd 60 1d     L6AD2               lda   $1d60,x
+003cd8 6ad5: f0 60                            beq   L6B37
+003cda 6ad7: bd 30 1d                         lda   $1d30,x
+003cdd 6ada: 29 03                            and   #$03
+003cdf 6adc: d0 59                            bne   L6B37
+003ce1 6ade: ac 28 14                         ldy   $1428
+003ce4 6ae1: cc 58 0c                         cpy   L0C58
+003ce7 6ae4: b0 51                            bcs   L6B37
+003ce9 6ae6: bd e0 1c                         lda   $1ce0,x
+003cec 6ae9: 09 01                            ora   #$01
+003cee 6aeb: c9 11                            cmp   #$11
+003cf0 6aed: b0 02                            bcs   L6AF1
+003cf2 6aef: a9 11                            lda   #$11
+003cf4 6af1: c9 e0        L6AF1               cmp   #$e0
+003cf6 6af3: 90 02                            bcc   L6AF7
+003cf8 6af5: a9 df                            lda   #$df
+003cfa 6af7: 99 70 1d     L6AF7               sta   $1d70,y
+003cfd 6afa: bd f0 1c                         lda   $1cf0,x
+003d00 6afd: c9 11                            cmp   #$11
+003d02 6aff: b0 02                            bcs   L6B03
+003d04 6b01: a9 11                            lda   #$11
+003d06 6b03: c9 a0        L6B03               cmp   #$a0
+003d08 6b05: 90 02                            bcc   L6B09
+003d0a 6b07: a9 9f                            lda   #$9f
+003d0c 6b09: 99 90 1d     L6B09               sta   $1d90,y
+003d0f 6b0c: a9 00                            lda   #$00
+003d11 6b0e: 99 b0 1d                         sta   $1db0,y
+003d14 6b11: 99 d0 1d                         sta   $1dd0,y
+003d17 6b14: 99 f0 1d                         sta   $1df0,y
+003d1a 6b17: 99 10 1e                         sta   $1e10,y
+003d1d 6b1a: 99 30 1e                         sta   $1e30,y
+003d20 6b1d: ee 28 14                         inc   $1428
+003d23 6b20: de 40 1d                         dec   $1d40,x
+003d26 6b23: 10 12                            bpl   L6B37
+003d28 6b25: a4 00                            ldy   _spriteEntryPtr
+003d2a 6b27: be f0 1c                         ldx   $1cf0,y
+003d2d 6b2a: b9 e0 1c                         lda   $1ce0,y
+003d30 6b2d: a0 0d                            ldy   #$0d
+003d32 6b2f: 20 21 4d                         jsr   eraseHulk
+003d35 6b32: a6 00                            ldx   _spriteEntryPtr
+003d37 6b34: 20 f0 6d                         jsr   L6DF0
+003d3a 6b37: 4c 12 6a     L6B37               jmp   L6A12

+003d3d 6b3a: 85 06        L6B3A               sta   _strobePtr
+003d3f 6b3c: 84 07                            sty   _strobePtr+1
+003d41 6b3e: e5 07                            sbc   _strobePtr+1
+003d43 6b40: b0 02                            bcs   L6B44
+003d45 6b42: 49 ff                            eor   #$ff
+003d47 6b44: cd 50 0c     L6B44               cmp   L0C50
+003d4a 6b47: 08                               php
+003d4b 6b48: 20 36 4c                         jsr   randomA
+003d4e 6b4b: a9 00                            lda   #$00
+003d50 6b4d: a4 4e                            ldy   MON_RNDL
+003d52 6b4f: c0 60                            cpy   #$60
+003d54 6b51: 90 0b                            bcc   L6B5E
+003d56 6b53: ad 43 0c                         lda   L0C43
+003d59 6b56: c0 b0                            cpy   #$b0
+003d5b 6b58: 90 04                            bcc   L6B5E
+003d5d 6b5a: 49 ff                            eor   #$ff
+003d5f 6b5c: 69 00                            adc   #$00
+003d61 6b5e: 28           L6B5E               plp
+003d62 6b5f: b0 19                            bcs   L6B7A
+003d64 6b61: a4 4f                            ldy   MON_RNDH
+003d66 6b63: cc 56 0c                         cpy   L0C56
+003d69 6b66: b0 12                            bcs   L6B7A
+003d6b 6b68: a4 06                            ldy   _strobePtr
+003d6d 6b6a: c4 07                            cpy   _strobePtr+1
+003d6f 6b6c: a8                               tay
+003d70 6b6d: b0 04                            bcs   L6B73
+003d72 6b6f: 10 09                            bpl   L6B7A
+003d74 6b71: 90 03                            bcc   L6B76

+003d76 6b73: 30 05        L6B73               bmi   L6B7A
+003d78 6b75: 18                               clc
+003d79 6b76: 49 ff        L6B76               eor   #$ff
+003d7b 6b78: 69 01                            adc   #$01
+003d7d 6b7a: 60           L6B7A               rts

+003d7e 6b7b: ae 28 14     L6B7B               ldx   $1428
+003d81 6b7e: ca           L6B7E               dex
+003d82 6b7f: 10 01                            bpl   L6B82
+003d84 6b81: 60                               rts

+003d85 6b82: de f0 1d     L6B82               dec   $1df0,x
+003d88 6b85: 10 f7                            bpl   L6B7E
+003d8a 6b87: 86 00                            stx   _spriteEntryPtr
+003d8c 6b89: ad 4e 0c                         lda   L0C4E
+003d8f 6b8c: 9d f0 1d                         sta   $1df0,x
+003d92 6b8f: a4 00                            ldy   _spriteEntryPtr
+003d94 6b91: be 90 1d                         ldx   $1d90,y
+003d97 6b94: b9 70 1d                         lda   $1d70,y
+003d9a 6b97: a0 0f                            ldy   #$0f
+003d9c 6b99: 20 21 4d                         jsr   eraseHulk
+003d9f 6b9c: a6 00                            ldx   _spriteEntryPtr
+003da1 6b9e: bd 70 1d     L6B9E               lda   $1d70,x
+003da4 6ba1: 18                               clc
+003da5 6ba2: 7d b0 1d                         adc   $1db0,x
+003da8 6ba5: c9 08                            cmp   #$08
+003daa 6ba7: 90 04                            bcc   L6BAD
+003dac 6ba9: c9 e8                            cmp   #$e8
+003dae 6bab: 90 10                            bcc   L6BBD
+003db0 6bad: bd b0 1d     L6BAD               lda   $1db0,x
+003db3 6bb0: 49 ff                            eor   #$ff
+003db5 6bb2: 18                               clc
+003db6 6bb3: 69 01                            adc   #$01
+003db8 6bb5: 9d b0 1d                         sta   $1db0,x
+003dbb 6bb8: 20 2f 6c                         jsr   L6C2F
+003dbe 6bbb: 10 e1                            bpl   L6B9E
+003dc0 6bbd: 9d 70 1d     L6BBD               sta   $1d70,x
+003dc3 6bc0: bd 90 1d     L6BC0               lda   $1d90,x
+003dc6 6bc3: 18                               clc
+003dc7 6bc4: 7d d0 1d                         adc   $1dd0,x
+003dca 6bc7: c9 08                            cmp   #$08
+003dcc 6bc9: 90 04                            bcc   L6BCF
+003dce 6bcb: c9 a8                            cmp   #$a8
+003dd0 6bcd: 90 10                            bcc   L6BDF
+003dd2 6bcf: bd d0 1d     L6BCF               lda   $1dd0,x
+003dd5 6bd2: 49 ff                            eor   #$ff
+003dd7 6bd4: 18                               clc
+003dd8 6bd5: 69 01                            adc   #$01
+003dda 6bd7: 9d d0 1d                         sta   $1dd0,x
+003ddd 6bda: 20 2f 6c                         jsr   L6C2F
+003de0 6bdd: 10 e1                            bpl   L6BC0
+003de2 6bdf: 9d 90 1d     L6BDF               sta   $1d90,x
+003de5 6be2: bd 10 1e                         lda   $1e10,x
+003de8 6be5: 29 03                            and   #$03
+003dea 6be7: 5d 30 1e                         eor   $1e30,x
+003ded 6bea: a8                               tay
+003dee 6beb: b9 20 09                         lda   L0920,y
+003df1 6bee: 85 06                            sta   _strobePtr
+003df3 6bf0: b9 28 09                         lda   L0928,y
+003df6 6bf3: 85 07                            sta   _strobePtr+1
+003df8 6bf5: bc 90 1d                         ldy   $1d90,x
+003dfb 6bf8: bd 70 1d                         lda   $1d70,x
+003dfe 6bfb: aa                               tax
+003dff 6bfc: 20 f6 4c                         jsr   drawHulk
+003e02 6bff: a6 00                            ldx   _spriteEntryPtr
+003e04 6c01: de 10 1e                         dec   $1e10,x
+003e07 6c04: 10 26                            bpl   L6C2C
+003e09 6c06: ad 4b 0c                         lda   L0C4B
+003e0c 6c09: 20 4b 4c                         jsr   multiplyRndX
+003e0f 6c0c: a6 00                            ldx   _spriteEntryPtr
+003e11 6c0e: 9d 10 1e                         sta   $1e10,x
+003e14 6c11: bd 70 1d                         lda   $1d70,x
+003e17 6c14: ac 00 15                         ldy   $1500
+003e1a 6c17: 20 38 6c                         jsr   L6C38
+003e1d 6c1a: 9d b0 1d                         sta   $1db0,x
+003e20 6c1d: bd 90 1d                         lda   $1d90,x
+003e23 6c20: ac 01 15                         ldy   $1501
+003e26 6c23: 20 38 6c                         jsr   L6C38
+003e29 6c26: 9d d0 1d                         sta   $1dd0,x
+003e2c 6c29: 20 2f 6c                         jsr   L6C2F
+003e2f 6c2c: 4c 7e 6b     L6C2C               jmp   L6B7E

+003e32 6c2f: bd 30 1e     L6C2F               lda   $1e30,x
+003e35 6c32: 49 03                            eor   #$03
+003e37 6c34: 9d 30 1e                         sta   $1e30,x
+003e3a 6c37: 60                               rts

+003e3b 6c38: 84 06        L6C38               sty   _strobePtr
+003e3d 6c3a: c5 06                            cmp   _strobePtr
+003e3f 6c3c: 08                               php
+003e40 6c3d: ad 44 0c                         lda   L0C44
+003e43 6c40: 0a                               asl   A
+003e44 6c41: 20 4b 4c                         jsr   multiplyRndX
+003e47 6c44: 38                               sec
+003e48 6c45: ed 44 0c                         sbc   L0C44
+003e4b 6c48: 69 00                            adc   #$00
+003e4d 6c4a: 29 fe                            and   #$fe
+003e4f 6c4c: a6 00                            ldx   _spriteEntryPtr
+003e51 6c4e: a4 4e                            ldy   MON_RNDL
+003e53 6c50: cc 54 0c                         cpy   L0C54
+003e56 6c53: b0 10                            bcs   L6C65
+003e58 6c55: 28                               plp
+003e59 6c56: a8                               tay
+003e5a 6c57: b0 04                            bcs   L6C5D
+003e5c 6c59: 10 09                            bpl   L6C64
+003e5e 6c5b: 90 03                            bcc   L6C60

+003e60 6c5d: 30 05        L6C5D               bmi   L6C64
+003e62 6c5f: 18                               clc
+003e63 6c60: 49 ff        L6C60               eor   #$ff
+003e65 6c62: 69 01                            adc   #$01
+003e67 6c64: 60           L6C64               rts

+003e68 6c65: 28           L6C65               plp
+003e69 6c66: 60                               rts

+003e6a 6c67: ae 29 14     L6C67               ldx   $1429
+003e6d 6c6a: ca           L6C6A               dex
+003e6e 6c6b: 10 03                            bpl   L6C70
+003e70 6c6d: 4c 24 6d                         jmp   L6D24

+003e73 6c70: de 90 1e     L6C70               dec   $1e90,x
+003e76 6c73: 10 f5                            bpl   L6C6A
+003e78 6c75: 86 00                            stx   _spriteEntryPtr
+003e7a 6c77: ad 4f 0c                         lda   L0C4F
+003e7d 6c7a: 9d 90 1e                         sta   $1e90,x
+003e80 6c7d: a4 00                            ldy   _spriteEntryPtr
+003e82 6c7f: be 60 1e                         ldx   $1e60,y
+003e85 6c82: b9 50 1e                         lda   $1e50,y
+003e88 6c85: a0 07                            ldy   #$07
+003e8a 6c87: 20 d0 4c                         jsr   eraseFamily
+003e8d 6c8a: a6 00                            ldx   _spriteEntryPtr
+003e8f 6c8c: bd 50 1e     L6C8C               lda   $1e50,x
+003e92 6c8f: 18                               clc
+003e93 6c90: 7d 70 1e                         adc   $1e70,x
+003e96 6c93: bc 70 1e                         ldy   $1e70,x
+003e99 6c96: 30 05                            bmi   L6C9D
+003e9b 6c98: 90 10                            bcc   L6CAA
+003e9d 6c9a: 18                               clc
+003e9e 6c9b: 90 02                            bcc   L6C9F

+003ea0 6c9d: b0 0b        L6C9D               bcs   L6CAA
+003ea2 6c9f: 98           L6C9F               tya
+003ea3 6ca0: 49 ff                            eor   #$ff
+003ea5 6ca2: 69 01                            adc   #$01
+003ea7 6ca4: 9d 70 1e                         sta   $1e70,x
+003eaa 6ca7: 4c 8c 6c                         jmp   L6C8C

+003ead 6caa: 9d 50 1e     L6CAA               sta   $1e50,x
+003eb0 6cad: bd 60 1e     L6CAD               lda   $1e60,x
+003eb3 6cb0: 18                               clc
+003eb4 6cb1: 7d 80 1e                         adc   $1e80,x
+003eb7 6cb4: c9 b8                            cmp   #$b8
+003eb9 6cb6: 90 0d                            bcc   L6CC5
+003ebb 6cb8: bd 80 1e                         lda   $1e80,x
+003ebe 6cbb: 49 ff                            eor   #$ff
+003ec0 6cbd: 69 00                            adc   #$00
+003ec2 6cbf: 9d 80 1e                         sta   $1e80,x
+003ec5 6cc2: 4c ad 6c                         jmp   L6CAD

+003ec8 6cc5: 9d 60 1e     L6CC5               sta   $1e60,x
+003ecb 6cc8: de a0 1e                         dec   $1ea0,x
+003ece 6ccb: 10 06                            bpl   L6CD3
+003ed0 6ccd: 20 f2 6c                         jsr   L6CF2
+003ed3 6cd0: 4c 6a 6c                         jmp   L6C6A

+003ed6 6cd3: bd a0 1e     L6CD3               lda   $1ea0,x
+003ed9 6cd6: 29 01                            and   #$01
+003edb 6cd8: a8                               tay
+003edc 6cd9: b9 30 09                         lda   L0930,y
+003edf 6cdc: 85 06                            sta   _strobePtr
+003ee1 6cde: b9 34 09                         lda   L0934,y
+003ee4 6ce1: 85 07                            sta   _strobePtr+1
+003ee6 6ce3: bc 60 1e                         ldy   $1e60,x
+003ee9 6ce6: bd 50 1e                         lda   $1e50,x
+003eec 6ce9: aa                               tax
+003eed 6cea: 20 ac 4c                         jsr   drawFamily
+003ef0 6ced: a6 00                            ldx   _spriteEntryPtr
+003ef2 6cef: 4c 6a 6c                         jmp   L6C6A

+003ef5 6cf2: 8a           L6CF2               txa
+003ef6 6cf3: 48                               pha
+003ef7 6cf4: ce 29 14                         dec   $1429
+003efa 6cf7: bd 51 1e     L6CF7               lda   $1e51,x
+003efd 6cfa: 9d 50 1e                         sta   $1e50,x
+003f00 6cfd: bd 61 1e                         lda   $1e61,x
+003f03 6d00: 9d 60 1e                         sta   $1e60,x
+003f06 6d03: bd 71 1e                         lda   $1e71,x
+003f09 6d06: 9d 70 1e                         sta   $1e70,x
+003f0c 6d09: bd 81 1e                         lda   $1e81,x
+003f0f 6d0c: 9d 80 1e                         sta   $1e80,x
+003f12 6d0f: bd 91 1e                         lda   $1e91,x
+003f15 6d12: 9d 90 1e                         sta   $1e90,x
+003f18 6d15: bd a1 1e                         lda   $1ea1,x
+003f1b 6d18: 9d a0 1e                         sta   $1ea0,x
+003f1e 6d1b: e8                               inx
+003f1f 6d1c: ec 29 14                         cpx   $1429
+003f22 6d1f: 90 d6                            bcc   L6CF7
+003f24 6d21: 68                               pla
+003f25 6d22: aa                               tax
+003f26 6d23: 60                               rts

+003f27 6d24: ce 2a 14     L6D24               dec   $142a
+003f2a 6d27: 30 01                            bmi   L6D2A
+003f2c 6d29: 60           L6D29               rts

+003f2d 6d2a: ad 2b 14     L6D2A               lda   $142b
+003f30 6d2d: 20 4b 4c                         jsr   multiplyRndX
+003f33 6d30: 8d 2a 14                         sta   $142a
+003f36 6d33: ad 28 14                         lda   $1428
+003f39 6d36: f0 f1                            beq   L6D29
+003f3b 6d38: 20 4b 4c                         jsr   multiplyRndX
+003f3e 6d3b: aa                               tax
+003f3f 6d3c: ac 29 14                         ldy   $1429
+003f42 6d3f: c0 10                            cpy   #$10
+003f44 6d41: b0 e6                            bcs   L6D29
+003f46 6d43: 98                               tya
+003f47 6d44: f0 08                            beq   L6D4E
+003f49 6d46: 20 36 4c                         jsr   randomA
+003f4c 6d49: cd 67 0c                         cmp   L0C67
+003f4f 6d4c: b0 0c                            bcs   L6D5A
+003f51 6d4e: ad 63 0c     L6D4E               lda   L0C63
+003f54 6d51: 8d 2e 14                         sta   $142e
+003f57 6d54: ad 64 0c                         lda   L0C64
+003f5a 6d57: 8d 2f 14                         sta   $142f
+003f5d 6d5a: bd 70 1d     L6D5A               lda   $1d70,x
+003f60 6d5d: 18                               clc
+003f61 6d5e: 69 03                            adc   #$03
+003f63 6d60: 99 50 1e                         sta   $1e50,y
+003f66 6d63: bd 90 1d                         lda   $1d90,x
+003f69 6d66: 18                               clc
+003f6a 6d67: 69 04                            adc   #$04
+003f6c 6d69: 99 60 1e                         sta   $1e60,y
+003f6f 6d6c: ad 00 15                         lda   $1500
+003f72 6d6f: 4a                               lsr   A
+003f73 6d70: 69 40                            adc   #$40
+003f75 6d72: 85 02                            sta   _strobePtrOffs
+003f77 6d74: ad 01 15                         lda   $1501
+003f7a 6d77: 4a                               lsr   A
+003f7b 6d78: 69 50                            adc   #$50
+003f7d 6d7a: 85 03                            sta   $03
+003f7f 6d7c: a5 4e                            lda   MON_RNDL
+003f81 6d7e: 10 12                            bpl   L6D92
+003f83 6d80: a5 02                            lda   _strobePtrOffs
+003f85 6d82: 30 07                            bmi   L6D8B
+003f87 6d84: a9 80                            lda   #$80
+003f89 6d86: 38                               sec
+003f8a 6d87: e5 02                            sbc   _strobePtrOffs
+003f8c 6d89: b0 05                            bcs   L6D90
+003f8e 6d8b: 49 ff        L6D8B               eor   #$ff
+003f90 6d8d: 18                               clc
+003f91 6d8e: 69 80                            adc   #$80
+003f93 6d90: 85 02        L6D90               sta   _strobePtrOffs
+003f95 6d92: a5 4f        L6D92               lda   MON_RNDH
+003f97 6d94: 10 12                            bpl   L6DA8
+003f99 6d96: a5 03                            lda   $03
+003f9b 6d98: 30 07                            bmi   L6DA1
+003f9d 6d9a: a9 a0                            lda   #$a0
+003f9f 6d9c: 38                               sec
+003fa0 6d9d: e5 03                            sbc   $03
+003fa2 6d9f: b0 05                            bcs   L6DA6
+003fa4 6da1: 49 ff        L6DA1               eor   #$ff
+003fa6 6da3: 18                               clc
+003fa7 6da4: 69 60                            adc   #$60
+003fa9 6da6: 85 03        L6DA6               sta   $03
+003fab 6da8: b9 50 1e     L6DA8               lda   $1e50,y
+003fae 6dab: 85 00                            sta   _spriteEntryPtr
+003fb0 6dad: b9 60 1e                         lda   $1e60,y
+003fb3 6db0: 85 01                            sta   _spriteEntryPtr+1
+003fb5 6db2: 46 00        L6DB2               lsr   _spriteEntryPtr
+003fb7 6db4: 46 01                            lsr   _spriteEntryPtr+1
+003fb9 6db6: 46 02                            lsr   _strobePtrOffs
+003fbb 6db8: 46 03                            lsr   $03
+003fbd 6dba: a5 02                            lda   _strobePtrOffs
+003fbf 6dbc: e5 00                            sbc   _spriteEntryPtr
+003fc1 6dbe: aa                               tax
+003fc2 6dbf: b0 02                            bcs   L6DC3
+003fc4 6dc1: 49 ff                            eor   #$ff
+003fc6 6dc3: cd 45 0c     L6DC3               cmp   L0C45
+003fc9 6dc6: b0 ea                            bcs   L6DB2
+003fcb 6dc8: 86 06                            stx   _strobePtr
+003fcd 6dca: a5 03                            lda   $03
+003fcf 6dcc: e5 01                            sbc   _spriteEntryPtr+1
+003fd1 6dce: aa                               tax
+003fd2 6dcf: b0 02                            bcs   L6DD3
+003fd4 6dd1: 49 ff                            eor   #$ff
+003fd6 6dd3: cd 45 0c     L6DD3               cmp   L0C45
+003fd9 6dd6: b0 da                            bcs   L6DB2
+003fdb 6dd8: a5 06                            lda   _strobePtr
+003fdd 6dda: 99 70 1e                         sta   $1e70,y
+003fe0 6ddd: 8a                               txa
+003fe1 6dde: 99 80 1e                         sta   $1e80,y
+003fe4 6de1: a9 00                            lda   #$00
+003fe6 6de3: 99 90 1e                         sta   $1e90,y
+003fe9 6de6: ad 4c 0c                         lda   L0C4C
+003fec 6de9: 99 a0 1e                         sta   $1ea0,y
+003fef 6dec: ee 29 14                         inc   $1429
+003ff2 6def: 60                               rts

+003ff3 6df0: 8a           L6DF0               txa
+003ff4 6df1: 48                               pha
+003ff5 6df2: ce 27 14                         dec   $1427
+003ff8 6df5: bd e1 1c     L6DF5               lda   $1ce1,x
+003ffb 6df8: 9d e0 1c                         sta   $1ce0,x
+003ffe 6dfb: bd f1 1c                         lda   $1cf1,x
+004001 6dfe: 9d f0 1c                         sta   $1cf0,x
+004004 6e01: bd 01 1d                         lda   $1d01,x
+004007 6e04: 9d 00 1d                         sta   $1d00,x
+00400a 6e07: bd 11 1d                         lda   $1d11,x
+00400d 6e0a: 9d 10 1d                         sta   $1d10,x
+004010 6e0d: bd 21 1d                         lda   $1d21,x
+004013 6e10: 9d 20 1d                         sta   $1d20,x
+004016 6e13: bd 31 1d                         lda   $1d31,x
+004019 6e16: 9d 30 1d                         sta   $1d30,x
+00401c 6e19: bd 41 1d                         lda   $1d41,x
+00401f 6e1c: 9d 40 1d                         sta   $1d40,x
+004022 6e1f: bd 51 1d                         lda   $1d51,x
+004025 6e22: 9d 50 1d                         sta   $1d50,x
+004028 6e25: bd 61 1d                         lda   $1d61,x
+00402b 6e28: 9d 60 1d                         sta   $1d60,x
+00402e 6e2b: e8                               inx
+00402f 6e2c: ec 27 14                         cpx   $1427
+004032 6e2f: 90 c4                            bcc   L6DF5
+004034 6e31: 68                               pla
+004035 6e32: aa                               tax
+004036 6e33: 60                               rts

+004037 6e34: ae 27 14     L6E34               ldx   $1427
+00403a 6e37: a5 1c                            lda   $1c
+00403c 6e39: 38                               sec
+00403d 6e3a: e9 0d                            sbc   #$0d
+00403f 6e3c: b0 02                            bcs   L6E40
+004041 6e3e: a9 00                            lda   #$00
+004043 6e40: a8           L6E40               tay
+004044 6e41: a5 1c        L6E41               lda   $1c
+004046 6e43: ca           L6E43               dex
+004047 6e44: 10 02                            bpl   L6E48
+004049 6e46: 18                               clc
+00404a 6e47: 60                               rts

+00404b 6e48: dd e0 1c     L6E48               cmp   $1ce0,x
+00404e 6e4b: 90 f6                            bcc   L6E43
+004050 6e4d: 98                               tya
+004051 6e4e: dd e0 1c                         cmp   $1ce0,x
+004054 6e51: b0 ee                            bcs   L6E41
+004056 6e53: a5 1d                            lda   $1d
+004058 6e55: dd f0 1c                         cmp   $1cf0,x
+00405b 6e58: 90 e7                            bcc   L6E41
+00405d 6e5a: e9 0d                            sbc   #$0d
+00405f 6e5c: 90 05                            bcc   L6E63
+004061 6e5e: dd f0 1c                         cmp   $1cf0,x
+004064 6e61: b0 de                            bcs   L6E41
+004066 6e63: a5 e8        L6E63               lda   $e8
+004068 6e65: f0 02                            beq   L6E69
+00406a 6e67: 38                               sec
+00406b 6e68: 60                               rts

+00406c 6e69: 8a           L6E69               txa
+00406d 6e6a: 48                               pha
+00406e 6e6b: a8                               tay
+00406f 6e6c: be f0 1c                         ldx   $1cf0,y
+004072 6e6f: b9 e0 1c                         lda   $1ce0,y
+004075 6e72: a0 0d                            ldy   #$0d
+004077 6e74: 20 21 4d                         jsr   eraseHulk
+00407a 6e77: 68                               pla
+00407b 6e78: 48                               pha
+00407c 6e79: a8                               tay
+00407d 6e7a: b9 e0 1c                         lda   $1ce0,y
+004080 6e7d: 18                               clc
+004081 6e7e: 69 03                            adc   #$03
+004083 6e80: aa                               tax
+004084 6e81: b9 f0 1c                         lda   $1cf0,y
+004087 6e84: a8                               tay
+004088 6e85: a9 06                            lda   #$06
+00408a 6e87: 20 27 5a                         jsr   L5A27
+00408d 6e8a: 68                               pla
+00408e 6e8b: aa                               tax
+00408f 6e8c: 20 f0 6d                         jsr   L6DF0
+004092 6e8f: a9 03                            lda   #$03
+004094 6e91: a2 e8                            ldx   #$e8
+004096 6e93: 20 d0 4d                         jsr   detectCollision
+004099 6e96: 38                               sec
+00409a 6e97: 60                               rts

+00409b 6e98: ae 28 14     L6E98               ldx   $1428
+00409e 6e9b: a5 1c                            lda   $1c
+0040a0 6e9d: 38                               sec
+0040a1 6e9e: e9 0d                            sbc   #$0d
+0040a3 6ea0: b0 02                            bcs   L6EA4
+0040a5 6ea2: a9 00                            lda   #$00
+0040a7 6ea4: a8           L6EA4               tay
+0040a8 6ea5: a5 1c        L6EA5               lda   $1c
+0040aa 6ea7: ca           L6EA7               dex
+0040ab 6ea8: 10 02                            bpl   L6EAC
+0040ad 6eaa: 18                               clc
+0040ae 6eab: 60                               rts

+0040af 6eac: dd 70 1d     L6EAC               cmp   $1d70,x
+0040b2 6eaf: 90 f6                            bcc   L6EA7
+0040b4 6eb1: 98                               tya
+0040b5 6eb2: dd 70 1d                         cmp   $1d70,x
+0040b8 6eb5: f0 02                            beq   L6EB9
+0040ba 6eb7: b0 ec                            bcs   L6EA5
+0040bc 6eb9: a5 1d        L6EB9               lda   $1d
+0040be 6ebb: dd 90 1d                         cmp   $1d90,x
+0040c1 6ebe: 90 e5                            bcc   L6EA5
+0040c3 6ec0: e9 0f                            sbc   #$0f
+0040c5 6ec2: 90 05                            bcc   L6EC9
+0040c7 6ec4: dd 90 1d                         cmp   $1d90,x
+0040ca 6ec7: b0 dc                            bcs   L6EA5
+0040cc 6ec9: a5 e8        L6EC9               lda   $e8
+0040ce 6ecb: f0 02                            beq   L6ECF
+0040d0 6ecd: 38                               sec
+0040d1 6ece: 60                               rts

+0040d2 6ecf: 8a           L6ECF               txa
+0040d3 6ed0: 48                               pha
+0040d4 6ed1: a8                               tay
+0040d5 6ed2: be 90 1d                         ldx   $1d90,y
+0040d8 6ed5: b9 70 1d                         lda   $1d70,y
+0040db 6ed8: a0 0f                            ldy   #$0f
+0040dd 6eda: 20 21 4d                         jsr   eraseHulk
+0040e0 6edd: 68                               pla
+0040e1 6ede: aa                               tax
+0040e2 6edf: 48                               pha
+0040e3 6ee0: bd 90 1d                         lda   $1d90,x
+0040e6 6ee3: 18                               clc
+0040e7 6ee4: 69 07                            adc   #$07
+0040e9 6ee6: a8                               tay
+0040ea 6ee7: bd 70 1d                         lda   $1d70,x
+0040ed 6eea: 18                               clc
+0040ee 6eeb: 69 03                            adc   #$03
+0040f0 6eed: aa                               tax
+0040f1 6eee: a9 aa                            lda   #$aa
+0040f3 6ef0: 20 74 4f                         jsr   L4F74
+0040f6 6ef3: 68                               pla
+0040f7 6ef4: aa                               tax
+0040f8 6ef5: 20 6f 6f                         jsr   L6F6F
+0040fb 6ef8: a9 00                            lda   #$00
+0040fd 6efa: a2 c8                            ldx   #$c8
+0040ff 6efc: 20 d0 4d                         jsr   detectCollision
+004102 6eff: ad 46 0c                         lda   L0C46
+004105 6f02: 8d 06 14                         sta   Level-1
+004108 6f05: ad 47 0c                         lda   L0C47
+00410b 6f08: 8d 22 14                         sta   $1422
+00410e 6f0b: ad 48 0c                         lda   L0C48
+004111 6f0e: 8d 23 14                         sta   $1423
+004114 6f11: 38                               sec
+004115 6f12: 60                               rts

+004116 6f13: ae 29 14     L6F13               ldx   $1429
+004119 6f16: a5 1c                            lda   $1c
+00411b 6f18: 38                               sec
+00411c 6f19: e9 07                            sbc   #$07
+00411e 6f1b: b0 02                            bcs   L6F1F
+004120 6f1d: a9 00                            lda   #$00
+004122 6f1f: a8           L6F1F               tay
+004123 6f20: a5 1c        L6F20               lda   $1c
+004125 6f22: ca           L6F22               dex
+004126 6f23: 10 02                            bpl   L6F27
+004128 6f25: 18                               clc
+004129 6f26: 60                               rts

+00412a 6f27: dd 50 1e     L6F27               cmp   $1e50,x
+00412d 6f2a: 90 f6                            bcc   L6F22
+00412f 6f2c: 98                               tya
+004130 6f2d: dd 50 1e                         cmp   $1e50,x
+004133 6f30: b0 ee                            bcs   L6F20
+004135 6f32: a5 1d                            lda   $1d
+004137 6f34: dd 60 1e                         cmp   $1e60,x
+00413a 6f37: 90 e7                            bcc   L6F20
+00413c 6f39: e9 07                            sbc   #$07
+00413e 6f3b: 90 05                            bcc   L6F42
+004140 6f3d: dd 60 1e                         cmp   $1e60,x
+004143 6f40: b0 de                            bcs   L6F20
+004145 6f42: a5 e8        L6F42               lda   $e8
+004147 6f44: f0 02                            beq   L6F48
+004149 6f46: 38                               sec
+00414a 6f47: 60                               rts

+00414b 6f48: 8a           L6F48               txa
+00414c 6f49: 48                               pha
+00414d 6f4a: a8                               tay
+00414e 6f4b: be 60 1e                         ldx   $1e60,y
+004151 6f4e: b9 50 1e                         lda   $1e50,y
+004154 6f51: a0 07                            ldy   #$07
+004156 6f53: 20 d0 4c                         jsr   eraseFamily
+004159 6f56: 68                               pla
+00415a 6f57: aa                               tax
+00415b 6f58: 20 f2 6c                         jsr   L6CF2
+00415e 6f5b: ad 49 0c                         lda   L0C49
+004161 6f5e: 8d 13 14                         sta   $1413
+004164 6f61: a9 01                            lda   #$01
+004166 6f63: 8d 12 14                         sta   $1412
+004169 6f66: a9 00                            lda   #$00
+00416b 6f68: a2 19                            ldx   #$19
+00416d 6f6a: 20 d0 4d                         jsr   detectCollision
+004170 6f6d: 38                               sec
+004171 6f6e: 60                               rts

+004172 6f6f: 8a           L6F6F               txa
+004173 6f70: 48                               pha
+004174 6f71: ce 28 14                         dec   $1428
+004177 6f74: bd 71 1d     L6F74               lda   $1d71,x
+00417a 6f77: 9d 70 1d                         sta   $1d70,x
+00417d 6f7a: bd 91 1d                         lda   $1d91,x
+004180 6f7d: 9d 90 1d                         sta   $1d90,x
+004183 6f80: bd b1 1d                         lda   $1db1,x
+004186 6f83: 9d b0 1d                         sta   $1db0,x
+004189 6f86: bd d1 1d                         lda   $1dd1,x
+00418c 6f89: 9d d0 1d                         sta   $1dd0,x
+00418f 6f8c: bd f1 1d                         lda   $1df1,x
+004192 6f8f: 9d f0 1d                         sta   $1df0,x
+004195 6f92: bd 11 1e                         lda   $1e11,x
+004198 6f95: 9d 10 1e                         sta   $1e10,x
+00419b 6f98: bd 31 1e                         lda   $1e31,x
+00419e 6f9b: 9d 30 1e                         sta   $1e30,x
+0041a1 6f9e: e8                               inx
+0041a2 6f9f: ec 28 14                         cpx   $1428
+0041a5 6fa2: 90 d0                            bcc   L6F74
+0041a7 6fa4: 68                               pla
+0041a8 6fa5: aa                               tax
+0041a9 6fa6: 60                               rts

+0041aa 6fa7: ff ff ff ff+                     .fill 89,$ff

                           ********************************************************************************
                           * jump table                                                                   *
                           * called with a jsr, thus jmp target needs to rts                              *
                           ********************************************************************************
+004203 7000: 4c 15 70     L7000               jmp   L7015

+004206 7003: 4c ca 70     L7003               jmp   L70CA

+004209 7006: 4c f1 76     L7006               jmp   L76F1

+00420c 7009: 4c bd 74     L7009               jmp   L74BD

+00420f 700c: 4c a3 73     L700C               jmp   L73A3

+004212 700f: 4c 8a 78     L700F               jmp   L788A

+004215 7012: 4c 85 75     L7012               jmp   L7585

+004218 7015: ad 29 0c     L7015               lda   L0C29                                   ;called from jump table only
+00421b 7018: ac 18 14                         ldy   $1418
+00421e 701b: d0 02                            bne   L701F
+004220 701d: a9 00                            lda   #$00
+004222 701f: 8d 1c 14     L701F               sta   $141c
+004225 7022: cd 21 14                         cmp   $1421
+004228 7025: 90 03                            bcc   L702A
+00422a 7027: 8d 21 14                         sta   $1421
+00422d 702a: 88           L702A               dey
+00422e 702b: 10 12                            bpl   L703F
+004230 702d: a9 00                            lda   #$00
+004232 702f: 8d 1b 14                         sta   $141b
+004235 7032: 8d 1d 14                         sta   $141d
+004238 7035: 8d 1e 14                         sta   $141e
+00423b 7038: 8d 19 14                         sta   $1419
+00423e 703b: 8d 26 14                         sta   $1426
+004241 703e: 60                               rts

+004242 703f: 20 36 4c     L703F               jsr   randomA
+004245 7042: 08                               php
+004246 7043: 29 01                            and   #$01
+004248 7045: 99 40 1b                         sta   $1b40,y
+00424b 7048: 28                               plp
+00424c 7049: 30 25                            bmi   L7070
+00424e 704b: a9 db                            lda   #$db
+004250 704d: 20 4b 4c                         jsr   multiplyRndX
+004253 7050: 18                               clc
+004254 7051: 69 0c                            adc   #$0c
+004256 7053: 29 fe                            and   #$fe
+004258 7055: 99 20 1b                         sta   $1b20,y
+00425b 7058: 20 36 4c                         jsr   randomA
+00425e 705b: 85 00                            sta   _spriteEntryPtr
+004260 705d: a9 20                            lda   #$20
+004262 705f: 20 4b 4c                         jsr   multiplyRndX
+004265 7062: 18                               clc
+004266 7063: 69 0c                            adc   #$0c
+004268 7065: a6 00                            ldx   _spriteEntryPtr
+00426a 7067: 10 02                            bpl   L706B
+00426c 7069: 69 7c                            adc   #$7c
+00426e 706b: 99 30 1b     L706B               sta   $1b30,y
+004271 706e: d0 23                            bne   L7093
+004273 7070: a9 9c        L7070               lda   #$9c
+004275 7072: 20 4b 4c                         jsr   multiplyRndX
+004278 7075: 18                               clc
+004279 7076: 69 0c                            adc   #$0c
+00427b 7078: 99 30 1b                         sta   $1b30,y
+00427e 707b: 20 36 4c                         jsr   randomA
+004281 707e: 85 00                            sta   _spriteEntryPtr
+004283 7080: a9 37                            lda   #$37
+004285 7082: 20 4b 4c                         jsr   multiplyRndX
+004288 7085: 18                               clc
+004289 7086: 69 0c                            adc   #$0c
+00428b 7088: a6 00                            ldx   _spriteEntryPtr
+00428d 708a: 10 02                            bpl   L708E
+00428f 708c: 69 a4                            adc   #$a4
+004291 708e: 29 fe        L708E               and   #$fe
+004293 7090: 99 20 1b                         sta   $1b20,y
+004296 7093: ad 0a 14     L7093               lda   $140a
+004299 7096: d0 04                            bne   L709C
+00429b 7098: a9 ff                            lda   #$ff
+00429d 709a: 30 03                            bmi   L709F

+00429f 709c: 20 4b 4c     L709C               jsr   multiplyRndX
+0042a2 709f: 99 50 1b     L709F               sta   $1b50,y
+0042a5 70a2: 98                               tya
+0042a6 70a3: 29 03                            and   #$03
+0042a8 70a5: 99 60 1b                         sta   $1b60,y
+0042ab 70a8: ad 25 0c                         lda   L0C25
+0042ae 70ab: 20 4b 4c                         jsr   multiplyRndX
+0042b1 70ae: 99 70 1b                         sta   $1b70,y
+0042b4 70b1: ad 26 0c                         lda   L0C26
+0042b7 70b4: 20 4b 4c                         jsr   multiplyRndX
+0042ba 70b7: 99 80 1b                         sta   $1b80,y
+0042bd 70ba: a9 ff                            lda   #$ff
+0042bf 70bc: 99 90 1b                         sta   $1b90,y
+0042c2 70bf: 20 36 4c                         jsr   randomA
+0042c5 70c2: 29 01                            and   #$01
+0042c7 70c4: 99 a0 1b                         sta   $1ba0,y
+0042ca 70c7: 4c 2a 70                         jmp   L702A

+0042cd 70ca: ae 18 14     L70CA               ldx   $1418                                   ;called from jump table only
+0042d0 70cd: ad 1c 14                         lda   $141c
+0042d3 70d0: f0 03                            beq   L70D5
+0042d5 70d2: 4c 11 72                         jmp   L7211

+0042d8 70d5: ca           L70D5               dex
+0042d9 70d6: 10 01                            bpl   L70D9
+0042db 70d8: 60                               rts

+0042dc 70d9: bd 90 1b     L70D9               lda   $1b90,x
+0042df 70dc: 30 05                            bmi   L70E3
+0042e1 70de: 86 00                            stx   _spriteEntryPtr
+0042e3 70e0: 4c 78 72                         jmp   L7278

+0042e6 70e3: de 60 1b     L70E3               dec   $1b60,x
+0042e9 70e6: 10 ed                            bpl   L70D5
+0042eb 70e8: ad 24 0c                         lda   L0C24
+0042ee 70eb: 9d 60 1b                         sta   $1b60,x
+0042f1 70ee: 86 00                            stx   _spriteEntryPtr
+0042f3 70f0: de 70 1b                         dec   $1b70,x
+0042f6 70f3: 10 0d                            bpl   L7102
+0042f8 70f5: ad 25 0c                         lda   L0C25
+0042fb 70f8: 9d 70 1b                         sta   $1b70,x
+0042fe 70fb: 20 d9 72                         jsr   L72D9
+004301 70fe: 98                               tya
+004302 70ff: 9d 50 1b                         sta   $1b50,x
+004305 7102: a4 00        L7102               ldy   _spriteEntryPtr
+004307 7104: be 30 1b                         ldx   $1b30,y
+00430a 7107: b9 20 1b                         lda   $1b20,y
+00430d 710a: a0 0d                            ldy   #$0d
+00430f 710c: 20 21 4d                         jsr   eraseHulk
+004312 710f: a4 00                            ldy   _spriteEntryPtr
+004314 7111: b9 40 1b                         lda   $1b40,y
+004317 7114: 49 01                            eor   #$01
+004319 7116: 99 40 1b                         sta   $1b40,y
+00431c 7119: be 50 1b                         ldx   $1b50,y
+00431f 711c: 30 13                            bmi   L7131
+004321 711e: ec 0a 14                         cpx   $140a
+004324 7121: 90 1a                            bcc   L713D
+004326 7123: a6 00                            ldx   _spriteEntryPtr
+004328 7125: 20 d9 72                         jsr   L72D9
+00432b 7128: 98                               tya
+00432c 7129: 9d 50 1b                         sta   $1b50,x
+00432f 712c: a4 00                            ldy   _spriteEntryPtr
+004331 712e: aa                               tax
+004332 712f: 10 0c                            bpl   L713D
+004334 7131: ad 00 15     L7131               lda   $1500
+004337 7134: 85 06                            sta   _strobePtr
+004339 7136: ad 01 15                         lda   $1501
+00433c 7139: 85 07                            sta   _strobePtr+1
+00433e 713b: d0 0a                            bne   L7147
+004340 713d: bd 50 19     L713D               lda   $1950,x
+004343 7140: 85 06                            sta   _strobePtr
+004345 7142: bd 60 19                         lda   $1960,x
+004348 7145: 85 07                            sta   _strobePtr+1
+00434a 7147: b9 30 1b     L7147               lda   $1b30,y
+00434d 714a: 38                               sec
+00434e 714b: e5 07                            sbc   _strobePtr+1
+004350 714d: b0 04                            bcs   L7153
+004352 714f: 49 ff                            eor   #$ff
+004354 7151: 69 01                            adc   #$01
+004356 7153: c9 02        L7153               cmp   #$02
+004358 7155: b0 04                            bcs   L715B
+00435a 7157: a5 07                            lda   _strobePtr+1
+00435c 7159: d0 0d                            bne   L7168
+00435e 715b: b9 30 1b     L715B               lda   $1b30,y
+004361 715e: c5 07                            cmp   _strobePtr+1
+004363 7160: b0 04                            bcs   L7166
+004365 7162: 69 02                            adc   #$02
+004367 7164: 90 02                            bcc   L7168
+004369 7166: e9 02        L7166               sbc   #$02
+00436b 7168: 99 30 1b     L7168               sta   $1b30,y
+00436e 716b: a9 00                            lda   #$00
+004370 716d: 85 01                            sta   _spriteEntryPtr+1
+004372 716f: b9 20 1b                         lda   $1b20,y
+004375 7172: c5 06                            cmp   _strobePtr
+004377 7174: b0 18                            bcs   L718E
+004379 7176: 69 02                            adc   #$02
+00437b 7178: 99 20 1b                         sta   $1b20,y
+00437e 717b: 69 0f                            adc   #$0f
+004380 717d: c5 06                            cmp   _strobePtr
+004382 717f: 90 1a                            bcc   L719B
+004384 7181: b9 30 1b     L7181               lda   $1b30,y
+004387 7184: c5 07                            cmp   _strobePtr+1
+004389 7186: d0 13                            bne   L719B
+00438b 7188: 8a                               txa
+00438c 7189: 30 10                            bmi   L719B
+00438e 718b: 4c 14 73                         jmp   L7314

+004391 718e: e6 01        L718E               inc   _spriteEntryPtr+1
+004393 7190: e9 02                            sbc   #$02
+004395 7192: 99 20 1b                         sta   $1b20,y
+004398 7195: e9 09                            sbc   #$09
+00439a 7197: c5 06                            cmp   _strobePtr
+00439c 7199: 90 e6                            bcc   L7181
+00439e 719b: a5 01        L719B               lda   _spriteEntryPtr+1
+0043a0 719d: 99 a0 1b                         sta   $1ba0,y
+0043a3 71a0: 0a                               asl   A
+0043a4 71a1: 19 40 1b                         ora   $1b40,y
+0043a7 71a4: aa                               tax
+0043a8 71a5: bd e0 08                         lda   L08E0,x
+0043ab 71a8: 85 06                            sta   _strobePtr
+0043ad 71aa: bd e8 08                         lda   L08E8,x
+0043b0 71ad: 85 07                            sta   _strobePtr+1
+0043b2 71af: be 20 1b                         ldx   $1b20,y
+0043b5 71b2: b9 30 1b                         lda   $1b30,y
+0043b8 71b5: a8                               tay
+0043b9 71b6: 20 f6 4c                         jsr   drawHulk
+0043bc 71b9: a6 00                            ldx   _spriteEntryPtr
+0043be 71bb: de 80 1b                         dec   $1b80,x
+0043c1 71be: 10 4e                            bpl   L720E
+0043c3 71c0: ad 1d 14                         lda   $141d
+0043c6 71c3: 0a                               asl   A
+0043c7 71c4: a8                               tay
+0043c8 71c5: c0 10                            cpy   #$10
+0043ca 71c7: b0 45                            bcs   L720E
+0043cc 71c9: ee 1d 14                         inc   $141d
+0043cf 71cc: bd 20 1b                         lda   $1b20,x
+0043d2 71cf: 18                               clc
+0043d3 71d0: 69 05                            adc   #$05
+0043d5 71d2: 99 70 1c                         sta   $1c70,y
+0043d8 71d5: 99 71 1c                         sta   $1c71,y
+0043db 71d8: bd 30 1b                         lda   $1b30,x
+0043de 71db: 99 80 1c                         sta   $1c80,y
+0043e1 71de: 99 81 1c                         sta   $1c81,y
+0043e4 71e1: 20 8f 76                         jsr   L768F
+0043e7 71e4: a5 02                            lda   _strobePtrOffs
+0043e9 71e6: 99 90 1c                         sta   $1c90,y
+0043ec 71e9: 99 91 1c                         sta   $1c91,y
+0043ef 71ec: a5 03                            lda   $03
+0043f1 71ee: 99 a0 1c                         sta   $1ca0,y
+0043f4 71f1: 99 a1 1c                         sta   $1ca1,y
+0043f7 71f4: ad 2e 0c                         lda   L0C2E
+0043fa 71f7: 99 b0 1c                         sta   $1cb0,y
+0043fd 71fa: 99 b1 1c                         sta   $1cb1,y
+004400 71fd: ad 2e 0c                         lda   L0C2E
+004403 7200: 99 c1 1c                         sta   $1cc1,y
+004406 7203: ad 26 0c                         lda   L0C26
+004409 7206: 20 4b 4c                         jsr   multiplyRndX
+00440c 7209: a6 00                            ldx   _spriteEntryPtr
+00440e 720b: 9d 80 1b                         sta   $1b80,x
+004411 720e: 4c d5 70     L720E               jmp   L70D5

+004414 7211: 0a           L7211               asl   A
+004415 7212: 0a                               asl   A
+004416 7213: 85 0a                            sta   _colorBit
+004418 7215: a0 0d                            ldy   #$0d
+00441a 7217: 20 a1 50                         jsr   roboNoise01
+00441d 721a: ae 18 14                         ldx   $1418
+004420 721d: ca           L721D               dex
+004421 721e: 10 04                            bpl   L7224
+004423 7220: ce 1c 14                         dec   $141c
+004426 7223: 60                               rts

+004427 7224: 86 00        L7224               stx   _spriteEntryPtr
+004429 7226: bd a0 1b                         lda   $1ba0,x
+00442c 7229: 0a                               asl   A
+00442d 722a: a8                               tay
+00442e 722b: b9 e0 08                         lda   L08E0,y
+004431 722e: 85 06                            sta   _strobePtr
+004433 7230: b9 e8 08                         lda   L08E8,y
+004436 7233: 85 07                            sta   _strobePtr+1
+004438 7235: bc 30 1b                         ldy   $1b30,x
+00443b 7238: bd 20 1b                         lda   $1b20,x
+00443e 723b: aa                               tax
+00443f 723c: 20 7c 4c                         jsr   fetchSprite
+004442 723f: a9 00                            lda   #$00
+004444 7241: 85 20                            sta   MON_WNDLEFT
+004446 7243: b1 fc        L7243               lda   (PixelLineBaseL),y
+004448 7245: 85 06                            sta   _strobePtr
+00444a 7247: b1 fe                            lda   (PixelLineBaseH),y
+00444c 7249: 85 07                            sta   _strobePtr+1
+00444e 724b: 84 05                            sty   _ix
+004450 724d: a4 04                            ldy   _length
+004452 724f: a1 08                            lda   (_destPtr,x)
+004454 7251: 21 20                            and   (MON_WNDLEFT,x)
+004456 7253: 91 06                            sta   (_strobePtr),y
+004458 7255: e6 08                            inc   _destPtr
+00445a 7257: c8                               iny
+00445b 7258: a1 08                            lda   (_destPtr,x)
+00445d 725a: 21 20                            and   (MON_WNDLEFT,x)
+00445f 725c: 91 06                            sta   (_strobePtr),y
+004461 725e: e6 08                            inc   _destPtr
+004463 7260: c8                               iny
+004464 7261: a1 08                            lda   (_destPtr,x)
+004466 7263: 21 20                            and   (MON_WNDLEFT,x)
+004468 7265: 91 06                            sta   (_strobePtr),y
+00446a 7267: e6 08                            inc   _destPtr
+00446c 7269: e6 20                            inc   MON_WNDLEFT
+00446e 726b: a4 05                            ldy   _ix
+004470 726d: 88                               dey
+004471 726e: 10 d3                            bpl   L7243
+004473 7270: 20 6e 4c                         jsr   doSpeaker
+004476 7273: a6 00                            ldx   _spriteEntryPtr
+004478 7275: 4c 1d 72                         jmp   L721D

+00447b 7278: ac 3d 0c     L7278               ldy   L0C3D
+00447e 727b: bd 40 1b                         lda   $1b40,x
+004481 727e: 49 01                            eor   #$01
+004483 7280: 9d 40 1b                         sta   $1b40,x
+004486 7283: f0 03                            beq   L7288
+004488 7285: ac 3e 0c                         ldy   L0C3E
+00448b 7288: 84 02        L7288               sty   _strobePtrOffs
+00448d 728a: bd a0 1b                         lda   $1ba0,x
+004490 728d: 0a                               asl   A
+004491 728e: a8                               tay
+004492 728f: b9 e0 08                         lda   L08E0,y
+004495 7292: 85 06                            sta   _strobePtr
+004497 7294: b9 e8 08                         lda   L08E8,y
+00449a 7297: 85 07                            sta   _strobePtr+1
+00449c 7299: bc 30 1b                         ldy   $1b30,x
+00449f 729c: bd 20 1b                         lda   $1b20,x
+0044a2 729f: aa                               tax
+0044a3 72a0: 20 7c 4c                         jsr   fetchSprite
+0044a6 72a3: b1 fc        L72A3               lda   (PixelLineBaseL),y
+0044a8 72a5: 85 06                            sta   _strobePtr
+0044aa 72a7: b1 fe                            lda   (PixelLineBaseH),y
+0044ac 72a9: 85 07                            sta   _strobePtr+1
+0044ae 72ab: 84 05                            sty   _ix
+0044b0 72ad: a4 04                            ldy   _length
+0044b2 72af: a1 08                            lda   (_destPtr,x)
+0044b4 72b1: 45 02                            eor   _strobePtrOffs
+0044b6 72b3: 91 06                            sta   (_strobePtr),y
+0044b8 72b5: e6 08                            inc   _destPtr
+0044ba 72b7: c8                               iny
+0044bb 72b8: a1 08                            lda   (_destPtr,x)
+0044bd 72ba: 45 02                            eor   _strobePtrOffs
+0044bf 72bc: 91 06                            sta   (_strobePtr),y
+0044c1 72be: e6 08                            inc   _destPtr
+0044c3 72c0: c8                               iny
+0044c4 72c1: a1 08                            lda   (_destPtr,x)
+0044c6 72c3: 45 02                            eor   _strobePtrOffs
+0044c8 72c5: 91 06                            sta   (_strobePtr),y
+0044ca 72c7: e6 08                            inc   _destPtr
+0044cc 72c9: a4 05                            ldy   _ix
+0044ce 72cb: 88                               dey
+0044cf 72cc: 10 d5                            bpl   L72A3
+0044d1 72ce: a6 00                            ldx   _spriteEntryPtr
+0044d3 72d0: de 90 1b                         dec   $1b90,x
+0044d6 72d3: 20 6e 4c                         jsr   doSpeaker
+0044d9 72d6: 4c d5 70                         jmp   L70D5

+0044dc 72d9: ac 0a 14     L72D9               ldy   $140a
+0044df 72dc: d0 02                            bne   L72E0
+0044e1 72de: 88                               dey
+0044e2 72df: 60                               rts

+0044e3 72e0: a9 ff        L72E0               lda   #$ff
+0044e5 72e2: 85 06                            sta   _strobePtr
+0044e7 72e4: a9 00                            lda   #$00
+0044e9 72e6: 85 07                            sta   _strobePtr+1
+0044eb 72e8: 88           L72E8               dey
+0044ec 72e9: 30 26                            bmi   L7311
+0044ee 72eb: b9 50 19                         lda   $1950,y
+0044f1 72ee: fd 20 1b                         sbc   $1b20,x
+0044f4 72f1: b0 02                            bcs   L72F5
+0044f6 72f3: 49 ff                            eor   #$ff
+0044f8 72f5: 85 08        L72F5               sta   _destPtr
+0044fa 72f7: b9 60 19                         lda   $1960,y
+0044fd 72fa: fd 30 1b                         sbc   $1b30,x
+004500 72fd: b0 02                            bcs   L7301
+004502 72ff: 49 ff                            eor   #$ff
+004504 7301: 65 08        L7301               adc   _destPtr
+004506 7303: 90 02                            bcc   L7307
+004508 7305: a9 ff                            lda   #$ff
+00450a 7307: c5 06        L7307               cmp   _strobePtr
+00450c 7309: b0 dd                            bcs   L72E8
+00450e 730b: 85 06                            sta   _strobePtr
+004510 730d: 84 07                            sty   _strobePtr+1
+004512 730f: 90 d7                            bcc   L72E8

+004514 7311: a4 07        L7311               ldy   _strobePtr+1
+004516 7313: 60                               rts

+004517 7314: bd 90 19     L7314               lda   $1990,x
+00451a 7317: 48                               pha
+00451b 7318: 8a                               txa
+00451c 7319: a8                               tay
+00451d 731a: be 60 19                         ldx   $1960,y
+004520 731d: b9 50 19                         lda   $1950,y
+004523 7320: a0 0a                            ldy   #$0a
+004525 7322: 20 d0 4c                         jsr   eraseFamily
+004528 7325: a4 00                            ldy   _spriteEntryPtr
+00452a 7327: be 50 1b                         ldx   $1b50,y
+00452d 732a: 20 21 5a                         jsr   L5A21
+004530 732d: a4 00                            ldy   _spriteEntryPtr
+004532 732f: ad 1b 14                         lda   $141b
+004535 7332: 0a                               asl   A
+004536 7333: 85 01                            sta   _spriteEntryPtr+1
+004538 7335: b9 20 1b     L7335               lda   $1b20,y
+00453b 7338: be a0 1b                         ldx   $1ba0,y
+00453e 733b: d0 11                            bne   L734E
+004540 733d: 18                               clc
+004541 733e: 69 12                            adc   #$12
+004543 7340: b0 04                            bcs   L7346
+004545 7342: c9 f3                            cmp   #$f3
+004547 7344: 90 11                            bcc   L7357
+004549 7346: 8a           L7346               txa
+00454a 7347: 49 01                            eor   #$01
+00454c 7349: 99 a0 1b                         sta   $1ba0,y
+00454f 734c: 10 e7                            bpl   L7335
+004551 734e: 38           L734E               sec
+004552 734f: e9 0c                            sbc   #$0c
+004554 7351: 90 f3                            bcc   L7346
+004556 7353: c9 06                            cmp   #$06
+004558 7355: 90 ef                            bcc   L7346
+00455a 7357: a6 01        L7357               ldx   _spriteEntryPtr+1
+00455c 7359: 9d b0 1b                         sta   $1bb0,x
+00455f 735c: 9d b1 1b                         sta   $1bb1,x
+004562 735f: b9 30 1b                         lda   $1b30,y
+004565 7362: 9d d0 1b                         sta   $1bd0,x
+004568 7365: 9d d1 1b                         sta   $1bd1,x
+00456b 7368: b9 a0 1b                         lda   $1ba0,y
+00456e 736b: 9d f0 1b                         sta   $1bf0,x
+004571 736e: 9d f1 1b                         sta   $1bf1,x
+004574 7371: 9d 30 1c                         sta   $1c30,x
+004577 7374: a9 70                            lda   #$70
+004579 7376: 9d 10 1c                         sta   $1c10,x
+00457c 7379: 9d 11 1c                         sta   $1c11,x
+00457f 737c: 68                               pla
+004580 737d: 9d 50 1c                         sta   $1c50,x
+004583 7380: ad 2a 0c                         lda   L0C2A
+004586 7383: 38                               sec
+004587 7384: e9 01                            sbc   #$01
+004589 7386: 9d 31 1c                         sta   $1c31,x
+00458c 7389: ad 28 0c                         lda   L0C28
+00458f 738c: 8d 19 14                         sta   $1419
+004592 738f: 99 90 1b                         sta   $1b90,y
+004595 7392: 9d 51 1c                         sta   $1c51,x
+004598 7395: ad 23 0c                         lda   L0C23
+00459b 7398: 8d 1a 14                         sta   $141a
+00459e 739b: ee 1b 14                         inc   $141b
+0045a1 739e: a6 00                            ldx   _spriteEntryPtr
+0045a3 73a0: 4c d5 70                         jmp   L70D5

+0045a6 73a3: ae 18 14     L73A3               ldx   $1418                                   ;called from jump table only
+0045a9 73a6: a5 1c                            lda   $1c
+0045ab 73a8: 38                               sec
+0045ac 73a9: e9 0d                            sbc   #$0d
+0045ae 73ab: b0 02                            bcs   L73AF
+0045b0 73ad: a9 00                            lda   #$00
+0045b2 73af: a8           L73AF               tay
+0045b3 73b0: a5 1c        L73B0               lda   $1c
+0045b5 73b2: ca           L73B2               dex
+0045b6 73b3: 10 02                            bpl   L73B7
+0045b8 73b5: 18                               clc
+0045b9 73b6: 60                               rts

+0045ba 73b7: dd 20 1b     L73B7               cmp   $1b20,x
+0045bd 73ba: 90 f6                            bcc   L73B2
+0045bf 73bc: 98                               tya
+0045c0 73bd: dd 20 1b                         cmp   $1b20,x
+0045c3 73c0: b0 ee                            bcs   L73B0
+0045c5 73c2: a5 1d                            lda   $1d
+0045c7 73c4: dd 30 1b                         cmp   $1b30,x
+0045ca 73c7: 90 e7                            bcc   L73B0
+0045cc 73c9: e9 0d                            sbc   #$0d
+0045ce 73cb: 90 05                            bcc   L73D2
+0045d0 73cd: dd 30 1b                         cmp   $1b30,x
+0045d3 73d0: b0 de                            bcs   L73B0
+0045d5 73d2: a5 e8        L73D2               lda   $e8
+0045d7 73d4: f0 02                            beq   L73D8
+0045d9 73d6: 38                               sec
+0045da 73d7: 60                               rts

+0045db 73d8: 86 00        L73D8               stx   _spriteEntryPtr
+0045dd 73da: a4 00                            ldy   _spriteEntryPtr
+0045df 73dc: be 30 1b                         ldx   $1b30,y
+0045e2 73df: b9 20 1b                         lda   $1b20,y
+0045e5 73e2: a0 0d                            ldy   #$0d
+0045e7 73e4: 20 21 4d                         jsr   eraseHulk
+0045ea 73e7: a6 00                            ldx   _spriteEntryPtr
+0045ec 73e9: bd 30 1b                         lda   $1b30,x
+0045ef 73ec: 18                               clc
+0045f0 73ed: 69 06                            adc   #$06
+0045f2 73ef: a8                               tay
+0045f3 73f0: bd 20 1b                         lda   $1b20,x
+0045f6 73f3: 69 03                            adc   #$03
+0045f8 73f5: aa                               tax
+0045f9 73f6: a9 d5                            lda   #$d5
+0045fb 73f8: 20 74 4f                         jsr   L4F74
+0045fe 73fb: a6 00                            ldx   _spriteEntryPtr
+004600 73fd: bd 90 1b                         lda   $1b90,x
+004603 7400: 30 3f                            bmi   L7441
+004605 7402: ad 1b 14                         lda   $141b
+004608 7405: 0a                               asl   A
+004609 7406: a8                               tay
+00460a 7407: 88           L7407               dey
+00460b 7408: 88                               dey
+00460c 7409: 30 34                            bmi   L743F
+00460e 740b: b9 51 1c                         lda   $1c51,y
+004611 740e: 30 f7                            bmi   L7407
+004613 7410: 20 79 79                         jsr   L7979
+004616 7413: 90 f2                            bcc   L7407
+004618 7415: 84 01                            sty   _spriteEntryPtr+1
+00461a 7417: be d0 1b                         ldx   $1bd0,y
+00461d 741a: ca                               dex
+00461e 741b: ca                               dex
+00461f 741c: b9 b0 1b                         lda   $1bb0,y
+004622 741f: a0 0e                            ldy   #$0e
+004624 7421: 20 d0 4c                         jsr   eraseFamily
+004627 7424: a6 01                            ldx   _spriteEntryPtr+1
+004629 7426: bc d0 1b                         ldy   $1bd0,x
+00462c 7429: bd b0 1b                         lda   $1bb0,x
+00462f 742c: aa                               tax
+004630 742d: 20 24 5a                         jsr   L5A24
+004633 7430: a6 01                            ldx   _spriteEntryPtr+1
+004635 7432: 20 42 79                         jsr   L7942
+004638 7435: a6 00                            ldx   _spriteEntryPtr
+00463a 7437: a9 ff                            lda   #$ff
+00463c 7439: 9d 90 1b                         sta   $1b90,x
+00463f 743c: 20 59 74                         jsr   L7459
+004642 743f: a6 00        L743F               ldx   _spriteEntryPtr
+004644 7441: 20 79 74     L7441               jsr   L7479
+004647 7444: a9 01                            lda   #$01
+004649 7446: a2 f4                            ldx   #$f4
+00464b 7448: 20 d0 4d                         jsr   detectCollision
+00464e 744b: ad 32 0c                         lda   L0C32
+004651 744e: 8d 1e 14                         sta   $141e
+004654 7451: ad 31 0c                         lda   L0C31
+004657 7454: 8d 1f 14                         sta   $141f
+00465a 7457: 38                               sec
+00465b 7458: 60                               rts

+00465c 7459: ad 19 14     L7459               lda   $1419
+00465f 745c: f0 1a                            beq   L7478
+004661 745e: ae 18 14                         ldx   $1418
+004664 7461: a9 00                            lda   #$00
+004666 7463: ca           L7463               dex
+004667 7464: 30 0f                            bmi   L7475
+004669 7466: bc 90 1b                         ldy   $1b90,x
+00466c 7469: 30 f8                            bmi   L7463
+00466e 746b: dd 90 1b                         cmp   $1b90,x
+004671 746e: b0 f3                            bcs   L7463
+004673 7470: bd 90 1b                         lda   $1b90,x
+004676 7473: 10 ee                            bpl   L7463
+004678 7475: 8d 19 14     L7475               sta   $1419
+00467b 7478: 60           L7478               rts

+00467c 7479: 8a           L7479               txa
+00467d 747a: 48                               pha
+00467e 747b: ce 18 14                         dec   $1418
+004681 747e: bd 21 1b     L747E               lda   $1b21,x
+004684 7481: 9d 20 1b                         sta   $1b20,x
+004687 7484: bd 31 1b                         lda   $1b31,x
+00468a 7487: 9d 30 1b                         sta   $1b30,x
+00468d 748a: bd 41 1b                         lda   $1b41,x
+004690 748d: 9d 40 1b                         sta   $1b40,x
+004693 7490: bd 51 1b                         lda   $1b51,x
+004696 7493: 9d 50 1b                         sta   $1b50,x
+004699 7496: bd 61 1b                         lda   $1b61,x
+00469c 7499: 9d 60 1b                         sta   $1b60,x
+00469f 749c: bd 71 1b                         lda   $1b71,x
+0046a2 749f: 9d 70 1b                         sta   $1b70,x
+0046a5 74a2: bd 81 1b                         lda   $1b81,x
+0046a8 74a5: 9d 80 1b                         sta   $1b80,x
+0046ab 74a8: bd 91 1b                         lda   $1b91,x
+0046ae 74ab: 9d 90 1b                         sta   $1b90,x
+0046b1 74ae: bd a1 1b                         lda   $1ba1,x
+0046b4 74b1: 9d a0 1b                         sta   $1ba0,x
+0046b7 74b4: e8                               inx
+0046b8 74b5: ec 18 14                         cpx   $1418
+0046bb 74b8: 90 c4                            bcc   L747E
+0046bd 74ba: 68                               pla
+0046be 74bb: aa                               tax
+0046bf 74bc: 60                               rts

+0046c0 74bd: a9 00        L74BD               lda   #$00                                    ;called from jump table only
+0046c2 74bf: 85 fc                            sta   PixelLineBaseL
+0046c4 74c1: 85 fe                            sta   PixelLineBaseH
+0046c6 74c3: ad 1d 14                         lda   $141d
+0046c9 74c6: 0a                               asl   A
+0046ca 74c7: aa                               tax
+0046cb 74c8: ca           L74C8               dex
+0046cc 74c9: ca                               dex
+0046cd 74ca: 10 01                            bpl   L74CD
+0046cf 74cc: 60                               rts

+0046d0 74cd: 86 00        L74CD               stx   _spriteEntryPtr
+0046d2 74cf: 20 28 76                         jsr   L7628
+0046d5 74d2: a6 00                            ldx   _spriteEntryPtr
+0046d7 74d4: 20 46 75                         jsr   L7546
+0046da 74d7: bc 80 1c                         ldy   $1c80,x
+0046dd 74da: bd 70 1c                         lda   $1c70,x
+0046e0 74dd: 20 1c 4c                         jsr   divdeA7
+0046e3 74e0: 85 04                            sta   _length
+0046e5 74e2: a9 00                            lda   #$00
+0046e7 74e4: 38                               sec
+0046e8 74e5: 2a           L74E5               rol   A
+0046e9 74e6: ca                               dex
+0046ea 74e7: 10 fc                            bpl   L74E5
+0046ec 74e9: 85 0a                            sta   _colorBit
+0046ee 74eb: a2 02                            ldx   #$02
+0046f0 74ed: b1 fc        L74ED               lda   (PixelLineBaseL),y
+0046f2 74ef: 85 06                            sta   _strobePtr
+0046f4 74f1: b1 fe                            lda   (PixelLineBaseH),y
+0046f6 74f3: 85 07                            sta   _strobePtr+1
+0046f8 74f5: 84 05                            sty   _ix
+0046fa 74f7: a4 04                            ldy   _length
+0046fc 74f9: a5 0a                            lda   _colorBit
+0046fe 74fb: 11 06                            ora   (_strobePtr),y
+004700 74fd: 91 06                            sta   (_strobePtr),y
+004702 74ff: a5 0a                            lda   _colorBit
+004704 7501: 0a                               asl   A
+004705 7502: 10 03                            bpl   L7507
+004707 7504: c8                               iny
+004708 7505: a9 01                            lda   #$01
+00470a 7507: 11 06        L7507               ora   (_strobePtr),y
+00470c 7509: 91 06                            sta   (_strobePtr),y
+00470e 750b: a4 05                            ldy   _ix
+004710 750d: c8                               iny
+004711 750e: ca                               dex
+004712 750f: d0 dc                            bne   L74ED
+004714 7511: a6 00                            ldx   _spriteEntryPtr
+004716 7513: de b0 1c                         dec   $1cb0,x
+004719 7516: 10 b0                            bpl   L74C8
+00471b 7518: a4 00                            ldy   _spriteEntryPtr
+00471d 751a: 20 8f 76                         jsr   L768F
+004720 751d: a5 02                            lda   _strobePtrOffs
+004722 751f: 99 90 1c                         sta   $1c90,y
+004725 7522: 99 c0 1c                         sta   $1cc0,y
+004728 7525: a5 03                            lda   $03
+00472a 7527: 99 a0 1c                         sta   $1ca0,y
+00472d 752a: 99 d0 1c                         sta   $1cd0,y
+004730 752d: ad 2d 0c                         lda   L0C2D
+004733 7530: 20 4b 4c                         jsr   multiplyRndX
+004736 7533: 18                               clc
+004737 7534: 6d 2e 0c                         adc   L0C2E
+00473a 7537: 99 b0 1c                         sta   $1cb0,y
+00473d 753a: c8                               iny
+00473e 753b: ad 2e 0c                         lda   L0C2E
+004741 753e: 99 b0 1c                         sta   $1cb0,y
+004744 7541: a6 00                            ldx   _spriteEntryPtr
+004746 7543: 4c c8 74                         jmp   L74C8

+004749 7546: bd 70 1c     L7546               lda   $1c70,x
+00474c 7549: 18                               clc
+00474d 754a: 7d 90 1c                         adc   $1c90,x
+004750 754d: c9 02                            cmp   #$02
+004752 754f: 90 04                            bcc   L7555
+004754 7551: c9 fe                            cmp   #$fe
+004756 7553: 90 0d                            bcc   L7562
+004758 7555: bd 90 1c     L7555               lda   $1c90,x
+00475b 7558: 49 ff                            eor   #$ff
+00475d 755a: 18                               clc
+00475e 755b: 69 01                            adc   #$01
+004760 755d: 9d 90 1c                         sta   $1c90,x
+004763 7560: d0 e4                            bne   L7546
+004765 7562: 9d 70 1c     L7562               sta   $1c70,x
+004768 7565: bd 80 1c     L7565               lda   $1c80,x
+00476b 7568: 18                               clc
+00476c 7569: 7d a0 1c                         adc   $1ca0,x
+00476f 756c: c9 02                            cmp   #$02
+004771 756e: 90 04                            bcc   L7574
+004773 7570: c9 be                            cmp   #$be
+004775 7572: 90 0d                            bcc   L7581
+004777 7574: bd a0 1c     L7574               lda   $1ca0,x
+00477a 7577: 49 ff                            eor   #$ff
+00477c 7579: 18                               clc
+00477d 757a: 69 01                            adc   #$01
+00477f 757c: 9d a0 1c                         sta   $1ca0,x
+004782 757f: d0 e4                            bne   L7565
+004784 7581: 9d 80 1c     L7581               sta   $1c80,x
+004787 7584: 60                               rts

+004788 7585: ad 1d 14     L7585               lda   $141d                                   ;called from jump table only
+00478b 7588: 0a                               asl   A
+00478c 7589: aa                               tax
+00478d 758a: e6 1c                            inc   $1c
+00478f 758c: e6 1d                            inc   $1d
+004791 758e: a5 1c                            lda   $1c
+004793 7590: 38                               sec
+004794 7591: e9 04                            sbc   #$04
+004796 7593: b0 02                            bcs   L7597
+004798 7595: a9 00                            lda   #$00
+00479a 7597: a8           L7597               tay
+00479b 7598: a5 1c        L7598               lda   $1c
+00479d 759a: ca           L759A               dex
+00479e 759b: ca                               dex
+00479f 759c: 10 06                            bpl   L75A4
+0047a1 759e: c6 1c                            dec   $1c
+0047a3 75a0: c6 1d                            dec   $1d
+0047a5 75a2: 18                               clc
+0047a6 75a3: 60                               rts

+0047a7 75a4: dd 70 1c     L75A4               cmp   $1c70,x
+0047aa 75a7: 90 f1                            bcc   L759A
+0047ac 75a9: 98                               tya
+0047ad 75aa: dd 70 1c                         cmp   $1c70,x
+0047b0 75ad: b0 e9                            bcs   L7598
+0047b2 75af: a5 1d                            lda   $1d
+0047b4 75b1: dd 80 1c                         cmp   $1c80,x
+0047b7 75b4: 90 e2                            bcc   L7598
+0047b9 75b6: e9 04                            sbc   #$04
+0047bb 75b8: 90 05                            bcc   L75BF
+0047bd 75ba: dd 80 1c                         cmp   $1c80,x
+0047c0 75bd: b0 d9                            bcs   L7598
+0047c2 75bf: a5 e8        L75BF               lda   $e8
+0047c4 75c1: f0 02                            beq   L75C5
+0047c6 75c3: 38                               sec
+0047c7 75c4: 60                               rts

+0047c8 75c5: 86 00        L75C5               stx   _spriteEntryPtr
+0047ca 75c7: a9 00                            lda   #$00
+0047cc 75c9: 85 fc                            sta   PixelLineBaseL
+0047ce 75cb: 85 fe                            sta   PixelLineBaseH
+0047d0 75cd: ad 2e 0c                         lda   L0C2E
+0047d3 75d0: 85 02                            sta   _strobePtrOffs
+0047d5 75d2: 20 28 76     L75D2               jsr   L7628
+0047d8 75d5: c6 02                            dec   _strobePtrOffs
+0047da 75d7: 10 f9                            bpl   L75D2
+0047dc 75d9: a6 00                            ldx   _spriteEntryPtr
+0047de 75db: 20 eb 75                         jsr   L75EB
+0047e1 75de: a9 00                            lda   #$00
+0047e3 75e0: a2 64                            ldx   #$64
+0047e5 75e2: 20 d0 4d                         jsr   detectCollision
+0047e8 75e5: c6 1c                            dec   $1c
+0047ea 75e7: c6 1d                            dec   $1d
+0047ec 75e9: 38                               sec
+0047ed 75ea: 60                               rts

+0047ee 75eb: 8a           L75EB               txa
+0047ef 75ec: 48                               pha
+0047f0 75ed: ce 1d 14                         dec   $141d
+0047f3 75f0: ad 1d 14                         lda   $141d
+0047f6 75f3: 0a                               asl   A
+0047f7 75f4: 85 06                            sta   _strobePtr
+0047f9 75f6: bd 72 1c     L75F6               lda   $1c72,x
+0047fc 75f9: 9d 70 1c                         sta   $1c70,x
+0047ff 75fc: bd 82 1c                         lda   $1c82,x
+004802 75ff: 9d 80 1c                         sta   $1c80,x
+004805 7602: bd 92 1c                         lda   $1c92,x
+004808 7605: 9d 90 1c                         sta   $1c90,x
+00480b 7608: bd a2 1c                         lda   $1ca2,x
+00480e 760b: 9d a0 1c                         sta   $1ca0,x
+004811 760e: bd b2 1c                         lda   $1cb2,x
+004814 7611: 9d b0 1c                         sta   $1cb0,x
+004817 7614: bd c2 1c                         lda   $1cc2,x
+00481a 7617: 9d c0 1c                         sta   $1cc0,x
+00481d 761a: bd d2 1c                         lda   $1cd2,x
+004820 761d: 9d d0 1c                         sta   $1cd0,x
+004823 7620: e8                               inx
+004824 7621: e4 06                            cpx   _strobePtr
+004826 7623: 90 d1                            bcc   L75F6
+004828 7625: 68                               pla
+004829 7626: aa                               tax
+00482a 7627: 60                               rts

+00482b 7628: a6 00        L7628               ldx   _spriteEntryPtr
+00482d 762a: e8                               inx
+00482e 762b: bd c0 1c                         lda   $1cc0,x
+004831 762e: f0 05                            beq   L7635
+004833 7630: de c0 1c                         dec   $1cc0,x
+004836 7633: 10 59                            bpl   L768E
+004838 7635: bc 80 1c     L7635               ldy   $1c80,x
+00483b 7638: bd 70 1c                         lda   $1c70,x
+00483e 763b: 20 1c 4c                         jsr   divdeA7
+004841 763e: 85 04                            sta   _length
+004843 7640: a9 ff                            lda   #$ff
+004845 7642: 18                               clc
+004846 7643: 2a           L7643               rol   A
+004847 7644: ca                               dex
+004848 7645: 10 fc                            bpl   L7643
+00484a 7647: 85 0a                            sta   _colorBit
+00484c 7649: a2 02                            ldx   #$02
+00484e 764b: b1 fc        L764B               lda   (PixelLineBaseL),y
+004850 764d: 85 06                            sta   _strobePtr
+004852 764f: b1 fe                            lda   (PixelLineBaseH),y
+004854 7651: 85 07                            sta   _strobePtr+1
+004856 7653: 84 05                            sty   _ix
+004858 7655: a4 04                            ldy   _length
+00485a 7657: a5 0a                            lda   _colorBit
+00485c 7659: 31 06                            and   (_strobePtr),y
+00485e 765b: 91 06                            sta   (_strobePtr),y
+004860 765d: a5 0a                            lda   _colorBit
+004862 765f: 38                               sec
+004863 7660: 2a                               rol   A
+004864 7661: 30 03                            bmi   L7666
+004866 7663: c8                               iny
+004867 7664: a9 fe                            lda   #$fe
+004869 7666: 31 06        L7666               and   (_strobePtr),y
+00486b 7668: 91 06                            sta   (_strobePtr),y
+00486d 766a: a4 05                            ldy   _ix
+00486f 766c: c8                               iny
+004870 766d: ca                               dex
+004871 766e: d0 db                            bne   L764B
+004873 7670: a6 00                            ldx   _spriteEntryPtr
+004875 7672: e8                               inx
+004876 7673: 20 46 75                         jsr   L7546
+004879 7676: de b0 1c                         dec   $1cb0,x
+00487c 7679: d0 13                            bne   L768E
+00487e 767b: a9 40                            lda   #$40
+004880 767d: 9d b0 1c                         sta   $1cb0,x
+004883 7680: a4 00                            ldy   _spriteEntryPtr
+004885 7682: b9 c0 1c                         lda   $1cc0,y
+004888 7685: 9d 90 1c                         sta   $1c90,x
+00488b 7688: b9 d0 1c                         lda   $1cd0,y
+00488e 768b: 9d a0 1c                         sta   $1ca0,x
+004891 768e: 60           L768E               rts

+004892 768f: a2 00        L768F               ldx   #$00
+004894 7691: a5 4e                            lda   MON_RNDL
+004896 7693: 4a                               lsr   A
+004897 7694: 90 06                            bcc   L769C
+004899 7696: e8                               inx
+00489a 7697: 4a                               lsr   A
+00489b 7698: 90 02                            bcc   L769C
+00489d 769a: ca                               dex
+00489e 769b: ca                               dex
+00489f 769c: a5 4f        L769C               lda   MON_RNDH
+0048a1 769e: 29 03                            and   #$03
+0048a3 76a0: 38                               sec
+0048a4 76a1: e9 02                            sbc   #$02
+0048a6 76a3: 90 02                            bcc   L76A7
+0048a8 76a5: 69 00                            adc   #$00
+0048aa 76a7: 24 4f        L76A7               bit   MON_RNDH
+0048ac 76a9: 10 05                            bpl   L76B0
+0048ae 76ab: 86 02                            stx   _strobePtrOffs
+0048b0 76ad: aa                               tax
+0048b1 76ae: a5 02                            lda   _strobePtrOffs
+0048b3 76b0: 86 02        L76B0               stx   _strobePtrOffs
+0048b5 76b2: 85 03                            sta   $03
+0048b7 76b4: 20 36 4c                         jsr   randomA
+0048ba 76b7: cd 2f 0c                         cmp   L0C2F
+0048bd 76ba: b0 34                            bcs   L76F0
+0048bf 76bc: b9 70 1c                         lda   $1c70,y
+0048c2 76bf: cd 00 15                         cmp   $1500
+0048c5 76c2: a5 02                            lda   _strobePtrOffs
+0048c7 76c4: b0 08                            bcs   L76CE
+0048c9 76c6: 10 0c                            bpl   L76D4
+0048cb 76c8: 49 ff                            eor   #$ff
+0048cd 76ca: 69 01                            adc   #$01
+0048cf 76cc: 10 06                            bpl   L76D4
+0048d1 76ce: 30 04        L76CE               bmi   L76D4
+0048d3 76d0: 49 ff                            eor   #$ff
+0048d5 76d2: 69 00                            adc   #$00
+0048d7 76d4: 85 02        L76D4               sta   _strobePtrOffs
+0048d9 76d6: b9 80 1c                         lda   $1c80,y
+0048dc 76d9: cd 01 15                         cmp   $1501
+0048df 76dc: a5 03                            lda   $03
+0048e1 76de: b0 08                            bcs   L76E8
+0048e3 76e0: 10 0c                            bpl   L76EE
+0048e5 76e2: 49 ff                            eor   #$ff
+0048e7 76e4: 69 01                            adc   #$01
+0048e9 76e6: 10 06                            bpl   L76EE
+0048eb 76e8: 30 04        L76E8               bmi   L76EE
+0048ed 76ea: 49 ff                            eor   #$ff
+0048ef 76ec: 69 00                            adc   #$00
+0048f1 76ee: 85 03        L76EE               sta   $03
+0048f3 76f0: 60           L76F0               rts

+0048f4 76f1: ad 1b 14     L76F1               lda   $141b                                   ;called from jump table only
+0048f7 76f4: 0a                               asl   A
+0048f8 76f5: aa                               tax
+0048f9 76f6: ca           L76F6               dex
+0048fa 76f7: ca                               dex
+0048fb 76f8: 10 03                            bpl   L76FD
+0048fd 76fa: 4c dd 77                         jmp   L77DD

+004900 76fd: bd 51 1c     L76FD               lda   $1c51,x
+004903 7700: 30 09                            bmi   L770B
+004905 7702: 86 00                            stx   _spriteEntryPtr
+004907 7704: 20 21 78                         jsr   L7821
+00490a 7707: a6 00                            ldx   _spriteEntryPtr
+00490c 7709: 10 eb                            bpl   L76F6
+00490e 770b: ad 08 15     L770B               lda   UsedPaddle?
+004911 770e: d0 e6                            bne   L76F6
+004913 7710: 86 00                            stx   _spriteEntryPtr
+004915 7712: bd 31 1c                         lda   $1c31,x
+004918 7715: 30 06                            bmi   L771D
+00491a 7717: de 31 1c                         dec   $1c31,x
+00491d 771a: 4c 20 77                         jmp   L7720

+004920 771d: 20 78 77     L771D               jsr   L7778
+004923 7720: a6 00        L7720               ldx   _spriteEntryPtr
+004925 7722: 20 9e 77                         jsr   L779E
+004928 7725: bd 50 1c                         lda   $1c50,x
+00492b 7728: 0a                               asl   A
+00492c 7729: 0a                               asl   A
+00492d 772a: 1d f0 1b                         ora   $1bf0,x
+004930 772d: a8                               tay
+004931 772e: b9 f0 08                         lda   L08F0,y
+004934 7731: 85 06                            sta   _strobePtr
+004936 7733: b9 00 09                         lda   L0900,y
+004939 7736: 85 07                            sta   _strobePtr+1
+00493b 7738: bc d0 1b                         ldy   $1bd0,x
+00493e 773b: bd b0 1b                         lda   $1bb0,x
+004941 773e: aa                               tax
+004942 773f: 20 59 50                         jsr   drawYou
+004945 7742: a6 00                            ldx   _spriteEntryPtr
+004947 7744: de 10 1c                         dec   $1c10,x
+00494a 7747: 10 ad                            bpl   L76F6
+00494c 7749: a9 70                            lda   #$70
+00494e 774b: 9d 10 1c                         sta   $1c10,x
+004951 774e: bd b0 1b                         lda   $1bb0,x
+004954 7751: ac 00 15                         ldy   $1500
+004957 7754: 20 12 78                         jsr   L7812
+00495a 7757: 85 02                            sta   _strobePtrOffs
+00495c 7759: 84 03                            sty   $03
+00495e 775b: bd d0 1b                         lda   $1bd0,x
+004961 775e: ac 01 15                         ldy   $1501
+004964 7761: 20 12 78                         jsr   L7812
+004967 7764: c5 02                            cmp   _strobePtrOffs
+004969 7766: b0 04                            bcs   L776C
+00496b 7768: a5 03                            lda   $03
+00496d 776a: 10 03                            bpl   L776F
+00496f 776c: 98           L776C               tya
+004970 776d: 09 02                            ora   #$02
+004972 776f: 9d f0 1b     L776F               sta   $1bf0,x
+004975 7772: 9d 30 1c                         sta   $1c30,x
+004978 7775: 4c f6 76                         jmp   L76F6

+00497b 7778: a6 00        L7778               ldx   _spriteEntryPtr
+00497d 777a: e8                               inx
+00497e 777b: 20 9e 77                         jsr   L779E
+004981 777e: 8a                               txa
+004982 777f: a8                               tay
+004983 7780: be d0 1b                         ldx   $1bd0,y
+004986 7783: b9 b0 1b                         lda   $1bb0,y
+004989 7786: a0 0a                            ldy   #$0a
+00498b 7788: 20 d0 4c                         jsr   eraseFamily
+00498e 778b: a6 00                            ldx   _spriteEntryPtr
+004990 778d: de 11 1c                         dec   $1c11,x
+004993 7790: 10 0b                            bpl   L779D
+004995 7792: a9 70                            lda   #$70
+004997 7794: 9d 11 1c                         sta   $1c11,x
+00499a 7797: bd 30 1c                         lda   $1c30,x
+00499d 779a: 9d f1 1b                         sta   $1bf1,x
+0049a0 779d: 60           L779D               rts

+0049a1 779e: bc f0 1b     L779E               ldy   $1bf0,x
+0049a4 77a1: bd b0 1b                         lda   $1bb0,x
+0049a7 77a4: 18                               clc
+0049a8 77a5: 79 3e 0d                         adc   L0D3E,y
+0049ab 77a8: c9 06                            cmp   #$06
+0049ad 77aa: b0 04                            bcs   L77B0
+0049af 77ac: a9 00                            lda   #$00
+0049b1 77ae: 10 06                            bpl   L77B6

+0049b3 77b0: c9 f3        L77B0               cmp   #$f3
+0049b5 77b2: 90 07                            bcc   L77BB
+0049b7 77b4: a9 01                            lda   #$01
+0049b9 77b6: 9d f0 1b     L77B6               sta   $1bf0,x
+0049bc 77b9: 10 e3                            bpl   L779E

+0049be 77bb: 9d b0 1b     L77BB               sta   $1bb0,x
+0049c1 77be: bd d0 1b     L77BE               lda   $1bd0,x
+0049c4 77c1: 18                               clc
+0049c5 77c2: 79 42 0d                         adc   L0D42,y
+0049c8 77c5: c9 06                            cmp   #$06
+0049ca 77c7: b0 04                            bcs   L77CD
+0049cc 77c9: a9 02                            lda   #$02
+0049ce 77cb: 10 06                            bpl   L77D3

+0049d0 77cd: c9 b0        L77CD               cmp   #$b0
+0049d2 77cf: 90 08                            bcc   L77D9
+0049d4 77d1: a9 03                            lda   #$03
+0049d6 77d3: 9d f0 1b     L77D3               sta   $1bf0,x
+0049d9 77d6: a8                               tay
+0049da 77d7: 10 e5                            bpl   L77BE
+0049dc 77d9: 9d d0 1b     L77D9               sta   $1bd0,x
+0049df 77dc: 60                               rts

+0049e0 77dd: ce 26 14     L77DD               dec   $1426
+0049e3 77e0: 10 2f                            bpl   L7811
+0049e5 77e2: ad 2b 0c                         lda   L0C2B
+0049e8 77e5: 20 4b 4c                         jsr   multiplyRndX
+0049eb 77e8: 85 06                            sta   _strobePtr
+0049ed 77ea: ad 2a 0c                         lda   L0C2A
+0049f0 77ed: 18                               clc
+0049f1 77ee: 69 01                            adc   #$01
+0049f3 77f0: 0a                               asl   A
+0049f4 77f1: 65 06                            adc   _strobePtr
+0049f6 77f3: 8d 26 14                         sta   $1426
+0049f9 77f6: ad 1b 14                         lda   $141b
+0049fc 77f9: 0a                               asl   A
+0049fd 77fa: aa                               tax
+0049fe 77fb: ca           L77FB               dex
+0049ff 77fc: ca                               dex
+004a00 77fd: 30 12                            bmi   L7811
+004a02 77ff: bd 31 1c                         lda   $1c31,x
+004a05 7802: 10 f7                            bpl   L77FB
+004a07 7804: a9 00                            lda   #$00
+004a09 7806: 9d 10 1c                         sta   $1c10,x
+004a0c 7809: ad 2a 0c                         lda   L0C2A
+004a0f 780c: 9d 11 1c                         sta   $1c11,x
+004a12 780f: 10 ea                            bpl   L77FB
+004a14 7811: 60           L7811               rts

+004a15 7812: 84 01        L7812               sty   _spriteEntryPtr+1
+004a17 7814: a0 01                            ldy   #$01
+004a19 7816: 38                               sec
+004a1a 7817: e5 01                            sbc   _spriteEntryPtr+1
+004a1c 7819: b0 05                            bcs   L7820
+004a1e 781b: 49 ff                            eor   #$ff
+004a20 781d: 69 01                            adc   #$01
+004a22 781f: 88                               dey
+004a23 7820: 60           L7820               rts

+004a24 7821: ac 08 15     L7821               ldy   UsedPaddle?
+004a27 7824: b9 41 0c                         lda   L0C41,y
+004a2a 7827: 85 02                            sta   _strobePtrOffs
+004a2c 7829: de 51 1c                         dec   $1c51,x
+004a2f 782c: 10 10                            bpl   L783E
+004a31 782e: bd d0 1b                         lda   $1bd0,x
+004a34 7831: 38                               sec
+004a35 7832: e9 02                            sbc   #$02
+004a37 7834: bc b0 1b                         ldy   $1bb0,x
+004a3a 7837: aa                               tax
+004a3b 7838: 98                               tya
+004a3c 7839: a0 0e                            ldy   #$0e
+004a3e 783b: 4c d0 4c                         jmp   eraseFamily

+004a41 783e: bd 50 1c     L783E               lda   $1c50,x
+004a44 7841: 0a                               asl   A
+004a45 7842: 1d f0 1b                         ora   $1bf0,x
+004a48 7845: 0a                               asl   A
+004a49 7846: a8                               tay
+004a4a 7847: b9 a0 08                         lda   L08A0,y
+004a4d 784a: 85 06                            sta   _strobePtr
+004a4f 784c: b9 b0 08                         lda   L08B0,y
+004a52 784f: 85 07                            sta   _strobePtr+1
+004a54 7851: bd d0 1b                         lda   $1bd0,x
+004a57 7854: 38                               sec
+004a58 7855: e9 02                            sbc   #$02
+004a5a 7857: a4 4e                            ldy   MON_RNDL
+004a5c 7859: 10 02                            bpl   L785D
+004a5e 785b: e9 fc                            sbc   #$fc
+004a60 785d: a8           L785D               tay
+004a61 785e: bd b0 1b                         lda   $1bb0,x
+004a64 7861: aa                               tax
+004a65 7862: 20 7c 4c                         jsr   fetchSprite
+004a68 7865: b1 fc        L7865               lda   (PixelLineBaseL),y
+004a6a 7867: 85 06                            sta   _strobePtr
+004a6c 7869: b1 fe                            lda   (PixelLineBaseH),y
+004a6e 786b: 85 07                            sta   _strobePtr+1
+004a70 786d: 84 05                            sty   _ix
+004a72 786f: a4 04                            ldy   _length
+004a74 7871: a1 08                            lda   (_destPtr,x)
+004a76 7873: 45 02                            eor   _strobePtrOffs
+004a78 7875: 91 06                            sta   (_strobePtr),y
+004a7a 7877: e6 08                            inc   _destPtr
+004a7c 7879: c8                               iny
+004a7d 787a: a1 08                            lda   (_destPtr,x)
+004a7f 787c: 45 02                            eor   _strobePtrOffs
+004a81 787e: 91 06                            sta   (_strobePtr),y
+004a83 7880: e6 08                            inc   _destPtr
+004a85 7882: a4 05                            ldy   _ix
+004a87 7884: 88                               dey
+004a88 7885: 10 de                            bpl   L7865
+004a8a 7887: 4c 6e 4c                         jmp   doSpeaker                               ;speaker tail call

+004a8d 788a: ad 1b 14     L788A               lda   $141b                                   ;called from jump table only
+004a90 788d: 0a                               asl   A
+004a91 788e: aa                               tax
+004a92 788f: a5 1c                            lda   $1c
+004a94 7891: 38                               sec
+004a95 7892: e9 07                            sbc   #$07
+004a97 7894: b0 02                            bcs   L7898
+004a99 7896: a9 00                            lda   #$00
+004a9b 7898: a8           L7898               tay
+004a9c 7899: a5 1c        L7899               lda   $1c
+004a9e 789b: ca           L789B               dex
+004a9f 789c: ca                               dex
+004aa0 789d: 10 02                            bpl   L78A1
+004aa2 789f: 18                               clc
+004aa3 78a0: 60                               rts

+004aa4 78a1: dd b0 1b     L78A1               cmp   $1bb0,x
+004aa7 78a4: 90 f5                            bcc   L789B
+004aa9 78a6: 98                               tya
+004aaa 78a7: dd b0 1b                         cmp   $1bb0,x
+004aad 78aa: b0 ed                            bcs   L7899
+004aaf 78ac: a5 1d                            lda   $1d
+004ab1 78ae: dd d0 1b                         cmp   $1bd0,x
+004ab4 78b1: 90 e6                            bcc   L7899
+004ab6 78b3: e9 0a                            sbc   #$0a
+004ab8 78b5: 90 05                            bcc   L78BC
+004aba 78b7: dd d0 1b                         cmp   $1bd0,x
+004abd 78ba: b0 dd                            bcs   L7899
+004abf 78bc: a5 e8        L78BC               lda   $e8
+004ac1 78be: f0 02                            beq   L78C2
+004ac3 78c0: 38                               sec
+004ac4 78c1: 60                               rts

+004ac5 78c2: 86 00        L78C2               stx   _spriteEntryPtr
+004ac7 78c4: bd 51 1c                         lda   $1c51,x
+004aca 78c7: 10 31                            bpl   L78FA
+004acc 78c9: ad 2a 0c                         lda   L0C2A
+004acf 78cc: 85 01                            sta   _spriteEntryPtr+1
+004ad1 78ce: 20 78 77     L78CE               jsr   L7778
+004ad4 78d1: c6 01                            dec   _spriteEntryPtr+1
+004ad6 78d3: 10 f9                            bpl   L78CE
+004ad8 78d5: bd d0 1b                         lda   $1bd0,x
+004adb 78d8: 18                               clc
+004adc 78d9: 69 05                            adc   #$05
+004ade 78db: a8                               tay
+004adf 78dc: bd b0 1b                         lda   $1bb0,x
+004ae2 78df: aa                               tax
+004ae3 78e0: a9 7f                            lda   #$7f
+004ae5 78e2: 20 74 4f                         jsr   L4F74
+004ae8 78e5: ad 37 0c                         lda   L0C37
+004aeb 78e8: 8d 06 14                         sta   Level-1
+004aee 78eb: ad 38 0c                         lda   L0C38
+004af1 78ee: 8d 22 14                         sta   $1422
+004af4 78f1: ad 39 0c                         lda   L0C39
+004af7 78f4: 8d 23 14                         sta   $1423
+004afa 78f7: 38                               sec
+004afb 78f8: b0 36                            bcs   L7930

+004afd 78fa: a4 00        L78FA               ldy   _spriteEntryPtr
+004aff 78fc: be d0 1b                         ldx   $1bd0,y
+004b02 78ff: ca                               dex
+004b03 7900: ca                               dex
+004b04 7901: b9 b0 1b                         lda   $1bb0,y
+004b07 7904: a0 0e                            ldy   #$0e
+004b09 7906: 20 d0 4c                         jsr   eraseFamily
+004b0c 7909: a6 00                            ldx   _spriteEntryPtr
+004b0e 790b: bc d0 1b                         ldy   $1bd0,x
+004b11 790e: bd b0 1b                         lda   $1bb0,x
+004b14 7911: aa                               tax
+004b15 7912: 20 24 5a                         jsr   L5A24
+004b18 7915: a4 00                            ldy   _spriteEntryPtr
+004b1a 7917: ae 18 14                         ldx   $1418
+004b1d 791a: ca           L791A               dex
+004b1e 791b: 30 12                            bmi   L792F
+004b20 791d: bd 90 1b                         lda   $1b90,x
+004b23 7920: 30 f8                            bmi   L791A
+004b25 7922: 20 79 79                         jsr   L7979
+004b28 7925: 90 f3                            bcc   L791A
+004b2a 7927: a9 ff                            lda   #$ff
+004b2c 7929: 9d 90 1b                         sta   $1b90,x
+004b2f 792c: 20 59 74                         jsr   L7459
+004b32 792f: 18           L792F               clc
+004b33 7930: 08           L7930               php
+004b34 7931: a6 00                            ldx   _spriteEntryPtr
+004b36 7933: 20 42 79                         jsr   L7942
+004b39 7936: 28                               plp
+004b3a 7937: 90 07                            bcc   L7940
+004b3c 7939: a9 00                            lda   #$00
+004b3e 793b: a2 64                            ldx   #$64
+004b40 793d: 20 d0 4d                         jsr   detectCollision
+004b43 7940: 38           L7940               sec
+004b44 7941: 60                               rts

+004b45 7942: 8a           L7942               txa
+004b46 7943: 48                               pha
+004b47 7944: ce 1b 14                         dec   $141b
+004b4a 7947: ad 1b 14                         lda   $141b
+004b4d 794a: 0a                               asl   A
+004b4e 794b: 85 06                            sta   _strobePtr
+004b50 794d: bd b2 1b     L794D               lda   $1bb2,x
+004b53 7950: 9d b0 1b                         sta   $1bb0,x
+004b56 7953: bd d2 1b                         lda   $1bd2,x
+004b59 7956: 9d d0 1b                         sta   $1bd0,x
+004b5c 7959: bd f2 1b                         lda   $1bf2,x
+004b5f 795c: 9d f0 1b                         sta   $1bf0,x
+004b62 795f: bd 12 1c                         lda   $1c12,x
+004b65 7962: 9d 10 1c                         sta   $1c10,x
+004b68 7965: bd 32 1c                         lda   $1c32,x
+004b6b 7968: 9d 30 1c                         sta   $1c30,x
+004b6e 796b: bd 52 1c                         lda   $1c52,x
+004b71 796e: 9d 50 1c                         sta   $1c50,x
+004b74 7971: e8                               inx
+004b75 7972: e4 06                            cpx   _strobePtr
+004b77 7974: 90 d7                            bcc   L794D
+004b79 7976: 68                               pla
+004b7a 7977: aa                               tax
+004b7b 7978: 60                               rts

+004b7c 7979: bd 30 1b     L7979               lda   $1b30,x
+004b7f 797c: d9 d0 1b                         cmp   $1bd0,y
+004b82 797f: d0 15                            bne   L7996
+004b84 7981: bd 20 1b                         lda   $1b20,x
+004b87 7984: 18                               clc
+004b88 7985: 69 12                            adc   #$12
+004b8a 7987: d9 b0 1b                         cmp   $1bb0,y
+004b8d 798a: f0 08                            beq   L7994
+004b8f 798c: 38                               sec
+004b90 798d: e9 1e                            sbc   #$1e
+004b92 798f: d9 b0 1b                         cmp   $1bb0,y
+004b95 7992: d0 02                            bne   L7996
+004b97 7994: 38           L7994               sec
+004b98 7995: 60                               rts

+004b99 7996: 18           L7996               clc
+004b9a 7997: 60                               rts

+004b9b 7998: 10 10 10 10+                     .fill 7,$10
+004ba2 799f: 9c                               .dd1  $9c
+004ba3 79a0: 10 10 10 10+                     .fill 15,$10
+004bb2 79af: 9c                               .dd1  $9c
+004bb3 79b0: 10 10 10 10+                     .fill 15,$10
+004bc2 79bf: 5c                               .dd1  $5c
+004bc3 79c0: 10 10 10 10+                     .fill 15,$10
+004bd2 79cf: 90                               .dd1  $90
+004bd3 79d0: 10 10 10 10+                     .fill 15,$10
+004be2 79df: 5c                               .dd1  $5c
+004be3 79e0: 10 10 10 10+                     .fill 15,$10
+004bf2 79ef: 14                               .dd1  $14
+004bf3 79f0: 10 10 10 10+                     .fill 15,$10
+004c02 79ff: 50                               .dd1  $50
                           ********************************************************************************
                           *                                                                              *
                           * sprite dictionary                                                            *
                           *                                                                              *
                           ********************************************************************************
+004c03 7a00: 02                               .dd1  $02
+004c04 7a01: 0a                               .dd1  $0a
+004c05 7a02: 00 82                            .dd2  L8200
+004c07 7a04: ff ff ff ff+                     .fill 12,$ff
+004c13 7a10: 02                               .dd1  $02
+004c14 7a11: 0a                               .dd1  $0a
+004c15 7a12: 14 82                            .dd2  L8214
+004c17 7a14: ff ff ff ff+                     .fill 12,$ff
+004c23 7a20: 02                               .dd1  $02
+004c24 7a21: 0a                               .dd1  $0a
+004c25 7a22: 28 82                            .dd2  L8228
+004c27 7a24: ff ff ff ff+                     .fill 12,$ff
+004c33 7a30: 02                               .dd1  $02
+004c34 7a31: 0a                               .dd1  $0a
+004c35 7a32: 3c 82                            .dd2  L823B+1
+004c37 7a34: ff ff ff ff+                     .fill 12,$ff
+004c43 7a40: 02                               .dd1  $02
+004c44 7a41: 0a                               .dd1  $0a
+004c45 7a42: 50 82                            .dd2  L8250
+004c47 7a44: ff ff ff ff+                     .fill 12,$ff
+004c53 7a50: 02                               .dd1  $02
+004c54 7a51: 0a                               .dd1  $0a
+004c55 7a52: 64 82                            .dd2  L8264
+004c57 7a54: ff ff ff ff+                     .fill 12,$ff
+004c63 7a60: 02                               .dd1  $02
+004c64 7a61: 0a                               .dd1  $0a
+004c65 7a62: 78 82                            .dd2  L8278
+004c67 7a64: ff ff ff ff+                     .fill 12,$ff
+004c73 7a70: 03                               .dd1  $03
+004c74 7a71: 0d                               .dd1  $0d
+004c75 7a72: 8c 82                            .dd2  L828C
+004c77 7a74: ff ff ff ff+                     .fill 12,$ff
+004c83 7a80: 03                               .dd1  $03
+004c84 7a81: 0d                               .dd1  $0d
+004c85 7a82: b3 82                            .dd2  L82B3
+004c87 7a84: ff ff ff ff+                     .fill 12,$ff
+004c93 7a90: 02                               .dd1  $02
+004c94 7a91: 0a                               .dd1  $0a
+004c95 7a92: da 82                            .dd2  L82DA
+004c97 7a94: ff ff ff ff+                     .fill 12,$ff
+004ca3 7aa0: 02                               .dd1  $02
+004ca4 7aa1: 0a                               .dd1  $0a
+004ca5 7aa2: 00 83                            .dd2  L82FE+2
+004ca7 7aa4: ff ff ff ff+                     .fill 12,$ff
+004cb3 7ab0: 02                               .dd1  $02
+004cb4 7ab1: 0a                               .dd1  $0a
+004cb5 7ab2: 14 83                            .dd2  L830E+6
+004cb7 7ab4: ff ff ff ff+                     .fill 12,$ff
+004cc3 7ac0: 02                               .dd1  $02
+004cc4 7ac1: 0a                               .dd1  $0a
+004cc5 7ac2: 28 83                            .dd2  L831E+10
+004cc7 7ac4: ff ff ff ff+                     .fill 12,$ff
+004cd3 7ad0: 03                               .dd1  $03
+004cd4 7ad1: 0e                               .dd1  $0e
+004cd5 7ad2: 3c 83                            .dd2  L832E+14
+004cd7 7ad4: ff ff ff ff+                     .fill 12,$ff
+004ce3 7ae0: 03                               .dd1  $03
+004ce4 7ae1: 0e                               .dd1  $0e
+004ce5 7ae2: 66 83                            .dd2  L835E+8
+004ce7 7ae4: ff ff ff ff+                     .fill 12,$ff
+004cf3 7af0: 03                               .dd1  $03
+004cf4 7af1: 0e                               .dd1  $0e
+004cf5 7af2: 90 83                            .dd2  L838E+2
+004cf7 7af4: ff ff ff ff+                     .fill 12,$ff
+004d03 7b00: 03                               .dd1  $03
+004d04 7b01: 0e                               .dd1  $0e
+004d05 7b02: ba 83                            .dd2  L83AE+12
+004d07 7b04: ff ff ff ff+                     .fill 12,$ff
+004d13 7b10: 03                               .dd1  $03
+004d14 7b11: 0e                               .dd1  $0e
+004d15 7b12: 00 84                            .dd2  L83FE+2
+004d17 7b14: ff ff ff ff+                     .fill 12,$ff
+004d23 7b20: 03                               .dd1  $03
+004d24 7b21: 0e                               .dd1  $0e
+004d25 7b22: 2a 84                            .dd2  L841E+12
+004d27 7b24: ff ff ff ff+                     .fill 12,$ff
+004d33 7b30: 03                               .dd1  $03
+004d34 7b31: 0d                               .dd1  $0d
+004d35 7b32: 54 84                            .dd2  L844E+6
+004d37 7b34: ff ff ff ff+                     .fill 12,$ff
+004d43 7b40: 03                               .dd1  $03
+004d44 7b41: 0d                               .dd1  $0d
+004d45 7b42: 7b 84                            .dd2  L846E+13
+004d47 7b44: ff ff ff ff+                     .fill 12,$ff
+004d53 7b50: 03                               .dd1  $03
+004d54 7b51: 0d                               .dd1  $0d
+004d55 7b52: a2 84                            .dd2  L849E+4
+004d57 7b54: ff ff ff ff+                     .fill 12,$ff
+004d63 7b60: 03                               .dd1  $03
+004d64 7b61: 0d                               .dd1  $0d
+004d65 7b62: c9 84                            .dd2  L84BE+11
+004d67 7b64: ff ff ff ff+                     .fill 12,$ff
+004d73 7b70: 02                               .dd1  $02
+004d74 7b71: 07                               .dd1  $07
+004d75 7b72: f0 84                            .dd2  L84EE+2
+004d77 7b74: ff ff ff ff+                     .fill 12,$ff
+004d83 7b80: 02                               .dd1  $02
+004d84 7b81: 07                               .dd1  $07
+004d85 7b82: 00 85                            .dd2  L84FE+2
+004d87 7b84: ff ff ff ff+                     .fill 12,$ff
+004d93 7b90: 03                               .dd1  $03
+004d94 7b91: 0d                               .dd1  $0d
+004d95 7b92: 0e 85                            .dd2  L850E
+004d97 7b94: ff ff ff ff+                     .fill 12,$ff
+004da3 7ba0: 03                               .dd1  $03
+004da4 7ba1: 0d                               .dd1  $0d
+004da5 7ba2: 35 85                            .dd2  L852E+7
+004da7 7ba4: ff ff ff ff+                     .fill 12,$ff
+004db3 7bb0: 03                               .dd1  $03
+004db4 7bb1: 0d                               .dd1  $0d
+004db5 7bb2: 5c 85                            .dd2  L854E+14
+004db7 7bb4: ff ff ff ff+                     .fill 12,$ff
+004dc3 7bc0: 03                               .dd1  $03
+004dc4 7bc1: 0d                               .dd1  $0d
+004dc5 7bc2: 83 85                            .dd2  L857E+5
+004dc7 7bc4: ff ff ff ff+                     .fill 12,$ff
+004dd3 7bd0: 03                               .dd1  $03
+004dd4 7bd1: 0c                               .dd1  $0c
+004dd5 7bd2: aa 85                            .dd2  L859E+12
+004dd7 7bd4: ff ff ff ff+                     .fill 12,$ff
+004de3 7be0: 03                               .dd1  $03
+004de4 7be1: 0c                               .dd1  $0c
+004de5 7be2: ce 85                            .dd2  L85CE
+004de7 7be4: ff ff ff ff+                     .fill 12,$ff
+004df3 7bf0: 03                               .dd1  $03
+004df4 7bf1: 0c                               .dd1  $0c
+004df5 7bf2: 00 86                            .dd2  L85FE+2
+004df7 7bf4: ff ff ff ff+                     .fill 12,$ff
+004e03 7c00: 03                               .dd1  $03
+004e04 7c01: 0c                               .dd1  $0c
+004e05 7c02: 24 86                            .dd2  L861E+6
+004e07 7c04: ff ff ff ff+                     .fill 12,$ff
+004e13 7c10: 03                               .dd1  $03
+004e14 7c11: 0c                               .dd1  $0c
+004e15 7c12: 48 86                            .dd2  L863E+10
+004e17 7c14: ff ff ff ff+                     .fill 12,$ff
+004e23 7c20: 03                               .dd1  $03
+004e24 7c21: 0c                               .dd1  $0c
+004e25 7c22: 6c 86                            .dd2  L865E+14
+004e27 7c24: ff ff ff ff+                     .fill 12,$ff
+004e33 7c30: 03                               .dd1  $03
+004e34 7c31: 0c                               .dd1  $0c
+004e35 7c32: 90 86                            .dd2  L868E+2
+004e37 7c34: ff ff ff ff+                     .fill 12,$ff
+004e43 7c40: 03                               .dd1  $03
+004e44 7c41: 0d                               .dd1  $0d
+004e45 7c42: b4 86                            .dd2  L86AE+6
+004e47 7c44: ff ff ff ff+                     .fill 12,$ff
+004e53 7c50: 03                               .dd1  $03
+004e54 7c51: 0d                               .dd1  $0d
+004e55 7c52: 00 87                            .dd2  L86FE+2
+004e57 7c54: ff ff ff ff+                     .fill 12,$ff
+004e63 7c60: 03                               .dd1  $03
+004e64 7c61: 0d                               .dd1  $0d
+004e65 7c62: 27 87                            .dd2  L871E+9
+004e67 7c64: ff ff ff ff+                     .fill 12,$ff
+004e73 7c70: 02                               .dd1  $02
+004e74 7c71: 0a                               .dd1  $0a
+004e75 7c72: 4e 87                            .dd2  L874E
+004e77 7c74: ff ff ff ff+                     .fill 12,$ff
+004e83 7c80: 02                               .dd1  $02
+004e84 7c81: 0a                               .dd1  $0a
+004e85 7c82: 62 87                            .dd2  L875E+4
+004e87 7c84: ff ff ff ff+                     .fill 12,$ff
+004e93 7c90: 02                               .dd1  $02
+004e94 7c91: 0a                               .dd1  $0a
+004e95 7c92: 76 87                            .dd2  L876E+8
+004e97 7c94: ff ff ff ff+                     .fill 12,$ff
+004ea3 7ca0: 02                               .dd1  $02
+004ea4 7ca1: 0a                               .dd1  $0a
+004ea5 7ca2: 8a 87                            .dd2  L877E+12
+004ea7 7ca4: ff ff ff ff+                     .fill 12,$ff
+004eb3 7cb0: 02                               .dd1  $02
+004eb4 7cb1: 0a                               .dd1  $0a
+004eb5 7cb2: 9e 87                            .dd2  L879E
+004eb7 7cb4: ff ff ff ff+                     .fill 12,$ff
+004ec3 7cc0: 02                               .dd1  $02
+004ec4 7cc1: 0a                               .dd1  $0a
+004ec5 7cc2: b2 87                            .dd2  L87AE+4
+004ec7 7cc4: ff ff ff ff+                     .fill 12,$ff
+004ed3 7cd0: 03                               .dd1  $03
+004ed4 7cd1: 0f                               .dd1  $0f
+004ed5 7cd2: c6 87                            .dd2  L87BE+8
+004ed7 7cd4: ff ff ff ff+                     .fill 12,$ff
+004ee3 7ce0: 03                               .dd1  $03
+004ee4 7ce1: 0f                               .dd1  $0f
+004ee5 7ce2: 00 88                            .dd2  L87FE+2
+004ee7 7ce4: ff ff ff ff+                     .fill 12,$ff
+004ef3 7cf0: 03                               .dd1  $03
+004ef4 7cf1: 0f                               .dd1  $0f
+004ef5 7cf2: 2d 88                            .dd2  L881E+15
+004ef7 7cf4: ff ff ff ff+                     .fill 12,$ff
+004f03 7d00: 03                               .dd1  $03
+004f04 7d01: 0f                               .dd1  $0f
+004f05 7d02: 5a 88                            .dd2  L884E+12
+004f07 7d04: ff ff ff ff+                     .fill 12,$ff
+004f13 7d10: 03                               .dd1  $03
+004f14 7d11: 0d                               .dd1  $0d
+004f15 7d12: 87 88                            .dd2  L887E+9
+004f17 7d14: ff ff ff ff+                     .fill 12,$ff
+004f23 7d20: 03                               .dd1  $03
+004f24 7d21: 0d                               .dd1  $0d
+004f25 7d22: ae 88                            .dd2  L88AE
+004f27 7d24: ff ff ff ff+                     .fill 12,$ff
+004f33 7d30: 03                               .dd1  $03
+004f34 7d31: 0d                               .dd1  $0d
+004f35 7d32: d5 88                            .dd2  L88CE+7
+004f37 7d34: ff ff ff ff+                     .fill 12,$ff
+004f43 7d40: 03                               .dd1  $03
+004f44 7d41: 0d                               .dd1  $0d
+004f45 7d42: 00 89                            .dd2  L88FE+2
+004f47 7d44: ff ff ff ff+                     .fill 12,$ff
+004f53 7d50: 02                               .dd1  $02
+004f54 7d51: 07                               .dd1  $07
+004f55 7d52: 27 89                            .dd2  L891E+9
+004f57 7d54: ff ff ff ff+                     .fill 12,$ff
+004f63 7d60: 02                               .dd1  $02
+004f64 7d61: 07                               .dd1  $07
+004f65 7d62: 35 89                            .dd2  L892E+7
+004f67 7d64: ff ff ff ff+                     .fill 12,$ff
+004f73 7d70: 02                               .dd1  $02
+004f74 7d71: 0a                               .dd1  $0a
+004f75 7d72: 00 7e                            .dd2  L7E00
+004f77 7d74: ff ff ff ff+                     .fill 12,$ff
+004f83 7d80: 02                               .dd1  $02
+004f84 7d81: 0a                               .dd1  $0a
+004f85 7d82: 14 7e                            .dd2  L7E10+4
+004f87 7d84: ff ff ff ff+                     .fill 12,$ff
+004f93 7d90: 02                               .dd1  $02
+004f94 7d91: 0a                               .dd1  $0a
+004f95 7d92: 28 7e                            .dd2  L7E20+8
+004f97 7d94: ff ff ff ff+                     .fill 12,$ff
+004fa3 7da0: 02                               .dd1  $02
+004fa4 7da1: 0a                               .dd1  $0a
+004fa5 7da2: 3c 7e                            .dd2  L7E30+12
+004fa7 7da4: ff ff ff ff+                     .fill 12,$ff
+004fb3 7db0: 02                               .dd1  $02
+004fb4 7db1: 0a                               .dd1  $0a
+004fb5 7db2: 50 7e                            .dd2  L7E50
+004fb7 7db4: ff ff ff ff+                     .fill 12,$ff
+004fc3 7dc0: 02                               .dd1  $02
+004fc4 7dc1: 0a                               .dd1  $0a
+004fc5 7dc2: 64 7e                            .dd2  L7E60+4
+004fc7 7dc4: ff ff ff ff+                     .fill 12,$ff
+004fd3 7dd0: 02                               .dd1  $02
+004fd4 7dd1: 0a                               .dd1  $0a
+004fd5 7dd2: 78 7e                            .dd2  L7E70+8
+004fd7 7dd4: ff ff ff ff+                     .fill 44,$ff
                           ; other stuff
+005003 7e00: 00 00 18 00+ L7E00               .bulk 0000180008001c001c001c0008001c00
+005013 7e10: 1c 00 00 00+ L7E10               .bulk 1c00000000003c0014001c003e001c00
+005023 7e20: 08 00 1c 00+ L7E20               .bulk 08001c001c00000000000c0008001c00
+005033 7e30: 1c 00 1c 00+ L7E30               .bulk 1c001c0008001c001c00000000001e00
+005043 7e40: 14 00 1c 00+                     .bulk 14001c003e001c0008001c001c000000
+005053 7e50: 00 00 67 00+ L7E50               .bulk 00006700770063006300630077006300
+005063 7e60: 63 00 00 00+ L7E60               .bulk 63000000000073007700630063006300
+005073 7e70: 77 00 63 00+ L7E70               .bulk 7700630063000000000049006b002200
+005083 7e80: 22 00 41 00+                     .bulk 220041007700630063000000d08280d4
+005093 7e90: 8a 80 84 88+                     .bulk 8a80848880c5a880808080ddbb80d5aa
+0050a3 7ea0: 80 dd bb 80+                     .bulk 80ddbb80808080c5a880848880d48a80
+0050b3 7eb0: d0 82 80 55+                     .bulk d08280552a0033330065290049240000
+0050c3 7ec0: 00 00 5d 3b+                     .bulk 00005d3b00552a005d3b000000004924
+0050d3 7ed0: 00 65 29 00+                     .bulk 00652900333300552a00000000000000
+0050e3 7ee0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+0050f3 7ef0: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005103 7f00: 03 05 43 89+                     .bulk 03054389ffffffffffffffffffffffff
+005113 7f10: 03 05 52 89+                     .bulk 03055289ffffffffffffffffffffffff
+005123 7f20: 03 05 61 89+                     .bulk 03056189ffffffffffffffffffffffff
+005133 7f30: 03 05 70 89+                     .bulk 03057089ffffffffffffffffffffffff
+005143 7f40: 03 05 7f 89+                     .bulk 03057f89ffffffffffffffffffffffff
+005153 7f50: 02 0c 8e 89+                     .bulk 020c8e89ffffffffffffffffffffffff
+005163 7f60: 02 0c a6 89+                     .bulk 020ca689ffffffffffffffffffffffff
+005173 7f70: 02 0c be 89+                     .bulk 020cbe89ffffffffffffffffffffffff
+005183 7f80: 02 0c d6 89+                     .bulk 020cd689ffffffffffffffffffffffff
+005193 7f90: 03 0d 8c 7e+                     .bulk 030d8c7effffffffffffffffffffffff
+0051a3 7fa0: 03 0d b3 7e+                     .bulk 030db37effffffffffffffffffffffff
+0051b3 7fb0: ff ff da 7e+                     .bulk ffffda7effffffffffffffffffffffff
+0051c3 7fc0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0051d3 7fd0: ff ff ff ff+                     .bulk ffffffffffffffffffffffffffffffff
+0051e3 7fe0: 08 28 c0 05+                     .bulk 0828c005ffffffffffffffffffffffff
+0051f3 7ff0: 22 2d 00 8a+                     .bulk 222d008affffffffffffffffffffffff

                           ********************************************************************************
                           *                                                                              *
                           * Letters                                                                      *
                           * sorted by ASCII                                                              *
                           *                                                                              *
                           ********************************************************************************
+005203 8000: 00 00 00 00+ Bitmap_SPACE        .bulk 0000000000000000

+00520b 8008: 0c 0c 0c 0c+ Bitmap_BANG         .bulk 0c0c0c0c0c000c0c

+005213 8010: 12 12 00 00+ Bitmap_DQUOTE       .bulk 1212000000000000

+00521b 8018: 14 14 3e 14+ Bitmap_EQUAL        .bulk 14143e143e141400

                           ; $ is (c)
+005223 8020: 3e 41 59 45+ Bitmap_COPYRIGHT    .bulk 3e4159454559413e

+00522b 8028: 26 26 10 08+ Bitmap_PERCENT      .bulk 2626100804323200

+005233 8030: 0c 14 0c 06+ Bitmap_AMP          .bulk 0c140c0615251e04

+00523b 8038: 08 08 00 00+ Bitmap_SQUOTE       .bulk 0808000000000000

+005243 8040: 10 08 0c 0c+ Bitmap_LBRACKET     .bulk 10080c0c0c0c0810

+00524b 8048: 04 08 18 18+ Bitmap_RBRACKET     .bulk 0408181818180804

+005253 8050: 08 2a 1c 7f+ Bitmap_MULT         .bulk 082a1c7f1c2a0800

+00525b 8058: 00 08 08 3e+ Bitmap_PLUS         .bulk 0008083e08080000

+005263 8060: 00 00 00 00+ Bitmap_COMMA        .bulk 000000000018180c

+00526b 8068: 00 00 00 3e+ Bitmap_MINUS        .bulk 0000003e00000000

+005273 8070: 00 00 00 00+ Bitmap_POINT        .bulk 00000000000c0c00

+00527b 8078: 40 20 10 08+ Bitmap_SLASH        .bulk 4020100804020100

+005283 8080: 3e 22 22 32+ Bitmap_0            .bulk 3e22223232323e00

+00528b 8088: 08 08 08 0c+ Bitmap_1            .bulk 0808080c0c0c0c00

+005293 8090: 3c 34 30 3e+ Bitmap_2            .bulk 3c34303e06063e00

+00529b 8098: 3e 30 30 3e+ Bitmap_3            .bulk 3e30303e20203e00

+0052a3 80a0: 06 06 26 26+ Bitmap_4            .bulk 060626263e202000

+0052ab 80a8: 1e 16 06 3e+ Bitmap_5            .bulk 1e16063e30303e00

+0052b3 80b0: 02 02 02 3e+ Bitmap_6            .bulk 0202023e32323e00

+0052bb 80b8: 3e 30 30 10+ Bitmap_7            .bulk 3e30301008080800

+0052c3 80c0: 3e 26 26 3e+ Bitmap_8            .bulk 3e26263e32323e00

+0052cb 80c8: 3e 26 26 3e+ Bitmap_9            .bulk 3e26263e30303000

+0052d3 80d0: 00 0c 0c 00+ Bitmap_COLON        .bulk 000c0c000c0c0000

+0052db 80d8: 00 18 18 00+ Bitmap_SEMICOLON    .bulk 001818000018180c

+0052e3 80e0: 30 18 0c 06+ Bitmap_LT           .bulk 30180c060c183000

+0052eb 80e8: 55 2a 55 00+                     .bulk 552a550000000000

+0052f3 80f0: 06 0c 18 30+ Bitmap_GT           .bulk 060c1830180c0600

+0052fb 80f8: 3e 32 30 3c+ Bitmap_QUESTION     .bulk 3e32303c0c000c0c

+005303 8100: 7f 7f 00 00+                     .bulk 7f7f000000000000

+00530b 8108: 3c 24 24 3e+ Bitmap_A            .bulk 3c24243e26262600

+005313 8110: 1e 16 16 3e+ Bitmap_B            .bulk 1e16163e26263e00

+00531b 8118: 3e 26 06 06+ Bitmap_C            .bulk 3e26060606263e00

+005323 8120: 1e 26 26 26+ Bitmap_D            .bulk 1e26262626261e00

+00532b 8128: 3e 06 06 1e+ Bitmap_E            .bulk 3e06061e06063e00

+005333 8130: 3e 06 06 1e+ Bitmap_F            .bulk 3e06061e06060600

+00533b 8138: 3e 06 06 36+ Bitmap_G            .bulk 3e06063626263e00

+005343 8140: 26 26 26 3e+ Bitmap_H            .bulk 2626263e26262600

+00534b 8148: 1e 0c 0c 0c+ Bitmap_I            .bulk 1e0c0c0c0c0c1e00

+005353 8150: 30 30 30 30+ Bitmap_J            .bulk 3030303030363e00

+00535b 8158: 36 36 16 0e+ Bitmap_K            .bulk 3636160e16363600

+005363 8160: 04 04 04 06+ Bitmap_L            .bulk 0404040606063e00

+00536b 8168: 22 36 2a 22+ Bitmap_M            .bulk 22362a2222222200

+005373 8170: 26 2e 2e 36+ Bitmap_N            .bulk 262e2e3626262600

+00537b 8178: 3e 26 26 26+ Bitmap_O            .bulk 3e26262622223e00

+005383 8180: 3e 26 26 3e+ Bitmap_P            .bulk 3e26263e06060600

+00538b 8188: 3e 22 22 22+ Bitmap_Q            .bulk 3e22222232323e70

+005393 8190: 3e 22 22 3e+ Bitmap_R            .bulk 3e22223e12222200

+00539b 8198: 3e 26 06 3e+ Bitmpa_S            .bulk 3e26063e30323e00

+0053a3 81a0: 3e 08 08 08+ Bitmap_T            .bulk 3e08080808080800

+0053ab 81a8: 26 26 26 26+ Bitmap_U            .bulk 2626262626263e00

+0053b3 81b0: 36 36 36 36+ Bitmap_V            .bulk 36363636141c0800

+0053bb 81b8: 22 22 22 22+ Bitmap_W            .bulk 222222222a362200

+0053c3 81c0: 36 36 14 08+ Bitmap_X            .bulk 3636140814363600

+0053cb 81c8: 36 36 36 14+ Bitmap_Y            .bulk 3636361408080800

+0053d3 81d0: 3e 26 10 08+ Bitmap_Z            .bulk 3e26100804323e00

+0053db 81d8: 1e 06 06 06+ Bitmap_LSBRACKET    .bulk 1e0606060606061e

+0053e3 81e0: 01 02 04 08+ Bitmap_BACKSLASH    .bulk 0102040810204000

+0053eb 81e8: 1e 18 18 18+ Bitmap_RSBRACKET    .bulk 1e18181818181e00

+0053f3 81f0: 08 1c 2a 08+ Bitmap_UPARROW      .bulk 081c2a0808080800

+0053fb 81f8: 7f 00 00 00+                     .bulk 7f00000000000000

                           ********************************************************************************
                           * something else                                                               *
                           ********************************************************************************
+005403 8200: 36 00 14 00+ L8200               .bulk 3600140014001400
+00540b 8208: 5d 00 5d 00+                     .bulk 5d005d003e000800
+005413 8210: 1c 00 1c 00                      .bulk 1c001c00

+005417 8214: 18 00 08 00+ L8214               .bulk 1800080008001c00
+00541f 821c: 1c 00 1c 00+                     .bulk 1c001c001c000800
+005427 8224: 1c 00 1c 00                      .bulk 1c001c00

+00542b 8228: 3c 00 14 00+ L8228               .bulk 3c00140014001c00
+005433 8230: 3e 00 3e 00+                     .bulk 3e003e001c000800
+00543b 8238: 1c 00 1c                         .bulk 1c001c

+00543e 823b: 00 0c 00 08+ L823B               .bulk 000c00080008001c
+005446 8243: 00 1c 00 1c+                     .bulk 001c001c001c0008
+00544e 824b: 00 1c 00 1c+                     .bulk 001c001c00

+005453 8250: 1e 00 14 00+ L8250               .bulk 1e00140014001c00
+00545b 8258: 3e 00 3e 00+                     .bulk 3e003e001c000800
+005463 8260: 1c 00 1c 00                      .bulk 1c001c00

+005467 8264: 06 00 34 00+ L8264               .bulk 0600340014001400
+00546f 826c: 5d 00 5d 00+                     .bulk 5d005d003e000800
+005477 8274: 1c 00 1c 00                      .bulk 1c001c00

+00547b 8278: 30 00 16 00+ L8278               .bulk 3000160014001400
+005483 8280: 5d 00 5d 00+                     .bulk 5d005d003e000800
+00548b 8288: 1c 00 1c 00                      .bulk 1c001c00

                           ; Grunt
                           ; 3 x 13
+00548f 828c: 8f 80 80 8a+ L828C               .bulk 8f80808a9f808a85
+005497 8294: 80 aa 85 80+                     .bulk 80aa8580aa8580a9
+00549f 829c: 89 80 f9 89+                     .bulk 8980f98980ad8b80
+0054a7 82a4: f6 86 80 a0+                     .bulk f68680a08080a881
+0054af 82ac: 80 fc 83 80+                     .bulk 80fc8380a88180

+0054b6 82b3: 80 8f 80 8f+ L82B3               .bulk 808f808f85808a85
+0054be 82bb: 80 aa 85 80+                     .bulk 80aa8580aa8580a9
+0054c6 82c3: 89 80 f9 89+                     .bulk 8980f98980ad8b80
+0054ce 82cb: f6 86 80 a0+                     .bulk f68680a08080a881
+0054d6 82d3: 80 fc 83 80+                     .bulk 80fc8380a88180

+0054dd 82da: 18 00 08 00+ L82DA               .bulk 1800080008001c00
+0054e5 82e2: 1c 00 1f 00+                     .bulk 1c001f001f000e00
+0054ed 82ea: 1e 00 1c 00                      .bulk 1e001c00
                           ; other sprites?
+0054f1 82ee: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005501 82fe: 00 00 3c 00+ L82FE               .bulk 00003c00140014001c003e003f001f00
+005511 830e: 0e 00 1e 00+ L830E               .bulk 0e001e001c000c00080008001c001c00
+005521 831e: 7c 00 7c 00+ L831E               .bulk 7c007c0038003c001c001e0014001400
+005531 832e: 1c 00 3e 00+ L832E               .bulk 1c003e007e007c0038003c001c001410
+005541 833e: 00 02 28 00+                     .bulk 00022800040400080200540a00552a00
+005551 834e: 56 12 00 54+                     .bulk 561200540800140800140a00540a0060
+005561 835e: 01 00 60 01+ L835E               .bulk 0100600100d082804002004000004000
+005571 836e: 00 40 00 00+                     .bulk 00400000540a00552a00521a00440a00
+005581 837e: 04 0a 00 14+                     .bulk 040a00140a00540a00600100600100d0
+005591 838e: 82 80 02 0a+ L838E               .bulk 8280020a00051000080800100400540a
+0055a1 839e: 00 55 2a 00+                     .bulk 00552a00521a00440a00040a00140a00
+0055b1 83ae: 54 0a 00 60+ L83AE               .bulk 540a00600100600100d0828050000040
+0055c1 83be: 00 00 40 00+                     .bulk 0000400000400000540a00552a005612
+0055d1 83ce: 00 54 08 00+                     .bulk 00540800140800140a00540a00600100
+0055e1 83de: 60 01 00 d0+                     .bulk 600100d0828000000000000000000000
+0055f1 83ee: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005601 83fe: 00 00 00 05+ L83FE               .bulk 0000000500000100280100200100573a
+005611 840e: 00 57 3a 00+                     .bulk 00573a00573a00533200533200533200
+005621 841e: 5f 3e 00 60+ L841E               .bulk 5f3e00600100600100d0828028000020
+005631 842e: 00 00 20 05+                     .bulk 0000200500200100573a00573a00573a
+005641 843e: 00 53 32 00+                     .bulk 005332005332005332005f3e00600100
+005651 844e: 60 01 00 d0+ L844E               .bulk 600100d08280d08280948a8084888085
+005661 845e: a8 80 81 a0+                     .bulk a88081a080c1a080d1a280c1a08081a0
+005671 846e: 80 85 a8 80+ L846E               .bulk 8085a880848880948a80d08280808080
+005681 847e: d0 82 80 94+                     .bulk d08280948a8084888085a88081a080c1
+005691 848e: a0 80 81 a0+                     .bulk a08081a08085a880848880948a80d082
+0056a1 849e: 80 80 80 80+ L849E               .bulk 80808080808080808080c08080d08280
+0056b1 84ae: 94 8a 80 84+                     .bulk 948a80848880848880848880948a80d0
+0056c1 84be: 82 80 c0 80+ L84BE               .bulk 8280c080808080808080805e07000801
+0056d1 84ce: 00 28 01 00+                     .bulk 00280100280100230c007e0700230c00
+0056e1 84de: 50 00 00 56+                     .bulk 5000005606002c030058010070000020
+0056f1 84ee: 00 00 08 00+ L84EE               .bulk 00000800080008007f00080008000800
+005701 84fe: 00 00 41 00+ L84FE               .bulk 00004100220014000800140022004100
+005711 850e: 00 14 00 00+ L850E               .bulk 001400000400000400003400000400f0
+005721 851e: 8a 80 dc aa+                     .bulk 8a80dcaa80f7be80d5ab80f7aa80ddbb
+005731 852e: 80 d4 ae 80+ L852E               .bulk 80d4ae80d08b80403200000900000400
+005741 853e: 00 34 00 00+                     .bulk 003400000400a08a80c8aa80a2be8095
+005751 854e: a9 80 a2 aa+ L854E               .bulk a980a2aa80899180d4a4809089800a00
+005761 855e: 00 08 00 00+                     .bulk 000800000800000b0000080000d48380
+005771 856e: d5 8e 80 df+                     .bulk d58e80dfbb80f5aa80d5bb80f7ae80dd
+005781 857e: 8a 80 f4 82+ L857E               .bulk 8a80f482805300002400000800000b00
+005791 858e: 00 08 00 00+                     .bulk 00080000948180d584809f9180a5aa80
+0057a1 859e: 95 91 80 a2+ L859E               .bulk 959180a2a480c98a80a482807e070023
+0057b1 85ae: 0c 00 2e 07+                     .bulk 0c002e07002e07000b0d000b0d000b0d
+0057c1 85be: 00 06 06 00+                     .bulk 000606005c03000c03000c0300780100
+0057d1 85ce: 70 01 00 18+ L85CE               .bulk 7001001803005801005801000c03000c
+0057e1 85de: 03 00 0c 03+                     .bulk 03000c03000c03005801000c03000c03
+0057f1 85ee: 00 78 01 00+                     .bulk 00780100000000000000000000000000
+005801 85fe: 00 00 78 03+ L85FE               .bulk 00007803000c06002c03002c03000c03
+005811 860e: 00 06 06 00+                     .bulk 000606000606000c03005801000c0300
+005821 861e: 0c 03 00 78+ L861E               .bulk 0c03007801007800004c010058010058
+005831 862e: 01 00 0c 03+                     .bulk 01000c03000c03000c03000c03005801
+005841 863e: 00 0c 03 00+ L863E               .bulk 000c03000c03007801007c0100060300
+005851 864e: 2c 03 00 2c+                     .bulk 2c03002c03000c03000606000606000c
+005861 865e: 03 00 58 01+ L865E               .bulk 03005801000c03000c03007801003e00
+005871 866e: 00 63 07 00+                     .bulk 006307002e0c002e07000b0d000b0d00
+005881 867e: 0b 0d 00 06+                     .bulk 0b0d000606005c03000c03000c030078
+005891 868e: 01 00 60 07+ L868E               .bulk 01006007003e0c002307002e07000b0d
+0058a1 869e: 00 0b 0d 00+                     .bulk 000b0d000b0d000606005c03000c0300
+0058b1 86ae: 0c 03 00 78+ L86AE               .bulk 0c0300780100f0fffff5e0fff5faffd5
+0058c1 86be: fa ff d5 fa+                     .bulk faffd5faffd6f6ff86f6ffd2f4ff89f9
+0058d1 86ce: ff df ff ff+                     .bulk ffdfffffd7feff83fcffd7feff000000
+0058e1 86de: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+0058f1 86ee: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005901 86fe: 00 00 ff f0+ L86FE               .bulk 0000fff0fff0fafff5faffd5faffd5fa
+005911 870e: ff d6 f6 ff+                     .bulk ffd6f6ff86f6ffd2f4ff89f9ffdfffff
+005921 871e: d7 fe ff 83+ L871E               .bulk d7feff83fcffd7feff84888085a88081
+005931 872e: a0 80 80 80+                     .bulk a080808080c080809082809082809082
+005941 873e: 80 c0 80 80+                     .bulk 80c0808080808081a08085a880848880
+005951 874e: 67 00 77 00+ L874E               .bulk 67007700770063006300630063007700
+005961 875e: 63 00 63 00+ L875E               .bulk 63006300730077007700630063006300
+005971 876e: 63 00 77 00+ L876E               .bulk 630077006300630049006b006b002200
+005981 877e: 22 00 22 00+ L877E               .bulk 22002200410077006300630067007700
+005991 878e: 77 00 63 00+                     .bulk 77006300630060006000710061006300
+0059a1 879e: 73 00 77 00+ L879E               .bulk 73007700770063006300030003004700
+0059b1 87ae: 43 00 63 00+ L87AE               .bulk 4300630049006b006b00220022002200
+0059c1 87be: 00 00 41 00+ L87BE               .bulk 0000410041006300e48f808280808180
+0059d1 87ce: 80 ce 9f 80+                     .bulk 80ce9f80c08080d48a80848880e48980
+0059e1 87de: f4 8b 80 84+                     .bulk f48b80848880d48a80c08080d0828090
+0059f1 87ee: 82 80 d0 82+                     .bulk 8280d082800000000000000000000000
+005a01 87fe: 00 00 f8 83+ L87FE               .bulk 0000f8838080908081a080be9e80c080
+005a11 880e: 80 d4 8a 80+                     .bulk 80d48a80848880e48980f48b80848880
+005a21 881e: d4 8a 80 c0+ L881E               .bulk d48a80c08080d08280908280d08280fc
+005a31 882e: 8c 80 82 90+                     .bulk 8c8082908080a080fc9980c08080d48a
+005a41 883e: 80 84 88 80+                     .bulk 80848880e48980f48b80848880d48a80
+005a51 884e: c0 80 80 d0+ L884E               .bulk c08080d08280b08380d082809c8f8082
+005a61 885e: 90 80 81 a0+                     .bulk 908081a080f28780c08080d48a808488
+005a71 886e: 80 e4 89 80+                     .bulk 80e48980f48b80848880d48a80c08080
+005a81 887e: d0 82 80 b0+ L887E               .bulk d08280b08380d0828000000000000000
+005a91 888e: 00 00 00 00+                     .bulk 00000000000000006001002001006001
+005aa1 889e: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005ab1 88ae: 00 00 00 00+ L88AE               .bulk 00000000000000000000000050020030
+005ac1 88be: 03 00 50 02+                     .bulk 03005002003003005002000000000000
+005ad1 88ce: 00 00 00 00+ L88CE               .bulk 00000000000000000000000000540a00
+005ae1 88de: 0c 0c 00 14+                     .bulk 0c0c00140b00340900440800240b0034
+005af1 88ee: 0a 00 0c 0c+                     .bulk 0a000c0c00540a000000000000000000
+005b01 88fe: 00 00 55 2a+ L88FE               .bulk 0000552a003333006529004924005332
+005b11 890e: 00 27 39 00+                     .bulk 00273900552a00273900533200492400
+005b21 891e: 65 29 00 33+ L891E               .bulk 652900333300552a0008002a003e005d
+005b31 892e: 00 3e 00 2a+ L892E               .bulk 003e002a000800140008005d0036005d
+005b41 893e: 00 08 00 14+                     .bulk 0008001400776e01522a01522a01532a
+005b51 894e: 01 72 6e 01+                     .bulk 01726e01776e01512a01572a01542a01
+005b61 895e: 77 6e 01 77+                     .bulk 776e01776e01542a01562a01542a0177
+005b71 896e: 6e 01 74 6e+                     .bulk 6e01746e01572a01552a01512a01716e
+005b81 897e: 01 77 6e 01+                     .bulk 01776e01542a01572a01512a01776e01
+005b91 898e: 03 30 63 31+                     .bulk 03306331740b1806700378074c0c4c0c
+005ba1 899e: 78 07 74 0b+                     .bulk 7807740b0330033003102331540b0804
+005bb1 89ae: 70 02 38 07+                     .bulk 700238074c084c0c7006300301300210
+005bc1 89be: 01 10 22 21+                     .bulk 01102221540a180410030804740b4c0c
+005bd1 89ce: 60 06 24 0a+                     .bulk 6006240a011002200210212120021804
+005be1 89de: 10 03 28 02+                     .bulk 10032802040848045004040a00200210
+005bf1 89ee: 00 00 00 00+                     .bulk 00000000000000000000000000000000
+005c01 89fe: 00 00 fc ff+                     .bulk 0000fcff8f8080ff81ffffbf80ffffbf
+005c11 8a0e: 80 ff ff bf+                     .bulk 80ffffbf80ff9ffc878080ffffbfe0bf
+005c21 8a1e: 80 ff 81 80+                     .bulk 80ff8180fcff8f8080ffc1ffc0ffc0ff
+005c31 8a2e: c0 ff c0 ff+                     .bulk c0ffc0ffc0ffc0ff9ffc8780c0ffc0ff
+005c41 8a3e: e0 bf 80 ff+                     .bulk e0bf80ff8180fcff8f8080ffe1bf80ff
+005c51 8a4e: e1 bf 80 ff+                     .bulk e1bf80ffe1bf80ffe1ff9ffc8780e0bf
+005c61 8a5e: 80 ff e1 bf+                     .bulk 80ffe1bf80ff8180fcff8f8080ffe1bf
+005c71 8a6e: 80 ff e1 bf+                     .bulk 80ffe1bf80ffe1bf80ffe1ff9ffc8780
+005c81 8a7e: e0 bf 80 ff+                     .bulk e0bf80ffe1bf80ff8180fcff8f8080ff
+005c91 8a8e: e1 bf 80 ff+                     .bulk e1bf80ffe1bf80ffe1bf80ffe1ff9ffc
+005ca1 8a9e: 87 80 e0 bf+                     .bulk 8780e0bf80ffe1bf80ff8180fcff8f80
+005cb1 8aae: 80 ff e1 bf+                     .bulk 80ffe1bf80ffe1bf80ffe1bf80ffe1ff
+005cc1 8abe: 80 fc 87 80+                     .bulk 80fc8780e0bf80ffe1bf80ff8180fcff
+005cd1 8ace: 8f 80 80 ff+                     .bulk 8f8080ffe1bf80ffe1bf80ffe1bf80ff
+005ce1 8ade: e1 bf 80 fc+                     .bulk e1bf80fc8780e0bf80ffe1bf80ff8180
+005cf1 8aee: fc ff 8f 80+                     .bulk fcff8f8080ffe1bf80ffe1bf80ffe1bf
+005d01 8afe: 80 ff e1 bf+                     .bulk 80ffe1bf80fc8780e0bf80ffe1bf80ff
+005d11 8b0e: 81 80 fc ff+                     .bulk 8180fcff8f8080ffe1bf80ffe1bf80ff
+005d21 8b1e: e1 bf 80 ff+                     .bulk e1bf80ffe1bf80fc8780e0bf80ffe1bf
+005d31 8b2e: 80 ff 81 80+                     .bulk 80ff8180fcff8f8080ffe1bf80ffe1bf
+005d41 8b3e: 80 ff e1 bf+                     .bulk 80ffe1bf80ffe1bf80fc8780e0bf80ff
+005d51 8b4e: e1 bf 80 ff+                     .bulk e1bf80ff8180fcff8f8080ffe1ff83ff
+005d61 8b5e: e1 bf f0 ff+                     .bulk e1bff0ffe1ff83ffe1bf80fc8780e0ff
+005d71 8b6e: 83 ff e1 bf+                     .bulk 83ffe1bf80ff8180fcff8f8080ffe1ff
+005d81 8b7e: 87 ff e1 bf+                     .bulk 87ffe1bff8ffe1ff87ffe1bf80fc8780
+005d91 8b8e: e0 ff 87 ff+                     .bulk e0ff87ffe1bf80ff8180fcff8f8080ff
+005da1 8b9e: e1 ff 87 ff+                     .bulk e1ff87ffe1bff8ffe1ff87ffe1bf80fc
+005db1 8bae: 87 80 e0 ff+                     .bulk 8780e0ff87ffe1bf80ff8180fcff8f80
+005dc1 8bbe: 80 ff e1 ff+                     .bulk 80ffe1ff87ffe1bff8ffe1ff87ffe1bf
+005dd1 8bce: 80 fc 87 80+                     .bulk 80fc8780e0ff87ffe1bf80ff8180fcff
+005de1 8bde: 8f 80 80 ff+                     .bulk 8f8080ffe1ff87ffe1bff8ffe1ff87ff
+005df1 8bee: e1 bf 80 fc+                     .bulk e1bf80fc8780e0ff87ffe1bf80ff8180
+005e01 8bfe: fc ff 8f 80+                     .bulk fcff8f8080ffe1ff87ffe1bff8ffe1ff
+005e11 8c0e: 87 ff e1 bf+                     .bulk 87ffe1bf80fc87ffe1ff87ffe1bf80ff
+005e21 8c1e: 81 80 fc ff+                     .bulk 8180fcff8f8080ffe1ff87ffe1bff8ff
+005e31 8c2e: e1 ff 87 ff+                     .bulk e1ff87ffe1bf80fc87ffe1ff87ffe1bf
+005e41 8c3e: 80 ff 81 80+                     .bulk 80ff8180fcff8f8080ffe1ff87ffe1bf
+005e51 8c4e: f8 ff e1 ff+                     .bulk f8ffe1ff87ffe1bf80fccfffe1ff87ff
+005e61 8c5e: e1 bf 80 ff+                     .bulk e1bf80ff8180fcff8f80c0ffe1ff87ff
+005e71 8c6e: e1 bf f8 ff+                     .bulk e1bff8ffe1ff87ffe1bf80fcffffe1ff
+005e81 8c7e: 87 ff e1 ff+                     .bulk 87ffe1ffc0ff8180fcff9f80e0ffe1ff
+005e91 8c8e: 87 ff e1 bf+                     .bulk 87ffe1bff8ffe1ff87ffe1bf80fcffff
+005ea1 8c9e: e1 ff 87 ff+                     .bulk e1ff87ffe1ffffff8180fcffffffffff
+005eb1 8cae: c0 ff cf ff+                     .bulk c0ffcfffe0fffcffc0ffcfffe0bf80f8
+005ec1 8cbe: ff ff c0 ff+                     .bulk ffffc0ffcfffc0ffffff8180fcffffff
+005ed1 8cce: ff bf 80 ff+                     .bulk ffbf80ffffbfe0ffffbf80ffffbfe0bf
+005ee1 8cde: 80 f0 ff bf+                     .bulk 80f0ffbf80ffffbf80ffffff8080fcff
+005ef1 8cee: ff ff ff 80+                     .bulk ffffff8080808080e0bf808080808080
+005f01 8cfe: e0 bf 80 80+                     .bulk e0bf8080808080808080808080808080
+005f11 8d0e: fc 8f 80 fc+                     .bulk fc8f80fcff8180808080e0bf80808080
+005f21 8d1e: 80 80 e0 bf+                     .bulk 8080e0bf808080808080808080808080
+005f31 8d2e: 80 80 fc 87+                     .bulk 8080fc8780f8ff8380808080e0bf8080
+005f41 8d3e: 80 80 80 80+                     .bulk 80808080e0bf80808080808080808080
+005f51 8d4e: 80 80 80 80+                     .bulk 80808080fc8780f8ff8380808080e0bf
+005f61 8d5e: 80 80 80 80+                     .bulk 808080808080e0bf8080808080808080
+005f71 8d6e: 80 80 80 80+                     .bulk 808080808080fc8780f8ff8380808080
+005f81 8d7e: e0 bf 80 80+                     .bulk e0bf8080808080c0ffffff8080808080
+005f91 8d8e: 80 80 80 80+                     .bulk 8080808080808080fc8780f8ff838080
+005fa1 8d9e: 80 80 e0 bf+                     .bulk 8080e0bf8080808080c0ffffff808080
+005fb1 8dae: 80 80 80 80+                     .bulk 80808080808080808080fc8780f8ff83
+005fc1 8dbe: 80 80 80 80+                     .bulk 80808080e0bf8080808080c0ffffff80
+005fd1 8dce: 80 80 80 80+                     .bulk 808080808080808080808080fc8780f8
+005fe1 8dde: ff 83 80 80+                     .bulk ff8380808080e0bf8080808080c0ffff
+005ff1 8dee: ff 80 80 80+                     .bulk ff80808080808080808080808080fc87
+006001 8dfe: 80 f8 ff 83+                     .bulk 80f8ff8380808080e0bf8080808080c0
+006011 8e0e: ff ff ff 80+                     .bulk ffffff80808080808080808080808080
+006021 8e1e: fc 87 80 f8+                     .bulk fc8780f8ff8380808080e0bf80808080
+006031 8e2e: 80 c0 ff ff+                     .bulk 80c0ffffff8080808080808080808080
+006041 8e3e: 80 80 fc 87+                     .bulk 8080fc8780f8ff8380808080e0bf8080
+006051 8e4e: 80 80 80 80+                     .bulk 80808080e0bf80808080808080808080
+006061 8e5e: 80 80 80 80+                     .bulk 80808080fc8780f8ff8380808080e0bf
+006071 8e6e: 80 80 80 80+                     .bulk 808080808080e0bf8080808080808080
+006081 8e7e: 80 80 80 80+                     .bulk 808080808080fc8780f8ff8380808080
+006091 8e8e: e0 bf 80 80+                     .bulk e0bf808080808080e0bf808080808080
+0060a1 8e9e: 80 80 80 80+                     .bulk 8080808080808080fc8780f8ff838080
+0060b1 8eae: 80 80 e0 bf+                     .bulk 8080e0bf808080808080e0bf80808080
+0060c1 8ebe: 80 80 80 80+                     .bulk 80808080808080808080fc8780f8ff83
+0060d1 8ece: 80 80 80 80+                     .bulk 80808080e0bf808080808080e0bf8080
+0060e1 8ede: 80 80 80 80+                     .bulk 808080808080808080808080fc8780f8
+0060f1 8eee: ff 83 80 80+                     .bulk ff8380808080e0bf808080808080e0bf
+006101 8efe: 80 80 80 80+                     .bulk 8080808080808080808080808080fc87
+006111 8f0e: 80 f8 ff 83+                     .bulk 80f8ff8380808080e0bf808080808080
+006121 8f1e: e0 bf 80 80+                     .bulk e0bf8080808080808080808080808080
+006131 8f2e: fc 87 80 f8+                     .bulk fc8780f8ff8380808080e0bf80808080
+006141 8f3e: 80 80 e0 bf+                     .bulk 8080e0bf808080808080808080808080
+006151 8f4e: 80 80 fc 87+                     .bulk 8080fc8780f8ff8380808080e0bf8080
+006161 8f5e: 80 80 80 80+                     .bulk 80808080e0bf80808080808080808080
+006171 8f6e: 80 80 80 80+                     .bulk 80808080fc8780f8ff8380808080e0bf
+006181 8f7e: 80 80 80 80+                     .bulk 808080808080e0bf8080808080808080
+006191 8f8e: 80 80 80 80+                     .bulk 808080808080fc8f80fcff8380808080
+0061a1 8f9e: c0 9f 80 80+                     .bulk c09f808080808080c09f808080808080
+0061b1 8fae: 80 80 80 80+                     .bulk 8080808080808080f8ffffffff818080
+0061c1 8fbe: 80 80 80 80+                     .bulk 80808080808080808080808080808080
+0061d1 8fce: 80 80 80 80+                     .bulk 80808080808080808080f0ffffffff80
+0061e1 8fde: 80 80 80 80+                     .bulk 80808080808080808080808080808080
+0061f1 8fee: 80 80 80 80+                     .bulk 808080808080808080808080ffffff
