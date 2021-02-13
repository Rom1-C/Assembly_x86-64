%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "11.in"
inputend:

section .data
array TIMES 400 dq 0

section .text
global _start
_start:

	mov rsi, input
	mov r8, array
	xor r9, r9
	mov r14, 8
	mov r15, 160

_atoi:					; Convert input to int

 .setup:
 	xor eax, eax

 .inner:
 	imul rax, 10
	movzx rbx, byte [rsi]
	add rax, rbx
	sub rax, 48
	inc rsi
	cmp byte [rsi], 32
	jne .inner
	mov [r8], rax
	add r8, 8
	inc rsi
	cmp rsi, inputend
	jle .setup

	mov r10, r8
	mov r8, array

_solv:

	xor rcx, rcx
	xor r12, r12

 .right:
 	cmp rcx, 16
 	ja .rightTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11+8]
 	mul qword [r8+r11+16]
 	mul qword [r8+r11+24]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .right

 .rightTest:
 	cmp r12, 19
 	je .rightEnd
 	inc r12
 	xor rcx, rcx
 	jmp .right

 .rightEnd:
 	mov rcx, 3
 	xor r12, r12

 .left:
 	cmp rcx, 19
 	ja .leftTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11-8]
 	mul qword [r8+r11-16]
 	mul qword [r8+r11-24]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .left

 .leftTest:
 	cmp r12, 19
 	je .leftEnd
 	inc r12
 	mov rcx, 3
 	jmp .left

 .leftEnd:
 	xor rcx, rcx
 	xor r12, r12

 .down:
 	cmp rcx, 19
 	ja .downTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11+160]
 	mul qword [r8+r11+320]
 	mul qword [r8+r11+480]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .down

 .downTest:
 	cmp r12, 16
 	je .downEnd
 	inc r12
 	xor rcx, rcx
 	jmp .down

 .downEnd:
 	xor rcx, rcx
 	mov r12, 3

 .up:
 	cmp rcx, 19
 	ja .upTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11-160]
 	mul qword [r8+r11-320]
 	mul qword [r8+r11-480]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .up

 .upTest:
 	cmp r12, 19
 	je .upEnd
 	xor rcx, rcx
 	inc r12
 	jmp .up

 .upEnd:
 	xor rcx, rcx
 	xor r12, r12

 .diag:
 	cmp rcx, 16
 	ja .diagTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11+168]
 	mul qword [r8+r11+336]
 	mul qword [r8+r11+504]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .diag

 .diagTest:
 	cmp r12, 16
 	je .diagEnd
 	xor rcx, rcx
 	inc r12
 	jmp .diag

 .diagEnd:
 	mov rcx, 3
 	xor r12, r12

 .diagLeft:
 	cmp rcx, 19
 	ja .diagLeftTest
 	mov rax, rcx
 	mul r14
 	mov r11, rax
 	mov rax, r12
 	mul r15
 	add r11, rax
 	mov rax, [r8+r11]
 	mul qword [r8+r11+152]
 	mul qword [r8+r11+304]
 	mul qword [r8+r11+456]
 	cmp rax, r9
 	cmova r9, rax
 	inc rcx
 	jmp .diagLeft

 .diagLeftTest:
 	cmp r12, 16
 	je _itoa
 	mov rcx, 3
 	inc r12
 	jmp .diagLeft


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
	
