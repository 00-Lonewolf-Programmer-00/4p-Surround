game
.L00 ;  set kernel DPC + 

.L01 ;  const offscreen  =  200

.L02 ;  const font = whimsey

.
 ; 

.L03 ;  dim Clock  =  a

.L04 ;  dim Temp1  =  b

.L05 ;  dim P1Direction  =  c

.L06 ;  dim P2Direction  =  d

.L07 ;  dim P3Direction  =  e

.L08 ;  dim P4Direction  =  f

.L09 ;  dim GameLevel  =  g

.L010 ;  dim P1FireBit0  =  h

.L011 ;  dim P2FireBit1  =  h

.L012 ;  dim P3FireBit2  =  h

.L013 ;  dim P4FireBit3  =  h

.L014 ;  dim MissileDirection  =  i

.L015 ;  dim DragonDirection  =  j

.L016 ;  dim _NUSIZ0  =  k

.L017 ;  dim qtcontroller  =  z

.L018 ;  dim _sc1  =  score

.L019 ;  dim _sc2  =  score + 1

.L020 ;  dim _sc3  =  score + 2

.L021 ;  goto GameInit bank2

 sta temp7
 lda #>(.GameInit-1)
 pha
 lda #<(.GameInit-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #2
 jmp BS_jsr
.
 ; 

.L022 ;  asm

minikernel

    ldx #0

    stx COLUBK

    rts

.
 ; 

.L023 ;  bank 2

 if ECHO1
 echo "    ",[(start_bank1 - *)]d , "bytes of ROM space left in bank 1")
 endif
ECHO1 = 1
 ORG $1FF4-bscode_length
 RORG $1FF4-bscode_length
start_bank1 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $1FFC
 RORG $1FFC
 .word (start_bank1 & $ffff)
 .word (start_bank1 & $ffff)
 ORG $2000
 RORG $3000
HMdiv
  .byte 0, 0, 0, 0, 0, 0, 0
  .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
  .byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3
  .byte 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4
  .byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5
  .byte 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6
  .byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7
  .byte 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8
  .byte 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9
  .byte 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10
  .byte 10,10,10,10,10,10,0,0,0
.
 ; 

.GameInit
 ; GameInit

.
 ; 

.
 ; 

.L024 ;  if !INPT0{7}  &&  INPT1{7} then ____skip_qt_not_detected

	BIT INPT0
	BMI .skipL024
