.cpu _65c02
#importonce 

#import "../lib/constants.asm"
#import "../lib/petscii.asm"
#import "../lib/macro.asm"

// *=$0801
// 	BasicUpstart2(main)
// main: {
// 	jsr setDisplay
// 	jsr clearScreen
// 	jsr setupCharsInVera
// 	jsr drawPianoKeys
// 	//bra part2
// 	jsr Music.IRQ_TitleMusicSetup

// PlayTitle:
// 	lda Music.finished
// 	beq PlayTitle
// 	jsr Music.Restore_INT
// part2:
// 	jsr Music.IRQ_GameMusicSetup
	
// playGameMusic:
// 	bra playGameMusic		//forever	
// 	rts
// }

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
	//lda #0				//char 0 
	ldx #32
bottomRow:
	stz VERADATA0
	sty VERADATA0
	dex
	bne bottomRow	
	rts

pianoTopRow:{
	.byte 1,3,3,2,1,3,2,1,3,3,2,1,3,2,1,3,2,1,3,3,2,1,3,2,1,3,3,2,1,3,2,0
}
}

setupCharsInVera:{
	copyDataToVera(Tile0,$00000,32) 
	stz VERA_L1_tilebase
	rts
}
#import "playTitleMusic.asm"
#import "tuneData.asm"
#import "pianokeysCharSet.asm"