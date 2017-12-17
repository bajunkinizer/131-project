
TITLE BATTLESHIP (SIMPLFIED .EXE FORMAT)
.MODEL SMALL
;---------------------------------------------
.STACK 32

SET_CURSOR macro X,Y
  MOV AH, 02H   ;function code to request for set cursor
  MOV BH, 00    ;page number 0, i.e. current screen
  MOV DL, X    ;set row
  mov DH, Y    ;set column
  INT 10H
endm

MARK_BOARD macro X, Y, Z
local SET_HIT_P1
local end_hit_p1

  LEA SI, Z
  INC SI
  MOV AL, [SI]
  SUB AL, 48
  MOV CX, 4
  MUL CX
  LEA DI, X
  ADD DI, AL
  INC DI
  INC DI

 LEA SI, Y
  ADD SI, AL
  MOV AL, [SI]
  CMP AL, 'o'
  JE SET_HIT_P1
  CMP AL, 'x'
  JE END_HIT_P1

  MOV AL, 'x'
  STOSB
  JMP END_HIT_P1
  SET_HIT_P1:

  MOV AL, 'H'
  STOSB

  END_HIT_P1:
endm

P2MARK_BOARDMACRO macro X, Y,Z
LOCAL SET_HIT_P2
LOCAL END_HIT_P2
  
  LEA SI, Z
  INC SI
  MOV AL, [SI]
  SUB AL, 48
  MOV CX, 4
  MUL CX
  LEA DI, X
  ADD DI, AL

  LEA SI, Y
  ADD SI, AL

  INC SI
  INC SI

  MOV AL, [SI]
  CMP AL, 'o'
  JE SET_HIT_P2
  CMP AL, 'x'
  JE END_HIT_P2

  MOV AL, 'x'
  STOSB
  JMP END_HIT_P2
  SET_HIT_P2:

  MOV AL, 'H'
  STOSB

  END_HIT_P2:
endm

P2MARK_BOARD2 macro X, Y
  LEA SI, Y
  INC SI
  MOV AL, [SI]
  SUB AL, 48
  MOV CX, 4
  MUL CX
  LEA DI, X
  ADD DI, AL
  INC DI
  INC DI


  MOV AL, 'x'
  STOSB

endm

P1MARK_BOARD2 macro X, Y
  LEA SI, Y
  INC SI
  MOV AL, [SI]
  SUB AL, 48
  MOV CX, 4
  MUL CX
  LEA DI, X
  ADD DI, AL
  MOV AL, 'x'
  STOSB
endm

PRINT macro X
  LEA DX, X
  MOV AH, 9
  INT 21H
endm

GET_INPUT macro X,Y
  LEA DX, X
  MOV CX, Y
  MOv AH, 3FH
  MOV BX, 00
  INT 21H

endm

SOURCE_IS macro X

  CLD                  ;clear direction flag (left to right)
  MOV CX, 11          ;initializes CX (counter) to 16 bytes
  LEA DI, PATHFILENAME    ;initialize receiving/destination address
  LEA SI, X       ;initialize sending/soure address
  REP MOVSB             ;copy MESSAGE1 to MESSAGE2 byte by byte (repeatedly for 16 times)
  JMP DISPLAY_SCREEN

endm
;---------------------------------------------
.DATA
  
  ;;; MAIN MENU ;;;;  FOR THE MAIN MENU FUNCTION

  RETURN_TO_GAME DB 0

  PATHFILENAME1  DB 'file1.txt', 00H
  PATHFILENAME2  DB 'file2.txt', 00H
  PATHFILENAME3  DB 'file3.txt', 00H
  PATHFILENAME4  DB 'file4.txt', 00H

  PATHFILENAME_HTP DB 'HTP.txt', 00H
  PATHFILENAME_HS DB 'HS.txt', 00H


  FILEHANDLE    DW ?

  CHOICE DB 1

  PATHFILENAME  DB  11 DUP('$')

  NEW_INPUT DB    ?


  RECORD_STR    DB 1501 DUP('$')  ;length = original length of record + 1 (for $)

  ERROR1_STR    DB 'Error in opening file.$'
  ERROR2_STR    DB 'Error reading from file.$'
  ERROR3_STR    DB 'No record read from file.$'
  
  ;;;; VISUALS ;;;; VARIABLES FOR THE BOARD

  COLUMNS DB 0AH, 0DH, "    1   2   3   4   5   6   7$"

  UPPERBORDER DB 0AH, 0DH, "  ���������������������������Ŀ$" 		;UPPER EDGE BORDER
  
  LOWERBORDER DB 0AH, 0DH, "  �����������������������������$"		;LOWER EDGE BORDER
	
  INTERNALBORDER DB 0AH, 0DH, "  ���������������������������Ĵ$"	; INTERNAL BORDER

  GUESSBOARD DB  "  YOUR GUESSBOARD$"
  YOURBOARD DB  "  YOUR BOARD$"


  P1_GUESSBOARD_ROW_A DB 0AH, 0DH, "A �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_B DB 0AH, 0DH, "B �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_C DB 0AH, 0DH, "C �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_D DB 0AH, 0DH, "D �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_E DB 0AH, 0DH, "E �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_F DB 0AH, 0DH, "F �   �   �   �   �   �   �   �$"
  P1_GUESSBOARD_ROW_G DB 0AH, 0DH, "G �   �   �   �   �   �   �   �$"

  P1_REALBOARD_ROW_A DB 0AH, 0DH, "A �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_B DB 0AH, 0DH, "B �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_C DB 0AH, 0DH, "C �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_D DB 0AH, 0DH, "D �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_E DB 0AH, 0DH, "E �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_F DB 0AH, 0DH, "F �   �   �   �   �   �   �   �$"
  P1_REALBOARD_ROW_G DB 0AH, 0DH, "G �   �   �   �   �   �   �   �$"


;------------------------------------------------------------
  COLUMNS2 DB  "    1   2   3   4   5   6   7$"

  UPPERBORDER2 DB  "  ���������������������������Ŀ$" 		;UPPER EDGE BORDER
  
  LOWERBORDER2 DB  "  �����������������������������$"		;LOWER EDGE BORDER
	
  INTERNALBORDER2 DB  "  ���������������������������Ĵ$"	; INTERNAL BORDER

  GUESSBOARD2 DB  "  YOUR GUESSBOARD$"
  YOURBOARD2 DB  "  YOUR BOARD$"

  P2_GUESSBOARD_ROW_A DB  "A �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_B DB  "B �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_C DB  "C �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_D DB  "D �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_E DB  "E �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_F DB  "F �   �   �   �   �   �   �   �$"
  P2_GUESSBOARD_ROW_G DB  "G �   �   �   �   �   �   �   �$"

  P2_REALBOARD_ROW_A DB  "A �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_B DB  "B �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_C DB  "C �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_D DB  "D �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_E DB  "E �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_F DB  "F �   �   �   �   �   �   �   �$"
  P2_REALBOARD_ROW_G DB  "G �   �   �   �   �   �   �   �$"






;;;; DIALOUGES ;;;;

