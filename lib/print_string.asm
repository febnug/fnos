print_string:         ; Push registers onto the stack
  pusha

string_loop:
  mov     al, [bx]    ; Set al to the value at bx
  test    al, al      ; Compare the value in al to 0 (check for null terminator)
  jne     print_char  ; If it's not null, print the character at al
                      ; Otherwise the string is done, and the function is ending
  popa                ; Pop all the registers back onto the stack
  ret                 ; return execution to where we were

print_char:
  mov     ah, 0x0e    ; Linefeed printing
  int     0x10        ; Print character
  inc     bx          ; Shift bx to the next character
  jmp     string_loop ; go back to the beginning of our loop
