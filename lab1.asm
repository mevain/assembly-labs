section .data
f1 dw 65535
f2 dd 65535
; сегмент неинициализированных переменных
section .bss
;InBuf resb 10 ; буфер для вводимой строки
;lenIn equ $-InBuf
X resd 1
   section .text ; сегмент кода
   global _start
_start:
; write
mov EAX, [f1]
add EAX,1
mov EAX, [f2]
add EAX, 1
; вызов системной функции
syscall
; exit
mov rax, 60 ; системная функция 60 (exit)
xor rdi, rdi ; return code 0
syscall
; вызов системной функции

