section .data
    ; Macro for printing one line
    %macro PRINT_LINE 1
        mov ecx, %1
        call print_line
    %endmacro

    line1  db "                         I", 10
    len1   equ $ - line1
    line2  db "                       wrote", 10
    len2   equ $ - line2
    line3  db "                      a poem", 10
    len3   equ $ - line3
    line4  db "                    in the shape", 10
    len4   equ $ - line4
    line5  db "                   of a Christmas", 10
    len5   equ $ - line5
    line6  db "                 tree but then forgot", 10
    len6   equ $ - line6
    line7  db "               to water it and only a few", 10
    len7   equ $ - line7
    line8  db "                         days", 10
    len8   equ $ - line8
    line9  db "                         later", 10
    len9   equ $ - line9
    line10 db 10, "                         there", 10
    len10  equ $ - line10
    line11 db "                    were", 10
    len11  equ $ - line11
    line12 db "                              words", 10
    len12  equ $ - line12
    line13 db "       all", 10
    len13  equ $ - line13
    line14 db "                         over", 10
    len14  equ $ - line14
    line15 db "                                   carpet", 10
    len15  equ $ - line15
    line16 db "             the", 10
    len16  equ $ - line16

section .text
    global _start

_start:
    PRINT_LINE line1
    PRINT_LINE line2
    PRINT_LINE line3
    PRINT_LINE line4
    PRINT_LINE line5
    PRINT_LINE line6
    PRINT_LINE line7
    PRINT_LINE line8
    PRINT_LINE line9
    PRINT_LINE line10
    PRINT_LINE line11
    PRINT_LINE line12
    PRINT_LINE line13
    PRINT_LINE line14
    PRINT_LINE line15
    PRINT_LINE line16

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Procedure that prints the line whose address is in ECX
print_line:
    push eax
    push ebx
    push edx

    ; Find the line length by scanning for its newline
    mov edx, ecx
    xor eax, eax
.count:
    cmp byte [edx], 10
    je .done_count
    inc edx
    inc eax
    jmp .count

.done_count:
    inc eax                 ; include the newline
    mov edx, eax            ; number of bytes to print
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    int 0x80

    pop edx
    pop ebx
    pop eax
    ret