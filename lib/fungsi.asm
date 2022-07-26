_1:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

_2:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

_3:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

_4:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

shutdown:
    mov     ax, 5301
    xor     bx, bx
    int     0x15

    mov     ax, 0x530E
    xor     bx, bx
    mov     cx, 0x0102
    int     0x15

    mov     ax, 0x5307
    mov     bx, 0x0001
    mov     cx, 0x0003
    int     0x15
    ret


%include "lib/print_string.asm"

; Prints the value of DX as hex.
print_hex:
    pusha             ; save the register values to the stack for later

    mov     cx,4          ; Start the counter: we want to print 4 characters
                    ; 4 bits per char, so we're printing a total of 16 bits

char_loop:
    dec     cx            ; Decrement the counter

    mov     ax,dx         ; copy bx into ax so we can mask it for the last chars
    shr     dx,4          ; shift bx 4 bits to the right
    and     ax,0xf        ; mask ah to get the last 4 bits

    mov     bx, HEX_OUT   ; set bx to the memory address of our string
    add     bx, 2         ; skip the '0x'
    add     bx, cx        ; add the current counter to the address

    cmp     ax, 0xa        ; Check to see if it's a letter or number
    jl      set_letter     ; If it's a number, go straight to setting the value
    add     al, 0x27      ; If it's a letter, add 0x27, and plus 0x30 down below
                    ; ASCII letters start 0x61 for "a" characters after 
                    ; decimal numbers. We need to cover that distance. 
    jl      set_letter

set_letter:
    add     al, 0x30      ; For and ASCII number, add 0x30
    mov     byte [bx], al  ; Add the value of the byte to the char at bx

    cmp     cx, 0          ; check the counter, compare with 0
    je      print_hex_done ; if the counter is 0, finish
    jmp     char_loop     ; otherwise, loop again

print_hex_done:
    mov     bx, HEX_OUT   ; print the string pointed to by bx
    call    print_string

    popa              ; pop the initial register values back from the stack
    ret               ; return the function

HEX_OUT: db '0x0000', 0


cetak_string:           
    mov     ah, 0x0e    
.repeat:
    lodsb           
    test    al, al
    je      .done       
    int     0x10         
    jmp     .repeat
.done:
    ret
    
; ==============================

logo:
    db  13, 10, " _____ _____ _____ _____"
    db  13, 10, "|   __|   | |     |   __|"
    db  13, 10, "|   __| | | |  |  |__   |"
    db  13, 10, "|__|  |_|___|_____|_____|"
    db  13, 10, "by Febriyanto Nugroho"
    db  13, 10, "  ", 0x0
 
about:
    call    _2

    mov     ah, 0x6   
    xor     al, al    
    xor     cx, cx    
    mov     dx, 0x184F  
    mov     bh, 0x0F    
    int     0x10

    mov     ah, 0x02
    mov     dh, 0x00
    xor     dl, dl
    xor     bh, bh
    int     0x10
 
    mov     cx, 0x8
    mov     ah, 0x0e
__loop:
    mov     al, 13
    int     0x10
    mov     al, 10
    int     0x10
    dec     cx
    jnz     __loop
 
    mov     si, logo
    call    cetak_string
    
    mov     ah, 0x02
    mov     dh, 0x10
    xor     dl, dl
    xor     bh, bh
    int     0x10

    mov     si, teks_tentang
    call    cetak_string

    xor     ah, ah
    int     0x16 
    cmp     al, 0x0d
    je      main_os


teks_tentang:
    db  13, 10, "This is very dumb simple minimal operating system by Febriyanto Nugroho,"
    db  13, 10, "written from scratch using x86 assembly language 16-bit Real Mode 8086."
    db  13, 10, "It was written in order to learn about 8086 it quite likely"
    db  13, 10, "will serve no use for you :)."
    db  13, 10, "  "
    db  13, 10, "You know ?, this very dumb simple minimal operating system is dedicated"
    db  13, 10, "for my parents with initial H and S and my sister with initial N."
    db  13, 10, "Press 'Enter' to continue.", 0x0
 
teks_info:
    db  13, 10, "  "
    db  13, 10, "You're at ", 0x0


info:
    call    _3

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
    mov     dh, 0x10
    xor     dl, dl
    xor     bh, bh
    int     0x10
 
    mov     si, logo
    call    cetak_string

    mov     ah, 0x02
    mov     dh, 0x16
    xor     dl, dl
    xor     bh, bh
    int     0x10

    mov     si, teks_info
    call    cetak_string

    mov     dx, BASE_ABS_ADDR
    call    print_hex

    xor     ah, ah
    int     0x16 
    cmp     al, 0x0d
    je      main_os
    
tanggal:
    call    date
    call    day
    call    month

    call    century
    call    year
    call    display_date

date:
;Get date from the system
    mov     ah, 04h   ;function 04h (get RTC date)
    int     1ah     ;BIOS Interrupt 1ah (Read Real Time Clock)
    ret

;CH - Century
;CL - Year
;DH - Month
;DL - Day

month:
;Converts the system date from BCD to ASCII
    mov     bh, dh ;copy contents of month (dh) to bh
    shr     bh, 4
    add     bh, 30h ;add 30h to convert to ascii
    mov     [display + 3], bh
    mov     bh, dh
    and     bh, 0fh
    add     bh, 30h
    mov     [display + 4], bh
    ret

day:
    mov     bh, dl ;copy contents of day (dl) to bh
    shr     bh, 4
    add     bh, 30h ;add 30h to convert to ascii
    mov     [display + 0], bh
    mov     bh, dl
    and     bh, 0fh
    add     bh, 30h
    mov     [display + 1], bh
    ret

