%include "./lib64.asm"

section .data
; сегмент инициализированных переменных
; сегмент неинициализированных переменных
section .bss
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf
e resd 1
b resd 1
d resd 1
g resd 1
m resd 1
cur resd 1
result resd 1
InBuf resb 10
lenIn equ $-InBuf
; lenIn equ $-InBuf
ZeroMsg db "d is equal zero",10
lenZero equ $-ZeroMsg
section .text
global _start
_start:

    ;write
    ;read e
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [e], rax

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [b], rax

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [d], rax
    cmp eax, 0; проверка кода ошибки
    je exit

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [g], rax

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [m], rax

    mov eax, [e]
    ;mov ebx, [b]
    sub eax, [b]
    mov ebx, eax
    mov ebx, [d]
    ;mul ebx
    cwde
    idiv ebx
    mov [result], eax ;здесь результат деления (e-b)/d

    mov eax, [g]
    imul eax
    mov ebx, [m]
    imul ebx
    mov ebx, eax
    mov eax, [result]
    sub eax, ebx
    sub eax, 2
    mov [result], eax
    ; write
    mov rsi, OutBuf ; адрес выводимой строки
    mov rax, [result]
    cwde
    call IntToStr64
    mov rbp, rax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    ; mov rcx, rsi ; адрес выводимой строки
    mov rdx, rbp ; длина выводимой строки
    syscall ; вызов системной функции
    exit:
        mov rax, 60 ; системная функция 60 (exit)
        xor rdi, rdi ; return code 0
        syscall