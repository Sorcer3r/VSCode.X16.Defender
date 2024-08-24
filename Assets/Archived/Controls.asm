.cpu _65c02

#importonce 
#import "ZPStorage.asm"


.namespace Controls {

    GetJoyStick:
    {
            // Joystick Get Results
            // Acc: | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
            //  SNES| B | Y |SEL|STA| UP|DN |LFT|RGT|
            // X:
            //  SNES| A | X |LSB|RSB| 1 | 1 | 1 | 1 |
            // Y:
            //      $00 = Joystick Present, $FF = Not
            // Default State of Bits = 1; inverted 0 = Pressed


            // Manic Miner Controls
            // Left / Right D-Pad = Horizontal Movment (Cursor Keys)
            // B = Jump (X)
            // START = Start/Pause Game (ENTER)
            // A = ???? (Z)

            .label tmpJoystick = ZPStorage.TempByte1
            .label tmpAccumlator = ZPStorage.TempByte2
            .label tmpXReg = ZPStorage.TempByte3
        Looper:
            stz tmpJoystick        // Clears Out Joystick Register

            lda #CONTROLLER_KBD
            jsr JOYSTICK_GET

            sta tmpAccumlator
            stx tmpXReg

            // Test For Up
            bbs3 tmpAccumlator, !TestDown+
            smb0 tmpJoystick

        !TestDown:
            // Test For Down
            bbs2 tmpAccumlator, !TestLeft+
            smb1 tmpJoystick

        !TestLeft:
            // Test For Left
            bbs1 tmpAccumlator, !TestRight+
            smb2 tmpJoystick

        !TestRight:
            // Test For Right
            bbs0 tmpAccumlator, !TestStart+
            smb3 tmpJoystick

        !TestStart:
            // Test For Start
            bbs4 tmpAccumlator, !TestShield+
            smb5 tmpJoystick

        !TestShield:
            // Test For Shield
            bbs7 tmpAccumlator, !TestFire+
            smb6 tmpJoystick

        !TestFire:
            // Test For Fire
            bbs7 tmpXReg, !NothingPressed+
            smb4 tmpJoystick

        !NothingPressed:
            lda tmpJoystick
            sta ZPStorage.JoyStick
        rts
    }   
}