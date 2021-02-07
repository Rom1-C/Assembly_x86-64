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

	xor r8, r8
	xor r9, r9

_solv:

	xor rcx, rcx
	
 .squares:
 	cmp rcx, 101
 	je .setup
 	mov rax, rcx
 	mul rax
 	add r8, rax
 	inc rcx
 	jmp .squares

 .setup:
 	dec rcx

 .sum:
 	cmp rcx, 0
 	je .square
 	add r9, rcx
 	dec rcx
 	jmp .sum

 .square:
 	mov rax, r9
 	mul rax
 	mov r9, rax

 .end:
 	sub r9, r8

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
	
