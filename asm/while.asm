global main

extern printf
extern scanf

section .data
str7 db "%d%c", 0
str8 db "The total is ", 0
str2 db "false", 0
str1 db "true", 0
str3 db "%s", 0
str4 db "Number [", 0
str5 db "%d", 0
str6 db "] = ", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 52

mov eax, 0
mov dword[ebp - 4], eax
mov eax, 0
mov dword[ebp - 8], eax
; WhileStatement
while_label3:
mov eax, dword[ebp - 8]
cmp eax, 3
jl label4
mov eax, 1
jmp end_label4
label4:
mov eax, 0
end_label4:
mov dword[ebp - 36], eax
mov eax, dword[ebp - 36] ; for cond
cmp eax, 1
jge end_while_label3
mov eax, dword[ebp - 8]
add eax, 1
mov dword[ebp - 40], eax
mov eax, dword[ebp - 40]
mov ecx, 10
imul ecx
mov dword[ebp - 44], eax
mov eax, dword[ebp - 44]
mov dword[ebp - 12], eax
push str4
push str3
call printf
add esp, 8
push dword[ebp - 8]
push str5
call printf
add esp, 8
push str6
push str3
call printf
add esp, 8
push 10
push dword[ebp - 12]
push str7
call printf
add esp, 12
mov eax, dword[ebp - 8]
add eax, 1
mov dword[ebp - 48], eax
mov eax, dword[ebp - 48]
mov dword[ebp - 8], eax
mov eax, dword[ebp - 4]
add eax, dword[ebp - 12]
mov dword[ebp - 52], eax
mov eax, dword[ebp - 52]
mov dword[ebp - 4], eax
jmp while_label3
end_while_label3:

push str8
push str3
call printf
add esp, 8
push 10
push dword[ebp - 4]
push str7
call printf
add esp, 12

end_main:
add esp, 52
leave
ret

