; ==========================================
; Simple Umbrella ASCII Art
; NASM 32-bit Linux
; ==========================================

section .data

    title db "Simple Umbrella - NASM32", 10
    titleLen equ $ - title

    top1 db "        *        ", 10
    top1Len equ $ - top1

    top2 db "      *****      ", 10
    top2Len equ $ - top2

    top3 db "    *********    ", 10
    top3Len equ $ - top3

    top4 db "  *************  ", 10
    top4Len equ $ - top4

    top5 db "*****************", 10
    top5Len equ $ - top5

    edge db "\   /   \   /   \", 10
    edgeLen equ $ - edge

    newline db 10

    handleChar db "|"
    spaceChar db " "
    curve db "        \___", 10
    curveLen equ $ - curve

section .text

    global _start

_start:

    ; -------------------------------
    ; Print program title
    ; -------------------------------
    mov ecx, title
    mov edx, titleLen
    call printString


    ; -------------------------------
    ; Print umbrella top
    ; -------------------------------
    mov ecx, top1
    mov edx, top1Len
    call printString

    mov ecx, top2
    mov edx, top2Len
    call printString

    mov ecx, top3
    mov edx, top3Len
    call printString

    mov ecx, top4
    mov edx, top4Len
    call printString

    mov ecx, top5
    mov edx, top5Len
    call printString

    mov ecx, edge
    mov edx, edgeLen
    call printString


    ; -------------------------------
    ; Print umbrella handle
    ; Using a loop
    ; -------------------------------
    mov esi, 6          ; print handle 6 times

handleLoop:

    call printSpaces
    call printHandle

    dec esi
    jnz handleLoop


    ; -------------------------------
    ; Print curved bottom handle
    ; -------------------------------
    mov ecx, curve
    mov edx, curveLen
    call printString


    ; -------------------------------
    ; Exit program
    ; -------------------------------
    mov eax, 1          ; sys_exit
    mov ebx, 0
    int 0x80


; ==========================================
; printString
; ECX = address of string
; EDX = string length
; ==========================================
printString:

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    int 0x80

    ret


; ==========================================
; printSpaces
; Prints 8 spaces before the handle
; ==========================================
printSpaces:

    mov edi, 8

spaceLoop:

    push edi

    mov eax, 4
    mov ebx, 1
    mov ecx, spaceChar
    mov edx, 1
    int 0x80

    pop edi

    dec edi
    jnz spaceLoop

    ret


; ==========================================
; printHandle
; Prints | followed by newline
; ==========================================
printHandle:

    mov eax, 4
    mov ebx, 1
    mov ecx, handleChar
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret