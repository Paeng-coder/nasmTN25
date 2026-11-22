section .data
    numbers db 1, 2, 3, 4, 5
    message db "Array sum: "
    message_len equ $ - message

section .bss
    total resb 1
    output_char resb 1

section .text
    global _start

_start:
    xor eax, eax              ; EAX accumulates the sum
    xor esi, esi              ; ESI is the array index

sum_loop:
    ; Indexed addressing: read numbers[ESI]
    movzx ebx, byte [numbers + esi]
    add eax, ebx
    inc esi
    cmp esi, 5
    jl sum_loop

    ; Store the final sum in the reserved byte
    mov [total], al

    ; The sum is 15; convert it to two ASCII digits.
    movzx eax, byte [total]
    mov ebx, 10
    xor edx, edx
    div ebx                   ; AL quotient (1), DL remainder (5)

    add al, '0'
    add dl, '0'
    mov [output_char], al
    mov [output_char + 1], dl

    ; Display the label
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Display the tens digit
    mov eax, 4
    mov ebx, 1
    mov ecx, output_char
    mov edx, 1
    int 0x80

    ; Display the ones digit and newline
    mov byte [output_char + 1], '5'
    mov byte [output_char + 2], 10
    mov eax, 4
    mov ebx, 1
    mov ecx, output_char + 1
    mov edx, 2
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80