INPUT_TARGET DB 0AH, 0DH, "Where should we attack, Captain? $"
P2INPUT_TARGET DB  "Where should we attack, Captain? $"
INPUT_SHIP DB 0AH, 0DH, "Captain, where should we deploy the ship? $"
INPUT_DIRECTION DB 0AH, 0DH, "Towards what direction Captain? $"


COORDINATE_ERROR DB 0AH, 0DH, "INVALID COORDINATES ENTERED! CORRECT FORMAT: (A-G),(1-7) $"
INVALID_DIRECTION DB 0AH, 0DH, "Captain, your instruction cannot be understood!$"
GOING_OUT_OF_BOUNDS DB 0AH, 0DH, "The ship can't be deployed there Captain! $"
INVALID_TORPEDO DB 0AH, 0DH, "Captain, we can't attack that! $"
P1WONSTRING DB 0AH, 0DH, "P2 WON! P2 WON! P2 WON! P2 WON! P2 WON! P2 WON! P2 WON! P2 WON! P2 WON! P2 WON!$"
P2WONSTRING DB 0AH, 0DH, "P1 WON! P1 WON! P1 WON! P1 WON! P1 WON! P1 WON! P1 WON! P1 WON! P1 WON! P1 WON!$"



;;;; PLAYER 1 VARIABLES
    
    P1_NAME DB 10 DUP(' '), "$"

    ;; SHIPS ;;
    P1_TWO_UNIT_SHIP DB 5 DUP(' '), "$"
    P1_TWO_UNIT_FLAG DB 1
    P1_THREE_UNIT_SHIP DB 7 DUP(' '), "$"
    P1_THREE_UNIT_FLAG DB 1
    P1_FOUR_UNIT_SHIP DB 9 DUP(' '), "$"
    P1_FOUR_UNIT_FLAG DB 1
    P1_FIVE_UNIT_SHIP DB 11 DUP(' '), "$"
    P1_FIVE_UNIT_FLAG DB 1
    P1_SHIP_NUMBER DB 4; NUMBER OF SHIPS ALIVE BY PLAYER 1, IF IT REACHES 0, PLAYER 2 WINS
    P1_TURN DB 0AH, 0DH, "Captain 1's turn" , 0AH, 0DH, "$"




;;;; PLAYER 2 VARIABLES ;;;;
    ;; SHIPS ;;
    P2_TWO_UNIT_SHIP DB 5 DUP(' '), "$"
    P2_TWO_UNIT_FLAG DB 1
    P2_THREE_UNIT_SHIP DB 7 DUP(' '), "$"
    P2_THREE_UNIT_FLAG DB 1
    P2_FOUR_UNIT_SHIP DB 9 DUP(' '), "$"
    P2_FOUR_UNIT_FLAG DB 1
    P2_FIVE_UNIT_SHIP DB 11 DUP(' '), "$"
    P2_FIVE_UNIT_FLAG DB 1
    P2_SHIP_NUMBER DB 4; NUMBER OF SHIPS ALIVE BY PLAYER 2, IF IT REACHES 0, PLAYER 2 WINS
    P2_TURN DB 0AH, 0DH, "Captain 2's turn" , 0AH, 0DH, "$"


;;;; CONSTANTS ;;;;


TRUE EQU 1
NULL EQU 0
TWO_UNIT_LENGTH EQU 4
THREE_UNIT_LENGTH EQU 6
FOUR_UNIT_LENGTH EQU 8
FIVE_UNIT_LENGTH EQU 10
TORPEDO_LENGTH EQU 2
DIRECTION_LENGTH EQU 1
STARTING_POINT_LENGTH EQU 2

  ;;; DIRECTIONS ;;;
  UP EQU 85  ; U
  DOWN EQU 68 ; D 
  RIGHT EQU 82 ;R 
  LEFT EQU 76  ; L


;;;; NEUTRAL VARIABLES ;;;; 

DIRECTION DB 2 DUP(' '), "$"
STARTING_POINT DB 3 DUP(' '), "$"
UNIT_MATCH DB 1
COUNTER DB 0
TORPEDO DB 3 DUP(' '), "$" ; COORDINATE TO BE HIT
COORDINATE_CORRECT_FLAG DB 1
OUT_OF_BOUNDS DB 1





SHIP DB "C1C2C3"
SHIP2 DB "A2B2C2D2"
SHIP_LENGTH EQU 6
SHIP2_LENGTH EQU 8

  TESTCO DB "A4"

;---------------------------------------------
 .CODE
START:
  MOV AX, @data;DATASEG
  MOV DS, AX
  MOV ES, AX

 ;CALL P1UPDATE_SCREEN
 ;CALL GET_P1SHIP

 CALL MAIN_MENU  ;DISPLAYS MAIN MENU. RETURNS IF THE PLAYERS DECIDES TO PLAY NOW


CALL P1ANDP2_SCREEN  ;; DISPLAYS THE REAL BOARD OF P1 AND P2 **REAL BOARD MEANS THE ONE WITH THE ACTUAL SHIPS
 

;CALL FOR GETTING THE COORDINATES OF THE SHIP FOR PLAYER 1 AND 2 
; 1.) IT ASKS FOR A STARTING POINT ex. G3, A1, E1, B7. It is counted as one coordinate. The coordinate should have a capital letter (A-G) followed by a number (1-7) otherwise the function asks for input again.
;2.) IT ASKS FOR DIRECTION TO WHICH THE SHIP SHOULD BE LAYED DOWN STARTING FROM THE USER-INPUTTED-STARTING POINT. IT GENERATES THE WHOLE COORDINATE OF THE SHIP BASED ON THE SHIP'S NUMBER OF
;UNITS. EX. STARTING POINT A1, A SHIP1 HAS TWO UNITS, DIRECTION ENTERED IS R (RIGHT)  **NOTE THAT EACH COORDINATE IS ONE UNIT OF A SHIP
; RESULT COORDINATE:   A1A2
; EX. STARTING POINT D5, 5 UNIT SHIP, DOWN
; RESULT COORDINATE:   ERROR??? WHY??? 
;   SUPPOSED RESULT IS   D5, E5, F5, G5, H5..... BUT THERE IS NOT SUCH THING AS H5, SO IT GOES OUT OF BOUNDS AND WE ASK FOR INPUT AGAIN
; 3.) ONCE THE VALID SHIP AND DIRECTION IS ENTERED. IT THEN DISPLAY THE NEW SHIPS IN THE BOARD OF THE RESPECTIVE PLAYERS
CALL P1GET_SHIP2
CALL P1GET_SHIP3
CALL P1GET_SHIP4
CALL P1GET_SHIP5

CALL P2GET_SHIP2
CALL P2GET_SHIP3
CALL P2GET_SHIP4
CALL P2GET_SHIP5

