#importonce
// sampleRate = 25Mhz / 512 = 48828.125 Hz
// outputFrequency = sampleRate / (2^17) * frequencyWord

.const VERA_PSG_VOICE00     = $1F9C0
.const VERA_PSG_VOICE01     = $1F9C4
.const VERA_PSG_VOICE02     = $1F9C8
.const VERA_PSG_VOICE03     = $1F9CC
.const VERA_PSG_VOICE04     = $1F9D0
.const VERA_PSG_VOICE05     = $1F9D4
.const VERA_PSG_VOICE06     = $1F9D8
.const VERA_PSG_VOICE07     = $1F9DC
.const VERA_PSG_VOICE08     = $1F9E0
.const VERA_PSG_VOICE09     = $1F9E4
.const VERA_PSG_VOICE10     = $1F9E8
.const VERA_PSG_VOICE11     = $1F9EC
.const VERA_PSG_VOICE12     = $1F9F0
.const VERA_PSG_VOICE13     = $1F9F4
.const VERA_PSG_VOICE14     = $1F9F8
.const VERA_PSG_VOICE15     = $1F9FC


//|Register |Bit 7 |Bit 6  |Bit 5  |Bit 4  |Bit 3  |Bit 2  |Bit 1  |Bit 0   |
//|  0      | Frequency Bits 0-7                                            |
//|  1      | Frequency Bits 8-15                                           |
//|  2      ! Right| Left  | Volume                                         |
//|  3      | Waveform     | Pulse width                                    |

.const VERA_PSG_FREQLO_OFFSET = 0
.const VERA_PSG_FREQHI_OFFSET = 1
.const VERA_PSG_VOLUME_OFFSET = 2
.const VERA_PSG_WAVEFORM_OFFSET = 3

.const VERA_PSG_STEREO_BOTH = %11000000
.const VERA_PSG_STEREO_RIGHT =%10000000
.const VERA_PSG_STEREO_LEFT = %01000000
.const VERA_PSG_STEREO_NONE = %00000000

.const VERA_PSG_WAVEFORM_PULSE  = %00000000
.const VERA_PSG_WAVEFORM_SAW    = %01000000
.const VERA_PSG_WAVEFORM_TRI    = %10000000
.const VERA_PSG_WAVEFORM_NOISE  = %11000000

