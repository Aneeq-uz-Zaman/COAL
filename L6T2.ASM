.MODEL SMALL
.STACK 100H
.DATA
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

NEXT_CHAR:
    ; read single character (echoed by DOS)
    MOV AH,01h
    INT 21h
    CMP AL,0Dh       ; Enter?
    JE EXIT

    ; copy input from AL to AH for upper-nibble work
    MOV AH,AL

    ; --- upper nibble ---
    AND AH,0F0h      ; keep upper 4 bits
    SHR AH,4         ; shift to low nibble (0..15)

    CMP AH,9
    JG UPPER_LET
    ADD AH,30h       ; '0'..'9'
    JMP UPPER_DONE
UPPER_LET:
    ADD AH,37h       ; 'A'..'F'
UPPER_DONE:
    MOV DL,AH
    MOV AH,02h
    INT 21h

    ; --- lower nibble (in AL) ---
    MOV AH,AL        ; move original AL back to AH for masking
    AND AH,0Fh       ; keep lower 4 bits

    CMP AH,9
    JG LOWER_LET
    ADD AH,30h
    JMP LOWER_DONE
LOWER_LET:
    ADD AH,37h
LOWER_DONE:
    MOV DL,AH
    MOV AH,02h
    INT 21h

    ; newline (CR LF)
    MOV DL,0Dh
    MOV AH,02h
    INT 21h
    MOV DL,0Ah
    MOV AH,02h
    INT 21h

    JMP NEXT_CHAR

EXIT:
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
