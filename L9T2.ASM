.model small
.stack 100h
.data

msg db 'enter a message:$'
newline db 0Dh,0Ah,'$'

input db 100 dup('$')
array1 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
array2 db 'FVXCHSAIYQWGOTBNZKMJPLURDE'

.code
main proc
    mov ax,@data
    mov ds,ax

    mov dx,offset msg
    mov ah,09h
    int 21h

    mov ah,0Ah
    mov dx,offset input
    int 21h

    mov si,offset input+2
    mov cl,input+1

encode:
    cmp cl,0
    je print_encode
    mov al,[si]
    cmp al,32
    je skip_encode
    mov di,0
find_enc:
    cmp al,array1[di]
    je found_enc
    inc di
    cmp di,26
    jne find_enc
    jmp skip_encode
found_enc:
    mov al,array2[di]
    mov [si],al
skip_encode:
    inc si
    dec cl
    jmp encode

print_encode:
    mov dx,offset newline
    mov ah,09h
    int 21h

    mov dx,offset input+2
    mov ah,09h
    int 21h

    mov si,offset input+2
    mov cl,input+1

decode:
    cmp cl,0
    je print_decode
    mov al,[si]
    cmp al,32
    je skip_decode
    mov di,0
find_dec:
    cmp al,array2[di]
    je found_dec
    inc di
    cmp di,26
    jne find_dec
    jmp skip_decode
found_dec:
    mov al,array1[di]
    mov [si],al
skip_decode:
    inc si
    dec cl
    jmp decode

print_decode:
    mov dx,offset newline
    mov ah,09h
    int 21h

    mov dx,offset input+2
    mov ah,09h
    int 21h

    mov ah,4Ch
    int 21h
main endp
end main
