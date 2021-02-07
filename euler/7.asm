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

	xor rcx, rcx
	xor r8, r8

_solv:

	mov r9, 2

 .run:
	call _isPrime
	cmp r11, 1
	jne .outer
	inc rcx
	cmp rcx, 10001
	je _itoa

 .outer:
 	inc r9
 	jmp .run

_isPrime: ; args : r9

	mov r12, 2

 .inner:
 	mov rax, r12
 	mul rax
 	cmp rax, r9
 	ja .prime
 	xor rdx, rdx
 	mov rax, r9
 	div r12
 	cmp rdx, 0
 	je .notPrime
 	inc r12
 	jmp .inner

 .prime:
 	mov r11, 1
 	ret

 .notPrime:
 	mov r11, 0
 	ret


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
	
