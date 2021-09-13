*-----------------------------------------------------------
* Title      : HOMEWORK_2 QUESTION 3
* Written by : BISRAT ASEFAW
* Date       : 11/22/2020
* Description: ADDR1,ADDSUM,CARRYBIT
*-----------------------------------------------------------



Addr1       DS.L         10                    
Addsum      DS.W         10                 
CarryBit    DS.B         10
TARGET      EQU          $A000


    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    LEA     InMessage,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0
    TRAP    #15
    
    *MOVE.B  #24,$6010  *TEST CASE 1
    
    MOVE.B   D1,$A000
    *CLR.L    D1
    
    MOVE.B   $A000,D1
    MOVEA.L  #$6000,A2
    
    CLR      D2
    MOVE.B   TARGET,D2
    
LOOP   CMPA.L       #$8000,A2
       BGT          NOTFOUND
       CMP.B        (A2)+,D2
       BEQ          FOUND

       BRA          LOOP

NOTFOUND    MOVE.L  #$6000,Addr1
            MOVE.L  Addr1,A2
            BRA     ADDALL
            

FOUND    ADD.L     #-1,A2
         MOVE.L    A2,Addr1
         BRA       ADDALL            


ADDALL   MOVEA.L   A2,A5
         ADDA.L    #512,A5      *MOVE.B    #0,CarryBit *FOR TESTING 
         CLR.B     CarryBit     *MOVE.W    #0,Addsum    *FOR TESTING 
         CLR.W     Addsum
         CLR       D1
         CLR       D5
                                        *CLR   D2 FOR TESTING 
         
ADD     CMPA.L    A5,A2
        BGE       DONE
                                        *ADD       #1,D2 *FOR TESTING 
        MOVE.B    (A2)+,D1
        ADD.W     D1,Addsum
        BCS       CARRYDETECTED
        
        BRA       ADD
        
CARRYDETECTED   CMP.B       #0,CarryBit
                BNE         ADD             *LOOPS BACK IF THE CARRY BIT IS ALREADY SET 
                MOVE.B      #1,CarryBit
                BRA         ADD
                
                
DONE    LEA     ADDRESSPRINT,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        CLR     D1
        
        MOVE.L  Addr1,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        CLR     D1
        
        LEA     ADD_SUM,A1
        MOVE.B  #14,D0
        TRAP    #15
        
                                *MOVE.W  D5,Addsum  TESTING 
        
        CLR.W   D1
        MOVE.W  Addsum,D1
        MOVE.B  #3,D0
        TRAP    #15
        
        
        LEA     Carr_yBit,A1
        MOVE.B  #14,D0
        TRAP    #15

        CLR.L   D1
        MOVE.B  (CarryBit),D1
        MOVE    #3,D0
        TRAP    #15



         

    SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU             $0D                   
LF          EQU             $0A                 

InMessage       DC.B    'INTER A HEX BYTE :',0
ADDRESSPRINT    DC.B    CR,LF,'Addr1 :',0
ADD_SUM         DC.B    CR,LF,'Addsum :',0
Carr_yBit       DC.B    CR,LF,'CarryBit :',0
    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
