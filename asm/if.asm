global main

extern printf
extern scanf

section .data
str10 db "X is not equal to Y", 0
str9 db "X is equal to Y", 0
str8 db "%s%c", 0
str7 db "%d%c", 0
str2 db "false", 0
str3 db "%s", 0
str4 db "X = ", 0
str5 db "%d", 0
str1 db "true", 0
str6 db " Y = ", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 24

mov eax, 5
mov dword[ebp - 4], eax
mov eax, 7
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
; IfStatement
mov eax, dword[ebp - 4]
cmp eax, dword[ebp - 8];x==y
je label6
mov eax, 1
jmp end_label6
label6:
mov eax, 0
end_label6:
mov dword[ebp - 20], eax
mov eax, dword[ebp - 20] ; for cond
cmp eax, 1
jge else_if_label5
push 10
push str9
push str8
call printf
add esp, 12
jmp end_if_label5
else_if_label5:
push 10
push str10
push str8
call printf
add esp, 12
end_if_label5:
mov eax, 456
mov dword[ebp - 4], eax
mov eax, 456
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
; IfStatement
mov eax, dword[ebp - 4]
cmp eax, dword[ebp - 8];x==y
je label8
mov eax, 1
jmp end_label8
label8:
mov eax, 0
end_label8:
mov dword[ebp - 24], eax
mov eax, dword[ebp - 24] ; for cond
cmp eax, 1
jge else_if_label7
push 10
push str9
push str8
call printf
add esp, 12
jmp end_if_label7
else_if_label7:
push 10
push str10
push str8
call printf
add esp, 12
end_if_label7:

end_main:
add esp, 24
leave
ret

