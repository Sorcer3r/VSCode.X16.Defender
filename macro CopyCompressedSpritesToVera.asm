in Macros add

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

    addressRegisterFromAddr(1,1,decompress_dst,1,0)
copy_loop:
    lda VERADATA1
    sta VERADATA0
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
// rts                 ; not needed since in macro
}

========================================
in manicminer.asm 

SpriteData:
{
// #import "Assets/Sprites.asm"
// #import "Assets/Enemies.asm"
// #import "Assets/Doors.asm"
#import "Assets\compsprites.asm"
}

=================
in gameLogic.asm 

//copyDataToVera(SpriteData,SpriteMemoryAddr,_SpriteData-SpriteData)
CopyCompressedSpritesToVera()

