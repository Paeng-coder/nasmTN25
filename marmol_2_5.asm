%define BUFFER_SIZE 2

section .data
    ; EQU defines a fixed message length.
    prompt db "Enter one character: "
    prompt_len equ $ - prompt

    result db "You entered: "
    result_len equ $ - result

    newline db 10

section .bss
    input_buffer resb BUFFER_SIZE

section .text
    global _start

_start:
    ; Display the initial prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read a character and the Enter newline.
    ; BUFFER_SIZE is defined above and reused here.
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, BUFFER_SIZE
    int 0x80

    ; Inspect the first character using direct addressing.
    mov al, [input_buffer]

    ; Display the result label
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, result_len
    int 0x80

    ; Display the character that was read
    mov eax, 4
    mov ebx, 1
    mov ecx, input_buffer
    mov edx, 1
    int 0x80

    ; Display a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80