.MODEL SMALL
.STACK 100H
.DATA
    A    DB 1,2,3,4,5,6,7,8
    B    DB 11,12,13,14,15,16,17,18
.CODE
MAIN PROC
         MOV AX,@DATA
         MOV DS,AX
         MOV SI,OFFSET A
         MOV DI,OFFSET B
         MOV CX,8
    L1:  MOV AL,[SI]
         MOV BL,[DI]
         MOV [SI],BL
         MOV [DI],AL
         INC SI
         INC DI
         DEC CX
         JNZ L1
         MOV AH,4CH
         INT 21H
MAIN ENDP
END MAIN
