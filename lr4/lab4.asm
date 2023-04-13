%include "./lib64.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define ROWS 4
%define COLUMNS 7
%define MATRIX_SIZE 35

section .data
    StartMsg db "Enter 4*7 matrix:", 10
    StartLen equ $-StartMsg
    NewLine: db 0xA
    ResultMsg db "Result:", 10
    ResultLen equ $-ResultMsg

    IncorrectLineMsg db "Each line should have exactly 7 numbers divided by spaces", 10
    IncorrectLineLen equ $-IncorrectLineMsg

    ErrorSTIMsg dq "Error while transform str to int", 10
    ErrorSTILen equ $-ErrorSTIMsg

    Space db "  "

section .bss
    matrix times MATRIX_SIZE resq 1
    cur resd 1
    cur1 resd 1
    cur2 resd 1
    OutBuf resw 1
    lenOut equ $-OutBuf
    InBuf resq 10
    lenIn equ $-InBuf


section .text
global _start

_start:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, StartMsg
    mov rdx, StartLen
    syscall

    mov rcx, ROWS
    xor rdi, rdi

read_line:
    push rcx
    push rdi

    mov rax, READ
    mov rdi, STDIN
    mov rsi, InBuf
    mov rdx, lenIn
    syscall

    pop rdi
    mov rcx, rax ; Сохраням длину строки
    xor rdx, rdx ; Обнуляем регистр
    xor r8, r8 ; Обнуляем регистр

process_line:
    cmp byte[InBuf + rdx], 10; Если конец строки то обрабатываем число
    je process_number

    cmp byte[InBuf + rdx], ' '; Если был не конец, и следующий символ 
    jne next; не пробел, то продолжаем считывание

    mov byte[InBuf + rdx], 10; Помещаем вместо проблеа \n
    cmp r8, rdx; Если длина строки не совпадает с предыдущей
    jne process_number
    jmp next; ???

process_number:
    push rdx

    call StrToInt64; Вход: RSI Выход: RAX, RBX содержит 0 if errors = 0
    cmp rbx, 0
    jne STIError; Вывод ошибки

    mov [matrix + 8 * rdi], rax; Помещаем результат в матрицу
    inc rdi; увеличиваем счетчик введенных чисел

    pop rdx
    mov r8, rdx; Теперь считывать следующее число надо начинать с 
    inc r8; окончания длины предыдущего
    lea rsi, [InBuf + r8]; Передаем указатель на смещенный буфер

next:
    inc rdx; Увеличиваем длину числа
    loop process_line

    pop rcx
    mov rax, ROWS; Проверим количество введеных чисел < 7 в текущей строке
    sub rax, rcx
    inc rax
    push rdx
    mov rdx, COLUMNS
    imul rdx
    pop rdx 

    cmp rdi, rax; Если введено чисел больше чем длинна строки матрицы
    jne IncorrectLine

    ; loop read_line; 
    dec rcx
    cmp rcx, 0
    jnz read_line

output:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, ResultMsg
    mov rdx, ResultLen
    syscall

    mov rcx, ROWS
    xor rbx, rbx; Обнуляем регистр
    mov al, 0 ; счетчик строк
    mov bl, 0 ; счетчик столбцов
    mov [cur], al
    mov [cur1], bl
output_row:
    push rcx
    mov rcx, COLUMNS
output_column:
    push rcx
    mov eax, [cur]
    add eax, [cur1]
    mov [cur2], bl
    mov bl, 3
    cwde
    div bl
    mov bl, [cur2]
    mov [cur2], ah
    mov rsi, OutBuf
    xor rax, rax
    mov rax, [matrix + 8 * rbx]
    inc rbx
    cmp dword [cur2], 0
    jne continue1
    call IntToStr64
    mov rax, WRITE; системная функция 1 (write)
    mov rdi, STDOUT; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции
    call PrintSpace
continue1:
    inc dword [cur1] ;сбивает все регистры. надо делать счетчик в переменных.
    pop rcx
    loop output_column
    mov rax, WRITE; системная функция 1 (write)
    mov rdi, STDOUT; дескриптор файла stdout=1
    mov rsi, NewLine ; адрес выводимой строки
    mov rdx, 1 ; длина строки
    syscall; вызов системной функции
    pop rcx
    inc dword [cur]
    mov dword [cur1], 0
    dec rcx
    jnz output_row

exit:
    xor rdi, rdi
    mov rax, EXIT
    syscall

 not_div:
     add al, 1
     jmp output_column

IncorrectLine:
    mov rax, WRITE
    mov rdi, STDOUT   
    mov rsi, IncorrectLineMsg
    mov rdx, IncorrectLineLen
    syscall
    jmp exit

STIError:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ErrorSTIMsg ; адрес выводимой строки
    mov rdx, ErrorSTILen ; длина строки
    syscall; вызов системной функции
    jmp exit
;end

PrintSpace:    
    mov rax, 1
    mov rdi, 1
    mov rsi, Space
    mov rdx, 1
    syscall
    ret
