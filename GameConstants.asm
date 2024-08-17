#importonce 

.const gameStateStartUp     = 1
// Set up Vera, copy Sprite Char Data to Vera.
.const gameStateTitle       = 2
// Display Level 20, with the piano keys, playing the music awaiting the 
// user to get bored and start the game. (Also Text Scroller)
.const gameStateInit        = 3
// Game initialise, reset Lives back to 5, set Level back to 1, reset Scores
.const gameStateLevelSetUp  = 4
// Prepare the Screen, set up sprites and there movements. Add Keys. 
// Reset Air
.const gameStatePlaying     = 5
// Playing The Game
// sub States : All Keys Collected, Switches
.const gameSubStateKeysFound = 128
.const gameSubStateNone     = 0
.const gameStateSuckAirMeter= 6
// After Clearing A Level, animate the air been sucked out adding to Score
// Set up parameters for next level, e.g Level Var.
.const gameStateBeatLevel   = 7
// ??????????
.const gameStateDied        = 8
// Remove a life, test for death proper
.const gameStateOutOfLives  = 9
// Willy has run out of lives, squash with boot.
.const gameStateWon         = 10
// Obviously
.const gameStateLost        = 11
// ???????????
.const gameStateDemo        = 128

.const joyPadDUp      = %00000001   // Key Cur Up
.const joyPadDDown    = %00000010   // Key Cur Down
.const joyPadDLeft    = %00000100   // Key Cur Left
.const joyPadDRight   = %00001000   // Key Cur Right
.const joyPadA        = %00010000   // Key X
.const joyPadStart    = %00100000   // Key ENTER
.const joyPadB        = %01000000   // Key Z

.const stateJumpOFF = 0
.const stateJumpUP = 1
.const stateJumpDOWN = 2
.const stateNotFalling = 0
.const stateFalling = 128

.const maxWillyJumpHeight = 8
.const maxWillyJumpSpeed = 4
.const maxWillyFallHeight = 9
.const WillyDeathState = 128

.const directionStill = 0
.const directionRight = 1
.const directionLeft = 255

.const maxWillyPixelMovement = 2
.const maxWillyPixelFallMovement = 4
.const maxNumberOfKeysPerLevel = 5

.const worldEmpty       = 0
.const worldFloor       = 1
.const worldSpecial     = 2
.const worldWall	    = 3
.const worldCollapse    = 4
.const worldBush	    = 5
.const worldRock	    = 6
.const worldConveyor    = 7
.const worldKey	        = 8
.const worldKey1	    = 10
.const worldKey2	    = 11
.const worldKey3	    = 12
.const worldKey4	    = 13
.const worldKey5		= 14
.const worldCollapse1	= 15
.const worldCollapse2	= 16
.const worldCollapse3	= 17
.const worldCollapse4	= 18
.const worldCollapse5	= 19
.const worldCollapse6	= 20
.const worldCollapse7	= 21
.const worldCollapse8	= 22
.const worldConveyor1	= 23
.const worldConveyor2	= 24
.const worldConveyor3	= 25
.const worldConveyor4	= 26
.const worldSwitchLeft1	= 27
.const worldSwitchLeft2	= 28
.const worldSwitchRight	= 29
.const worldAir2		= 30
.const worldAir1		= 31
.const blankChar		= 32

.const colNoCol	    = 0 
.const colSpecial	= 1
.const colWall		= 2 
.const colDie		= 4 
.const colFloor		= 8 
.const colConveyor	= 16 
.const colCollapse	= 32 
.const colSwitch	= 64
.const colDoor		= 128

.const spClass_Horizontal	= 0
.const spClass_Vertical	    = 1
.const spClass_Full_Range	= 2
.const spClass_Eugene		= 4
.const spClass_Door		    = 8
.const spClass_ExtendMaxX	= 16
.const spClass_Kong		    = 32
.const spClass_SkyLab		= 64
.const spClass_HoldAtEnd	= 128
//.const spClass_NonReversable=1


.const colour_Background    = 0
.const colour_Ground        = 1
.const colour_Special       = 2
.const colour_Wall          = 3
.const colour_Collapse      = 4
.const colour_Bush          = 5
.const colour_Rock          = 6
.const colour_Conveyor      = 7
.const colour_Border        = 8
.const colour_Door          = 9

.const charSpace            = 32

.const dimScreenRows        = 30
.const dimScreenCols        = 40

.const dimPlayRows          = 16
.const dimPlayCols          = 32
.const dimPlayRowOffSet     = 8
.const dimPlayColOffset     = 3