;GAME LOGIC
;1 STARTING AT THIS POINT IT WILL BE THE GAME PROPER
;2 START WITH PLAYER 1 TURN
;3 ASKS INPUT ON WHERE TO ATTACK ex. GET_TORPEDO
;3.1 IT MARKS THE GUESSBOARD OF PLAYER 1 , AND THE REALBOARD OF PLAYER2, DEPENDING ON WHERE THEY ATTACKED ex. P1MARK_BOARD, P2MARK_BOARD
;4 THE INPUT IS THEN CHECKED IF IT HIT ANY OF THE SHIPS OF PLAYER 2  ex. IF_HIT
;5 PROGRAM THEN CHECKS IF THERE ARE ANY SHIPS THAT HAVE SUNK DOWN ( A SHIP IS GOING TO SINK IF ALL OF IT'S COORDINATES GET HIT. THOSE COORDINATEST ARE HIT BECOME NULL OR 0) ex. IS_ALIVE (checks if all coordinates are 0)
;6 IF YES, THEN THE TOTAL NUMBER OF SHIPS ALIVE BY PLAYER 2 WILL BE REDUCED OTHERWISE PROCEED IMMEDIATELY TO CHECKING OF THE NUMBER OF SHIPS
;7 PROGRAM THEN CHECKS IF P1 NUMBER OF SHIPS == 0. IF YES, THEN PLAYER 2 WILL WIN AND THE GAME ENDS, OTHERWISE ITS PLAYER 2
;8. IN PLAYER 2'S TURN. ALL STEPS FROM STEP 1 WILL BE REPEATED EXCEPT PLAYER1 WILL BECOME PLAYER 2.




;
GAME:
  ;; P1_ATTACK
  CALL P1UPDATE_SCREEN
  CALL GET_TORPEDO

  LEA SI,TORPEDO
  CALL P1MARK_BOARD
  CALL P1UPDATE_SCREEN
  CALL _DELAY

  LEA SI, TORPEDO
  LEA DI, P2_TWO_UNIT_SHIP
  MOV BX, TWO_UNIT_LENGTH
  CALL IF_HIT


  LEA SI, TORPEDO
  LEA DI, P2_THREE_UNIT_SHIP
  MOV BX, THREE_UNIT_LENGTH
  CALL IF_HIT

  LEA SI, TORPEDO
  LEA DI, P2_FOUR_UNIT_SHIP
  MOV BX, FOUR_UNIT_LENGTH
  CALL IF_HIT

  LEA SI, TORPEDO
  LEA DI, P2_FIVE_UNIT_SHIP
  MOV BX, FIVE_UNIT_LENGTH
  CALL IF_HIT

  CMP P2_TWO_UNIT_FLAG, 0
  JE CHECK_P2_3

  LEA SI, P2_TWO_UNIT_SHIP
  MOV CX, TWO_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P2_3
  
  MOV P2_TWO_UNIT_FLAG, 0
  DEC P2_SHIP_NUMBER

  CHECK_P2_3: 

  CMP P2_THREE_UNIT_FLAG, 0
  JE CHECK_P2_4

  LEA SI, P2_THREE_UNIT_SHIP
  MOV CX, THREE_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P2_4

  MOV P2_THREE_UNIT_FLAG, 0
  DEC P2_SHIP_NUMBER

  CHECK_P2_4:
  CMP P2_FOUR_UNIT_FLAG, 0
  JE CHECK_P2_5

  LEA SI, P2_FOUR_UNIT_SHIP
  MOV CX, FOUR_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P2_5

  MOV P2_FOUR_UNIT_FLAG, 0
  DEC P2_SHIP_NUMBER

  CHECK_P2_5:
  CMP P2_FIVE_UNIT_FLAG, 0
  JE CHECK_P2_LOSE

  LEA SI, P2_FIVE_UNIT_SHIP
  MOV CX, FIVE_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P2_LOSE

  MOV P2_FIVE_UNIT_FLAG, 0
  DEC P2_SHIP_NUMBER

  CHECK_P2_LOSE:
  CMP P2_SHIP_NUMBER, 0
  JNE PLAYER2TURN

  CALL PWON

  ;; PLAYER 2
  PLAYER2TURN:
  
  CALL P2UPDATE_SCREEN
  CALL P2GET_TORPEDO

  LEA SI,TORPEDO
  CALL P2MARK_BOARD
  CALL P2UPDATE_SCREEN
  CALL _DELAY

  LEA SI, TORPEDO
  LEA DI, P1_TWO_UNIT_SHIP
  MOV BX, TWO_UNIT_LENGTH
  CALL IF_HIT

  LEA SI, TORPEDO
  LEA DI, P1_THREE_UNIT_SHIP
  MOV BX, THREE_UNIT_LENGTH
  CALL IF_HIT

  LEA SI, TORPEDO
  LEA DI, P1_FOUR_UNIT_SHIP
  MOV BX, FOUR_UNIT_LENGTH
  CALL IF_HIT

  LEA SI, TORPEDO
  LEA DI, P1_FIVE_UNIT_SHIP
  MOV BX, FIVE_UNIT_LENGTH
  CALL IF_HIT

  CMP P1_TWO_UNIT_FLAG, 0
  JE CHECK_P1_3

  LEA SI, P1_TWO_UNIT_SHIP
  MOV CX, TWO_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P1_3
  

  MOV P1_TWO_UNIT_FLAG, 0
  DEC P1_SHIP_NUMBER

  CHECK_P1_3: 
  CMP P1_THREE_UNIT_FLAG, 0
  JE CHECK_P1_4

  LEA SI, P1_THREE_UNIT_SHIP
  MOV CX, THREE_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P1_4

  JMP SKIP_THIS
  P1_WON11:
    JMP P1_WON

  SKIP_THIS:

  MOV P1_THREE_UNIT_FLAG, 0
  DEC P1_SHIP_NUMBER

  CHECK_P1_4:

  CMP P1_FOUR_UNIT_FLAG, 0
  JE CHECK_P1_5

  LEA SI, P1_FOUR_UNIT_SHIP
  MOV CX, FOUR_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P1_5

  MOV P1_FOUR_UNIT_FLAG, 0
  DEC P1_SHIP_NUMBER

  CHECK_P1_5:

  CMP P1_FIVE_UNIT_FLAG, 0
  JE CHECK_P1_LOSE

  LEA SI, P1_FIVE_UNIT_SHIP
  MOV CX, FIVE_UNIT_LENGTH
  CALL IS_ALIVE

  CMP CX, 0
  JNE CHECK_P1_LOSE

  MOV P1_FIVE_UNIT_FLAG, 0
  DEC P1_SHIP_NUMBER

  CHECK_P1_LOSE:
  CMP P1_SHIP_NUMBER, 0
  JE smart_skip
  JMP GAME
smart_skip:
  CALL PWON


  P1_WON:


  P2_WON:
  EXIT:
  MOV AH, 4CH
  INT 21H
;-------------------------------------------
_DELAY PROC NEAR
      mov bp, 15 ;lower value faster
      mov si, 15 ;lower value faster
    delay2:
      dec bp
      nop
      jnz delay2
      dec si
      cmp si,0
      jnz delay2
      RET
_DELAY ENDP
;-------------------------------------------
;---------------------------------------
PWON PROC NEAR
  
    CMP P1_SHIP_NUMBER, 0
    JNE P2WON

    PRINT P1WONSTRING
    JMP EXIT_PWON

    P2WON:
    PRINT P2WONSTRING

EXIT_PWON:
MOV AH, 4CH
INT 21H

PWON ENDP
;-------------------------------------------
IS_ALIVE PROC NEAR

  IS_ALIVE_LOOP:

    CMP BYTE PTR [SI], 0
    JNE END_IS_ALIVE

    INC SI
    DEC CX

  CMP CX, 0
  JNE IS_ALIVE_LOOP

  END_IS_ALIVE:
  RET
;IF CX IS 0 IT MEANS THE SHIP IS DEAD
IS_ALIVE ENDP
;-------------------------------------------
IF_HIT PROC NEAR
MOV AL, [SI]
MOV AH, [DI]

MOV CX, 0
MOV UNIT_MATCH, 0

P1_LOOP_IF_TORPEDO_HITS:
  
  CMP CX, BX
  JE P1_EXIT_IF_TORPEDO_HITS_P2SHIP

  CMP AL, AH
  JE P1_NEXT_HALF_COORDINATE

  CMP UNIT_MATCH, 1
  JE P1_MOVE_HALF_COORDINATE

  INC DI
  INC DI
  INC CX
  INC CX
  MOV AH, [DI]
  
  JMP P1_LOOP_IF_TORPEDO_HITS

 P1_MOVE_HALF_COORDINATE:
  MOV UNIT_MATCH, 0
  INC DI
  MOV AH, [DI]
  INC CX
  DEC SI
  MOV AL, [SI]

  JMP P1_LOOP_IF_TORPEDO_HITS

  P1_NEXT_HALF_COORDINATE:
    INC UNIT_MATCH
    CMP UNIT_MATCH, 2
    JE P1_TURN_SHIP_SEGMENT_TO_NULL
    INC SI
    MOV AL, [SI]
    INC DI
    MOV AH, [DI]
    INC CX

    JMP P1_LOOP_IF_TORPEDO_HITS

  P1_TURN_SHIP_SEGMENT_TO_NULL:

  DEC DI
  MOV AL, NULL
  STOSB
  STOSB
  RET


P1_EXIT_IF_TORPEDO_HITS_P2SHIP:
RET


IF_HIT ENDP
;---------------------------------------------
P2GET_SHIP5 PROC NEAR

JMP P2SKIP_PRINT_COORDINATE_ERROR5
P2PRINT_COORDINATE_ERROR5:

PRINT COORDINATE_ERROR

P2SKIP_PRINT_COORDINATE_ERROR5:
P2GET_COORDINATE5:
PRINT P2_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P2PRINT_COORDINATE_ERROR5

 LEA DI, P2_FIVE_UNIT_SHIP
 MOV COUNTER, FIVE_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P2GET_COORDINATE5

 LEA SI, P2_FIVE_UNIT_SHIP
 MOV CX, FIVE_UNIT_LENGTH
 CALL P2SET_SHIP
 CALL P1ANDP2_SCREEN

RET
P2GET_SHIP5 ENDP
;---------------------------------------
;---------------------------------------
P2GET_SHIP4 PROC NEAR

JMP P2SKIP_PRINT_COORDINATE_ERROR4
P2PRINT_COORDINATE_ERROR4:

PRINT COORDINATE_ERROR

P2SKIP_PRINT_COORDINATE_ERROR4:
P2GET_COORDINATE4:
PRINT P2_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P2PRINT_COORDINATE_ERROR4

 LEA DI, P2_FOUR_UNIT_SHIP
 MOV COUNTER, FOUR_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P2GET_COORDINATE4

 LEA SI, P2_FOUR_UNIT_SHIP
 MOV CX, FOUR_UNIT_LENGTH
 CALL P2SET_SHIP
 CALL P1ANDP2_SCREEN

RET
P2GET_SHIP4 ENDP
;---------------------------------------
P2GET_SHIP2 PROC NEAR

JMP P2SKIP_PRINT_COORDINATE_ERROR2
P2PRINT_COORDINATE_ERROR2:

PRINT COORDINATE_ERROR

P2SKIP_PRINT_COORDINATE_ERROR2:
P2GET_COORDINATE2:
PRINT P2_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P2PRINT_COORDINATE_ERROR2

 LEA DI, P2_TWO_UNIT_SHIP
 MOV COUNTER, TWO_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P2GET_COORDINATE2

 LEA SI, P2_TWO_UNIT_SHIP
 MOV CX, TWO_UNIT_LENGTH
 CALL P2SET_SHIP
 CALL P1ANDP2_SCREEN

RET
P2GET_SHIP2 ENDP
;---------------------------------------
P2GET_SHIP3 PROC NEAR

JMP P2SKIP_PRINT_COORDINATE_ERROR3
P2PRINT_COORDINATE_ERROR3:

PRINT COORDINATE_ERROR

P2SKIP_PRINT_COORDINATE_ERROR3:
P2GET_COORDINATE3:
PRINT P2_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P2PRINT_COORDINATE_ERROR3

 LEA DI, P2_THREE_UNIT_SHIP
 MOV COUNTER, THREE_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P2GET_COORDINATE3

 LEA SI, P2_THREE_UNIT_SHIP
 MOV CX, THREE_UNIT_LENGTH
 CALL P2SET_SHIP
 CALL P1ANDP2_SCREEN

RET
P2GET_SHIP3 ENDP
;---------------------------------------
P1GET_SHIP2 PROC NEAR

JMP P1SKIP_PRINT_COORDINATE_ERROR2
P1PRINT_COORDINATE_ERROR2:

PRINT COORDINATE_ERROR

P1SKIP_PRINT_COORDINATE_ERROR2:
P1GET_COORDINATE2:
PRINT P1_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P1PRINT_COORDINATE_ERROR2

 LEA DI, P1_TWO_UNIT_SHIP
 MOV COUNTER, TWO_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P1GET_COORDINATE2

 LEA SI, P1_TWO_UNIT_SHIP
 MOV CX, TWO_UNIT_LENGTH
 CALL P1SET_SHIP
 CALL P1ANDP2_SCREEN

RET
P1GET_SHIP2 ENDP
;---------------------------------------
P1GET_SHIP3 PROC NEAR

JMP P1SKIP_PRINT_COORDINATE_ERROR3
P1PRINT_COORDINATE_ERROR3:

PRINT COORDINATE_ERROR

P1SKIP_PRINT_COORDINATE_ERROR3:
P1GET_COORDINATE3:
PRINT P1_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P1PRINT_COORDINATE_ERROR3

 LEA DI, P1_THREE_UNIT_SHIP
 MOV COUNTER, THREE_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P1GET_COORDINATE3

 LEA SI, P1_THREE_UNIT_SHIP
 MOV CX, THREE_UNIT_LENGTH
 CALL P1SET_SHIP
 CALL P1ANDP2_SCREEN

 RET

P1GET_SHIP3 ENDP

;---------------------------------------
P1GET_SHIP4 PROC NEAR

JMP P1SKIP_PRINT_COORDINATE_ERROR4
P1PRINT_COORDINATE_ERROR4:

PRINT COORDINATE_ERROR

P1SKIP_PRINT_COORDINATE_ERROR4:
P1GET_COORDINATE4:
PRINT P1_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P1PRINT_COORDINATE_ERROR4

 LEA DI, P1_FOUR_UNIT_SHIP
 MOV COUNTER, FOUR_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P1GET_COORDINATE4

 LEA SI, P1_FOUR_UNIT_SHIP
 MOV CX, FOUR_UNIT_LENGTH
 CALL P1SET_SHIP
 CALL P1ANDP2_SCREEN
RET
P1GET_SHIP4 ENDP

;---------------------------------------
P1GET_SHIP5 PROC NEAR

JMP P1SKIP_PRINT_COORDINATE_ERROR5
P1PRINT_COORDINATE_ERROR5:

PRINT COORDINATE_ERROR

P1SKIP_PRINT_COORDINATE_ERROR5:
P1GET_COORDINATE5:
PRINT P1_TURN

PRINT INPUT_SHIP
GET_INPUT STARTING_POINT, STARTING_POINT_LENGTH 

LEA SI, STARTING_POINT
CALL CHECK_COORDINATE 
CMP COORDINATE_CORRECT_FLAG, NULL
JE P1PRINT_COORDINATE_ERROR5

 LEA DI, P1_FIVE_UNIT_SHIP
 MOV COUNTER, FIVE_UNIT_LENGTH ; INPUT WHAT SHIP TO GET BEFORE CALLING GET SHIP
 CALL GET_SHIP

 CMP OUT_OF_BOUNDS, 1
 JE P1GET_COORDINATE5

 LEA SI, P1_FIVE_UNIT_SHIP
 MOV CX, FIVE_UNIT_LENGTH
 CALL P1SET_SHIP
 CALL P1ANDP2_SCREEN
RET
P1GET_SHIP5 ENDP
;---------------------------------------


CLEAR_SCREEN PROC NEAR
  MOV AX, 0600H   ;full screen
  MOV CX, 0000H   ;upper left row:column (0:0)
  MOV DX, 184FH   ;lower right row:column (24:79)
  INT 10H

  RET
CLEAR_SCREEN ENDP
;-------------------------------------------
GET_DIRECTION PROC NEAR

JMP SKIP_PRINT_DIRECTION_ERROR
PRINT_DIRECTION_ERROR:
PRINT INVALID_DIRECTION

SKIP_PRINT_DIRECTION_ERROR:

PRINT INPUT_DIRECTION
GET_INPUT DIRECTION, DIRECTION_LENGTH

LEA SI, DIRECTION
MOV AL, [SI]
CMP AL, UP
JE EXIT_GET_DIRECTION
CMP AL, DOWN
JE EXIT_GET_DIRECTION
CMP AL, LEFT
JE EXIT_GET_DIRECTION
CMP AL, RIGHT
JE EXIT_GET_DIRECTION

JMP PRINT_DIRECTION_ERROR


EXIT_GET_DIRECTION:
RET


GET_DIRECTION ENDP
;-------------------------------------------
GENERATE_UP PROC NEAR

 MOV AL, [SI]
 MOV BL, [SI]  ; BL CONTAINS THE FIRST PART OF THE COORDINATE
 STOSB
 INC SI  ; SI WILL STAY WITH THE 2ND PART OF THE COORDINATE
 MOV AL, [SI]
 STOSB   

DEC COUNTER
DEC COUNTER

GENERATE_UP_LOOP:

  DEC BL 

  CMP BL, 65
  JL OUTOFBOUNDS_UP

  MOV AL, BL
  DEC COUNTER
  DEC COUNTER
  STOSB
  MOV AL, [SI]
  STOSB

CMP COUNTER, 0
JNE GENERATE_UP_LOOP
  
MOV OUT_OF_BOUNDS, 0
RET

 OUTOFBOUNDS_UP:
 PRINT GOING_OUT_OF_BOUNDS
 MOV OUT_OF_BOUNDS, 1
 RET



GENERATE_UP ENDP
;-------------------------------------------
GET_KEY PROC  NEAR
      MOV   AH, 01H   ;check for input
      INT   16H

      JZ    BEFORE_PARSE3

      MOV   AH, 00H   ;get input  MOV AH, 10H; INT 16H
      INT   16H


  _PARSE1:
  
      CMP   AH, 4BH   ; LEFT
      JNE   _PARSE2
      ;JMP    __ITERATEXL
      CMP CHOICE, 1
      JNE MOVE_LEFT
      JMP DISPLAY_SCREEN
  MOVE_LEFT:
    DEC CHOICE
    JMP BACK
  _PARSE2:
    
      CMP   AH, 4DH   ; RIGHT
      JNE   _PARSE3     
      ;JMP    __ITERATEXR
      CMP CHOICE, 4
      JNE MOVE_RIGHT
      JMP DISPLAY_SCREEN
  MOVE_RIGHT:
    INC CHOICE
    JMP BACK

    BEFORE_PARSE3:    
        JMP __LEAVETHIS


  _PARSE3:
      CMP   AL, 0DH   ; ENTER
      JNE   _WAIT
      CMP CHOICE, 1
      JE SET_RETURN_TO_GAME
      CMP CHOICE, 4
      JNE L1
      MOV AH, 4CH
        INT 21H
      
    L1:
      CMP CHOICE, 2
      JE  GO_TO_HTP
      CMP CHOICE, 3
      JE GO_TO_HS
      CMP CHOICE, 6
      JE  TO_TITLE
      CMP CHOICE, 5
      JNE __LEAVETHIS

  TO_TITLE:
    MOV CHOICE, 1
    JMP BACK

  GO_TO_HTP:

    MOV CHOICE, 5
    JMP BACK
  GO_TO_HS:
    MOV CHOICE, 6
    JMP BACK
  _WAIT:
    MOV AH,00       ; Read Character
        INT 16H


    JMP   _PARSE1

  __LEAVETHIS:
      RET
    SET_RETURN_TO_GAME:
      MOV RETURN_TO_GAME, 1
      RET
GET_KEY   ENDP

;-------------------------------------------
GENERATE_DOWN PROC NEAR

 MOV AL, [SI]
 MOV BL, [SI]  ; BL CONTAINS THE FIRST PART OF THE COORDINATE
 STOSB
 INC SI  ; SI WILL STAY WITH THE 2ND PART OF THE COORDINATE
 MOV AL, [SI]
 STOSB   

DEC COUNTER
DEC COUNTER

GENERATE_DOWN_LOOP:

  INC BL 

  CMP BL, 71
  JG OUTOFBOUNDS_DOWN

  MOV AL, BL
  DEC COUNTER
  DEC COUNTER
  STOSB
  MOV AL, [SI]
  STOSB

CMP COUNTER, 0
JNE GENERATE_DOWN_LOOP
  
MOV OUT_OF_BOUNDS, 0
RET

 OUTOFBOUNDS_DOWN:
 PRINT GOING_OUT_OF_BOUNDS
 MOV OUT_OF_BOUNDS, 1
 RET



GENERATE_DOWN ENDP
;-------------------------------------------
;-------------------------------------------
GENERATE_LEFT PROC NEAR
 MOV AL, [SI]
 STOSB
 INC SI  
 MOV AL, [SI]
 STOSB

 
 MOV BL, [SI]  ; BL CONTAINS THE NUMBER PART OF THE COORDINATE 
 DEC SI
DEC COUNTER
DEC COUNTER

GENERATE_LEFT_LOOP:

  DEC BL 

  CMP BL, 49
  JL OUTOFBOUNDS_LEFT


  DEC COUNTER
  DEC COUNTER
  MOV AL, [SI]
  STOSB
  MOV AL, BL
  STOSB

CMP COUNTER, 0
JNE GENERATE_LEFT_LOOP
  
MOV OUT_OF_BOUNDS, 0
RET

 OUTOFBOUNDS_LEFT:
 PRINT GOING_OUT_OF_BOUNDS
 MOV OUT_OF_BOUNDS, 1
 RET



GENERATE_LEFT ENDP
;-------------------------------------------
MAIN_MENU PROC NEAR 
BACK:
  CMP CHOICE, 1
  JNE CHECK_CHOICE2
  SOURCE_IS PATHFILENAME1

CHECK_CHOICE2:

  CMP CHOICE, 2
  JNE CHECK_CHOICE3
  SOURCE_IS PATHFILENAME2

CHECK_CHOICE3:

  CMP CHOICE, 3
  JNE CHECK_CHOICE4
  SOURCE_IS PATHFILENAME3

CHECK_CHOICE4:

  CMP CHOICE, 4
  JNE CHECK_CHOICE5
  SOURCE_IS PATHFILENAME4

CHECK_CHOICE5:

  CMP CHOICE, 5
  JNE CHECK_CHOICE6
  SOURCE_IS PATHFILENAME_HTP

CHECK_CHOICE6:

  CMP CHOICE, 6
  JNE DISPLAY_SCREEN
  SOURCE_IS PATHFILENAME_HS

DISPLAY_SCREEN:

  ;open file
  MOV AH, 3DH           ;requst open file
  MOV AL, 00            ;read only; 01 (write only); 10 (read/write)
  LEA DX, PATHFILENAME
  INT 21H
  JC DISPLAY_ERROR1
  MOV FILEHANDLE, AX

  ;read file
  MOV AH, 3FH           ;request read record
  MOV BX, FILEHANDLE    ;file handle
  MOV CX, 1500            ;record length
  LEA DX, RECORD_STR    ;address of input area
  INT 21H
  JC DISPLAY_ERROR2
  CMP AX, 00            ;zero bytes read?
  JE DISPLAY_ERROR3

  ;display record
  LEA DX, RECORD_STR
  MOV AH, 09
  INT 21H

  ;close file handle
  MOV AH, 3EH           ;request close file
  MOV BX, FILEHANDLE    ;file handle
  INT 21H

  CALL GET_KEY

  CMP RETURN_TO_GAME, 1
  JE RETURN

  JMP BACK

DISPLAY_ERROR1:
  LEA DX, ERROR1_STR
  MOV AH, 09
  INT 21H

  JMP EXIT_MAINMENU

DISPLAY_ERROR2:
  LEA DX, ERROR2_STR
  MOV AH, 09
  INT 21H

  JMP EXIT_MAINMENU

DISPLAY_ERROR3:
  LEA DX, ERROR3_STR
  MOV AH, 09
  INT 21H

EXIT_MAINMENU:
  MOV AH, 4CH
  INT 21H

RETURN:
RET

MAIN_MENU ENDP
;-------------------------------------------
GENERATE_RIGHT PROC NEAR
 MOV AL, [SI]
 STOSB
 INC SI  
 MOV AL, [SI]
 STOSB

 
 MOV BL, [SI]  ; BL CONTAINS THE NUMBER PART OF THE COORDINATE 
 DEC SI
DEC COUNTER
DEC COUNTER

GENERATE_RIGHT_LOOP:

  INC BL 

  CMP BL, 55
  JG OUTOFBOUNDS_RIGHT


  DEC COUNTER
  DEC COUNTER
  MOV AL, [SI]
  STOSB
  MOV AL, BL
  STOSB

CMP COUNTER, 0
JNE GENERATE_RIGHT_LOOP
  
MOV OUT_OF_BOUNDS, 0
RET

 OUTOFBOUNDS_RIGHT:
 PRINT GOING_OUT_OF_BOUNDS
 MOV OUT_OF_BOUNDS, 1
 RET



GENERATE_RIGHT ENDP
;-------------------------------------------
GET_SHIP PROC NEAR
    

    CALL GET_DIRECTION

    LEA SI, STARTING_POINT
    CMP AL, UP
    JNE CMP_DOWN
    CALL GENERATE_UP

    CMP OUT_OF_BOUNDS, 1
    JE EXIT_GET_SHIP
    JMP CHECK_IF_NO_COLLISION

    CMP_DOWN:
    CMP AL, DOWN
    JNE CMP_LEFT
    CALL GENERATE_DOWN

    CMP OUT_OF_BOUNDS, 1
    JE EXIT_GET_SHIP
    JMP CHECK_IF_NO_COLLISION

    CMP_LEFT:
    CMP AL, LEFT
    JNE CMP_RIGHT
    CALL GENERATE_LEFT

    CMP OUT_OF_BOUNDS, 1
    JE EXIT_GET_SHIP
    JMP CHECK_IF_NO_COLLISION

    CMP_RIGHT:
    CALL GENERATE_RIGHT

    CMP OUT_OF_BOUNDS, 1
    JE EXIT_GET_SHIP


    CHECK_IF_NO_COLLISION:
    EXIT_GET_SHIP:
    RET

GET_SHIP ENDP
;-------------------------------------------
CHECK_COORDINATE PROC NEAR
      CMP BYTE PTR [SI], 65
  JL CHECK_COORDINATE_EXIT

  CMP BYTE PTR [SI], 71
  JG CHECK_COORDINATE_EXIT

  INC SI

  CMP BYTE PTR [SI], 49
  JL CHECK_COORDINATE_EXIT

  CMP BYTE PTR [SI], 55
  JG CHECK_COORDINATE_EXIT

  MOV COORDINATE_CORRECT_FLAG, TRUE
  RET

  CHECK_COORDINATE_EXIT:
  MOV COORDINATE_CORRECT_FLAG, NULL
  RET

CHECK_COORDINATE ENDP
;---------------------------------------
P1UPDATE_SCREEN PROC NEAR
  MOV BH, 00H
  CALL CLEAR_SCREEN
  SET_CURSOR 7,2
  MOV BH, 0FH
  CALL CLEAR_SCREEN


  PRINT GUESSBOARD
  PRINT COLUMNS
  PRINT UPPERBORDER


  PRINT P1_GUESSBOARD_ROW_A
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_B
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_C
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_D
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_E
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_F
  PRINT INTERNALBORDER

  PRINT P1_GUESSBOARD_ROW_G

  PRINT LOWERBORDER


;------------------ PLAYER 2 SIDE--------------

  SET_CURSOR 49,2
  PRINT YOURBOARD

  SET_CURSOR 39,3
  PRINT COLUMNS2

  SET_CURSOR 39,4
  PRINT UPPERBORDER2

  SET_CURSOR 39,5
  PRINT P2_REALBOARD_ROW_A

  SET_CURSOR 39,6
  PRINT INTERNALBORDER2

  SET_CURSOR 39,7
  PRINT P2_REALBOARD_ROW_B

  SET_CURSOR 39,8
  PRINT INTERNALBORDER2

  SET_CURSOR 39,9
  PRINT P2_REALBOARD_ROW_C

  SET_CURSOR 39,10
  PRINT INTERNALBORDER2

  SET_CURSOR 39,11
  PRINT P2_REALBOARD_ROW_D

  SET_CURSOR 39,12
  PRINT INTERNALBORDER2

  SET_CURSOR 39,13
  PRINT P2_REALBOARD_ROW_E

  SET_CURSOR 39,14
  PRINT INTERNALBORDER2

  SET_CURSOR 39,15
  PRINT P2_REALBOARD_ROW_F

  SET_CURSOR 39,16
  PRINT INTERNALBORDER2

  SET_CURSOR 39,17
  PRINT P2_REALBOARD_ROW_G

  SET_CURSOR 39,18
  PRINT LOWERBORDER2

  RET

P1UPDATE_SCREEN ENDP
;---------------------------------------
;---------------------------------------
P2UPDATE_SCREEN PROC NEAR
  MOV BH, 00H
  CALL CLEAR_SCREEN
  SET_CURSOR 7,2
  MOV BH, 0FH
  CALL CLEAR_SCREEN


  PRINT YOURBOARD
  PRINT COLUMNS
  PRINT UPPERBORDER


  PRINT P1_REALBOARD_ROW_A
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_B
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_C
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_D
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_E
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_F
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_G

  PRINT LOWERBORDER


;------------------ PLAYER 2 SIDE--------------

  SET_CURSOR 49,2
  PRINT GUESSBOARD

  SET_CURSOR 39,3
  PRINT COLUMNS2

  SET_CURSOR 39,4
  PRINT UPPERBORDER2

  SET_CURSOR 39,5
  PRINT P2_GUESSBOARD_ROW_A

  SET_CURSOR 39,6
  PRINT INTERNALBORDER2

  SET_CURSOR 39,7
  PRINT P2_GUESSBOARD_ROW_B

  SET_CURSOR 39,8
  PRINT INTERNALBORDER2

  SET_CURSOR 39,9
  PRINT P2_GUESSBOARD_ROW_C

  SET_CURSOR 39,10
  PRINT INTERNALBORDER2

  SET_CURSOR 39,11
  PRINT P2_GUESSBOARD_ROW_D

  SET_CURSOR 39,12
  PRINT INTERNALBORDER2

  SET_CURSOR 39,13
  PRINT P2_GUESSBOARD_ROW_E

  SET_CURSOR 39,14
  PRINT INTERNALBORDER2

  SET_CURSOR 39,15
  PRINT P2_GUESSBOARD_ROW_F

  SET_CURSOR 39,16
  PRINT INTERNALBORDER2

  SET_CURSOR 39,17
  PRINT P2_GUESSBOARD_ROW_G

  SET_CURSOR 39,18
  PRINT LOWERBORDER2

  RET

P2UPDATE_SCREEN ENDP
;-------------------------------------------
P1ANDP2_SCREEN PROC NEAR
  MOV BH, 00H
  CALL CLEAR_SCREEN
  SET_CURSOR 7,2
  MOV BH, 0FH
  CALL CLEAR_SCREEN


  PRINT YOURBOARD
  PRINT COLUMNS
  PRINT UPPERBORDER


  PRINT P1_REALBOARD_ROW_A
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_B
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_C
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_D
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_E
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_F
  PRINT INTERNALBORDER

  PRINT P1_REALBOARD_ROW_G

  PRINT LOWERBORDER


;------------------ PLAYER 2 SIDE--------------

  SET_CURSOR 49,2
  PRINT YOURBOARD

  SET_CURSOR 39,3
  PRINT COLUMNS2

  SET_CURSOR 39,4
  PRINT UPPERBORDER2

  SET_CURSOR 39,5
  PRINT P2_REALBOARD_ROW_A

  SET_CURSOR 39,6
  PRINT INTERNALBORDER2

  SET_CURSOR 39,7
  PRINT P2_REALBOARD_ROW_B

  SET_CURSOR 39,8
  PRINT INTERNALBORDER2

  SET_CURSOR 39,9
  PRINT P2_REALBOARD_ROW_C

  SET_CURSOR 39,10
  PRINT INTERNALBORDER2

  SET_CURSOR 39,11
  PRINT P2_REALBOARD_ROW_D

  SET_CURSOR 39,12
  PRINT INTERNALBORDER2

  SET_CURSOR 39,13
  PRINT P2_REALBOARD_ROW_E

  SET_CURSOR 39,14
  PRINT INTERNALBORDER2

  SET_CURSOR 39,15
  PRINT P2_REALBOARD_ROW_F

  SET_CURSOR 39,16
  PRINT INTERNALBORDER2

  SET_CURSOR 39,17
  PRINT P2_REALBOARD_ROW_G

  SET_CURSOR 39,18
  PRINT LOWERBORDER2

  RET

P1ANDP2_SCREEN ENDP
;---------------------------------------
P1SET_SHIP PROC NEAR
 
  
P1SET_SHIP_LOOP:
  MOV AL, [SI]

  CMP AL,'A'
  JNE P1CHECK_SET_SHIP_B
  LEA DI, P1_REALBOARD_ROW_A
  JMP END_P1CHECK_ROW

  P1CHECK_SET_SHIP_B:
    CMP AL,'B'
    JNE P1CHECK_SET_SHIP_C
    LEA DI, P1_REALBOARD_ROW_B
    JMP END_P1CHECK_ROW
  P1CHECK_SET_SHIP_C:
    CMP AL,'C'
    JNE P1CHECK_SET_SHIP_D
    LEA DI, P1_REALBOARD_ROW_C
    JMP END_P1CHECK_ROW
  P1CHECK_SET_SHIP_D:
    CMP AL,'D'
    JNE P1CHECK_SET_SHIP_E
    LEA DI, P1_REALBOARD_ROW_D
    JMP END_P1CHECK_ROW
  P1CHECK_SET_SHIP_E:
    CMP AL,'E'
    JNE P1CHECK_SET_SHIP_F
    LEA DI, P1_REALBOARD_ROW_E
    JMP END_P1CHECK_ROW
  P1CHECK_SET_SHIP_F:
    CMP AL,'F'
    JNE P1CHECK_SET_SHIP_G
    LEA DI, P1_REALBOARD_ROW_F
    JMP END_P1CHECK_ROW
  P1CHECK_SET_SHIP_G:
    LEA DI, P1_REALBOARD_ROW_G

    END_P1CHECK_ROW:


  ;IDENTIFY WHICH COLUMN THE PROGRAM WILL PRINT TO

  INC SI
  DEC CX

  MOV AL, [SI]
  SUB AL, 48
  MOV BX, 4
  MUL BX
  ADD DI, AL
  MOV AL, 'o'
  INC DI
  INC DI
  STOSB
  
  INC SI
  LOOP P1SET_SHIP_LOOP


  RET
P1SET_SHIP ENDP
;---------------------------------------
;---------------------------------------
P2SET_SHIP PROC NEAR
 
  
P2SET_SHIP_LOOP:
  MOV AL, [SI]

  CMP AL,'A'
  JNE P2CHECK_SET_SHIP_B
  LEA DI, P2_REALBOARD_ROW_A
  JMP END_P2CHECK_ROW

  P2CHECK_SET_SHIP_B:
    CMP AL,'B'
    JNE P2CHECK_SET_SHIP_C
    LEA DI, P2_REALBOARD_ROW_B
    JMP END_P2CHECK_ROW
  P2CHECK_SET_SHIP_C:
    CMP AL,'C'
    JNE P2CHECK_SET_SHIP_D
    LEA DI, P2_REALBOARD_ROW_C
    JMP END_P2CHECK_ROW
  P2CHECK_SET_SHIP_D:
    CMP AL,'D'
    JNE P2CHECK_SET_SHIP_E
    LEA DI, P2_REALBOARD_ROW_D
    JMP END_P2CHECK_ROW
  P2CHECK_SET_SHIP_E:
    CMP AL,'E'
    JNE P2CHECK_SET_SHIP_F
    LEA DI, P2_REALBOARD_ROW_E
    JMP END_P2CHECK_ROW
  P2CHECK_SET_SHIP_F:
    CMP AL,'F'
    JNE P2CHECK_SET_SHIP_G
    LEA DI, P2_REALBOARD_ROW_F
    JMP END_P2CHECK_ROW
  P2CHECK_SET_SHIP_G:
    LEA DI, P2_REALBOARD_ROW_G

    END_P2CHECK_ROW:


  ;IDENTIFY WHICH COLUMN THE PROGRAM WILL PRINT TO

  INC SI
  DEC CX

  MOV AL, [SI]
  SUB AL, 48
  MOV BX, 4
  MUL BX
  ADD DI, AL
  MOV AL, 'o'
  STOSB
  
  INC SI
  LOOP P2SET_SHIP_LOOP


  RET
P2SET_SHIP ENDP
;---------------------------------------
GET_TORPEDO PROC NEAR

JMP SKIP_PRINT_ERROR_TORPEDO
PRINT_ERROR_TORPEDO:
PRINT INVALID_TORPEDO

SKIP_PRINT_ERROR_TORPEDO:

PRINT INPUT_TARGET
GET_INPUT TORPEDO, TORPEDO_LENGTH

LEA SI, TORPEDO
CALL CHECK_COORDINATE
CMP COORDINATE_CORRECT_FLAG, NULL
JE PRINT_ERROR_TORPEDO


RET

GET_TORPEDO ENDP 
;---------------------------------------
P2GET_TORPEDO PROC NEAR

JMP P2SKIP_PRINT_ERROR_TORPEDO
P2PRINT_ERROR_TORPEDO:
PRINT INVALID_TORPEDO

P2SKIP_PRINT_ERROR_TORPEDO:

SET_CURSOR 39,19
PRINT P2INPUT_TARGET
GET_INPUT TORPEDO, TORPEDO_LENGTH

LEA SI, TORPEDO
CALL CHECK_COORDINATE
CMP COORDINATE_CORRECT_FLAG, NULL
JE P2PRINT_ERROR_TORPEDO


RET

P2GET_TORPEDO ENDP
;---------------------------------------
P1MARK_BOARD PROC NEAR

 CMP TORPEDO, 'S'
 JNE OK
 MOV AH, 4CH
 INT 21H

 OK:
  LEA SI, TORPEDO
  MOV AL, [SI]

  CMP AL,'A'
  JNE CHECKB
  JMP IS_A

CHECKB:
  CMP AL,'B'
  JNE CHECKC
  JMP IS_B

CHECKC:
  CMP AL,'C'
  JNE CHECKD
  JMP IS_C

CHECKD:
  CMP AL,'D'
  JNE CHECKE
  JMP IS_D

CHECKE:
  CMP AL,'E'
  JNE CHECKF
  JMP IS_E

CHECKF:
  CMP AL,'F'
  JNE CHECKG
  JMP IS_F

CHECKG:
  JMP IS_G
IS_A:
MARK_BOARD P1_GUESSBOARD_ROW_A, P2_REALBOARD_ROW_A, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_A, TORPEDO
  
  
  JMP CHANGE_TURN

IS_B:
  MARK_BOARD P1_GUESSBOARD_ROW_B, P2_REALBOARD_ROW_B, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_B, TORPEDO
  
  
  JMP CHANGE_TURN

IS_C:
MARK_BOARD P1_GUESSBOARD_ROW_C, P2_REALBOARD_ROW_C, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_C, TORPEDO
  
  
  JMP CHANGE_TURN

IS_D:
MARK_BOARD P1_GUESSBOARD_ROW_D, P2_REALBOARD_ROW_D, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_D, TORPEDO
  
  
  JMP CHANGE_TURN

IS_E:
MARK_BOARD P1_GUESSBOARD_ROW_E, P2_REALBOARD_ROW_E, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_E, TORPEDO
  
  
  JMP CHANGE_TURN

IS_F:
MARK_BOARD P1_GUESSBOARD_ROW_F, P2_REALBOARD_ROW_F, TORPEDO
  P1MARK_BOARD2 P2_REALBOARD_ROW_F, TORPEDO
  
  
  JMP CHANGE_TURN

IS_G:
  MARK_BOARD P1_GUESSBOARD_ROW_G, P2_REALBOARD_ROW_G, TORPEDO
   P1MARK_BOARD2 P2_REALBOARD_ROW_G, TORPEDO

 


CHANGE_TURN:


RET
P1MARK_BOARD ENDP
;---------------------------------------
;---------------------------------------
P2MARK_BOARD PROC NEAR

 CMP TORPEDO, 'S'
 JNE P2OK
 MOV AH, 4CH
 INT 21H

 P2OK:
  LEA SI, TORPEDO
  MOV AL, [SI]

  CMP AL,'A'
  JNE P2CHECKB
  JMP P2IS_A

P2CHECKB:
  CMP AL,'B'
  JNE P2CHECKC
  JMP P2IS_B

P2CHECKC:
  CMP AL,'C'
  JNE P2CHECKD
  JMP P2IS_C

P2CHECKD:
  CMP AL,'D'
  JNE P2CHECKE
  JMP P2IS_D

P2CHECKE:
  CMP AL,'E'
  JNE P2CHECKF
  JMP P2IS_E

P2CHECKF:
  CMP AL,'F'
  JNE P2CHECKG
  JMP P2IS_F

P2CHECKG:
  JMP P2IS_G
P2IS_A:
  P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_A,P1_REALBOARD_ROW_A, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_A, TORPEDO
  
  RET

P2IS_B:
  
  P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_B, P1_REALBOARD_ROW_B, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_B, TORPEDO

  RET

P2IS_C:
  P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_C, P1_REALBOARD_ROW_C, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_C, TORPEDO
  

  RET

P2IS_D:

P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_D, P1_REALBOARD_ROW_D, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_D, TORPEDO
  

  RET

P2IS_E:
    
    P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_E, P1_REALBOARD_ROW_E, TORPEDO
   P2MARK_BOARD2 P1_REALBOARD_ROW_E, TORPEDO
  
 
  RET

P2IS_F:
P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_F, P1_REALBOARD_ROW_F, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_F, TORPEDO
  
  RET

P2IS_G:
   P2MARK_BOARDMACRO P2_GUESSBOARD_ROW_G, P1_REALBOARD_ROW_G, TORPEDO
  P2MARK_BOARD2 P1_REALBOARD_ROW_G, TORPEDO
 



RET
P2MARK_BOARD ENDP
;-------------------------------------------
;---------------------------------------

END START

