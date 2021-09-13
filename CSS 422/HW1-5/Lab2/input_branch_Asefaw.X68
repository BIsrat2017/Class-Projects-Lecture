*-----------------------------------------------------------
* Title      : CSS 422 
* Written by : BISRAT ASEAW
* Date       : OCT. 9,2021
* Description: LAB1
*-----------------------------------------------------------
CR  EQU     $0D
LF  EQU     $0A

    
START:      ORG    $1000        ; first instruction of program

* Put program code here

*------- CODE FOR OUTPUT ----
LOOP       LEA     MESSAGE,A1
           MOVE.B  #14,D0
           TRAP    #15
        
*-------- CODE FOR INPUT ---
           MOVE.B  #4,D0
           TRAP    #15
           CMP.L   #1972554,D1
           BEQ     DONE
        
           CMP.L   #20,D1
           BLT     INVALID
           CMP.L   #25,D1
           BGT     INVALID 
           
*-------- CODE FOR FIGURING OUT THE NUMBER ---  
           CMP.L    #20,D1
           BNE      TWENTYONE
           LEA      DISP20,A1
           MOVE.B   #14,D0
           TRAP     #15
           BRA      LOOP

TWENTYONE  CMP.L    #21,D1
           BNE      TWENTYTWO
           LEA      DISP21,A1
           MOVE.B   #14,D0
           TRAP     #15
           BRA      LOOP
           
TWENTYTWO  CMP.L    #22,D1
           BNE      TWENTYTHREE
           LEA      DISP22,A1
           MOVE.B   #14,D0
           TRAP     #15
           BRA      LOOP
           
TWENTYTHREE CMP.L    #23,D1
            BNE      TWENTYFOUR
            LEA      DISP23,A1
            MOVE.B   #14,D0
            TRAP     #15
            BRA      LOOP

TWENTYFOUR  CMP.L    #24,D1
           BNE      TWENTYFIVE
           LEA      DISP24,A1
           MOVE.B   #14,D0
           TRAP     #15
           BRA      LOOP 
                  
TWENTYFIVE LEA      DISP25,A1
           MOVE.B   #14,D0
           TRAP     #15
           BRA      LOOP
           
           BRA     LOOP    
 
INVALID      LEA     INV,A1
             MOVE.B  #14,D0
             TRAP    #15
             BRA     LOOP 

DONE    MOVE.B  #9,D0
        TRAP    #15
 
MESSAGE DC.B    'Enter a number, Enter 1972554 to exit: ',0
INV     DC.B    'WARNING!!!, NOT BETWEEN 20 AND 25',CR,LF,0
DISP20  DC.B    'Correct 3.5!! I GOT 20  VALID ',CR,LF,0
DISP21  DC.B    'Nice 3.6!! I GOT 21  VALID',CR,LF,0
DISP22  DC.B    'Great 3.8!! Pass, I GOT 22  VALID',CR,LF,0
DISP23  DC.B    'Swee 3.9t!!, I GOT 23  VALID',CR,LF,0
DISP24  DC.B    'You Got It 3.9!!, I GOT 24  VALID',CR,LF,0
DISP25  DC.B    'Excellent 4.0!!, I GOT 25  VALID',CR,LF,0
    


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