.condpart0
	BIT INPT1
	bmi .____skip_qt_not_detected
 if ( (((((#>*)&$1f)*256)|(#<.____skip_qt_not_detected))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.____skip_qt_not_detected))<=(bankswitch_hotspot+bs_mask)) )
   echo "WARNING: branch near the end of bank 2 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL024
.L025 ;  if !INPT2{7}  &&  INPT3{7} then ____skip_qt_not_detected

	BIT INPT2
	BMI .skipL025
.condpart1
	BIT INPT3
	bmi .____skip_qt_not_detected
 if ( (((((#>*)&$1f)*256)|(#<.____skip_qt_not_detected))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.____skip_qt_not_detected))<=(bankswitch_hotspot+bs_mask)) )
   echo "WARNING: branch near the end of bank 2 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL025
.L026 ;  COLUBK = $40

	LDA #$40
	STA COLUBK
.____skip_qt_not_detected
 ; ____skip_qt_not_detected

.
 ; 

.Start
 ; Start

.
 ; 

.
 ; 

.L027 ;  scorecolors:

	lda #<scoredata
	STA DF0LOW
	lda #((>scoredata) & $0f)
	STA DF0HI
	lda #$66

	sta DF0WRITE
	lda #$6A

	sta DF0WRITE
	lda #$6C

	sta DF0WRITE
	lda #$6F

	sta DF0WRITE
	lda #$6F

	sta DF0WRITE
	lda #$6C

	sta DF0WRITE
	lda #$6A

	sta DF0WRITE
	lda #$66

	sta DF0WRITE
.
 ; 

.L028 ;  pfcolors:

	LDA #<PFCOLS
	STA DF0LOW
	LDA #(>PFCOLS) & $0F
	STA DF0HI
	LDA #<playfieldcolorL028
	STA PARAMETER
	LDA #((>playfieldcolorL028) & $0f) | (((>playfieldcolorL028) / 2) & $70)
	STA PARAMETER
	LDA #0
	STA PARAMETER
	LDA #11
	STA PARAMETER
	LDA #1
	STA CALLFUNCTION
.
 ; 

.L029 ;  player2color:

	lda #<(playerpointers+20)
	sta DF0LOW
	lda #(>(playerpointers+20)) & $0F
	sta DF0HI
	LDX #<playercolorL029_2
	STX DF0WRITE
	LDA #((>playercolorL029_2) & $0f) | (((>playercolorL029_2) / 2) & $70)
	STA DF0WRITE
.
 ; 

.L030 ;  player1color:

	lda #<(playerpointers+18)
	sta DF0LOW
	lda #(>(playerpointers+18)) & $0F
	sta DF0HI
	LDX #<playercolorL030_1
	STX DF0WRITE
	LDA #((>playercolorL030_1) & $0f) | (((>playercolorL030_1) / 2) & $70)
	STA DF0WRITE
.
 ; 

.L031 ;  player3color:

	lda #<(playerpointers+22)
	sta DF0LOW
	lda #(>(playerpointers+22)) & $0F
	sta DF0HI
	LDX #<playercolorL031_3
	STX DF0WRITE
	LDA #((>playercolorL031_3) & $0f) | (((>playercolorL031_3) / 2) & $70)
	STA DF0WRITE
.
 ; 

.L032 ;  player4color:

	lda #<(playerpointers+24)
	sta DF0LOW
	lda #(>(playerpointers+24)) & $0F
	sta DF0HI
	LDX #<playercolorL032_4
	STX DF0WRITE
	LDA #((>playercolorL032_4) & $0f) | (((>playercolorL032_4) / 2) & $70)
	STA DF0WRITE
.
 ; 

.
 ; 

.L033 ;  bkcolors:

	LDA #<BKCOLS
	STA DF0LOW
	LDA #(>BKCOLS) & $0F
	STA DF0HI
	LDA #<backgroundcolorL033
	STA PARAMETER
	LDA #((>backgroundcolorL033) & $0f) | (((>backgroundcolorL033) / 2) & $70)
	STA PARAMETER
	LDA #0
	STA PARAMETER
	LDA #1
	STA PARAMETER
	LDA #1
	STA CALLFUNCTION
.
 ; 

.L034 ;  playfield:

 ldy #22
	LDA #<PF_data1
	LDX #((>PF_data1) & $0f) | (((>PF_data1) / 2) & $70)
 sta temp7
 lda #>(ret_point1-1)
 pha
 lda #<(ret_point1-1)
 pha
 lda #>(pfsetup-1)
 pha
 lda #<(pfsetup-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
ret_point1
.
 ; 

.L035 ;  player1x = 60

	LDA #60
	STA player1x
.L036 ;  player2x = 70

	LDA #70
	STA player2x
.L037 ;  player3x = 80

	LDA #80
	STA player3x
.L038 ;  player4x = 90

	LDA #90
	STA player4x
.L039 ;  player1y = 58

	LDA #58
	STA player1y
.L040 ;  player2y = 75

	LDA #75
	STA player2y
.L041 ;  player3y = 91

	LDA #91
	STA player3y
.L042 ;  player4y = 108

	LDA #108
	STA player4y
.
 ; 

.L043 ;  missile1height  =  16

	LDA #16
	STA missile1height
.L044 ;  player0x  =  70

	LDA #70
	STA player0x
.L045 ;  player0y  =  offscreen

	LDA #offscreen
	STA player0y
.L046 ;  missile1y  =  offscreen

	LDA #offscreen
	STA missile1y
.L047 ;  COLUM1 = $2F

	LDA #$2F
	STA COLUM1
.L048 ;  _NUSIZ1  =  $30  :  NUSIZ2  =  $30  :  NUSIZ3  =  $30  :  NUSIZ4  =  $30

	LDA #$30
	STA _NUSIZ1
	STA NUSIZ2
	STA NUSIZ3
	STA NUSIZ4
.
 ; 

.L049 ;  score = 0

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
.
 ; 

.MainLoop
 ; MainLoop

.L050 ;  DF6FRACINC  =  1

	LDA #1
	STA DF6FRACINC
.L051 ;  DF4FRACINC  =  32

	LDA #32
	STA DF4FRACINC
.
 ; 

.L052 ;  DF0FRACINC  =  32

	LDA #32
	STA DF0FRACINC
.L053 ;  DF1FRACINC  =  32

	LDA #32
	STA DF1FRACINC
.L054 ;  DF2FRACINC  =  32

	LDA #32
	STA DF2FRACINC
.L055 ;  DF3FRACINC  =  32

	LDA #32
	STA DF3FRACINC
.L056 ;  NUSIZ0 = _NUSIZ0

	LDA _NUSIZ0
	STA NUSIZ0
.L057 ;  Clock = Clock + 1

	INC Clock
.L058 ;  gosub SetPlayers

 jsr .SetPlayers

.L059 ;  if missile1y  =  offscreen then gosub CheckFire else gosub MoveMissile

	LDA missile1y
	CMP #offscreen
     BNE .skipL059
.condpart2
 jsr .CheckFire
 jmp .skipelse0
.skipL059
 jsr .MoveMissile

.skipelse0
.L060 ;  if player0y  =  offscreen then gosub GenerateDragon else gosub MoveDragon

	LDA player0y
	CMP #offscreen
     BNE .skipL060
.condpart3
 jsr .GenerateDragon
 jmp .skipelse1
.skipL060
 jsr .MoveDragon

.skipelse1
.L061 ;  if qtcontroller then goto ____skip_controllers_1_2

	LDA qtcontroller
	BEQ .skipL061
.condpart4
 jmp .____skip_controllers_1_2

.skipL061
.
 ; 

.L062 ;  if joy0up then P1Direction  =  0

 lda #$10
 bit SWCHA
	BNE .skipL062
.condpart5
	LDA #0
	STA P1Direction
.skipL062
.L063 ;  if joy0down then P1Direction  =  2

 lda #$20
 bit SWCHA
	BNE .skipL063
.condpart6
	LDA #2
	STA P1Direction
.skipL063
.L064 ;  if joy0left then P1Direction  =  3

 bit SWCHA
	BVS .skipL064
.condpart7
	LDA #3
	STA P1Direction
.skipL064
.L065 ;  if joy0right then P1Direction  =  1

 bit SWCHA
	BMI .skipL065
.condpart8
	LDA #1
	STA P1Direction
.skipL065
.L066 ;  if joy0fire then P1FireBit0{0}  =  1 else P1FireBit0{0}  =  0

 bit INPT4
	BMI .skipL066
.condpart9
	LDA P1FireBit0
	ORA #1
	STA P1FireBit0
 jmp .skipelse2
.skipL066
	LDA P1FireBit0
	AND #254
	STA P1FireBit0
.skipelse2
.L067 ;  if joy1up then P2Direction  =  0

 lda #1
 bit SWCHA
	BNE .skipL067
.condpart10
	LDA #0
	STA P2Direction
.skipL067
.L068 ;  if joy1down then P2Direction  =  2

 lda #2
 bit SWCHA
	BNE .skipL068
.condpart11
	LDA #2
	STA P2Direction
.skipL068
.L069 ;  if joy1left then P2Direction  =  3

 lda #4
 bit SWCHA
	BNE .skipL069
.condpart12
	LDA #3
	STA P2Direction
.skipL069
.L070 ;  if joy1right then P2Direction  =  1

 lda #8
 bit SWCHA
	BNE .skipL070
.condpart13
	LDA #1
	STA P2Direction
.skipL070
.L071 ;  if joy1fire then P2FireBit1{1}  =  1 else P2FireBit1{1}  =  0

 bit INPT5
	BMI .skipL071
.condpart14
	LDA P2FireBit1
	ORA #2
	STA P2FireBit1
 jmp .skipelse3
.skipL071
	LDA P2FireBit1
	AND #253
	STA P2FireBit1
.skipelse3
.L072 ;  qtcontroller  =  1

	LDA #1
	STA qtcontroller
.L073 ;  goto ____skip_controllers_3_4

 jmp .____skip_controllers_3_4

.____skip_controllers_1_2
 ; ____skip_controllers_1_2

.
 ; 

.
 ; 

.L074 ;  if joy0up then P3Direction  =  0

 lda #$10
 bit SWCHA
	BNE .skipL074
.condpart15
	LDA #0
	STA P3Direction
.skipL074
.L075 ;  if joy0down then P3Direction  =  2

 lda #$20
 bit SWCHA
	BNE .skipL075
.condpart16
	LDA #2
	STA P3Direction
.skipL075
.L076 ;  if joy0left then P3Direction  =  3

 bit SWCHA
	BVS .skipL076
.condpart17
	LDA #3
	STA P3Direction
.skipL076
.L077 ;  if joy0right then P3Direction  =  1

 bit SWCHA
	BMI .skipL077
.condpart18
	LDA #1
	STA P3Direction
.skipL077
.L078 ;  if joy0fire then P3FireBit2{2}  =  1 else P3FireBit2{2}  =  0

 bit INPT4
	BMI .skipL078
.condpart19
	LDA P3FireBit2
	ORA #4
	STA P3FireBit2
 jmp .skipelse4
.skipL078
	LDA P3FireBit2
	AND #251
	STA P3FireBit2
.skipelse4
.L079 ;  if joy1up then P4Direction  =  0

 lda #1
 bit SWCHA
	BNE .skipL079
.condpart20
	LDA #0
	STA P4Direction
.skipL079
.L080 ;  if joy1down then P4Direction  =  2

 lda #2
 bit SWCHA
	BNE .skipL080
.condpart21
	LDA #2
	STA P4Direction
.skipL080
.L081 ;  if joy1left then P4Direction  =  3

 lda #4
 bit SWCHA
	BNE .skipL081
.condpart22
	LDA #3
	STA P4Direction
.skipL081
.L082 ;  if joy1right then P4Direction  =  1

 lda #8
 bit SWCHA
	BNE .skipL082
.condpart23
	LDA #1
	STA P4Direction
.skipL082
.L083 ;  if joy1fire then P4FireBit3{3}  =  1 else P4FireBit3{3}  =  0

 bit INPT5
	BMI .skipL083
.condpart24
	LDA P4FireBit3
	ORA #8
	STA P4FireBit3
 jmp .skipelse5
.skipL083
	LDA P4FireBit3
	AND #247
	STA P4FireBit3
.skipelse5
.L084 ;  qtcontroller  =  0

	LDA #0
	STA qtcontroller
.____skip_controllers_3_4
 ; ____skip_controllers_3_4

.
 ; 

.L085 ;  drawscreen

 sta temp7
 lda #>(ret_point2-1)
 pha
 lda #<(ret_point2-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
ret_point2
.L086 ;  if ! ( Clock & 3 )  then AUDC0 = 0 : AUDV0 = 0

; complex statement detected
	LDA Clock
	AND #3
	BNE .skipL086
.condpart25
	LDA #0
	STA AUDC0
	STA AUDV0
.skipL086
.L087 ;  if collision(player0,playfield) then goto GameOver

	bit 	CXP0FB
	BPL .skipL087
.condpart26
 jmp .GameOver

.skipL087
.L088 ;  if collision(player0,missile1) then gosub DragonHit

	bit 	CXM1P
	BPL .skipL088
.condpart27
 jsr .DragonHit

.skipL088
.L089 ;  goto MainLoop

 jmp .MainLoop

.
 ; 

.
 ; 

.SetPlayers
 ; SetPlayers

.L090 ;  on P1Direction goto ____p1_up ____p1_right ____p1_down ____p1_left

	LDX P1Direction
	LDA .L090jumptablehi,x
	PHA
	LDA .L090jumptablelo,x
	PHA
	RTS
.L090jumptablehi
	.byte >(.____p1_up-1)
	.byte >(.____p1_right-1)
	.byte >(.____p1_down-1)
	.byte >(.____p1_left-1)
.L090jumptablelo
	.byte <(.____p1_up-1)
	.byte <(.____p1_right-1)
	.byte <(.____p1_down-1)
	.byte <(.____p1_left-1)
.____p1_up
 ; ____p1_up

.L091 ;  player1:

	lda #<(playerpointers+0)
	sta DF0LOW
	lda #(>(playerpointers+0)) & $0F
	sta DF0HI
	LDX #<playerL091_1
	STX DF0WRITE
	LDA #((>playerL091_1) & $0f) | (((>playerL091_1) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player1height
.L092 ;  goto ____end_p1_direction

 jmp .____end_p1_direction

.____p1_right
 ; ____p1_right

.L093 ;  player1:

	lda #<(playerpointers+0)
	sta DF0LOW
	lda #(>(playerpointers+0)) & $0F
	sta DF0HI
	LDX #<playerL093_1
	STX DF0WRITE
	LDA #((>playerL093_1) & $0f) | (((>playerL093_1) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player1height
.L094 ;  goto ____end_p1_direction

 jmp .____end_p1_direction

.____p1_down
 ; ____p1_down

.L095 ;  player1:

	lda #<(playerpointers+0)
	sta DF0LOW
	lda #(>(playerpointers+0)) & $0F
	sta DF0HI
	LDX #<playerL095_1
	STX DF0WRITE
	LDA #((>playerL095_1) & $0f) | (((>playerL095_1) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player1height
.L096 ;  goto ____end_p1_direction

 jmp .____end_p1_direction

.____p1_left
 ; ____p1_left

.L097 ;  player1:

	lda #<(playerpointers+0)
	sta DF0LOW
	lda #(>(playerpointers+0)) & $0F
	sta DF0HI
	LDX #<playerL097_1
	STX DF0WRITE
	LDA #((>playerL097_1) & $0f) | (((>playerL097_1) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player1height
.____end_p1_direction
 ; ____end_p1_direction

.
 ; 

.L098 ;  on P2Direction goto ____p2_up ____p2_right ____p2_down ____p2_left

	LDX P2Direction
	LDA .L098jumptablehi,x
	PHA
	LDA .L098jumptablelo,x
	PHA
	RTS
.L098jumptablehi
	.byte >(.____p2_up-1)
	.byte >(.____p2_right-1)
	.byte >(.____p2_down-1)
	.byte >(.____p2_left-1)
.L098jumptablelo
	.byte <(.____p2_up-1)
	.byte <(.____p2_right-1)
	.byte <(.____p2_down-1)
	.byte <(.____p2_left-1)
.____p2_up
 ; ____p2_up

.L099 ;  player2:

	lda #<(playerpointers+2)
	sta DF0LOW
	lda #(>(playerpointers+2)) & $0F
	sta DF0HI
	LDX #<playerL099_2
	STX DF0WRITE
	LDA #((>playerL099_2) & $0f) | (((>playerL099_2) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player2height
.L0100 ;  goto ____end_p2_direction

 jmp .____end_p2_direction

.____p2_right
 ; ____p2_right

.L0101 ;  player2:

	lda #<(playerpointers+2)
	sta DF0LOW
	lda #(>(playerpointers+2)) & $0F
	sta DF0HI
	LDX #<playerL0101_2
	STX DF0WRITE
	LDA #((>playerL0101_2) & $0f) | (((>playerL0101_2) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player2height
.L0102 ;  goto ____end_p2_direction

 jmp .____end_p2_direction

.____p2_down
 ; ____p2_down

.L0103 ;  player2:

	lda #<(playerpointers+2)
	sta DF0LOW
	lda #(>(playerpointers+2)) & $0F
	sta DF0HI
	LDX #<playerL0103_2
	STX DF0WRITE
	LDA #((>playerL0103_2) & $0f) | (((>playerL0103_2) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player2height
.L0104 ;  goto ____end_p2_direction

 jmp .____end_p2_direction

.____p2_left
 ; ____p2_left

.L0105 ;  player2:

	lda #<(playerpointers+2)
	sta DF0LOW
	lda #(>(playerpointers+2)) & $0F
	sta DF0HI
	LDX #<playerL0105_2
	STX DF0WRITE
	LDA #((>playerL0105_2) & $0f) | (((>playerL0105_2) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player2height
.____end_p2_direction
 ; ____end_p2_direction

.
 ; 

.L0106 ;  on P3Direction goto ____p3_up ____p3_right ____p3_down ____p3_left

	LDX P3Direction
	LDA .L0106jumptablehi,x
	PHA
	LDA .L0106jumptablelo,x
	PHA
	RTS
.L0106jumptablehi
	.byte >(.____p3_up-1)
	.byte >(.____p3_right-1)
	.byte >(.____p3_down-1)
	.byte >(.____p3_left-1)
.L0106jumptablelo
	.byte <(.____p3_up-1)
	.byte <(.____p3_right-1)
	.byte <(.____p3_down-1)
	.byte <(.____p3_left-1)
.____p3_up
 ; ____p3_up

.L0107 ;  player3:

	lda #<(playerpointers+4)
	sta DF0LOW
	lda #(>(playerpointers+4)) & $0F
	sta DF0HI
	LDX #<playerL0107_3
	STX DF0WRITE
	LDA #((>playerL0107_3) & $0f) | (((>playerL0107_3) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player3height
.L0108 ;  goto ____end_p3_direction

 jmp .____end_p3_direction

.____p3_right
 ; ____p3_right

.L0109 ;  player3:

	lda #<(playerpointers+4)
	sta DF0LOW
	lda #(>(playerpointers+4)) & $0F
	sta DF0HI
	LDX #<playerL0109_3
	STX DF0WRITE
	LDA #((>playerL0109_3) & $0f) | (((>playerL0109_3) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player3height
.L0110 ;  goto ____end_p3_direction

 jmp .____end_p3_direction

.____p3_down
 ; ____p3_down

.L0111 ;  player3:

	lda #<(playerpointers+4)
	sta DF0LOW
	lda #(>(playerpointers+4)) & $0F
	sta DF0HI
	LDX #<playerL0111_3
	STX DF0WRITE
	LDA #((>playerL0111_3) & $0f) | (((>playerL0111_3) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player3height
.L0112 ;  goto ____end_p3_direction

 jmp .____end_p3_direction

.____p3_left
 ; ____p3_left

.L0113 ;  player3:

	lda #<(playerpointers+4)
	sta DF0LOW
	lda #(>(playerpointers+4)) & $0F
	sta DF0HI
	LDX #<playerL0113_3
	STX DF0WRITE
	LDA #((>playerL0113_3) & $0f) | (((>playerL0113_3) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player3height
.____end_p3_direction
 ; ____end_p3_direction

.
 ; 

.L0114 ;  on P4Direction goto ____p4_up ____p4_right ____p4_down ____p4_left

	LDX P4Direction
	LDA .L0114jumptablehi,x
	PHA
	LDA .L0114jumptablelo,x
	PHA
	RTS
.L0114jumptablehi
	.byte >(.____p4_up-1)
	.byte >(.____p4_right-1)
	.byte >(.____p4_down-1)
	.byte >(.____p4_left-1)
.L0114jumptablelo
	.byte <(.____p4_up-1)
	.byte <(.____p4_right-1)
	.byte <(.____p4_down-1)
	.byte <(.____p4_left-1)
.____p4_up
 ; ____p4_up

.L0115 ;  player4:

	lda #<(playerpointers+6)
	sta DF0LOW
	lda #(>(playerpointers+6)) & $0F
	sta DF0HI
	LDX #<playerL0115_4
	STX DF0WRITE
	LDA #((>playerL0115_4) & $0f) | (((>playerL0115_4) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player4height
.L0116 ;  goto ____end_p4_direction

 jmp .____end_p4_direction

.____p4_right
 ; ____p4_right

.L0117 ;  player4:

	lda #<(playerpointers+6)
	sta DF0LOW
	lda #(>(playerpointers+6)) & $0F
	sta DF0HI
	LDX #<playerL0117_4
	STX DF0WRITE
	LDA #((>playerL0117_4) & $0f) | (((>playerL0117_4) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player4height
.L0118 ;  goto ____end_p4_direction

 jmp .____end_p4_direction

.____p4_down
 ; ____p4_down

.L0119 ;  player4:

	lda #<(playerpointers+6)
	sta DF0LOW
	lda #(>(playerpointers+6)) & $0F
	sta DF0HI
	LDX #<playerL0119_4
	STX DF0WRITE
	LDA #((>playerL0119_4) & $0f) | (((>playerL0119_4) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player4height
.L0120 ;  goto ____end_p4_direction

 jmp .____end_p4_direction

.____p4_left
 ; ____p4_left

.L0121 ;  player4:

	lda #<(playerpointers+6)
	sta DF0LOW
	lda #(>(playerpointers+6)) & $0F
	sta DF0HI
	LDX #<playerL0121_4
	STX DF0WRITE
	LDA #((>playerL0121_4) & $0f) | (((>playerL0121_4) / 2) & $70)
	STA DF0WRITE
	LDA #10
	STA player4height
.____end_p4_direction
 ; ____end_p4_direction

.L0122 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.GameOver
 ; GameOver

.L0123 ;  Temp1 = 100

	LDA #100
	STA Temp1
.L0124 ;  qtcontroller = 0

	LDA #0
	STA qtcontroller
.L0125 ;  AUDC0 = 0 : AUDF0 = 0 : AUDV0 = 0

	LDA #0
	STA AUDC0
	STA AUDF0
	STA AUDV0
.L0126 ;  bkcolors:

	LDA #<BKCOLS
	STA DF0LOW
	LDA #(>BKCOLS) & $0F
	STA DF0HI
	LDA #<backgroundcolorL0126
	STA PARAMETER
	LDA #((>backgroundcolorL0126) & $0f) | (((>backgroundcolorL0126) / 2) & $70)
	STA PARAMETER
	LDA #0
	STA PARAMETER
	LDA #1
	STA PARAMETER
	LDA #1
	STA CALLFUNCTION
.GameOverLoop
 ; GameOverLoop

.L0127 ;  DF6FRACINC  =  1

	LDA #1
	STA DF6FRACINC
.L0128 ;  DF4FRACINC  =  32

	LDA #32
	STA DF4FRACINC
.
 ; 

.L0129 ;  DF0FRACINC  =  32

	LDA #32
	STA DF0FRACINC
.L0130 ;  DF1FRACINC  =  32

	LDA #32
	STA DF1FRACINC
.L0131 ;  DF2FRACINC  =  32

	LDA #32
	STA DF2FRACINC
.L0132 ;  DF3FRACINC  =  32

	LDA #32
	STA DF3FRACINC
.L0133 ;  NUSIZ0  =  _NUSIZ0

	LDA _NUSIZ0
	STA NUSIZ0
.L0134 ;  if Temp1 then Temp1 = Temp1 - 1

	LDA Temp1
	BEQ .skipL0134
.condpart28
	DEC Temp1
.skipL0134
.L0135 ;  if Temp1 then ____skip_reset

	LDA Temp1
	bne .____skip_reset
 if ( (((((#>*)&$1f)*256)|(#<.____skip_reset))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.____skip_reset))<=(bankswitch_hotspot+bs_mask)) )
   echo "WARNING: branch near the end of bank 2 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.L0136 ;  if !switchreset  &&  !joy0fire then goto ____skip_reset

 lda #1
 bit SWCHB
	BEQ .skipL0136
.condpart29
 bit INPT4
	BPL .skip29then
.condpart30
 jmp .____skip_reset

.skip29then
.skipL0136
.L0137 ;  for temp5  =  0 to 25

	LDA #0
	STA temp5
.L0137fortemp5
.L0138 ;  a[temp5]  =  0

	LDA #0
	LDX temp5
	STA a,x
.L0139 ;  next

	LDA temp5
	CMP #25

	INC temp5
	bcc .L0137fortemp5
 if ( (((((#>*)&$1f)*256)|(#<.L0137fortemp5))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.L0137fortemp5))<=(bankswitch_hotspot+bs_mask)) )
   echo "WARNING: branch near the end of bank 2 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.L0140 ;  goto Start

 jmp .Start

.____skip_reset
 ; ____skip_reset

.L0141 ;  Clock  =  Clock  +  1

	INC Clock
.L0142 ;  drawscreen

 sta temp7
 lda #>(ret_point3-1)
 pha
 lda #<(ret_point3-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
ret_point3
.L0143 ;  goto GameOverLoop

 jmp .GameOverLoop

.
 ; 

.
 ; 

.DragonHit
 ; DragonHit

.L0144 ;  player0y  =  offscreen

	LDA #offscreen
	STA player0y
.L0145 ;  if _sc3 = $49 then GameLevel = 1

	LDA _sc3
	CMP #$49
     BNE .skipL0145
.condpart31
	LDA #1
	STA GameLevel
.skipL0145
.L0146 ;  if _sc3 = $99 then GameLevel = 2

	LDA _sc3
	CMP #$99
     BNE .skipL0146
.condpart32
	LDA #2
	STA GameLevel
.skipL0146
.L0147 ;  score  =  score  +  1

	SED
	CLC
	LDA score+2
	ADC #$01
	STA score+2
	LDA score+1
	ADC #$00
	STA score+1
	LDA score
	ADC #$00
	STA score
	CLD
.
 ; 

.L0148 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.CheckFire
 ; CheckFire

.L0149 ;  if !P1FireBit0{0} then return

	LDA P1FireBit0
	LSR
	BCS .skipL0149
.condpart33
	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.skipL0149
.L0150 ;  if P2FireBit1{1}  &&  P3FireBit2{2}  &&  P4FireBit3{3} then goto ____skip_bad_fire

	LDA P2FireBit1
	AND #2
	BEQ .skipL0150
.condpart34
	LDA P3FireBit2
	AND #4
	BEQ .skip34then
.condpart35
	LDA P4FireBit3
	AND #8
	BEQ .skip35then
.condpart36
 jmp .____skip_bad_fire

.skip35then
.skip34then
.skipL0150
.L0151 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.____skip_bad_fire
 ; ____skip_bad_fire

.L0152 ;  if P1Direction  =  P2Direction  &&  P2Direction  =  P3Direction  &&  P3Direction  =  P4Direction then goto ____skip_bad_shot

	LDA P1Direction
	CMP P2Direction
     BNE .skipL0152
.condpart37
	LDA P2Direction
	CMP P3Direction
     BNE .skip37then
.condpart38
	LDA P3Direction
	CMP P4Direction
     BNE .skip38then
.condpart39
 jmp .____skip_bad_shot

.skip38then
.skip37then
.skipL0152
.L0153 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.____skip_bad_shot
 ; ____skip_bad_shot

.L0154 ;  missile1x  =  missile_x_start[P1Direction]

	LDX P1Direction
	LDA missile_x_start,x
	STA missile1x
.L0155 ;  missile1y  =  missile_y_start[P1Direction]

	LDX P1Direction
	LDA missile_y_start,x
	STA missile1y
.L0156 ;  MissileDirection  =  P1Direction

	LDA P1Direction
	STA MissileDirection
.L0157 ;  AUDC0 = 3

	LDA #3
	STA AUDC0
.L0158 ;  AUDF0 = 1

	LDA #1
	STA AUDF0
.L0159 ;  AUDV0 = 8

	LDA #8
	STA AUDV0
.L0160 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.MoveMissile
 ; MoveMissile

.L0161 ;  if missile1y  >  7  &&  missile1y  <  160  &&  missile1x  >  7  &&  missile1x  <  152 then ____skip_missile_offscreen

	LDA #7
	CMP missile1y
     BCS .skipL0161
.condpart40
	LDA missile1y
	CMP #160
     BCS .skip40then
.condpart41
	LDA #7
	CMP missile1x
     BCS .skip41then
.condpart42
	LDA missile1x
	CMP #152
	bcc .____skip_missile_offscreen
 if ( (((((#>*)&$1f)*256)|(#<.____skip_missile_offscreen))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.____skip_missile_offscreen))<=(bankswitch_hotspot+bs_mask)) )
   echo "WARNING: branch near the end of bank 2 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skip41then
.skip40then
.skipL0161
.L0162 ;  missile1y  =  offscreen

	LDA #offscreen
	STA missile1y
.L0163 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.____skip_missile_offscreen
 ; ____skip_missile_offscreen

.L0164 ;  on MissileDirection goto ____shoot_up ____shoot_right ____shoot_down ____shoot_left

	LDX MissileDirection
	LDA .L0164jumptablehi,x
	PHA
	LDA .L0164jumptablelo,x
	PHA
	RTS
.L0164jumptablehi
	.byte >(.____shoot_up-1)
	.byte >(.____shoot_right-1)
	.byte >(.____shoot_down-1)
	.byte >(.____shoot_left-1)
.L0164jumptablelo
	.byte <(.____shoot_up-1)
	.byte <(.____shoot_right-1)
	.byte <(.____shoot_down-1)
	.byte <(.____shoot_left-1)
.____shoot_up
 ; ____shoot_up

.L0165 ;  missile1y  =  missile1y  -  8

	LDA missile1y
	SEC
	SBC #8
	STA missile1y
.L0166 ;  goto ____done_shoot

 jmp .____done_shoot

.____shoot_right
 ; ____shoot_right

.L0167 ;  missile1x  =  missile1x  +  8

	LDA missile1x
	CLC
	ADC #8
	STA missile1x
.L0168 ;  goto ____done_shoot

 jmp .____done_shoot

.____shoot_down
 ; ____shoot_down

.L0169 ;  missile1y  =  missile1y  +  8

	LDA missile1y
	CLC
	ADC #8
	STA missile1y
.L0170 ;  goto ____done_shoot

 jmp .____done_shoot

.____shoot_left
 ; ____shoot_left

.L0171 ;  missile1x  =  missile1x  -  8

	LDA missile1x
	SEC
	SBC #8
	STA missile1x
.____done_shoot
 ; ____done_shoot

.L0172 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.MoveDragon
 ; MoveDragon

.L0173 ;  on DragonDirection goto ____move_dragon_down ____move_dragon_left ____move_dragon_up ____move_dragon_right

	LDX DragonDirection
	LDA .L0173jumptablehi,x
	PHA
	LDA .L0173jumptablelo,x
	PHA
	RTS
.L0173jumptablehi
	.byte >(.____move_dragon_down-1)
	.byte >(.____move_dragon_left-1)
	.byte >(.____move_dragon_up-1)
	.byte >(.____move_dragon_right-1)
.L0173jumptablelo
	.byte <(.____move_dragon_down-1)
	.byte <(.____move_dragon_left-1)
	.byte <(.____move_dragon_up-1)
	.byte <(.____move_dragon_right-1)
.____move_dragon_down
 ; ____move_dragon_down

.L0174 ;  if GameLevel = 0  &&  Clock{0} then player0y  =  player0y  +  1

	LDA GameLevel
	CMP #0
     BNE .skipL0174
.condpart43
	LDA Clock
	LSR
	BCC .skip43then
.condpart44
	INC player0y
.skip43then
.skipL0174
.L0175 ;  if GameLevel = 1 then player0y  =  player0y  +  1

	LDA GameLevel
	CMP #1
     BNE .skipL0175
.condpart45
	INC player0y
.skipL0175
.L0176 ;  if GameLevel = 2 then player0y  =  player0y  +  2

	LDA GameLevel
	CMP #2
     BNE .skipL0176
.condpart46
	LDA player0y
	CLC
	ADC #2
	STA player0y
.skipL0176
.L0177 ;  goto ____done_move_dragon

 jmp .____done_move_dragon

.____move_dragon_left
 ; ____move_dragon_left

.L0178 ;  if GameLevel = 0  &&  Clock{0} then player0x  =  player0x  -  1

	LDA GameLevel
	CMP #0
     BNE .skipL0178
.condpart47
	LDA Clock
	LSR
	BCC .skip47then
.condpart48
	DEC player0x
.skip47then
.skipL0178
.L0179 ;  if GameLevel = 1 then player0x  =  player0x  -  1

	LDA GameLevel
	CMP #1
     BNE .skipL0179
.condpart49
	DEC player0x
.skipL0179
.L0180 ;  if GameLevel = 2 then player0x  =  player0x  -  2

	LDA GameLevel
	CMP #2
     BNE .skipL0180
.condpart50
	LDA player0x
	SEC
	SBC #2
	STA player0x
.skipL0180
.L0181 ;  goto ____done_move_dragon

 jmp .____done_move_dragon

.____move_dragon_up
 ; ____move_dragon_up

.L0182 ;  if GameLevel = 0  &&  Clock{0} then player0y  =  player0y  -  1

	LDA GameLevel
	CMP #0
     BNE .skipL0182
.condpart51
	LDA Clock
	LSR
	BCC .skip51then
.condpart52
	DEC player0y
.skip51then
.skipL0182
.L0183 ;  if GameLevel = 1 then player0y  =  player0y  -  1

	LDA GameLevel
	CMP #1
     BNE .skipL0183
.condpart53
	DEC player0y
.skipL0183
.L0184 ;  if GameLevel = 2 then player0y  =  player0y  -  2

	LDA GameLevel
	CMP #2
     BNE .skipL0184
.condpart54
	LDA player0y
	SEC
	SBC #2
	STA player0y
.skipL0184
.L0185 ;  goto ____done_move_dragon

 jmp .____done_move_dragon

.____move_dragon_right
 ; ____move_dragon_right

.L0186 ;  if GameLevel = 0  &&  Clock{0} then player0x  =  player0x  +  1

	LDA GameLevel
	CMP #0
     BNE .skipL0186
.condpart55
	LDA Clock
	LSR
	BCC .skip55then
.condpart56
	INC player0x
.skip55then
.skipL0186
.L0187 ;  if GameLevel = 1 then player0x  =  player0x  +  1

	LDA GameLevel
	CMP #1
     BNE .skipL0187
.condpart57
	INC player0x
.skipL0187
.L0188 ;  if GameLevel = 2 then player0x  =  player0x  +  2

	LDA GameLevel
	CMP #2
     BNE .skipL0188
.condpart58
	LDA player0x
	CLC
	ADC #2
	STA player0x
.skipL0188
.____done_move_dragon
 ; ____done_move_dragon

.L0189 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.GenerateDragon
 ; GenerateDragon

.L0190 ;  DragonDirection  =   ( rand & 3 ) 

; complex statement detected
        lda rand
	AND #3
	STA DragonDirection
.L0191 ;  if DragonDirection  =  1  ||  DragonDirection  =  3 then goto ____skip_small_dragon

	LDA DragonDirection
	CMP #1
     BNE .skipL0191
.condpart59
 jmp .condpart60
.skipL0191
	LDA DragonDirection
	CMP #3
     BNE .skip14OR
.condpart60
 jmp .____skip_small_dragon

.skip14OR
.
 ; 

.L0192 ;  player0:

	LDX #<playerL0192_0
	STX player0pointerlo
	LDA #((>playerL0192_0) & $0f) | (((>playerL0192_0) / 2) & $70)
	STA player0pointerhi
	LDA #20
	STA player0height
.
 ; 

.L0193 ;  on GameLevel goto ____yellow_dragon ____green_dragon ____red_dragon

	LDX GameLevel
	LDA .L0193jumptablehi,x
	PHA
	LDA .L0193jumptablelo,x
	PHA
	RTS
.L0193jumptablehi
	.byte >(.____yellow_dragon-1)
	.byte >(.____green_dragon-1)
	.byte >(.____red_dragon-1)
.L0193jumptablelo
	.byte <(.____yellow_dragon-1)
	.byte <(.____green_dragon-1)
	.byte <(.____red_dragon-1)
.____yellow_dragon
 ; ____yellow_dragon

.L0194 ;  player0color:

	LDX #<playercolorL0194_0
	STX player0color
	LDA #((>playercolorL0194_0) & $0f) | (((>playercolorL0194_0) / 2) & $70)
	STA player0color+1
.L0195 ;  goto ____end_s_dragon_color

 jmp .____end_s_dragon_color

.____green_dragon
 ; ____green_dragon

.L0196 ;  player0color:

	LDX #<playercolorL0196_0
	STX player0color
	LDA #((>playercolorL0196_0) & $0f) | (((>playercolorL0196_0) / 2) & $70)
	STA player0color+1
.L0197 ;  goto ____end_s_dragon_color

 jmp .____end_s_dragon_color

.____red_dragon
 ; ____red_dragon

.L0198 ;  player0color:

	LDX #<playercolorL0198_0
	STX player0color
	LDA #((>playercolorL0198_0) & $0f) | (((>playercolorL0198_0) / 2) & $70)
	STA player0color+1
.____end_s_dragon_color
 ; ____end_s_dragon_color

.L0199 ;  _NUSIZ0 = $00

	LDA #$00
	STA _NUSIZ0
.
 ; 

.L0200 ;  goto ____done_dragon_size

 jmp .____done_dragon_size

.____skip_small_dragon
 ; ____skip_small_dragon

.L0201 ;  player0:

	LDX #<playerL0201_0
	STX player0pointerlo
	LDA #((>playerL0201_0) & $0f) | (((>playerL0201_0) / 2) & $70)
	STA player0pointerhi
	LDA #40
	STA player0height
.
 ; 

.L0202 ;  on GameLevel goto ____byellow_dragon ____bgreen_dragon ____bred_dragon

	LDX GameLevel
	LDA .L0202jumptablehi,x
	PHA
	LDA .L0202jumptablelo,x
	PHA
	RTS
.L0202jumptablehi
	.byte >(.____byellow_dragon-1)
	.byte >(.____bgreen_dragon-1)
	.byte >(.____bred_dragon-1)
.L0202jumptablelo
	.byte <(.____byellow_dragon-1)
	.byte <(.____bgreen_dragon-1)
	.byte <(.____bred_dragon-1)
.____byellow_dragon
 ; ____byellow_dragon

.L0203 ;  player0color:

	LDX #<playercolorL0203_0
	STX player0color
	LDA #((>playercolorL0203_0) & $0f) | (((>playercolorL0203_0) / 2) & $70)
	STA player0color+1
.L0204 ;  goto ____end_big_dragon_color

 jmp .____end_big_dragon_color

.____bgreen_dragon
 ; ____bgreen_dragon

.L0205 ;  player0color:

	LDX #<playercolorL0205_0
	STX player0color
	LDA #((>playercolorL0205_0) & $0f) | (((>playercolorL0205_0) / 2) & $70)
	STA player0color+1
.L0206 ;  goto ____end_big_dragon_color

 jmp .____end_big_dragon_color

.____bred_dragon
 ; ____bred_dragon

.L0207 ;  player0color:

	LDX #<playercolorL0207_0
	STX player0color
	LDA #((>playercolorL0207_0) & $0f) | (((>playercolorL0207_0) / 2) & $70)
	STA player0color+1
.____end_big_dragon_color
 ; ____end_big_dragon_color

.L0208 ;  _NUSIZ0 = $05

	LDA #$05
	STA _NUSIZ0
.____done_dragon_size
 ; ____done_dragon_size

.
 ; 

.L0209 ;  player0x = dragon_x_start[DragonDirection]

	LDX DragonDirection
	LDA dragon_x_start,x
	STA player0x
.L0210 ;  player0y = dragon_y_start[DragonDirection]

	LDX DragonDirection
	LDA dragon_y_start,x
	STA player0y
.
 ; 

.L0211 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.L0212 ;  data quadtari_detection

	JMP .skipL0212
quadtari_detection
	.byte 	$1B, $1F, $0B, $0E, $1E, $0B, $1C, $13

.skipL0212
.
 ; 

.
 ; 

.L0213 ;  data dragon_y_start

	JMP .skipL0213
dragon_y_start
	.byte     0

	.byte     68

	.byte     156

	.byte     68

.skipL0213
.
 ; 

.L0214 ;  data dragon_x_start

	JMP .skipL0214
dragon_x_start
	.byte     76

	.byte     143

	.byte     76

	.byte     0

.skipL0214
.
 ; 

.
 ; 

.L0215 ;  data missile_y_start

	JMP .skipL0215
missile_y_start
	.byte     40

	.byte     80

	.byte     121

	.byte     80

.skipL0215
.
 ; 

.L0216 ;  data missile_x_start

	JMP .skipL0216
missile_x_start
	.byte     76

	.byte     101

	.byte     76

	.byte     53

.skipL0216
.
 ; 

.
 ; 

.
 ; 

.L0217 ;  bank 3

 if ECHO2
 echo "    ",[(start_bank2 - *)]d , "bytes of ROM space left in bank 2")
 endif
ECHO2 = 1
 ORG $2FF4-bscode_length
 RORG $3FF4-bscode_length
start_bank2 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $2FFC
 RORG $3FFC
 .word (start_bank2 & $ffff)
 .word (start_bank2 & $ffff)
 ORG $3000
 RORG $5000
 repeat 129
 .byte 0
 repend
.
 ; 

.L0218 ;  bank 4

 if ECHO3
 echo "    ",[(start_bank3 - *)]d , "bytes of ROM space left in bank 3")
 endif
ECHO3 = 1
 ORG $3FF4-bscode_length
 RORG $5FF4-bscode_length
start_bank3 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $3FFC
 RORG $5FFC
 .word (start_bank3 & $ffff)
 .word (start_bank3 & $ffff)
 ORG $4000
 RORG $7000
 repeat 129
 .byte 0
 repend
.
 ; 

.L0219 ;  bank 5

 if ECHO4
 echo "    ",[(start_bank4 - *)]d , "bytes of ROM space left in bank 4")
 endif
ECHO4 = 1
 ORG $4FF4-bscode_length
 RORG $7FF4-bscode_length
start_bank4 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $4FFC
 RORG $7FFC
 .word (start_bank4 & $ffff)
 .word (start_bank4 & $ffff)
 ORG $5000
 RORG $9000
 repeat 129
 .byte 0
 repend
.
 ; 

.L0220 ;  bank 6

 if ECHO5
 echo "    ",[(start_bank5 - *)]d , "bytes of ROM space left in bank 5")
 endif
ECHO5 = 1
 ORG $5FF4-bscode_length
 RORG $9FF4-bscode_length
start_bank5 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $5FFC
 RORG $9FFC
 .word (start_bank5 & $ffff)
 .word (start_bank5 & $ffff)
 ORG $6000
 RORG $B000
 repeat 129
 .byte 0
 repend
.
 ; 

 if ECHO6
 echo "    ",[(start_bank6 - *)]d , "bytes of ROM space left in bank 6")
 endif
ECHO6 = 1
 ORG $6FF4-bscode_length
 RORG $BFF4-bscode_length
start_bank6 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $6FFC
 RORG $BFFC
 .word (start_bank6 & $ffff)
 .word (start_bank6 & $ffff)
 ORG $7000
 RORG $D000
 repeat 129
 .byte 0
 repend
; bB.asm file is split here
playfieldcolorL028
	.byte  $EA
	.byte  $EA
	.byte  $EA
	.byte  $20
	.byte  $20
	.byte  $20
	.byte  $20
	.byte  $20
	.byte  $EA
	.byte  $EA
	.byte  $EA
playercolorL029_2
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
	.byte         $4F
playercolorL030_1
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
	.byte         $9F
playercolorL031_3
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
	.byte         $3F
playercolorL032_4
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
	.byte         $CF
backgroundcolorL033
	.byte  $F0
PF_data1
	.byte %00000000
	.byte %01010000
	.byte %11111000
	.byte %11111000
	.byte %01010000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00010100
	.byte %00111110
	.byte %00111110
	.byte %00011100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01110000
	.byte %11111000
	.byte %11111000
	.byte %01010000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00010100
	.byte %00111110
	.byte %00111110
	.byte %00010100
	.byte %00000000
playerL091_1
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
playerL093_1
	.byte         %00000100
	.byte         %00000100
	.byte         %00001010
	.byte         %00001010
	.byte         %11111110
	.byte         %11111110
	.byte         %00001010
	.byte         %00001010
	.byte         %00000100
	.byte         %00000100
playerL095_1
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
playerL097_1
	.byte         %00100000
	.byte         %00100000
	.byte         %01010000
	.byte         %01010000
	.byte         %01111111
	.byte         %01111111
	.byte         %01010000
	.byte         %01010000
	.byte         %00100000
	.byte         %00100000
playerL099_2
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
playerL0101_2
	.byte         %00000100
	.byte         %00000100
	.byte         %00001010
	.byte         %00001010
	.byte         %11111110
	.byte         %11111110
	.byte         %00001010
	.byte         %00001010
	.byte         %00000100
	.byte         %00000100
playerL0103_2
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
playerL0105_2
	.byte         %00100000
	.byte         %00100000
	.byte         %01010000
	.byte         %01010000
	.byte         %01111111
	.byte         %01111111
	.byte         %01010000
	.byte         %01010000
	.byte         %00100000
	.byte         %00100000
playerL0107_3
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
playerL0109_3
	.byte         %00000100
	.byte         %00000100
	.byte         %00001010
	.byte         %00001010
	.byte         %11111110
	.byte         %11111110
	.byte         %00001010
	.byte         %00001010
	.byte         %00000100
	.byte         %00000100
playerL0111_3
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
playerL0113_3
	.byte         %00100000
	.byte         %00100000
	.byte         %01010000
	.byte         %01010000
	.byte         %01111111
	.byte         %01111111
	.byte         %01010000
	.byte         %01010000
	.byte         %00100000
	.byte         %00100000
playerL0115_4
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
playerL0117_4
	.byte         %00000100
	.byte         %00000100
	.byte         %00001010
	.byte         %00001010
	.byte         %11111110
	.byte         %11111110
	.byte         %00001010
	.byte         %00001010
	.byte         %00000100
	.byte         %00000100
playerL0119_4
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00010000
	.byte         %00111000
	.byte         %01010100
	.byte         %01010100
	.byte         %00111000
playerL0121_4
	.byte         %00100000
	.byte         %00100000
	.byte         %01010000
	.byte         %01010000
	.byte         %01111111
	.byte         %01111111
	.byte         %01010000
	.byte         %01010000
	.byte         %00100000
	.byte         %00100000
backgroundcolorL0126
	.byte  $02
playerL0192_0
	.byte         $06
	.byte         $0f
	.byte         $f3
	.byte         $fe
	.byte         $0e
	.byte         $04
	.byte         $04
	.byte         $1e
	.byte         $3f
	.byte         $7f
	.byte         $e3
	.byte         $c3
	.byte         $c3
	.byte         $c7
	.byte         $ff
	.byte         $3c
	.byte         $08
	.byte         $8f
	.byte         $e1
	.byte         $3f
playercolorL0194_0
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $1A
	.byte         $1A
	.byte         $1A
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1A
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
playercolorL0196_0
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $CA
	.byte         $CA
	.byte         $CA
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CA
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
playercolorL0198_0
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $4A
	.byte         $4A
	.byte         $4A
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4A
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
playerL0201_0
	.byte         $06
	.byte         $06
	.byte         $0f
	.byte         $0f
	.byte         $f3
	.byte         $f3
	.byte         $fe
	.byte         $fe
	.byte         $0e
	.byte         $0e
	.byte         $04
	.byte         $04
	.byte         $04
	.byte         $04
	.byte         $1e
	.byte         $1e
	.byte         $3f
	.byte         $3f
	.byte         $7f
	.byte         $7f
	.byte         $e3
	.byte         $e3
	.byte         $c3
	.byte         $c3
	.byte         $c3
	.byte         $c3
	.byte         $c7
	.byte         $c7
	.byte         $ff
	.byte         $ff
	.byte         $3c
	.byte         $3c
	.byte         $08
	.byte         $08
	.byte         $8f
	.byte         $8f
	.byte         $e1
	.byte         $e1
	.byte         $3f
	.byte         $3f
playercolorL0203_0
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $1A
	.byte         $1A
	.byte         $1A
	.byte         $1A
	.byte         $1A
	.byte         $1A
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1C
	.byte         $1A
	.byte         $1A
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
	.byte         $18
playercolorL0205_0
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $CA
	.byte         $CA
	.byte         $CA
	.byte         $CA
	.byte         $CA
	.byte         $CA
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CC
	.byte         $CA
	.byte         $CA
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
	.byte         $C8
playercolorL0207_0
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $4A
	.byte         $4A
	.byte         $4A
	.byte         $4A
	.byte         $4A
	.byte         $4A
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4C
	.byte         $4A
	.byte         $4A
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
	.byte         $48
 if ECHOFIRST
       echo "    ",[(DPC_graphics_end - *)]d , "bytes of ROM space left in graphics bank")
 endif 
ECHOFIRST = 1
 
 
 
