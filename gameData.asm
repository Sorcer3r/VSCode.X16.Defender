#importonce 
#import "GameContants.asm"

.namespace gameData {
    
    Screens:
    {
        Level01:
        {
            .byte $68, $03, $84, $00, $60, $82, $00, $06, $86, $00, $30, $03
            .byte $8e, $00, $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $03
            .byte $8a, $00, $50, $00, $50, $00, $30, $13, $86, $11, $82, $44
            .byte $41, $44, $14, $83, $11, $31, $03, $8e, $00, $30, $13, $11
            .byte $8d, $00, $30, $03, $87, $00, $30, $33, $50, $84, $00, $30
            .byte $13, $11, $01, $00, $8a, $77, $00, $30, $03, $8d, $00, $10
            .byte $31, $03, $8e, $00, $30, $03, $85, $00, $05, $83, $00, $33
            .byte $43, $82, $44, $11, $31, $03, $00, $10, $87, $11, $85, $00
            .byte $30, $03, $8e, $00, $30, $13, $8e, $11, $31 
        }

        Level02:
        {
            .byte $77, $03, $88, $00, $30, $86, $33, $03, $8e, $00, $36, $03
            .byte $8e, $00, $30, $03, $89, $00, $40, $44, $01, $82, $00, $30
            .byte $03, $8e, $00, $30, $13, $89, $11, $84, $00, $03, $30, $03
            .byte $89, $00, $10, $11, $31, $44, $03, $30, $13, $82, $44, $04
            .byte $88, $00, $30, $00, $03, $30, $03, $8b, $00, $30, $44, $03
            .byte $30, $03, $83, $00, $10, $83, $11, $84, $00, $30, $44, $03
            .byte $30, $03, $88, $00, $40, $44, $04, $30, $44, $03, $30, $03
            .byte $70, $77, $07, $88, $00, $30, $44, $03, $30, $03, $86, $00
            .byte $82, $11, $83, $00, $30, $44, $03, $30, $03, $83, $00, $82
            .byte $44, $89, $00, $30, $03, $8e, $00, $30, $13, $8e, $11, $31
        }

        Level03:
        {
            .byte $66, $03, $84, $00, $06, $83, $00, $02, $83, $00, $60, $00
            .byte $30, $03, $88, $00, $06, $85, $00, $30, $03, $8e, $00, $30
            .byte $03, $8e, $00, $30, $03, $8e, $00, $30, $13, $11, $41, $8c
            .byte $44, $34, $03, $8e, $00, $30, $13, $82, $11, $01, $89, $00
            .byte $10, $11, $31, $23, $8e, $00, $30, $23, $82, $00, $83, $77
            .byte $89, $00, $30, $23, $8b, $00, $10, $82, $11, $31, $63, $86
            .byte $00, $82, $11, $01, $85, $00, $30, $03, $00, $10, $82, $11
            .byte $01, $89, $00, $30, $03, $89, $00, $10, $84, $11, $31, $03
            .byte $8e, $00, $30, $13, $8e, $11, $31
            }

        Level04:
        {
            .byte $77, $03, $82, $00, $60, $83, $00, $89, $33, $03, $8e, $00
            .byte $30, $03, $8e, $00, $30, $03, $88, $00, $10, $82, $11, $01
            .byte $82, $00, $30, $03, $8c, $00, $10, $11, $31, $13, $82, $00
            .byte $10, $84, $00, $10, $86, $00, $30, $03, $85, $00, $11, $83
            .byte $00, $10, $11, $83, $00, $30, $43, $44, $8d, $00, $30, $03
            .byte $82, $00, $10, $01, $88, $00, $11, $01, $30, $03, $88, $00
            .byte $11, $01, $84, $00, $30, $73, $77, $8d, $00, $31, $03, $85
            .byte $00, $11, $01, $83, $00, $11, $01, $82, $00, $30, $03, $82
            .byte $00, $11, $87, $00, $60, $82, $00, $11, $31, $03, $88, $00
            .byte $11, $85, $00, $30, $03, $8e, $00, $30, $13, $8e, $11, $31
        }

        Level05:
        {
            .byte $79, $03, $89, $00, $06, $84, $00, $30, $03, $8e, $00, $30
            .byte $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $8b, $00, $05
            .byte $82, $00, $30, $13, $86, $11, $82, $00, $82, $44, $83, $11
            .byte $00, $30, $03, $8d, $00, $10, $31, $03, $89, $00, $50, $84
            .byte $00, $30, $03, $88, $00, $85, $77, $00, $30, $03, $00, $85
            .byte $11, $88, $00, $30, $03, $8e, $00, $30, $43, $14, $85, $11
            .byte $82, $00, $83, $11, $01, $82, $00, $31, $03, $83, $00, $03
            .byte $8a, $00, $30, $13, $01, $82, $00, $03, $82, $00, $03, $30
            .byte $86, $00, $30, $03, $00, $50, $00, $03, $82, $00, $03, $30
            .byte $83, $33, $55, $82, $00, $30, $13, $83, $11, $88, $33, $83
            .byte $11, $31
        }

        Level06:
        {
            .byte $72, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $8e, $00
            .byte $30, $03, $8e, $00, $30, $03, $89, $00, $60, $84, $00, $30
            .byte $03, $83, $00, $11, $01, $00, $10, $01, $00, $10, $82, $11
            .byte $82, $00, $30, $03, $10, $01, $85, $00, $03, $85, $00, $11
            .byte $31, $03, $87, $00, $03, $86, $00, $30, $03, $8a, $00, $10
            .byte $82, $11, $00, $30, $13, $01, $8d, $00, $30, $03, $82, $00
            .byte $10, $84, $11, $13, $84, $11, $82, $00, $30, $03, $87, $00
            .byte $63, $86, $00, $30, $03, $50, $86, $00, $03, $85, $00, $11
            .byte $31, $03, $70, $77, $07, $87, $00, $11, $83, $00, $30, $03
            .byte $8e, $00, $30, $13, $8e, $11, $31
        }

        Level07:
        {
            .byte $81, $03, $86, $00, $89, $33, $03, $8e, $00, $30, $03, $8e
            .byte $00, $30, $03, $86, $00, $10, $31, $86, $44, $30, $03, $87
            .byte $00, $30, $86, $44, $34, $03, $82, $00, $70, $82, $77, $00
            .byte $11, $31, $85, $44, $46, $34, $13, $11, $86, $00, $30, $44
            .byte $40, $84, $44, $34, $03, $87, $00, $30, $84, $44, $04, $44
            .byte $34, $13, $87, $00, $30, $82, $44, $64, $83, $44, $34, $03
            .byte $86, $00, $11, $31, $86, $44, $34, $13, $85, $11, $82, $00
            .byte $30, $04, $84, $44, $46, $34, $03, $87, $00, $30, $86, $44
            .byte $30, $03, $86, $00, $82, $33, $82, $44, $64, $83, $44, $34
            .byte $03, $83, $00, $10, $11, $00, $03, $87, $00, $30, $03, $86
            .byte $00, $03, $87, $00, $30, $13, $86, $11, $89, $33
        }

        Level08:
        {
            .byte $a2, $03, $06, $83, $00, $06, $82, $00, $30, $00, $03, $84
            .byte $00, $30, $03, $87, $00, $30, $00, $03, $84, $00, $30, $03
            .byte $86, $00, $10, $31, $85, $00, $10, $31, $03, $87, $00, $30
            .byte $86, $00, $30, $03, $87, $00, $30, $86, $00, $30, $13, $11
            .byte $82, $00, $10, $82, $11, $01, $30, $11, $85, $00, $30, $03
            .byte $87, $00, $30, $00, $10, $11, $01, $82, $00, $31, $03, $11
            .byte $01, $85, $00, $30, $84, $00, $10, $00, $30, $03, $83, $00
            .byte $11, $01, $82, $00, $30, $86, $00, $30, $03, $87, $00, $30
            .byte $82, $11, $01, $83, $00, $30, $13, $85, $00, $11, $01, $30
            .byte $84, $00, $10, $11, $31, $03, $83, $00, $10, $01, $82, $00
            .byte $30, $86, $00, $30, $03, $00, $11, $85, $00, $30, $82, $00
            .byte $82, $11, $01, $00, $30, $03, $84, $00, $70, $77, $03, $30
            .byte $11, $85, $00, $30, $03, $86, $00, $03, $30, $82, $00, $50
            .byte $83, $00, $30, $13, $8e, $11, $31
        }

        Level09:
        {
            .byte $63, $03, $30, $8d, $00, $30, $03, $8e, $00, $30, $03, $8e
            .byte $00, $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $13, $11
            .byte $01, $10, $11, $00, $84, $11, $00, $11, $01, $10, $01, $30
            .byte $03, $8e, $00, $30, $03, $8d, $00, $10, $31, $03, $10, $01
            .byte $10, $11, $00, $84, $77, $85, $00, $30, $03, $8a, $00, $11
            .byte $01, $10, $01, $30, $13, $01, $8d, $00, $30, $03, $8e, $00
            .byte $30, $03, $10, $01, $10, $11, $00, $84, $11, $00, $11, $01
            .byte $10, $01, $30, $03, $8d, $00, $10, $31, $03, $8e, $00, $30
            .byte $13, $8e, $11, $31
        }

        Level10:
        {
            .byte $91, $03, $84, $00, $60, $10, $11, $03, $06, $16, $84, $11
            .byte $31, $03, $87, $00, $03, $00, $60, $84, $00, $30, $13, $82
            .byte $11, $01, $84, $00, $03, $84, $00, $10, $11, $31, $03, $60
            .byte $86, $00, $03, $86, $00, $30, $03, $87, $00, $13, $11, $01
            .byte $84, $00, $30, $03, $83, $00, $41, $83, $44, $03, $82, $00
            .byte $10, $83, $11, $31, $13, $11, $01, $85, $00, $03, $86, $00
            .byte $30, $03, $87, $00, $13, $83, $11, $44, $04, $00, $30, $13
            .byte $82, $11, $85, $00, $03, $86, $00, $30, $63, $83, $00, $10
            .byte $83, $11, $03, $85, $00, $10, $31, $13, $11, $41, $04, $84
            .byte $00, $13, $83, $11, $83, $00, $36, $03, $87, $00, $03, $82
            .byte $00, $60, $44, $04, $00, $30, $03, $83, $00, $85, $22, $86
            .byte $00, $30, $13, $11, $8c, $00, $11, $31, $03, $8e, $00, $30
            .byte $90, $22
        }

        Level11:
        {
            .byte $82, $83, $33, $03, $85, $00, $60, $85, $00, $30, $03, $88
            .byte $00, $50, $85, $00, $30, $03, $8e, $00, $30, $13, $11, $01
            .byte $8c, $00, $30, $03, $8e, $00, $30, $03, $00, $10, $82, $11
            .byte $01, $00, $10, $21, $83, $22, $11, $82, $00, $30, $03, $8b
            .byte $00, $06, $00, $10, $31, $03, $8b, $00, $06, $82, $00, $30
            .byte $13, $01, $70, $07, $88, $00, $06, $00, $10, $31, $03, $84
            .byte $00, $10, $84, $11, $82, $00, $05, $82, $00, $30, $03, $85
            .byte $00, $06, $82, $00, $60, $84, $00, $01, $30, $03, $82, $00
            .byte $44, $14, $00, $06, $82, $00, $50, $85, $00, $30, $03, $85
            .byte $00, $05, $87, $00, $11, $31, $13, $01, $89, $00, $10, $11
            .byte $82, $00, $30, $03, $8e, $00, $30, $13, $8e, $11, $31
        }

        Level12:
        {
            .byte $98, $03, $06, $83, $00, $06, $82, $00, $30, $00, $30, $84
            .byte $00, $30, $03, $8e, $00, $30, $03, $86, $00, $40, $04, $86
            .byte $00, $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $13, $11
            .byte $82, $00, $40, $82, $44, $03, $30, $83, $44, $11, $82, $00
            .byte $30, $03, $86, $00, $03, $30, $86, $00, $31, $03, $82, $00
            .byte $11, $83, $00, $03, $30, $86, $00, $30, $03, $10, $85, $00
            .byte $03, $30, $83, $00, $10, $82, $11, $31, $03, $84, $00, $82
            .byte $11, $03, $30, $86, $00, $30, $03, $82, $00, $01, $84, $00
            .byte $30, $11, $01, $84, $00, $30, $03, $87, $00, $30, $83, $00
            .byte $10, $01, $00, $30, $13, $82, $11, $01, $84, $00, $30, $82
            .byte $00, $50, $82, $00, $05, $30, $03, $84, $00, $10, $11, $03
            .byte $30, $85, $77, $07, $30, $03, $86, $00, $03, $30, $86, $00
            .byte $30, $13, $86, $11, $82, $33, $86, $11, $31
        }

        Level13:
        {
            .byte $74, $90, $33, $03, $20, $8d, $00, $30, $03, $20, $8d, $00
            .byte $30, $03, $20, $00, $10, $88, $11, $01, $10, $11, $31, $03
            .byte $20, $8d, $00, $30, $03, $20, $8d, $00, $30, $03, $20, $00
            .byte $10, $01, $10, $11, $01, $10, $82, $11, $00, $82, $11, $00
            .byte $31, $03, $20, $8d, $00, $30, $03, $20, $8d, $00, $30, $03
            .byte $20, $00, $10, $82, $11, $00, $11, $01, $00, $82, $11, $01
            .byte $10, $11, $31, $03, $20, $8d, $00, $30, $03, $20, $8d, $00
            .byte $30, $03, $20, $00, $10, $11, $00, $11, $01, $10, $11, $01
            .byte $10, $11, $01, $10, $31, $03, $20, $8d, $00, $30, $03, $20
            .byte $8d, $00, $30, $13, $71, $8c, $77, $17, $31
        }

        Level14:
        {
            .byte $72, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $8e, $00
            .byte $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $86, $00
            .byte $10, $02, $86, $00, $30, $03, $10, $02, $82, $00, $10, $02
            .byte $82, $00, $10, $02, $82, $00, $10, $02, $30, $03, $82, $00
            .byte $10, $02, $86, $00, $10, $02, $82, $00, $30, $03, $8e, $00
            .byte $30, $03, $00, $10, $02, $82, $00, $10, $02, $82, $00, $10
            .byte $02, $82, $00, $10, $32, $03, $8e, $00, $30, $13, $02, $82
            .byte $00, $10, $02, $00, $70, $82, $77, $07, $00, $10, $02, $00
            .byte $30, $03, $8e, $00, $30, $03, $82, $00, $10, $02, $8a, $00
            .byte $30, $03, $8e, $00, $30, $90, $33
        }

        Level15:
        {
            .byte $79, $03, $82, $00, $8d, $33, $03, $8d, $00, $20, $32, $03
            .byte $8d, $00, $20, $32, $03, $83, $00, $88, $77, $82, $11, $21
            .byte $32, $03, $83, $00, $06, $89, $00, $26, $32, $13, $82, $11
            .byte $00, $05, $89, $00, $26, $32, $03, $8b, $00, $11, $00, $26
            .byte $32, $03, $82, $00, $40, $82, $00, $11, $87, $00, $26, $32
            .byte $03, $10, $01, $86, $00, $11, $84, $00, $26, $32, $03, $8b
            .byte $00, $10, $01, $26, $32, $13, $01, $84, $00, $11, $87, $00
            .byte $25, $32, $03, $88, $00, $11, $84, $00, $20, $32, $03, $00
            .byte $10, $11, $87, $00, $10, $01, $00, $20, $32, $03, $85, $00
            .byte $11, $87, $00, $20, $32, $03, $8d, $00, $20, $32, $13, $8e
            .byte $11, $31
        }

        Level16:
        {
            .byte $75, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $8e, $00
            .byte $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $13, $82, $00
            .byte $01, $00, $30, $00, $03, $83, $00, $11, $01, $82, $00, $30
            .byte $03, $84, $00, $30, $00, $33, $87, $00, $30, $03, $00, $01
            .byte $82, $00, $30, $00, $33, $03, $83, $00, $10, $82, $11, $31
            .byte $03, $84, $00, $30, $00, $82, $33, $86, $00, $30, $43, $74
            .byte $8b, $77, $07, $00, $30, $03, $8e, $00, $30, $03, $84, $00
            .byte $33, $11, $86, $00, $01, $00, $30, $13, $84, $11, $8a, $00
            .byte $30, $03, $89, $00, $01, $82, $00, $01, $00, $30, $03, $8a
            .byte $00, $50, $55, $82, $00, $30, $13, $8e, $11, $31
        }

        Level17:
        {
            .byte $9d, $03, $8d, $00, $30, $33, $03, $8e, $00, $30, $03, $8e
            .byte $00, $30, $03, $8e, $00, $30, $03, $82, $00, $05, $50, $00
            .byte $50, $00, $05, $82, $00, $82, $05, $82, $00, $30, $13, $41
            .byte $83, $44, $00, $83, $44, $04, $40, $44, $40, $04, $10, $31
            .byte $43, $64, $83, $44, $00, $83, $44, $04, $40, $82, $44, $04
            .byte $40, $34, $43, $84, $44, $00, $44, $04, $44, $04, $40, $82
            .byte $44, $06, $40, $34, $43, $04, $40, $82, $44, $00, $44, $82
            .byte $77, $07, $40, $82, $44, $04, $40, $34, $03, $04, $40, $82
            .byte $44, $00, $83, $44, $04, $40, $82, $44, $04, $40, $34, $43
            .byte $04, $40, $82, $44, $00, $83, $44, $04, $44, $46, $44, $04
            .byte $40, $34, $43, $04, $40, $44, $64, $00, $87, $44, $00, $40
            .byte $34, $43, $04, $40, $82, $44, $00, $87, $44, $04, $40, $34
            .byte $03, $8e, $00, $30, $03, $8c, $00, $10, $11, $31, $13, $8e
            .byte $11, $31
        }

        Level18:
        {
            .byte $61, $03, $8d, $00, $03, $30, $03, $8e, $00, $30, $03, $8e
            .byte $00, $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $10
            .byte $01, $10, $11, $00, $84, $11, $00, $11, $01, $10, $11, $31
            .byte $03, $8e, $00, $30, $13, $01, $8d, $00, $30, $03, $85, $00
            .byte $84, $11, $00, $11, $01, $10, $01, $30, $03, $10, $01, $10
            .byte $11, $8a, $00, $30, $03, $8d, $00, $10, $31, $03, $8e, $00
            .byte $30, $03, $10, $01, $10, $11, $00, $84, $11, $00, $11, $01
            .byte $10, $01, $30, $13, $01, $8d, $00, $30, $03, $8e, $00, $30
            .byte $90, $11
        }

        Level19:
        {
            .byte $6b, $33, $03, $8d, $00, $30, $03, $8e, $00, $30, $03, $8e
            .byte $00, $30, $03, $8e, $00, $30, $03, $8e, $00, $30, $03, $10
            .byte $01, $00, $10, $82, $11, $01, $84, $00, $83, $11, $31, $03
            .byte $8e, $00, $30, $03, $88, $00, $10, $11, $84, $00, $30, $13
            .byte $01, $84, $00, $10, $11, $84, $00, $83, $11, $31, $03, $8e
            .byte $00, $30, $03, $88, $00, $10, $01, $84, $00, $30, $13, $11
            .byte $01, $89, $00, $83, $11, $31, $03, $82, $00, $70, $77, $07
            .byte $00, $82, $11, $01, $85, $00, $30, $03, $8e, $00, $30, $33
            .byte $03, $8d, $00, $30, $33, $13, $89, $11, $31, $83, $11, $31
        }

        Level20:
        {
            .byte $48, $d9, $33, $03, $30, $84, $00, $30, $89, $33, $03, $30
            .byte $84, $00, $30, $89, $33, $03, $30, $84, $00, $30, $03, $8d
            .byte $00, $10, $31, $03, $8e, $00, $30, $73, $8a, $77, $07, $00
            .byte $04, $00, $30, $03, $83, $00, $50, $00, $05, $00, $50, $00
            .byte $50, $83, $00, $01, $30, $13, $01, $8d, $00, $30, $03, $00
            .byte $10, $01, $8b, $00, $30, $03, $8e, $00, $30, $13, $8e, $11
            .byte $31
        }

        LookUps:
        {
            .word Level01
            .word Level02
            .word Level03
            .word Level04
            .word Level05
            .word Level06
            .word Level07
            .word Level08
            .word Level09
            .word Level10
            .word Level11
            .word Level12
            .word Level13
            .word Level14
            .word Level15
            .word Level16
            .word Level17
            .word Level18
            .word Level19
            .word Level20
        }

        levelColour:
        {
    // door (9) ═════════════════════════════════════════════════════════════════════════════╕
    // border (8) ══════════════════════════════════════════════════════════════════════╕    │
    // conveyor (7) ════════════════════════════════════════════════════════════╕       │    │
    // rock (6) ════════════════════════════════════════════════════════╕       │       │    │
    // bush (5) ════════════════════════════════════════════════╕       │       │       │    │
    // collapse (4) ════════════════════════════════════╕       │       │       │       │    │
    // wall (3) ════════════════════════════╕           │       │       │       │       │    │
    // special (2) ═════════════════╕       │           │       │       │       │       │    │
    // ground (1) ══════════╕       │       │           │       │       │       │       │    │
    // bckgrd (0) ══╕       │       │       │           │       │       │       │       │    │
            .byte   BLACK,  RED,    BLACK,  YELLOW,     RED,    GREEN,  CYAN,   GREEN,  RED, BLUE   // Level 0
            .byte   BLUE,   PURPLE, PURPLE, YELLOW,     PURPLE, GREEN,  CYAN,   YELLOW, RED, RED    // Level 1
            .byte   BLACK,  CYAN,   PURPLE, CYAN,       CYAN,   YELLOW, PURPLE, RED,    RED, BLUE   // Level 2 
            .byte   BLACK,  YELLOW, BLACK,  BLUE,       YELLOW, GREEN,  CYAN,   PURPLE, RED, BLUE   // Level 3
            .byte   RED,    CYAN,   RED,    LIGHT_GREEN,GREEN,  YELLOW, PURPLE, YELLOW, BLUE,RED    // Level 4
            .byte   BLACK,  GREEN,  BLACK,  YELLOW,     GREEN,  PURPLE, YELLOW, CYAN,   RED, BLUE   // Level 5
            .byte   BLACK,  YELLOW, BLACK,  CYAN,       RED,    CYAN,   YELLOW, GREEN,  RED, BLUE   // Level 6
            .byte   BLACK,  RED,    YELLOW, YELLOW,     RED,    GREEN,  CYAN,   GREEN,  RED, BLUE   // Level 7
            .byte   BLACK,  YELLOW, BLACK,  YELLOW,     RED,    GREEN,  CYAN,   GREEN,  BLUE,BLUE   // Level 8
            .byte   BLACK,  GREEN,  CYAN,   BROWN,      RED,    CYAN,   GREEN,  PURPLE, RED, PURPLE // Level 9
            .byte   BLACK,  BLUE,   CYAN,   DARK_GRAY,  BLUE,   YELLOW, RED,    YELLOW, RED, RED    // Level 10
            .byte   BLACK,  PURPLE, YELLOW, CYAN,       PURPLE, GREEN,  CYAN,   YELLOW, RED, PURPLE // Level 11
            .byte   BLACK,  CYAN,   YELLOW, YELLOW,     RED,    GREEN,  CYAN,   GREEN,  RED, BLUE   // Level 12
            .byte   BLUE,   GREEN,  GREEN,  CYAN,       RED,    BLUE,   BLUE,   PURPLE, RED, PURPLE // Level 13
            .byte   BLACK,  BLUE,   YELLOW, DARK_GRAY,  BLUE,   YELLOW, RED,    CYAN,   RED, RED    // Level 14
            .byte   BLACK,  RED,    YELLOW, CYAN,       RED,    GREEN,  CYAN,   YELLOW, RED, PURPLE // Level 15
            .byte   BLACK,  GREEN,  BLACK,  YELLOW,     GREEN,  YELLOW, BLUE,   GREEN,  RED, BLUE   // Level 16
            .byte   BLACK,  RED,    BLACK,  YELLOW,     RED,    GREEN,  CYAN,   GREEN,  RED, BLUE   // Level 17
            .byte   GREEN,  BLACK,  GREEN,  YELLOW,     RED,    YELLOW, RED,    YELLOW, RED, BLUE   // Level 18
            .byte   BLACK,  RED,    BLACK,  YELLOW,     RED,    GREEN,  RED,    CYAN,   RED, PURPLE // Level 19
        }

        levelCharIndex:
        {
    // key (7) ═════════════════════════════════╕
    // conveyor (6) ════════════════════════╕   │
    // rock (5) ════════════════════════╕   │   │
    // bush (4) ════════════════════╕   │   │   │
    // collapse (3) ════════════╕   │   │   │   │
    // wall (2) ════════════╕   │   │   │   │   │
    // special (1) ═════╕   │   │   │   │   │   │
    // floor (0) ═╕     │   │   │   │   │   │   │
            .byte 49,   0,	31, 39, 13, 40, 28, 9   // Level 0
            .byte 49,	0,	31,	39,	13,	40,	28,	16  // Level 1
            .byte 46,	3,	21,	45,	13,	5,	30,	9   // Level 2 
            .byte 49,	0,	31,	39,	13,	52,	28,	9   // Level 3
            .byte 49,	0,	31,	39,	13,	19,	7,	8   // Level 4
            .byte 47,	0,	31,	49,	13,	11,	28,	9   // Level 5
            .byte 49,	0,	31,	38,	13,	23,	22,	9   // Level 6
            .byte 49,	49,	31,	39,	13,	19,	29,	20  // Level 7
            .byte 49,	0,	24,	39,	13,	19,	7,	9   // Level 8
            .byte 18,	48,	27,	32,	13,	15,	28,	1   // Level 9
            .byte 49,	51,	26,	39,	4,	3,	33,	10  // Level 10
            .byte 49,	49,	31,	39,	13,	19,	29,	20  // Level 11
            .byte 41,	35,	24,	49,	13,	19,	7,	6   // Level 12
            .byte 44,	43,	34,	49,	0,	0,	7,	25  // Level 13
            .byte 50,	42,	26,	39,	4,	3,	33,	17  // Level 14
            .byte 49,	49,	27,	39,	14,	19,	29,	2   // Level 15
            .byte 49,	0,	37,	38,	13,	12,	28,	9   // Level 16
            .byte 49,	0,	36,	39,	13,	19,	28,	9   // Level 17
            .byte 49,	0,	31,	39,	13,	19,	28,	9   // Level 18
            .byte 49,	0,	31,	39,	4,	19,	28,	9   // Level 19
        }

        KeyPositions:
        {
            .byte  9,0, 29,0,   16,1,   24,4,   30,6    // Level 0
            .byte  7,1, 24,1,   26,7,   3,9,    19,12   // Level 1
            .byte  6,0, 15,0,   23,0,   30,6,   21,6    // Level 2
            .byte  1,0, 12,1,   25,1,   16,6,   30,6    // Level 3
            .byte 30,1, 10,6,   29,7,   7,12,   9,12    // Level 4
            .byte 15,6, 17,6,   30,7,   1,10,   13,11   // Level 5
            .byte 30,3, 20,6,   27,7,   19,10,  30,11   // Level 6
            .byte 13,2, 14,6,   2,8,    29,13,  -1,-1   // Level 7
            .byte 16,1, -1,-1,  -1,-1,  -1,-1,  -1,-1   // Level 8
            .byte 21,2, 14,1,   12,6,   18,8,   30,1    // Level 9
            .byte 24,0, 30,1,   1,4,    19,6,   30,13   // Level 10
            .byte 15,3, 16,7,   2,6,    29,13,  26,5    // Level 11
            .byte 26,3, 10,6,   19,9,   26,9,   11,12   // Level 12
            .byte 23,2, 3,8,    27,7,   16,7,   -1,-1   // Level 13
            .byte 25,2, 12,6,   26,14,  -1,-1,  -1,-1   // Level 14
            .byte 30,2, 13,7,   1,0,    17,10,  -1,-1   // Level 15
            .byte 24,5, 15,7,   1,9,    19,10,  26,11   // Level 16
            .byte 16,1, -1,-1,  -1,-1,  -1,-1,  -1,-1   // Level 17
            .byte 30,1, 1,5,    30,12,  -1,-1,  -1,-1   // Level 18
            .byte 23,5, 30,6,   10,11,  14,11,  19,11   // Level 19
        }

        doorValues:
        {
            .byte 29, 13	// Level 0
            .byte 29, 13	// Level 1
            .byte 29, 11	// Level 2
            .byte 29,  1 	// Level 3
            .byte 15, 13	// Level 4
            .byte 29,  0	// Level 5
            .byte 15, 13	// Level 6
            .byte 15, 13	// Level 7
            .byte  1,  0	// Level 8
            .byte 12, 13	// Level 9
            .byte  1,  1	// Level 10
            .byte 15, 13	// Level 11
            .byte  1, 13	// Level 12
            .byte 15,  0	// Level 13
            .byte  1,  3	// Level 14
            .byte 12,  5	// Level 15
            .byte 29,  1	// Level 16
            .byte 29,  0	// Level 17
            .byte  1,  1	// Level 18
            .byte 19,  5	// Level 19
        }

        switchPositions:
        {
            .byte 6,0,  18,0 
        }
    }

    LookUps:
    {
        TenTimes:
        {
            .for(var i=0;i<20;i++)
            {
                .byte i*10
            }
        }

        ThirtyTwoTimes:
        {
            .for(var i=0;i<dimPlayRows;i++)
            {
                .word i*32
            }
        }

        SpriteAddrTable:
        {
            Lo:
            {
                .for(var spNo=0; spNo<145;spNo++)
                {
                    .byte <(SpriteMemoryAddr+(spNo * 128) >> 5)
                }    
            }
            Hi:
            {
                .for(var spNo=0; spNo<145;spNo++)
                {
                    .byte >(SpriteMemoryAddr+(spNo * 128) >> 5)
                }    
            }
        }

        GameStates:
        {
            JumpTableLo:
            {
                .byte <Logic.StartUp
                .byte <Logic.Title
                .byte <Logic.Init
                .byte <Logic.LevelSetUp
                .byte <Logic.Playing
                .byte <Logic.SuckAirMeter
                .byte <Logic.BeatLevel
                .byte <Logic.Died
                .byte <Logic.OutOfLives
                .byte <Logic.Won
                .byte <Logic.Lost
                .byte <Logic.Demo
            }

            JumpTableHi:
            {
                .byte >Logic.StartUp
                .byte >Logic.Title
                .byte >Logic.Init
                .byte >Logic.LevelSetUp
                .byte >Logic.Playing
                .byte >Logic.SuckAirMeter
                .byte >Logic.BeatLevel
                .byte >Logic.Died
                .byte >Logic.OutOfLives
                .byte >Logic.Won
                .byte >Logic.Lost
                .byte >Logic.Demo
            }
        }
    }

    .encoding "petscii_mixed"
    LevelNames:
    {
        .text "         Central Cavern         "	// Level 0
        .text "          The Cold Room         "	// Level 1
        .text "          The Menagerie         "	// Level 2 
        .text "   Abandoned Uranium Workings   "	// Level 3
        .text "         Eugene's Lair          "	// Level 4
        .text "       Processing Plant         "	// Level 5
        .text "            The Vat             "	// Level 6
        .text "Miner Willy meets the Kong Beast"	// Level 7
        .text "        Wacky Amoebatrons       "	// Level 8
        .text "       The Endorian Forest      "	// Level 9
        .text "Attack of the  Mutant Telephones"	// Level 10
        .text " Return of the Alien Kong Beast "	// Level 11
        .text "          Ore Refinery          "	// Level 12
        .text "       Skylab Landing Bay       "	// Level 13
        .text "            The Bank            "	// Level 14
        .text "      The Sixteenth Cavern      "	// Level 15
        .text "         The Warehouse          "	// Level 16
        .text "      Amoebatrons' Revenge      "	// Level 17
        .text "     Solar Power  Generator     "	// Level 18
        .text "        The Final Barrier       "	// Level 19
    }

    Strings:{
    //-------------------------------------------------------------------------
    szIntroText: .text "                                .  .  .  .  .  .  .  .  .  . MANIC MINER . . BUG-BYTE ltd. 1983 . . By Matthew Smith . . . Q to P and A to L = Left & Right . . Bottom row = Jump . . . Guide Miner Willy through 20 lethal caverns   .  .  .  .  .  .  .  .  "
    szThisVersionText: .text " This version by Stefan Wessels"
    szScoreText: .text "High Score 000000   Score 000000"
    .label ScoreStrLen = szGameOverText - szScoreText
    szGameOverText: .text "Game    Over"
    szAir: .text "AIR "
    .label AirStrLen = 4
    }

    spriteData:
    {
        // spriteClass═══════════════════════════════════════════════════════════════════════════════════════╕
        // startEnabled═══════════════════════════════════════════════════════════════════════════════════╕  │
        // startDirection══════════════════════════════════════════════════════════════════════════════╕  │  │
        // colour═══════════════════════════════════════════════════════════════════════════╕          │  │  │
        // spriteAnimationPattern══════════════════════════════════════════╕                │          │  │  │
        // frameIndex═══════════════════════════════════╕                  │                │          │  │  │
        // speed═════════════════════════════════════╕  │                  │                │          │  │  │
        // otherAxis══════════════════════════════╕  │  │                  │                │          │  │  │
        // start═════════════════════════════╕    │  │  │                  │                │          │  │  │
        // max══════════════════════════╕    │    │  │  │                  │                │          │  │  │
        // min═════════════════════╕    │    │    │  │  │                  │                │          │  │  │
        // curLocalStorage════╕    │    │    │    │  │  │                  │                │          │  │  │
        // curEnabled══════╕  │    │    │    │    │  │  │                  │                │          │  │  │
        // curDirection═╕  │  │    │    │    │    │  │  │                  │                │          │  │  │
        // curFrame══╕  │  │  │    │    │    │    │  │  │                  │                │          │  │  │
        // curPos═╕  │  │  │  │    │    │    │    │  │  │                  │                │          │  │  │

        // Level 0
            .byte 0, 0, 0, 0, 0,  60, 122,  60,  56, 2, spriteRobotWalker, spriteFourFrames, YELLOW,   1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0, 232, 232, 232, 104, 0, spriteDoor,        spriteOneFrame,   YELLOW,   0, 0, spClass_Door	
        // Level 1
            .byte 0, 0, 0, 0, 0,   6, 148, 144,  24, 2,  spritePenguin,    spriteThreeFrames, YELLOW,  -1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,  94, 236, 232, 104, 2,  spritePenguin,    spriteThreeFrames, CYAN  ,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 232, 232, 232, 104, 0,  spriteDoor + 1,   spriteOneFrame,    PURPLE,   0, 0, spClass_Door	
        // Level 2
            .byte 0, 0, 0, 0, 0,   8, 156, 152, 104, 2,  spriteChicken,    spriteThreeFrames, GREEN ,  -1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,   8, 132, 128,  24, 2,  spriteChicken,    spriteThreeFrames, PURPLE,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 144, 232, 144,  24, 2,  spriteChicken,    spriteThreeFrames, RED   ,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 232, 232, 232,  88, 0,  spriteDoor + 2,   spriteOneFrame,    YELLOW,   0, 0, spClass_Door	
        // Level 3
            .byte 0, 0, 0, 0, 0,   8,  84,   8, 104, 2,  spriteSealion,    spriteThreeFrames, RED   ,   1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,  48, 124,  56, 104, 2,  spriteSealion,    spriteThreeFrames, GREEN ,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 232, 232, 232,   8, 0,  spriteDoor + 3,   spriteOneFrame,    YELLOW,   0, 0, spClass_Door	
        // Level 4
            .byte 0, 0, 0, 0, 0,   6, 98,  96,  24, 2,  spriteToilet,     spriteThreeFrames, YELLOW,  -1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,  30, 98,  32,  56, 2,  spriteToilet,     spriteThreeFrames, BLACK ,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0,   1,  87,   1, 120, 1,  spriteEugene,     spriteOneFrame,    WHITE ,   1, 1, spClass_Vertical | spClass_Full_Range | spClass_Eugene	
            .byte 0, 0, 0, 0, 0, 120, 120, 120, 104, 0,  spriteDoor + 4,   spriteOneFrame,    WHITE ,   0, 0, spClass_Door	
        // Level 5
            .byte 0, 0, 0, 0, 0,  46, 106,  48,  64, 2,  spritePacMan,     spriteThreeFrames, YELLOW,   1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0, 110, 170, 112,  64, 2,  spritePacMan,     spriteThreeFrames, PURPLE,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0,  62, 162,  64, 104, 2,  spritePacMan,     spriteThreeFrames, CYAN  ,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 190, 234, 192, 104, 2,  spritePacMan,     spriteThreeFrames, YELLOW,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 232, 232, 232,   0, 0,  spriteDoor + 5,   spriteOneFrame,    YELLOW,   0, 0, spClass_Door	
        // Level 6
            .byte 0, 0, 0, 0, 0, 116, 236, 116,   8, 2,  spriteKangaroo,   spriteFourFrames, CYAN  ,   1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,  12,  84,  80,  64, 2,  spriteKangaroo,   spriteFourFrames, PURPLE,  -1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 132, 236, 132, 104, 2,  spriteKangaroo,   spriteFourFrames, YELLOW,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 120, 120, 120, 104, 0,  spriteDoor + 6,   spriteOneFrame,   PURPLE,   0, 0, spClass_Door	
        // Level 7
            .byte 0, 0, 0, 0, 0,   6,  76,  72, 104, 2,  spriteBarrel,     spriteFourFrames, GREEN ,  -1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  86, 124,  88,  88, 1,  spriteBarrel,     spriteFourFrames, PURPLE,   1, 1, spClass_Full_Range | spClass_ExtendMaxX	
            .byte 0, 0, 0, 0, 0, 142, 172, 144,  56, 2,  spriteBarrel,     spriteFourFrames, CYAN  ,   1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   0,   0,   0, 120, 4,  spriteKong,       spriteThreeFrames,GREEN ,   0, 1, spClass_Vertical | spClass_Full_Range | spClass_Kong | spClass_HoldAtEnd	
            .byte 0, 0, 0, 0, 0, 120, 120, 120, 104, 0,  spriteDoor + 7,   spriteOneFrame,   YELLOW,   0, 0, spClass_Door
        // Level 8
            .byte 0, 0, 0, 0, 0,  94, 146,  96,  24, 2,  spriteWheeledThingy,spriteFourFrames,GREEN,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  94, 146, 128,  80, 1,  spriteWheeledThingy,spriteFourFrames,CYAN ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   5, 100,   8,  40, 1,  spriteAmeoba,   spriteThreeFrames, PURPLE,   1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 100,   8,  80, 2,  spriteAmeoba,   spriteThreeFrames, GREEN ,   1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   5, 100,   8, 160, 1,  spriteAmeoba,   spriteThreeFrames, CYAN  ,   1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 100,   8, 200, 2,  spriteAmeoba,   spriteThreeFrames, RED   ,   1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8,   8,   8,   0, 0,  spriteDoor + 8, spriteOneFrame,    YELLOW,   0, 0, spClass_Door
        // Level 9
            .byte 0, 0, 0, 0, 0,  68, 114,  72,  56, 2,  spriteBunny,   spriteFiveFrames,   YELLOW,   1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,  60, 114,  96,  80, 1,  spriteBunny,   spriteFiveFrames,   RED   ,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0,  28, 210,  64, 104, 2,  spriteBunny,   spriteFiveFrames,   PURPLE,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 134, 172, 144,  40, 2,  spriteBunny,   spriteFiveFrames,   CYAN  ,   1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0,  96,  96,  96, 104, 0,  spriteDoor + 9,spriteOneFrame,     YELLOW,   0, 0, spClass_Door	
        // Level 10
            .byte 0, 0, 0, 0, 0, 120, 192, 120,  24, 2,  spriteMobileAntenna,spriteFourFrames,YELLOW, 1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0, 112, 144, 112,  56, 1,  spriteMobileAntenna,spriteFourFrames,GREEN , 1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  40, 156, 120, 104, 2,  spriteMobileAntenna,spriteFourFrames,RED   , -1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   2,  56,   8,  96, 2,  spriteTelephone, spriteThreeAltFrames, PURPLE,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  32, 100,  32,  24, 1,  spriteTelephone, spriteThreeAltFrames, GREEN ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  48, 100,  48, 168, 1,  spriteTelephone, spriteThreeAltFrames, YELLOW,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 100,  48, 208, 2,  spriteTelephone, spriteThreeAltFrames, RED   , -1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8,   8,   8,   8, 0,  spriteDoor + 10, spriteOneFrame,    YELLOW,  0, 0, spClass_Door
        // Level 11
            .byte 0, 0, 0, 0, 0,   6,  76,  72, 104, 2,  spriteBarrel,    spriteFourFrames,  GREEN , -1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  86, 122,  88,  88, 1,  spriteBarrel,    spriteFourFrames,  YELLOW,  1, 1, spClass_Full_Range | spClass_ExtendMaxX	
            .byte 0, 0, 0, 0, 0, 198, 228, 200,  48, 2,  spriteBarrel,    spriteFourFrames,  CYAN  ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   0,   0,   0, 120, 4,  spriteKong,      spriteThreeFrames, GREEN ,  0, 1, spClass_Vertical | spClass_Full_Range | spClass_Kong | spClass_HoldAtEnd	
            .byte 0, 0, 0, 0, 0, 120, 120, 120, 104, 0,  spriteDoor + 11, spriteOneFrame,    YELLOW,  0, 0, spClass_Door	
        // Level 12
            .byte 0, 0, 0, 0, 0,  54, 234,  56,   8, 2,  spritePogoEyes,  spriteFourFrames,  PURPLE,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  54, 234, 128,  32, 1,  spritePogoEyes,  spriteFourFrames,  GREEN ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  78, 210, 160,  56, 2,  spritePogoEyes,  spriteFourFrames,  YELLOW, -1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  54, 234, 144,  80, 1,  spritePogoEyes,  spriteFourFrames,  RED   ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8, 100,   8,  40, 2,  spriteEyeBall,   spriteFourFrames,  WHITE ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8,   8,   8, 104, 0,  spriteDoor + 12, spriteOneFrame,    WHITE ,  0, 0, spClass_Door	
        // Level 13
            .byte 0, 0, 0, 0, 0,   0,  72,   0,   0, 3, spriteSkyLab,     spriteEightFrames, WHITE , 0, 1, spClass_Vertical | spClass_SkyLab | spClass_HoldAtEnd
            .byte 0, 0, 0, 0, 0,   0,  56,   0,   0, 2, spriteSkyLab,     spriteEightFrames, YELLOW, 0, 2, spClass_Vertical | spClass_SkyLab | spClass_HoldAtEnd	
            .byte 0, 0, 0, 0, 0,   0,  32,   0,   0, 1, spriteSkyLab,     spriteEightFrames, LIGHT_BLUE,0, 3, spClass_Vertical | spClass_SkyLab | spClass_HoldAtEnd	
            .byte 0, 0, 0, 0, 0, 120, 120, 120,   0, 0, spriteDoor + 13,  spriteOneFrame,    YELLOW, 0, 0, spClass_Door	
        // Level 14
            .byte 0, 0, 0, 0, 0, 136, 156, 136, 104, 2, spriteMoney,      spriteFourFrames,  CYAN  ,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  36, 102,  40,  72, 2, spriteBankBox,    spriteFourFrames,  YELLOW,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  36, 102,  64, 120, 1, spriteBankBox,    spriteFourFrames,  WHITE ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  32, 104,  80, 168, 2, spriteBankBox,    spriteFourFrames,  GREEN , -1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8,   8,   8,  24, 0, spriteDoor + 14,  spriteOneFrame,    YELLOW,  0, 0, spClass_Door	
        // Level 15    
            .byte 0, 0, 0, 0, 0,   8, 146,  72, 104, 2, spriteFlagTail,   spriteFourFrames,  GREEN , 1, 1, spClass_Horizontal
            .byte 0, 0, 0, 0, 0,   8,  60,   8,  80, 2, spriteFlagTail,   spriteFourFrames,  YELLOW, 1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 144, 186, 144,  56, 2, spriteFlagTail,   spriteFourFrames,  PURPLE, 1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0, 200, 234, 208,  40, 1, spriteFlagTail,   spriteFourFrames,  CYAN ,  1, 1, spClass_Horizontal	
            .byte 0, 0, 0, 0, 0,  96,  96,  96,  40, 0, spriteDoor + 15,  spriteOneFrame,    YELLOW, 0, 0, spClass_Door	
        // Level 16
            .byte 0, 0, 0, 0, 0,  38,  66,  40, 104, 1, spriteWalker,    spriteFourFrames,   RED   ,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  96, 202,  96, 104, 2, spriteWalker,    spriteFourFrames,   CYAN  ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  64, 102,  64,  24, 2, spriteWarehouse, spriteFourFrames,   BLUE  ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   2,  96,  64,  80, 2, spriteWarehouse, spriteFourFrames,   YELLOW, -1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   2,  64,  48, 152, 1, spriteWarehouse, spriteFourFrames,   WHITE ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4,  96,   0, 216, 4, spriteWarehouse, spriteFourFrames,   PURPLE,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0, 232, 232, 232,   8, 0, spriteDoor + 16, spriteOneFrame,     GREEN ,  0, 0, spClass_Door
        // Level 17
            .byte 0, 0, 0, 0, 0,  96, 144,  96,  24, 1, spriteWheeledThingy, spriteFourFrames,   GREEN ,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  96, 140, 128,  80, 1, spriteWheeledThingy, spriteFourFrames,   CYAN  ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  96, 140, 128,  48, 2, spriteWheeledThingy, spriteFourFrames,   PURPLE,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  96, 144, 128, 104, 2, spriteWheeledThingy, spriteFourFrames,   YELLOW, -1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 104,   8,  40, 3, spriteJellyFish, spriteFourFrames,  PURPLE,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 104,   8,  80, 2, spriteJellyFish, spriteFourFrames,  GREEN ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 104,   8, 160, 4, spriteJellyFish, spriteFourFrames,  CYAN  ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4, 104,   8, 200, 1, spriteJellyFish, spriteFourFrames,  YELLOW,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0, 232, 232, 232,   0, 0, spriteDoor + 17, spriteOneFrame,    YELLOW,  0, 0, spClass_Door	
        // Level 18
            .byte 0, 0, 0, 0, 0, 184, 236, 192,  24, 2, spriteSolarTruck, spriteFourFrames, YELLOW,  1, 1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0, 176, 236, 224,  48, 2, spriteSolarTruck, spriteFourFrames, BLUE  ,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0, 184, 236, 232,  72, 1, spriteSolarTruck, spriteFourFrames, RED   , -1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0, 104, 236, 128, 104, 2, spriteSolarTruck, spriteFourFrames, YELLOW,  1, 1, spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   2, 102,  64,  40, 3, spriteSolarBall, spriteFourFrames,  YELLOW,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,  48, 102,  56,  88, 1, spriteSolarBall, spriteFourFrames,  RED   , -1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   4,  80,  80, 128, 1, spriteSolarBall, spriteFourFrames,  BLUE  ,  1, 1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0,   8,   8,   8,   8, 0, spriteDoor + 18, spriteOneFrame,    YELLOW,  0, 0, spClass_Door
        // Level 19
            .byte 0, 0, 0, 0, 0,  54, 178,  56, 104, 2, spriteHeadLight, spriteFourFrames,  YELLOW,   1,   1, spClass_Full_Range
            .byte 0, 0, 0, 0, 0,  40, 103,  48, 192, 1, spriteEyeBall,   spriteFourFrames,  WHITE ,   1,   1, spClass_Vertical | spClass_Full_Range	
            .byte 0, 0, 0, 0, 0, 152, 152, 152,  40, 0, spriteDoor + 19, spriteOneFrame,    YELLOW,   0,   0, spClass_Door	
        // Level Lose
            .byte 0,   0,   0,   0,   0,   0, 255, 104, 120,   0,  16,   WHITE ,   0,   1, spClass_Vertical
            .byte 0,   0,   0,   0,   0,   0,  88,   0, 120,   2,  25,   RED   ,   1,   0, spClass_Vertical | spClass_HoldAtEnd	
    };

    level2Sprite:
    {
    // number of sprites (1) ══════╕
    // main array index (0)  ═╕    │
                        .byte 0,   2	// Level 0
                        .byte 2,   3	// Level 1
                        .byte 5,   4	// Level 2
                        .byte 9,   3	// Level 3
                        .byte 12,   4	// Level 4
                        .byte 16,   5	// Level 5
                        .byte 21,   4	// Level 6
                        .byte 25,   5	// Level 7
                        .byte 30,   7	// Level 8
                        .byte 37,   5	// Level 9
                        .byte 42,   8	// Level 10
                        .byte 50,   5	// Level 11
                        .byte 55,   6	// Level 12
                        .byte 61,   4	// Level 13
                        .byte 65,   5	// Level 14
                        .byte 70,   5	// Level 15
                        .byte 75,   7	// Level 16
                        .byte 82,   9	// Level 17
                        .byte 91,   8	// Level 18
                        .byte 99,   3	// Level 19
                        .byte 102,   2	// Level Lose
    };

    level2SpriteFramesSequences:
    {
        EightFrames:    .byte 0,1,2,3,4,5,6,7
        FourFrames:     .byte 0,1,2,3,0,1,2,3
        ThreeFrames:    .byte 0,1,2,1,0,1,2,1
        FiveFrames:     .byte 0,1,2,1,0,3,4,3
        ThreeAltFrames: .byte 0,1,0,2,0,1,0,2
        OneFrame:       .byte 0,0,0,0,0,0,0,0
    }

    //-------------------------------------------------------------------------
    willyStartDirections: 
    { .byte 1,1,1,-1,1,-1,1,1,1,1,1,1,1,1,1,1,-1,-1,1,-1,1}

    //-------------------------------------------------------------------------
    conveyorDirections:
    { .byte -1,1,-1,1,-1,-1,-1,1,1,-1,-1,1,1,-1,-1,-1,1,-1,-1,1}; 

//-------------------------------------------------------------------------
    willyStartPositions: 
    {
    .byte  16, 104	//Level 0
    .byte  16, 104 // Level 1
    .byte  16, 104 // Level 2
    .byte 232, 104 // Level 3
    .byte   8,  24 // Level 4
    .byte 126,  24 // Level 5
    .byte  16, 104 // Level 6
    .byte  16, 104 // Level 7
    .byte   8, 104 // Level 8
    .byte   8,  32 // Level 9
    .byte  24,   8 // Level 10
    .byte  16, 104 // Level 11
    .byte 232, 104 // Level 12
    .byte 232, 104 // Level 13
    .byte  16, 104 // Level 14
    .byte  16, 104 // Level 15
    .byte  14,  24 // Level 16
    .byte 238, 104 // Level 17
    .byte 112,  80 // Level 18
    .byte 216, 104 // Level 19
    .byte 124,  88 // Level Lose
    };

    GameDefaults:
    {
        .label XtraLifeOnDigit  = $01       // 10000 get xtra life
        .label NoOfLives        = $03
    }
}
