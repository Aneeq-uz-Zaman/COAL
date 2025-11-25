.model small
.stack 100h
.data
array1 db 5 dup(?)             
array2 db "Enter the number in HEX: $"  
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
    cmp si,4
    je done

    cmp al,'0'
    jb READ_NUM         
    cmp al,'9'
    ja letter
    jmp valid
letter:
    cmp al,'A'
    jb READ_NUM        
    cmp al,'F'
    ja READ_NUM         
valid:
    mov array1[si],al  
    inc si
    jmp READ_NUM

done:
    mov array1[si],'$'   

    mov si,0
PRINT_ARRAY:
    mov al,array1[si]
    cmp al,'$'
    je exit

    ; convert ASCII to numeric value
    cmp al,'9'
    jbe number
    sub al,'A'
    add al,10
    jmp bits
number:
    sub al,'0'

bits:
    mov cl,4            
    mov bl,al           
    mov ch,4            
shift_left4:
    shl bl,1           
    dec ch
    jnz shift_left4

printbits:
    shl bl,1           
    jc printone         
    mov dl,'0'
    jmp outbit
printone:
    mov dl,'1'
outbit:
    mov ah,02h
    int 21h
    dec cl
    jnz printbits

    inc si
    jmp PRINT_ARRAY

exit:
    mov ah,4Ch
    int 21h

main endp
end main