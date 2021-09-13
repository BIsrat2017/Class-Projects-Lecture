*-----------------------------------------------------------
* Title      : Decode a floating point number
* Written by : Regie Pineda
* Date       : 10/22/2019
* Description: Given a 32-Bit Floating point Hexadecimal, 
*              display the sign, exponent, and mantissa.
*-----------------------------------------------------------
* Declares the SignBit, Exponent, and Mantissa 
SignBit     EQU $580
Exponent    EQU $582
Mantissa    EQU $584
    ORG    $4000 : Starts at address $4000
START:                  * first instruction of program

*----------Put program code here----------
    LEA     PROMPTONE, A1   : Prompt the user for input
    MOVE.B  #14, D0     : Loads TRAP code 14
    TRAP    #15         : Hardware interrupt for I/O
    MOVE.B  #2, D0      : Loads TRAP code 2
    TRAP    #15         : Hardware interrupt for I/O
    MOVEA.L #$56A, A5   : Store start address in A5     
    MOVE.B  #9, D2      : 9 is the number of chars that should be read
    
* This subroutine is used when the value in D2 continues while 
* D2 is greater than 0 and decrements D2 each time
* Converts the input values for appropriate use. 
CONVeRTINPUT   
    MOVE.B  (A1)+,D4    : Copy the firt byte to D4 and increment
    SUB.B   #1,D2       : Decrement the for loop subroutine
    CMP.B   #0,D2       : Checks if subroutine exists
    BEQ     MOVEBITSHELPER  : If it is, branch to MOVEBITSHELPER  
    CMP.B   #$40,D4       : Otherwise, check if first byte of user input is a letter
    BGT     CONVERTLETTER : If greater than '40', it may be letter
    CMP.B   #$3A,D4       : Otherwise, check if its a number since $3A
    BLT     CONVERTNUMBER : If it is smaller, then branch to CONVERTNUMBER

* This is a subroutine for converting letters from ASCII    
CONVERTLETTER
    CMP.B   #$46,D4 : Make sure the byte stored in D4 is valid
    BGT     ERRORHANDLE  : If it isnt, then branch to handle error
    SUB.B   #$37,D4 : Subtract $37 from the Byte for conversion
    MOVE.B  D4,(A5)+   : Move it to A5 and increment A5
    BRA CONVERTINPUT    : Branch to CONVERTINPUT   

* This is a subroutine for converting numbersfrom ASCII 
CONVERTNUMBER
    CMP.B   #$30,D4   : Checks the read in byte    
    BLT     ERRORHANDLE  : If its smaller, branch to error handling
    SUB.B   #$30,D4    : Sub $30 from the val in D4
    MOVE.B  D4,(A5)+   : Move that value to A5 and increment it
    BRA CONVERTINPUT   : Branch to CONVERTINPUT      

* This is the Error handling subroutine that
* stores the address at A5 indirectly with 0's
ERRORHANDLE 
    MOVE.B  #$00,(A5)+ : Stores $00 in A5 and increments it
    BRA CONVERTINPUT   : Branch to CONVERTINPUT     

* This subroutine is used to prepare for MOVEBITSSUBROUTINE
MOVEBITSHELPER
    MOVEA.L #$56A,A5   : Reset the start address in A5
    MOVE.B  #5,D2      : Store decimal val 5 in D2

* This subroutine does logical shifts on values
* to make sure thatD4 register has correct HEX values
MOVEBITSSUBROUTINE 
    SUB.B   #1,D2   : Startby decrementing  
    CMP.B   #0,D2  : Checks if its empty  
    BEQ     DERIVESIGNBIT   : If it is, bit movement is complete
    MOVE.B (A5)+,D3     : Otherwise, start to copy val from A5 to D3 and move to next
    LSL.L   #4, D3   : Uses logical shift left by four bits
    ADD.B  (A5)+,D3  : Add the next byte from A5 register
    LSL.L   #8,D4    : Does long shift left on D4 
    ADD.B   D3,D4    : Add the bits shifted copy from D3 to D4
    BRA MOVEBITSSUBROUTINE   : Branch to start again     

* This is the subroutine for finding the SignBit 
DERIVESIGNBIT
    MOVE.L  D4,D3    : Move the hex val derived from user to D3    
    MOVE.B  #31,D2   : Move '31' into D2     
    LSR.L   D2,D3    : Shift left
    MOVE.B  #$2D,SignBit   : Set default val as '-'
    CMP.B   #$1,D3   : Checks after doing the logical shift   
    BEQ     DERIVEEXPONENT   : If equal, branch to DERIVEEXPONENT  
    MOVE.B  #$2B,SignBit  : Otherwise, set the SignBit to '+' 

* This subroutine is for calculating the exponent
DERIVEEXPONENT
    MOVE.L  D4,D3    : Move the hex val from user to D3   
    BCLR.L  #31,D3   : Clear most significant bit   
    MOVE.B  #23,D2   : Copy '23' into D2      
    LSR.L   D2,D3    : Perform shift        
    MOVE.W  D3,Exponent  : Move the derived val into Exponent
  
* This is the subroutine for calculating the Mantissa
DERIVEMANTISSA
    MOVE.L  D4,D3   : Copy the hex val derived from user to D3   
    MOVE.B  #9,D2   : Copy '9' to D2      
    LSL.L   D2,D3   : Shift the val by 9 bits left      
    MOVE.B  #28,D2  : Copy '28' into D2
    LSR.L   D2,D3   : Shift hex val by 28 bits      
    MOVE.W  D3,Mantissa    : Move the derived val into the var Manrissa
* This is the printing subroutine
PRINT
    LEA     LabelSigBit,A1  : Print the SignBit var label
    MOVE.B  #14,D0         
    TRAP    #15               
    MOVE.B  SignBit, D1     : Load the SignBit into D1  
    MOVE.B  #6,D0            
    TRAP    #15             
    
    LEA     LabelExp,A1     : Print out the Exponent var label 
    MOVE.B  #14,D0              
    TRAP    #15          
    MOVE.W  Exponent, D1    : Load the Exponent into D1
    MOVE.B  #3,D0           : Display the val in D1 as decimal    
    TRAP    #15             
    
    LEA     LabelManti,A1   : Print out the Mantissa var label
    MOVE.B  #14,D0         
    TRAP    #15              
    MOVE.W  Mantissa,D1     : Load Mantissa into D1  
    MOVE.B  #3,D0           : Display val in D1 as decimal
    TRAP    #15             
 
    SIMHALT             ; halt simulator

CR      EQU $0D    : ASCII Carriage Return         
LF      EQU $0A    : ASCII Line Feed       
* Prompt the user
PROMPTONE	DC.B CR,'Please enter a IEEE 32-bit floating point number in hexadecimal: ',CR,LF,0
* Print out variables
LabelSigBit	DC.B CR, LF,'Sign Bit: ',0
LabelExp	DC.B CR, LF,'Exponent: ',0
LabelManti  DC.B CR, LF,'Mantissa: ',0

    END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
