; tuition.asm
; Student Credentials and Tuition Fee Calculator
; Uses MACROS and PROCEDURES

%macro print_text 2
    mov ecx, %1
    mov edx, %2
    call print_proc
%endmacro

%macro print_value 1
    mov ecx, %1
    call print_string
%endmacro

section .data
    title db 10, "========================================", 10
          db "       STUDENT TUITION FEE SYSTEM", 10
          db "========================================", 10
    title_len equ $ - title

    status_msg db "Enrollment Status: "
    status_len equ $ - status_msg

    student_no_msg db "Student #: "
    student_no_len equ $ - student_no_msg

    name_msg db "Name: "
    name_len equ $ - name_msg

    phone_msg db "Phone: "
    phone_len equ $ - phone_msg

    zip_msg db "Zip Code: "
    zip_len equ $ - zip_msg

    college_msg db "College: "
    college_len equ $ - college_msg

    program_msg db "Program: "
    program_len equ $ - program_msg

    year_msg db "Year Level: "
    year_len equ $ - year_msg

    term_msg db "Term: "
    term_len equ $ - term_msg

    school_year_msg db "School Year: "
    school_year_len equ $ - school_year_msg

    address_msg db "Address: "
    address_len equ $ - address_msg

    units_msg db 10, "Enter total number of units: "
    units_len equ $ - units_msg

    rate_msg db "Enter tuition rate per unit: "
    rate_len equ $ - rate_msg

    misc_msg db "Enter miscellaneous fee: "
    misc_len equ $ - misc_msg

    id_msg db "Enter ID validation fee: "
    id_len equ $ - id_msg

    lab1_msg db "Enter ITE laboratory fee 1: "
    lab1_len equ $ - lab1_msg

    lab2_msg db "Enter ITE laboratory fee 2: "
    lab2_len equ $ - lab2_msg

    lab3_msg db "Enter ITE laboratory fee 3: "
    lab3_len equ $ - lab3_msg

    science_msg db "Enter science laboratory fee: "
    science_len equ $ - science_msg

    tuition_result db 10, "Tuition Fee: PHP "
    tuition_result_len equ $ - tuition_result

    misc_result db "Miscellaneous Fee: PHP "
    misc_result_len equ $ - misc_result

    id_result db "ID Validation Fee: PHP "
    id_result_len equ $ - id_result

    lab1_result db "ITE Laboratory Fee 1: PHP "
    lab1_result_len equ $ - lab1_result

    lab2_result db "ITE Laboratory Fee 2: PHP "
    lab2_result_len equ $ - lab2_result

    lab3_result db "ITE Laboratory Fee 3: PHP "
    lab3_result_len equ $ - lab3_result

    science_result db "Science Laboratory Fee: PHP "
    science_result_len equ $ - science_result

    total_result db "TOTAL ASSESSMENT: PHP "
    total_result_len equ $ - total_result

    newline db 10
    newline_len equ $ - newline

section .bss
    input_buffer resb 32
    output_buffer resb 16

    status resb 64
    student_no resb 64
    student_name resb 64
    phone resb 64
    zip_code resb 64
    college resb 64
    program resb 64
    year_level resb 64
    term resb 64
    school_year resb 64
    address resb 64

    units resd 1
    rate resd 1
    tuition resd 1
    misc_fee resd 1
    id_fee resd 1
    lab1_fee resd 1
    lab2_fee resd 1
    lab3_fee resd 1
    science_fee resd 1
    total_fee resd 1

section .text
    global _start

