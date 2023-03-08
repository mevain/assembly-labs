%include "./lib64.asm"

section .data
; сегмент инициализированных переменных
; сегмент неинициализированных переменных
section .bss
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf

e resw 1
b resw 1
d resw 1
g resw 1
m resw 1
cur resw 1
result resw 1
InBuf resb 10
lenIn equ $-InBuf
; lenIn equ $-InBuf
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
    mov bl, [d]
    ;mul ebx
    div bl
    mov [result], eax ;здесь результат деления (e-b)/d

    mov eax, [g]
    mul eax
    mov ebx, [m]
    mul ebx
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
    
    ; exit
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall
