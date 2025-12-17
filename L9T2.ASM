.MODEL small
.STACK 100h
.DATA

msg db 'Enter a message:$'
newline db 0Dh,0Ah,'$'

input db 100 dup('$')   ; buffer for input

; encoding and decoding tables
array1 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
array2 db 'FVXCHSAIYQWGOTBNZKMJPLURDE'

.CODE
main proc
    mov ax,@data
    mov ds,ax

    ; --- prompt ---
    mov dx,offset msg
    mov ah,09h
    int 21h

    ; --- read input ---
    mov ah,0Ah
    mov dx,offset input
    int 21h

    ; --- encode using XLAT ---
    lea si,input+2           ; start of user input
    mov cl,[input+1]         ; number of characters

encode_loop:
    cmp cl,0
    je print_encode
    mov al,[si]
    cmp al,32                ; ignore space
    je skip_enc
    sub al,'A'               ; index into array1 (0-25)
    mov bx,offset array2     ; BX = base of table
    xlat                     ; AL = array2[AL]
    mov [si],al
skip_enc:
    inc si
    dec cl
    jmp encode_loop

print_encode:
    mov dx,offset newline
    mov ah,09h
    int 21h

    lea dx,input+2
    mov ah,09h
    int 21h

    ; --- decode using XLAT ---
    lea si,input+2
    mov cl,[input+1]

decode_loop:
    cmp cl,0
    je print_decode
    mov al,[si]
    cmp al,32
    je skip_dec
    sub al,'A'
    mov bx,offset array1
    xlat
    mov [si],al
skip_dec:
    inc si
    dec cl
    jmp decode_loop

print_decode:
    mov dx,offset newline
    mov ah,09h
    int 21h

    lea dx,input+2
    mov ah,09h
    int 21h

    ; --- exit ---
    mov ah,4Ch
    int 21h

main endp
end main
