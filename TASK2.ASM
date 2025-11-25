.model small
.stack 100h
.data
array db "mynameisaneeq$"
array1 db "MYNAMEISANEEQ$"
.code
main proc
mov ax,@data
mov ds,ax
mov si,offset array
mov di, offset array1
add si,8
add di,8
mov cx,5
again: and [si],DFh
        or [di],20h
        inc si
        inc di
        dec cx
        jnz again
mov dx,offset array1
int 21
mov dx,offset array2
int 21
mov ah,4ch
int 21
main endp
end main
