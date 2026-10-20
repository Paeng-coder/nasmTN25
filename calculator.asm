
;   nasm -f elf32 calculator.asm -o calculator.o
;   ld -m elf_i386 calculator.o -o calculator
;   ./calculator

section .data
    menu        db '----------------------------------', 10
                db 'MENU', 10
                db '[A]dd', 10
                db '[S]ubtract', 10
                db '[M]ultiply', 10
                db '[D]ivide', 10
                db '----------------------------------', 10
    menu_len    equ $ - menu

    choice_msg  db 'Enter your choice: '
    choice_len  equ $ - choice_msg
    first_msg   db 'Enter first number: '
    first_len   equ $ - first_msg
    second_msg  db 'Enter second number: '
    second_len  equ $ - second_msg
    again_msg   db 10, 'Do you want to try again (Y/N): '
    again_len   equ $ - again_msg

    sum_msg     db 'The sum is '
    sum_len     equ $ - sum_msg
    diff_msg    db 'The difference is '
    diff_len    equ $ - diff_msg
    product_msg db 'The product is '
    product_len equ $ - product_msg
    quotient_msg db 'The quotient is '
    quotient_len equ $ - quotient_msg
    remainder_msg db 'The remainder is '
    remainder_len equ $ - remainder_msg

    divzero_msg db 'Error: cannot divide by zero.', 10
    divzero_len equ $ - divzero_msg
    invalid_msg db 'Invalid choice. Select A, S, M, or D.', 10
    invalid_len equ $ - invalid_msg
    input_err   db 'Invalid number. Enter a whole number from -32768 to 32767.', 10
    input_err_len equ $ - input_err

    clear_codes db 27, '[2J', 27, '[H'
    clear_codes_len equ $ - clear_codes

section .bss
    input_buf   resb 64
    choice_buf  resb 64
    again_buf   resb 64
    num1        resd 1
    num2        resd 1
    result      resd 1
    out_buf     resb 16

section .text
    global _start

_start:

menu_loop:
    call clear_screen

    mov ecx, menu
    mov edx, menu_len
    call print

    mov ecx, choice_msg
    mov edx, choice_len
    call print

    mov edi, choice_buf
    call read_line
    cmp eax, 0
    jle exit_program

    mov al, [choice_buf]
    call uppercase_al

    cmp al, 'A'
    je do_add
    cmp al, 'S'
    je do_subtract
    cmp al, 'M'
    je do_multiply
    cmp al, 'D'
    je do_divide

    mov ecx, invalid_msg
    mov edx, invalid_len
    call print
    jmp ask_again

do_add:
    call get_two_numbers
    jc ask_again

    mov eax, [num1]
    add eax, [num2]
    mov [result], eax

    mov ecx, sum_msg
    mov edx, sum_len
    call print
    call print_result
    jmp ask_again

do_subtract:
    call get_two_numbers
    jc ask_again

    mov eax, [num1]
    sub eax, [num2]
    mov [result], eax

    mov ecx, diff_msg
    mov edx, diff_len
    call print
    call print_result
    jmp ask_again

do_multiply:
    call get_two_numbers
    jc ask_again

    mov eax, [num1]
    imul eax, dword [num2]
    mov [result], eax

    mov ecx, product_msg
    mov edx, product_len
    call print
    call print_result
    jmp ask_again

do_divide:
    call get_two_numbers
    jc ask_again

    cmp dword [num2], 0
    je division_by_zero

    mov eax, [num1]
    cdq
    idiv dword [num2]
    mov [result], eax
    push edx                    ; Save remainder while printing quotient

    mov ecx, quotient_msg
    mov edx, quotient_len
    call print
    call print_result

    pop eax                     ; Restore remainder
    mov [result], eax

    mov ecx, remainder_msg
    mov edx, remainder_len
    call print
    call print_result
    jmp ask_again

division_by_zero:
    mov ecx, divzero_msg
    mov edx, divzero_len
    call print
    jmp ask_again

ask_again:
    mov ecx, again_msg
    mov edx, again_len
    call print

    mov edi, again_buf
    call read_line
    cmp eax, 0
    jle exit_program

    mov al, [again_buf]
    call uppercase_al
    cmp al, 'Y'
    je menu_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Reads two signed whole numbers.
; Carry flag is set if either input is invalid.
get_two_numbers:
    mov ecx, first_msg
    mov edx, first_len
    call print

    mov edi, input_buf
    call read_line
    mov esi, input_buf
    call parse_integer
    jc bad_integer
    mov [num1], eax

    mov ecx, second_msg
    mov edx, second_len
    call print

    mov edi, input_buf
    call read_line
    mov esi, input_buf
    call parse_integer
    jc bad_integer
    mov [num2], eax

    clc
    ret

bad_integer:
    mov ecx, input_err
    mov edx, input_err_len
    call print
    stc
    ret

; Prints ECX bytes from address ECX.
; EDX contains the byte count.
print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

; Reads a line into the buffer pointed to by EDI.
read_line:
    mov eax, 3
    mov ebx, 0
    mov ecx, edi
    mov edx, 63
    int 0x80

    test eax, eax
    jle .done

    mov byte [edi + eax], 0
    xor esi, esi

.find_lf:
    cmp esi, eax
    jae .done

    cmp byte [edi + esi], 10
    je .terminate

    inc esi
    jmp .find_lf

.terminate:
    mov byte [edi + esi], 0

.done:
    ret

; Converts a signed decimal string at ESI into EAX.
; Sets carry flag if the input is invalid or out of range.
parse_integer:
    xor eax, eax
    xor ebx, ebx                ; BL = 1 when negative
    xor ecx, ecx                ; digit count

    mov dl, [esi]
    cmp dl, '-'
    jne .check_plus
    mov bl, 1
    inc esi
    jmp .digits

.check_plus:
    cmp dl, '+'
    jne .digits
    inc esi

.digits:
    mov dl, [esi]
    test dl, dl
    jz .finish

    cmp dl, '0'
    jb .invalid
    cmp dl, '9'
    ja .invalid

    imul eax, eax, 10
    movzx edx, dl
    sub edx, '0'
    add eax, edx

    inc ecx
    inc esi
    jmp .digits

.finish:
    test ecx, ecx
    jz .invalid

    test bl, bl
    jz .range
    neg eax

.range:
    cmp eax, 32767
    jg .invalid
    cmp eax, -32768
    jl .invalid

    clc
    ret

.invalid:
    stc
    ret

; Prints the signed integer stored in [result], followed by a newline.
print_result:
    mov eax, [result]
    mov edi, out_buf + 15
    mov byte [edi], 10
    dec edi

    xor esi, esi                ; Negative flag
    test eax, eax
    jge .convert

    mov esi, 1
    neg eax

.convert:
    mov ebx, 10

.convert_digit:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert_digit

    test esi, esi
    jz .write

    mov byte [edi], '-'
    dec edi

.write:
    lea ecx, [edi + 1]
    lea edx, [out_buf + 16]
    sub edx, ecx
    call print
    ret

; Converts lowercase ASCII letters in AL to uppercase.
uppercase_al:
    cmp al, 'a'
    jb .done
    cmp al, 'z'
    ja .done
    sub al, 32

.done:
    ret

clear_screen:
    mov ecx, clear_codes
    mov edx, clear_codes_len
    call print
    ret