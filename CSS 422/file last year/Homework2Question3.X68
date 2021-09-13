*-----------------------------------------------------------
* Title      : Homework 2 Question 3
* Written by : Ahmed Osman
* Date       : 10/19/2020

*-----------------------------------------------------------

* Description: Write a program in 68K assembly code that 
* satisfies the following specifications:
* 1- Your program should start at the memory location 
* $1000 (hint: use the ORG directive).

* 2- Take a one byte hexadecimal value from user input 
* and save the value at address $A000 (hint: you can 
* consider this input a target value). You should not 
* hardcode the inputs. You may ignore sanity check on corner 
* cases, but assume user inputs are always in an expected format.

* 3- Read each byte data stored in memory between the addresses 
* $6000 and $8000 and compare it to the (byte) data at address 
* $A000 (hint: you can consider the memory between $6000 and 
* $8000 an array).

* 4- Please define a LONGWORD variable called address Addr1. 
* In the specified memory range, if the data at address $A000
* is found, the longword address of the data in memory is saved
* into variable Addr1. If it fails to find the data within the 
* specified memory range ($6000 and $8000), then put Addr1 = $6000, 
* which is similar to the idea of "error code" or "invalid index" 
* in your C++ code.

* 5- Please define a WORD variable called address Addsum. Add a 
* series of bytes stored in the 512 consecutive memory locations 
* beginning at address Addr1, no matter you find the target data 
* or not. Save the sum value into Addsum.

* 6- There is a chance that the sum might exceed $FFFF, 
* (exceeding the range of word value), so you will also need to 
* store the carry bit if an overflow occurs. Store the carry bit 
* as a BYTE variable called CarryBit.

* 7- Print the Addr1, Addsum and CarryBit in the output window.

*---------------------------------------------------------------------

CR          EQU             $0D                   * CARRIAGE RETURN
LF          EQU             $0A                   * LINE FEED FOR ASCII
PROPER_LINE DC.B            CR,LF,0               * FORMATING LINE

Addr1       DS.L            1                     * DECLARE Add1 AS A LONGWORD SIZE VALUE
Addsum      DS.W            1                     * DECLARE Addsum AS A WORD SIZE VALUE
CarryBit    DS.B            1                     * DECLARE CarryBit AS A BYTE SIZE VALUE



    ORG    $1000
START:     

*------------------------ASK/TEST INPUT----------------------------------
		     
            LEA             USER_PROMPT,A1	     * TO PROMPT USER FOR INPUT
            MOVE.B          #14,D0               * TO DISPLAY USER'S PROMPT
            TRAP            #15                  * TO READ STRING FROM USER INPUT
            MOVE.B          #2,D0                * TO ALLOW INPUT OUTPUT OPERATIONS
            TRAP            #15                  * TO READ STRING FROM USER
  
            CLR             D0                   * GET D0 DATA REGISTER CLEAR
            
            JSR             CONVERT_TO_HEX       * JUMP TO SUBTOUTINE  TO CONVERT_TO_HEX
            MOVEA.L         #$6000,A2   	     * START SEARCHING FROM ADDRESS $6000
            MOVE.B          ($A000),D1    	     * COPY CONTENT OF $A000 TO D1 
             
*-----------------------------LOOP----------------------------------------    
        
LOOP        CMPA.L          #$8000,A2            * COMPARE ADDRESS REGISTER $8000 WITH A2
            BGT             NOT_FOUND_VALUE 	 * IF IT IS GREATER THEN GO TO NOT_FOUND_VALUE
            CMP.B           (A2)+,D1             * TO COMPARE THE CONTENT OF A2 WITH D1
            BEQ             FOUND_VALUE          * IF IT'S EQUAL THEN IT'S FOUND THEN GO TO
                                                 * VALUE_FOUND SUBROUTINE
            BRA             LOOP                 * IF NOT EQUAL THEN GO BACK TO THE LOOP
            
