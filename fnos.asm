;  _____ _____ _____ _____
; |   __|   | |     |   __|
; |   __| | | |  |  |__   |
; |__|  |_|___|_____|_____|
;               v.0.0-beta


%include "lib/base.inc"
%include "game/tetranglix.asm"
ORG BASE_RUN_OFS

BITS 16

start:
    call    bersihkan_layar
    
    mov     ah, 0x6    
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F    
    int     0x10

    mov     ah, 0eh
    mov     al, ">"
    int     10h

    mov     ah, 0eh
    mov     al, " "
    int     10h

 _loop:
    xor     ah, ah
    int     16h 
    mov     ah, 0eh
    int     10h
    mov     bl, al 
    jmp     tukar_char
lanjut:
    cmp     al, 0dh
    je      compare_input
    jmp     _loop
tukar_char:
    xchg    cl, bl
    jmp     lanjut   
compare_input:
    cmp     bl, "t"
    je      tetris
    cmp     bl, "T"
    je      tetris
    cmp     bl, "s"
    je      shutdown
    cmp     bl, "S"
    je      shutdown 
    cmp     bl, "r"
    je      reboot
    cmp     bl, "R"
    je      reboot

    jmp     $            ; Jump here - infinite loop!


bersihkan_layar:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

reboot:
    xor     ah, ah
    int     19h

shutdown:
    mov     ax, 0x1000
    mov     ax, ss
    mov     sp, 0xf000
    mov     ax, 0x5307
    mov     bx, 0x0001
    mov     cx, 0x0003
    int     0x15
