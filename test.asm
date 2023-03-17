%include "io.inc"

section .data
; сегмент инициализированных переменных
ExitMsg db "Press Enter to Exit",10 ; выводимое сообщение9
lenExit equ $-ExitMsg;
; сегмент неинициализированных переменных
section .bss
    InBuf resb 10;
    lenIn equ $-InBuf;
section .text ; сегмент кода
global
_start
_start:
; write
mov rax, 1 ; системная функция 1 (write)
mov rdi, 1 ; дескриптор файла stdout=1
mov rsi, ExitMsg ; адрес выводимой строки
mov rdx, lenExit ; длина строки
; вызов системной функции
syscall
; read
mov rax, 0 ; системная функция 0 (read)
mov rdi, 0 ; дескриптор файла stdin=0
mov rsi, InBuf ; адрес вводимой строки
mov rdx, lenIn ; длина строки
; вызов системной функции
syscall
; exit
mov rax, 60 ; системная функция 60 (exit)
xor rdi, rdi ; return code 0
syscall
; вызов системной функции
global CMAIN
CMAIN:
    ;write your code here
    xor eax, eax
    ret