tix:
    mov     ah, 06h   
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0184Fh  
    mov     bh, 00Fh    
    int     10h

cetak_tic_tac_toe_layout:
    mov     ah, 02h
    xor     dh, dh
    xor     dl, dl
    xor     bh, bh
    int     10h

    mov     si, tic_tac_toe_layout
    call    @cetak_string

    mov     dh, 7 
lanjut:
    mov     ah, 0x02 
    push    dx
    xor     bh, bh
    int     0x10

 i:
    xor     ax, ax
    int     16h
    cmp     al, "r"     ; reset game
    je      tix
    cmp     al, "q"     ; quit game
    je      main_os
    mov     ah, 0eh
    int     10h 
    mov     bh, al
 
    cmp     al, "x"
    je      _char_x
    cmp     al, "o"
    je      _char_o 
    
    mov     al, 20h
    int     10h
    xor     ax, ax
    int     16h
    cmp     al, "r"     ; reset game
    je      tix
    cmp     al, "q"     ; quit game
    je      main_os
    mov     ah, 0eh
    int     10h
    mov     bl, al 
    
    cmp     bx, 3131h
    je      _bar_1_kol_1
    cmp     bx, 3132h
    je      _bar_1_kol_2
    cmp     bx, 3133h
    je      _bar_1_kol_3
     
    cmp     bx, 3231h
    je      _bar_2_kol_1
    cmp     bx, 3232h
    je      _bar_2_kol_2
    cmp     bx, 3233h
    je      _bar_2_kol_3

    cmp     bx, 3331h
    je      _bar_3_kol_1
    cmp     bx, 3332h
    je      _bar_3_kol_2
    cmp     bx, 3333h
    je      _bar_3_kol_3
       
_bar_1_kol_1:
    mov     dh, 1
    mov     dl, 2  
    jmp     _spasi
_bar_1_kol_2:
    mov     dh, 1
    mov     dl, 6  
    jmp     _spasi
_bar_1_kol_3:
    mov     dh, 1
    mov     dl, 10  
    jmp     _spasi 
_bar_2_kol_1:
    mov     dh, 3
    mov     dl, 2
    jmp     _spasi
_bar_2_kol_2:
    mov     dh, 3
    mov     dl, 6
    jmp     _spasi
_bar_2_kol_3:
    mov     dh, 3
    mov     dl, 10
    jmp     _spasi
_bar_3_kol_1:
    mov     dh, 5
    mov     dl, 2
    jmp     _spasi
_bar_3_kol_2:
    mov     dh, 5
    mov     dl, 6
    jmp     _spasi
_bar_3_kol_3:
    mov     dh, 5
    mov     dl, 10
    jmp     _spasi    
_char_x:
    mov     al, "x"
    jmp    _cetak
_char_o:
    mov     al, "o"
    jmp    @_cetak
@_cetak:
    mov     ah, 02h
    xor     bh, bh
    int     10h
    mov     ah, 0eh
    int     10h
    xor     dx, dx 
    pop     dx
    inc     dh
    push    dx
    jmp     lanjut    
_spasi:   
    mov     al, 20h
    int     10h  
 
    jmp     i


@cetak_string:           
    mov     ah, 0x0e    
@.repeat:
    lodsb           
    test    al, al
    je      @.done       
    int     0x10         
    jmp     @.repeat
@.done:
    ret

    
tic_tac_toe_layout:
    db          "+---+---+---+"
    db 13, 10,  "|   |   |   |"
    db 13, 10,  "+---+---+---+"
    db 13, 10,  "|   |   |   |"
    db 13, 10,  "+---+---+---+"
    db 13, 10,  "|   |   |   |"
    db 13, 10,  "+---+---+---+", 0x0, 0x00
