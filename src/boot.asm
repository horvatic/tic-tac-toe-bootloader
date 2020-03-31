bits 16 ; tell NASM this is 16 bit code
org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00
boot:
    mov si,brd ; point si register to brd label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'

.init:
     jmp readboard ; init board

start:
    mov ah,0h   ;get character from keyboard
    int 16h     ;and store it in AL
    mov ah,0eh  ;Display a character in AL
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    cmp al,113 ; checks if user has enter q to quit
    jz halt ; quit if user enter q
    mov si,brd ; point si register to brd label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
    jmp readboard
    jmp start

readboard:
    lodsb
    or al,al ; is al == 0 ?
    jz start ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp readboard

halt:
    cli ; clear interrupt flag
    hlt ; halt execution


brd: db 0x0D, 0x0A, 0x0D, 0x0A, " 1 | 2 | 3 ", 0x0D, 0x0A, " 4 | 5 | 6 ", 0x0D, 0x0A, " 7 | 8 | 9 "

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ;  marks this 512 byte sector bootable!
