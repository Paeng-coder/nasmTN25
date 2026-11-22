; Activity 2.2: Type specifiers and direct-offset addressing

section .data
    SCORES db 88, 91, 75, 100, 82

    message db "A score was loaded from the table.", 10
    message_len equ $ - message

    score_label db "Score at index 2: "
    score_label_len equ $ - score_label

    newline db 10

section .bss
    test_value resb 1
    score_digits resb 2

section .text
    global _start

_start:
    ; Direct-offset addressing: load the third byte, 75
    mov al, [SCORES + 2]

    ; Direct-offset addressing: load the fifth byte, 82
    mov bl, [SCORES + 4]

    ; BYTE specifies the size of the memory destination
    mov byte [test_value], 95

    ; Load the third table value into EAX
    movzx eax, byte [SCORES + 2]

    ; Convert 75 into two ASCII digits
    xor edx, edx
    mov ebx, 10
    div ebx                 ; EAX = 7, EDX = 5
    add al, '0'
    add dl, '0'
    mov [score_digits], al
    mov [score_digits + 1], dl

    ; Display confirmation message
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Display score label
    mov eax, 4
    mov ebx, 1
    mov ecx, score_label
    mov edx, score_label_len
    int 0x80

    ; Display the score digits
    mov eax, 4
    mov ebx, 1
    mov ecx, score_digits
    mov edx, 2
    int 0x80

    ; Display newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80