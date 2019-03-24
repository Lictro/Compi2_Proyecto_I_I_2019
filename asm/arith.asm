global main

extern printf
extern scanf

section .data
link dd 2017
a dd 0
flag dd 1
b dd 0
str13 db "%s%c", 0
str9 db "Sub ", 0
str8 db "Add ", 0
str7 db "%d%c", 0
str11 db "Div ", 0
str2 db "false", 0
str1 db "true", 0
str3 db "%s", 0
str4 db "X = ", 0
str10 db "Mul ", 0
str5 db "%d", 0
str12 db "Mod ", 0
str6 db ", Y = ", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 40

mov eax, 15
mov dword[ebp - 4], eax
mov eax, 3
mov dword[ebp - 8], eax
push str4
push str3
call printf
add esp, 8
push dword[ebp - 4]
push str5
call printf
add esp, 8
push str6
push str3
call printf
add esp, 8
push 10
push dword[ebp - 8]
push str7
call printf
add esp, 12
push str8
push str3
call printf
add esp, 8
push 10
mov eax, dword[ebp - 4]
add eax, dword[link]
mov dword[ebp - 28], eax
push dword[ebp - 28]
push str7
call printf
add esp, 12
push str9
push str3
call printf
add esp, 8
push 10
mov eax, dword[ebp - 4]
sub eax, dword[ebp - 8]
mov dword[ebp - 32], eax
push dword[ebp - 32]
push str7
call printf
add esp, 12
push str10
push str3
call printf
add esp, 8
push 10
mov eax, dword[ebp - 4]
mov ecx, dword[ebp - 8]
imul ecx
mov dword[ebp - 36], eax
push dword[ebp - 36]
push str7
call printf
add esp, 12
push str11
push str3
call printf
add esp, 8
push 10
xor edx, edx
mov eax, dword[ebp - 4]
mov ecx, dword[ebp - 8]
cdq
idiv ecx
mov dword[ebp - 40], eax
push dword[ebp - 40]
push str7
call printf
add esp, 12
push str12
push str3
call printf
add esp, 8
push 10
mov eax, dword[flag]
cmp eax, 0
je label2
push str2
jmp end_label2
label2:
push str1
end_label2:

push str13
call printf
add esp, 12

end_main:
add esp, 40
leave
ret