*-------------------------NOT_FOUND_VALUE------------------------------------
NOT_FOUND_VALUE
            MOVEA.L         #$6000,A2            * SET ADDRESS REGISTER $6000 TO A2 IF THE 
                                                 * VALUE WASN'T FOUND
           	MOVE.L          A2,Addr1             * COPY THE THE CONTENT OF A2 TO Addr1
            BRA             ADD                  * BRANCH TO ADD_SUBROUTINE   
         
*-------------------------FOUND_VALUE---------------------------------------  
         
FOUND_VALUE   
            ADDA.L          #-1,A2               * STEP BACK ONE ADDRESS 
            MOVE.L          A2, Addr1            * STORE A2 TO Addr1  
            BRA             ADD                  * BRANCH TO ADD SUBROUTINE
            
*------------------------------ADD-----------------------------------------

ADD            
            MOVEA.L         A2,A3                * STORE A2 ADDRESS TO A3
            ADDA.L          #512,A3              * INCREMENT THE ADDRESS A3 BY 512
            MOVE.W          #0,Addsum            * COPY 0 AS THE CONTENT TO Addsum
            MOVE.B          #0,CarryBit          * COPY 0 AS THE CONTENT TO CarryBit
            CLR             D2                   * CLEAR THE CONTENT OF D2
             
*-------------------------MAIN_ADD_SUBROUTINE ---------------------------

MAIN_ADD_SUBROUTINE           
            CMPA.L          A3,A2                * COMPARRE THE CURRENT ADDRESS TO A2
            BGE             PRINT                * IF GREATER OR EQ THEN EXECUTE PRINT
            MOVE.B          (A2)+,D2             * COPY THE CONTENT OF A2 ADDRESS TO D2
            ADD.W           D2,Addsum            * ADD THE CONTENT OF D0 DATA REGISTER TO Addsum
            BCS             SET_CARRY_FLAG       * IF THE CARY VALUE IS SET BRANCH TO 
                                                 * SET_CARRY_FLAG SUBROUTINE
            BRA             MAIN_ADD_SUBROUTINE  * IF THE CARRY VALUE IS NOT SEET, THEN RESTART THE LOOP
            

*---------------------------SET_CARRY_FLAG-----------------------------------

SET_CARRY_FLAG
            MOVE.B          #1, CarryBit         * COPY 1 TO Carrybit AS A DEFAULT VALUE
            BRA             MAIN_ADD_SUBROUTINE  * BRANCHES BACK TO RULING ADD_SUBROUTINE

*-------------------------------PRINT---------------------------------------      

PRINT             
            LEA             PROPER_LINE, A1      * Change format for A1   
            MOVE.B          #14,D0               * TO DISPLAY 
            TRAP            #15                  * TO PRINT OUTPUT
            LEA             STR, A1              * LOAD STR AS AN EA
            MOVE.B          #14,D0               * TO DISPLAY
            TRAP            #15                  * TO PRINT OUTPUT
               
            LEA             Addr1, A1            * LOAD Addr1 INTO A1 AS AN EA
            MOVE.B          #4, D5               * COPY 4 INTO D5
            JSR             HEX_PRINT            * JUMPT SUBROUTINE TO HEX_PRINT SUBROUTINE
            
            LEA             PROPER_LINE, A1     
            MOVE.B          #14,D0               * TO DISPLAY
            TRAP            #15                  * TO PRINT OUT            
            LEA             STR_SUM, A1          * LOAD STR_SUM IN A1 AS AN EA
            MOVE.B          #14,D0               * TO DISPLAY
            TRAP            #15                  * TO PRINT OUT
             
            LEA             Addsum, A1           * LOAD Addsum INTO A1
            MOVE.B          #2, D5               * COPY 2 INTO D5
            JSR             HEX_PRINT            * JUMP TO SUBROUTINE HEX_PRINT
            
            LEA             PROPER_LINE,A1      
            MOVE.B          #14,D0               * TO DISPLAY 
            TRAP            #15                  * TO PRINT OUT
           
            LEA             STR_BIT,A1           * LOAD STR_BIT INTO A1
            MOVE.B          #14,D0               * TO DISPLAY    
            TRAP            #15                  * TO PRINT OUT
       
            MOVE.B          CarryBit, D1         * COPY THE VALUE OF Carrybit INTO D1
            LEA             USER_PROMPT, A1      * LOAD USER_PROMPT INTO ADDRESS REGISTER A1 AS AN EA
            MOVE.B          #3,D0                * COPY 3 INTO D0
            TRAP            #15                  * TO DISPLAY
            
