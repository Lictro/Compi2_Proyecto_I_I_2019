global main

extern printf
extern scanf

section .data
str7 db "End of loop, ", 0
str2 db "false", 0
str1 db "true", 0
str3 db "%s", 0
str6 db "%s%d%c", 0
str4 db "i = ", 0
str5 db "%d%c", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 20

mov eax, 10
mov dword[ebp - 4], eax
mov eax, 0
mov dword[ebp - 4], eax
for_label3:
mov eax, dword[ebp - 4]
cmp eax, 10
jle label4
mov eax, 1
jmp end_label4
label4:
mov eax, 0
end_label4:
mov dword[ebp - 16], eax
mov eax, dword[ebp - 16] ; for cond
cmp eax, 1
jge end_for_label3
push str4
push str3
call printf
add esp, 8
push 10
push dword[ebp - 4]
push str5
call printf
add esp, 12
mov eax, dword[ebp - 4]
add eax, 1
mov dword[ebp - 20], eax
mov eax, dword[ebp - 20]
mov dword[ebp - 4], eax
jmp for_label3
end_for_label3:

push 10
push dword[ebp - 4]
push str7
push str6
call printf
add esp, 16

end_main:
add esp, 20
leave
ret

