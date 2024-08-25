.cpu _65c02

#importonce 

.namespace Storage {

.label maxSprites = 128
.align $100
// world x/y 0-7ff,0-bf (2047,192) 
//sprite table for maxSprites entries. 12 bytes/sprite
spriteFrame: .fill maxSprites,0 // .byte 0        // $ff = Disable sprite
spriteFrameCounter: .fill maxSprites,0 //.byte 0
spriteX: .fill maxSprites,0 //.byte 0  - world position
spriteXHi: .fill maxSprites,0 //.byte 0 - world position
spriteY: .fill maxSprites,0 //.byte 0 - world position

spriteXDisp: .fill maxSprites,0 //.byte 0
spriteXHiDisp: .fill maxSprites,0 //.byte 0

spriteXRadar: .fill maxSprites,0 //.byte 0
spriteYRadar: .fill maxSprites,0 //.byte 0
oldspriteXRadar: .fill maxSprites,0 //.byte 0
oldspriteYRadar: .fill maxSprites,0 //.byte 0
spriteSpare: .fill maxSprites,0 // 
// --------------------------

viewport: .word 0


tempStartX: .fill maxSprites,random()*256 //.byte 223,72,56,115,225,6,240,254,0,17,98,26
tempStartXHi: .fill maxSprites,random()*8 //.byte 0,3,4,2,6,5,5,1,0,3,0,2 
tempStartY: .fill maxSprites,random()*172+4 //.byte 12,45,76,5,122,64,101,17,175,86,25,144
}