*------------------------CONVERT_TO_HEX ----------------------------------

CONVERT_TO_HEX            
 	        MOVEA.L         #$A000,A3            * MOVE $A000 INTO A3 AS AN DEFUALT ADDRESS REGISTER
			MOVE.B          (A1),D3              * STORE THE CONTENT OF A1 INTO D3 DATA REGISTER
			CMP.B           #0,D3                * COMPARE IF THE STRING REACHED NULL (THE END)
			BEQ             SKIP_BRANCH          * RETURN TO SUB
			MOVE.B          (A1)+,D4             * IF IT DID NOT REACH THE END, KEEP ON STRING
                                                 * THE CONTENT OF A1 INTO D4
			LSR.B           #4, D3               * PERFOR LOGICAL SHIFT RIGHT BY 4 BITS ON 
                                                 * BYTE LEVEL AND STORE THE RESULTS TO D3
                                                
			LSL.B           #4, D4               * PERFOR LOGICAL SHIFT LEFT ON BYTE LEVEL AND 
                                                 * STORE THE RESULTS INTO D4
			LSR.B           #4, D4               * PERFORM LSR SAME AS ABOVE
			CMP.B           #3,D3                * PERFORM COMPARISON
			BEQ             CONVERT_TO_NUM       * BRANCHTO CONVERT_TO_NUM IF EQUAL
			BRA             CONVERT_TO_LTR       * OTHERWISE BRANCH TO CONVERT_TO_LTR
			
*-------------------------SKIP_BRANCH -------------------------------------
					
SKIP_BRANCH                                      * TO RETURN TO SUBROUTINE
            RTS                                                        

*------------------------CONVERT_TO_NUM -----------------------------------

CONVERT_TO_NUM           
	        CMP.B           #0,D0                * COMPARE D0 WITH 0 THAT EMPLIES BEING EMPTY
			BEQ             SHIFTING             * BRANCH TO SHIFTING IF EQUAL
			CLR             D0                   * ERASE THE CONTENT OF D0
        	ADD.B           D4,(A3)+             * ADD D4 CONTENT INTO A3 CONTENT AND POST INCREMENT IT
            BRA             CONVERT_TO_HEX       * EXECUTE CONVERT_TOHEXT SUBROUTINE 

*------------------------CONVERT_TO_LTR ----------------------------------            

CONVERT_TO_LTR                
            ADD.B           #9, D4               * ADD 9 INTO CONTENT OF D4 DATA REGISTER
			CMP.B           #0, D0               * COMPARE TO D0 WITH 0 THAT EMPLIES BEING EMPTY
			BEQ             SHIFTING             * BRANCH TO SHIFTING IF EQUAL
			CLR             D0                   * ERASE TJE CONTENT OF D0
			ADD.B           D4, (A3)+            * ADD D4 CONTENT INTO A3 CONTENT AND POST INCREMENT IT
			BRA             CONVERT_TO_HEX :     * BRANCH TO CONVERT_TO_HEX

*---------------------------SHIFTING -------------------------------------

SHIFTING            
            LSL.B           #4, D4               * PERFORM LOGICAL 4 BITS SHIFT TO THE LEFT IN BYTE LEVEL 
            MOVE.B          D4, (A3)             * COPY THE CONTENT OF D4 DATA REGISTER INTO A3
            MOVE.B          #1, D0               * COPY 1 TO D0 AS AN EA
            BRA             CONVERT_TO_HEX :     * BRANCH TO CONVERT_TO_HEX
            
*---------------------------HEX_PRINT ------------------------------------

