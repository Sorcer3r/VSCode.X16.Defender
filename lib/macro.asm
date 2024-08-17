// macro files
#importonce

veraAddr: .byte 0,0,0,0

.macro addressRegister(control,address,increment,direction) {
	
	.if (control == 0){
        // CTRL Bit 0 Controls which Data Byte to use,
        // either DATA0 or DATA1 respectively

        // using DATA0
        lda VERACTRL
        and #%11111110
		sta VERACTRL
	} else {
        // using DATA1
        lda VERACTRL
		ora #$01
		sta VERACTRL
	}

	lda #address
	sta VERAAddrLow

	lda #address>>8
	sta VERAAddrHigh
	
	lda #(increment<<4 ) | address>>16 | direction<<3
	sta VERAAddrBank

}

.macro addressRegisterFromAddr(control,bit16,addrAddress,increment,direction) {
	
	.if (control == 0){
        // CTRL Bit 0 Controls which Data Byte to use,
        // either DATA0 or DATA1 respectively

        // using DATA0
        lda VERACTRL
        and #%11111110
		sta VERACTRL
	} else {
        // using DATA1
        lda VERACTRL
		ora #$01
		sta VERACTRL
	}

	lda addrAddress
	sta VERAAddrLow

	lda addrAddress + 1
	sta VERAAddrHigh
	
	lda #(increment<<4 ) | bit16 | direction<<3
	sta VERAAddrBank

}

.macro break(){
    .byte $db
}

.macro skip1Byte() {  // 2 byte nop 65c02
    .byte $24  // $42 etc dont work in emulator
}

.macro skip2Bytes() {  // 3 byte nop 65c02
    .byte  $2c  // $dc and $fc dont work in emulater
}

.macro resetVera() {
	
    lda #$80
    sta VERACTRL
}

.macro backupVeraAddrInfo()
{
    lda VERAAddrLow
    //sta veraAddr + 1
    pha
    lda VERAAddrHigh
    //sta veraAddr + 2
    pha
    lda VERAAddrBank
    //sta veraAddr + 3
    pha
    lda VERACTRL
    //sta veraAddr
    pha
}

.macro restoreVeraAddrInfo()
{
    pla
    //lda veraAddr
    sta VERACTRL
    pla
    //lda veraAddr + 3
    sta VERAAddrBank
    pla
    //lda veraAddr + 2
    sta VERAAddrHigh
    pla
    //lda veraAddr + 1
    sta VERAAddrLow
}

.macro backupVERAForIRQ()
{
    backupVeraAddrInfo()
    eor #%00000001
    sta VERACTRL
    backupVeraAddrInfo()
}

.macro restoreVERAForIRQ()
{
    restoreVeraAddrInfo()
    restoreVeraAddrInfo()
}

.macro setDCSel(dcSel)
 {
    pha
    lda VERACTRL
    and #%10000001
    ora #dcSel<<1
    sta VERACTRL
    pla
 }

.macro setAddrSel(addrSel)
 {
    pha
    lda VERACTRL
    and #%11111110
    ora #addrSel
    sta VERACTRL
    pla
 }

 .macro copyVERAData(source,destination,bytecount)
{
    // source greater than dest - regular copy
    .if (source > destination) {
    addressRegister(0,source,1,0)
    addressRegister(1,destination,1,0)
    } else {
    // source below dest - do backwards starting at end
    addressRegister(0,source + bytecount,1,1)
    addressRegister(1,destination + bytecount,1,1)
    }
    ldy #bytecount
copyloop:
    lda VERADATA0
 	sta VERADATA1
 	dey
 	bpl copyloop
}


.macro copyDataToVera(source,destination,bytecount) 
// source is x16 memory . dest is vera location, bytecount max 65535
// destroys a
{
    addressRegister(0,destination,1,0)
    lda counter: $deaf
    lda #bytecount & $ff
    sta counter
    lda #(bytecount >> 8) & $ff
    sta counter+1
    lda #source & $ff
    sta copyFrom
    lda #(source >>8) & $ff
    sta copyFrom + 1

    loop:
    lda copyFrom: $deaf
    sta VERADATA0
    inc copyFrom
    bne skip1
    inc copyFrom+1
skip1:
    dec counter
    bne loop
    dec counter+1
    bpl loop
}

