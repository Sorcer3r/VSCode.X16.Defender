#importonce 

.namespace Logic {
    
    GameLogicIndirectJump: .word $C0DE

    Execute:
    {
        lda Storage.m_gameState
        and #%01111111
        dec
        tax

        lda gameData.LookUps.GameStates.JumpTableLo,x
        sta GameLogicIndirectJump
        lda gameData.LookUps.GameStates.JumpTableHi,x
        sta GameLogicIndirectJump + 1

        jmp (GameLogicIndirectJump)
    }

    StartUp:
    {
        copyVERAData(VRAMPalette,VRAMPalette+32,32)
        copyVERAData(VRAMPalette,VRAMPalette+64,32)
        setDCSel(0)

        lda #DCSCALEx2
        sta VERA_DC_hscale
        sta VERA_DC_vscale

        // lda VERA_DC_video
        // ora #GLOBAL_SPRITE_ENABLE_ON
        // sta VERA_DC_video

        lda #GLOBAL_SPRITE_ENABLE_ON
        tsb VERA_DC_video

        //copyDataToVera(SpriteData,SpriteMemoryAddr,_SpriteData-SpriteData)
        CopyCompressedSpritesToVera()
        
        copyDataToVera(FontLowerData,fontCharLowerAddr,_FontLowerData-FontLowerData)
        copyDataToVera(FontUpperData,fontCharUpperAddr,_FontUpperData-FontUpperData)
        copyDataToVera(FontBackData,fontBackCharAddr,_FontBackData-FontBackData)

        SetCharacterAddress(CharMapAddr)

        jsr Render.ResetHiScore

#if MusicON
	jsr Music.IRQ_SoundSetup
#endif

        lda #gameStateTitle
        sta Storage.m_gameState
        rts

    }

    Title:
    {
        //SetCharacterAddress(DefaultCharMapAddr)

        jsr titleScreen.playTitleScreen

        //SetCharacterAddress(CharMapAddr)

        lda #gameStateInit
        sta Storage.m_gameState
        rts
    }

    Init:
    {
        lda #maxNoOfLives
        sta Storage.m_noOfLives

        ldx #19
        stx Storage.Render.m_level

        jsr Render.ResetScore

        lda #gameStateLevelSetUp
        sta Storage.m_gameState
        rts
    }

    LevelSetUp:
    {
        // Init Air Time
        lda #<AirTime
        sta Storage.m_airAmount
        lda #>AirTime
        sta Storage.m_airAmount + 1    

        jsr Render.PrepLevel
        jsr MinerWilly.SetUpMinerWillyLives

#if MusicON
    jsr Music.IRQ_GameSoundEnable
    jsr Music.IRQ_GameMusicStart
#endif

        ldx Storage.Render.m_level
        lda gameData.willyStartDirections,x
        sta Storage.Willy.Direction
        txa
        asl
        tax
        lda gameData.willyStartPositions,x
        pha
        lda gameData.willyStartPositions+1,x
        tay
        plx
        jsr MinerWilly.Initialise
        stz Storage.Render.AnimationFrame
        jsr MinerWilly.Draw

        lda #gameSubStateNone
        sta Storage.m_gameSubState

        lda #gameStatePlaying
        sta Storage.m_gameState
        rts
    }

    Playing:
    {
        inc Storage.Render.AnimationFrame
        lda Storage.Render.AnimationFrame
        and #%00000011
        jne(!Exit+)
        jsr MinerWilly.Input
        jsr MinerWilly.CheckCollision

    #if CollisionDEBUG
        jsr MinerWilly.ShowWillysAttributes
        ShowDebug:
            ldx MinerWilly.CheckCollision.ScreenXCol
            ldy MinerWilly.CheckCollision.ScreenYRow
            lda Storage.Willy.State
            bmi !HesDead+
            lda #(YELLOW <<4)
            .byte $2C
        !HesDead:
            lda #(RED <<4)
            
            jsr MinerWilly.ShowCollisionArea
            lda MinerWilly.CheckCollision.ScreenXCol
            sta Storage.Debug.PreviousX
            lda MinerWilly.CheckCollision.ScreenYRow
            sta Storage.Debug.PreviousY
    #endif

        jsr MinerWilly.Execute
        jsr MinerWilly.Draw

        lda Storage.m_noOfLivesFrame
        inc
        and #%00001111
        sta Storage.m_noOfLivesFrame
        and #%00000011
        bne !SkipAnimation+
        jsr MinerWilly.AnimateMinerWillyLives

        lda Storage.m_gameSubState
        bpl !SkipAnimation+
        jsr Render.FlashPaletteSpriteColourOne
    !SkipAnimation:

        jsr Render.moveSprites
        jsr Render.DrawSprites
        jsr Render.RotateConveyorBelt
        jsr Render.CycleColourFifteenColourPallet

        jsr MinerWilly.BumpedIntoSprite

        dec Storage.m_airAmount
        lda Storage.m_airAmount
        cmp #$FF
        bne !ByPass+
        dec Storage.m_airAmount + 1
        lda Storage.m_airAmount + 1
        ora Storage.m_airAmount
        bne !ByPass+
        lda #WillyDeathState
        sta Storage.Willy.State
        jmp PassedTheAirRowDraw

    !ByPass:
        jsr Render.SetAirRow

    PassedTheAirRowDraw:
        // lda #%00100001
        // jsr Utils.ApplyScore
        jsr Render.SetScore

        lda Storage.Render.ScreenChanged
        bpl !ByPass+
        jsr Render.copyScreenToVera
        stz Storage.Render.ScreenChanged

    !ByPass:
        // lda #gameStateSuckAirMeter
        // sta Storage.m_gameState
    !Exit:
        rts
    }

    SuckAirMeter:
    {
        jsr Render.SetAirRow

#if MusicON
    PlayNote(2, Storage.m_airAmount)
#endif
        sec
        lda Storage.m_airAmount
        sbc #DrainAirTimeInterval
        sta Storage.m_airAmount

        lda Storage.m_airAmount + 1
        sbc #0
        sta Storage.m_airAmount + 1

        lda #%00100000 | ScorePerAirInterval
        jsr Utils.ApplyScore

        jsr Render.SetScore

        lda Storage.m_airAmount + 1
        cmp #$FF
        bne !Exit+

#if MusicON
        StopPSGVoice(2)
#endif
        inc Storage.Render.m_level
        // TODO: Check For Last Level.....
        lda #gameStateLevelSetUp
        sta Storage.m_gameState

    !Exit:
        rts
    }

    BeatLevel:
    {
        lda #gameStateDied
        sta Storage.m_gameState
        rts
    }

    Died:
    {
        lda #gameStateOutOfLives
        sta Storage.m_gameState
        rts
    }

    OutOfLives:
    {
        lda #gameStateWon
        sta Storage.m_gameState
        rts
    }

    Won:
    {
        lda #gameStateLost
        sta Storage.m_gameState
        rts
    }

    Lost:
    {
        lda #gameStateDemo
        sta Storage.m_gameState
        rts
    }

    Demo:
    {
        lda #gameStateDemo
        sta Storage.m_gameState
        rts
    }


}
