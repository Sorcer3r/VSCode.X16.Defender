.cpu _65c02
#importonce
#import "Storage.asm"
#import "display.asm"
#import "lib\constants.asm"

.namespace spriteHandler{

initSprites:{
    addressRegister(0,SPRITEREGBASE,1,0)
    ldx #0         // max number of sprites
initLoop:
    lda Storage.tempStartX,x
    sta Storage.spriteX,x
    lda Storage.tempStartXHi,x
    sta Storage.spriteXHi,x
    lda Storage.tempStartY,x
    sta Storage.spriteY,x
    stz Storage.spriteFrame,x   //enabled - frame 0 (not implemented yet)
    lda #$ff
    sta Storage.oldspriteXRadar,x

    stz VERADATA0
    lda #1
    sta VERADATA0
    lda VERADATA0
    lda VERADATA0
    lda VERADATA0
    lda VERADATA0
    stz VERADATA0       // turn off sprite
    //lda #%01010000
    lda #0 //8*8
    sta VERADATA0       // set 16*16
    inx
    cpx #Storage.maxSprites         //sprite limit
    bne initLoop
    rts
}

// calc position of sprite against viewport and display if visible
displaySprite:{
    addressRegister(0,SPRITEREGBASE,1,0)  
    ldy #0      // sprite counter
displaySpriteLoop:
    lda Storage.spriteFrame,y
    cmp #$ff        // disabled
    beq nextSprite    
    lda Storage.spriteX,y
    sec
    sbc Storage.viewport
    sta Storage.spriteXDisp,y
    tax
    lda Storage.spriteXHi,y
    sbc Storage.viewport+1
    and #07
    sta Storage.spriteXHiDisp,y
// now check if >=$7f0 and < $140
    beq isOnScreen
    cmp #$07
    beq checkLeftLimit
    cmp #$01
    bne notOnScreen
    txa
    cmp #$41
    bcc isOnScreen
    bra notOnScreen

checkLeftLimit:
    txa
    cmp #$f0    
    bcc notOnScreen

isOnScreen:
    lda VERADATA0
    lda VERADATA0   // skip first 2 bytes

    lda Storage.spriteXDisp,y
    sta VERADATA0
    lda Storage.spriteXHiDisp,y
    sta VERADATA0
    lda Storage.spriteY,y
    clc
    adc #48     // offset for radar at top
    sta VERADATA0
    stz VERADATA0   // y never >255
    lda #%00001100  // move to foreground
    sta VERADATA0
    lda VERADATA0   // skip last
    bra nextSprite

notOnScreen:
    lda VERAAddrLow
    clc
    adc #$06
    sta VERAAddrLow
    lda #$00
    sta VERADATA0       // set sprite to back
    lda VERADATA0
nextSprite:
    iny
    cpy #Storage.maxSprites
    bne displaySpriteLoop
    rts
}

displaySpriteOnHUD:{
    ldy #0      // sprite counter
    stz display.pixelxHi        // radar max X is 192 so always 0
displayHudLoop:
    lda Storage.spriteFrame
    cmp #$ff
    beq nextHud
    tya
    and #$0f            // this is just to set a diff colour for each draw in bitmap
    sta hudColour       // but need colour in both nibbles
    asl
    asl
    asl
    asl
    ora hudColour: #$ff        // colour in both nibbles 
    sta display.pixelColour
    lda Storage.spriteXHiDisp,y
    sta hudXHi
    lda Storage.spriteXDisp,y
    sta hudX
    lsr hudXHi
    ror hudX
    lsr hudXHi
    ror hudX
    lsr hudXHi
    ror hudX
    lsr hudX
    lda Storage.spriteY,y
    lsr
    lsr
    sta Storage.spriteYRadar,y
    lda hudX
    cmp #72
    bcc !+
    sec
    sbc #128
!:
    clc
    adc #96+56
    sta Storage.spriteXRadar,y
    tax
    lda Storage.oldspriteXRadar,y
    cmp #$ff            // no old position to erase, just draw
    beq noOldPos
    txa
    cmp Storage.oldspriteXRadar,y
    bne moved
    lda Storage.spriteYRadar,y
    cmp Storage.oldspriteYRadar,y
    beq nextHud
moved:
    lda Storage.oldspriteXRadar,y
    sta display.pixelx
    lda Storage.oldspriteYRadar,y
    sta display.pixely    
    jsr display.plotPixel       // turn old pixel off
noOldPos:
    lda Storage.spriteXRadar,y
    sta Storage.oldspriteXRadar,y
    sta display.pixelx
    lda Storage.spriteYRadar,y
    sta Storage.oldspriteYRadar,y
    sta display.pixely    
    jsr display.plotPixel
nextHud:
    iny
    cpy #Storage.maxSprites
    bne displayHudLoop
    rts


.zp{
    .label hudX = ZPStorage.TempByte6
    .label hudXHi = ZPStorage.TempByte7
    .label hudY = ZPStorage.TempByte8
    .label tempX = ZPStorage.TempByte9
    .label tempy = ZPStorage.TempByte10
}

}
}