_start:
    print_text title, title_len

    ; Student credential inputs
    print_text status_msg, status_len
    mov ecx, status
    mov edx, 64
    call read_text

    print_text student_no_msg, student_no_len
    mov ecx, student_no
    mov edx, 64
    call read_text

    print_text name_msg, name_len
    mov ecx, student_name
    mov edx, 64
    call read_text

    print_text phone_msg, phone_len
    mov ecx, phone
    mov edx, 64
    call read_text

    print_text zip_msg, zip_len
    mov ecx, zip_code
    mov edx, 64
    call read_text

    print_text college_msg, college_len
    mov ecx, college
    mov edx, 64
    call read_text

    print_text program_msg, program_len
    mov ecx, program
    mov edx, 64
    call read_text

    print_text year_msg, year_len
    mov ecx, year_level
    mov edx, 64
    call read_text

    print_text term_msg, term_len
    mov ecx, term
    mov edx, 64
    call read_text

    print_text school_year_msg, school_year_len
    mov ecx, school_year
    mov edx, 64
    call read_text

    print_text address_msg, address_len
    mov ecx, address
    mov edx, 64
    call read_text

    ; Fee inputs
    print_text units_msg, units_len
    call read_number
    mov [units], eax

    print_text rate_msg, rate_len
    call read_number
    mov [rate], eax

    print_text misc_msg, misc_len
    call read_number
    mov [misc_fee], eax

    print_text id_msg, id_len
    call read_number
    mov [id_fee], eax

    print_text lab1_msg, lab1_len
    call read_number
    mov [lab1_fee], eax

    print_text lab2_msg, lab2_len
    call read_number
    mov [lab2_fee], eax

    print_text lab3_msg, lab3_len
    call read_number
    mov [lab3_fee], eax

    print_text science_msg, science_len
    call read_number
    mov [science_fee], eax

    call calculate_fees

    ; Display student information
    print_text title, title_len

    print_text status_msg, status_len
    print_value status
    print_text newline, newline_len

    print_text student_no_msg, student_no_len
    print_value student_no
    print_text newline, newline_len

    print_text name_msg, name_len
    print_value student_name
    print_text newline, newline_len

    print_text phone_msg, phone_len
    print_value phone
    print_text newline, newline_len

    print_text zip_msg, zip_len
    print_value zip_code
    print_text newline, newline_len

    print_text college_msg, college_len
    print_value college
    print_text newline, newline_len

    print_text program_msg, program_len
    print_value program
    print_text newline, newline_len

    print_text year_msg, year_len
    print_value year_level
    print_text newline, newline_len

    print_text term_msg, term_len
    print_value term
    print_text newline, newline_len

    print_text school_year_msg, school_year_len
    print_value school_year
    print_text newline, newline_len

    print_text address_msg, address_len
    print_value address
    print_text newline, newline_len

    ; Display fees
    print_text tuition_result, tuition_result_len
    mov eax, [tuition]
    call print_number
    print_text newline, newline_len

    print_text misc_result, misc_result_len
    mov eax, [misc_fee]
    call print_number
    print_text newline, newline_len

    print_text id_result, id_result_len
    mov eax, [id_fee]
    call print_number
    print_text newline, newline_len

    print_text lab1_result, lab1_result_len
    mov eax, [lab1_fee]
    call print_number
    print_text newline, newline_len

    print_text lab2_result, lab2_result_len
    mov eax, [lab2_fee]
    call print_number
    print_text newline, newline_len

    print_text lab3_result, lab3_result_len
    mov eax, [lab3_fee]
    call print_number
    print_text newline, newline_len

    print_text science_result, science_result_len
    mov eax, [science_fee]
    call print_number
    print_text newline, newline_len

    print_text total_result, total_result_len
    mov eax, [total_fee]
    call print_number
    print_text newline, newline_len

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80


; --------------------------------
; Procedure: print_proc
; --------------------------------
print_proc:
    push eax
    push ebx

    mov eax, 4
    mov ebx, 1
    int 0x80

    pop ebx
    pop eax
    ret


; --------------------------------
; Procedure: read_text
; --------------------------------
read_text:
    push eax
    push ebx
    push edx
    push esi

    mov eax, 3
    mov ebx, 0
    int 0x80

    mov esi, ecx
    xor edx, edx

.find_enter:
    cmp edx, eax
    jge .finish

    cmp byte [esi + edx], 10
    je .remove_enter

    inc edx
    jmp .find_enter

.remove_enter:
    mov byte [esi + edx], 0

.finish:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret


; --------------------------------
; Procedure: print_string
; --------------------------------
print_string:
    push eax
    push ebx
    push edx

    xor edx, edx

.count:
    cmp byte [ecx + edx], 0
    je .display

    inc edx
    jmp .count

.display:
    call print_proc

    pop edx
    pop ebx
    pop eax
    ret


; --------------------------------
; Procedure: read_number
; --------------------------------
read_number:
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 32
    int 0x80

    xor eax, eax
    xor ecx, ecx

.convert:
    xor ebx, ebx
    mov bl, [input_buffer + ecx]

    cmp bl, 10
    je .done

    cmp bl, 0
    je .done

    sub bl, '0'
    imul eax, 10
    add eax, ebx

    inc ecx
    jmp .convert

.done:
    ret


; --------------------------------
; Procedure: calculate_fees
; --------------------------------
calculate_fees:
    ; Tuition = Units × Rate
    mov eax, [units]
    mov ebx, [rate]
    imul eax, ebx
    mov [tuition], eax

    ; Total Assessment
    add eax, [misc_fee]
    add eax, [id_fee]
    add eax, [lab1_fee]
    add eax, [lab2_fee]
    add eax, [lab3_fee]
    add eax, [science_fee]
    mov [total_fee], eax

    ret


; --------------------------------
; Procedure: print_number
; --------------------------------
print_number:
    mov edi, output_buffer
    add edi, 15
    mov byte [edi], 0

    cmp eax, 0
    jne .convert_number

    dec edi
    mov byte [edi], '0'
    jmp .display

.convert_number:
    xor edx, edx
    mov ebx, 10
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    cmp eax, 0
    jne .convert_number

.display:
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, output_buffer
    add edx, 15
    sub edx, edi
    int 0x80
    ret