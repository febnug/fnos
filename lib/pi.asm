pi:

 

scale:		equ 100
arrinit:		equ scale/5
digits:		equ 14000-14	; It will generate (14000-14)/14*2 digits
                                ; Cannot go further with current precision
				
arr:	equ $+0x0200

	mov ax,0x0002	; Set text mode 80x25 and clear screen
	int 0x10	; Call BIOS
	cld		; Reset direction flag
	push cs		; Copy Code Segment to Data and Extended Segment
	pop ds	
	push cs
	pop es

    mov     ah, 0x6	; Scroll up function
    xor     al, al	; Clear entire screen
    xor     cx, cx	; Upper left corner CH=row, CL=column
    mov     dx, 0x184F  ; lower right corner DH=row, DL=column
    mov     bh, 0x0F    ; Black & White
    int     0x10

	mov di,arr	; Point to arr
	mov cx,digits+1	; Total digits plus one
	mov ax,arrinit	; Starting value
	rep stosw	; Reset array
	
	xor si,si	; Carry
	mov bx,digits	
m1:	push bx
	xor ax,ax	; #sum = 0
			; j = #i (uses again bx)
m2:	mul bx		; #sum = #sum * j
	push bx
	push dx
	push ax
	shl bx,1
	mov ax,[bx+arr]	; scale * arr[j]
	mov cx,scale
	mul cx
	pop bx
	add ax,bx	; Add both
	pop bx
	adc dx,bx
	pop bx
	mov cx,bx	; (j * 2 - 1)
	shl cx,1
	dec cx
	div cx
	push bx
	shl bx,1
	mov [bx+arr],dx	; arr(j) = #sum % (j * 2 - 1)
			; ax contains the division result.
	pop bx
	dec bx
	jne m2
	pop bx
	mov cx,scale
	mov dx,0
	div cx
	add ax,si	; carry + #sum / scale
	push dx		; #sum % scale
	mov ah,0
	mov dl,10
	div dl
	add al,0x30	; Left digit
	cmp al,0x3a
	jne m3
	sub al,0x0a
m3:
	call output
	cmp bx,digits
	jne m4
	mov al,'.'	; The start 3 is generated, but insert a period
	call output
m4:
	mov al,ah
	add al,0x30	; Right digit
	call output	
	pop si		; carry = #sum % scale
	sub bx,14
	cmp bx,1
	jge m1
	
	mov ah,0x00	; Wait for a key
	int 0x16
;	int 0x20	; Exit
	cmp al,'z' ; back to main os
	je main_os

	;
	; Output a character to screen
	; 
output:	push ax
	push bx
	push cx
	push dx
	push si
	mov ah,0x0e
	mov bx,0x0007
	int 0x10
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
