.cpu _65c02

#importonce 

.namespace Storage {

viewport: .word 0
viewportTarget: .word 0
viewportOffset: .word 0
// move towards target by 1 per frame

player:{
    x:      .byte 0
    xHi:    .byte 0
    y:      .byte 0
    dir:    .byte 0   // 0 = right, nz = left
    thrust: .byte 0  // inc if thrust pressed each frame (max 7?) . x increases by thrust each frame
                    // if no thrust then dec each frame to 0
    dirPressed: .byte 0 // remember key was pressed
    thrustCounter:    .byte 0
// calc viewport target based on x of player, thrust, dir
// going right.  viewport target is x - 50 - (thrust * counter(to 27) , max 191 $bf)
// going left.  viewport target is x-240 + (thrust * counter(to 27) , max 191 $bf))
// counter inc each frame thrust is pressed, max 27 decrese if no thrust
}


.label maxSprites = 64 //128
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

// bunch of random x and y coordinates for the garbage sprites 0-7ff,4-176 
tempStartX: .fill maxSprites,random()*256 //.byte 223,72,56,115,225,6,240,254,0,17,98,26
tempStartXHi: .fill maxSprites,random()*8 //.byte 0,3,4,2,6,5,5,1,0,3,0,2 
tempStartY: .fill maxSprites,random()*172+4 //.byte 12,45,76,5,122,64,101,17,175,86,25,144
}
