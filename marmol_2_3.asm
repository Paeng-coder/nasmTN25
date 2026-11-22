; Activity 2.3: Swap two word values using indirect addressing

section .data
    VAL_A dw 111
    VAL_B dw 222
    message db "The values were swapped.", 10
    message_len equ $ - message

    label_a db "VAL_A: "
    label_a_len equ $ - label_a
    label_b db "VAL_B: "
    label_b_len equ $ - label_b
    newline db 10

section .bss
    digits_a resb 3
    digits_b resb 3

section .text
    global _start

_start:
    ; Five valid MOV forms:
    ; MOV register, register
    ; MOV register, immediate
    ; MOV register, memory
    ; MOV memory, register
    ; MOV memory, immediate
    ; Memory-to-memory MOV is invalid; use an intermediate register.

    ; Put the variable addresses in registers
    mov ebx, VAL_A
    mov esi, VAL_B

    ; Swap the values using register-mediated indirect MOV instructions
    mov ax, [ebx]
    mov dx, [esi]
    mov [ebx], dx
    mov [esi], ax

    ; Convert VAL_A (now 222) to three ASCII digits
    movzx eax, word [VAL_A]
    mov ebx, 100
    xor edx, edx
    div ebx
    add al, '0'
    mov [digits_a], al

    movzx eax, word [VAL_A]
    xor edx, edx
    mov ebx, 100
    div ebx
    movzx eax, dx
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [digits_a + 1], al
    mov [digits_a + 2], dl

    ; Convert VAL_B (now 111) to three ASCII digits
    movzx eax, word [VAL_B]
    mov ebx, 100
    xor edx, edx
    div ebx
    add al, '0'
    mov [digits_b], al

    movzx eax, word [VAL_B]
    xor edx, edx
    mov ebx, 100
    div ebx
    movzx eax, dx
    mov ebx, 10
    xor edx, edx
    div ebx
    add al, '0'
    add dl, '0'
    mov [digits_b + 1], al
    mov [digits_b + 2], dl

    ; Display swap confirmation
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Display VAL_A
    mov eax, 4
    mov ebx, 1
    mov ecx, label_a
    mov edx, label_a_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, digits_a
    mov edx, 3
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Display VAL_B
    mov eax, 4
    mov ebx, 1
    mov ecx, label_b
    mov edx, label_b_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, digits_b
    mov edx, 3
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80