*-----------------------------------------------------------
* Title      : Pattern Finding and Cumulative Program
* Written by : Regie Pineda
* Date       : October 19, 2019
* Description: This program would search to through the start and
*              and end addresses for a byte data pattern
*              and stores the address in memory. From this 
*              address, cumulatively adds the next 512 bytes
*              and stores the total sum as a word and displays
*              if there is a carry bit.
*-----------------------------------------------------------
* Below are test variables used to check if the program works
*Target   EQU $09  : Target
*DesLoc  EQU $6000 : Address to place the target in

*------Put variables and constants here---*
CR          EQU     $0D     : Carriage Return for ASCII
LF          EQU     $0A     : Line feed for ASCII
FORMATLINE  DC.B    CR,LF,0 : Formatting line for proper print

Addr1       DS.L    1   : Declare value for Addr1 LONG SIZE
Addsum      DS.W    1   : Declare value for Addsum WORD size
CarryBit    DS.B    1	: Declare value for CarryBit BYTE size

*-------Put program code here-----------*

    ORG    $1000
START:      * Label for the first instruction of program
*------------Test-------------------------*
            * TESTING: 
			*MOVE.B #Target, DesLoc   
*----------------------------------------*			
			     
            LEA PROMPTALERT,A1	                                                                :   This will prompt the user to put in a byte sized HEX item
            MOVE.B #14,D0
            TRAP #15            :   This will display the prompt
            MOVE.B #2,D0        :   This will allow input / output operations
            TRAP #15            :   This will read in a string from user to be stored in A1
            CLR D0              :   This will make sure D0 is clear in time for conversion subroutine   
            JSR CONVERTFROMASCII	: 
         			            MOVEA.L #$6000,A2   	: Put address $6000 into A2, it is the starting address as dictated by instructions	                         
            MOVE.B ($A000),D1    	: Store the contents of $A000 into D1
READLOOP    CMPA.L #$8000,A2        : perform comparison
            BGT VALUENOTFOUNDCASE	        : If it past$8000 without match, itll go to VALUENOTFOUNDCASE
            CMP.B (A2)+,D1          : COmpares the contents at address A2 with D1   
            BEQ FOUND               : If match is found, go to FOUND subroutine          	
            BRA READLOOP            : If not match, go to start of the reading subroutine      	

VALUENOTFOUNDCASE
            MOVEA.L #$6000,A2       : This will make the address $6000 as a default if never found
           			MOVE.L A2,Addr1         : Move the address from A2 to Addr1 
            		                                                                                                           BRA ADDSUBROUTINESTART      : Branch to the addition subroutine
FOUND   
            ADDA.L #-1,A2   : Go back one place to get the address of actual match    
            MOVE.L A2, Addr1  : Store the address in the Addr1  
            BRA ADDSUBROUTINESTART  : Branch to the addition subroutine   

ADDSUBROUTINESTART            
            MOVEA.L A2,A3      : Move the start address to end 
            ADDA.L #512,A3  : Increase ending address story A3 by 512 for consecutive sum    
            MOVE.W #0,Addsum   : set Addsum var to 0 
            MOVE.B #0,CarryBit : set CarryBit var to 0
            CLR D2    : Reset the D2

ADDSUBROUTINEMAIN            
            CMPA.L A3,A2  : Compare the curr address with the end      
            BGE PRINT    : Checks if it greater or equal, then print      
            MOVE.B (A2)+,D2  : Move values of A2 into D2   
            ADD.W  D2,Addsum  : Adds the value of D2 to curr sum
            BCS SETCARRYVALUE  : Checks if carry is set, then branch to SETCARRYVALUE sub    
            BRA ADDSUBROUTINEMAIN : Otherwise, restart the loop       

SETCARRYVALUE            
            MOVE.B #1, CarryBit : Sets 1 as value for default 
            BRA ADDSUBROUTINEMAIN       

PRINT             
            LEA FORMATLINE, A1  : Change format for A1   
            MOVE.B #14,D0
            TRAP #15            : Print out        
            LEA STRADDRONE, A1  : Put STRADDRONE into A1  
            MOVE.B #14,D0
            TRAP #15            : Print out     
            
            LEA Addr1, A1       : Place Addr1 into A1
            MOVE.B #4, D5       : Move 4 into D5   
            JSR PRINTHEX        : Print the number at A1
            
            LEA FORMATLINE, A1  : Put a black Formatline into A1   
            MOVE.B #14,D0
            TRAP #15            : Print out   
            
            LEA STRADDSUM, A1   : Put STRADDSUM in A1 
            MOVE.B #14,D0       
            TRAP #15            : Print out
            
            LEA Addsum, A1      : Put Addsum in A1
            MOVE.B #2, D5       
            JSR PRINTHEX        : Print the num at A1
            
            LEA FORMATLINE,A1   : Put a black FORMATLINE in A1
            MOVE.B #14,D0
            TRAP #15            : Print out   
           
            LEA STRCARRYBIT,A1  : Put the STRADDRONE into A1   
            MOVE.B #14,D0
            TRAP #15            : Print out
       
            MOVE.B CarryBit, D1 : Get the carrybit val to D1
            LEA PROMPTALERT, A1  : Put first msg in A1     
            MOVE.B #3,D0
            TRAP #15           : Print out

