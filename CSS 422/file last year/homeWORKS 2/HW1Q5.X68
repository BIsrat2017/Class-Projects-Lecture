*-----------------------------------------------------------
* Title      : Homework 1 Question #5
* Written by : Regie Pineda
* Date       : 10/13/2019
* Description: This program will get input from the user
*              and print out the sum.
*-----------------------------------------------------------
START:    ORG    $1000  ; first instruction of program

* Progrom code starts here
*-------Code for input-------

        LEA     PROMPTONE,A1     Prompts user for first input
        MOVE.W  #13,D0       
        TRAP    #15

        MOVE.W  #4,D0            Records user input
        TRAP    #15

        MOVE.W  D1,D2            Pushes the D1 onto D2
        
        LEA     PROMPTTWO,A1     Prompts user for second input
        MOVE.W  #13,D0
        TRAP    #15
        
        MOVE.W  #4,D0            Records user input
        TRAP    #15
        
        CMP.W   D2,D1              Compares the values of D2,D1
        BVS.S   OVERFLOW           Checks 'V' for overflow
        ADD.W   D2,D1              Adds the first value to the second value
        BVS.S   OVERFLOW           Checks 'V' for overflow

        MOVE.W  D1,$6000           Moves it to the memory address $6000
        
        LEA     ALERT,A1           This will begin the pattern for alert  
        MOVE.W  #13,D0             Prints out the message about the sum.      
        TRAP    #15                Invokes the TRAP code
        
        MOVE.B  #3,D0              Show the result of the addition
        TRAP    #15                 
         
        SIMHALT
            
OVERFLOW    LEA     OVERFLOWMSG,A1     Alerts the user about the overflow
            MOVE.W  #13,D0
            TRAP    #15
             

        

* Put variables and constants here

CR        EQU     $0D             ASCII code for Carriage Return
LF        EQU     $0A             ASCII code for Line Feed
PROMPTONE DC.B    'Please enter a number:',0
PROMPTTWO DC.B    'Please enter a second number:',0
ALERT     DC.B    'The sum of the two values is:',0
*   Assumed no value output needed
OVERFLOWMSG DC.B  CR,LF,'An overflow has occurred from the addition or subtraction.',0  
        
        END     START         Last line of the source code
    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
