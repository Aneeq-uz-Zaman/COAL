.model small
.stack 100h
.data
array1 db 17 dup(?)                  ; array to store binary digits (max 16) + end marker
array2 db "Enter a binary number up to 16 digits: $"
.code
main proc
    mov ax,@data
    mov ds,ax

    ; print prompt
    mov dx,offset array2
    mov ah,09h
    int 21h

    mov si,0
READ_NUM:
    mov ah,01h
    int 21h
    cmp al,0Dh
    je done
    cmp si,16
    je done

    cmp al,'0'
    je valid
    cmp al,'1'
    je valid
    jmp READ_NUM          ; ignore invalid char

valid:
    mov array1[si],al
    inc si
    jmp READ_NUM

done:
    mov array1[si],'$'    ; end marker

    mov si,0
PRINT_HEX:
    mov bl,0
    mov cl,4              ; process 4 bits
bit_loop:
    mov al,array1[si]
    cmp al,'$'
    je exit
    inc si
    shl bl,1
    cmp al,'1'
    jne skip_set
    or bl,1
skip_set:
    dec cl
    jnz bit_loop

    ; print hex digit 0-9/A-F
    mov dl,bl
    cmp dl,9
    jbe prn_num
    add dl,7          ; DL = 10..15 → 'A'..'F' (because 'A' = 65 = 10+55)
prn_num:
    add dl,'0'
    mov ah,02h
    int 21h
    jmp PRINT_HEX

exit:
    mov ah,4Ch
    int 21h

main endp
end main