.model small
.stack 100h
.data

msg1        db  "Enter cents (0-99): $"

outHD       db  13,10, "Half Dollars: $"
outQ        db  13,10, "Quarters: $"
outD        db  13,10, "Dimes: $"
outN        db  13,10, "Nickels: $"
outP        db  13,10, "Pennies: $"

; storage for numbers
cents       db ?
tens        db ?
ones        db ?

halfDollar  db ?
quarter     db ?
dime        db ?
nickel      db ?
penny       db ?

.code
main proc
    mov ax, @data
    mov ds, ax

; ------------------------------
; Ask for input
; ------------------------------
    mov ah, 09h
    mov dx, offset msg1
    int 21h

; Read first digit
    mov ah, 01h
    int 21h
    sub al, '0'
    mov tens, al

; Read second digit
    mov ah, 01h
    int 21h
    sub al, '0'
    mov ones, al

; Combine into one number: cents = tens*10 + ones
    mov al, tens
    mov bl, 10
    mul bl             ; AL = tens*10
    add al, ones
    mov cents, al

; ------------------------------------------------
; Convert to coin units
; ------------------------------------------------

; Half Dollar (50)
    mov al, cents
    mov bl, 50
    div bl                  ; AL = count, AH = remainder
    mov halfDollar, al
    mov cents, ah

; Quarter (25)
    mov al, cents
    mov bl, 25
    div bl
    mov quarter, al
    mov cents, ah

; Dime (10)
    mov al, cents
    mov bl, 10
    div bl
    mov dime, al
    mov cents, ah

; Nickel (5)
    mov al, cents
    mov bl, 5
    div bl
    mov nickel, al
    mov cents, ah

; Pennies (1)
    mov al, cents
    mov penny, al


; ------------------------------
; PRINT OUTPUT
; ------------------------------

; Half Dollar
    mov ah,09h
    mov dx, offset outHD
    int 21h

    mov al, halfDollar
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

; Quarter
    mov ah,09h
    mov dx, offset outQ
    int 21h

    mov al, quarter
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

; Dime
    mov ah,09h
    mov dx, offset outD
    int 21h

    mov al, dime
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

; Nickel
    mov ah,09h
    mov dx, offset outN
    int 21h

    mov al, nickel
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

; Penny
    mov ah,09h
    mov dx, offset outP
    int 21h

    mov al, penny
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

; Exit program
    mov ah,4Ch
    int 21h

main endp
end main
