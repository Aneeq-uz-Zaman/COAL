.MODEL SMALL
.STACK 100H
.DATA
    NAME_STR DB 'Muhammad Aneeq$'
    ROLL_STR DB 'BSDSF24A033$'
.CODE
MAIN PROC
                 MOV  AX,@DATA
                 MOV  DS,AX

                 MOV  DX,OFFSET NAME_STR
                 CALL PRINT_STRING

                 MOV  DX,OFFSET ROLL_STR
                 CALL PRINT_STRING

                 MOV  AH,4CH
                 INT  21H
MAIN ENDP

PRINT_STRING PROC
                 MOV  AH,09H
                 INT  21H
                 RET
PRINT_STRING ENDP

END MAIN
