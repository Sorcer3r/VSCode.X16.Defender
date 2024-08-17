.cpu _65c02
#importonce
#import "../lib/macro.asm"
#import "../ZPStorage.asm"

.const scrollingTextLine = 22

titleScreen:{

playTitleScreen:{
    jsr setupCharsInVera
	jsr setDisplay
	jsr clearScreen
	jsr drawPianoKeys
	stz drawTitlePage.titlePageCounter
	lda #<scrollMessage.textToScroll
	sta ZPStorage.TempByte1 //scrollMessage.msgPointer
	lda #>scrollMessage.textToScroll
	sta ZPStorage.TempByte1+1 //scrollMessage.msgPointer+1
	addressRegister(0,VRAM_layer1_map +(scrollingTextLine*256)+80,1,0)
	lda #' '
	sta VERADATA0
	lda #YELLOW
	sta VERADATA0

	//bra part2
	// jsr Music.IRQ_SoundSetup
PlayTitleRepeat:
	jsr Music.IRQ_TitleMusicStart
PlayTitle:
	wai
	jsr drawTitlePage
	jsr scrollMessage
	lda Music.finished
	bne PlayTitleRepeat
	jsr getJoystick
	lda getJoystick.startPressed
	bne PlayTitle
	jsr Music.IRQ_StopAllSound
	rts
}

scrollMessage:{
	lda $9f28 //	VeraScanline_L	
	cmp scrollstartline: #96		// 96 for VGA 96+40 (136) for NTSC
	bne scrollMessage
	lda $9f26
	and #$40
	beq scrollMessage
	lda scrollX
	sta $9f37
	
scrollWaitEnd:	
	lda $9f28 //VeraScanline	
	cmp scrollstopline: #112	// 112 VGA, +40 = 152 NTSC
	bne scrollWaitEnd
	lda $9f26
	and #$40
	beq scrollWaitEnd
	stz $9f37
	inc scrollX
	lda scrollX
	cmp #8
	bne scrollExit
	stz scrollX
	lda (ZPStorage.TempByte1)
	bne copyLineLeft
	lda #<scrollMessage.textToScroll
	sta ZPStorage.TempByte1
	lda #>scrollMessage.textToScroll
	sta ZPStorage.TempByte1+1
copyLineLeft:
	addressRegister(1,VRAM_layer1_map +(scrollingTextLine*256),1,0)
	addressRegister(0,VRAM_layer1_map +(scrollingTextLine*256)+2,1,0)
	ldx #80
copyLoop:
	lda VERADATA0
	sta VERADATA1
	dex
	bne copyLoop	
	lda (ZPStorage.TempByte1)
	sta VERADATA1		//set char 41
	lda #YELLOW
	sta VERADATA1
	inc ZPStorage.TempByte1 //msgPointer
	bne scrollExit
	inc ZPStorage.TempByte1+1  //msgPointer+1
scrollExit:
	rts

scrollX:
	.byte 0
textToScroll:
	.text "OldSkoolCoder is proud to present to you ... Manic Miner! The classic 1983 ZX Spectrum"
	.text " game from 1983 by Matthew Smith. Now available for the Commander X16. Here you will "
	.text "find all the familiar maps you wasted hours of your youth trying to master. "
	.text "An all new multi-colour Miner Willy and enemies thanks to SP175 and the same annoying"
	.text " music that drove you mad back then brought to you by Sorcie. "
	.text "As always, thanks must go to all the dedicated OSK crew for the assistance with "
	.text "pointing out the spelling mistakes, missing inx's and #'s etc. and making OSK's"
	.text " twitch streams such a great place to hang out. One last thing before we start this"
	.text " stupidly long message again.     Visit https://streamlabs.com/oldskoolcoder/merch "
	.text "for all your OSK merchandise at very reasonable prices!                             "
	.byte 0

}


getJoystick:{
    //  SNES | B | Y |SEL    |STA   |UP     |DN    |LT    |RT    |
    //  KBD  | Z | A |L SHIFT|ENTER |CUR UP |CUR DN|CUR LT|CUR RT|z
    // stores zero in location if key pressed, nz if not

    lda #$00    //keyboard joystick
    jsr kernal.joystick_get
    sta kbdJoy1
    stx kbdJoy2
    sty kbdJoy3
    tax
    and #$80
    sta firePressed // zer = key pressed
    txa
    and #$02
    sta leftPressed
    txa 
    and #$01
    sta rightPressed
    txa 
    and #$10
    sta startPressed
    rts
kbdJoy1: .byte 0
kbdJoy2: .byte 0
kbdJoy3: .byte 0
firePressed: .byte 0
leftPressed: .byte 0
rightPressed: .byte 0
startPressed: .byte 0

}
setDisplay:{
// set 40 chars etc
	setDCSel(0)
	lda #$40			//64 double H,V
	sta VERA_DC_hscale
	sta VERA_DC_vscale
	sta VERA_DC_border	//black
	rts

}

clearScreen:{
	ldx #30
	addressRegister(0,VRAM_layer1_map,1,0)
line:
	ldy #80		// 40 char+40colour

row:	
	stz VERADATA0
	stz VERADATA0
	dey
	bne row
	stz VERAAddrLow
	inc VERAAddrHigh
	dex
	bne line
	rts
}

drawPianoKeys:{
	addressRegister(0,VRAM_layer1_map +(17*256)+8,1,0)	// point to row 18,col 4(2perchar)
	ldx #0
	ldy #$01		//black back, white fore
topRow:
	lda pianoTopRow,x
	sta VERADATA0
	sty VERADATA0
	inx
	cpx #32
	bne topRow
	lda #$08			//reset x to col 4
	sta VERAAddrLow	
	inc VERAAddrHigh	//move down a row
	lda #$00 //#$fc				//char 252
	ldx #32
bottomRow:
	sta VERADATA0
	sty VERADATA0
	dex
	bne bottomRow

	lda #$08
	sta VERAAddrLow
	inc VERAAddrHigh
	ldx #32
	ldy #YELLOW << 4
	lda #$20
yellowRow:
	sta VERADATA0
	sty VERADATA0
	dex
	bne yellowRow
	lda #$08
	sta VERAAddrLow
	inc VERAAddrHigh
	ldx #6
	ldy #RED << 4
	lda #$20
redRow:
	sta VERADATA0
	sty VERADATA0
	dex
	bne redRow
	ldx #26
	ldy #GREEN << 4
	lda #$20
greenRow:
	sta VERADATA0
	sty VERADATA0
	dex
	bne greenRow
//          press start to begin

// 	lda #$08
// 	sta VERAAddrLow
// 	inc VERAAddrHigh
// 	inc VERAAddrHigh
// 	ldy #WHITE
// 	ldx #0
// titleText1:
// 	lda text1,x
// 	sta VERADATA0
// 	sty VERADATA0
// 	inx
// 	cpx #32
// 	bne titleText1
// 	lda #$08
// 	sta VERAAddrLow
// 	inc VERAAddrHigh
// 	ldy #WHITE
// 	ldx #0
// titleText2:
// 	lda text2,x
// 	sta VERADATA0
// 	sty VERADATA0
// 	inx
// 	cpx #32
// 	bne titleText2
	rts

//     .encoding "petscii_mixed"
// text1:
// .text "  x16 version by oldskoolcoder  "
// text2:
// .text "original version - matthew smith"

pianoTopRow:{
	.byte 1,3,3,2,1,3,2,1,3,3,2,1,3,2,1,3,2,1,3,3,2,1,3,2,1,3,3,2,1,3,2,0
//	.byte $fd,$ff,$ff,$fe,$fd,$ff,$fe,$fd,$ff,$ff,$fe,$fd,$ff,$fe,$fd,$ff
//	.byte $fe,$fd,$ff,$ff,$fe,$fd,$ff,$fe,$fd,$ff,$ff,$fe,$fd,$ff,$fe,$fc

}
}

drawTitlePage:{
	.const MMrow1 = $b2
	.const MMrow2 = $b9
	lda titlePageCounter
	inc titlePageCounter
	tay
	and #$3f
	bne drawTitlePage_X
	tya
	and #%01000000
	clc
	rol
	rol
	rol
	sta titlePageCycle
	jsr clearRows
	ldx #$00
!titleRow1:
	addressRegister(0,$1b000,1,0)
	lda MMtitleScreen.charY,x
	eor titlePageCycle
	clc
	adc #MMrow1
	sta VERAAddrHigh
	lda MMtitleScreen.charTopRowX,x
	asl
	sta VERAAddrLow
	//lda MMtitleScreen.topRow,x
	txa
	jsr drawBigChar
	inx
	cpx #$05
	bne !titleRow1-
	ldx #$00
!titleRow2:
	addressRegister(0,$1b000,1,0)
	lda MMtitleScreen.charY,x
	eor titlePageCycle
	eor #$01
	clc
	adc #MMrow2
	sta VERAAddrHigh
	lda MMtitleScreen.charBotRowX,x
	asl
	sta VERAAddrLow
	//lda MMtitleScreen.botRow,x
	txa
	clc
	adc #$05
	jsr drawBigChar
	inx
	cpx #$05
	bne !titleRow2-
drawTitlePage_X:
	addressRegister(0,$1c314,1,0)
	ldy #YELLOW << 4
	lda titlePageCounter
	and #$20
	beq clear3
	ldy #YELLOW << 4 | YELLOW
clear3:
	ldx #$0
clearLoop3:
	lda startMessage,x
	sta VERADATA0
	sty VERADATA0
	inx
	cpx #20
	bne clearLoop3
	rts

clearRows:
	addressRegister(0,$1b000,1,0)
	lda #MMrow1
	sta VERAAddrHigh
	ldy #13
clearLoop1:
	ldx #80
clearLoop2:
	stz VERADATA0
	stz VERADATA0
	dex
	bne clearLoop2
	inc VERAAddrHigh
	stz VERAAddrLow
	dey
	bne clearLoop1
	rts

startMessage:
	.text "press start to begin"
	titlePageCounter:
	.byte 0
	titlePageCycle:
	.byte 0
}

drawBigChar:{
	// veraaddr is set to topleft of this char
	// a = char

	phx
	ldy VERAAddrLow
	tax
	lda #$00
	cpx #$00
!drawBig1:
	beq !drawBig2+
	clc
	adc #25
	dex
	bra !drawBig1-
!drawBig2:
	sta bigChar
	ldx #$05
!drawBigRow:
	phx
	ldx #$05
!drawBigCol:
	lda #$20
	sta VERADATA0
	lda bigChar: MMtitleScreen.M_RED
	sta VERADATA0
	inc bigChar
	dex
	bne !drawBigCol-
	sty VERAAddrLow
	inc VERAAddrHigh
	plx
	dex
	bne !drawBigRow-
	plx
	rts
}

setupCharsInVera:{
//	copyDataToVera(Tile0,$00000,32) 
	copyDataToVera(pianoKeys.Tile0,$00,32) 

	//stz VERA_L1_tilebase
	rts
}

MMtitleScreen:{        
    
// M
.align $100
M_RED:
.byte RED << 4,0,0,0,RED << 4
.byte RED << 4,RED << 4,0,RED << 4,RED << 4
.byte RED << 4,0,RED << 4,0,RED << 4
.byte RED << 4,0,0,0,RED << 4
.byte RED << 4,0,0,0,RED << 4

//A
A_YELLOW:
.byte 0,YELLOW << 4,YELLOW << 4,YELLOW << 4,0
.byte YELLOW << 4,0,0,0,YELLOW << 4
.byte YELLOW << 4,0,0,0,YELLOW << 4
.byte YELLOW << 4,YELLOW << 4,YELLOW << 4,YELLOW << 4,YELLOW << 4
.byte YELLOW << 4,0,0,0,YELLOW << 4

//N
N_GREEN:
.byte GREEN << 4,0,0,0,GREEN << 4
.byte GREEN << 4,GREEN << 4,0,0,GREEN << 4
.byte GREEN << 4,0,GREEN << 4,0,GREEN << 4
.byte GREEN << 4,0,0,GREEN << 4,GREEN << 4
.byte GREEN << 4,0,0,0,GREEN << 4

//I
I_LIGHTBLUE:
.byte LIGHT_BLUE << 4,LIGHT_BLUE << 4,LIGHT_BLUE << 4,0,0
.byte 0,LIGHT_BLUE << 4,0,0,0
.byte 0,LIGHT_BLUE << 4,0,0,0
.byte 0,LIGHT_BLUE << 4,0,0,0
.byte LIGHT_BLUE << 4,LIGHT_BLUE << 4,LIGHT_BLUE << 4,0,0

//C
C_PURPLE:
.byte 0,PURPLE << 4,PURPLE << 4,PURPLE << 4,0
.byte PURPLE << 4,0,0,0,PURPLE << 4
.byte PURPLE << 4,0,0,0,0
.byte PURPLE << 4,0,0,0,PURPLE << 4
.byte 0,PURPLE << 4,PURPLE << 4,PURPLE << 4,0

//M
M_LIGHTBLUE:
.byte LIGHT_BLUE << 4,0,0,0,LIGHT_BLUE << 4
.byte LIGHT_BLUE << 4,LIGHT_BLUE << 4,0,LIGHT_BLUE << 4,LIGHT_BLUE << 4
.byte LIGHT_BLUE << 4,0,LIGHT_BLUE << 4,0,LIGHT_BLUE << 4
.byte LIGHT_BLUE << 4,0,0,0,LIGHT_BLUE << 4
.byte LIGHT_BLUE << 4,0,0,0,LIGHT_BLUE << 4

//I
I_PURPLE:
.byte PURPLE << 4,PURPLE << 4,PURPLE << 4,0,0
.byte 0,PURPLE << 4,0,0,0
.byte 0,PURPLE << 4,0,0,0
.byte 0,PURPLE << 4,0,0,0
.byte PURPLE << 4,PURPLE << 4,PURPLE << 4,0,0

//N
N_RED:
.byte RED << 4,0,0,0,RED << 4
.byte RED << 4,RED << 4,0,0,RED << 4
.byte RED << 4,0,RED << 4,0,RED << 4
.byte RED << 4,0,0,RED << 4,RED << 4
.byte RED << 4,0,0,0,RED << 4

//E
E_YELLOW:
.byte YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,YELLOW<< 4
.byte YELLOW<< 4,0,0,0,0
.byte YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,0
.byte YELLOW<< 4,0,0,0,0
.byte YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,YELLOW<< 4,YELLOW<< 4

//R
R_GREEN:
.byte GREEN<< 4,GREEN<< 4,GREEN<< 4,GREEN<< 4,0
.byte GREEN<< 4,0,0,0,GREEN<< 4
.byte GREEN<< 4,GREEN<< 4,GREEN<< 4,GREEN<< 4,0
.byte GREEN<< 4,0,GREEN<< 4,0,0
.byte GREEN<< 4,0,0,GREEN<< 4,GREEN<< 4

charY:
.byte 0,1,0,1,0         // y offset  
.byte 0 //padding
charTopRowX:
.byte 7,13,19,25,29      //top row - MANIC
charBotRowX:
.byte 7,13,17,23,29      //bottom row - MINER

// topRow:
// .byte 0,1,2,3,4
// botRow:
// .byte 5,6,7,8,9
}

pianoKeys:{
Tile0:
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.
.byte $fe          //  XXXXXXX.


// sprite 1, Width : 8, Height : 8, Colour Depth : 2

Tile1:
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...
.byte $f8          //  XXXXX...


// sprite 2, Width : 8, Height : 8, Colour Depth : 2

Tile2:
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.
.byte $3e          //  ..XXXXX.


// sprite 3, Width : 8, Height : 8, Colour Depth : 2

Tile3:
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
.byte $38          //  ..XXX...
}


#import "playTitleMusic.asm"
#import "tuneData.asm"
//#import "pianokeysCharSet.asm"
//#import "titleScreenChars.asm"
}