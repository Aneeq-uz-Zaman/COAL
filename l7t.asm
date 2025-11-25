.MODEL SMALL
.STACK 100h
.DATA
choice_msg     DB 'Enter choice (1=Binary, 2=Hex, 3=Decimal): $'
bin_prompt     DB 13,10,'Enter binary number (up to 16 bits): $'
hex_prompt     DB 13,10,'Enter hex number (0..FFFF): $'
dec_prompt     DB 13,10,'Enter decimal number (0..65535): $'
err_bin        DB 'Illegal binary digit, try again: $'
err_hex        DB 'Illegal hex digit, try again: $'
err_dec        DB 'Illegal or overflow, try again: $'
out_dec_msg    DB 13,10,'In decimal: $'
out_hex_msg    DB 13,10,'In hex: $'
out_bin_msg    DB 13,10,'In binary: $'
newline        DB 13,10,'$'

value          DW 0

inbuf LABEL BYTE
    DB 40          ; max input chars for DOS buffered input
    DB 0           ; actual length on return
    DB 40 DUP(0)   ; data

.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX

; Read valid menu choice (1..3)
CHOICE_AGAIN:
    MOV AH, 09h
    LEA DX, choice_msg
    INT 21h

    MOV AH, 01h         ; read char
    INT 21h
    CMP AL, '1'
    JE BINARY_IO
    CMP AL, '2'
    JE HEX_IO
    CMP AL, '3'
    JE DECIMAL_IO
    ; ignore and ask again
    MOV AH, 09h
    LEA DX, newline
    INT 21h
    JMP CHOICE_AGAIN

; ----------------------------
; Binary input (up to 16 bits)
BINARY_IO:
    ; prompt
    MOV AH, 09h
    LEA DX, bin_prompt
    INT 21h

READ_BIN:
    LEA DX, inbuf
    MOV AH, 0Ah
    INT 21h

    ; limit length to 16
    LEA SI, inbuf
    MOV CL, [SI+1]
    XOR CH, CH
    MOV BL, 16
    CMP CL, BL
    JBE SHORT BIN_LEN_OK
    MOV CL, BL
BIN_LEN_OK:
    OR CL, CL
    JZ  SHORT BIN_BAD

    XOR AX, AX           ; accumulator for result
    LEA SI, [SI+2]

BIN_LOOP:
    MOV DL, [SI]
    CMP DL, '0'
    JE  BIN_ZERO
    CMP DL, '1'
    JE  BIN_ONE
    JMP SHORT BIN_BAD

BIN_ZERO:
    SHL AX, 1
    JMP SHORT BIN_NEXT

BIN_ONE:
    SHL AX, 1
    INC AX

BIN_NEXT:
    INC SI
    DEC CL
    JNZ BIN_LOOP

    MOV value, AX
    JMP SHOW_OUTPUTS

BIN_BAD:
    MOV AH, 09h
    LEA DX, err_bin
    INT 21h
    JMP READ_BIN

; ----------------------------
; Hex input (up to 4 uppercase digits)
HEX_IO:
    MOV AH, 09h
    LEA DX, hex_prompt
    INT 21h

READ_HEX:
    LEA DX, inbuf
    MOV AH, 0Ah
    INT 21h

    LEA SI, inbuf
    MOV CL, [SI+1]
    XOR CH, CH
    MOV BL, 4
    CMP CL, BL
    JBE SHORT HEX_LEN_OK
    MOV CL, BL
HEX_LEN_OK:
    OR CL, CL
    JZ  SHORT HEX_BAD

    XOR AX, AX           ; accumulator
    LEA SI, [SI+2]

HEX_LOOP:
    MOV DL, [SI]
    ; '0'..'9' ?
    CMP DL, '0'
    JB  SHORT HEX_BAD
    CMP DL, '9'
    JBE SHORT HEX_IS_NUM
    ; 'A'..'F' ? (uppercase only)
    CMP DL, 'A'
    JB  SHORT HEX_BAD
    CMP DL, 'F'
    JA  SHORT HEX_BAD
    ; A..F -> 10..15
    SUB DL, 'A'
    ADD DL, 10
    JMP SHORT HEX_ACCUM

HEX_IS_NUM:
    SUB DL, '0'

HEX_ACCUM:
    SHL AX, 1
    SHL AX, 1
    SHL AX, 1
    SHL AX, 1
    MOV BH, 0
    MOV BL, DL
    ADD AX, BX

    INC SI
    DEC CL
    JNZ HEX_LOOP

    MOV value, AX
    JMP SHOW_OUTPUTS

HEX_BAD:
    MOV AH, 09h
    LEA DX, err_hex
    INT 21h
    JMP READ_HEX

; ----------------------------
; Decimal input (0..65535)
DECIMAL_IO:
    MOV AH, 09h
    LEA DX, dec_prompt
    INT 21h

