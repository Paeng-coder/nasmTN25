section .data
    prompt_name     db "What is your name? ", 0
    prompt_age      db "How old are you? ", 0
    prompt_year     db "What is your year level? ", 0

    hello           db "Hello ", 0
    age_text        db "You are ", 0
    years_text      db " years old", 0

    freshman        db "Freshman", 0
    sophomore       db "Sophomore", 0
    junior          db "Junior", 0
    senior          db "Senior", 0
    invalid_year    db "INVALID YEAR LEVEL", 0
    invalid_age     db "INVALID AGE", 0

    newline         db 10

section .bss
    name_buf        resb 128
    age_buf         resb 32
    year_buf        resb 32
    number_buf      resb 16

section .text
    global _start

_start:
    ; Read the student's name
    mov esi, prompt_name
    call print_zstr

    mov edi, name_buf
    call read_line

    ; Read and validate age
    mov esi, prompt_age
    call print_zstr

    mov edi, age_buf
    call read_line

    mov esi, age_buf
    call atoi_validate
    jc invalid_age_message

    mov ebx, eax

    ; Read and validate year level
    mov esi, prompt_year
    call print_zstr

    mov edi, year_buf
    call read_line

    mov esi, year_buf
    call atoi_validate
    jc invalid_year_message

    ; Accept only 1, 2, 3, or 4
    cmp eax, 1
    je show_freshman

    cmp eax, 2
    je show_sophomore

    cmp eax, 3
    je show_junior

    cmp eax, 4
    je show_senior

    ; Any other number is invalid
    jmp invalid_year_message

show_freshman:
    mov esi, freshman
    jmp display_student

show_sophomore:
    mov esi, sophomore
    jmp display_student

show_junior:
    mov esi, junior
    jmp display_student

show_senior:
    mov esi, senior

display_student:
    push esi

    mov esi, hello
    call print_zstr

    mov esi, name_buf
    call print_zstr
    call print_newline

    mov esi, age_text
    call print_zstr

    mov eax, ebx
    call print_uint

    mov esi, years_text
    call print_zstr
    call print_newline

    pop esi
    call print_zstr
    call print_newline

    jmp exit_program

invalid_age_message:
    mov esi, invalid_age
    call print_zstr
    call print_newline
    jmp exit_program

invalid_year_message:
    mov esi, invalid_year
    call print_zstr
    call print_newline
    jmp exit_program

; Reads input and removes the Enter key
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

; Converts ASCII digits into an integer
; Carry Flag = 1 if input is invalid
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

; Displays a null-terminated string
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

; Displays an unsigned integer
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