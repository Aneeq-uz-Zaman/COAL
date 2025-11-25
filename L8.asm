.MODEL SMALL
.STACK 100H
.DATA
	a1 db 90h,12h,11h,33h,54h,5h,11h,22h,12h,10h,45h,44h,99h,37h,77h,88h
    a2 db dup(00)
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    mov si,OFFSET a1
    mov Cx,16
first:
    push cx
    mov si,0
    mov cx,15
second:
    mov al,ar[si]
    mov bl,ar[si+1]
    cmp al,bl
    jbe no_swap
    mov ar[si],bl
    mov ar[si+1],al
no_swap:
    inc si
    jnz first
    pop cx
    jnz second

END MAIN