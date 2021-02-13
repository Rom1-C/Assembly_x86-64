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

	mov r8, 3
	xor r9, r9
	xor r10, r10

_solv:

 	mov r9, r8
 	inc r9

 	mov r10, r9
 	inc r10

 .run:
 	cmp r8, 333
 	je _itoa
 	
 	mov rax, r10
 	mul r10
 	mov rdi, rax

 	mov rax, r9
 	mul r9
 	mov rsi, rax

 	mov rax, r8
 	mul r8
 	add rsi, rax
 	
 	cmp rsi, rdi
 	jne .follow

 	mov r11, r10
 	add r11, r9
 	add r11, r8
 	cmp r11, 1000
 	je .find

 .follow:

 	inc r10
 	cmp r10, 1000
 	je .c
 	jmp .run

 .c:
 	inc r9
 	cmp r9, 999
 	je .b
 	mov r10, r9
 	inc r10
 	jmp .run

 .b:
 	inc r8
 	mov r9, r8
 	inc r9

 	mov r10, r9
 	inc r10
 	jmp .run

 .find:
 	mov rax, r10
 	mul r9
 	mul r8

; Following part from Alicja Piecha, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer
	;mov rax, r15

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
	
