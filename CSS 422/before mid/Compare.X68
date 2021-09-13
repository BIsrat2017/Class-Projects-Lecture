*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
START        MOVE.B DATA,D0
             MOVE.B  DATA+2,D1
             CMP.B  D1,D0
             BGE    NEXT1
             MOVE.B D1,D0

NEXT1       MOVE.B DATA+2,D1
            CMP.B  D1,D0
            BGE    NEXT2
            MOVE.B D1,D0
            
            

NEXT2       MOVE.B DATA+2,D1
            CMP.B  D1,D0
            BGE    NEXT3
            MOVE.B D1,MAX_NUM
            BRA  DONE

NEXT3       MOVE.B  D0,MAX_NUM
DONE        STOP    #$2700

DATA        DC.B    $05,$4C,$42,$7F
MAX_NUM     DS.B    1
            END     $400

*Data for test program *Save result here


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
