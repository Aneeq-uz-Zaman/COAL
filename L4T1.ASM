.MODEL SMALL
.STACK 100H
.DATA
    A    DB 1,2,3,4,5,6,7,8
    B    DB 8 DUP(?)
.CODE
MAIN PROC
         MOV AX,@DATA
         MOV DS,AX
         MOV SI,OFFSET A
         MOV DI,OFFSET B
         MOV CX,8
    L1:  MOV AL,[SI]
         MOV [DI],AL
         INC SI
         INC DI
         DEC CX
         JNZ L1
         MOV AH,4CH
         INT 21H
MAIN ENDP
END MAIN
