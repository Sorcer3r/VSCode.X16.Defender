// Constants file
#importonce

// VERA
.const VERAAddrLow       = $9F20
.const VERAAddrHigh      = $9F21
.const VERAAddrBank      = $9F22
.const VERADATA0         = $9F23
.const VERADATA1         = $9F24
.const VERACTRL	         = $9F25
.const VERAINTENABLE     = $9F26
.const VERAINTSTATUS     = $9F27
.const VERASCANLINE      = $9F28
.const VERA_DC_video     = $9F29
.const VERA_DC_hscale    = $9F2A
.const VERA_DC_vscale    = $9F2B
.const VERA_DC_border    = $9F2C
.const VERA_DC_hstart    = $9F29
.const VERA_DC_hstop     = $9F2A
.const VERA_DC_vstart    = $9F2B
.const VERA_DC_vstop     = $9F2C

.const VERA_L0_config    = $9F2D
.const VERA_L0_mapbase   = $9F2E
.const VERA_L0_tilebase  = $9F2F
.const VERA_L1_config    = $9F34
.const VERA_L1_mapbase   = $9F35
.const VERA_L1_tilebase  = $9F36
.const VERA_L1_hscrollLow= $9F37
.const VERA_L1_hscrollHi = $9F38
.const VERA_L1_vscrollLow= $9F39
.const VERA_L1_vscrollHi = $9F3A

// VRAM Addresses
.const VRAM_layer1_map   = $1B000
.const VRAM_layer0_map   = $00000
.const VRAM_lowerchars   = $0B000
.const VRAM_lower_rev    = VRAM_lowerchars + 128*8
.const SPRITEDATA        = $13000
.const VRAM_petscii      = $1F000
.const VRAMPalette       = $1FA00
.const SPRITEREGBASE     = $1FC00
.const VERAPSG0         = $1f9c0
.const VERAPSG1         = $1f9c4
.const VERAPSG2         = $1f9c8
.const VERAPSG3         = $1f9cc
.const VERAPSG14        = $1f9f8
.const VERAPSG15        = $1f9fc

// ROM Banks
.const ROM_BANK          = $01
.const BASIC_BANK        = 4
.const CHARSET_BANK      = 6

//DCSCALE Factors
.const DCSCALEx1 = $80
.const DCSCALEx2 = $40
.const DCSCALEx4 = $20
.const DCSCALEx8 = $10
.const DCSCALEx16 = $08
.const DCSCALEx32 = $04
.const DCSCALEx64 = $02
.const DCSCALEx128 = $01

// Controllers
.const CONTROLLER_KBD = $00
.const CONTROLLER_SNES1 = $01
.const CONTROLLER_SNES2 = $02
.const CONTROLLER_SNES3 = $03
.const CONTROLLER_SNES4 = $04

// KERNEL Routines
// 
.const CHRIN  = $FFE4
.const CHROUT  = $FFD2
.const SCREEN  = $FFED
.const JOYSTICK_SCAN = $FF53
.const JOYSTICK_GET = $FF56

.const SPRITEENABLE = $40

.const GLOBAL_SPRITE_ENABLE_OFF = %10111111
.const GLOBAL_SPRITE_ENABLE_ON = %01000000

.const SPRITE_REGISTER_LENGTH = $08
.const SPRITE_ADDRESS_LO_OFFSET = $00
.const SPRITE_ADDRESS_HI_OFFSET = $01
.const SPRITE_MODE_OFFSET = $01
.const SPRITE_POSITION_X_LO_OFFSET = $02
.const SPRITE_POSITION_X_HI_OFFSET = $03
.const SPRITE_POSITION_Y_LO_OFFSET = $04
.const SPRITE_POSITION_Y_HI_OFFSET = $05
.const SPRITE_COLLISION_MASK_OFFSET = $06
.const SPRITE_Z_DEPTH_OFFSET = $06
.const SPRITE_DIMENSIONS_OFFSET = $07
.const SPRITE_PALETTE_OFFSET = $07

.const SPRITE_MODE_16_COLOUR = $00
.const SPRITE_MODE_256_COLOUR = $80

.const SPRITE_ZDEPTH_DISABLED = $00
.const SPRITE_ZDEPTH_B4LAYER0 = $04
.const SPRITE_ZDEPTH_LAYER0LAYER1 = $08
.const SPRITE_ZDEPTH_AFTERLAYER1 = $0C

.const SPRITE_WIDTH_8PX = $00
.const SPRITE_WIDTH_16PX = $10
.const SPRITE_WIDTH_32PX = $20
.const SPRITE_WIDTH_64PX = $30

.const SPRITE_HEIGHT_8PX = $00
.const SPRITE_HEIGHT_16PX = $40
.const SPRITE_HEIGHT_32PX = $80
.const SPRITE_HEIGHT_64PX = $C0

.const SPRITE_16COL_8x8INC = $01
.const SPRITE_16COL_16x16INC = $04
.const SPRITE_16COL_32x32INC = $10
.const SPRITE_16COL_64x64INC = $40
