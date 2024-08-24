.cpu _65c02
#importonce 


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
    lda #%00000110      // bitmapmode + 4bpp
    sta VERA_L0_config       // $9f2d
    lda #%00000000      // 0=320 pixels (1 = 640)
    sta VERA_L0_tilebase     // $9f2f
	lda VERA_DC_video   // $9f29
    ora #%01010000      // activate layer 0 and sprites
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
    lda #$07    //yellow
    sta pixelColour
    lda #160-65     // mid point - 64 -1
    sta pixelx
    stz pixelx+1
    stz pixely
    ldy #48
    jsr drawVerticalLine

    lda #160+65     // midpoint + 64 + 1
    sta pixelx
    stz pixelx+1
    stz pixely
    ldy #48
    jsr drawVerticalLine

    lda #160-64
    sta pixelx
    stz pixelxHi
    stz pixely
    ldy #129        // 129 pixels
    jsr drawHorizontalLine

    lda #160-64
    sta pixelx
    stz pixelxHi
    lda #47
    sta pixely
    ldy #129        // 129 pixels
    jsr drawHorizontalLine

    lda #1
    sta pixelColour
    stz pixelxHi
    lda #1
    sta pixely
    lda #160-10
    sta pixelx
    ldy #4
    jsr drawVerticalLine
    lda #1
    sta pixely
    lda #160+10
    sta pixelx
    ldy #4
    jsr drawVerticalLine
    lda #43
    sta pixely
    lda #160-10
    sta pixelx
    ldy #4
    jsr drawVerticalLine
    lda #43
    sta pixely
    lda #160+10
    sta pixelx
    ldy #4
    jsr drawVerticalLine
    rts
}

// y = number of pixels
// pixelx, pixel y are start point
// pixelColour = colour to set
drawVerticalLine:{
    // lda #160-65 
    // sta pixelx
    jsr setPixel
    // lda #160+65 
    // sta pixelx
    // jsr plotPixel
    inc pixely
    dey
    bne drawVerticalLine
    rts
}

// y = number of pixels
// pixelx, pixel y are start point
// pixelColour = colour to set
drawHorizontalLine:{    
    // lda #0
    // sta pixely
    jsr setPixel
    // lda #47
    // sta pixely
    // jsr plotPixel
    inc pixelx
    bne !+
    inc pixelx+1
!:
    dey
    bne drawHorizontalLine
    rts
}

// set pixel at Pixelx,pixely to pixelColour
setPixel:{
    setDCSel(0)
    stz VERAAddrBank        // set inc to 0, hi bit of addr to 0
    lda pixely
    asl         // *2
    tax
    lda table160+1,x    // get Y*160 hi
    sta VERAAddrHigh
    lda pixelxHi
    lsr
    lda pixelx
    ror         // div 2
    clc
    adc table160,x
    sta VERAAddrLow
    lda VERAAddrHigh
    adc #0
    sta VERAAddrHigh
    ldx VERADATA0
    lda pixelx
    and #$01
    beq leftPixel
    txa
    and #$f0            // mask off left pixel
    ora pixelColour    // set right pixel colour
    bra setPixel
leftPixel:
    lda pixelColour
    asl
    asl
    asl
    asl
    sta leftColour
    txa
    and #$0f                //  mask off right pixel
    ora leftColour: #$00    //set left pixel colour
setPixel:
    sta VERADATA0
    rts
}

// clear pixel at Pixelx,pixely to colour 0
clearPixel:{
    setDCSel(0)
    stz VERAAddrBank        // set inc to 0, hi bit of addr to 0
    lda pixely
    asl         // *2
    tax
    lda table160+1,x    // get Y*160 hi
    sta VERAAddrHigh
    lda pixelxHi
    lsr
    lda pixelx
    ror         // div 2
    clc
    adc table160,x
    sta VERAAddrLow
    lda VERAAddrHigh
    adc #0
    sta VERAAddrHigh
    ldx VERADATA0
    lda pixelx
    and #$01
    beq leftPixel
    txa
    and #$f0        // clear right pixel
    bra setPixel
leftPixel:
    txa
    and #$0f
setPixel:
    sta VERADATA0
    rts
}

// set/Unset pixel using EOR  
plotPixel:{
    setDCSel(0)
    stz VERAAddrBank        // set inc to 0, hi bit of addr to 0
    lda pixely
    asl         // *2
    tax
    lda table160+1,x    // get Y*160 hi
    sta VERAAddrHigh
    lda pixelxHi
    lsr
    lda pixelx
    ror         // div 2
    clc
    adc table160,x
    sta VERAAddrLow
    lda VERAAddrHigh
    adc #0
    sta VERAAddrHigh
    ldx VERADATA0

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

// pixelx:      .byte 0
// pixelxHi:    .byte 0
// pixely:      .byte 0
// pixelColour: .byte $05      //green

.zp{
.label pixelx = ZPStorage.TempByte1 //      .byte 0
.label pixelxHi= ZPStorage.TempByte2 //:    .byte 0
.label pixely= ZPStorage.TempByte3 //:      .byte 0
.label pixelColour= ZPStorage.TempByte4 //: .byte $05      //green
}

table160:       // low,Hi
.for(var i=0;i<48;i++)
{
    .byte <i*160
    .byte >i*160

}

}
