.cpu _65c02
#importonce 

.namespace Utils {

    ApplyScore:
    {
        // XXXX XXXX
        // 0000 = Value Digit Position, 0=1s, 1=10s, 2=100s, 3=1000s, 4=10000s... to 5
        //      0000 = The Value of that digit position = 0 -> 9

        // Input : Accumulator : Contain Score Value

        .label ScoringDigit = Storage.TempByte7
        .label ScoringValue = Storage.TempByte8
        pha
        lsr
        lsr
        lsr
        lsr

        // 012356 = Display Index
        // 543210 = Digit Index
        // 000000
        // ^^^^^^- 1's
        // |||||-- 10's
        // ||||--- 100's
        // |||---- 1000's
        // ||----- 10000's
        // |------ 100000's

        eor #$FF
        sec
        adc #6
        sta ScoringDigit

        pla
        and #%00001111
        sta ScoringValue

        ldy ScoringDigit
    !AddToNextDigit:
        cpy #gameData.GameDefaults.XtraLifeOnDigit
        bne !DontAddLife+
        inc Storage.m_noOfLives
    !DontAddLife:
        lda Storage.m_Score,y
        clc
        adc ScoringValue
        cmp #$0A
        bcs !AddCarryToNextDigit+
        sta Storage.m_Score,y
    !Exit:
        rts

    !AddCarryToNextDigit:
        sec
        sbc #$0A
        sta Storage.m_Score,y
        dey
        bmi !Exit-
        lda #1
        sta ScoringValue
        jmp !AddToNextDigit-
    }
    
}
