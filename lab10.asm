.MODEL SMALL
.STACK 100H

.DATA
    prm DB 13, 10, 'ENter string: $'
    men DB 13, 10, 'e: $'
    mde DB 13, 10, 'd: $'
    
    i DB 255
      DB ?
    str DB 255 DUP('$')
    
    s DB 256 DUP(0)
    t DB 256 DUP(0)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 256
    XOR BX, BX
tbl:
    MOV AL, BL
    INC AL
    MOV s[BX], AL
    
    PUSH BX
    PUSH AX
    
    MOV BH, 0
    MOV BL, AL
    MOV AL, BL
    DEC AL
    MOV t[BX], AL
    
    POP AX
    POP BX
    
    INC BX
    DEC CX
    JNZ tbl

    MOV AH, 09H
    MOV DX, OFFSET prm
    INT 21H

    MOV AH, 0AH
    MOV DX, OFFSET i ; Replaced LEA DX, I
    INT 21H

    MOV AH, 09H
    MOV DX, OFFSET men
    INT 21H
    
    MOV BX, OFFSET s
    MOV CL, i[1]
    MOV CH, 0
    
    MOV SI, OFFSET str 

enc:
    MOV AL, [SI]
    XLAT
    MOV [SI], AL
    
    INC SI
    DEC CX
    JNZ enc
    
    MOV AH, 09H
    MOV DX, OFFSET str
    INT 21H
    
    MOV AH, 09H
    MOV DX, OFFSET mde
    INT 21H
    
    MOV BX, OFFSET t
    MOV CL, i[1]
    MOV CH, 0
    
    MOV SI, OFFSET str 

dec:
    MOV AL, [SI]
    XLAT
    MOV [SI], AL

    INC SI
    DEC CX
    JNZ dec

    MOV AH, 09H
    MOV DX, OFFSET str
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN