.cpu _65c02

#importonce 
#import "lib/macro.asm"
#import "lib/petscii.asm"
#import "lib/constants.asm"
#import "lib/VERA_PSG_Constants.asm"
#import "lib/longBranchMacros.asm"

#import "ZPStorage.asm"
#import "GameContants.asm"
#import "Storage.asm"

.namespace Render {

    PrepLevel:
    {
        jsr Render.ClearScreenForLevel    
        jsr Render.ClearScreen

        jsr PrepBackgroundScreen
        jsr PlaceKeysOnScreen
        jsr PlaceSwitchesOnScreen
        jsr PlaceDoorOnScreen
        jsr copyScreenToVera

        jsr SetTitleRow
        jsr SetAirRow
        jsr SetScoreRow

        jsr SetLeftSwitch
        jsr PrepBackgroundChars 

        jsr PrepLevelSprites
        rts       
    }

    PrepBackgroundScreen:
    {
        // Input Variables : XReg = Level Index.

        .label i = Storage.TempByte1
        .label x = Storage.TempByte2
        .label y = Storage.TempByte3
        .label yOffSet = Storage.TempByte4
        .label dataIndex = Storage.TempByte5
        .label outChar = Storage.TempByte6

        .label screenLevelData = ZPStorage.TempByte1
        .label screenRamLoc = ZPStorage.TempByte3
        .label colourRamLoc = ZPStorage.TempByte5

        ldx Storage.Render.m_level

        stz x
        stz y
        stz dataIndex

        lda Storage.Render.m_level
        asl
        tay
        lda gameData.Screens.LookUps,y 
        sta screenLevelData
        iny
        lda gameData.Screens.LookUps,y 
        sta screenLevelData + 1

        stz screenRamLoc
        stz colourRamLoc
        lda #>ScreenRam
        sta screenRamLoc + 1
        lda #>ColourRam
        sta colourRamLoc + 1

        ldy #0
        lda (screenLevelData),y
        sta Storage.Render.LevelLen
        iny
        sty dataIndex
        stz yOffSet

    LevelLenWhileLoop:
        ldy dataIndex
        lda (screenLevelData),y
        iny
        sty dataIndex
        sta Storage.Render.Cell
        dec Storage.Render.LevelLen

        cmp #$80                // If this a Run of Chars
        bcc !SingleChar+
        and #$7F
        sta Storage.Render.Run

        lda (screenLevelData),y
        iny
        sty dataIndex
        sta Storage.Render.Cell
        dec Storage.Render.LevelLen
        jmp RunWhileLoop

    !SingleChar:
        lda #1
        sta Storage.Render.Run

        RunWhileLoop:
            dec Storage.Render.Run
            lda Storage.Render.Cell
            sta outChar

            stz i
            ForILooper:
                lda outChar
                and #$0F
                sta pokeChar

                cmp #worldCollapse
                bne !NotWorldCollapseChar+
                lda #worldCollapse1
                sta pokeChar

            !NotWorldCollapseChar:
                ldy yOffSet
                lda pokeChar: #$FF
                sta (screenRamLoc),y

                ldx Storage.Render.m_level
                lda outChar
                and #$0F
                clc
                adc gameData.LookUps.TenTimes,x
                tax

                lda gameData.Screens.levelColour,x
                ora Storage.Render.m_LevelBkCol
                sta (colourRamLoc),y
                iny
                sty yOffSet
                bne !ByPass+
                inc screenRamLoc + 1
                inc colourRamLoc + 1
            !ByPass:

                lda outChar
                lsr
                lsr
                lsr
                lsr
                sta outChar

                inc i
                lda i
                cmp #2
                bne ForILooper

            lda Storage.Render.Run
            bne RunWhileLoop

        lda Storage.Render.LevelLen
        beq !ByPass+
        jmp LevelLenWhileLoop

    !ByPass:
        rts
    }
    
    ClearScreen:
    {
        //sei
        stz ScreenColour

        addressRegister(0,$1b000,2,0)
        addressRegister(1,$1b001,2,0)

        ldy #$00
    RowLooper:
        ldx #0
    ColLooper:
        lda #charSpace
        sta VERADATA0

        lda ScreenColour: #$00
        sta VERADATA1

        inx
        cpx #128
        bne ColLooper

        iny
        cpy #dimScreenRows
        bne RowLooper
        //cli
        rts
    }

    ClearScreenWithColour:
    {
        // input Acc: Colour Of Background
        //sei
        asl
        asl
        asl
        asl
        sta Storage.Render.m_LevelBkCol
        ora #$01
        sta ScreenColour

        addressRegister(0,$1b000,2,0)
        addressRegister(1,$1b001,2,0)

        ldy #$00
    RowLooper:
        ldx #0
    ColLooper:
        lda #charSpace
        sta VERADATA0

        lda ScreenColour: #$00
        sta VERADATA1

        inx
        cpx #128
        bne ColLooper

        iny
        cpy #dimScreenRows
        bne RowLooper
        //cli
        rts
    }

    ClearPlayAreaWithColour:
    {
        // input Acc: Colour Of Background
        //sei
        asl
        asl
        asl
        asl
        sta Storage.Render.m_LevelBkCol
        ora #$01
        sta ScreenColour

        addressRegister(0,$1b000,2,0)
        addressRegister(1,$1b001,2,0)

        ldy #$00
    RowLooper:
        ldx #0
    ColLooper:
        lda #charSpace
        sta VERADATA0

        lda ScreenColour: #$00
        sta VERADATA1

        inx
        cpx #128
        bne ColLooper

        iny
        cpy #dimPlayRows + dimPlayColOffset
        bne RowLooper
        //cli
        rts
    }

    copyScreenToVera:
    // source is x16 memory . dest is vera location, bytecount max 65535
    // destroys a
    {
        addressRegister(0,$1b000,1,0)
        lda Counter: $deaf
        lda #512 & $ff
        sta Counter
        lda #(512 >> 8) & $ff
        sta Counter+1
        lda #ScreenRam & $ff
        sta copyFrom
        lda #(ScreenRam >>8) & $ff
        sta copyFrom + 1

        lda #ColourRam & $ff
        sta copyFrom2
        lda #(ColourRam >>8) & $ff
        sta copyFrom2 + 1

        ldy #0
    Row:
        tya
        clc
        adc #$b0 + dimPlayColOffset
        sta VERAAddrHigh
        ldx #dimPlayRowOffSet
        stx VERAAddrLow
        ldx #0

    Col:
        lda copyFrom: $deaf
        sta VERADATA0
        lda copyFrom2: $deaf
        sta VERADATA0
        inc copyFrom
        bne !skip1+
        inc copyFrom+1
    !skip1:
        inc copyFrom2
        bne !skip1+
        inc copyFrom2+1
    !skip1:
        inx
        cpx #dimPlayCols
        bne Col
        iny
        cpy #dimPlayRows
        bne Row
        rts
    }

    ClearScreenForLevel:
    {
        ldx Storage.Render.m_level
        lda gameData.LookUps.TenTimes,x
        tax
        lda gameData.Screens.levelColour,x

        jsr ClearPlayAreaWithColour
        rts
    }

    SetTitleRow:
    {
        .label LoByte = ZPStorage.TempByte1
        .label HiByte = ZPStorage.TempByte2

        lda Storage.Render.m_level
        stz HiByte

        // %00010100 -> 00000010 10000000
        asl
        //rol HiByte
        asl
        //rol HiByte
        asl
        //rol HiByte
        asl
        rol HiByte
        asl
        rol HiByte
        sta LoByte

        clc
        adc #<gameData.LevelNames
        sta LoByte
        lda HiByte
        adc #>gameData.LevelNames
        sta HiByte

        addressRegister(0,$1b000,1,0)
        lda #TitleRow
        clc
        adc #$b0
        sta VERAAddrHigh
        ldx #dimPlayRowOffSet
        stx VERAAddrLow

        ldy #0
    !TitleLoop:
        lda (LoByte),y
        sta VERADATA0
        // lda #YELLOW
        // ora Storage.Render.m_LevelBkCol
        lda #YELLOW << 4
        sta VERADATA0
        iny
        cpy #32
        bne !TitleLoop-
        rts
    }

    SetAirRow:
    {

        // Air Gauge = 1791 / 8
        // No Of Cols (Char)
        // Set Air Indicator Row Location
        addressRegister(0,$1b000,1,0)
        lda #AirRow
        clc
        adc #$b0
        sta VERAAddrHigh
        ldx #dimPlayRowOffSet
        stx VERAAddrLow

        // Display The Air Title String
        ldy #0
    !AirLooper:
        lda gameData.Strings.szAir,y
        sta VERADATA0
        lda #WHITE | RED << 4
        //ora Storage.Render.m_LevelBkCol
        sta VERADATA0
        iny
        cpy #gameData.Strings.AirStrLen
        bne !AirLooper-

        // Grab Air Time Colour
        ldx Storage.Render.m_level
        lda gameData.LookUps.TenTimes,x
        tax
        //lda gameData.Screens.levelColour + colour_Ground,x
        lda #WHITE
        sta AirColour
        sta AirColour2

        // Work out The Air Indicator Lengths
        lda Storage.m_airAmount
        sta Storage.Render.m_airHead
        lda Storage.m_airAmount + 1
        lsr
        ror Storage.Render.m_airHead
        lsr
        ror Storage.Render.m_airHead
        lsr
        ror Storage.Render.m_airHead
        lsr
        ror Storage.Render.m_airHead
        //lsr
        lsr Storage.Render.m_airHead
        //lsr
        lsr Storage.Render.m_airHead

        lda #dimPlayRowOffSet*2
        sta VERAAddrLow

        ldx Storage.Render.m_airHead
        //inx
        stx AirHeadLen
        beq !DoWorldAir2+

        // Perform the full Air Line
        ldy #0
    !AirHeadLooper:
        lda #worldAir1
        sta VERADATA0
        lda AirColour: #$00
        cpy #6
        bcc !MakeRed+
        ora #(GREEN << 4)
        skip2Bytes()
    !MakeRed:
        ora #(RED << 4)
        sta VERADATA0

        iny
        cpy AirHeadLen: #$00
        bne !AirHeadLooper-

    !DoWorldAir2:
        lda #worldAir2
        sta VERADATA0

        cpy #27
        bne !ByPassColour+
        lda AirColour2: #$00
        ora #GREEN << 4
        sta VERADATA0
        bra !DrawBlank+

    !ByPassColour:
        lda VERADATA0
    !DrawBlank:
        lda #blankChar
        sta VERADATA0
        // lda #GREEN << 4
        // sta VERADATA0

        lda Storage.m_airAmount
        lsr
        lsr
        lsr
        and #%00000111
        eor #%00000111

        // 000 xor 111 = 111
        // 001 xor 111 = 110
        // .....
        // 110 xor 111 = 001
        // 111 xor 111 = 000

        // 1111111. = 7
        // 111111.. = 6
        // 11111... = 5
        // 1111.... = 4
        // 111..... = 3
        // 11...... = 2
        // 1....... = 1
        // ........ = 0

        tay

        // Set Vera to #worldAir2 Character Location in Memory
        addressRegister(1, ((CharMapAddr + (worldAir2*CharX)) + 2),1,0)
        
        // ........
        // ........
        // 11111111
        // 11111111
        // 11111111
        // 11111111
        // ........
        // ........

        lda #%11111111
    !CharLooper:
        cpy #0
        beq !StoreWorldAir2+
        asl
        dey
        bra !CharLooper-

    !StoreWorldAir2:
        sta VERADATA1
        sta VERADATA1
        sta VERADATA1
        sta VERADATA1

    !Exit:
        rts
    }

    SetScoreRow:
    {
        .label LoByte = ZPStorage.TempByte1
        .label HiByte = ZPStorage.TempByte2

        addressRegister(0,$1b000,1,0)
        lda #ScoreRow
        clc
        adc #$b0
        sta VERAAddrHigh
        ldx #dimPlayRowOffSet
        stx VERAAddrLow

        ldy #0
    !TitleLoop:
        lda gameData.Strings.szScoreText,y
        sta VERADATA0
        lda #YELLOW
        //ora Storage.Render.m_LevelBkCol
        sta VERADATA0
        iny
        cpy #gameData.Strings.ScoreStrLen
        bne !TitleLoop-
        rts
    }

    SetScore:
    {
        .label LoByte = ZPStorage.TempByte1
        .label HiByte = ZPStorage.TempByte2

        addressRegister(0,$1b000,1,0)
        lda #ScoreRow
        clc
        adc #$b0
        sta VERAAddrHigh
        ldx #dimPlayRowScoreOffset
        stx VERAAddrLow

        ldy #0
    !ScoreLoop:
        lda Storage.m_Score,y
        clc
        adc #$30
        sta VERADATA0
        lda #YELLOW
        //ora Storage.Render.m_LevelBkCol
        sta VERADATA0
        iny
        cpy #6
        bne !ScoreLoop-

        ldx #dimPlayRowHiScoreOffset
        stx VERAAddrLow

        ldy #0
    !HiScoreLoop:
        lda Storage.m_HiScore,y
        clc
        adc #$30
        sta VERADATA0
        lda #YELLOW
        //ora Storage.Render.m_LevelBkCol
        sta VERADATA0
        iny
        cpy #6
        bne !HiScoreLoop-
        rts
    }

    ResetScore:
    {
        ldx #0
    !ScoreLoop:
        stz Storage.m_Score,x
        inx
        cpx #6
        bne !ScoreLoop-
        rts
    }

    ResetHiScore:
    {
        ldx #0
    !ScoreLoop:
        stz Storage.m_HiScore,x
        inx
        cpx #6
        bne !ScoreLoop-
        rts
    }

    PlaceKeysOnScreen:
    {
        stz Storage.m_keysToFind

    KeyLooper:
        ldx Storage.Render.m_level
        lda gameData.LookUps.TenTimes,x
        clc
        adc Storage.m_keysToFind
        adc Storage.m_keysToFind

        tax
        lda gameData.Screens.KeyPositions,x
        bmi !Exit+

        pha

        // Y Position = *32
        lda gameData.Screens.KeyPositions+1,x
        asl
        tax

        lda gameData.LookUps.ThirtyTwoTimes,x
        clc
        adc #<ScreenRam
        sta ScreenPosition
        sta ColourPosition

        lda gameData.LookUps.ThirtyTwoTimes + 1,x
        adc #>ScreenRam
        sta ScreenPosition + 1
        clc
        adc #>(ColourRam - ScreenRam)
        sta ColourPosition + 1

        plx

        lda #worldKey
        // clc
        // adc Storage.m_keysToFind

        sta ScreenPosition: $C0DE,x
        lda #LIGHT_GREY
        ora Storage.Render.m_LevelBkCol
        sta ColourPosition: $C0DE,x

        inc Storage.m_keysToFind

        lda Storage.m_keysToFind
        cmp #5
        bne KeyLooper

    !Exit:
        rts
    }

    PlaceSwitchesOnScreen:
    {
        ldx Storage.Render.m_level
        cpx #LEVEL_Miner_Willy_meets_the_Kong
        beq !Perform+
        cpx #LEVEL_Return_of_the_Alien_Kong_Beast
        beq !Perform+
        rts

    !Perform:
        // Y Position = *32
        // lda gameData.Screens.switchPositions+1,x
        // asl
        // tax

        lda gameData.Screens.switchPositions
        tax
        lda #worldSwitchLeft1
        sta ScreenRam,x
        lda #YELLOW
        ora Storage.Render.m_LevelBkCol
        sta ColourRam,x

        lda gameData.Screens.switchPositions+2
        tax
        lda #worldSwitchLeft2
        sta ScreenRam,x
        lda #YELLOW
        ora Storage.Render.m_LevelBkCol
        sta ColourRam,x
        rts
    }

    PlaceDoorOnScreen:
    {
        .label ColourPosition = ZPStorage.TempByte3

        ldx Storage.Render.m_level

        lda gameData.LookUps.TenTimes,x
        tax
        lda gameData.Screens.levelColour + colour_Door,x
        sta DoorColour

        lda Storage.Render.m_level
        asl
        tay

        // Y Position = *32
        lda gameData.Screens.doorValues+1,y
        asl
        tax

        lda gameData.LookUps.ThirtyTwoTimes,x
        clc
        adc #<ColourRam
        adc gameData.Screens.doorValues,y
        sta ColourPosition

        lda gameData.LookUps.ThirtyTwoTimes + 1,x
        adc #>ColourRam
        sta ColourPosition + 1

        lda DoorColour: #$00
        ldy #0
        sta (ColourPosition),y
        iny
        sta (ColourPosition),y
        ldy #32
        sta (ColourPosition),y
        iny
        sta (ColourPosition),y
        rts
    }

    SetLeftSwitch:
    {
        addressRegister(0,$00000,1,0)

        lda #$FF
        ldy #0
    !Looper:
        sta VERADATA0
        iny
        cpy #CharY
        bne !Looper-

        addressRegister(0,(CharY*worldSwitchLeft1),1,0)
        addressRegister(1,(CharY*worldSwitchLeft2),1,0)

        ldy #0
    !Looper:
        lda VERADATA0
        sta VERADATA1
        iny
        cpy #CharY
        bne !Looper-
        rts
    }

    PrepBackgroundChars:
    {
        .label cell = Storage.TempByte1
        .label index = Storage.TempByte2
        .label levelCharConfig = Storage.TempByte5

        addressRegister(1,$00008,1,0)               // VERA1 = Destination
        addressRegister(0,$00000,1,0)               // VERA0 = Source

        lda Storage.Render.m_level
        asl
        asl
        asl
        tax
        stx levelCharConfig

        stz index
    !CharLooper:
        stz Storage.Render.cellAddr
        stz Storage.Render.cellAddr + 1

        lda gameData.Screens.levelCharIndex,x

        jsr SetCharacterDefinitionAddr

        ldy #0
    !Looper:
        lda VERADATA0
        sta VERADATA1
        iny
        cpy #CharY
        bne !Looper-

        inc index
        inx
        lda index
        cmp #LevelTiles
        bne !CharLooper-

        jsr BuildWorldCollapseChars

        jsr BuildWorldConveyorChars

        jsr BuildWorldAirChars

        rts
    }

    SetCharacterDefinitionAddr:
    {
        // Input Acc = Character To Set 
                // fontBackCharAddr

        asl
        asl
        asl
        rol Storage.Render.cellAddr + 1
        clc
        adc #<fontBackCharAddr
        sta VERAAddrLow
        lda Storage.Render.cellAddr + 1
        adc #>fontBackCharAddr
        sta VERAAddrHigh
        rts
    }

    SetSpriteDefinitionAddr:
    {
        // Input Acc = Sprite Number To Set 
        // fontBackCharAddr
        // Each Sprite is 128 Bytes.
        stz Storage.Render.cellAddr
        lsr
        ror Storage.Render.cellAddr
        sta Storage.Render.cellAddr + 1

        clc
        adc #<SpriteMemoryAddr
        sta VERAAddrLow
        lda Storage.Render.cellAddr + 1
        adc #>SpriteMemoryAddr
        sta VERAAddrHigh
        rts
    }

    BuildWorldCollapseChars:
    {
        .label cell = Storage.TempByte1
        .label index = Storage.TempByte2
        .label levelCharConfig = Storage.TempByte5

        // World Collapse Chars
        setAddrSel(1)
        lda #worldCollapse1*CharY
        // // %00001111 <----- Init
        // asl
        // // %00011110
        // asl
        // // %00111100
        // asl
        // // %01111000 <----- End
        
        sta VERAAddrLow
        stz VERAAddrHigh

        setAddrSel(0)
    CharLooper:
        lda #<worldCollapse*CharY
        sta VERAAddrLow
        stz VERAAddrHigh

        lda #CharY
        sec
        sbc index
        sta CharLoopCounter

        ldy #0
    !BlankLooper:
        cpy CharLoopCounter: #00
        beq !CopyCharLooper+
        stz VERADATA1
        iny
        jmp !BlankLooper-

    !CopyCharLooper:
        lda VERADATA0
        sta VERADATA1
        iny
        cpy #CharY
        bne !CopyCharLooper-

        dec index
        lda index
        bne CharLooper
        rts
    }

    BuildWorldConveyorChars:
    {
        .label cell = Storage.TempByte1
        .label index = Storage.TempByte2
        .label levelCharConfig = Storage.TempByte5

        // World Conveyor Chars
        setAddrSel(1)
        lda #worldConveyor1*CharY
        sta VERAAddrLow
        stz VERAAddrHigh

        setAddrSel(0)
        ldx levelCharConfig

        lda gameData.Screens.levelCharIndex + (worldConveyor-1),x
        jsr SetCharacterDefinitionAddr

        ldy #0
    !ByteLooper:
        lda VERADATA0
        sta VERADATA1
        iny
        cpy #CharY
        bne !ByteLooper-

        setAddrSel(0)
        lda #worldConveyor1*CharY
        sta VERAAddrLow
        stz VERAAddrHigh

        stz index

    CharLooper:
        ldy #0
    !CopyCharLooper:
        lda VERADATA0

        cpy #0
        bne !TestForRow2+
        pha
        and #$C0
        rol
        rol
        rol
        sta ToBeORED1

        pla
        asl
        asl
        ora ToBeORED1: #$00
        jmp SendBackToVera

    !TestForRow2:
        cpy #2
        bne SendBackToVera

        pha
        and #$03
        ror
        ror
        ror
        sta ToBeORED2

        pla
        lsr
        lsr
        ora ToBeORED2: #$00

    SendBackToVera:
        sta VERADATA1
        iny
        cpy #CharY
        bne !CopyCharLooper-

        inc index
        lda index
        cmp #4
        bne CharLooper
        rts
    }

    BuildWorldAirChars:
    {
        .label cell = Storage.TempByte1
        .label index = Storage.TempByte2
        .label levelCharConfig = Storage.TempByte5

        // World Air Chars
        setAddrSel(1)
        lda #worldAir1*CharY
        sta VERAAddrLow
        stz VERAAddrHigh

        setAddrSel(0)
        lda #worldAir2*CharY
        sta VERAAddrLow
        stz VERAAddrHigh

        ldy #0
    !ByteLooper:
        lda VERADATA0
        sta VERADATA1
        iny
        cpy #CharY
        bne !ByteLooper-
        rts
    }

    // BuildSpriteAnimationArray:
    // {
    //     // Input    X = InitialSpriteFrame
    //     //          Y = Animation Sequence Start Point
    //     //          A = Sprite Number (0 -> 7)

    //     .label index = Storage.TempByte1

    //     stx SpriteAnimationAdder

    //     asl
    //     asl
    //     asl
    //     tax

    //     stz index
    // !Looper:
    //     lda gameData.level2SpriteFramesSequences,y
    //     clc
    //     adc SpriteAnimationAdder: #$00
    //     sta Storage.Render.SpriteFrames,x
    //     iny
    //     inx
    //     inc index
    //     lda index
    //     cmp #8
    //     bne !Looper-
    //     rts
    // }

    PrepLevelSprites:
    {
        .label initFrameNo = Storage.TempByte1
        .label SprNumber = Storage.TempByte2
        .label MaxNoOfSprites = Storage.TempByte3
        .label SpriteClass = Storage.TempByte4
        .label XPos = Storage.TempByte5
        .label YPos = Storage.TempByte6
        .label AnimationPattern = Storage.TempByte7
        .label CollisionMask = Storage.TempByte8

        .label arraySpriteBaseIndex = ZPStorage.SpriteWorkingArray
        .label arrayByteIndex = ZPStorage.SpriteTempararyArray
        
        lda Storage.Render.m_level
        asl
        tax

        stz arrayByteIndex
        stz arrayByteIndex + 1
        lda gameData.level2Sprite,x
        asl
        rol arrayByteIndex + 1
        asl
        rol arrayByteIndex + 1
        asl
        rol arrayByteIndex + 1
        asl
        rol arrayByteIndex + 1

        clc 
        adc #<gameData.spriteData
        sta arrayByteIndex
        sta arraySpriteBaseIndex
        lda arrayByteIndex + 1
        adc #>gameData.spriteData
        sta arrayByteIndex + 1
        sta arraySpriteBaseIndex + 1

        inx
        lda gameData.level2Sprite,x
        inc
        sta MaxNoOfSprites

        lda #1
        sta SprNumber
    
    SpriteLooper:
        ldy #spriteArrayClass
        lda (arrayByteIndex),y
        sta SpriteClass

        and #spClass_Vertical
        beq !DoHorizontal+

        ldy #spriteArrayStart
        lda (arrayByteIndex),y

        ldy #spriteArrayCurPos
        sta (arrayByteIndex),y
        sta YPos

        ldy #spriteArrayOtherAxis
        lda (arrayByteIndex),y
        sta XPos
        jmp GetInitFrame

    !DoHorizontal:
        ldy #spriteArrayStart
        lda (arrayByteIndex),y

        ldy #spriteArrayCurPos
        sta (arrayByteIndex),y
        sta XPos

        ldy #spriteArrayOtherAxis
        lda (arrayByteIndex),y
        sta YPos

    GetInitFrame:
        ldy #spriteArrayFrameIndex
        lda (arrayByteIndex),y
        sta initFrameNo

        ldy #spriteArrayCurFrame
        lda #0
        sta (arrayByteIndex),y

        ldy #spriteArrayAnimPattern
        lda (arrayByteIndex),y
        sta AnimationPattern

        lda SpriteClass
        and #spClass_Door
        beq !ByPass+
        lda #spriteDoorColMask
        sta CollisionMask    

        setUpSpriteInVera2WithCol(SprNumber,initFrameNo,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,XPos,YPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, 
                            SPRITE_WIDTH_16PX, 2, CollisionMask)
        jmp !Door+

    !ByPass:
        lda #spriteEnemyColMask
        sta CollisionMask    

        setUpSpriteInVera2WithCol(SprNumber,initFrameNo,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,XPos,YPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, 
                            SPRITE_WIDTH_16PX, 1, CollisionMask)

    !Door:
        lda SpriteClass
        and #spClass_Door
        beq !ByPass+
        ldy #spriteArrayColour
        lda (arrayByteIndex),y
        jsr SetPaletteSpriteColourOne

    !ByPass:
        ldy #spriteArrayStartDirection
        lda (arrayByteIndex),y

        ldy #spriteArrayCurDirection
        sta (arrayByteIndex),y
        sta StartDirection

        lda SpriteClass
        and #spClass_Vertical
        bne !DontFlip+

        lda StartDirection: #$00
        bpl !NoNeedToInvert+
        setSpriteFlip2(SprNumber,1,0)

    !NoNeedToInvert:
    !DontFlip:

        ldy #spriteArrayStartEnabled
        lda (arrayByteIndex),y
        ldy #spriteArrayCurEnabled
        sta (arrayByteIndex),y


        ldy #spriteArrayAnimPattern
        lda (arrayByteIndex),y
        tay

    //     lda SprNumber
    //     asl
    //     asl
    //     asl
    //     tax
    //     clc
    //     adc #8
    //     sta FrameCheck

    // !CopyLooper:
    //     lda gameData.level2SpriteFramesSequences,y
    //     sta Storage.Render.SpriteFrames,x

    //     iny
    //     inx
    //     cpx FrameCheck: #$00
    //     bne !CopyLooper-

        // TODO: needs to initalise the Sprite Data Array with Current Values
        // TODO: complete the sprite Loop. - Done
        // TODO: Complete the Amination Index Element in Sprite Data Array - Done ???
        // TODO: Redefine FrameIndex with new constants - Done

        clc
        lda arrayByteIndex
        adc #16
        sta arrayByteIndex
        bcc !ByPass+
        inc arrayByteIndex + 1
    !ByPass:
        inc SprNumber
        lda SprNumber
        cmp MaxNoOfSprites
        beq !Exit+
        jmp SpriteLooper

    !Exit:
        rts
    }


    DrawSprites:
    {
        .label initFrameNo = Storage.TempByte1
        .label SprNumber = Storage.TempByte2
        .label MaxNoOfSprites = Storage.TempByte3
        .label SpriteClass = Storage.TempByte4
        .label XPos = Storage.TempByte5
        .label YPos = Storage.TempByte6
        .label AnimationPattern = Storage.TempByte7
        .label CollisionMask = Storage.TempByte8

        .label arraySpriteBaseIndex = ZPStorage.SpriteWorkingArray
        .label arrayByteIndex = ZPStorage.SpriteTempararyArray
        

        lda arraySpriteBaseIndex
        sta arrayByteIndex
        lda arraySpriteBaseIndex + 1
        sta arrayByteIndex + 1

        lda Storage.Render.m_level
        asl
        tax
        inx

        lda gameData.level2Sprite,x
        inc
        sta MaxNoOfSprites

        lda #1
        sta SprNumber
    SpriteLooper:
        ldy #spriteArrayClass
        lda (arrayByteIndex),y
        sta SpriteClass

    //     and #spClass_Door
    //     jne(!IsClassEugene+)


    // !IsClassEugene:
    //     lda SpriteClass
    //     and #spClass_Eugene
    //     jne(!IsClassVertical+)

    // SkyLab

    // Solar Trucks.... they cant be flipped

    !IsClassVertical:
        lda SpriteClass
        and #spClass_Vertical
        beq !MustBeHorizontal+

        ldy #spriteArrayOtherAxis
        lda (arrayByteIndex),y
        sta XPos

        ldy #spriteArrayCurPos
        lda (arrayByteIndex),y
        sta YPos
        jmp !ShowFrame+

    !MustBeHorizontal:
        ldy #spriteArrayOtherAxis
        lda (arrayByteIndex),y
        sta YPos

        ldy #spriteArrayCurPos
        lda (arrayByteIndex),y
        sta XPos

    !ShowFrame:
    //     ldy #spriteArrayCurPos
    //     lda (arrayByteIndex),y
    //     and #%00000001
    //     bne !DontAnimate+

        ldy #spriteArrayCurFrame
        lda (arrayByteIndex),y

        ldy #spriteArrayAnimPattern
        clc
        adc (arrayByteIndex),y
        tax

        // Frame Counter ++
        // ldy #spriteArrayCurFrame
        // lda (arrayByteIndex),y
        // clc
        // adc #1
        // and #7
        // sta (arrayByteIndex),y

    // !DontAnimate:
        ldy #spriteArrayFrameIndex
        lda (arrayByteIndex),y
        clc
        adc gameData.level2SpriteFramesSequences,x
        sta initFrameNo

        lda SpriteClass
        and #spClass_Door
        beq !ByPass+
        lda #spriteDoorColMask
        sta CollisionMask    

        setUpSpriteInVera2WithCol(SprNumber,initFrameNo,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,XPos,YPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, 
                            SPRITE_WIDTH_16PX, 2, CollisionMask)
        jmp !Door+

    !ByPass:
        lda #spriteEnemyColMask
        sta CollisionMask    

        setUpSpriteInVera2WithCol(SprNumber,initFrameNo,
                            gameData.LookUps.SpriteAddrTable.Lo, gameData.LookUps.SpriteAddrTable.Hi,
                            SPRITE_MODE_16_COLOUR,XPos,YPos,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, 
                            SPRITE_WIDTH_16PX, 1, CollisionMask)

    !Door:
        // Sprite Class
        lda SpriteClass
        and #spClass_Vertical
        jne(!DontFlip+)

        ldy #spriteArrayCurDirection
        lda (arrayByteIndex),y

        bpl !NoNeedToInvert+
        ldx Storage.Render.m_level
        cpx #18
        bne !Flip+
        lda SprNumber
        cmp #5
        jcc(!DontFlip+)
    !Flip:
        setSpriteFlip2(SprNumber,1,0)
        jmp !DontFlip+

    !NoNeedToInvert:
        setSpriteFlip2(SprNumber,0,0)
    !DontFlip:
        clc
        lda arrayByteIndex
        adc #16
        sta arrayByteIndex
        bcc !ByPass+
        inc arrayByteIndex + 1
    !ByPass:
        inc SprNumber
        lda SprNumber
        cmp MaxNoOfSprites
        beq !Exit+
        jmp SpriteLooper

    !Exit:
        rts
    }

    moveSprites:
    {
        .label initFrameNo = Storage.TempByte1
        .label SprNumber = Storage.TempByte2
        .label MaxNoOfSprites = Storage.TempByte3
        .label SpriteClass = Storage.TempByte4
        .label XPos = Storage.TempByte5
        .label YPos = Storage.TempByte6
        .label AnimationPattern = Storage.TempByte7

        .label arraySpriteBaseIndex = ZPStorage.SpriteWorkingArray
        .label arrayByteIndex = ZPStorage.SpriteTempararyArray
        

        lda arraySpriteBaseIndex
        sta arrayByteIndex
        lda arraySpriteBaseIndex + 1
        sta arrayByteIndex + 1

        lda Storage.Render.m_level
        asl
        tax
        inx

        lda gameData.level2Sprite,x
        inc
        sta MaxNoOfSprites

        lda #1
        sta SprNumber
    SpriteLooper:
        ldy #spriteArrayClass
        lda (arrayByteIndex),y
        sta SpriteClass

        and #spClass_Door
        bne !DoNotMove+

        ldy #spriteArraySpeed
        lda (arrayByteIndex),y
        sta SpeedToAdd

        ldy #spriteArrayCurDirection
        lda (arrayByteIndex),y
        sta CurrentDirection

        ldy #spriteArrayCurPos
        lda (arrayByteIndex),y

        ldx #0
    !SpeedLooper:
        clc
        adc CurrentDirection: #$00
        inx
        cpx SpeedToAdd: #$00
        bne !SpeedLooper-

        ldy #spriteArrayCurPos
        sta (arrayByteIndex),y

        ldy #spriteArrayMin
        cmp (arrayByteIndex),y
        bcs !AboveMinimum+

        lda (arrayByteIndex),y
        ldy #spriteArrayCurPos
        sta (arrayByteIndex),y

        ldy #spriteArrayCurDirection
        lda #1
        sta (arrayByteIndex),y
        jmp !UpdateCurPos+

    !AboveMinimum:
        ldy #spriteArrayMax
        cmp (arrayByteIndex),y
        bcc !UpdateCurPos+

        lda (arrayByteIndex),y
        ldy #spriteArrayCurPos
        sta (arrayByteIndex),y

        ldy #spriteArrayCurDirection
        lda #255
        sta (arrayByteIndex),y

    !UpdateCurPos:
        lda SpriteClass
        cmp #spClass_HoldAtEnd
        bne !DoNotMove+

        ldy #spriteArrayCurDirection
        lda #0
        sta (arrayByteIndex),y

    !DoNotMove:
        ldy #spriteArrayCurPos
        lda (arrayByteIndex),y
        and #%00000001
        bne !DontAnimate+

        lda SpriteClass
        and #spClass_Kong
        beq !NotKong+

        lda Storage.Render.AnimationFrame
        and #%00001111
        bne !DontAnimate+

    !NotKong:
        // Frame Counter ++
        ldy #spriteArrayCurFrame
        lda (arrayByteIndex),y
        clc
        adc #1
        and #%00000111
        sta (arrayByteIndex),y

    !DontAnimate:

        clc
        lda arrayByteIndex
        adc #16
        sta arrayByteIndex
        bcc !ByPass+
        inc arrayByteIndex + 1
    !ByPass:
        inc SprNumber
        lda SprNumber
        cmp MaxNoOfSprites
        beq !Exit+
        jmp SpriteLooper

    !Exit:
        rts
    }

    SetPaletteSpriteColourOne:
    {
        // Input Acc = Colour To Define
        pha
        addressRegister(0,VRAMPalette,1,0)
        ply
    !Loop:
        inc VERAAddrLow
        inc VERAAddrLow
        dey
        bne !Loop-

        addressRegister(1,VRAMPalette+66,1,0)

        lda VERADATA0
        sta VERADATA1
        lda VERADATA0
        sta VERADATA1
        rts

    }

    FlashPaletteSpriteColourOne:
    {
        addressRegister(0,VRAMPalette+66,1,0)
        addressRegister(1,VRAMPalette+66,1,0)

        lda VERADATA0
        eor #$FF
        sta VERADATA1
        lda VERADATA0
        eor #$FF
        sta VERADATA1
        rts
    }

    GetCharacterFromScreen:
    {
        .label ScreenLocation = ZPStorage.TempByte1
        // Input    X = Column
        //          Y = Row

        // Output   Acc = Character

        tya
        asl
        tay
        lda gameData.LookUps.ThirtyTwoTimes,y
        clc
        adc #<ScreenRam
        sta ScreenLocation
        iny
        lda gameData.LookUps.ThirtyTwoTimes,y
        adc #>ScreenRam
        sta ScreenLocation + 1

        txa
        tay
        lda (ScreenLocation),y
        rts
    }

    PutCharacterToScreen:
    {
        .label ScreenLocation = ZPStorage.TempByte1
        // Input    X = Column
        //          Y = Row
        //          Acc = Character

        pha

        lda #%10000000
        sta Storage.Render.ScreenChanged

        tya
        asl
        tay
        lda gameData.LookUps.ThirtyTwoTimes,y
        clc
        adc #<ScreenRam
        sta ScreenLocation
        iny
        lda gameData.LookUps.ThirtyTwoTimes,y
        adc #>ScreenRam
        sta ScreenLocation + 1

        txa
        tay
        pla
        sta (ScreenLocation),y
        rts
    }

    RotateConveyorBelt:
    {
        // World Conveyor Chars
        addressRegister(0,worldConveyor*CharY,2,0)
        addressRegister(1,worldConveyor*CharY,2,0)

        ldx Storage.Render.m_level
        lda gameData.conveyorDirections,x
        sta Direction

        lda Direction: #$00
        bpl !WorkBackwards+

        lda VERADATA0
        asl
        adc #0
        asl
        adc #0
        sta VERADATA1

        lda VERADATA0
        lsr
        bcc !ByPass+
        ora #128
    !ByPass:
        lsr
        bcc !ByPass+
        ora #128
    !ByPass:
        sta VERADATA1
        bra !Exit+

    !WorkBackwards:

        lda VERADATA0
        lsr
        bcc !ByPass+
        ora #128
    !ByPass:
        lsr
        bcc !ByPass+
        ora #128
    !ByPass:
        sta VERADATA1

        lda VERADATA0
        asl
        adc #0
        asl
        adc #0
        sta VERADATA1

    !Exit:
        rts
    }

    CycleColourFifteenColourPallet:
    {
        addressRegister(0,(VRAMPalette + (15*2)),1,0)
        addressRegister(1,(VRAMPalette + (15*2)),1,0)

        lda VERADATA0
        clc
        adc #$13
        sta VERADATA1

        lda VERADATA0
        clc
        adc #$03
        sta VERADATA1
        rts
    }
}
