%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "13.in"
inputend:

section .data
array TIMES 100 dq 0

section .text
global _start
_start:

	mov rsi, input
	mov r8, array
	xor r9, r9

_atoi:					; Convert input to int

 .setup:
 	xor eax, eax
	xor rcx, rcx

 .inner:
 	imul rax, 10
	movzx rbx, byte [rsi]
	add rax, rbx
	sub rax, 48
	inc rsi
	inc rcx
	cmp rcx, 12
	jb .inner
	mov [r8], rax
	add r8, 8
	add rsi, 39
	cmp rsi, inputend
	jle .setup

	mov r10, r8
	mov r8, array

_solv:

	xor rcx, rcx

 .run:
 	cmp rcx, 100
 	je _itoa
 	add r9, [r8+8*rcx]
 	inc rcx
 	jmp .run

; Following part from Alicja Piecha, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer
	mov rax, r9

 .loop:
	xor edx, edx
	div r10
	add rdx, 48
	mov [r12], dl
	dec r12
	cmp r12, rsp
	jne .loop

	mov r9, rsp
	mov r11, 22
 .trim:
	inc r9
	dec r11
	cmp byte [r9], 48
	je .trim

	mov rax, 1
	mov rdi, 1
	mov rsi, r9
	mov rdx, r11
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
	
