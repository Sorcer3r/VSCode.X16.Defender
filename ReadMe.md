## Test routines for Defender for the Commander X16 ##

### Notes ###

- Notes:
-          --------------------------------------------------
-          |                                                |
-          |                Bitmap Area                     |
-          |               320 * 48 pixels                  |
-          |         160 bytes/line  48 Lines 16 Colour     |
-          |                                                |
-          |     96 pixels | 128 Pixels Radar | 96 Pixels   |
-          --------------------------------------------------
-          |                                                |
-          |                   Tile Map                     |
-          |                40 * 30 tiles                   |
-          |                                                |
-          | Tile Map covers entire screen                  |
-          | First 6 Lines filled with Transparent Space    |
-          | Remaining 24 lines filled with Black Background|
-          | which hides the rest of the Bitmap             |
-          |                                                |
-          |                                                |
-          |                                                |
-          --------------------------------------------------

-  Idea: could build overlay of bitmap area in tilemap screen but
-  this would cause problems if smooth scrolling of tilemap
-  is used
-
-  play area of original game is 2048 wide
-  radar view is 128 pixels wide * 48 lines
-  this translates as visible screen area in radar of 20 pixels wide
-  !! if  4096 then screen area on radar would cover 10 pixels!
-  !! could use 640 pixel mode but more memory and tile map then has to be 80 chars
-  translated sprite x to radar x =  x/16 + 96 (offset to radar area)
-  sprite y to radar y is y/4 

-  bitmap screen is 320*48 pixels, 160*48 bytes. 16 colours (2 pixels per byte)
-  the remaining 24 (192 scan lines) lines are tilemap
-  viewport is 320 * 192  (40*24 chars)  (240 -48 : top 48 lines are radar)
-  must be filled with a background colour that is not 0 (transparent)
-  to hide the bitmap screen behind it. 
-  15 (check # with SP) has been changed to black and is used as background colour to clear screen
-  
-  bitmap screen uses 7680 bytes VERA: 0-1dff
-
-  tilemap is standard screen at VERA: 1b000-

-  need to create 160* table for fast maths in bitmap
