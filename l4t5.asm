.MODEL SMALL
.STACK 100H
.DATA
    A    DB 1,2,3,4,5,6,7,8
.CODE
MAIN PROC
         MOV AX,@DATA
         MOV DS,AX
         MOV SI,OFFSET A
         MOV CX,8
         MOV ah,01H
         INT 21H
         SUB AL,30H
         MOV BL,AL
    L1:  ADD BL,[SI]
         MOV [SI],BL
         INC SI
         DEC CX
         JNZ L1
         MOV AH,4CH
         INT 21H
MAIN ENDP
END MAIN
