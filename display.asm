.cpu _65c02
#importonce 
#import "lib\macro.asm"
#import "lib\constants.asm"
#import "ZPStorage.asm"
#import "Storage.asm"

.namespace display {

updateViewport:{
// calc viewport target
// this should be player -50 if going right
// use player -256 if going left (ez mode)
// calc offset from player
// calc step to take  as difference/8
    lda Storage.player.dir
    bne goingLeft
    lda Storage.player.x
    sec
    sbc #50
    sta Storage.viewportTarget
    tax
    lda Storage.player.xHi
    sbc #0
    sta Storage.viewportTarget+1
    tay
    txa
    sec
    sbc Storage.viewport
    sta Storage.viewportOffset
    tax
    tya
    sec
    sbc Storage.viewport+1
    sta Storage.viewportOffset+1
    bne needToMove
    lda Storage.viewportOffset
    beq exit    
needToMove:    
    txa
    lsr
    lsr
    lsr
    lsr
    adc Storage.viewport
    sta Storage.viewport
    lda Storage.viewport+1
    adc #0
    sta Storage.viewport+1
    bra exit

goingLeft:
    lda Storage.player.x
    sec
    sbc #0
    sta Storage.viewportTarget
    tax
    lda Storage.player.xHi
    sbc #1
    sta Storage.viewportTarget+1
    tay
    txa
    sec
    sbc Storage.viewport
    sta Storage.viewportOffset
    tax
    tya
    sec
    sbc Storage.viewport+1
    sta Storage.viewportOffset+1
    bne needToMoveL
    lda Storage.viewportOffset
    beq exit    
needToMoveL:    
    txa
    lsr
    lsr
    lsr
    lsr
    sec
    sbc Storage.viewport
    sta Storage.viewport
    lda Storage.viewport+1
    sbc #0
    sta Storage.viewport+1
//    bra exit
    //break()

exit:
    rts
}

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
    lda #$77    //yellow Note: always put colour in upper and lower nibbles
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

    lda #$11            // always put colour in upper and lower nibbles
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
// pixelColour = colour to set (put in both nibbles - we mask unwanted half)
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
// pixelColour = colour to set (put in both nibbles - we mask unwanted half)
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
    ldx VERADATA0   //get current data from display
    lda pixelx
    and #$01
    beq leftPixel
    lda pixelColour
    and #$0f        // only use right Pixel
    sta thisPixelColour
    txa 
    and #$f0            // mask off left pixel
    bra setPixel
leftPixel:
    lda pixelColour
    and #$f0            //only use left Pixel
    sta thisPixelColour
    txa
    and #$0f                //  mask off right pixel
setPixel:
    ora thisPixelColour
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
    lda pixelColour
    and #$0f        // only use right Pixel
    sta thisPixelColour
    txa
//    eor pixelColour    // set right pixel colour
    bra setPixel
leftPixel:
    lda pixelColour
    and #$f0            //only use left Pixel
    sta thisPixelColour
    txa
//    and #$0f                //  mask off right pixel

    // lda pixelColour
    // asl
    // asl
    // asl
    // asl
    // sta leftColour
    // txa
    // eor leftColour: #$00    //set left pixel colour
setPixel:
    eor thisPixelColour    // set right pixel colour
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
.label pixelx = ZPStorage.TempByte1 
.label pixelxHi= ZPStorage.TempByte2
.label pixely= ZPStorage.TempByte3 
.label pixelColour= ZPStorage.TempByte4  
.label thisPixelColour = ZPStorage.TempByte5    
}

table160:       // low,Hi
.for(var i=0;i<48;i++)
{
    .byte <i*160
    .byte >i*160
}

}
