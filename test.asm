.cpu _65c02
#importonce 
// See ReadMe Notes!
#import "lib/petscii.asm"
#import "lib/constants.asm"
#import "lib/kernal_routines.asm"
#import "lib/macro.asm"
#import "lib\VERA_PSG_Constants.asm"
#import "lib/longBranchMacros.asm"
#import "GameConstants.asm"

#import "ZPStorage.asm"

BasicUpstart2(Start)

Start:{
    backupVeraAddrInfo()

    jsr display.setupDisplay
    jsr display.clearScreen
    jsr display.clearBitmap
    jsr display.drawBitmapFrame

    jsr spriteHandler.initSprites
    lda #$00
    sta Storage.viewport
    lda #$00
    sta Storage.viewport+1

loop:   wai


    jsr spriteHandler.displaySprite
    //set colour 7 - check time routine takes
    // addressRegister(0,$1fa0e,0,0)
    // lda #$00
    // sta VERADATA0
    jsr spriteHandler.displaySpriteOnHUD
    //set colour 7 - check time routine takes
    // addressRegister(0,$1fa0e,0,0)
    // lda #$e7     correct value
    // sta VERADATA0


    jsr Controls.GetJoyStick
    lda ZPStorage.JoyStick
    and #%00001000
    beq !+
    stz tmpDir
!:
    lda ZPStorage.JoyStick
    and #%00000100
    beq !+
    sta tmpDir  //left non zero
!:
    lda tmpDir
    bne movingLeft
    //move view right
    inc Storage.viewport
    bne loop
    lda Storage.viewport+1
    inc
    and #7
    sta Storage.viewport+1
    bra loop
    //move view left
movingLeft:
    lda Storage.viewport
    sec
    sbc #$01
    sta Storage.viewport
    bcs loop

    lda Storage.viewport+1
    dec
    and #7
    sta Storage.viewport+1
    bra loop


}

tmpDir: .byte 0

#import "spriteHandler.asm"
#import "display.asm"
#import "Controls.asm"

SpriteData:{
    //#import "Assets\Sprites.asm"
}



