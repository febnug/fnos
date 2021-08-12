;  _____ _____ _____ _____
; |   __|   | |     |   __|
; |   __| | | |  |  |__   |
; |__|  |_|___|_____|_____|
;
; Copyright (c) 2021 Febriyanto Nugroho


%include "lib/base.inc"
%include "game/tetranglix.asm"
%include "lib/fungsi.asm"

ORG BASE_RUN_OFS

BITS 16

start:

main_os:
    call    bersihkan_layar_1

    mov     ah, 0x6    ; Scroll up function
    xor     al, al    ; Clear entire screen
    xor     cx, cx     ; Upper left corner CH=row, CL=column
    mov     dx, 0x184F  ; lower right corner DH=row, DL=column
    mov     bh, 0x0F    ; Black & White
    int     0x10



    mov     ah, 0x02
    mov     dh, 0x09
    xor     dl, dl
    xor     bh, bh
    int     0x10
 

    mov     si, intro
    call    cetak_string   


    mov     ah, 0x02
    mov     dh, 0x18
    xor     dl, dl
    xor     bh, bh
    int     0x10

    mov     ah, 0x01
    mov     cx, 16
    int     0x10

_loop:
    xor     ah, ah
    int     0x16 
_cetak:
    mov     ah, 0x0e
    int     0x10
    cmp     al, 0x08
    je      _backspace
    test    al, al
    je      _input_lagi
    mov     bl, al 
    jmp     tukar_char
lanjut:
    cmp     al, 0x0d
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
    cmp     bl, "a"
    je      about
    cmp     bl, "A"
    je      about
_backspace: 
    xor     al, al
    jmp     _cetak 
_input_lagi:
    mov     ah, 0x02
    mov     dh, 0x18
    mov     dl, 0x00
    xor     bh, bh
    int     0x10 
    jmp     _loop


    jmp     $
