.cpu _65c02

#importonce 

.namespace Storage {

// world x/y 0-7ff,0-bf (2047,192)
spriteX: .byte 0
spriteXHi: .byte 0
spriteY: .byte 0

spriteXDisp: .byte 0
spriteXHiDisp: .byte 0

spriteXRadar: .byte 0
spriteYRadar: .byte 0
oldspriteXRadar: .byte 0
oldspriteYRadar: .byte 0


viewport: .word 0



}
