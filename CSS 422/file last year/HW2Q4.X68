*-----------------------------------------------------------
* Title      : HW 2 Q4
* Written by : Sepehr Karimi
* Date       : 04/30/2020
* Description: 
* Write a program in 68K assembly code to decipher IEEE 32-bit 
* floating point hexadecimal representation to sign bit, exponent 
* bits, and mantissa bits. Write the program that satisfies the following specifications:
* 1- Your program should start at the memory location $4000.

* 2- The program should print the instruction in the output window to get a user input: 
* "Please enter IEEE 32-bit floating point number in hexadecimal":

* 3- User Input should be in IEEE 32-bit floating point number Hexadecimal format. 
* You should not hardcode the inputs. You may ignore sanity check on corner cases, 
* but assume user inputs are always in an expected format.

* 4- After getting the user input, save the input number into a variable that you define, 
* but not into a register.

* 5- Print out the following information to the output window: Sign bit: ("+" or "-"), 
* Exponent: (in decimal) and Mantissa: (in decimal). For example, if the user input is C0680000, 
* then the output window shows:
* Sign bit: - 
* Exponent:128
* Mantissa: 13

*-----------------------------------------------------------
 
SignBit             EQU             $600
Exponent            EQU             $602
Mantissa            EQU             $604
CR                  EQU             $0D          : CARRIAGE RETURN     
LF                  EQU             $0A          : LINE FEED
 
    ORG         $4000           *START AT ADDRESS $4000
    
START:                  

*Put program code here

*------------------------GET THE USER INPUT-------------------------------
    LEA            PROMPT, A1                    * PROMPT USER INPUT
    MOVE.B         #14, D0                       * COPY INSTRUCTION 14 INTO D0
    TRAP           #15                           * TO DISPLAY OUTPUT
    MOVE.B         #2, D0                        * COPY INSTRUCTION 2 TO D0
    TRAP           #15                           * TO DISPLAY OUTPUT
    MOVEA.L        #$56A, A5                     * STORE 58A UB ADDRESS A5
    MOVE.B         #9, D2                        * COPY 9 INT D2 WHICH REPRESENTS 
                                                 * THE NUMBER OF CHARS
    
*------------------------INPUT_CONVERT------------------------------------
INPUT_CONVERT                                    * THE SUBROUTINE USED TO CONVERT 
                                                 * INPUT VALUES TO PROPER FORMAT
                                                 
    MOVE.B         (A1)+,D4                      * COPY THE CONTENT OF A1 TO D4
    SUB.B          #1,D2                         * DECREMENT THE FOR LOOP COUNTER
    CMP.B          #0,D2                         * COMPARE D2 WITH 0 TO SEE IF IT EXISTS
    BEQ            SHIFT_BITS_HELPER             * BRANCH TO SHIFT_BITS_HELPER IF EQUAL
    CMP.B          #$40,D4                       * IF NOT EQUAL PERFORMA COMPARISON
    BGT            CONVERT_TO_LTR                * IF IT IS GREATER THAN 40 THEN IT IS LETTTER.
                                                 * THEN BRANCH TO CONVERT_TO_LTR SUBROUTINE
    CMP.B          #$3A,D4                       * IF IT IS NOT GREATER THE COMPARE IS $3A
                                                 
    BLT            CONVERT_TO_NUM                * AND IF IT IS LESS THAN THAT BRANCH TO CONVERT_TO_NUM

*------------------------CONVERT_TO_LTR------------------------------------   

CONVERT_TO_LTR                                   * TO CONVERT TO LETTER FROM ASCII
    CMP.B          #$46,D4                       * PERFORM COMPARISON TO SEE THE BYTE IS VALID
    BGT            INVALID_BYTE                  * IF NOT BRANCH TO INVALID BYTE
    SUB.B          #$37,D4                       * FIR CINVERTINBG BYTE TO LETTER
    MOVE.B         D4,(A5)+                      * COPY D4 TO TO A5 AND INCREMENT A5 
    BRA            INPUT_CONVERT                 * BRANCH BACK TO INPUT_CONVERT


*------------------------CONVERT_TO_NUM------------------------------------   

CONVERT_TO_NUM                                   * TO CONVERT TO NUMBER FROM ASCII 
    CMP.B          #$30,D4                       * PERFORM COMPARISON TO SEE IF THE BYTE IS VALID
    BLT            INVALID_BYTE                  * IF NOT BRANCH INTO INVALID_BYTE SUBROUTINE
    SUB.B          #$30,D4                       * TO GET THE NUM FROM ASCII SUBTRACT 30 FROM D4 CONTENT
    MOVE.B         D4,(A5)+                      * COPY THE CONTENT OF D4 TO A5 ADDRESS REGISTER AND INCREMENT IT
    BRA            INPUT_CONVERT                 * AND THEN BRANCH BACK TO INPUT_CONVERT MAIN SUBROUTINE

*-------------------------INVALID_BYTE------------------------------------   

INVALID_BYTE                                     * TO HANDLE THE CASE WHEN THE BYTE IS NOT VALID 
    MOVE.B         #$00,(A5)+                    * IF THE BYTE ENTERED BY THE USER IS NOT VALID 
                                                 * STORE 00 INTO A5 ADDRESS REGISTER
    BRA            INPUT_CONVERT                 * BRANCH BACK TO INPUT_CONVERT MAIN SUBROUTINE


*----------------------SHIFT_BITS_HELPER----------------------------------
SHIFT_BITS_HELPER                                * TO SHIFT THE BITS
    MOVEA.L        #$56A,A5                      * COPY 5 TO D2 DATA REGISTER TO RESET THE START ADDRESS
    MOVE.B         #5,D2                         * THE DECIMAL VALUE WILL BE STORED INTO D2


