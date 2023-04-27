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
    mov ax, 4
    mov bl, 2
    imul bl
    mov [result], ax
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