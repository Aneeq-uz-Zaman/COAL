.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Capital$'
    MSG2 DB 'Small$'
.CODE
MAIN PROC
         MOV AX,@DATA
         MOV DS,AX

         MOV AH,1
         INT 21H
         MOV BL,AL

         CMP BL,'Z'
         JLE CAP

    SML: 
         MOV DX,OFFSET MSG2
         MOV AH,9
         INT 21H
         JMP EXIT

    CAP: 
         MOV DX,OFFSET MSG1
         MOV AH,9
         INT 21H

    EXIT:
         MOV AH,4CH
         INT 21H
MAIN ENDP
END MAIN
