.MODEL SMALL
.STACK 100H
.DATA
    ARR1 DB 1,2,3,4,5,6,7,8
    ARR2 DB 9,8,7,6,5,4,3,2
    ARR3 DB 8 DUP(?)
.CODE
MAIN PROC
              MOV  AX,@DATA
              MOV  DS,AX
              MOV  SI,OFFSET ARR1
              MOV  DI,OFFSET ARR2
              MOV  BX,OFFSET ARR3
              CALL ADD_ARRAY
              MOV  AH,4CH
              INT  21H
MAIN ENDP
ADD_ARRAY PROC
              MOV  CX,8
    L1:       
              MOV  AL,[SI]
              ADD  AL,[DI]
              MOV  [BX],AL
              INC  SI
              INC  DI
              INC  BX
              DEC  CX
              JNZ  L1
              RET
ADD_ARRAY ENDP
END MAIN
