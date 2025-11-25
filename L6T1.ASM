.MODEL SMALL
.STACK 100H
.DATA
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    MOV AH,01H       
    INT 21H
    MOV BL,AL    

    MOV CL,8
    MOV CH,0

AGAIN:
    SHL BL,1
    JNC ZERO
    INC CH
    MOV DL,31H
    MOV AH,02
    INT 21H
    JMP NEXT

ZERO:
    MOV DL,30H
    MOV AH,02
    INT 21H

NEXT:
    DEC CL
    JNZ AGAIN

    ; print count of 1s
    MOV DL,0AH       ; new line
    MOV AH,02
    INT 21H

    MOV DL,CH
    ADD DL,30H       ; convert count to ASCII
    MOV AH,02
    INT 21H

    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN
