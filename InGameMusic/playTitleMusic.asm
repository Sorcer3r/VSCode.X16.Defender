.cpu _65c02
#importonce 
#import "tuneData.asm"
#import "../lib/macro.asm"
#import "notePositions.asm"
#import "../Storage.asm"

.const pianoKeyRow2 = VRAM_layer1_map +(18*256)

// Callable Routines
// Music.IRQ_SoundSetup        - configure interrupt for sound routines 
// Music.Restore_INT           - restore interrupt to system default   
// Music.IRQ_TitleMusicStart   - Starts title music tune playing
// Music.IRQ_StopAllSound      - Stops all sound playing
// Music.IRQ_GameSoundEnable   - enable in-game sound mode
// Music.IRQ_GameMusicStart    - start playing the annoying in-game tune
// Music.IRQ_GameMusicStop     - stop playing the annoying in-game tune

// VERA PSG register
// $1:F9C0-$1:F9FF	    - 16 x 4 bytes/sound channel
// voice1 1f9c0-1f9c3
// voice2 1f9c4-1f9c7
// voice3 1f9c8-1f9cb
// voice4 1f9cc-1f9cf

// each PSG is 4 bytes
//0	Frequency word (7:0)
//1	Frequency word (15:8)
//2	Right(7) Left(6)	Volume(5-0) 
//3	Waveform(7-6)	    Pulse width(5-0)

// vol max is 63 %00111111
// waveform =
// 0	Pulse       %00
// 1	Sawtooth    %01
// 2	Triangle    %10
// 3	Noise       %11
// pulse width max  63 %00111111  = 50% 

