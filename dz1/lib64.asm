         section .text     ; сегмент кода
IntToStr64: 
         push   rdi
         push   rbx
         push   rdx
         push   rcx
		 push   rsi
		 mov    byte[rsi],0 ; на место знака
         cmp    eax,0
         jge    .l1
         neg    eax
         mov    byte[rsi],'-'
.l1      mov    byte[rsi+6],10
         mov    rdi,5
         mov    bx,10
.again:  cwd           ; расширили слово до двойного
         div    bx     ; делим результат на 10
         add    dl,30h ; получаем из остатка код цифры
         mov    [rsi+rdi],dl ; пишем символ в строку
         dec    rdi    ; переводим указатель на  
                       ; предыдущую позицию
         cmp    ax, 0  ; преобразовали все число?
         jne    .again
         mov    rcx, 6
         sub    rcx, rdi ; длина результата+знак
		 mov    rax,rcx
		 inc    rax    ; длина результата+OA
         inc    rsi    ; пропускаем знак
		 push   rsi
         lea    rsi,[rsi+rdi] ; начало результата
		 pop    rdi
         rep movsb
         pop    rsi  
         pop    rcx
         pop    rdx
         pop    rbx
         pop    rdi
         ret
StrToInt64:
         push   rdi
         mov    bh, '9'
         mov    bl, '0'
         push   rsi     ; сохран€ем адрес исходной строки
         cmp    byte[rsi], '-'
         jne    .prod
         inc    rsi     ; пропускаем знак
.prod    cld
         xor    di, di  ; обнул€ем будущее число
.cycle:  lodsb          ; загружаем символ (цифру)
         cmp    al, 10  ; если 10, то на конец
         je     .Return
         cmp    al, bl  ; сравниваем с кодом нул€
         jb     .Error  ; "ниже" Ц ќшибка
         cmp    al, bh  ; сравниваем с кодом дев€ти 
         ja     .Error  ; "выше" Ц ќшибка
         sub    al, 30h ; получаем цифру из символа
         cbw            ; расшир€ем до слова
         push   ax      ; сохран€ем в стеке
         mov    ax, 10  ; заносим 10 в AX
         mul    di      ; умножаем, результат в DX:AX
         pop    di      ; в DI Ц очередна€ цифра
         add    ax, di
         mov    di, ax  ; в DI Ц накопленное число        
         jmp    .cycle
.Return: pop    rsi
         mov    rbx, 0
         cmp    byte[rsi], '-'
         jne    .J
         neg    di
.J       mov    ax, di
         cwde
         jmp    .R
.Error:  pop    rsi
         mov    rax, 0
         mov    rbx, 1
.R       pop    rdi
         ret