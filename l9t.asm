.model small
.stack 100h
.data

msg db 'Enter string only in UPPERCASE: $'
newline db 0Dh,0Ah,'$'

input db 50 dup('$')
array1 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
array2 db 'FVXCHSAIYQWGOTBNZKMJPLURDE'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov dx, offset msg
    mov ah, 09h
    int 21h

    
    mov ah, 0Ah
    mov dx, offset input
    int 21h
    mov si, offset input +2
    mov cl, input + 1          

l1:
    cmp cl, 0
    je print
    mov al, [si] 
    CMP AL,32
    JE NOTH    
    sub al, 'A'       
    mov bx, offset table
    xlat               
    mov [si], al       
NOTH:
    inc si
    dec cl
    jmp l1

print:
    mov dx, offset newline
    mov ah, 09h
    int 21h

    mov dx, offset input + 2
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h
main endp
end main
