bits 16 ; tell NASM this is 16 bit code
org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00
boot:
    mov si,brd ; point si register to brd label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'

_start:
     jmp main ; init board

main:

    lodsb
    or al,al ; is al == 0 ?
    jz game ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp main

game:

    mov ah,0h   ; get character from keyboard
    int 16h     ; and store it in AL
    mov ah,0eh  ; Display a character in AL
    
    cmp al,113 ; checks if user has enter q to quit
    jz halt ; quit if user enter q

    mov ah, [player]
    cmp al,49 ; check if player picked 1
    jz moveone
    cmp al,50 ; check if player picked 2
    jz movetwo
    cmp al,51 ; check if player picked 3
    jz movethree
    cmp al,52 ; check if player picked 4
    jz movefour
    cmp al,53 ; check if player picked 5
    jz movefive
    cmp al,54 ; check if player picked 6
    jz movesix
    cmp al,55 ; check if player picked 7
    jz moveseven
    cmp al,56 ; check if player picked 8
    jz moveeight
    cmp al,57 ; check if player picked 9
    jz movenine

setplayer:
    mov ah, [player]
    cmp ah, 88 ; check if player is x
    jz seto ; switch to O
    cmp ah, 79 ; check if player is O
    jz setx ; switch to X

playerset:
    mov si,brd ; point si register to brd label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
    jmp main

setx:
    mov byte [player], 'X'
    jmp playerset

seto:
    mov byte [player], 'O'
    jmp playerset

moveone:
    mov [spaceone], ah
    jmp setplayer

movetwo:
    mov [spacetwo], ah
    jmp setplayer

movethree:
    mov [spacethree], ah
    jmp setplayer

movefour:
    mov [spacefour], ah
    jmp setplayer

movefive:
    mov [spacefive], ah
    jmp setplayer

movesix:
    mov [spacesix], ah
    jmp setplayer

moveseven:
    mov [spaceseven], ah
    jmp setplayer

moveeight:
    mov [spaceeight], ah
    jmp setplayer

movenine:
    mov [spacenine], ah
    jmp setplayer

halt:
    cli ; clear interrupt flag
    hlt ; halt execution

brd:          db 0x0D, 0x0A, 0x0D, 0x0A
spaceone:     db '1'
	      db " | "
spacetwo:     db '2'
	      db " | "
spacethree:   db '3'
	      db " ", 0x0D, 0x0A,
spacefour:    db '4'
	      db " | "
spacefive:    db '5'
	      db " | "
spacesix:     db '6'
	      db " ", 0x0D, 0x0A,
spaceseven:   db '7'
	      db " | "
spaceeight:   db '8'
	      db " | "
spacenine:    db '9', 0

player:       db 'X', 0

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ;  marks this 512 byte sector bootable!
