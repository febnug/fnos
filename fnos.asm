;  _____ _____ _____ _____
; |   __|   | |     |   __|
; |   __| | | |  |  |__   |
; |__|  |_|___|_____|_____|
;               v.0.0-beta


%include "lib/base.inc"
%include "game/tetranglix.asm"
%include "lib/main.asm"

ORG BASE_RUN_OFS

BITS 16

start:

    call    bersihkan_layar_0

    mov     ah, 0x6   
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F    
    int     0x10


; DB
; DC
; DE
; DD
; DF

    

    mov     ah, 0x02
    mov     dh, 10
    mov     dl, 38
    xor     bh, bh
    int     0x10  
      
    mov     ah, 0x09
    mov     al, 0xFE
    xor     bh, bh
    mov     bl, 0x0F
    mov     cx, 1
    int     0x10

    mov     ah, 0x02
    mov     dh, 09
    mov     dl, 39
    xor     bh, bh
    int     0x10  
      
    mov     ah, 0x09
    mov     al, 0xFE
    xor     bh, bh
    mov     bl, 0x0F
    mov     cx, 1
    int     0x10
    
 
    xor     ah, ah
    int     0x16 
    cmp     al, 0x0d
    je      main_os
    

    jmp     $


bersihkan_layar_0:
    xor     ah, ah
    mov     al, 0x03  
    int     0x10
    ret
