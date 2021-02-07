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

	mov r10, 10
	mov rsi, 11
	xor r9, r9
	mov r14, 999

_solv:
	
 .inner:
 	cmp r14, 100
 	jb _itoa
 	xor rdx, rdx
 	mov rax, r14
 	div rsi
 	cmp rdx, 0
 	jne .outer
 	mov r15, 999
 	mov rdi, 1
 	jmp .follow

 .outer:
 	mov r15, 990
 	mov rdi, 11

 .follow:
 	cmp r15, r14
 	jb .end
 	mov rax, r14
 	mul r15
 	cmp rax, r9
 	jbe .end
 	mov r8, rax
 	call _isPalindrome
 	cmp r12, 1
 	jne .no
 	mov rax, r14
 	mul r15
 	mov r9, rax

 .no:
 	sub r15, rdi
 	jmp .follow

 .end:
 	dec r14
 	jmp .inner

_reverse: ; arg : r8

	xor rcx, rcx

 .calc:
 	xor rdx, rdx
 	cmp r8, 0
 	je .done
 	mov rax, rcx
 	mul r10
 	mov rcx, rax
 	mov rax, r8
 	div r10
 	add rcx, rdx
 	xor rdx, rdx
 	mov rax, r8
 	div r10
 	mov r8, rax
 	jmp .calc

 .done:
 	ret

_isPalindrome: ; arg : r8

	mov r11, r8
	call _reverse
	cmp r11, rcx
	jne .false
	mov r12, 1
	ret

 .false:
 	xor r12, r12
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
	
