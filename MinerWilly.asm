.cpu _65c02

#importonce 
#import "Storage.asm"
#import "GameContants.asm"

.namespace MinerWilly {

    Initialise:
    {
        // Input Paramters
        // X: Initial Col
        // Y: Initial Row

        // stz Storage.Willy.X + 1
        // txa
        // clc
        // adc #4
        // asl
        // rol Storage.Willy.X + 1
        // asl
        // rol Storage.Willy.X + 1
        // asl
        // rol Storage.Willy.X + 1
        // sta Storage.Willy.X

        txa
        // asl
        // asl
        // asl
        sta Storage.Willy.PlayAreaX
        clc
        adc #(4*8)
        sta Storage.Willy.ActualX
        lda #0
        adc #0
        sta Storage.Willy.ActualX + 1

        tya
        // asl
        // asl
        // asl
        sta Storage.Willy.PlayAreaY
        clc
        adc #(3*8)
        sta Storage.Willy.ActualY

        setUpSpriteInVeraWithCol(0,SpriteMemoryAddr,SPRITE_MODE_16_COLOUR,
                                    0,0,SPRITE_ZDEPTH_AFTERLAYER1,
                                    SPRITE_HEIGHT_16PX, SPRITE_WIDTH_16PX, 
                                    1, spriteWillyColMask)

        rts 
    }

    Draw:
    {
        lda Storage.Willy.Direction
        cmp #directionRight
        bne !TryLeft+
        setSpriteFlip(0, 0, 0)
        jmp !ShowWilly+

    !TryLeft:
        cmp #directionLeft
        bne !ShowWilly+
        setSpriteFlip(0, 1, 0)

    !ShowWilly:
        lda Storage.Willy.Direction
        beq !Move+
        lda Storage.Willy.AnimationFrame
        clc
        adc #1
        and #%00000111
        sta Storage.Willy.AnimationFrame
        and #%00000111
        // lsr
        tay     // Works For Sprite Zero
        lda gameData.level2SpriteFramesSequences,y
        sta Storage.Willy.SpriteFrame
        
        setSpriteAddressInVeraByTable(0, Storage.Willy.SpriteFrame, gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi, SPRITE_MODE_16_COLOUR)

    !Move:
        lda Storage.Willy.PlayAreaX
        clc
        adc #dimSpriteOffsetX
        sta Storage.Willy.ActualX
        lda #0
        adc #0
        sta Storage.Willy.ActualX + 1

        lda Storage.Willy.ActualX
        sec
        sbc #spriteWillyXOffset
        sta Storage.Willy.ActualX
        lda Storage.Willy.ActualX + 1
        sbc #0
        sta Storage.Willy.ActualX + 1

        lda Storage.Willy.PlayAreaY
        clc
        adc #dimSpriteOffsetY
        sta Storage.Willy.ActualY

        moveSpriteInVera(0, Storage.Willy.ActualX, Storage.Willy.ActualY)
        rts
    }

    Input:
    {
        lda Storage.Willy.JumpState
        bne !Exit+
        
        jsr Controls.GetJoyStick

        lda ZPStorage.JoyStick
        bne !SomethingIsPressed+
        stz Storage.Willy.InputDirection // directionStill
        rts

    !SomethingIsPressed:
        lda ZPStorage.JoyStick
        and #joyPadDLeft
        beq !TryRight+
        lda #directionLeft
        sta Storage.Willy.InputDirection

    !TryRight:
        lda ZPStorage.JoyStick
        and #joyPadDRight
        beq !TryJump+
        lda #directionRight
        sta Storage.Willy.InputDirection

    !TryJump:
        lda Storage.Willy.JumpState
        ora Storage.Willy.FallingState
        bne !Exit+

        lda ZPStorage.JoyStick
        and #joyPadA
        beq !Exit+

        lda #stateJumpUP
        sta Storage.Willy.JumpState
        stz Storage.JumpHeight

        lda #2
        sta Storage.Willy.ForcedDirection

    !Exit:
        rts
    }

    Execute:
    {
        lda Storage.Willy.Direction
        cmp #directionRight
        bne !ExecuteLeft+

        clc
        lda Storage.Willy.PlayAreaX
        adc #maxWillyPixelMovement
        sta Storage.Willy.PlayAreaX
        jmp !ExecuteJump+

    !ExecuteLeft:
        cmp #directionLeft
        bne !ExecuteJump+

        sec
        lda Storage.Willy.PlayAreaX
        sbc #maxWillyPixelMovement
        sta Storage.Willy.PlayAreaX
        jmp !ExecuteJump+

    !ExecuteJump:
        lda Storage.Willy.JumpState
        bne !IsJumping+
        jmp !ExecuteFalling+

    !IsJumping:
        cmp #stateJumpUP
        beq !ExecuteJumpUp+
        jmp !ExecuteJumpDown+

    !ExecuteJumpUp:
        lda Storage.JumpHeight
        lsr
        sta Storage.TempByte1
        lda #maxWillyJumpSpeed
        sec
        sbc Storage.TempByte1
        sta Storage.TempByte1

        lda Storage.Willy.PlayAreaY
        sec
        sbc Storage.TempByte1
        sta Storage.Willy.PlayAreaY

        inc Storage.JumpHeight
        lda Storage.JumpHeight
        cmp #maxWillyJumpHeight
        bcs !MaxxedJump+
        rts

    !MaxxedJump:
        lda #stateJumpDOWN
        sta Storage.Willy.JumpState
        dec Storage.JumpHeight
        rts //jmp !Exit+

    !ExecuteJumpDown:
        lda Storage.JumpHeight
        bpl !NotNegative+
        stz Storage.FallHeight
        jmp !PassedNotNegative+
    !NotNegative:
        lsr
        sta Storage.FallHeight

    !PassedNotNegative:
        lda #maxWillyJumpSpeed
        sec
        sbc Storage.FallHeight
        sta Storage.TempByte1

        lda Storage.Willy.PlayAreaY
        clc
        adc Storage.TempByte1
        sta Storage.Willy.PlayAreaY

        dec Storage.JumpHeight
        lda Storage.JumpHeight
        bpl !Exit+

        //lda #stateJumpOFF
        stz Storage.Willy.JumpState
        stz Storage.JumpHeight
        stz Storage.Willy.ForcedDirection
        jmp !Exit+

    !ExecuteFalling:
        lda Storage.Willy.FallingState
        bpl !Exit+

        lda Storage.Willy.PlayAreaY
        clc
        adc #maxWillyPixelFallMovement
        sta Storage.Willy.PlayAreaY

        inc Storage.FallHeight

    !Exit:
        rts
    }

    CheckCollision:
    {
        // OutPuts  Acc = Collision Pattern

        ldx Storage.Willy.PlayAreaX
        ldy Storage.Willy.PlayAreaY
        phx
        phy
        txa
        and #%00000111
        sta ScreenXColRemainder

        tya
        and #%00000111
        sta ScreenYRowRemainder

        pla
        lsr
        lsr
        lsr
        sta ScreenYRow

        pla
        lsr
        lsr
        lsr
        sta ScreenXCol
        sta TestAtXCol

#if CollisionDEBUG
        ldx Storage.Debug.PreviousX
        ldy Storage.Debug.PreviousY
        lda Storage.Render.m_LevelBkCol
        asl
        asl
        asl
        asl

        jsr ShowCollisionArea
#endif

        lda #colNoCol
        sta CollisionBottom
        sta CollisionSide
        sta CollisionTop

        jsr WorkOutMotion

        // Testing Willys' New Direction
        lda Storage.Willy.Direction

        // Yes They Did
    !Continue:
        cmp #1
        bne !GoingLeft+

        // Y = Sprite Y
        ldx ScreenXCol
        // Testing Right Side of Willy
        inx
        stx TestAtXCol
        jmp CheckPosition

    !GoingLeft:
        ldx ScreenXCol
        // Left Side Of Willy
        dex
        stx TestAtXCol

    CheckPosition:
        jsr CheckSides
        jcs(!Exit+)

    CheckingWhileJumping:
        lda Storage.Willy.JumpState
        cmp #stateJumpUP
        bne !CheckJumpingDown+

        jsr CheckAbove
        jmp !Exit+

    !CheckJumpingDown:
        jsr CheckBeneath

    !Exit:
        rts

        ScreenXCol: .byte 0
        ScreenYRow: .byte 0
        TestAtXCol: .byte 0
        TestAtYRow: .byte 0
        ScreenXColRemainder: .byte 0
        ScreenYRowRemainder: .byte 0
        ScreenCharacter: .byte 0
        CollisionTop: .byte 0
        CollisionBottom: .byte 0
        CollisionBottomLeft: .byte 0
        CollisionBottomRight: .byte 0
        CollisionSide: .byte 0
    }

    CheckCollisionAtPosition:
    {
        // Inputs   X Reg = X Axis Column
        //          Y Reg = Y Axis Row

        // OutPuts  Acc = Collision Pattern

        stx ScreenXCol
        sty ScreenYRow
        jsr Render.GetCharacterFromScreen
        sta ScreenCharacter

        cmp #worldEmpty
        beq !WorldEmpty+
        cmp #worldSwitchRight
        beq !WorldEmpty+

        cmp #worldSpecial
        beq !WorldSpecial+

        cmp #worldWall
        beq !WorldWall+

        cmp #worldCollapse1
        beq !WorldCollapse+
        cmp #worldCollapse2
        beq !WorldCollapse+
        cmp #worldCollapse3
        beq !WorldCollapse+
        cmp #worldCollapse4
        beq !WorldCollapse+
        cmp #worldCollapse5
        beq !WorldCollapse+
        cmp #worldCollapse6
        beq !WorldCollapse+
        cmp #worldCollapse7
        beq !WorldCollapse+
        cmp #worldCollapse8
        beq !WorldCollapse+

        cmp #worldBush
        beq !WorldDie+
        cmp #worldRock
        beq !WorldDie+

        cmp #worldConveyor
        beq !WorldConveyor+

        cmp #worldSwitchLeft1
        beq !WorldSwitchLeft+
        cmp #worldSwitchLeft2
        beq !WorldSwitchLeft+

        cmp #worldKey
        beq !WorldKey+
        // cmp #worldKey1
        // beq !WorldKey+
        // cmp #worldKey2
        // beq !WorldKey+
        // cmp #worldKey3
        // beq !WorldKey+
        // cmp #worldKey4
        // beq !WorldKey+
        // cmp #worldKey5
        // beq !WorldKey+

        lda #colFloor
        rts

    !WorldEmpty:
        lda #colNoCol
        rts

    !WorldSpecial:
        lda #colSpecial
        rts

    !WorldWall:
        lda #colWall
        rts

    !WorldCollapse:
        lda #colCollapse
        rts

    !WorldDie:
        lda #colDie
        rts

    !WorldConveyor:
        lda #colConveyor
        rts

    !WorldSwitchLeft:
    // TODO: Needs Fleshing Out
        lda #colNoCol
        rts

    !WorldKey:
        jsr Music.playBell
        dec Storage.m_keysToFind
        bne !NotAllKeysFound+
        lda #gameSubStateKeysFound
        sta Storage.m_gameSubState

    !NotAllKeysFound:
        lda #%00110001
        jsr Utils.ApplyScore

        ldx ScreenXCol
        ldy ScreenYRow
        lda #worldEmpty
        jsr Render.PutCharacterToScreen

        inc ZPStorage.TempByte1 + 1
        inc ZPStorage.TempByte1 + 1
        lda Storage.Render.m_LevelBkCol
        lsr
        lsr
        lsr
        lsr
        sta (ZPStorage.TempByte1),y
        lda #colNoCol
        rts

        ScreenXCol: .byte 0
        ScreenYRow: .byte 0
        ScreenCharacter: .byte 0
    }


    WorkOutMotion:
    {
        lda Storage.Willy.InputDirection
        cmp Storage.Willy.Direction
        beq !ByPass+

        lda Storage.Willy.InputDirection
        cmp Storage.Willy.ForcedDirection
        bne !WorkOutMotion+
        lda Storage.Willy.ForcedDirection
        cmp #2
        bne !+
        rts
    !:
        sta Storage.Willy.Motion
        stz Storage.Willy.Direction
        bra !UpdateDirection+

    !WorkOutMotion:
        lda Storage.Willy.ForcedDirection
        bne !EvaluateForcedDirection+
        lda Storage.Willy.InputDirection
        sta Storage.Willy.Motion
        bra !UpdateDirection+

    !EvaluateForcedDirection:
        cmp #2
        beq !ResetForcedMotion+
        sta Storage.Willy.Motion
        bra !UpdateDirection+

    !ResetForcedMotion:
        stz Storage.Willy.Motion

    !UpdateDirection:
        // if (Motion)
        lda Storage.Willy.Motion
        beq !ByPass+

        // && Motion != Direction
        cmp Storage.Willy.Direction
        beq !ByPass+

        // Motion != 2
        cmp #2
        beq !ZeroMotion+
        sta Storage.Willy.Direction

    !ZeroMotion:
        stz Storage.Willy.Motion

    !ByPass:
        rts
    }

#if CollisionDEBUG
    ShowCollisionArea:
    {
        stx Col
        sty Row
        sta Backgrd

        clc
        lda Col
        adc #dimPlayRowOffSet/2
        asl
        inc
        sta ScreenAddr

        // Top
        lda Row
        dec
        adc #$B0 + dimPlayColOffset
        sta ScreenAddr + 1

        // Directly Above
        addressRegisterFromAddr(0,1,ScreenAddr,0,0)
        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Directly Above + 1
        inc VERAAddrLow
        inc VERAAddrLow
        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Upper Left
        inc VERAAddrHigh

        dec VERAAddrLow
        dec VERAAddrLow
        dec VERAAddrLow
        dec VERAAddrLow

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Upper Right
        inc VERAAddrLow
        inc VERAAddrLow
        inc VERAAddrLow
        inc VERAAddrLow

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Lower Right
        inc VERAAddrHigh

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Lower Left
        dec VERAAddrLow
        dec VERAAddrLow
        dec VERAAddrLow
        dec VERAAddrLow

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Bottom Left
        inc VERAAddrHigh
        inc VERAAddrLow
        inc VERAAddrLow

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0

        // Bottom Right
        inc VERAAddrLow
        inc VERAAddrLow

        lda VERADATA0
        and #%00001111
        ora Backgrd
        sta VERADATA0
        rts

        Col:  .byte 255
        Row:  .byte 255
        Backgrd:    .byte 0
        ScreenAddr: .word 0
    }

    ShowWillysAttributes:
    {
        addressRegister(0,VRAM_layer1_map,1,0)
        ldy #0
    !Looper:
        lda Storage.Willy.InputDirection,y
        clc
        adc #$30
        sta VERADATA0
        lda #WHITE
        sta VERADATA0
        iny
        cpy #6
        bne !Looper-
    }
#endif

    CheckUnderWillysFeet:
    {
        // Input X = Column
        //       Y = Row

        ldx CheckCollision.ScreenXCol
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr CheckCollisionAtPosition
        sta CheckCollision.CollisionBottomLeft

        ldx CheckCollision.ScreenXCol
        inx
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr CheckCollisionAtPosition
        sta CheckCollision.CollisionBottomRight

        ora CheckCollision.CollisionBottomLeft
        sta CheckCollision.CollisionBottom
        rts
    }

    CheckSides:
    {
        lda CheckCollision.ScreenXColRemainder
        beq !Check+
        jmp ExitToContinue

    !Check:
        // TODO: Temp, take out for game
        stz Storage.Willy.State

        ldx CheckCollision.TestAtXCol
        ldy CheckCollision.ScreenYRow
        jsr CheckCollisionAtPosition
        sta CheckCollision.CollisionSide

        ldx CheckCollision.TestAtXCol
        ldy CheckCollision.ScreenYRow
        iny
        jsr CheckCollisionAtPosition
        ora CheckCollision.CollisionSide
        sta CheckCollision.CollisionSide

        lda CheckCollision.ScreenYRowRemainder
        bne !Check+
        jmp EvaluateSideCollision

    !Check:
        ldx CheckCollision.TestAtXCol
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr CheckCollisionAtPosition
        ora CheckCollision.CollisionSide
        sta CheckCollision.CollisionSide

    EvaluateSideCollision:
        lda CheckCollision.CollisionSide
        and #colDie
        beq !NotDead+
        bra WillyDied

    !NotDead:
        lda CheckCollision.CollisionSide
        and #colWall
        beq !NotAWall+
        stz Storage.Willy.Direction

    !NotAWall:
        lda Storage.Willy.JumpState
        cmp #stateJumpOFF
        bne !WehaveAFloor+

    TestForFloor:
        jsr CheckUnderWillysFeet

        lda CheckCollision.CollisionBottomLeft
        and #colFloor | colWall | colCollapse | colConveyor
        bne !WehaveAFloor+

        lda #stateFalling
        sta Storage.Willy.FallingState
        stz Storage.Willy.Direction

        // lda #stateJumpDOWN
        // sta Storage.Willy.JumpState

        bra ExitToExit

    !WehaveAFloor:
        lda Storage.FallHeight
        cmp #maxWillyFallHeight
        bcs WillyDied
        lda #stateNotFalling
        stz Storage.FallHeight
        sta Storage.Willy.FallingState
        .byte $2C

    ExitToExit:
        sec
        .byte $24

    ExitToContinue:
        clc
        rts
    }

    WillyDied:
    {
        lda #WillyDeathState
        sta Storage.Willy.State
        // TODO: Temp Take Out For Game
        stz Storage.Willy.FallingState
        addressRegister(0,SPRITEREGBASE+6,4,0)
        lda #$09    
!spritesOff:                // turn sprites off - not sure how many are in use so do 9?
        stz VERADATA0
        dec
        bne !spritesOff-
        stz notePtr         // pointer to note sequence
        lda #$01
        sta cycleColour    // set first colour for screen flash  
!nextLoop:
        ldx #18        // lines of play area
        addressRegister(0,VRAM_layer1_map+($300+8+1),2,0) // 1st colour byte of play area
        lda cycleColour: #$00
        asl
        asl
        asl
        asl                 
        adc cycleColour   // put colour in background and foreground
!nextRow:
        ldy #32           // play area width
!nextLine:
        sta VERADATA0
        dey
        bne !nextLine-
        ldy #9            // set to 1st colour on line
        sty VERAAddrLow
        inc VERAAddrHigh  //and move to next line
        dex
        bpl !nextRow-
        addressRegister(0,VERAPSG3,1,0) // psg 3
        ldx notePtr: #$00
        lda freqTableLo,x
        sta VERADATA0
        lda freqTableHi,x
        sta VERADATA0
        lda #$c0 + $3f        // both channels + full vol
        sta VERADATA0
        lda #$80 + $3f
        sta VERADATA0
//         lda noteTime,x
// !waitForSoundEnd:
//         dey
//         bne !waitForSoundEnd-
//         ldy #$20
//         dec 
//         bne !waitForSoundEnd-
        inc notePtr
        wai
//!nextColour:
        lda cycleColour
        inc
        and #$0f
        sta cycleColour
        cmp #$01
        beq !bypass+
        jmp !nextLoop-
!bypass:
        addressRegister(0,VERAPSG3+2,1,0)
        stz VERADATA0   // turn ch3 off
        break()     // remove when willydead is handled correctly
        rts

        freqTableLo: .byte 156,107,169,101,119,50,75,159,156,107,169,101,119,50,75,159
        freqTableHi: .byte 41,35,30,25,19,15,12,11,10,9,8,7,6,5,4,3
//        noteTime:    .byte 3,4,5,6,7,8,9,10,9,7,6,5,4,3,2,1
    }

    CheckAbove:
    {
        lda CheckCollision.ScreenYRowRemainder
        bne !DontRefreshCollisionMatrix+
        //jne(!DontRefreshCollisionMatrix+)

        ldx CheckCollision.ScreenXCol
        // ldx TestAtXCol
        ldy CheckCollision.ScreenYRow
        dey
        jsr CheckCollisionAtPosition
        sta CheckCollision.CollisionTop

        ldx CheckCollision.ScreenXCol
        cpx #dimPlayCols-2
        beq !DontRefreshCollisionMatrix+
        inx
        ldy CheckCollision.ScreenYRow
        dey
        jsr CheckCollisionAtPosition
        ora CheckCollision.CollisionTop
        sta CheckCollision.CollisionTop

    !DontRefreshCollisionMatrix:
        lda CheckCollision.CollisionTop
        beq !Exit+
        and #colWall
        beq !WasNotAWall+
        lda Storage.JumpHeight
        bne !CompleteJump+
        lda #stateJumpOFF
        sta Storage.Willy.JumpState
        stz Storage.JumpHeight
        stz Storage.Willy.ForcedDirection
        jmp !Exit+

    !CompleteJump:
        lda #stateJumpDOWN
        sta Storage.Willy.JumpState
        lda #stateNotFalling
        sta Storage.Willy.FallingState
        //stz Storage.Willy.Direction
        dec Storage.JumpHeight
        jmp !Exit+

    !WasNotAWall:
        lda CheckCollision.CollisionTop
        and #colDie
        beq !Exit+
        //jeq(!Exit+)
        stz Storage.Willy.JumpState
        jmp WillyDied

    !Exit:
        rts
    }

    CheckBeneath:
    {
        lda Storage.Willy.JumpState
        cmp #stateJumpDOWN
        beq !CheckUnderWillysFeet+

        lda Storage.Willy.FallingState
        cmp #stateFalling
        jne(!NotJumping+)

    !CheckUnderWillysFeet:
        lda CheckCollision.ScreenYRowRemainder
        bne !DontRefreshCollisionMatrix+
        jsr CheckUnderWillysFeet

    !DontRefreshCollisionMatrix:
        lda CheckCollision.CollisionBottom
        and #colFloor | colWall | colCollapse | colConveyor
        bne !WehaveAFloor+

        lda CheckCollision.CollisionBottom
        jne(!NotJumping+)
        lda #stateFalling
        sta Storage.Willy.FallingState

        // lda #stateJumpOFF
        // sta Storage.Willy.JumpState


        // Test For Other Things????
        jmp !NotJumping+

    !WehaveAFloor:
        lda #stateJumpOFF
        sta Storage.Willy.JumpState
        lda #stateNotFalling
        sta Storage.Willy.FallingState
        stz Storage.Willy.ForcedDirection
        
        lda CheckCollision.CollisionBottom
        and #colDie
        beq !TestForCollapsing+
        jmp WillyDied

    !TestForCollapsing:
        jsr CheckForCollapsingFloor
        jsr CheckForConveyor

        // Check For Max Fall Height
    !Exit:
        rts

    !NotJumping:
    !Exit:
        rts
    }

    CheckForCollapsingFloor:
    {
        lda CheckCollision.CollisionBottom
        and #colCollapse
        beq !Exit+

        lda CheckCollision.CollisionBottomLeft
        and #colCollapse
        beq !TestRightCollapse+

        ldx CheckCollision.ScreenXCol
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr Render.GetCharacterFromScreen

        inc
        cmp #worldCollapse8
        beq !StoreCharBack+
        bcc !StoreCharBack+
        lda #worldEmpty

    !StoreCharBack:
        ldx CheckCollision.ScreenXCol
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr Render.PutCharacterToScreen

        cmp #worldEmpty
        bne !TestRightCollapse+
        inc ZPStorage.TempByte1 + 1
        inc ZPStorage.TempByte1 + 1
        lda Storage.Render.m_LevelBkCol
        lsr
        lsr
        lsr
        lsr
        ora Storage.Render.m_LevelBkCol
        sta (ZPStorage.TempByte1),y

    !TestRightCollapse:
        lda CheckCollision.CollisionBottomRight
        and #colCollapse
        beq !Exit+

    !DontExit:
        ldx CheckCollision.ScreenXCol
        inx
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr Render.GetCharacterFromScreen

        inc
        cmp #worldCollapse8
        beq !StoreCharBack+
        bcc !StoreCharBack+
        lda #worldEmpty

    !StoreCharBack:
        ldx CheckCollision.ScreenXCol
        inx
        ldy CheckCollision.ScreenYRow
        iny
        iny
        jsr Render.PutCharacterToScreen

        cmp #worldEmpty
        bne !Exit+
        inc ZPStorage.TempByte1 + 1
        inc ZPStorage.TempByte1 + 1
        lda Storage.Render.m_LevelBkCol
        lsr
        lsr
        lsr
        lsr
        ora Storage.Render.m_LevelBkCol
        sta (ZPStorage.TempByte1),y

    !Exit:
        rts
    }

    CheckForConveyor:
    {
        lda CheckCollision.CollisionBottom
        and #colConveyor
        beq !Exit+

        ldx Storage.Render.m_level
        lda gameData.conveyorDirections,x
        sta Storage.Willy.ForcedDirection

    !Exit:
        rts
    }

    SetUpMinerWillyLives:
    {
        .label WillySpriteNumber = Storage.TempByte7
        .label WillyXPos = Storage.TempByte5
        .label WillyYPos = Storage.TempByte4
        

        lda #20
        sta WillySpriteNumber

        lda #NoOfLivesRow * 8
        sta WillyYPos

        lda #0
        sta WillyXPos
        sta Storage.m_noOfLivesFrame

    !Looper:
        setUpSpriteInVera2(WillySpriteNumber,Storage.m_noOfLivesFrame,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,WillyXPos,WillyYPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, SPRITE_WIDTH_16PX, 1)

        inc WillySpriteNumber
        lda WillyXPos
        clc
        adc #16
        sta WillyXPos

        lda WillySpriteNumber
        cmp #20 + maxNoOfLives
        bne !Looper-
        rts
    }

    AnimateMinerWillyLives:
    {
        .label WillySpriteNumber = Storage.TempByte7
        .label WillySpriteFrame = Storage.TempByte6
        .label WillyXPos = Storage.TempByte5
        .label WillyYPos = Storage.TempByte4
        
        lda #20
        sta WillySpriteNumber

        lda #NoOfLivesRow * 8
        sta WillyYPos

        lda #0
        sta WillyXPos

        lda Storage.m_noOfLivesFrame
        lsr
        lsr
        sta WillySpriteFrame

    !Looper:
        setUpSpriteInVera2(WillySpriteNumber,WillySpriteFrame,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,WillyXPos,WillyYPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, SPRITE_WIDTH_16PX, 1)

        lda Storage.m_noOfLives
        clc
        adc #19
        cmp WillySpriteNumber
        bcs !ByPass+

        dec VERAAddrLow
        dec VERAAddrLow
        stz VERADATA0

    !ByPass:
        inc WillySpriteNumber
        lda WillyXPos
        clc
        adc #16
        sta WillyXPos

        lda WillySpriteNumber
        cmp #20 + maxNoOfLives
        jne(!Looper-)
        rts
    }

    BumpedIntoSprite:
    {
        lda VERAINTSTATUS
        and #%00000100
        beq !Exit+

        lda VERAINTSTATUS
        and #%11110000
        cmp #spriteDoorColMask << 4 
        bne !HitEnemy+

        lda Storage.m_gameSubState
        bpl !HitEnemy+

#if MusicON
        jsr Music.IRQ_GameMusicStop

        SetUpPSGVoice(2, MaxVolume, VERA_PSG_WAVEFORM_SAW)
#endif 
        lda #gameStateSuckAirMeter
        sta Storage.m_gameState
        bra !Exit+

    !HitEnemy:
        cmp #spriteEnemyColMask << 4
        bne !Exit+

#if MusicON
        jsr Music.IRQ_GameMusicStop
#endif 

        lda #gameStateDied
        sta Storage.m_gameState

    !Exit:
        rts
    }
}
