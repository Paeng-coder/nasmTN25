; FLAB4.asm
; Georgette Eatery Food Ordering System
; NASM 32-bit Linux

%macro PRINT 2
    mov ecx, %1
    mov edx, %2
    call print_string
%endmacro

section .data

menu db 10
     db "+------------------------------------------+", 10
     db "|           Georgette EATERY              |", 10
     db "+------------------------------------------+", 10
     db "| A. Rice  : Plain Rice       Php 5.00     |", 10
     db "| B. Rice  : Java Rice        Php 10.00    |", 10
     db "| C. Ulam 1: (Fish)           Php 35.00    |", 10
     db "| D. Ulam 2: (Pork)           Php 50.00    |", 10
     db "| E. Ulam 3: (Vegetables)     Php 20.00    |", 10
     db "| F. Dessert: Saging con yelo Php 60.00    |", 10
     db "+------------------------------------------+", 10
menu_len equ $ - menu

order_prompt db "Enter your order: "
order_prompt_len equ $ - order_prompt

ordered_msg db "You ordered "
ordered_msg_len equ $ - ordered_msg

price_text db ": Php "
price_text_len equ $ - price_text

again_prompt db "Do you want to order again? [Y/N]: "
again_prompt_len equ $ - again_prompt

invalid_choice db 10, "Invalid choice. Please choose A-F.", 10
invalid_choice_len equ $ - invalid_choice

invalid_again db 10, "Please enter Y or N.", 10
invalid_again_len equ $ - invalid_again

thank_you db 10, "Thank you! Please come again!", 10
thank_you_len equ $ - thank_you

receipt_screen db 10, "========== RECEIPT ==========", 10
receipt_screen_len equ $ - receipt_screen

receipt_header db "Receipt", 10
receipt_header_len equ $ - receipt_header

newline db 10
newline_len equ $ - newline

closing_message db 10
                db "Thank you for choosing Georgette Eatery!", 10
                db "Have a wonderful day!", 10
closing_message_len equ $ - closing_message

receipt_file db "receipt.txt", 0

file_error db 10, "Error: receipt.txt could not be opened.", 10
file_error_len equ $ - file_error

plain_rice db "Plain Rice"
plain_rice_len equ $ - plain_rice
plain_rice_price db "5.00"
plain_rice_price_len equ $ - plain_rice_price

java_rice db "Java Rice"
java_rice_len equ $ - java_rice
java_rice_price db "10.00"
java_rice_price_len equ $ - java_rice_price

fish db "Fish"
fish_len equ $ - fish
fish_price db "35.00"
fish_price_len equ $ - fish_price

pork db "Pork"
pork_len equ $ - pork
pork_price db "50.00"
pork_price_len equ $ - pork_price

vegetables db "Vegetables"
vegetables_len equ $ - vegetables
vegetables_price db "20.00"
vegetables_price_len equ $ - vegetables_price

dessert db "Saging con yelo"
dessert_len equ $ - dessert
dessert_price db "60.00"
dessert_price_len equ $ - dessert_price

section .bss

input_buffer resb 32
receipt_fd resd 1

item_pointer resd 1
item_length resd 1
price_pointer resd 1
price_length resd 1

section .text
global _start

_start:

    ; Open receipt.txt for reading and writing
    ; 0x242 = O_RDWR | O_CREAT | O_TRUNC
    mov eax, 5
    mov ebx, receipt_file
    mov ecx, 0x242
    mov edx, 0666
    int 0x80

    ; Check if file opening failed
    test eax, eax
    js receipt_error

    mov [receipt_fd], eax

    ; Write receipt heading
    mov ebx, [receipt_fd]
    mov ecx, receipt_header
    mov edx, receipt_header_len
    call write_file


menu_loop:

    call display_menu

    PRINT order_prompt, order_prompt_len
    call read_input
    and al, 0DFh

    cmp al, 'A'
    je choose_plain_rice

    cmp al, 'B'
    je choose_java_rice

    cmp al, 'C'
    je choose_fish

    cmp al, 'D'
    je choose_pork

    cmp al, 'E'
    je choose_vegetables

    cmp al, 'F'
    je choose_dessert

    PRINT invalid_choice, invalid_choice_len
    jmp menu_loop