.const VERA_PSG_NOTE_C0         = 44        // Freqy = 16.35
.const VERA_PSG_NOTE_CSharp0    = 46        // Freqy = 17.32
.const VERA_PSG_NOTE_D0         = 49        // Freqy = 18.35
.const VERA_PSG_NOTE_DSharp0    = 52        // Freqy = 19.45
.const VERA_PSG_NOTE_E0         = 55        // Freqy = 20.6
.const VERA_PSG_NOTE_F0         = 59        // Freqy = 21.83
.const VERA_PSG_NOTE_FSharp0    = 62        // Freqy = 23.12
.const VERA_PSG_NOTE_G0         = 66        // Freqy = 24.5
.const VERA_PSG_NOTE_GSharp0    = 70        // Freqy = 25.96
.const VERA_PSG_NOTE_A0         = 74        // Freqy = 27.5
.const VERA_PSG_NOTE_ASharp0    = 78        // Freqy = 29.14
.const VERA_PSG_NOTE_B0         = 83        // Freqy = 30.87
.const VERA_PSG_NOTE_C1         = 88        // Freqy = 32.7
.const VERA_PSG_NOTE_CSharp1    = 93        // Freqy = 34.65
.const VERA_PSG_NOTE_D1         = 99        // Freqy = 36.71
.const VERA_PSG_NOTE_DSharp1    = 104       // Freqy = 38.89
.const VERA_PSG_NOTE_E1         = 111       // Freqy = 41.2
.const VERA_PSG_NOTE_F1         = 117       // Freqy = 43.65
.const VERA_PSG_NOTE_FSharp1    = 124       // Freqy = 46.25
.const VERA_PSG_NOTE_G1         = 132       // Freqy = 49
.const VERA_PSG_NOTE_GSharp1    = 139       // Freqy = 51.91
.const VERA_PSG_NOTE_A1         = 148       // Freqy = 55
.const VERA_PSG_NOTE_ASharp1    = 156       // Freqy = 58.27
.const VERA_PSG_NOTE_B1         = 166       // Freqy = 61.74
.const VERA_PSG_NOTE_C2         = 176       // Freqy = 65.41
.const VERA_PSG_NOTE_CSharp2    = 186       // Freqy = 69.3
.const VERA_PSG_NOTE_D2         = 197       // Freqy = 73.42
.const VERA_PSG_NOTE_DSharp2    = 209       // Freqy = 77.78
.const VERA_PSG_NOTE_E2         = 221       // Freqy = 82.41
.const VERA_PSG_NOTE_F2         = 234       // Freqy = 87.31
.const VERA_PSG_NOTE_FSharp2    = 248       // Freqy = 92.5
.const VERA_PSG_NOTE_G2         = 263       // Freqy = 98
.const VERA_PSG_NOTE_GSharp2    = 279       // Freqy = 103.83
.const VERA_PSG_NOTE_A2         = 295       // Freqy = 110
.const VERA_PSG_NOTE_ASharp2    = 313       // Freqy = 116.54
.const VERA_PSG_NOTE_B2         = 331       // Freqy = 123.47
.const VERA_PSG_NOTE_C3         = 351       // Freqy = 130.81
.const VERA_PSG_NOTE_CSharp3    = 372       // Freqy = 138.59
.const VERA_PSG_NOTE_D3         = 394       // Freqy = 146.83
.const VERA_PSG_NOTE_DSharp3    = 418       // Freqy = 155.56
.const VERA_PSG_NOTE_E3         = 442       // Freqy = 164.81
.const VERA_PSG_NOTE_F3         = 469       // Freqy = 174.61
.const VERA_PSG_NOTE_FSharp3    = 497       // Freqy = 185
.const VERA_PSG_NOTE_G3         = 526       // Freqy = 196
.const VERA_PSG_NOTE_GSharp3    = 557       // Freqy = 207.65
.const VERA_PSG_NOTE_A3         = 591       // Freqy = 220
.const VERA_PSG_NOTE_ASharp3    = 626       // Freqy = 233.08
.const VERA_PSG_NOTE_B3         = 663       // Freqy = 246.94
.const VERA_PSG_NOTE_C4         = 702       // Freqy = 261.63
.const VERA_PSG_NOTE_CSharp4    = 744       // Freqy = 277.18
.const VERA_PSG_NOTE_D4         = 788       // Freqy = 293.66
.const VERA_PSG_NOTE_DSharp4    = 835       // Freqy = 311.13
.const VERA_PSG_NOTE_E4         = 885       // Freqy = 329.63
.const VERA_PSG_NOTE_F4         = 937       // Freqy = 349.23
.const VERA_PSG_NOTE_FSharp4    = 993       // Freqy = 369.99
.const VERA_PSG_NOTE_G4         = 1052      // Freqy = 392
.const VERA_PSG_NOTE_GSharp4    = 1115      // Freqy = 415.3
.const VERA_PSG_NOTE_A4         = 1181      // Freqy = 440
.const VERA_PSG_NOTE_ASharp4    = 1251      // Freqy = 466.16
.const VERA_PSG_NOTE_B4         = 1326      // Freqy = 493.88
.const VERA_PSG_NOTE_C5         = 1405      // Freqy = 523.25
.const VERA_PSG_NOTE_CSharp5    = 1488      // Freqy = 554.37
.const VERA_PSG_NOTE_D5         = 1577      // Freqy = 587.33
.const VERA_PSG_NOTE_DSharp5    = 1670      // Freqy = 622.25
.const VERA_PSG_NOTE_E5         = 1770      // Freqy = 659.25
.const VERA_PSG_NOTE_F5         = 1875      // Freqy = 698.46
.const VERA_PSG_NOTE_FSharp5    = 1986      // Freqy = 739.99
.const VERA_PSG_NOTE_G5         = 2105      // Freqy = 783.99
.const VERA_PSG_NOTE_GSharp5    = 2230      // Freqy = 830.61
.const VERA_PSG_NOTE_A5         = 2362      // Freqy = 880
.const VERA_PSG_NOTE_ASharp5    = 2503      // Freqy = 932.33
.const VERA_PSG_NOTE_B5         = 2652      // Freqy = 987.77
.const VERA_PSG_NOTE_C6         = 2809      // Freqy = 1046.5
.const VERA_PSG_NOTE_CSharp6    = 2976      // Freqy = 1108.73
.const VERA_PSG_NOTE_D6         = 3153      // Freqy = 1174.66
.const VERA_PSG_NOTE_DSharp6    = 3341      // Freqy = 1244.51
.const VERA_PSG_NOTE_E6         = 3539      // Freqy = 1318.51
.const VERA_PSG_NOTE_F6         = 3750      // Freqy = 1396.91
.const VERA_PSG_NOTE_FSharp6    = 3973      // Freqy = 1479.98
.const VERA_PSG_NOTE_G6         = 4209      // Freqy = 1567.98
.const VERA_PSG_NOTE_GSharp6    = 4459      // Freqy = 1661.22
.const VERA_PSG_NOTE_A6         = 4724      // Freqy = 1760
.const VERA_PSG_NOTE_ASharp6    = 5005      // Freqy = 1864.66
.const VERA_PSG_NOTE_B6         = 5303      // Freqy = 1975.53
.const VERA_PSG_NOTE_C7         = 5618      // Freqy = 2093
.const VERA_PSG_NOTE_CSharp7    = 5952      // Freqy = 2217.46
.const VERA_PSG_NOTE_D7         = 6306      // Freqy = 2349.32
.const VERA_PSG_NOTE_DSharp7    = 6681      // Freqy = 2489.02
.const VERA_PSG_NOTE_E7         = 7079      // Freqy = 2637.02
.const VERA_PSG_NOTE_F7         = 7500      // Freqy = 2793.83
.const VERA_PSG_NOTE_FSharp7    = 7946      // Freqy = 2959.96
.const VERA_PSG_NOTE_G7         = 8418      // Freqy = 3135.96
.const VERA_PSG_NOTE_GSharp7    = 8919      // Freqy = 3322.44
.const VERA_PSG_NOTE_A7         = 9449      // Freqy = 3520
.const VERA_PSG_NOTE_ASharp7    = 10011     // Freqy = 3729.31
.const VERA_PSG_NOTE_B7         = 10606     // Freqy = 3951.07
.const VERA_PSG_NOTE_C8         = 11237     // Freqy = 4186.01
.const VERA_PSG_NOTE_CSharp8    = 11905     // Freqy = 4434.92
.const VERA_PSG_NOTE_D8         = 12613     // Freqy = 4698.63
.const VERA_PSG_NOTE_DSharp8    = 13363     // Freqy = 4978.03
.const VERA_PSG_NOTE_E8         = 14157     // Freqy = 5274.04
.const VERA_PSG_NOTE_F8         = 14999     // Freqy = 5587.65
.const VERA_PSG_NOTE_FSharp8    = 15891     // Freqy = 5919.91
.const VERA_PSG_NOTE_G8         = 16836     // Freqy = 6271.93
.const VERA_PSG_NOTE_GSharp8    = 17837     // Freqy = 6644.88
.const VERA_PSG_NOTE_A8         = 18898     // Freqy = 7040
.const VERA_PSG_NOTE_ASharp8    = 20022     // Freqy = 7458.62
.const VERA_PSG_NOTE_B8         = 21212     // Freqy = 7902.13
