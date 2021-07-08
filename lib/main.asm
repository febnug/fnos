 %include "fungsi.asm"

 main_os:
    call    bersihkan_layar_1

    mov     ah, 0x6    
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F   
    int     0x10

    mov     ah, 0x02
    mov     dh, 0x01
    mov     dl, 0x01
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
    cmp     bl, "s"
    je      shutdown
    cmp     bl, "S"
    je      shutdown 
    cmp     bl, "r"
    je      reboot
    cmp     bl, "R"
    je      reboot
_backspace: 
    xor     al, al
    jmp     _cetak 
_input_lagi:
    mov     ah, 0x02
    mov     dh, 0x01
    mov     dl, 0x01
    xor     bh, bh
    int     0x10 
    jmp     _loop 

    jmp     $            
