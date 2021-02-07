%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "8.in"

section .text
global _start
_start:

	mov r8, input
	xor r9, r9
	xor rcx, rcx

_solv:

 .calc:
 	cmp rcx, 988
 	je _itoa
 	call _load
 	cmp rax, r9
 	cmova r9, rax
 	inc r8
 	inc rcx
 	jmp .calc

_load:
	xor r15, r15
	mov rax, 1

 .inner:
 	cmp r15, 13
 	je .done
 	movzx r11, byte [r8+r15]
 	sub r11, 48
 	mul r11
 	inc r15
 	jmp .inner
 .done:
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
	
