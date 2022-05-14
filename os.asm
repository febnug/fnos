; Base FNOS
;
; -------------------
;
; btw, this is copying and pasting from stack overflow :)
; 

%include "lib/base.inc" ; oh, this is base 

BASE_LOAD_SEG  equ BASE_ABS_ADDR>>4                              
BASE_LBA_START equ 1                                   
BASE_LBA_END   equ BASE_LBA_START + NUM_BASE_SECTORS                              
DISK_RETRIES     equ 3         

bits 16
ORG 0x7c00

; Include a BPB (1.44MB floppy with FAT12) to be more comaptible with USB floppy media
%include "lib/bpb.inc"

boot_start:
    xor     ax, ax                  
    mov     ds, ax
    mov     ss, ax                  
    mov     sp, 0x7c00
    cld                         

load_base:
    mov     [bootDevice], dl        
    mov     di, BASE_LOAD_SEG     
    mov     si, BASE_LBA_START    
    jmp     .chk_for_last_lba       

.read_sector_loop:
    mov     bp, DISK_RETRIES        

    call    lba_to_chs             
    mov     es, di                 
    xor     bx, bx                 

.retry:
    mov     ax, 0x0201              
                               
    int     0x13                    
    jc      .disk_error              

.success:
    add     di, 512>>4              
    inc     si                      

.chk_for_last_lba:
    cmp     si, BASE_LBA_END      
    jl      .read_sector_loop        

.base_loaded:
    mov     ax, BASE_RUN_SEG     
    mov     ds, ax
    mov     es, ax

    jmp     BASE_RUN_SEG:BASE_RUN_OFS

.disk_error:
    xor     ah, ah                  
    int     0x13
    dec     bp                      
    jge     .retry                  

error_end:
    xor     ah, ah
    mov     al, 0x03  ; text mode 80x25 16 colours
    int     0x10
    ret

    mov     ah, 0x6    ; Scroll up function
    xor     al, al    ; Clear entire screen
    xor     cx, cx     ; Upper left corner CH=row, CL=column
    mov     dx, 0x184F  ; lower right corner DH=row, DL=column
    mov     bh, 0x0F    ; Black & White
    int     0x10

    mov     si, diskErrorMsg        
    call    print_string
    cli
.error_loop:
    hlt
    jmp     .error_loop

print_string:
    mov     ah, 0x0e                
    xor     bx, bx                  
    jmp     .getch
.repeat:
    int     0x10                    
.getch:
    lodsb                       
    test    al, al                  
    jnz     .repeat                 
.end:
    ret

lba_to_chs:
    push    ax                     
    mov     ax, si                  
    xor     dx, dx                  
    div     word [sectorsPerTrack]  
    mov     cl, dl                  
    inc     cl                     
    xor     dx, dx                  
    div     word [numHeads]         
    mov     dh, dl                  
    mov     dl, [bootDevice]         
    mov     ch, al                  
    shl     ah, 6                   
    or      cl, ah                  
    pop     ax                      
    ret

; Uncomment these lines if not using a BPB (via bpb.inc)
; numHeads:        dw 2         ; 1.44MB Floppy has 2 heads & 18 sector per track
; sectorsPerTrack: dw 18

bootDevice:      db 0x00
diskErrorMsg:    db "!", 0


TIMES 510-($-$$) db  0
dw 0xaa55

NUM_BASE_SECTORS equ (base_end-base_start+511) / 512
                                ; Number of 512 byte sectors "base" uses.

base_start:
    incbin "fnos.bin"

base_end:
