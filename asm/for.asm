global main

extern printf
extern scanf

section .data
n dd 10
arr TIMES 10 DD 0
str7 db "", 0
str2 db "false", 0
str1 db "true", 0
str3 db "%d", 0
str4 db "%s", 0
str5 db " ", 0
str6 db "%s%c", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 20

mov eax, 24
mov ecx, 0
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 71
mov ecx, 1
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 94
mov ecx, 2
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 3
mov ecx, 3
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 46
mov ecx, 4
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 54
mov ecx, 5
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 96
mov ecx, 6
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 14
mov ecx, 7
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 7
mov ecx, 8
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 42
mov ecx, 9
shl ecx, 2
mov edx, arr
add edx, ecx
mov dword[edx], eax
mov eax, 0
mov dword[ebp - 4], eax
for_label3:
mov eax, dword[ebp - 4]
cmp eax, dword[n]
jl label4
mov eax, 1
jmp end_label4
label4:
mov eax, 0
end_label4:
mov dword[ebp - 16], eax
mov eax, dword[ebp - 16] ; for cond
cmp eax, 1
jge end_for_label3
mov ecx, dword[ebp - 4]
shl ecx, 2
mov edx, arr
add edx, ecx
push dword[edx]
push str3
call printf
add esp, 8
push str5
push str4
call printf
add esp, 8
mov eax, dword[ebp - 4]
add eax, 1
mov dword[ebp - 20], eax
mov eax, dword[ebp - 20]
mov dword[ebp - 4], eax
jmp for_label3
end_for_label3:

push 10
push str7
push str6
call printf
add esp, 12

end_main:
add esp, 20
leave
ret

