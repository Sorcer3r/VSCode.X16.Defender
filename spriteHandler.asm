.cpu _65c02
#importonce
#import "Storage.asm"
#import "display.asm"

.namespace spriteHandler{

initSprite:{
    lda #150
    sta Storage.spriteX
    stz Storage.spriteXHi
    lda #96
    sta Storage.spriteY
    addressRegister(0,SPRITEREGBASE,1,0)

    stz VERADATA0
    lda #1
    sta VERADATA0
    lda VERADATA0
    lda VERADATA0
    lda VERADATA0
    lda VERADATA0
    stz VERADATA0       // turn off sprite
    lda #%01010000
    sta VERADATA0       // set 16*16
    rts
}

// calc position of sprite against viewport and display if visible
displaySprite:{
    addressRegister(0,SPRITEREGBASE+2,1,0)  // start at x
    lda Storage.spriteX
    sec
    sbc Storage.viewport
    sta Storage.spriteXDisp
    tax
    lda Storage.spriteXHi
    sbc Storage.viewport+1
    and #07
    sta Storage.spriteXHiDisp
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
    lda Storage.spriteXDisp
    sta VERADATA0
    lda Storage.spriteXHiDisp
    sta VERADATA0
    lda Storage.spriteY
    clc
    adc #48     // offset for radar at top
    sta VERADATA0
    stz VERADATA0   // y never >255
    lda #%00001100  // move to foreground
    sta VERADATA0
    bra exit

notOnScreen:
    lda VERAAddrLow
    clc
    adc #$05
    sta VERAAddrLow
    lda VERADATA0       // bump to next address
    lda #$00
    sta VERADATA0       // set sprite to back
exit:
    rts
}

displaySpriteOnHUD:{
    lda Storage.spriteXHiDisp
    sta hudXHi
    lda Storage.spriteXDisp
    sta hudX
    
    lsr hudXHi
    ror hudX
    lsr hudXHi
    ror hudX
    lsr hudXHi
    ror hudX
    lsr hudX
    lda Storage.spriteY
    lsr
    lsr
    sta Storage.spriteYRadar
    tax
    lda hudX
    cmp #72
    bcc !+
    sec
    sbc #128
!:
    clc
    adc #96+56
    sta Storage.spriteXRadar
    cmp Storage.oldspriteXRadar
    bne moved
    txa
    cmp Storage.oldspriteYRadar
    beq notMoved
moved:
    lda Storage.oldspriteXRadar
    sta display.pixelx
    lda Storage.oldspriteYRadar
    sta display.pixely    
    stz display.pixelxHi
    lda #13  //colour
    sta display.pixelColour
    jsr display.clearPixel       // turn old pixel off
    lda Storage.spriteXRadar
    sta Storage.oldspriteXRadar
    sta display.pixelx
    lda Storage.spriteYRadar
    sta Storage.oldspriteYRadar
    sta display.pixely    
    jsr display.setPixel
notMoved:    
    rts


.zp{
    .label hudX = ZPStorage.TempByte5
    .label hudXHi = ZPStorage.TempByte6
    .label hudY = ZPStorage.TempByte7 
}

}
}