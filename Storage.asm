.cpu _65c02

#importonce 

.namespace Storage {
    TempByte1: .byte 0
    TempByte2: .byte 0
    TempByte3: .byte 0
    TempByte4: .byte 0
    TempByte5: .byte 0
    TempByte6: .byte 0
    TempByte7: .byte 0
    TempByte8: .byte 0

    Willy:{
        ActualX: .word 0          // Move 256 Pixels in any direction 0 -> 255
        ActualY: .word 0
        PlayAreaX: .byte 0
        PlayAreaY: .byte 0
// Users Inputed Direction
        InputDirection: .byte 0
// Finalised Direction we want Willy To Go
        Direction: .byte 0
// Direction Applied To Willy without user intervention (Conveyors)        
        ForcedDirection: .byte 0
// The Default Motion that will be applied.
        Motion: .byte 0
        JumpState: .byte 0
        FallingState: .byte 0
        AnimationFrame: .byte 0
        SpriteFrame: .byte 0
        State: .byte 0
    }

    JumpHeight: .byte 0
    FallHeight: .byte 0

    m_airAmount: .word AirTime
    m_keysToFind: .byte 0

    m_Score:    .fill 6, $0
    m_HiScore:  .fill 6, $0

    m_noOfLives:    .byte 0
    m_noOfLivesFrame: .byte 0

    m_gameState:    .byte 0
    m_gameSubState: .byte 0

    Render:
    {
        Cell: .byte 0
        Index: .byte 0
        Roll: .byte 0

        Run: .byte 0
        LevelLen: .byte 0
        yOffset: .byte 0

        m_level: .byte 0
        m_LevelBkCol: .byte 0
        m_airHead: .byte 0

        cellAddr: .word 0

        AnimationFrame: .byte 0
        ScreenChanged: .byte 0

        // SpriteFrames:
        // .for (var i=0; i<10; i++)
        // {
        //     .for (var j=0; j<8; j++)
        //     {
        //         .byte 0     // Frame of Sprite
        //     }
        // }
    } 

#if CollisionDEBUG
    Debug:
    {
        PreviousX:  .byte 255
        PreviousY:  .byte 255
    }
#endif
}
