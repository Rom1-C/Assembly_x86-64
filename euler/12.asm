%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

; Slow implementation, will use prime numbers and triangle number notation in next update of the code

section .text
global _start
_start:

	mov r11, 1
	mov r8, r11

_solv:

 .run:
 	call _number
 	cmp r9, 500
 	ja _itoa
 	inc r11
 	add r8, r11
 	jmp .run

_number: ; arg: r8, return r9
	
	mov rcx, 1
	mov r9, 1
	mov r15, r8
	shr r15, 1

 .t:
 	cmp rcx, r15
 	ja .end
 	xor rdx, rdx
 	mov rax, r8
 	div rcx
 	inc rcx
 	cmp rdx, 0
 	jne .t
 	inc r9
 	jmp .t

 .end:
 	ret

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
	
