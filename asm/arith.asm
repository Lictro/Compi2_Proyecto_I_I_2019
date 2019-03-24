global main

extern printf
extern scanf

section .data
str3 dd "%s%s%c", 0
str4 dd "es", 0
str1 dd "true", 0
str2 dd "false", 0

section .text

main:
push 10
push str1
push str4
push str3
call printf
add esp, 16
push 10
push str2
push str4
push str3
call printf
add esp, 16

end_main:
leave
ret

