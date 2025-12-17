.model small
.stack 100h
.data
msg1        db  "Enter cents : $"

outHD       db  13,10, "Half: $"
outQ        db  13,10, "Quart: $"
outD        db  13,10, "Dim: $"
outN        db  13,10, "Nick: $"
outP        db  13,10, "Pen: $"


cents       db ?


HD  db ?
quarter     db ?
dime        db ?
nickel      db ?
penny       db ?


.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    mov dx, offset msg1
    int 21h

    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, 10
    mul bl 
    mov cents, al


    mov ah, 01h
    int 21h
    sub al, 30h
    add al, cents
    mov cents, al



    mov al, cents
    mov ah,0
    mov bl, 50
    div bl                  
    mov HD, al
    mov cents, ah

    mov al, cents
    mov ah, 0
    mov bl, 25
    div bl
    mov quarter, al
    mov cents, ah

    mov al, cents
    mov ah, 0
    mov bl, 10
    div bl
    mov dime, al
    mov cents, ah

    mov al, cents
    mov ah, 0
    mov bl, 5
    div bl
    mov nickel, al
    mov cents, ah

    mov al, cents
    mov ah, 0
    mov penny, al

    mov ah,09h
    mov dx, offset outHD
    int 21h

    mov al, HD
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    mov ah,09h
    mov dx, offset outQ
    int 21h

    mov al, quarter
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    

    mov ah,09h
    mov dx, offset outD
    int 21h

    mov al, dime
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    mov ah,09h
    mov dx, offset outN
    int 21h

    mov al, nickel
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    mov ah,09h
    mov dx, offset outP
    int 21h

    mov al, penny
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    mov ah,4Ch
    int 21h

main endp
end main
