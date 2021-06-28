;  _____ _____ _____ _____
; |   __|   | |     |   __|
; |   __| | | |  |  |__   |
; |__|  |_|___|_____|_____|
;               v.0.0-beta


%include "base.inc"
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


    xor     ah, ah
    int     16h
    cmp     al, 'r'
    je      reboot
    cmp     al, 's'
    je      shutdown
    cmp     al, 't'
    je      tetris


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
