%include "./lib64.asm"
section .data
    StartMsg db "Enter a string", 10
    StartLen equ $-StartMsg
section .bss
    InBuf resb 100
    lenIn equ $-InBuf
    max resd 1
    OutBuf resb 10
    lenOut equ $-OutBuf
    c resb 1
    Space resb 1
    indp resq 1
    ind resd 1
    cur resd 1
    curs resb 10
    lencur equ $-curs

    section .text
        global _start
        _start:
            ;вывод сообщения в консоль
            mov rax, 1
            mov rdi, 1
            mov rsi, StartMsg
            mov rdx, StartLen
            syscall

            ;ввод строки
            mov rax, 0
            mov rdi, 0
            mov rsi, InBuf
            mov rdx, lenIn
            syscall
            mov eax, lenIn
            ;добавление пробела к строке
            lea rdi,[InBuf] ; загружаем адрес строки в edi
            mov rcx,lenIn ; загружаем размер буфера ввода
            mov al,0Ah ; загружаем 0Ah для поиска в буфере ввода
            repne scasb ; ищем код Enter в строке
            mov rax,100
            sub rax,rcx ; вычитаем из размера буфера остаток cx
            mov rcx,rax ; полученная разница – длина строки +1
            mov BYTE[rcx+InBuf-1],' '

            ;поиск слова
            lea rdi,[InBuf] ; загружаем адрес строки в edi
            mov rdx, lenIn
            mov eax, edx
            mov r9, 0 ;смещение
            mov BYTE[Space], ' '
            mov bl, 0 ; длина слова
            mov dword [max], 0
            mov dword [ind], 0 ; индекс слова
            mov al, ' '
            cycl1: mov al, ' '
                   cmp BYTE[rdi+r9], al
                   je next_word
                   inc bl
        continue:  inc r9
                   cmp BYTE[rdi+r9], 0x00 ; проверка на конец строки
                   jne cycl1
                   jmp exit
        
        next_word: mov eax, [ind]
                   mov [indp], eax
                   mov al, bl
                   mov [ind], r9 ; индекс пробела
                   add BYTE[ind], 1 ;прибавляем единицу, чтобы получить индекс первого символа слова
                   mov [cur], bl ; теперь в cur хранится длина слова
                   mov bl, 2
                   ;mov eax, [cur]
                   ;mov eax, [indp]
                   div bl
                   mov bl, 0 ; обнуляем длину слова
                   ;mov eax, [indp]
                   ;mov eax, [cur]
                   cmp ah, 0 ;проверяем четность длины
                   jne continue
                   mov eax, [max]
                   cmp [cur], eax ;сравниваем длину с максимумом
                   jl continue 
                   mov eax, [cur]
                   mov [max], eax; новая максимальная длина
                   mov ecx, [cur]
                   mov r8, 0
                   push r9
                   mov eax, [indp]
                   mov r9, [indp] ;в r9 индекс начала предыдущего слова (ОТКУДА ЗДЕСЬ 300)
                   lea rsi, [OutBuf]
                   lea rdi, [InBuf] 
        cycl2:     mov al, BYTE[rdi+r9]
                   mov BYTE[rsi+r8], al
                   inc r8
                   inc r9
                   loop cycl2
                   mov bl, 0
                   pop r9
                   jmp continue

        exit:      mov rax, 1
                   mov rdi, 1
                   mov rsi, OutBuf
                   mov rdx, lenOut
                   syscall
                   mov eax, 1
                   xor ebx, ebx
                   int 80h




