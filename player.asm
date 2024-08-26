.cpu _65c02
#importonce
#import "Storage.asm"
#import "lib\macro.asm"
#import "lib\constants.asm"
#import "ZPStorage.asm"

.namespace player {
    
initPlayer:{
    lda #50
    sta Storage.player.x
    stz Storage.player.xHi
    lda #90
    sta Storage.player.y
    stz Storage.player.dir  // right
    stz Storage.player.thrust
    stz Storage.player.thrustCounter
    rts    
}

control:{
    jsr player.checkControls
    lda Storage.player.thrust
    beq noThrust
    tax
    lda Storage.player.dir
    beq goingRight
    stx thrustL
    lda Storage.player.x
    sec
    sbc thrustL: #$00
    sta Storage.player.x
    lda Storage.player.xHi
    sbc #0
    bra updatePlayerSprite
goingRight:
    stx thrustR
    lda Storage.player.x
    clc
    adc thrustR: #$00
    sta Storage.player.x
    lda Storage.player.xHi
    adc #0
updatePlayerSprite:    
    and #$07
    sta Storage.player.xHi
noThrust:
    ldx #127
    lda Storage.player.x
    sta Storage.spriteX,x
    lda Storage.player.xHi
    sta Storage.spriteXHi,x
    lda Storage.player.y
    sta Storage.spriteY,x
    rts
}

checkControls:{
    jsr Controls.GetJoyStick
    ldx ZPStorage.JoyStick
    txa
    and #%00000001
    beq testDown
up:
    lda Storage.player.y
    dec
    cmp #$ff
    bne upOk
    lda #0
upOk:
    sta Storage.player.y
testDown:
    txa
    and #%00000010
    beq testDir
    lda Storage.player.y
    inc
    cmp #192
    bne downOk
    lda #191
downOk:
    sta Storage.player.y
testDir:
    txa
    and #%00010000
    beq dirNotPressed           //
    lda Storage.player.dirPressed       // is it held down
    bne testThrust              // yes, dont change dir
    lda Storage.player.dir
    eor #$ff
    sta Storage.player.dir
    stz Storage.player.thrust
    lda #1
dirNotPressed:
    sta Storage.player.dirPressed       // set dirPressed flag
testThrust:
    txa
    and #%00100000              // fire = thrust
    beq thrustNotPressed
    inc Storage.player.thrustCounter
    lda Storage.player.thrustCounter
    cmp #$08
    bne noIncThrust
    stz Storage.player.thrustCounter
    lda Storage.player.thrust
    inc
    cmp #$08
    bne notMaxThrust
    dec
notMaxThrust:
    sta Storage.player.thrust
noIncThrust:
    bra exit
thrustNotPressed:
    dec Storage.player.thrustCounter
    bpl exit
    lda #$07
    sta Storage.player.thrustCounter
    dec Storage.player.thrust
    bpl exit
    stz Storage.player.thrust
exit:
// 0 0 start fire left right down up
//  start thrust fire reverse
    rts
}

}