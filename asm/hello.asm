global main

extern printf
extern scanf

section .data
str4 dd "Hola Mundo"
str3 dd "%s%c"
str1 dd "%s"
str2 dd "Hello World!\n"

section .text

main:
push str2
push str1
call printf
add esp, 8
push 10
push str4
push str3
call printf
add esp, 12
end_main:
leave
ret

