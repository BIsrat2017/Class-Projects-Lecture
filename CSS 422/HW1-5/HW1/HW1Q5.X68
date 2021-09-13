*-----------------------------------------------------------
* Title      :  HW1Q#5
* Written by :Bisrat Asefaw
* Date       : 10/18/2020
* Description: program for adding two numbers 
*-----------------------------------------------------------
CR      EQU     $0D
LF      EQU     $0A

    ORG    $1000
START:                  ; first instruction of program

* Put program code here
       MOVE.B  #1,D3        * usign D3 to make two loop for storing two data 
       
LOOP   LEA     MESSAGE,A1   *loading a message to A1  
       MOVE.W  #14,D0       * trap tast 14 for displaying 
       TRAP    #15
       
       MOVE.W  D1,D2        * moving data in D1 to D2
       MOVE.W  #4,D0        * asking usr to inter a number 
       TRAP    #15
       
       
       CMP.W   #2,D3        * comparing if the loop makes two times 
       BEQ     DONE         * branch if its two times 
    
       ADD.W   #1,D3        * add one to D3 for counting the loop
       
       BRA     LOOP         * branch to loop
       

DONE   ADD.W   D2,D1        * add the two numbers 
       BVS.S   INVal        * if overflow flag is set branch 
       MOVE.W  D1,$6000     * move the sum to address $6000 

       
       LEA     MESSAGES,A1     * display the message the sum is 
       MOVE.W  #14,D0
       TRAP    #15
      
       
       MOVE.W  #3,D0           *display the sum
       TRAP    #15             *end  the  program
       
       SIMHALT

       
INVal    LEA     INV,A1         * display an invalid message 
         MOVE.W  #14,D0
         TRAP    #15
            
         MOVE.W  #9,D0          *end the program
         TRAP    #15
         
* Put variables and constants here
MESSAGE DC.B    'ENTER A NUMBER : ',0
MESSAGES DC.B    'THE SUM IS: ',0
INV      DC.B     ' ',CR,LF,'WARNING, OVERFLOW !! ',0
    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