READ_DEC:
    LEA DX, inbuf
    MOV AH, 0Ah
    INT 21h

    LEA SI, inbuf
    MOV CL, [SI+1]
    XOR CH, CH
    OR CL, CL
    JZ  SHORT DEC_BAD

    XOR AX, AX           ; accumulator
    MOV DI, 10           ; multiplier constant
    LEA SI, [SI+2]

DEC_LOOP:
    MOV DL, [SI]
    CMP DL, '0'
    JB  SHORT DEC_BAD
    CMP DL, '9'
    JA  SHORT DEC_BAD
    SUB DL, '0'          ; DL = digit (0..9)

    ; AX = AX * 10 + digit with overflow check (<= 65535)
    XOR DX, DX
    MUL DI               ; DX:AX = AX * 10
    OR  DX, DX
    JNZ SHORT DEC_OVER
    MOV BH, 0
    MOV BL, DL
    ADD AX, BX
    JC  SHORT DEC_OVER

    INC SI
    DEC CL
    JNZ DEC_LOOP

    MOV value, AX
    JMP SHOW_OUTPUTS

DEC_OVER:
DEC_BAD:
    MOV AH, 09h
    LEA DX, err_dec
    INT 21h
    JMP READ_DEC

; ----------------------------
; Output section: print in decimal, hex, and binary
SHOW_OUTPUTS:
    ; print decimal
    MOV AH, 09h
    LEA DX, out_dec_msg
    INT 21h
    MOV AX, value
    CALL PRINT_DEC_16

    ; print hex (4 digits)
    MOV AH, 09h
    LEA DX, out_hex_msg
    INT 21h
    MOV AX, value
    CALL PRINT_HEX_4

    ; print binary (16 bits)
    MOV AH, 09h
    LEA DX, out_bin_msg
    INT 21h
    MOV AX, value
    CALL PRINT_BIN_16

    ; trailing newline
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; exit to DOS
    MOV AH, 4Ch
    INT 21h

; ----------------------------
; Utilities
; Print AX in unsigned decimal
PRINT_DEC_16 PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    CMP AX, 0
    JNE SHORT PD_LOOP
    ; print single '0'
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    JMP SHORT PD_DONE

PD_LOOP:
    XOR CX, CX           ; digit count
PD_DIV:
    XOR DX, DX
    DIV BX               ; AX=AX/10, DX=remainder
    PUSH DX              ; save remainder
    INC CX
    CMP AX, 0
    JNE PD_DIV

PD_PRINT:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PD_PRINT

PD_DONE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DEC_16 ENDP

; Print AX as 4 uppercase hex digits
PRINT_HEX_4 PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; nibble 3 (bits 15..12)
    MOV DX, AX
    MOV CL, 12
    SHR DX, CL
    AND DL, 0Fh
    CMP DL, 9
    JBE SHORT PH0_NUM
    ADD DL, 'A' - 10
    JMP SHORT PH0_OUT
PH0_NUM:
    ADD DL, '0'
PH0_OUT:
    MOV AH, 02h
    INT 21h

    ; nibble 2 (bits 11..8)
    MOV DX, AX
    MOV CL, 8
    SHR DX, CL
    AND DL, 0Fh
    CMP DL, 9
    JBE SHORT PH1_NUM
    ADD DL, 'A' - 10
    JMP SHORT PH1_OUT
PH1_NUM:
    ADD DL, '0'
PH1_OUT:
    MOV AH, 02h
    INT 21h

    ; nibble 1 (bits 7..4)
    MOV DX, AX
    MOV CL, 4
    SHR DX, CL
    AND DL, 0Fh
    CMP DL, 9
    JBE SHORT PH2_NUM
    ADD DL, 'A' - 10
    JMP SHORT PH2_OUT
PH2_NUM:
    ADD DL, '0'
PH2_OUT:
    MOV AH, 02h
    INT 21h

    ; nibble 0 (bits 3..0)
    MOV DX, AX
    AND DL, 0Fh
    CMP DL, 9
    JBE SHORT PH3_NUM
    ADD DL, 'A' - 10
    JMP SHORT PH3_OUT
PH3_NUM:
    ADD DL, '0'
PH3_OUT:
    MOV AH, 02h
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_HEX_4 ENDP

; Print AX as 16 binary digits with leading zeros
PRINT_BIN_16 PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, AX
    MOV CX, 16
PB_LOOP:
    SHL BX, 1
    JNC PB_ZERO
    MOV DL, '1'
    JMP SHORT PB_OUT
PB_ZERO:
    MOV DL, '0'
PB_OUT:
    MOV AH, 02h
    INT 21h
    LOOP PB_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_BIN_16 ENDP

main ENDP
END main






main endp
end main