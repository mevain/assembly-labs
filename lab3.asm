%include "./lib64.asm"

section .data
; сегмент инициализированных переменных
; сегмент неинициализированных переменных
section .bss
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf
a resd 1
b resd 1
cur1 resd 1
cur2 resd 1
cur3 resd 1
cur4 resd 1
InBuf resb 10
lenIn equ $-InBuf
; lenIn equ $-InBuf
section .text
global _start
_start:

    ;write
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [a], rax

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [b], rax

    mov eax, [a]
    sub eax, [b]
    mov [cur1], eax

    mov eax, [a]
    add eax, [b]
    mov [cur2], eax
    
    mov eax, [a]
    mov ebx, [b]
    cwde
    idiv ebx
    mov [cur3], eax

    mov eax, [cur2]
    mov edx, 0
    mov ebx, [cur1]
    cwde
    div ebx
    mov [cur4], eax

    mov eax, [cur4]
    cmp eax, [cur3]
    jg greater
    jl less

    ; write
    ; mov rsi, OutBuf ; адрес выводимой строки
    ; mov rax, [cur4]
    ; cwde
    ; call IntToStr64
    ; mov rbp, rax
    ; mov rax, 1 ; системная функция 1 (write)
    ; mov rdi, 1 ; дескриптор файла stdout=1
    ; ; mov rcx, rsi ; адрес выводимой строки
    ; mov rdx, rbp ; длина выводимой строки
    ; syscall ; вызов системной функции
    ; mov rax, 60 ; системная функция 60 (exit)
    ; xor rdi, rdi ; return code 0
    ; syscall

    greater:     ; write
            mov rsi, OutBuf ; адрес выводимой строки
            mov rax, [cur2]
            cwde
            call IntToStr64
            mov rbp, rax
            mov rax, 1 ; системная функция 1 (write)
            mov rdi, 1 ; дескриптор файла stdout=1
            ; mov rcx, rsi ; адрес выводимой строки
            mov rdx, rbp ; длина выводимой строки
            syscall ; вызов системной функции
            mov rax, 60 ; системная функция 60 (exit)
            xor rdi, rdi ; return code 0
            syscall

    less:     ; write
            mov rsi, OutBuf ; адрес выводимой строки
            mov rax, [cur1]
            cwde
            call IntToStr64
            mov rbp, rax
            mov rax, 1 ; системная функция 1 (write)
            mov rdi, 1 ; дескриптор файла stdout=1
            ; mov rcx, rsi ; адрес выводимой строки
            mov rdx, rbp ; длина выводимой строки
            syscall ; вызов системной функции
            mov rax, 60 ; системная функция 60 (exit)
            xor rdi, rdi ; return code 0
            syscall