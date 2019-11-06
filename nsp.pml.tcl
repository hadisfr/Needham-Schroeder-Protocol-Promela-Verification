# maxx 1
# maxx 3
# Scaler 0.937500, MH 640
wm title . "scenario"
wm geometry . 800x600+650+100
canvas .c -width 800 -height 800 \
	-scrollregion {0c -1c 30c 100c} \
	-xscrollcommand ".hscroll set" \
	-yscrollcommand ".vscroll set" \
	-bg white -relief raised -bd 2
scrollbar .vscroll -relief sunken  -command ".c yview"
scrollbar .hscroll -relief sunken -orient horiz  -command ".c xview"
pack append . \
	.vscroll {right filly} \
	.hscroll {bottom fillx} \
	.c {top expand fill}
.c yview moveto 0
# ProcLine[4] stays at 0 (Used 0 nobox 0)
.c create rectangle 574 0 670 20 -fill black
# ProcLine[4] stays at 0 (Used 0 nobox 0)
.c create rectangle 572 -2 668 18 -fill ivory
.c create text 620 8 -text "3:Intruder"
# ProcLine[3] stays at 0 (Used 0 nobox 0)
.c create rectangle 438 0 486 20 -fill black
# ProcLine[3] stays at 0 (Used 0 nobox 0)
.c create rectangle 436 -2 484 18 -fill ivory
.c create text 460 8 -text "2:Bob"
# ProcLine[2] stays at 0 (Used 0 nobox 0)
.c create rectangle 270 0 334 20 -fill black
# ProcLine[2] stays at 0 (Used 0 nobox 0)
.c create rectangle 268 -2 332 18 -fill ivory
.c create text 300 8 -text "1:Alice"
# ProcLine[1] stays at 0 (Used 0 nobox 0)
.c create rectangle 38 0 246 20 -fill black
# ProcLine[1] stays at 0 (Used 0 nobox 0)
.c create rectangle 36 -2 244 18 -fill ivory
.c create text 140 8 -text "0:encrypted_connection"
.c create text 70 32 -fill #eef -text "1"
.c create line 140 32 620 32 -fill #eef -dash {6 4}
.c create line 140 36 140 20 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[1] from 0 to 1 (Used 1 nobox 0)
# ProcLine[1] stays at 1 (Used 1 nobox 1)
# .c create rectangle 132 22 148 42 -fill white -width 0
.c create text 140 32 -text "#4"
.c create line 300 66 460 66 -fill darkblue -tags mesg -width 2
.c create line 460 66 620 66 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 56 -fill #eef -text "3"
.c create line 140 56 620 56 -fill #eef -dash {6 4}
.c create line 300 36 300 44 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[2] from 0 to 3 (Used 1 nobox 1)
# ProcLine[2] stays at 3 (Used 1 nobox 1)
# .c create rectangle 75 46 525 66 -fill white -width 0
.c create text 300 56 -text "network!syn,intruder,alice_agent,nonce_alice,key_intruder"
.c create text 70 80 -fill #eef -text "5"
.c create line 140 80 620 80 -fill #eef -dash {6 4}
.c create line 620 36 620 68 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 0 to 5 (Used 1 nobox 1)
# ProcLine[4] stays at 5 (Used 1 nobox 1)
# .c create rectangle 498 70 742 90 -fill white -width 0
.c create text 620 80 -text "network?syn,intruder,alice_agent,nonce_alice,key_intruder"
.c create line 620 114 540 114 -fill darkblue -tags mesg -width 2
.c create line 540 114 460 114 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 104 -fill #eef -text "7"
.c create line 140 104 620 104 -fill #eef -dash {6 4}
.c create line 620 96 620 92 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 5 to 7 (Used 1 nobox 1)
# ProcLine[4] stays at 7 (Used 1 nobox 1)
# .c create rectangle 522 94 718 114 -fill white -width 0
.c create text 620 104 -text "network!syn,bob,alice_agent,nonce_alice,key_bob"
.c create text 70 128 -fill #eef -text "9"
.c create line 140 128 620 128 -fill #eef -dash {6 4}
.c create line 460 36 460 116 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[3] from 0 to 9 (Used 1 nobox 1)
# ProcLine[3] stays at 9 (Used 1 nobox 1)
# .c create rectangle 362 118 558 138 -fill white -width 0
.c create text 460 128 -text "network?syn,bob,alice_agent,nonce_alice,key_bob"
.c create line 460 162 540 162 -fill darkblue -tags mesg -width 2
.c create line 540 162 620 162 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 152 -fill #eef -text "11"
.c create line 140 152 620 152 -fill #eef -dash {6 4}
.c create line 460 144 460 140 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[3] from 9 to 11 (Used 1 nobox 1)
# ProcLine[3] stays at 11 (Used 1 nobox 1)
# .c create rectangle 338 142 582 162 -fill white -width 0
.c create text 460 152 -text "network!synack,alice,nonce_alice,nonce_bob,key_alice"
.c create text 70 176 -fill #eef -text "13"
.c create line 140 176 620 176 -fill #eef -dash {6 4}
.c create line 620 120 620 164 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 7 to 13 (Used 1 nobox 1)
# ProcLine[4] stays at 13 (Used 1 nobox 1)
# .c create rectangle 498 166 742 186 -fill white -width 0
.c create text 620 176 -text "network?synack,alice,nonce_alice,nonce_bob,key_alice"
.c create line 620 210 460 210 -fill darkblue -tags mesg -width 2
.c create line 460 210 300 210 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 200 -fill #eef -text "15"
.c create line 140 200 620 200 -fill #eef -dash {6 4}
.c create line 620 192 620 188 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 13 to 15 (Used 1 nobox 1)
# ProcLine[4] stays at 15 (Used 1 nobox 1)
# .c create rectangle 498 190 742 210 -fill white -width 0
.c create text 620 200 -text "network!synack,alice,nonce_alice,nonce_bob,key_alice"
.c create text 70 224 -fill #eef -text "17"
.c create line 140 224 620 224 -fill #eef -dash {6 4}
.c create line 300 72 300 212 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[2] from 3 to 17 (Used 1 nobox 1)
# ProcLine[2] stays at 17 (Used 1 nobox 1)
# .c create rectangle 178 214 422 234 -fill white -width 0
.c create text 300 224 -text "network?synack,alice,nonce_alice,nonce_bob,key_alice"
.c create line 300 258 460 258 -fill darkblue -tags mesg -width 2
.c create line 460 258 620 258 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 248 -fill #eef -text "19"
.c create line 140 248 620 248 -fill #eef -dash {6 4}
.c create line 300 240 300 236 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[2] from 17 to 19 (Used 1 nobox 1)
# ProcLine[2] stays at 19 (Used 1 nobox 1)
# .c create rectangle 178 238 422 258 -fill white -width 0
.c create text 300 248 -text "network!ack,intruder,nonce_bob,null,key_intruder"
.c create text 70 272 -fill #eef -text "21"
.c create line 140 272 620 272 -fill #eef -dash {6 4}
.c create line 620 216 620 260 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 15 to 21 (Used 1 nobox 1)
# ProcLine[4] stays at 21 (Used 1 nobox 1)
# .c create rectangle 498 262 742 282 -fill white -width 0
.c create text 620 272 -text "network?ack,intruder,nonce_bob,null,key_intruder"
.c create line 620 306 540 306 -fill darkblue -tags mesg -width 2
.c create line 540 306 460 306 -fill darkblue -width 2 -arrow last -arrowshape {5 5 5} -tags mesg
.c raise mesg
.c create text 70 296 -fill #eef -text "23"
.c create line 140 296 620 296 -fill #eef -dash {6 4}
.c create line 620 288 620 284 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[4] from 21 to 23 (Used 1 nobox 1)
# ProcLine[4] stays at 23 (Used 1 nobox 1)
# .c create rectangle 522 286 718 306 -fill white -width 0
.c create text 620 296 -text "network!ack,bob,nonce_bob,null,key_bob"
.c create text 70 320 -fill #eef -text "25"
.c create line 140 320 620 320 -fill #eef -dash {6 4}
.c create line 460 168 460 308 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[3] from 11 to 25 (Used 1 nobox 1)
# ProcLine[3] stays at 25 (Used 1 nobox 1)
# .c create rectangle 362 310 558 330 -fill white -width 0
.c create text 460 320 -text "network?ack,bob,nonce_bob,null,key_bob"
.c create text 70 344 -fill #eef -text "27"
.c create line 140 344 620 344 -fill #eef -dash {6 4}
.c create line 140 48 140 332 -fill lightgrey -tags grid -width 1 
.c lower grid
# ProcLine[1] from 1 to 27 (Used 1 nobox 1)
# ProcLine[1] stays at 27 (Used 1 nobox 1)
# .c create rectangle 132 334 148 354 -fill white -width 0
.c create text 140 344 -text "#3"
.c lower grid
.c raise mesg

update;
.c postscript -height 400 -width 850 -file ./nsp.ps