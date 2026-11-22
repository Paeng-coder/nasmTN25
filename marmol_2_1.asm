section .bss
    input_buffer resb 64

section .data
    prompt db "Enter your name: "
    prompt_len equ $ - prompt
    result db "You entered: "
    result_len equ $ - result

section .text
    global _start

_start:
    ; Display the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read from standard input into the buffer
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 64
    int 0x80
    mov esi, eax              ; Save number of bytes read

    ; Display the confirmation message
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, result_len
    int 0x80

    ; Echo the input, including the Enter key's newline
    mov eax, 4
    mov ebx, 1
    mov ecx, input_buffer
    mov edx, esi
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80