Music:{

voiceM1Ptr:      .byte 0    // voice M1 and M2 are used to play tune sequences
voiceM2Ptr:      .byte 0    // title music uses M1 and M2 on voices 14/15   
voiceM1Time:     .byte 0    // game music uses M1 on voice 14
voiceM2Time:     .byte 0

// voice 0-3  are available for sound effects
// populate top 9 bytes, playtime is last since this will then trigger playback
//              VOICE 0  1  2  3   
voiceFreqLo:    .byte 0, 0, 0, 0    
voiceFreqHi:    .byte 0, 0, 0, 0
voiceVol:       .byte 0, 0, 0, 0    // volume 0-3f
voiceShape:     .byte 0, 0, 0, 0    // bits 6/7 00 = pulse, 01 = saw, 02 = tri, 03 = noise. bits 0-5 = pulse width (3f = 50%)
voiceFreqStep:  .byte 0, 0, 0, 0    // +127 to -128
voiceStepTime:  .byte 0, 0, 0, 0    // ticks between frequency steps
voicedecay:     .byte 0, 0, 0, 0    // volume decay value
voicedecayTime: .byte 0, 0, 0, 0    // ticks between volume decay
voicePlayTime:  .byte 0, 0, 0, 0    // length of sound in game ticks 60 = 1second.  zero = inactive voice
voiceStepTick:  .byte 0, 0, 0, 0
voicedecayTick: .byte 0, 0, 0, 0

GameMusicOn:    .byte 0 // 0 = off, 1 = playing, 2 = Start, 3 = stop
SoundMode:      .byte 0 // 0 = off, 1 = title music, 2 = ingame sound+music, 128 = turn sounds off (stop all)
finished:       .byte 0
lastHeight:     .byte 0

INT_Save:       .word $deaf

IRQ_TitleMusicStart:{
	lda #0
	sta voiceM1Ptr
	sta voiceM2Ptr
	sta finished
	inc
	sta voiceM1Time
	sta voiceM2Time
    lda #1
    sta SoundMode
	rts
}

IRQ_StopAllSound:{
    lda #128
    sta SoundMode
    wai
	rts
}

IRQ_GameSoundEnable:{
    lda #2      // start game music
    sta SoundMode       // ingame sounds on
    rts
}

IRQ_GameMusicStart:{
    lda #2      // start game music
	sta GameMusicOn
    rts
}

IRQ_GameMusicStop:{
    lda #3      //stop game music
    sta GameMusicOn
    rts
}

IRQ_Sound:{
    backupVeraAddrInfo()
    lda SoundMode
    beq IRQ_SoundX  // no noises!
    bmi !stopAll+
    dec
    beq !titlePlay+
    jsr IRQ_playGameMusic
    bra IRQ_SoundX
!titlePlay:    
    jsr IRQ_playTitleMusic
    bra IRQ_SoundX
!stopAll:
    stz SoundMode
    stz GameMusicOn
    addressRegister(0,VERAPSG0,1,0)
    ldx #16*4    // 4 * number of voices that could be on - increase if we use more
!stopPSG:
    stz VERADATA0
    dex
    bne !stopPSG-
IRQ_SoundX:
    restoreVeraAddrInfo()
    jmp (INT_Save)
}

IRQ_playTitleMusic:{
    lda voiceM1Ptr
    tay
    asl
    tax  
    lda titleTune.Voice01+1,x         
    bpl decvoiceM1Time               // freq_hi < $80 so must be valid data
    inc finished                     //otherwise we hit end so set finished flag   
    jmp IRQ_playTitleMusicX       


decvoiceM1Time:
    addressRegister(0,VERAPSG14,1,0)
    dec voiceM1Time
    lda voiceM1Time
    beq setVoice1       // count is 0 so get next note
    cmp #$01            // check if count is 1, if so, turn vol off/end note
    bne doVoice2        // otherwise count is not 1 so go deal with voice 2 
    stz VERADATA0       //
    stz VERADATA0
    stz VERADATA0
    bra doVoice2

setVoice1:
    lda titleTune.Voice01,x         //freq low 
    sta VERADATA0
    lda titleTune.Voice01+1,x       //freq hi
    sta VERADATA0
    ora titleTune.Voice01,x 
    beq v1setVol               //put 0 in vol if freqis 0
    lda #192 | MaxVolume       //both channels, max vol
v1setVol:
    sta VERADATA0
    lda #$3f                // %10111111  triangle, 50% duty                
    sta VERADATA0
    lda titleTune.Voice01Time,y       
    sta voiceM1Time 
    inc voiceM1Ptr

// light up keyboard RED
    addressRegister(0,pianoKeyRow2,0,0)
    ldx #$01            //white
    lda notePositions.redKeys,y     //previous note
    beq thisRedNote                 // if zero then skip
    asl                 //double cos 2 bytes per char
    clc
    adc #$09            //offset from left + 1 for colour byte
    sta VERAAddrLow
    stx VERADATA0       // put colour in   
thisRedNote:
    lda notePositions.redKeys+1,y     //this note position
    beq doVoice2        //if nothing then skip
    ldx #02             //red
    asl                 //double cos 2 bytes per char
    clc
    adc #$09            //offset from left + 1 for colour byte
    sta VERAAddrLow
    stx VERADATA0       // put colour in   

doVoice2:
    addressRegister(0,VERAPSG15,1,0)
    dec voiceM2Time    
    lda voiceM2Time
    beq setVoice2           // timer = 0 , set next note
    cmp #$01
    bne IRQ_playTitleMusicX     // timer not 1 so do nothing
    stz VERADATA0
    stz VERADATA0
    stz VERADATA0           // set vol to 0 at count of 1 (end note)
    bra IRQ_playTitleMusicX

setVoice2:
    lda voiceM2Ptr
    tay
    asl
    tax
    lda titleTune.Voice02,x
    sta VERADATA0
    lda titleTune.Voice02+1,x         
    sta VERADATA0
    ora titleTune.Voice02,x 
    beq v2setVol                //put 0 in vol if freqis 0
    lda #192 | MaxVolume        // both channels, vol $3f max
v2setVol:
    sta VERADATA0
    lda #$bf                // %10111111  triangle, 50% duty   
    sta VERADATA0
    lda titleTune.Voice02Time,y     
    sta voiceM2Time    
    inc voiceM2Ptr

// light up keyboard Blue
    addressRegister(0,pianoKeyRow2,0,0)
    ldx #$01            //white
    lda notePositions.blueKeys,y     //previous note
    beq thisBlueNote                 // if zero then skip
    asl                 //double cos 2 bytes per char
    clc
    adc #$09            //offset from left + 1 for colour byte
    sta VERAAddrLow
    stx VERADATA0       // put colour in   
thisBlueNote:
    lda notePositions.blueKeys+1,y     //this note position
    beq IRQ_playTitleMusicX        //if nothing then skip
    ldx #06             //Blue
    asl                 //double cos 2 bytes per char
    clc
    adc #$09            //offset from left + 1 for colour byte
    sta VERAAddrLow
    stx VERADATA0       // put colour in  

IRQ_playTitleMusicX:
    rts
}

IRQ_playGameMusic:{
    addressRegister(0,VERAPSG14,1,0)
    lda GameMusicOn
    //bne !notStopped+
    beq IRQ_playGameMusicX  // 0 = music not currently playing
//!notStopped:
    dec
    beq playNextNote        // 1 = playing
    dec
    beq startGameMusic      // 2 = start from beginning
                            // get here - must be 3 (stop)
    stz GameMusicOn         // set mode to stopped
    //addressRegister(0,VERAPSG0,1,0) // and turn off voice 1
    stz VERADATA0
    stz VERADATA0
    stz VERADATA0
    stz VERADATA0
    bra IRQ_playGameMusicX
startGameMusic:
	lda #0
	sta voiceM1Ptr
	inc
	sta voiceM1Time
    sta GameMusicOn     // set to 1 - playing
playNextNote:
    dec voiceM1Time
    bne IRQ_playGameMusicX  // countdown not zero so exit
    //addressRegister(0,VERAPSG0,1,0)
    lda voiceM1Ptr
    asl             // *2
    tax
    lda gameTune+1,x    // check hi note for end of tune
    bpl setVoice1       // hi freq <$80 so valid note otherwise
    ldx #$00            // end of tune reached so reset 
    stx voiceM1Ptr
setVoice1:
    //addressRegister(0,VERAPSG0,1,0)
    lda gameTune,x         //freq low 
    sta VERADATA0
    lda gameTune+1,x       //freq hi
    sta VERADATA0
//    ora gameTune,x 
//    beq v1setVol               //put 0 in vol if freqis 0
    lda #192 | MaxVolume         //both channels, max vol
//v1setVol:
    sta VERADATA0
    lda #$3f                // %10111111  triangle, 50% duty                
    sta VERADATA0
    lda #$09
    sta voiceM1Time 
    inc voiceM1Ptr

IRQ_playGameMusicX:
    //  Check for other sounds to play in voices 0-3

    ldx #$0
checkEffects:
    lda voicePlayTime,x
    beq checkNextEffect
    jsr playGameSoundEffect     // x is voice to play
checkNextEffect:
    inx
    cpx #$04
    bne checkEffects
//IRQ_Exit:
    lda Storage.JumpHeight
    bne playJumpSound
    //lda #<VERAPSG0 +22
    //sta VERAAddrLow
    //stz VERADATA0   // kill volume on voice 4
    stz lastHeight
    rts
}

playJumpSound:{
    ldy #$3f            //volume
    cmp lastHeight
    bne !on+
    ldy #$00            //volume 0
!on:
    sta lastHeight
    tax
    lda #<VERAPSG0 +20  // voice 4 
    sta VERAAddrLow
    stz VERADATA0
    txa
    asl
    clc
    adc #$10
    sta VERADATA0
    tya             //get volume
    ora #$c0        //both channels
    sta VERADATA0
    lda #%00001111   // pulse
    sta VERADATA0
!exit:
    rts
}


playGameSoundEffect:{
// x = voice to play 0-3

    //addressRegister(0,VERAPSG0,1,0)
    txa
    asl
    asl     // multiply register number by 4
    clc
    adc  #<VERAPSG0
    sta VERAAddrLow         // set veraaddrlow offset by x*4

    dec voicePlayTime,x     // must have been >0 to get here
    bne !PSGPlaying+
    stz voiceVol,x          // playtime now zero - turn voice off
    stz voiceStepTime,x
    stz voicedecayTime,x
!PSGPlaying:
    lda voiceStepTime,x
    beq !PSGVolume+
    inc voiceStepTick,x
    cmp voiceStepTick,x
    bne !PSGVolume+
    stz voiceStepTick,x
    lda voiceFreqLo,x
    clc
    adc voiceFreqStep,x
    sta voiceFreqLo,x
    bcc !PSGVolume+
    lda voiceFreqStep,x
    bmi !PSGFreqDown+       // just dec high
    inc voiceFreqHi,x
    inc voiceFreqHi,x        // or add 2 then ...
!PSGFreqDown:    
    dec voiceFreqHi,x        //sub 1
!PSGVolume:
    lda voicedecayTime,x
    beq !PSGSet+
    inc voicedecayTick,x
    cmp voicedecayTick,x
    bne !PSGSet+
    stz voicedecayTick,x
    lda voiceVol,x
    clc
    adc voicedecay,x
    sta voiceVol,x
!PSGSet:
    lda voiceFreqLo,x
    sta VERADATA0
    lda voiceFreqHi,x
    sta VERADATA0
    lda voiceVol,x
    ora #$c0        //both channels
    sta VERADATA0
    lda voiceShape,x
    sta VERADATA0
    rts
}

IRQ_SoundSetup:{
	// setup int for title music
    lda $314
    sta INT_Save
    lda $315
    sta INT_Save+1
    sei
    lda #<IRQ_Sound
    sta $314
    lda #>IRQ_Sound
    sta $315

    lda #128
    sta SoundMode   
	cli
	rts
}

Restore_INT:{
	sei
	lda INT_Save
	sta $314
	lda INT_Save+1
	sta $315
	cli
	rts
}

playBell:{
// y is voice to use
    ldy #$00    //using voice 0
    ldx #$00
playBellLoop:
    lda bellSound,x
    sta voiceFreqLo,y
    iny
    iny
    iny
    iny     // add 4 to y
    inx
    cpx #$09
    bne playBellLoop
    rts

// voiceFreqLo
// voiceFreqHi
// voiceVol
// voiceShape
// voiceFreqStep
// voiceStepTime
// voicedecay
// voicedecayTime
// voicePlayTime
bellSound: .byte  $80, $18,  $3f, $80 + $3f, $0, $0,  $ff, $1, $2f
}

playDeathSound:{
// a is cycle time
// y is Freq Lo
// x is freq Hi
    sty DeathSound
    stx DeathSound+1
    sta DeathSound+8

    ldy #$03    //using voice 3
    ldx #$00
playDeathLoop:
    lda DeathSound,x
    sta voiceFreqLo,y
    iny
    iny
    iny
    iny     // add 4 to y
    inx
    cpx #$09
    bne playDeathLoop
    rts

// voiceFreqLo
// voiceFreqHi
// voiceVol
// voiceShape
// voiceFreqStep
// voiceStepTime
// voicedecay
// voicedecayTime
// voicePlayTime
DeathSound: .byte  $00, $00,  $3f, $80 + $3f, $0, $0,  $00, $00, $00

}

}
