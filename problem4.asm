section .data
    prompt_name     db "Enter account name: ", 0
    prompt_pin      db "Enter PIN: ", 0
    prompt_amount   db "Enter withdrawal amount: ", 0

    access_granted  db "ACCESS GRANTED", 0
    access_denied   db "ACCESS DENIED", 0

    balance_text    db "Current Balance: PHP ", 0
    withdrawn_text  db "Amount Withdrawn: PHP ", 0
    remaining_text  db "Remaining Balance: PHP ", 0

    success_text    db "WITHDRAWAL SUCCESSFUL", 0
    invalid_amount  db "INVALID AMOUNT", 0
    insufficient     db "INSUFFICIENT FUNDS", 0
    multiple_error  db "AMOUNT MUST BE A MULTIPLE OF 100", 0

    newline         db 10

section .bss
    account_buf     resb 128
    pin_buf         resb 32
    amount_buf      resb 32
    number_buf      resb 16

section .text
    global _start

_start:
    ; Starting balance is PHP 10000
    mov ebp, 10000

    ; Ask for account name
    mov esi, prompt_name
    call print_zstr

    mov edi, account_buf
    call read_line

    ; Ask for PIN
    mov esi, prompt_pin
    call print_zstr

    mov edi, pin_buf
    call read_line

    ; Convert PIN from ASCII to integer
    mov esi, pin_buf
    call atoi_validate
    jc access_denied_message

    ; Compare entered PIN with 1234
    cmp eax, 1234
    jne access_denied_message

    ; Correct PIN
    mov esi, access_granted
    call print_zstr
    call print_newline

    ; Display current balance
    mov esi, balance_text
    call print_zstr

    mov eax, ebp
    call print_uint
    call print_newline

    ; Ask for withdrawal amount
    mov esi, prompt_amount
    call print_zstr

    mov edi, amount_buf
    call read_line

    ; Convert amount from ASCII to integer
    mov esi, amount_buf
    call atoi_validate
    jc invalid_amount_message

    ; Save withdrawal amount
    mov ebx, eax

    ; Amount must be greater than zero
    cmp ebx, 0
    jle invalid_amount_message

    ; Amount must not exceed balance
    cmp ebx, ebp
    ja insufficient_funds_message

    ; Check if amount is divisible by 100
    mov eax, ebx
    xor edx, edx
    mov ecx, 100
    div ecx

    ; Remainder must be zero
    cmp edx, 0
    jne multiple_error_message

    ; Deduct amount from balance
    sub ebp, ebx

    ; Display successful withdrawal
    mov esi, success_text
    call print_zstr
    call print_newline

    ; Display amount withdrawn
    mov esi, withdrawn_text
    call print_zstr

    mov eax, ebx
    call print_uint
    call print_newline

    ; Display remaining balance
    mov esi, remaining_text
    call print_zstr

    mov eax, ebp
    call print_uint
    call print_newline

    jmp exit_program

access_denied_message:
    mov esi, access_denied
    call print_zstr
    call print_newline
    jmp exit_program

invalid_amount_message:
    mov esi, invalid_amount
    call print_zstr
    call print_newline
    jmp exit_program

insufficient_funds_message:
    mov esi, insufficient
    call print_zstr
    call print_newline
    jmp exit_program

multiple_error_message:
    mov esi, multiple_error
    call print_zstr
    call print_newline
    jmp exit_program

; Reads a line from the keyboard.
; EDI contains the address of the input buffer.
; Removes the Enter key line ending.
read_line:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 3
    xor ebx, ebx
    mov ecx, edi
    mov edx, 127
    int 80h

    mov ecx, eax
    mov byte [edi + ecx], 0

    xor eax, eax

remove_line_ending:
    cmp eax, ecx
    jae finish_read

    mov dl, [edi + eax]

    cmp dl, 10
    je cut_line

    cmp dl, 13
    je cut_line

    inc eax
    jmp remove_line_ending

cut_line:
    mov byte [edi + eax], 0

finish_read:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Converts an ASCII decimal string into an integer.
; Carry Flag = 1 if the input is invalid.
atoi_validate:
    push ebx
    push ecx

    xor eax, eax
    xor ecx, ecx

convert_digit:
    mov bl, [esi + ecx]

    cmp bl, 0
    je conversion_finished

    cmp bl, '0'
    jb invalid_number

    cmp bl, '9'
    ja invalid_number

    imul eax, eax, 10
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx

    inc ecx
    jmp convert_digit

conversion_finished:
    test ecx, ecx
    jz invalid_number

    clc
    pop ecx
    pop ebx
    ret

invalid_number:
    stc
    pop ecx
    pop ebx
    ret

; Displays a null-terminated string.
print_zstr:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, esi
    xor edx, edx

find_length:
    cmp byte [ecx + edx], 0
    je write_string

    inc edx
    jmp find_length

write_string:
    mov eax, 4
    mov ebx, 1
    int 80h

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

print_newline:
    push esi
    mov esi, newline
    call print_zstr
    pop esi
    ret

; Displays an unsigned integer.
print_uint:
    push eax
    push ebx
    push ecx
    push edx

    mov edi, number_buf + 15
    mov byte [edi], 0
    mov ebx, 10

    test eax, eax
    jnz convert_integer

    dec edi
    mov byte [edi], '0'
    jmp display_integer

convert_integer:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz convert_integer

display_integer:
    mov esi, edi
    call print_zstr

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 80h