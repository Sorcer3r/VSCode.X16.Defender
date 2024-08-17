.cpu _65c02

#define CollisionDEBUG
#define MusicON

#importonce 
#import "lib/petscii.asm"
#import "lib/constants.asm"
#import "lib/VERA_PSG_Constants.asm"
#import "lib/kernal_routines.asm"

#import "ZPStorage.asm"
#import "GameContants.asm"

BasicUpstart2(Start)

.const SCREENHI_OFFSET = $B0
.const SpriteMemoryAddr = $10000
.const CharMapAddr = $0000
.const DefaultCharMapAddr = $F800
.const fontCharLowerAddr = CharMapAddr + (worldSwitchLeft2 * CharY)
.const fontCharUpperAddr = CharMapAddr + (UpperFontStart * CharY)
.const fontBackCharAddr = CharMapAddr + ((UpperFontStart + 31) * CharY)

Start:
    backupVeraAddrInfo()

    // note: if output is interlaced then scrolling message will look odd
    // because we cannot scroll both the odd and even fields at the same time!
    // to overcome this we will force 240P output on NTSC.
    // I have no idea how smooth scroll would even be possible on interlaced video. 
    ldx #96             // default start and end lines for scrolling message VGA
    ldy #112    
    lda VERA_DC_video
    and #%00000011
    cmp #%00000001      // test if we are in VGA mode
    beq !VGA+
    lda VERA_DC_video
    ora #%00001000      // turn on 240P or it will look horrendous. (comment out to see!)
    sta VERA_DC_video   
    ldx #136            // line start and end for scrolling message NTSC
    ldy #154
!VGA:
    stx titleScreen.scrollMessage.scrollstartline
    sty titleScreen.scrollMessage.scrollstopline
    
    lda #gameStateStartUp
    sta Storage.m_gameState

GameLoop:
    jsr Logic.Execute

    wai
    jmp GameLoop

#import "lib/macro.asm"
#import "lib/longBranchMacros.asm"
#import "Controls.asm"
#import "MinerWilly.asm"
#import "gameRender.asm"
#import "InGameMusic/playTitleMusic.asm"
#import "gameUtils.asm"
#import "gameLogic.asm"

*=$3000 "Sprite Data"
SpriteData:
{
//#import "Assets/Sprites.asm"
//#import "Assets/Enemies.asm"
//#import "Assets/Doors.asm"
#import "Assets\compsprites.asm"
}
_SpriteData:

*=* "Char Data"
FontLowerData:{
#import "Assets/lowerCharMap.asm"
}
_FontLowerData:

FontUpperData:{
#import "Assets/upperCharMap.asm"
}
_FontUpperData:

FontBackData:{
#import "Assets/backCharMap.asm"
}
_FontBackData:

* = * "Game Data"
#import "gameData.asm"

* = * "Title Screen"
#import "InGameMusic/titleScreen.asm"