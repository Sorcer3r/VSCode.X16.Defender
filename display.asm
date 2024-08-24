.cpu _65c02

.namespace display {

setupDisplay:{
    // set 40 chars etc
	setDCSel(0)
	lda #$40			//64 double H,V
	sta VERA_DC_hscale
	sta VERA_DC_vscale
	sta VERA_DC_border	//black
    // layer 1 default $1b000
    // set layer 0 $00000
    // and active
    // Value	Map width / height
    // 0	32 tiles
    // 1	64 tiles
    // 2	128 tiles
    // 3	256 tiles
    // $9F2D	L0_CONFIG	Map Height	Map Width	T256C	Bitmap Mode	Color Depth
    // $9F2E	L0_MAPBASE	Map Base Address (16:9)
    // $9F2F	L0_TILEBASE	Tile Base Address (16:11)	Tile Height	Tile Width
    // Bitmap mode 1/2/4/8 bpp
    // MAP_BASE isn’t used in these modes. TILE_BASE points to the bitmap data.
    // TILEW specifies the bitmap width. 0 = 320 pixels wide. 1 = 640 pixels wide.
    lda #%00000110      // bitmapmode + 4bpp
    sta VERA_L0_config       // $9f2d
    lda #%00000000      // 0=320 pixels (1 = 640)
    sta VERA_L0_tilebase     // $9f2f
	lda VERA_DC_video   // $9f29
    ora #%00010000      // activate layer 0
    sta VERA_DC_video   // $9f29
    addressRegister(0,VRAMPalette +(15*2),1,0)  // colour 15
    stz VERADATA0
    stz VERADATA0   // set colour 15 to black so we can hide bitmap
    rts
}

clearScreen:{
	ldx #30         // 30 lines
	addressRegister(0,VRAM_layer1_map,1,0)
doLine:
	ldy #80		    // 40 char+40 colour
doRow:
    lda #$20        // space
    sta VERADATA0	// fill char with space
    txa             // save x
    cmp #25             // first 6 lines?
    bcs transparent     // yes - set colour to transparent 
    lda #$F0            // background black (colour 15)
    skip2Bytes()
transparent:
    lda #$00            // background colour 0 (transparent)
	sta VERADATA0       // set background colour
	dey
	bne doRow
	stz VERAAddrLow     // reset to first char on line
	inc VERAAddrHigh    // advance to next line
	dex
	bne doLine
	rts
}

clearBitmap:{
	addressRegister(0,VRAM_layer0_map,1,0)
    ldx #48     // 48 lines of bitmap need clearing
line:
	ldy #160		// 160 bytes per line: 320 pixels , 2 pixels /byte
row:
    stz VERADATA0
	dey
	bne row
    dex
	bne line
	rts
}

drawBitmapFrame:{
    lda #$00
    sta pixely
    stz pixelx+1
    lda #$07    //yellow
    sta pixelColour
    ldy #48
vLine:    
    lda #160-65 
    sta pixelx
    jsr plotPixel
    lda #160+65 
    sta pixelx
    jsr plotPixel
    inc pixely
    dey
    bne vLine

    lda #160-64
    sta pixelx
    ldy #129
hLine:    
    lda #0
    sta pixely
    jsr plotPixel
    lda #47
    sta pixely
    jsr plotPixel
    jsr incPixelX
    dey
    bne hLine

    lda #1
    sta pixelColour
    sta ZPStorage.TempByte1
    lda #46
    sta ZPStorage.TempByte2
    ldy #4
vFrame:    
    lda ZPStorage.TempByte1
    sta pixely
    lda #160-8
    sta pixelx
    jsr plotPixel
    lda #160+8
    sta pixelx
    jsr plotPixel
    lda ZPStorage.TempByte2
    sta pixely
    lda #160-8
    sta pixelx
    jsr plotPixel
    lda #160+8
    sta pixelx
    jsr plotPixel
    inc ZPStorage.TempByte1
    dec ZPStorage.TempByte2
    dey
    bne vFrame
    rts
}


plotPixel:{
    addressRegister(0,VRAM_layer0_map,13,0) //step 160
    ldx pixely
    beq calcX
calcY:
    lda VERADATA0
    dex
    bne calcY
calcX:
    lda VERAAddrBank
    and #$0f    // set inc to 0
    sta VERAAddrBank
    lda pixelx+1
    lsr
    lda pixelx
    ror
    clc
    adc VERAAddrLow
    sta VERAAddrLow
    lda VERAAddrHigh
    adc #0
    sta VERAAddrHigh
    ldx VERADATA0
pp:
    lda pixelx
    and #$01
    beq leftPixel
    txa
    eor pixelColour    // set right pixel colour
    bra setPixel
leftPixel:
    lda pixelColour
    asl
    asl
    asl
    asl
    sta leftColour
    txa
    eor leftColour: #$00    //set left pixel colour
setPixel:
    sta VERADATA0
    rts
}
clearPixel:{
    addressRegister(0,VRAM_layer0_map,13,0) //step 160
    ldx pixely
    beq calcX
calcY:
    lda VERADATA0   // read vera to inc addr by 160
    dex
    bne calcY
calcX:
    lda VERAAddrBank
    and #$0f    // set inc to 0
    sta VERAAddrBank
    lda pixelx+1
    lsr
    lda pixelx
    ror
    clc
    adc VERAAddrLow
    sta VERAAddrLow
    lda VERAAddrHigh
    adc #0
    sta VERAAddrHigh
    ldx VERADATA0
    lda pixelx
    and #$01
    beq leftPixel
    txa
    eor pixelColour
    bra setPixel
leftPixel:
    lda pixelColour
    asl
    asl
    asl
    asl
    sta leftColour
    txa
    eor leftColour: #0
setPixel:
    sta VERADATA0
    rts
}

incPixelX:{
    inc pixelx
    bne checkLimit
    inc pixelx+1
checkLimit:
    lda pixelx+1    // check Hi byte
    beq exit        // Hi byte is 0
    lda pixelx      // Hi is 1 so check low
    cmp #64         // are we past 320 (320-256)
    bne exit        // yep >>
    stz pixelx      // no so reset to 0
    stz pixelx+1
exit:
    rts
}

pixelx:      .word 0
pixely:      .byte 0
pixelColour: .byte $05      //green


}