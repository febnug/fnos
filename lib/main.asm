%include "fungsi.asm"

 main_os:
    call    bersihkan_layar_1

    mov     ah, 0x6    
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F   
    int     0x10


    mov     ah, 0x01
    mov     cx, 16
    int     0x10
    
    mov     ah, 0x02
    push    0x0101
    pop     dx
_input:
    mov     ah, 0x02
    xor     bh, bh
    int     0x10   
    xor     ah, ah
    int     0x16   
    cmp     al, 0x08
    je      _backspace
    cmp     al, 0dh
    je      _baris_selanjutnya
    cmp     al, "t"
    je      _cetak
    cmp     al, "T"
    je      _cetak
    cmp     al, "s"
    je      _cetak
    cmp     al, "S"
    je      _cetak
    cmp     al, "r"
    je      _cetak
    cmp     al, "R"
_baris_selanjutnya:
    inc     dh 
    push    dx
    jmp     _input
    
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
    xor     bh, bh
    int     0x10 

    cmp     cl, 0x0d 
    je      _input
    jne      _xoring
_xoring:
    xor     bl, bl
    test    bl, bl
    je      _input
    
    jmp     _loop 
    
    jmp     $            