.macro setUpSpriteInVera(SpriteNumber, SpriteAddress, Mode, XPos, YPos, ZDepth, Height, Width, PalletOffset)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda #<(SpriteAddress>>5)
    sta VERADATA0
    lda #>(SpriteAddress>>5) | Mode
    sta VERADATA0

    lda #<XPos
    sta VERADATA0
    lda #>XPos
    sta VERADATA0

    lda #<YPos
    sta VERADATA0
    lda #>YPos
    sta VERADATA0

    lda #ZDepth
    sta VERADATA0

    lda #Height | Width | PalletOffset
    sta VERADATA0

}

.macro setUpSpriteInVeraWithCol(SpriteNumber, SpriteAddress, Mode, XPos, YPos, ZDepth, Height, Width, PalletOffset, ColMask)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda #<(SpriteAddress>>5)
    sta VERADATA0
    lda #>(SpriteAddress>>5) | Mode
    sta VERADATA0

    lda #<XPos
    sta VERADATA0
    lda #>XPos
    sta VERADATA0

    lda #<YPos
    sta VERADATA0
    lda #>YPos
    sta VERADATA0

    lda #ZDepth | (ColMask << 4)
    sta VERADATA0

    lda #Height | Width | PalletOffset
    sta VERADATA0

}

.macro setUpSpriteInVera2(addrSpriteNumber, addSpriteInitFrame, addrSpriteTableLo, addrSpriteTableHi, Mode, addrXPos, addrYPos, ZDepth, Height, Width, PalletOffset)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    stz VERAAddrHigh
    lda addrSpriteNumber
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
	sta VERAAddrLow

    lda VERAAddrHigh
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    ldy addSpriteInitFrame
    lda addrSpriteTableLo,y
    sta VERADATA0
    lda addrSpriteTableHi,y
    ora #Mode
    sta VERADATA0

    lda addrXPos
    clc
    adc #dimSpriteOffsetX
    sta VERADATA0
    lda #0
    adc #0
    sta VERADATA0

    lda addrYPos
    clc
    adc #dimSpriteOffsetY
    sta VERADATA0
    lda #0
    sta VERADATA0

    lda #ZDepth
    sta VERADATA0

    lda #Height | Width | PalletOffset
    sta VERADATA0

}

.macro setUpSpriteInVera2WithCol(addrSpriteNumber, addSpriteInitFrame, addrSpriteTableLo, addrSpriteTableHi, Mode, addrXPos, addrYPos, ZDepth, Height, Width, PalletOffset, addrColMask)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    stz VERAAddrHigh
    lda addrSpriteNumber
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
	sta VERAAddrLow

    lda VERAAddrHigh
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    ldy addSpriteInitFrame
    lda addrSpriteTableLo,y
    sta VERADATA0
    lda addrSpriteTableHi,y
    ora #Mode
    sta VERADATA0

    lda addrXPos
    clc
    adc #dimSpriteOffsetX
    sta VERADATA0
    lda #0
    adc #0
    sta VERADATA0

    lda addrYPos
    clc
    adc #dimSpriteOffsetY
    sta VERADATA0
    lda #0
    sta VERADATA0

    lda addrColMask
    asl
    asl
    asl
    asl
    ora #ZDepth
    sta VERADATA0

    lda #Height | Width | PalletOffset
    sta VERADATA0
}

.macro moveSpriteInVera(SpriteNumber, XPosAddr, YPosAddr)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)+ SPRITE_POSITION_X_LO_OFFSET
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda XPosAddr
    sta VERADATA0
    lda XPosAddr+1
    sta VERADATA0

    lda YPosAddr
    sta VERADATA0
    lda YPosAddr + 1
    sta VERADATA0

}

.macro moveSpriteInVeraAddr(SpriteNumberAddr, XPosAddr, YPosAddr)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    stz VERAAddrHigh
    lda SpriteNumberAddr
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
	sta VERAAddrLow

    lda VERAAddrHigh
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda XPosAddr
    sta VERADATA0
    lda XPosAddr+1
    sta VERADATA0

    lda YPosAddr
    sta VERADATA0
    lda YPosAddr + 1
    sta VERADATA0

}

.macro setSpriteAddressInVera(SpriteNumber, SpriteAddress, Mode)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda #<(SpriteAddress>>5)
    sta VERADATA0
    lda #>(SpriteAddress>>5) | Mode
    sta VERADATA0

}

.macro setSpriteAddressInVeraByTable(SpriteNumber, addrFrameNo, addrSpriteTableLo, addrSpriteTableHi, Mode)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    lda addrFrameNo
    tay
    lda addrSpriteTableLo,y
    sta VERADATA0
    lda addrSpriteTableHi,y
    ora #Mode
    sta VERADATA0
}

