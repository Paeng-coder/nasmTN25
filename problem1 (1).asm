section .data
    prompt_name     db "What is your name? ", 0
    prompt_age      db "How old are you? ", 0
    prompt_gender   db "What is your gender? ", 0
    hello           db "Hello ", 0
    world_text      db "World", 0
    age_text        db "You are ", 0
    years_text      db " years old", 0
    invalid_age     db "INVALID AGE", 0
    invalid_gender  db "INVALID", 0
    newline         db 10

section .bss
    name_buf        resb 128
    age_buf         resb 32
    gender_buf      resb 32
    number_buf      resb 16

section .text
    global _start

_start:
    mov esi, prompt_name
    call print_zstr
    mov edi, name_buf
    call read_line

    mov esi, prompt_age
    call print_zstr
    mov edi, age_buf
    call read_line

    mov esi, age_buf
    call atoi_validate
    jc .bad_age
    mov ebx, eax

    mov esi, prompt_gender
    call print_zstr
    mov edi, gender_buf
    call read_line

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

    mov al, [gender_buf]
    or al, 20h

    cmp al, 'm'
    je .male

    cmp al, 'f'
    je .female

    mov esi, invalid_gender
    call print_zstr
    jmp .finish

.male:
    mov esi, hello
    call print_zstr
    jmp .finish

.female:
    mov esi, world_text
    call print_zstr

.finish:
    call print_newline
    jmp exit_program

.bad_age:
    mov esi, invalid_age
    call print_zstr
    call print_newline
    jmp exit_program

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

.scan:
    cmp eax, ecx
    jae .done

    mov dl, [edi + eax]

    cmp dl, 10
    je .cut

    cmp dl, 13
    je .cut

    inc eax
    jmp .scan

.cut:
    mov byte [edi + eax], 0

.done:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

atoi_validate:
    push ebx
    push ecx

    xor eax, eax
    xor ecx, ecx

.digits:
    mov bl, [esi + ecx]

    cmp bl, 0
    je .end_digits

    cmp bl, '0'
    jb .invalid

    cmp bl, '9'
    ja .invalid

    imul eax, eax, 10
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx

    inc ecx
    jmp .digits

.end_digits:
    test ecx, ecx
    jz .invalid

    clc
    pop ecx
    pop ebx
    ret

.invalid:
    stc
    pop ecx
    pop ebx
    ret

print_zstr:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, esi
    xor edx, edx

.length:
    cmp byte [ecx + edx], 0
    je .write

    inc edx
    jmp .length

.write:
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

print_uint:
    push eax
    push ebx
    push ecx
    push edx

    mov edi, number_buf + 15
    mov byte [edi], 0
    mov ebx, 10

    test eax, eax
    jnz .convert

    dec edi
    mov byte [edi], '0'
    jmp .show

.convert:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

.show:
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