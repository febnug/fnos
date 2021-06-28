BASE_ABS_ADDR   equ 0x07e00    ; Physical address of "BASE"

; Segment and Offset to use to transfer (FAR JMP) control to "BASE"
;     Segment:Offset = 0x0000:0x7e00
BASE_RUN_SEG   equ 0x0000
BASE_RUN_OFS   equ BASE_ABS_ADDR