.macro setSpriteFlip(SpriteNumber, Horizonal, Vertical)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

    clc
	lda VERAAddrLow
    adc #$06
	sta VERAAddrLow
	lda VERAAddrHigh
    adc #0
	sta VERAAddrHigh

	lda #%00000001
	sta VERAAddrBank

    lda VERADATA0
    and #%11111100
    ora #Vertical<<1
    ora #Horizonal
    sta VERADATA0
}

.macro setSpriteFlip2(addrSpriteNumber, Horizonal, Vertical)
{
    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    stz VERAAddrHigh
    lda addrSpriteNumber
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
    asl
    rol VERAAddrHigh
	sta VERAAddrLow

    lda VERAAddrHigh
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh
    
    clc
	lda VERAAddrLow
    adc #$06
	sta VERAAddrLow
	lda VERAAddrHigh
    adc #0
	sta VERAAddrHigh

	lda #%00000001
	sta VERAAddrBank

    lda VERADATA0
    and #%11111100
    ora #Vertical<<1
    ora #Horizonal
    sta VERADATA0
}

.macro SetCharacterAddress(CharBaseAddress)
{
    lda VERA_L1_tilebase
    and #%00000011
    ora #>CharBaseAddress
    sta VERA_L1_tilebase
}

.macro SetUpPSGVoice(VoiceNo, Volume, WaveForm)
{
    addressRegister(0, VERA_PSG_VOICE00 + (VoiceNo * 4) + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | Volume
    sta VERADATA0

    lda #WaveForm | $3F // All Other Sound Effects
    sta VERADATA0
}

.macro PlayNote(VoiceNo, addrNote)
{
    addressRegister(0, VERA_PSG_VOICE00 + (VoiceNo * 4) + VERA_PSG_FREQLO_OFFSET,1,0)
    lda addrNote
    sta VERADATA0
    lda addrNote + 1
    sta VERADATA0
}

.macro StopPSGVoice(VoiceNo)
{
    addressRegister(0, VERA_PSG_VOICE00 + (VoiceNo * 4) + VERA_PSG_VOLUME_OFFSET,1,0)

    lda #VERA_PSG_STEREO_BOTH | %00000000
    sta VERADATA0
}

.macro CopyCompressedSpritesToVera(){
    .label decompress_src = ZPStorage.TempByte1
    .label decompress_dst = ZPStorage.TempByte3
    .label decompress_tmp = ZPStorage.TempByte5

    addressRegister(0,$10000,1,0)
    lda #<SpriteData
    sta decompress_src
    lda #>SpriteData
    sta decompress_src+1

	ldx #0                  // (zp,x) will be used to access (zp,0)
for:
    setAddrSel(0)
	lda (decompress_src,x)  // next control byte
	beq done                // 0 signals end of decompression
	bpl copy_raw            // msb=0 means just copy this many bytes from source
	clc
	adc #$80 + 2            // flip msb, then add 2, we wont request 0 or 1 as that wouldn't save anything
	sta decompress_tmp      // count of bytes to copy (>= 2)
	ldy #1                  // byte after control is offset
	lda (decompress_src),y  // offset from current src - 256
	tay
		lda decompress_src  // advance src past the control byte and offset
		clc
		adc #2
		sta decompress_src
		bcc !+
		inc decompress_src+1
	!:
copy_previous:              // copy tmp bytes from dst - 256 + offset
// set veradata1 to current veradata0 - 256 + y
    sty decompress_tmp+1
    lda VERAAddrHigh
    dec
    sta decompress_dst+1
    lda VERAAddrLow
    clc
    adc decompress_tmp+1
    sta decompress_dst
    lda decompress_dst+1
    adc #0
    sta decompress_dst+1

    addressRegisterFromAddr(1,1,decompress_dst,0,0)
copy_loop:
    lda decompress_dst      // update veradata1 Low address manually so that
    sta VERAAddrLow         // data1 gets refreshed!
    lda decompress_dst+1    // and the High address
    sta VERAAddrHigh        // incase we passed page boundary
    lda VERADATA1
    sta VERADATA0
    inc decompress_dst 
	bne !+
	inc decompress_dst+1
!:
    dec decompress_tmp      // count down bytes to copy
	bne copy_loop
	beq for                 // after copying, go back for next control byte

copy_raw:
	tay                     // bytes to copy from src
copy:
		inc decompress_src  // INC src (1st time past control byte)
		bne !+
		inc decompress_src+1
	!:
	dey
	bmi for
	lda (decompress_src,x)  // copy bytes
	sta VERADATA0   //
	bra copy        // rest of bytes 
done:
// on exit X=A=0
// rts                 ; must add an RTS
}
