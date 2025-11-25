.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Overflow$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 1h
    INT 21H
    SUB AL, 30H       
    MOV BL, AL

    MOV AH, 1h
    INT 21H
    SUB AL, 30H
    ADD BL, AL       

    CMP BL, 10
    JGE OVERFLOW      

    ADD BL, 30H      
    MOV DL, BL
    MOV AH, 2h
    INT 21H
    JMP EXIT

OVERFLOW:
    MOV DX, OFFSET MSG1
    MOV AH, 9h
    INT 21H

EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