HEX_PRINT            
            CMP.B           #0, D5               * COMPARE D4 WITH 0 THAT EMPLIES BEING EMPTY
            BEQ             SKIP_HEX_PRINT       * IF EQUAL BRANCH TO SKIP_HEX_PRINT
            MOVE.B          (A1),D3              * COPY A1 CONTENT INTO D3
            MOVE.B          (A1)+,D4             * COPY A1 CONTENT INTO D4 AND ICREMENT IT
            
            LSR.B           #4, D3               * PERFORM LOGICAL SHIFT RIGHT ON BYTE LEVEL AND 
                                                 * STORE THE RESULTS INTO D3
           
            LSL.B           #4, D4               * PERFORM LOGICAL SHIFT LEFT ON BYTE LEVEL AND 
                                                 * STORE THE RESULTS INTO D4

            LSR.B           #4, D4               * PERFORM LOGICAL SHIFT LEFT ON BYTE LEVEL AND 
                                                 * STORE THE RESULTS INTO D4
            
            CLR             D6                   * CLEAR THE CONTENT OF D6 DATA REGISTER
            MOVE.B          D3,D1                * COPY THE CONTENT OF D3 INTO D1 DATA REGISTER
            CMP.B           #10,D3               * PERFORM COMPARISON BETWEEN 10 AND D3 CONTENT
            BLT             PRINT_NUM            * BRANCH PRINT_NUM SUBROUTINE IF IT IS LESS
            BRA             PRINT_LTR            * OTHERWISE BRANCH PRINT_LTR SUBROUTINE
PRINT_SEC                   
            MOVE.B          D4,D1
            CMP.B           #10,D4
            BLT             PRINT_NUM
            BRA             PRINT_LTR
                 
*---------------------------SKIP_HEX_PRINT ------------------------------              
                 
SKIP_HEX_PRINT
            RTS                                  * TO BRANCH BACK
            
*-----------------------------PRINT_NUM ---------------------------------

PRINT_NUM                                        * SUBROUTINE TO PRINT NUMBER
            ADD.B           #$30, D1             * COPY $30 AS AN IMEDIATE VAL INTO D1
            MOVE.B          #6, D0               * COPY 6 INTO D0 AS AN EA
            TRAP            #15                  * TO DISPLAY NUM
            CMP.B           #0, D6 :             * COMPARE D6 CONTENT WITH 0 IF EQUAL
            BEQ             SWAP                 * BRANCH TO SWAP SUBROUTINE
            SUB.B           #1, D5               * IF NOT EQUAL SUBTRACT 1 FROM THE CONTENT OF D5
            BRA             HEX_PRINT            * AND BRANCH INTO HEX_PRINT SUBROUTINE
            
*-----------------------------PRINT_LTR ---------------------------------

PRINT_LTR                                       * SUBROUTINE TO PRINT LETTER
            SUB.B           #9, D1              * SUBTRACT 9 FROM D1 CONTENT 
            ADD.B           #$40, D1            * ADD 40 INTO CONTENT OF D1 DATA REGISTER
            MOVE.B          #6, D0              * COPY 6 INTO D0 DATA REGISTER
            TRAP            #15                 * TO DISPLAY OUTPUT
            
            CMP.B           #0, D6              * COMPARE D6 CONTENT WITH 0
            BEQ             SWAP                * IF EQUAL BRANCH SWAP
            
            SUB.B           #1, D5              * SUBTRACT 1 FROM THE CONTENT OF D5 DATA REGISTER
            BRA             HEX_PRINT           * BRANCH TO HEX_PRINT
            
*-------------------------------SWAP-------------------------------------
            
SWAP                                            * SUBROUTINE HELPER FOR PRINT_LTR SUBROUTINE
            MOVE.B #1, D6
            BRA PRINT_SEC

            SIMHALT                             * halt simulator
            
*------------------------DECLARING CONSTANTS-----------------------------

USER_PROMPT DC.B    'ENTER ONE BYE HEXADECIMAL VALUE IN CAPITAL LETERS:',0
STR         DC.B    'Addr1:     ',0
STR_SUM     DC.B    'Addsum:    ',0
STR_BIT     DC.B    'CarryBit:  ',0

    END    START        : Last line of source code.


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
