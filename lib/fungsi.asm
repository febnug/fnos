bersihkan_layar_1:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

reboot:
    xor     ah, ah
    int     0x19

shutdown:
    mov     ax, 0x1000
    mov     ax, ss
    mov     sp, 0xf000
    mov     ax, 0x5307
    mov     bx, 0x0001
    mov     cx, 0x0003
    int     0x15
