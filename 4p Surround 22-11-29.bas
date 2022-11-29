
 temp1 = temp1
 set kernel DPC+
 set tv ntsc
 set smartbranching on



 goto init bank2

 bank 2
 temp1 = temp1
init

 bkcolors:
 $00
end

; Detect quadtari hardware, and turn the background red if not detected.
	if !INPT0{7} && INPT1{7} then quadtariDetected ; left side
	if !INPT2{7} && INPT3{7} then quadtariDetected ; right side

 bkcolors:
 $40
end
quadtariDetected

 const scorepointers=player1x
 rem *** The selected game number. The game selection minikernel displays 
 rem *** this variable
 dim gamenumber=y
 gamenumber=1

 rem *** this debounce variable is used to slow down the game number selection
 dim swdebounce=b
 swdebounce=0

 rem *** this turns on the score fading effect. it looks especially pretty
 rem *** if you do a "scorecolor=scorecolor+1" every 2nd or 4th frame.
 const scorefade=1
 scorecolor=$1a

titleLoop
/*
 gosub titledrawscreen bank3
 if joy0fire || switchreset then goto gamestart

 if !switchselect then swdebounce=0
 if swdebounce>0  then swdebounce=swdebounce-1: goto titleLoop
 if switchselect then swdebounce=30: gamenumber=gamenumber+1
 if gamenumber=21 then gamenumber=1
 goto titleLoop
*/
gamestart

  player0:
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
end

  player0color:
  $7a
  $7a
  $7a
  $7a
  $7a
  $7a
  $7a
  $7a
end

  player1-2:
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
  %11110000
end

  player1color:
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
end



 playfield: 
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 pfcolors:
 $3a
end

/*
 playfield: 
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 pfcolors:
 $3a
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $3a
end
*/
 bkcolors:
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $00
 $90
 $90
 $90
 $90
 $90
 $90
 $90
 $90
end




 player0x = 24 ;16 + 4
 player0y = 16

 player1x = 132
 player1y = 16

 ;player2x = 24
 ;player2y = 152

 ballx = 25
 bally = 152
 ballheight = 8
 CTRLPF = $21

 missile0x = 133 ;nusiz one off
 missile0y = 152
 missile0height = 8
 ;NUSIZ0
 COLUM0 = $7a
 

/*
 missile1y = 0
 missile1height = 200
 _NUSIZ1 = $20
 COLUM1 = $00
*/

 dim pfX = temp3
 dim pfY = temp4
 dim tempX = temp5
 dim tempY = temp6
 ;dim overlap = temp7

 const objectHeightMinusOne = 7
 const objectWidthMinusOne = 3

 def pfPixelHeight=8
 def pfPixelWidth=4

 const pfOffset = 16

 const tileHeightMask = %00000111
 const tileWidthMask = %00000011

 const tileHeight = 8
 const tileWidth = 4





 ;def __top = tempY / 8
 ;def __bottom = (tempY + objectHeightMinusOne) / 8
 ;def __left = (tempX - pfOffset) / 4
 ;def __right = ((tempX - pfOffset) + objectWidthMinusOne) / 4

 DF6FRACINC = 255 ;bgcols
 DF4FRACINC = 0 ;pfcols
 DF0FRACINC = 32 : DF1FRACINC = 32 : DF2FRACINC = 32 : DF3FRACINC = 32 ;pf

 NUSIZ0 = $20
 drawscreen 

 dim directionP1 = a
 directionP1 = 0

 dim directionP2 = b
 directionP2 = 0

 dim directionP3 = c
 directionP3 = 0

 dim directionP4 = d
 directionP4 = 0


 def gameOver=e{0}
 gameOver = 0
 
 def resetRestrainer=e{1}
 resetRestrainer = 0

 def flip=e{2}
 flip = 0

 def p1Collision=f{1}
 def p2Collision=f{2}
 def p3Collision=f{3}
 def p4Collision=f{4}
 f = 0

 dim previusXPos = g
 dim previusYPos = h



 dim moveDelay = i
 moveDelay = 0

 dim delayInc = j
 delayInc = 1

 dim moveCounter = k
 moveCounter = 0


 ;directionP1 = 4
 ;tempY = player0y : tempX = player0x : gosub collisionCheck

 directionP2 = 3
 ;tempY = player1y : tempX = player1x : gosub collisionCheck

 ;directionP3 = 4
 ;tempY = bally : tempX = ballx : gosub collisionCheck
 
 ;directionP4 = 3
 ;tempY = missile0y : tempX = missile0x : gosub collisionCheck


 dim qtcontroller = z
main


 ;pixel aspect ratio is 12:7 (1.714)
 ;take whatever speed you're using in the Y, and divide it by 1.714, and use that for your X
 ;or take X and multiply by 1.714 for same Y speed

 if qtcontroller then goto skipControllers_1_2

 ;joy1
 if !joy0up then skipUp1
 directionP1 = 1
skipUp1

 if !joy0down then skipDown1
 directionP1 = 2
skipDown1

 if !joy0left then skipLeft1
 directionP1 = 3
skipLeft1

 if !joy0right then skipRight1
 directionP1 = 4
skipRight1

 ;joy2
 if !joy1up then skipUp2
 directionP2 = 1
skipUp2

 if !joy1down then skipDown2
 directionP2 = 2
skipDown2

 if !joy1left then skipLeft2
 directionP2 = 3
