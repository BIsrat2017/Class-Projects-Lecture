*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    
    LEA         MESSAGE,A1
    MOVE.B      #14,D0
    TRAP        #15
    

CR    EQU     $0D
LF    EQU     $0A

MESSAGE DC.B    'Hello, my name is Bisrat,Asefaw',CR,LF
        DC.B    'I am senior student in UWB.',CR,LF,'I study CSSE,hopping one day ',CR,LF
        DC.B    'I am going to be a programer or engineer.',CR,LF
        DC.B    'I am graduating in June,2021',CR,LF,CR,LF
        DC.B    'Thank you for listening',CR,LF,0



* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