*---------------------------SHIFT_BITS-----------------------------------
SHIFT_BITS                                       * SUBROUTINE USED TO ENSURE D4 HAS CORRECT HEX VALUE
    SUB.B          #1,D2                         * PERFORM SUBTRACTION TO DECREMENT 
    CMP.B          #0,D2                         * PERFORM COMPARISION TO SEE IF IT IS EMPTY
    BEQ            GET_SIGN_BIT                  * BRANCH TO GET_SIGN_BIT IF EQUAL
    MOVE.B         (A5)+,D3                      * IF NOT EQUAL COPY THE CONTENT OF A5 TO D3 AND INCREMENT A5
    LSL.L          #4, D3                        * PERFORM LOGICAL SHIFT TO THE LEFT BY 4 BITS IN LONGWORD LEVEL
    ADD.B          (A5)+,D3                      * PERFORM ADDITION TO ADD NEXT BYTE FROM A5 REGISTER TO D3
    LSL.L          #8,D4                         * PERFORM LOGICLA SHIFT TO THE LEFT IN LONGWORD LEVEL 
                                                 * ON THE CONTENT OF D4
    ADD.B          D3,D4                         * PERFORM ADDITION TO SHIFTED BITS IN D3  TO D4
    BRA            SHIFT_BITS                    * GO BACK TO SHIFT_BITS SUBROUTINE


*------------------------GET_SIGN_BIT-----------------------------------

GET_SIGN_BIT                                     * THIS SUBROUTINE USED TO GET THE SIGN BIT
    MOVE.L         D4,D3                         * COPY THE D4 CONTENT TO D3
    MOVE.B         #31,D2                        * COPY 31 INTO D2 DATA REGISTER CONTENT
    LSR.L          D2,D3                         * PERFOR LOGICAL SHIFT LEFT IN LONG LEVEL AS MUCH AS THE CONTENT OF D2 
    MOVE.B         #$2D,SignBit                  * COPY IMMEDIATE ADDRESS OF $2D TO SignBit
    CMP.B          #$1,D3                        * PERFORM COMPARISON 
    BEQ            GET_EXPONENT                  * BRANCH INTO GET_EXPONENT
    MOVE.B         #$2B,SignBit                  * COPY IMMEDIATE ADDRESS #$2B INTO SignBit IR SET SignBit TO +

*------------------------GET_EXPONENT---------------------------------

GET_EXPONENT                                     * TO CALCULATE THE EXPONENET SUBROUTINE 
    MOVE.L         D4,D3                         * COPY D4 ( USER INPUT) INTO D3
    BCLR.L         #31,D3                        * TO GET THE BIT CLEAR
    MOVE.B         #23,D2                        * COPY 23 INTO D2
    LSR.L          D2,D3                         * LOGICAL SHIFT RIGHT IN LONGWORD LEVEL
    MOVE.W         D3,Exponent                   * MOVE THE CONTENT OF D3 WHICH IS THE EXPONENET VALUE TO EXPONANT


*------------------------GET_MANTISSA---------------------------------
  
GET_MANTISSA                                     * TO CALCUALTE MANTISSA
    MOVE.L         D4,D3                         * COPY D4 CONTENT (USER INPUT) INTO D3
    MOVE.B         #9,D2                         * COPY 9 INTO D2 DATA REGISTER
    LSL.L          D2,D3                         * PERFORM LOGICAL SHIFT TO THE LEFT IN LONGWORD LEVEL
    MOVE.B         #28,D2                        * COPY THE VALUE 28 INTO TO D2
    LSR.L          D2,D3                         * PERFORM LOGICAL SHIFT TO THE LEFT IN LONGWORD LEVEL
    MOVE.W         D3,Mantissa                   * COPY THE CONTENT OF D3 WHICH HOLD THE VALUE OF MANTISA TO MANTISSA
    


*---------------------------PRINT------------------------------------

PRINT                                            * SUBROUTINE USED TO PRINT
    LEA            PRINT_SigBit,A1               * TO PRINT SignBit
    MOVE.B         #14,D0         
    TRAP           #15               
    MOVE.B         SignBit, D1                   * COPY THE SignBit VALUE TO D1
    MOVE.B         #6,D0            
    TRAP           #15             
    
    LEA            PRINT_EXPONENT,A1             * TO PRINT THE EXPONENET VARIABLE: Print out the Exponent var label 
    MOVE.B         #14,D0              
    TRAP           #15          
    MOVE.W         Exponent, D1                  * TO COPY THE EXPONENT VALUE INTO D1 
    MOVE.B         #3,D0                         * TO DISPLAY VALUE AS DECIMAL
    TRAP           #15             
    
    LEA            PRINT_MANTISSA,A1             * TO PRINT MANTISSA VALUE
    MOVE.B         #14,D0         
    TRAP           #15              
    MOVE.W         Mantissa,D1                   * COPY THE VALUE OF MANTISSA TO D1
    MOVE.B         #3,D0                         * TO DISPLAY VALUE AS DECIMAL
    TRAP           #15             
 
    SIMHALT                                     ; halt simulator

     
*-----------------------------------PROMPT THE USER-----------------------------------------

PROMPT	          DC.B 'Please enter a IEEE 32-bit floating point number in hexadecimal: ',0

*-------------------------------------PRINT VARIABLES---------------------------------------

PRINT_SigBit	  DC.B CR, LF,'Sign Bit: ',0
PRINT_EXPONENT    DC.B CR, LF,'Exponent: ',0
PRINT_MANTISSA    DC.B CR, LF,'Mantissa: ',0

    END    START        ; last line of source












*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
