global main

extern printf

section .data
; Numeric constants
const4 dd 11
const3 dd 10
const2 dd 0
const0 dd 1
const1 dd 2
; String literals
strl3 db "Fibonnaci(10) = ", 0
strl2 db "Fibonnaci(1) = ", 0
strl0 db "Fibonnaci(0) = ", 0
strl4 db "Fibonnaci(11) = ", 0
strl1 db "%s%d%c", 0
; Variables
; Temp variables

section .text
fib:
push ebp
mov ebp, esp
sub esp, 24

cmp dword [ebp + 8], 0
je lbl2


mov eax, dword [ebp + 8]
sub eax, dword [const0]
mov dword [ebp - 4], eax
cmp dword [ebp - 4], 0
je lbl0


mov eax, dword [ebp + 8]
sub eax, dword [const0]
mov dword [ebp - 8], eax
push dword [ebp - 8]
call fib
add esp, 4
mov dword [ebp - 12], eax


mov eax, dword [ebp + 8]
sub eax, dword [const1]
mov dword [ebp - 16], eax
push dword [ebp - 16]
call fib
add esp, 4
mov dword [ebp - 20], eax
mov eax, dword [ebp - 12]
add eax, dword [ebp - 20]
mov dword [ebp - 24], eax
mov eax, dword [ebp - 24]
jmp __lbl_fib_epilog

jmp lbl1
lbl0:

mov eax, dword [const0]
jmp __lbl_fib_epilog

lbl1:

jmp lbl3
lbl2:

mov eax, dword [const2]
jmp __lbl_fib_epilog

lbl3:
__lbl_fib_epilog:
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 16


push dword [const2]
call fib
add esp, 4
mov dword [ebp - 4], eax

push 10
push dword [ebp - 4]
push strl0
push strl1
call printf
add esp, 16


push dword [const0]
call fib
add esp, 4
mov dword [ebp - 8], eax

push 10
push dword [ebp - 8]
push strl2
push strl1
call printf
add esp, 16


push dword [const3]
call fib
add esp, 4
mov dword [ebp - 12], eax

push 10
push dword [ebp - 12]
push strl3
push strl1
call printf
add esp, 16


push dword [const4]
call fib
add esp, 4
mov dword [ebp - 16], eax

push 10
push dword [ebp - 16]
push strl4
push strl1
call printf
add esp, 16
__lbl_main_epilog:
leave
ret
