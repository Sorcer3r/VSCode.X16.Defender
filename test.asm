.cpu _65c02

// See ReadMe Notes!

#importonce 
#import "lib/petscii.asm"
#import "lib/constants.asm"
#import "lib/kernal_routines.asm"

#import "ZPStorage.asm"
#import "GameConstants.asm"
#import "lib/macro.asm"
#import "lib\VERA_PSG_Constants.asm"
#import "lib/longBranchMacros.asm"



BasicUpstart2(Start)

Start:{
    backupVeraAddrInfo()

    jsr display.setupDisplay
    jsr display.clearScreen
    jsr display.clearBitmap
    jsr display.drawBitmapFrame

    lda #24
    sta display.pixely  // line 24
    stz display.pixelx
    stz display.pixelx +1

    lda #5  //green
    sta display.pixelColour
loop:
    jsr display.plotPixel
    wai
    jsr display.plotPixel
    jsr display.incPixelX
    bra loop
break()
}

#import "display.asm"

SpriteData:{
    //#import "Assets\Sprites.asm"
}



