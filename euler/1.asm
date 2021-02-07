%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .text
global _start
_start:

	mov r9, 3
	mov r10, 5
	xor r8, r8
	mov rcx, 1

_solv:
	
	inc rcx
	cmp rcx, 1000
	je _itoa
	mov rax, rcx
	mov rdx, 0
	div r9
	cmp rdx, 0
	je .three
	mov rax, rcx
	mov rdx, 0
	div r10
	cmp rdx, 0
	je .five
	jmp _solv

 .three:
 	add r8, rcx
 	jmp _solv

 .five:
 	add r8, rcx
 	jmp _solv

; Following part from Alicja Piecha, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer
	mov rax, r8

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
	
