%include "./lib64.asm"

section .data
; сегмент инициализированных переменных
ExitMsg db "Error: division to zero",10
lenExit equ $-ExitMsg
; сегмент неинициализированных переменных
section .bss
cur resd 1
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf
mas resb 28
InBuf resb 10
lenIn equ $-InBuf

section .text
global _start
_start:
        mov edi, 0
        mov ecx, 7 ; количество столбцов
cycle3: 
        push rcx
        mov ecx, 4 ; количество строк
        mov ebx, 0
cycle4: mov rax, 0
        mov rdi, 0
        mov rsi, InBuf
        mov rdx, 4
        mov bl, ecx
        syscall
        mov ecx, bl
        mov rsi, InBuf
        call StrToInt64
        mov [ebx+edi+mas], rax
        add ebx, 7
        loop cycle4
        pop rcx
        inc edi
        loop cycle3

        ; вывод нужных элементов
        mov edi, 0
        mov ecx, 7 ; количество столбцов
cycle1: 
        push rcx
        mov ecx, 4 ; количество строк
        mov ebx, 0
cycle2: mov eax, ebx
        add eax, ecx
        mov bl, 3
        mov [cur], eax
        cmp [cur], bl
        jne cycle2
        mov rsi, OutBuf ; адрес выводимой строки
        mov rax, [ebx+edi+mas]
        cwde
        call IntToStr64
        mov rbp, rax
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rdx, rbp ; длина выводимой строки
        syscall ; вызов системной функции
        add ebx, 7
        loop cycle2
        pop rcx
        inc edi
        loop cycle1

        ;exit
        mov rax, 60 ; системная функция 60 (exit)
        xor rdi, rdi ; return code 0
        syscall