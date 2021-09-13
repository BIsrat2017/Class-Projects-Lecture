*-----------------------------------------------------------
* Title      :  CHANGE FROM IEEE-32 TO SIGN, EXPONENT,MANTISA
* Written by :  BISRAT ASEFAW
* Date       :  10/23/2020
* Description:  PROGRAM TO CHANGE FROM HEX-IEEE TO SIGN, EXPONENT,MANTISA
*-----------------------------------------------------------


USERINPUT       EQU     $5000
USERINPUTDATA   EQU     $5010
UERINPUTINHEX   EQU     $5020

    ORG    $4000
START:                  ; first instruction of program

* Put program code here

    LEA     MESSAGE,A1
    MOVE.L  #14,D0
    TRAP    #15
    
    
       MOVE.L  #2,D0
       TRAP    #15
       SUBI.L  #2,D1                * SUBTRACTS 2 TO THE LENGTH OF CHARACTER INPUT B/C IT SHIFTS TWO CHAR
                                    * CAUSING TWO CHARACTER TO BE SHEFTED OUT OR BECOMING OVERFLOW and
                                    * ignoring last two digits wont affect our result  
    
      MOVE.L     A1,USERINPUT           *SAVING USER INPUT ADDRESS
      MOVE.L    (A1),USERINPUTDATA      *SAVING USER INPUT DATA
      
      
      CLR.L    D2                       *CLEARING DATA REGISTERS D2,D3 FOR STORING 
      CLR.L    D3
    
CHANGE  MOVE.B   (A1)+,D2               *LOOPING THROUGH USER INPUT TO CONVERT TO HEX VALUE
        CMP.B    #0,D1
        BEQ      DONE                   * WHEN WE FINISH CHANGING AND SAVE THE INPUT CHARACTER ON D3
        CMP.B    #$40,D2                * WE BRACH TO DONE TO PERFORM SPLITING OF SIGN,EXPONENT, MANTISSA
        BGE      WORD_CHANGE            *BRANCH FOR A CHARACTER A-F
        BLT      NUM_CHANGE             *BRANCH FOR A NUMBER 0-9
        
    
WORD_CHANGE SUB.B   #$37,D2             * CHARACTER CONVERTER BY SUBTRACTING 37 AND SAVING IT IN D2

           LSL.B   #4, D2               * LOGIC SHIFT LEFT TO CREATE A SPACE FOR POSITIONING INPUTS 
           MOVE.B  D2, D3               * MOVE IT TO D3 TO ACCUMULATE CHANGED INPUTS   
           LSL.L   #4, D3               * LOGIC SHIFT LEFT TO CREATE A SPACE FOR OTHER INPUTS
           SUB.B   #1,D1                * SUBTACT 1 FROM THE NUMBER OF CHARACTERS INPUT 
           BRA     CHANGE               *TAKES BACK TO THE BEGINIGN TO REPEAT CHANGING CHAT BY CHAR
            
NUM_CHANGE  SUB.B    #$30,D2            *CHANGES THE INPUT CHARACTER FOR NUMBER AND DO THE NECESSARY SHIFTING 
            LSL.B   #4, D2
            MOVE.B  D2, D3
            LSL.L   #4, D3
            SUB.B   #1,D1
            BRA     CHANGE              *TAKES BACK TO THE BEGINIGN TO REPEAT CHANGING CHAT BY CHAR
            

                
  
DONE MOVE.L   D3,D1                  * START CHANGING THE INPUT           
    
    MOVE.L   D3,UERINPUTINHEX
    
    *CARRY-BIT
    LEA     SIGN,A1                  *DISPLAY THE SIGNBIT MESSAGE
    MOVE.B  #14,D0
    TRAP    #15
    
    
    LSL.L   #1,D1
    BCS     NEGATIVENUM             *BRANCH FOR NEGATIVE NUMBER 
    LEA     POSNUM,A1               *DISPLAY POSITIVE SIGN
    MOVE.B  #14,D0
    TRAP    #15
    BRA     EXPONENTNUM             *BRANCH FOR EXPONENT 
    
NEGATIVENUM   LEA     NEGNUM,A1     *DISPLAY NEGATIVE SIGN
              MOVE.B  #14,D0
              TRAP    #15

EXPONENTNUM   LEA     EXPONENT,A1   *DISPLAY THE EXPONENT MESSAGE
              MOVE.B  #14,D0
              TRAP    #15
              
              ROL.L     #8,D1   *PERFORM SHIFTING FOR EXPONENT 
              MOVE.L    D1,D3
              
              CLR.L     D1      
              MOVE.B    D3,D1
              
              MOVE.B    #3,D0
              TRAP      #15   
              

         
              LEA      MANTISSA,A1        *DISPLAY THE MANTISSA MESSAGE

              MOVE.B   #14,D0
              TRAP     #15
              
              LSR.L     #8,D3           *PERFORM SHIFTING FOR MANTISSA 
              LSR.L     #1,D3
                                        *PUSH THE ZEROS OUT              
PUSHZEROS    BTST      #$0,D3
             BNE       CLEARED
             LSR.L     #1,D3
             BRA        PUSHZEROS
            
             
              
CLEARED      CLR.L     D1           
             MOVE.L    D3,D1
             
             MOVE.B    #3,D0        *DISPLAY MANTISSA VALUE 
             TRAP      #15
   

     
    
    SIMHALT             ; halt simulator

* Put variables and constants here
CR          EQU             $0D                   
LF          EQU             $0A                 

MESSAGE     DC.B     'Please enter IEEE 32-bit floating point number in hexadecimal: ',0
SIGN        DC.B     CR,LF,'Sign bit: ',0
EXPONENT    DC.B     CR,LF,'EXPONENET: ',0
MANTISSA     DC.B     CR,LF,'MANTISSA: ',0
POSNUM      DC.B     '+',0
NEGNUM      DC.B     '-',0
    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