century:
    mov     bh, ch ;copy contents of century (ch) to bh
    shr     bh, 4
    add     bh, 30h ;add 30h to convert to ascii
    mov     [display + 6], bh
    mov     bh, ch
    and     bh, 0fh
    add     bh, 30h
    mov     [display + 7], bh
    ret

year:
    mov     bh, cl ;copy contents of year (cl) to bh
    shr     bh, 4
    add     bh, 30h ;add 30h to convert to ascii
    mov     [display + 5], ch
    mov     [display + 8], bh
    mov     bh, cl
    and     bh, 0fh
    add     bh, 30h
    mov     [display + 9], bh
    ret


display: 
    db "00-00-0000"

display_date:
    mov     ah, 0x6   
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F    
    int     0x10

;Display the system date

    mov     ah, 13h ;function 13h (Display String)
    xor     al, al ;Write mode is zero
    xor     bh, bh ;Use video page of zero
    mov     bl, 0xf0 ;Attribute
    mov     cx, 10 ;Character string is 10 long
    mov     dh, 11 ;position on row 4
    mov     dl, 35 ;and column 28
    push    ds ;put ds register on stack
    pop     es ;pop it into es register
    lea     bp, [display] ;load the offset address of string into BP
    int     10h

    xor     ah, ah
    int     0x16 
    cmp     al, 0x0d
    je      main_os
    
waktu:
    mov     ah, 0x6    
    xor     al, al    
    xor     cx, cx     
    mov     dx, 0x184F  
    mov     bh, 0x0F    
    int     0x10

    call    time

    mov     al, ch
    call    cvt
    mov     [tmfld + 0], ax
    mov     al, cl
    call    cvt
    mov     [tmfld + 3], ax
    mov     al, dh
    call    cvt
    mov     [tmfld + 6], ax

    call    dsptime

time:
    mov     ah, 0x02
    int     0x1a
    ret

cvt:
    mov     ah, al
    shr     al, 4
    and     ah, 0x0F
    add     ax, 0x3030
    ret

tmfld:  db '00:00:00'

dsptime:
    mov     ah, 0x13
    mov     al, 0
    mov     bh, 0
    mov     bl, 0x0F
    mov     cx, 8
    mov     dh, 11
    mov     dl, 35
    push    ds
    pop     es
    mov     bp, tmfld
    int     0x10

    xor     ah, ah
    int     0x16 
    cmp     al, 0x0d
    je      main_os
    ret
    
hati:  
 
mov ax,0x0013	; Graphics mode 320x200x256 colors
	int 0x10	; Setup video mode
	mov ax,0xa000	; Point to video memory
	mov ds,ax
animate:
	mov cx,0x007f	; t = 127 (where pi * 2 is 128)
main_loop:
	mov ax,cx	; sin(t)
	call get_sin
	mov bx,ax
	imul bx		; ^2
	call defrac
	imul bx		; ^3
	call defrac
	mov bx,40	; Expand to fill screen horizontally
	imul bx
	call defrac
	add ax,160	; Center horizontally
	push ax		; Save x-coord in stack.

	mov al,4	; cos(4 * t)
	mul cl
	call get_cos
	push ax
	mov al,3	; cos(3 * t)
	mul cl
	call get_cos
	shl ax,1	; * 2
	push ax
	mov al,2	; cos(2 * t)
	mul cl
	call get_cos
	mov bx,5	; * 5
	imul bx
	push ax
	mov ax,cx
	call get_cos	; cos(t) * 13
	mov bx,13
	imul bx
	pop bx
	sub ax,bx	; 13*cos(t) - 5*cos(2*t)
	pop bx
	sub ax,bx	; 13*cos(t) - 5*cos(2*t) - 2*cos(3*t)
	pop bx
	sub ax,bx	; 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)
	neg ax
	mov bx,3	; Expand to fill screen vertically
	imul bx
	call defrac
	add ax,100	; Center vertically
	mov bx,320	; Get row pixel address
	mul bx
	pop bx
	add bx,ax	; Add column pixel address
	mov byte [bx],0x0c	; Paint a red pixel

	loop main_loop
; key for exit, didn't work
    ;xor     ah, ah
    ;int     0x16 
    ;cmp     al, "q"
    ;je      main_os

	;
	; Remove fraction
	;
defrac:
	mov al,ah
	mov ah,dl
	ret

	;
	; Get cosine
	; Input: al = angle (0-127)
	; Output: ax = 8.8 fraction
	;
get_cos:
        add al,32       ; Add 90 degrees to get cosine
	;
	; Get sine
	; Input: al = angle (0-127)
	; Output: ax = 8.8 fraction
	;
get_sin:
        test al,64      ; Angle >= 180 degrees?
        pushf
        test al,32      ; Angle 90-179 or 270-359 degrees?
        je .2
        xor al,31       ; Invert bits (reduces table)
.2:
        and ax,31       ; Only 90 degrees in table
        mov bx,sin_table
        cs xlat         ; Get fraction
        popf
        je .1           ; Jump if angle less than 180
        neg ax          ; Else negate result
.1:
        ret

	;
	; Sine table (0.8 format)
	;
	; 32 bytes are 90 degrees.
	;
sin_table:
	db 0x00,0x09,0x16,0x24,0x31,0x3e,0x47,0x53
	db 0x60,0x6c,0x78,0x80,0x8b,0x96,0xa1,0xab
	db 0xb5,0xbb,0xc4,0xcc,0xd4,0xdb,0xe0,0xe6
	db 0xec,0xf1,0xf5,0xf7,0xfa,0xfd,0xff,0xff