CONVERTFROMASCII            
 	                  MOVEA.L #$A000,A3      : Move default address to A3
			MOVE.B (A1),D3 : Store the first hex char to D3     	
			CMP.B #0,D3    : Checks if we reach null terminator  	   
			BEQ ESCAPEFROMTHEBRANCH	: If it does, return from sub
			MOVE.B (A1)+,D4  : Otherwise, continue and store the first hex char to D4   	
			LSR.B #4, D3  : Shift right of D3 to get top 4 bits     
			LSL.B #4, D4   : Shift left of D4 to get bottom 4 bits     	
			LSR.B #4, D4   : Repeats above instruction
			CMP.B #3,D3    : Checks if they are equal 
			BEQ CONVERTNUMBER  : Go to sub for converting value to a num
			BRA CONVERTLETTER : convert value to a letter
					
ESCAPEFROMTHEBRANCH     * Flow away from convert Subroutine
            RTS                          

CONVERTNUMBER           
	                                CMP.B #0,D0 : See if D0 is empty
			BEQ SHIFT : Invoke SHIFT
			CLR D0    : Clear D0
        	        	                                                                                            ADD.B D4,(A3)+    : Add D4 val to A3 and post increment
            BRA CONVERTFROMASCII : Branch to CONVERTFROMASCII

CONVERTLETTER                
            ADD.B #9, D4    : Add 9 to D4
			CMP.B #0, D0 : Check if D0 is empty
			BEQ SHIFT    : If it is, then go SHIFT
			CLR D0       : Clear D0
			ADD.B D4, (A3)+ : Add value in D4 to A3 indirectly and post increment
			BRA CONVERTFROMASCII :  Branch to CONVERTFROMASCII

SHIFT            
            LSL.B #4, D4    : Shift Left
            MOVE.B D4, (A3) : Movethe value in D4 indirectly to A3
            MOVE.B #1, D0   : Set D0 to 1
            BRA CONVERTFROMASCII : Branch to CONVERTFROMASCII

PRINTHEX            
            CMP.B #0, D5    : Compare 0 with value D5
            BEQ ESCAPEFROMPRINTHEX
            MOVE.B (A1),D3  : Move the val pointed to A1 to D3
            MOVE.B (A1)+,D4 : Move the val pointed to A1 to D4 and increment
            
            LSR.B #4, D3    : Shift to allow Examination of the nibbles.
            LSL.B #4, D4
            LSR.B #4, D4
            
            CLR D6         : Clear  D6
            MOVE.B D3,D1   : Move val in D3 to D1
            CMP.B #10,D3   : Compare value 10 and D3
            BLT PRINTNUM
            BRA PRINTLET   : Branch to letter subroutine

PRINTSEC                   
            MOVE.B D4,D1
            CMP.B #10,D4
            BLT PRINTNUM
            BRA PRINTLET
                 
ESCAPEFROMPRINTHEX	* Branch back
            RTS           

PRINTNUM            * Subroutine for printing 
            ADD.B #$30, D1
            MOVE.B #6, D0
            TRAP #15
            CMP.B #0, D6 : Branch to SWAP if 0 is in D6
            BEQ SWAP
            SUB.B #1, D5 : Otherwise decrement 
            BRA PRINTHEX : Branch back to PRINTHEX

PRINTLET    * This subroutine will allow the printing of letters
            SUB.B #9, D1
            ADD.B #$40, D1  : Add '40' to the data register #1
            MOVE.B #6, D0
            TRAP #15
            
            CMP.B #0, D6
            BEQ SWAP
            
            SUB.B #1, D5
            BRA PRINTHEX
            
SWAP        * Helper subroutine for PRINTLET
            MOVE.B #1, D6
            BRA PRINTSEC

            SIMHALT             * halt simulator

PROMPTALERT DC.B    'Please enter a byte sized hex number using capital letters and numbers:',CR,LF,0
STRADDRONE  DC.B    'Addr1: ',0
STRADDSUM   DC.B    'Addsum: ',0
STRCARRYBIT DC.B    'CarryBit: ',0

    END    START        : Last line of source code.






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