skipLeft2

 if !joy1right then skipRight2
 directionP2 = 4
skipRight2

 qtcontroller = 1 ; Check controllers 3 and 4 next frame
 goto skipControllers_3_4
skipControllers_1_2

 ;joy3
 if !joy0up then skipUp3
 directionP3 = 1
skipUp3

 if !joy0down then skipDown3
 directionP3 = 2
skipDown3

 if !joy0left then skipLeft3
 directionP3 = 3
skipLeft3

 if !joy0right then skipRight3
 directionP3 = 4
skipRight3

 ;joy4
 if !joy1up then skipUp4
 directionP4 = 1
skipUp4

 if !joy1down then skipDown4
 directionP4 = 2
skipDown4

 if !joy1left then skipLeft4
 directionP4 = 3
skipLeft4

 if !joy1right then skipRight4
 directionP4 = 4
skipRight4

 qtcontroller = 0 ; Check controllers 1 and 2 next frame
skipControllers_3_4



 moveDelay = moveDelay + delayInc


 if moveDelay < 40 then skipMove

 moveCounter = moveCounter + 1
 if moveCounter = 16 && delayInc < 4 then delayInc = delayInc + 1 : moveCounter = 0
/*
 previusYPos = player0y : previusXPos = player0x
 if directionP1 = 1 then player0y = player0y - 8
 if directionP1 = 2 then player0y = player0y + 8
 if directionP1 = 3 then player0x = player0x - 4
 if directionP1 = 4 then player0x = player0x + 4
 tempY = player0y : tempX = player0x : gosub collisionCheck
 if temp1 = 1 then p1Collision = 1
*/
 previusYPos = player1y : previusXPos = player1x
 if directionP2 = 1 then player1y = player1y - 8
 if directionP2 = 2 then player1y = player1y + 8
 if directionP2 = 3 then player1x = player1x - 4
 if directionP2 = 4 then player1x = player1x + 4
 tempY = player1y : tempX = player1x : gosub collisionCheck
 if temp1 = 1 then p2Collision = 1
/*
 previusYPos = bally : previusXPos = ballx
 if directionP3 = 1 then bally = bally - 8
 if directionP3 = 2 then bally = bally + 8
 if directionP3 = 3 then ballx = ballx - 4
 if directionP3 = 4 then ballx = ballx + 4
 tempY = bally : tempX = ballx : gosub collisionCheck
 if temp1 = 1 then p3Collision = 1

 previusYPos = missile0y : previusXPos = missile0x
 if directionP4 = 1 then missile0y = missile0y - 8
 if directionP4 = 2 then missile0y = missile0y + 8
 if directionP4 = 3 then missile0x = missile0x - 4
 if directionP4 = 4 then missile0x = missile0x + 4
 tempY = missile0y : tempX = missile0x : gosub collisionCheck
 if temp1 = 1 then p4Collision = 1
*/
 if f then gameOver = 1

 AUDC0 = 1
 AUDV0 = 10
 AUDF0 = 10 - delayInc

 moveDelay = 0
skipMove
 



loop
 DF6FRACINC = 255 ;bgcols
 DF4FRACINC = 0 ;pfcols
 DF0FRACINC = 32 : DF1FRACINC = 32 : DF2FRACINC = 32 : DF3FRACINC = 32 ;pf

 NUSIZ0 = $20
 drawscreen 
 AUDV0 = 0

 flip = !flip

 ;ball = missile0
 ;missile0= player1
 ;player1 = ball
 if flip then goto skipEven
 tempX = ballx
 tempY = bally

 ballx = missile0x
 bally = missile0y
 missile0x = player1x + 1
 missile0y = player1y
 player1x = tempX - 1
 player1y = tempY

  player1color:
  $cc
  $cc
  $cc
  $cc
  $cc
  $cc
  $cc
  $cc
end

 missile1x = 13

 goto skipOdd

 ;player1 = missile0
 ;missile0 = ball
 ;ball = player1
skipEven
 tempX = player1x
 tempY = player1y

 player1x = missile0x - 1
 player1y = missile0y
 missile0x = ballx
 missile0y = bally 
 ballx = tempX + 1
 bally = tempY

  player1color:
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
  $ac
end

 missile1x = 145 ;nusiz one off
skipOdd


/*
 tempX = missile0x
 tempY = missile0y
 missile0x = ballx
 missile0y = bally
 ballx = tempX
 bally = tempY

*/

 ;if switchreset then resetRestrainer = 1
 ;if !switchreset && resetRestrainer then goto init

 if switchreset then resetRestrainer = 1 else if resetRestrainer then goto init


 if gameOver then loop
 goto main



collisionCheck

 temp1 = 0

 pfY = tempY / 8
 pfX = (tempX - pfOffset) / 4
 if pfread(pfX, pfY) then temp1 = 1
 gosub pfPixelOn
 return thisbank





pfPixelOn
 pfY = previusYPos / 8
 pfX = (previusXPos- pfOffset) / 4
 pfpixel pfX pfY on

 return thisbank

; Data string for Stella to detect the quadtari
	data quadtari_detection
	$1B, $1F, $0B, $0E, $1E, $0B, $1C, $13
end


   bank 3
   temp1=temp1

 asm
 ;include "titlescreen/asm/titlescreen.asm"
end
 

   bank 4
   temp1=temp1

   bank 5
   temp1=temp1

   bank 6
   temp1=temp1

   bank 7
   temp1=temp1