section .data
    prompt_name  db "Enter student name: ", 0
    prompt_id    db "Enter student ID: ", 0
    prompt_grade db "Enter grade: ", 0

    name_label   db "Student Name: ", 0
    id_label     db "Student ID: ", 0
    grade_label  db "Grade: ", 0
    class_label  db "Classification: ", 0

    excellent    db "Excellent", 0
    very_good    db "Very Good", 0
    good         db "Good", 0
    passed       db "Passed", 0
    failed       db "Failed", 0
    invalid_grade db "INVALID GRADE", 0

    newline      db 10

section .bss
    name_buf     resb 128
    id_buf       resb 64
    grade_buf    resb 32
    number_buf   resb 16

section .text
    global _start

_start:
    mov esi, prompt_name
    call print_zstr
    mov edi, name_buf
    call read_line

    mov esi, prompt_id
    call print_zstr
    mov edi, id_buf
    call read_line

    mov esi, prompt_grade
    call print_zstr
    mov edi, grade_buf
    call read_line

    mov esi, grade_buf
    call atoi_validate
    jc .invalid

    cmp eax, 100
    ja .invalid

    mov ebx, eax

    mov esi, name_label
    call print_zstr

    mov esi, name_buf
    call print_zstr
    call print_newline

    mov esi, id_label
    call print_zstr

    mov esi, id_buf
    call print_zstr
    call print_newline

    mov esi, grade_label
    call print_zstr

    mov eax, ebx
    call print_uint
    call print_newline

    mov esi, class_label
    call print_zstr

    cmp ebx, 90
    jae .excellent

    cmp ebx, 85
    jae .very_good

    cmp ebx, 80
    jae .good

    cmp ebx, 75
    jae .passed

    mov esi, failed
    jmp .show_class

.excellent:
    mov esi, excellent
    jmp .show_class

.very_good:
    mov esi, very_good
    jmp .show_class

.good:
    mov esi, good
    jmp .show_class

.passed:
    mov esi, passed

.show_class:
    call print_zstr
    call print_newline
    jmp exit_program

.invalid:
    mov esi, invalid_grade
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
    je .end

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

.end:
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