.const dimPlayRowHiScoreOffset = (11*2) + dimPlayRowOffSet
.const dimPlayRowScoreOffset = (26*2) + dimPlayRowOffSet

.const dimSpriteOffsetX     = (dimPlayRowOffSet/2) * 8
.const dimSpriteOffsetY     = dimPlayColOffset * 8

.const spriteWillyXOffset   = 4
.const spriteWillyColMask   = %00001111
.const spriteDoorColMask    = %00000010
.const spriteEnemyColMask   = %00000001

.const ScreenRam            = $A000
.const ColourRamDifference  = $0200
.const ColourRam            = ScreenRam + ColourRamDifference
.const AirTime              = 1791
.const DrainAirTimeInterval = 8
.const ScorePerAirInterval  = 1 // (10 Points)
.const MaxVolume            = 4         // 0-63 = Game Stand = 32
.const maxNoOfLives         = 5
.const enemyStartSpriteNo   = maxNoOfLives + 1

.const TitleRow             = 19
.const AirRow               = 20
.const ScoreRow             = 22
.const NoOfLivesRow         = 21

.const CharX                = 8 
.const CharY                = 8
.const LevelTiles           = 8

.const UpperFontStart       = 193

.const forcedLeft           = -1
.const forcedRight          = 1
.const forcedFalling        = 2

.const LEVEL_Central_Cavern                     = 0
.const LEVEL_The_Cold_Room                      = 1
.const LEVEL_The_Menagerie                      = 2
.const LEVEL_Abandoned_Uranium_Workings         = 3
.const LEVEL_Eugenes_Lair                       = 4
.const LEVEL_Processing_Plant                   = 5
.const LEVEL_The_Vat                            = 6
.const LEVEL_Miner_Willy_meets_the_Kong         = 7
.const LEVEL_Wacky_Amoebatrons                  = 8
.const LEVEL_The_Endorian_Forest                = 9
.const LEVEL_Attack_of_the_Mutant_Telephones    = 10
.const LEVEL_Return_of_the_Alien_Kong_Beast     = 11
.const LEVEL_Ore_Refinery                       = 12
.const LEVEL_Skylab_Landing_Bay                 = 13
.const LEVEL_The_Bank                           = 14
.const LEVEL_The_Sixteenth_Cavern               = 15
.const LEVEL_The_Warehouse                      = 16
.const LEVEL_Amoebatrons_Revenge                = 17
.const LEVEL_Solar_Power_Generator              = 18
.const LEVEL_The_Final_Barrier                  = 19

.const spriteMinerWilly         = 0
.const spriteRobotWalker        = 8
.const spritePenguin            = 12
.const spriteChicken            = 15
.const spriteToilet             = 18
.const spriteSealion            = 21
.const spriteEyeBall            = 25
.const spriteBarrel             = 29
.const spriteTelephone          = 33
.const spriteEugene             = 36
.const spriteBunny              = 37
.const spritePacMan             = 42
.const spriteKong               = 45
.const spriteKongFall           = 48
.const spriteKangaroo           = 51
.const spriteWheeledThingy      = 55
.const spriteAmeoba             = 59
.const spriteMobileAntenna      = 62
.const spritePogoEyes           = 66
.const spriteSkyLab             = 70
.const spriteBankBox            = 78
.const spriteMoney              = 82
.const spriteFlagTail           = 86
.const spriteWalker             = 90
.const spriteWarehouse          = 94
.const spriteJellyFish          = 98
.const spriteSolarBall          = 102
.const spriteSolarTruck         = 106
.const spriteHeadLight          = 110
.const spriteFoot               = 114
.const spriteLeg                = 115
.const spritePlith              = 116
.const spriteDoor               = 117
// Doors -> 137

.const spriteEightFrames        = 0
.const spriteFourFrames         = 8
.const spriteThreeFrames        = 16
.const spriteFiveFrames         = 24
.const spriteThreeAltFrames     = 32
.const spriteOneFrame           = 40

.const spriteArrayCurPos        = 0
.const spriteArrayCurFrame      = 1
.const spriteArrayCurDirection  = 2
.const spriteArrayCurEnabled    = 3
.const spriteArrayCurLocalStrge = 4
.const spriteArrayMin           = 5
.const spriteArrayMax           = 6
.const spriteArrayStart         = 7
.const spriteArrayOtherAxis     = 8
.const spriteArraySpeed         = 9
.const spriteArrayFrameIndex    = 10
.const spriteArrayAnimPattern   = 11
.const spriteArrayColour        = 12
.const spriteArrayStartDirection= 13
.const spriteArrayStartEnabled  = 14
.const spriteArrayClass         = 15
