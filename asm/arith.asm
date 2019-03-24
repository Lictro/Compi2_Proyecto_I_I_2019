global main

extern printf
extern scanf

section .data
str9 dd "menor igual ", 0
str8 dd "mayor igual ", 0
str7 dd "menor ", 0
str2 dd "false", 0
str1 dd "true", 0
str3 dd "%s%s%c", 0
str5 dd "distinto ", 0
str4 dd "igual ", 0
str6 dd "mayor ", 0

section .text

main:
push ebp
mov ebp, esp
sub esp, 48

push 10
mov eax, 10
cmp eax, 11;10==11
je label13
mov eax, 1
jmp end_label13
label13:
mov eax, 0
end_label13:
mov dword[ebp - 28], eax
mov eax, dword[ebp - 28]
cmp eax, 0
je label14
push str2
jmp end_label14
label14:
push str1
end_label14:

push str4
push str3
call printf
add esp, 16
push 10
mov eax, 10
cmp eax, 11
jne label15
mov eax, 1
jmp end_label15
label15:
mov eax, 0
end_label15:
mov dword[ebp - 32], eax
mov eax, dword[ebp - 32]
cmp eax, 0
je label16
push str2
jmp end_label16
label16:
push str1
end_label16:

push str5
push str3
call printf
add esp, 16
push 10
mov eax, 10
cmp eax, 11
jg label17
mov eax, 1
jmp end_label17
label17:
mov eax, 0
end_label17:
mov dword[ebp - 36], eax
mov eax, dword[ebp - 36]
cmp eax, 0
je label18
push str2
jmp end_label18
label18:
push str1
end_label18:

push str6
push str3
call printf
add esp, 16
push 10
mov eax, 10
cmp eax, 11
jl label19
mov eax, 1
jmp end_label19
label19:
mov eax, 0
end_label19:
mov dword[ebp - 40], eax
mov eax, dword[ebp - 40]
cmp eax, 0
je label20
push str2
jmp end_label20
label20:
push str1
end_label20:

push str7
push str3
call printf
add esp, 16
push 10
mov eax, 10
cmp eax, 11
jge label21
mov eax, 1
jmp end_label21
label21:
mov eax, 0
end_label21:
mov dword[ebp - 44], eax
mov eax, dword[ebp - 44]
cmp eax, 0
je label22
push str2
jmp end_label22
label22:
push str1
end_label22:

push str8
push str3
call printf
add esp, 16
push 10
mov eax, 10
cmp eax, 11
jle label23
mov eax, 1
jmp end_label23
label23:
mov eax, 0
end_label23:
mov dword[ebp - 48], eax
mov eax, dword[ebp - 48]
cmp eax, 0
je label24
push str2
jmp end_label24
label24:
push str1
end_label24:

push str9
push str3
call printf
add esp, 16

end_main:
add esp, 48
leave
ret

