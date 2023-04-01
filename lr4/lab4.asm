%include "./lib64.asm"

section .data
    ; объявление матрицы размером 4*7
matrix db 1, 2, 3, 4, 5, 6, 7
       db 8, 9, 10, 11, 12, 13, 14
       db 15, 16, 17, 18, 19, 20, 21
       db 22, 23, 24, 25, 26, 27, 28
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


section .text
global _start
_start:
mov ecx, 0  ; инициализация счетчика элементов матрицы

loop_start:
    cmp ecx, 28  ; проверка, достигнут ли конец матрицы
    jge loop_end

    mov eax, ecx  ; сохранение текущего индекса столбца
    mov ebx, 7    ; сохранение количества столбцов в матрице
    div ebx       ; вычисление индекса строки

    add eax, ebx  ; вычисление суммы индексов
    cmp eax, 0
    jne next

    ; вывод элемента матрицы
    mov eax, [matrix + ecx]
    ;mov [result], eax
    ; write
    mov rsi, OutBuf ; адрес выводимой строки
    ;mov rax, dl
    cwde
    call IntToStr64
    mov rbp, rax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    ; mov rcx, rsi ; адрес выводимой строки
    mov rdx, rbp ; длина выводимой строки
    syscall ; вызов системной функции

next:
    inc ecx       ; переход к следующему элементу матрицы
    jmp loop_start

loop_end:
    ; завершение работы программы
    ret