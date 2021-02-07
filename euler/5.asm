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

	mov rax, 20
	jmp _ok

_solv:

	cmp r9, 1
	je _itoa
	add rax, 20

_ok:

	mov r8, 1
 
 .inner:
	push rax
	mov edx, 0
	div r8
	pop rax
	cmp rdx, 0
	jne .no
	cmp r8, 20
	ja .yes
	inc r8
	jmp .inner

 .no:
	xor r9, r9
	jmp _solv

 .yes:
	mov r9, 1
	jmp _solv

; Following part from Alicja Piecha, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer
	;mov rax, rax

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
	
