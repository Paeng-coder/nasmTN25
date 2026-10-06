; NASM 32-bit Linux ASCII Birthday Cake
; Compile:
; nasm -f elf32 birthday_cake.asm -o birthday_cake.o
; ld -m elf_i386 birthday_cake.o -o birthday_cake
; ./birthday_cake

section .data

    artwork dd line1, line2, line3, line4, line5, line6
            dd line7, line8, line9, line10, line11, line12

    line1  db '              *     *     *', 10, 0
    line2  db '              |     |     |', 10, 0
    line3  db '             ( )   ( )   ( )', 10, 0
    line4  db '              |     |     |', 10, 0
    line5  db '        .------------------------.', 10, 0
    line6  db '       /  H A P P Y  B I R T H D A Y \', 10, 0
    line7  db '      /______________________________\', 10, 0
    line8  db '      |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|', 10, 0
    line9  db '      |   @@@@@@@@@@@@@@@@@@@@@@@@   |', 10, 0
    line10 db '      |______________________________|', 10, 0
    line11 db '     /                                \', 10, 0
    line12 db '    /__________________________________\', 10, 0

    newline db 10
    repeat_char db 0

section .text
    global _start

_start:

    ; Print a decorative line using a loop
    mov al, '='
    mov ecx, 38
    call print_repeat

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Print all cake lines using a loop
    mov esi, artwork
    mov ebp, 12

print_lines:
    lodsd                   ; Load the next line address into EAX

    push ebp
    push esi
    push eax

    call print_string

    add esp, 4
    pop esi
    pop ebp

    dec ebp
    jnz print_lines

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80


; -----------------------------------------
; print_string
; Input: EAX = address of null-terminated string
; -----------------------------------------
print_string:

    push ebx
    push ecx
    push edx
    push edi

    mov edi, eax
    xor edx, edx

find_length:
    cmp byte [edi + edx], 0
    je write_string

    inc edx
    jmp find_length

write_string:
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, edi
    int 0x80

    pop edi
    pop edx
    pop ecx
    pop ebx

    ret


; -----------------------------------------
; print_repeat
; AL  = character to print
; ECX = number of repetitions
; -----------------------------------------
print_repeat:

    push eax
    push ebx
    push ecx
    push edx
    push edi

    mov [repeat_char], al
    mov edi, ecx

repeat_loop:
    cmp edi, 0
    je repeat_done

    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, repeat_char
    mov edx, 1
    int 0x80

    dec edi
    jmp repeat_loop

repeat_done:
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret