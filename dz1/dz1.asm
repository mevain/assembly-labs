%include "./lib64.asm"
section .data
; сегмент инициализированных переменных
ExitMsg db "Result: ",10
lenExit equ $-ExitMsg
EnterMsg db "Введите количество символов:",10
lenM equ $-EnterMsg
SymMsg db "Введите символ:",10
lenS equ $-SymMsg
AmMsg db "Введите количество повторений:",10
lenAm equ $-$AmMsg
; сегмент неинициализированных переменных
section .bss
n resd 1 ;количество символов
x resd 1 ;количество повторений одного символа
c resb 1 ;символ
lenc equ $-c
cur resd 1
; буфер для вводимой строки
InBuf resb 100
lenIn equ $-InBuf
InBuf1 resb 100
lenIn1 equ $-InBuf1
AnsBuf resb 100
lenAns equ $-AnsBuf
section .text ; сегмент кода
global _start
_start:
    ; write
    mov rax, 1 ; системная функция 4 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, EnterMsg ; адрес выводимой строки
    mov rdx, lenM ; длина выводимой строки
    syscall; вызов системной функции
    ; ; read
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [n], rax
    mov ecx, [n]
    mov r9, 0
    lea rdi, [AnsBuf]

cycl:
     ;вывод сообщения
    push rdi
    mov rax, 1 ; системная функция 4 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, AmMsg ; адрес выводимой строки
    mov rdx, lenAm; длина выводимой строки
    mov [cur], ecx
    syscall; вызов системной функции
    mov ecx, [cur]
    ; ввод количества повторений
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    mov [cur], ecx
    syscall
    mov ecx, [cur]
    mov rsi, InBuf
    call StrToInt64
    mov [x], rax
    mov rax, 1 ; системная функция 4 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, SymMsg ; адрес выводимой строки
    mov rdx, lenS ; длина выводимой строки
    mov [cur], ecx
    syscall; вызов системной функции
    mov ecx, [cur]
    ; ввод символа
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    mov [cur], ecx
    syscall
    mov ecx, [cur]
    mov rsi, InBuf
    push rcx
    mov ecx, [x]
    lea rdi, [AnsBuf]
cycl2:
    ;mov [c], rsi
    mov al, BYTE[rsi]
    ;pop rdi
    mov BYTE[rdi+r9], al
    mov al, BYTE[rdi]
    inc r9
    loop cycl2

    pop rcx
    dec ecx
    jnz cycl

    lea rsi, [AnsBuf]
exit:
    push rsi
    ;write text
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, ExitMsg
    mov rdx, lenExit ; длина строки
    syscall ; вызов системной функции

    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    pop rsi
    mov rdx, lenAns ; длина строки
    syscall ; вызов системной функции

    ; exit
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; код возврата 0
    syscall ; вызов системной функции завершения
    ;;создать строку ans, сначала ввести n, потом цикл по n элементов где вводим букву и цифру, потом букву m колво раз пихаем в ans