choose_plain_rice:

    mov dword [item_pointer], plain_rice
    mov dword [item_length], plain_rice_len
    mov dword [price_pointer], plain_rice_price
    mov dword [price_length], plain_rice_price_len
    call process_order
    jmp ask_again


choose_java_rice:

    mov dword [item_pointer], java_rice
    mov dword [item_length], java_rice_len
    mov dword [price_pointer], java_rice_price
    mov dword [price_length], java_rice_price_len
    call process_order
    jmp ask_again


choose_fish:

    mov dword [item_pointer], fish
    mov dword [item_length], fish_len
    mov dword [price_pointer], fish_price
    mov dword [price_length], fish_price_len
    call process_order
    jmp ask_again


choose_pork:

    mov dword [item_pointer], pork
    mov dword [item_length], pork_len
    mov dword [price_pointer], pork_price
    mov dword [price_length], pork_price_len
    call process_order
    jmp ask_again


choose_vegetables:

    mov dword [item_pointer], vegetables
    mov dword [item_length], vegetables_len
    mov dword [price_pointer], vegetables_price
    mov dword [price_length], vegetables_price_len
    call process_order
    jmp ask_again


choose_dessert:

    mov dword [item_pointer], dessert
    mov dword [item_length], dessert_len
    mov dword [price_pointer], dessert_price
    mov dword [price_length], dessert_price_len
    call process_order
    jmp ask_again


ask_again:

    PRINT again_prompt, again_prompt_len
    call read_input
    and al, 0DFh

    cmp al, 'Y'
    je menu_loop

    cmp al, 'N'
    je end_order

    PRINT invalid_again, invalid_again_len
    jmp ask_again


end_order:

    PRINT thank_you, thank_you_len

    ; Move file position back to the beginning
    ; sys_lseek = 19
    mov eax, 19
    mov ebx, [receipt_fd]
    xor ecx, ecx
    xor edx, edx
    int 0x80

    ; Display receipt heading
    PRINT receipt_screen, receipt_screen_len


display_receipt:

    ; Read receipt.txt
    mov eax, 3
    mov ebx, [receipt_fd]
    mov ecx, input_buffer
    mov edx, 32
    int 0x80

    cmp eax, 0
    jle close_receipt

    ; Display receipt contents
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, input_buffer
    int 0x80

    jmp display_receipt


close_receipt:

    ; Close receipt file
    mov eax, 6
    mov ebx, [receipt_fd]
    int 0x80

    ; Display closing message
    PRINT closing_message, closing_message_len

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80


receipt_error:

    PRINT file_error, file_error_len

    mov eax, 1
    mov ebx, 1
    int 0x80


; ---------------------------------
; Display menu procedure
; ---------------------------------
display_menu:

    PRINT menu, menu_len
    ret


; ---------------------------------
; Read input procedure
; ---------------------------------
read_input:

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 32
    int 0x80

    mov al, [input_buffer]
    ret


; ---------------------------------
; Print string procedure
; ---------------------------------
print_string:

    mov eax, 4
    mov ebx, 1
    int 0x80
    ret


; ---------------------------------
; Write file procedure
; ---------------------------------
write_file:

    mov eax, 4
    int 0x80
    ret


; ---------------------------------
; Process order procedure
; ---------------------------------
process_order:

    ; Display selected item
    PRINT ordered_msg, ordered_msg_len

    mov ecx, [item_pointer]
    mov edx, [item_length]
    call print_string

    PRINT price_text, price_text_len

    mov ecx, [price_pointer]
    mov edx, [price_length]
    call print_string

    PRINT newline, newline_len

    ; Write item to receipt
    mov ebx, [receipt_fd]
    mov ecx, [item_pointer]
    mov edx, [item_length]
    call write_file

    ; Write price label
    mov ebx, [receipt_fd]
    mov ecx, price_text
    mov edx, price_text_len
    call write_file

    ; Write price
    mov ebx, [receipt_fd]
    mov ecx, [price_pointer]
    mov edx, [price_length]
    call write_file

    ; Write newline
    mov ebx, [receipt_fd]
    mov ecx, newline
    mov edx, newline_len
    call write_file

    ret