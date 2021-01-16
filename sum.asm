bits 64
global _start

;; sys/syscall.h
%define SYS_write   1
%define SYS_mmap    9
%define SYS_clone   56
%define SYS_EXIT    60
%define SYS_WAITID    247

;; unistd.h
%define STDIN       0
%define STDOUT      1
%define STDERR      2

;; sched.h
%define CLONE_VM    0x00000100
%define CLONE_FS    0x00000200
%define CLONE_FILES 0x00000400
%define CLONE_SIGHAND   0x00000800
%define CLONE_PARENT    0x00008000
%define CLONE_THREAD    0x00010000
%define CLONE_IO    0x80000000
%define CLONE_SIGCHLD    0x00000011

;; sys/mman.h
%define MAP_GROWSDOWN   0x0100
%define MAP_ANONYMOUS   0x0020
%define MAP_PRIVATE 0x0002
%define PROT_READ   0x1
%define PROT_WRITE  0x2
%define PROT_EXEC   0x4

%define THREAD_FLAGS \
 CLONE_SIGCHLD|CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_PARENT|CLONE_THREAD|CLONE_IO

%define STACK_SIZE  (1024 * 1024)

section .data
count:  dq 0
mid : dq 0
number : dq 0
turn : dq 0

section .text
global _start
_start:

	add rsp, 10h
	pop rsi				; Taking number from args
	mov rbp, rsp

_atoi:					; Convert input to int

 .setup:
 	xor eax, eax

 .inner:
 	imul rax, 10
	movzx rbx, byte [rsi]
	add rax, rbx
	sub rax, 48
	inc rsi
	cmp byte [rsi], 0
	jne .inner

_prepareVar:

	mov qword [count], 0
	mov qword [turn], 0

	mov [number], rax
	mov rdi, 2
	div rdi
	mov [mid], rax

	mov rdi, _first
    call thread_create
    push rax
    mov rdi, _second
    call thread_create
    push rax
    mov rdi, 1       
    pop rsi    ; pid
    mov rdx, 0
    mov r10, 4      ; exit
    mov rax, SYS_WAITID
    syscall
    mov rdi, 1       
    pop rsi   ; pid
    mov rdx, 0
    mov r10, 4      ; exit
    mov rax, SYS_WAITID
    syscall
    mov r15, qword [number]

 .run:
 	cmp [turn], r15
 	jne .run
    jmp _itoa



_first:				;sum from 1 to number/2
    mov rcx, 1
 
 .sum:
 	lock add [count], rcx
 	inc rcx
 	lock add qword [turn], 1
 	cmp rcx, [mid]
 	jbe .sum
 	mov rax, SYS_EXIT
 	mov rdi, 0
 	syscall

_second:				;sum from numbers/2 +1 to number
    mov rdx, [mid]
    inc rdx
 
 .sum2:
 	lock add [count], rdx
 	inc rdx
 	lock add qword [turn], 1
 	cmp rdx, [number]
 	jbe .sum2
 	mov rax, SYS_EXIT
 	mov rdi, 0
 	syscall

;; long thread_create(void (*)(void))
thread_create:
    push rdi
    call stack_create
    lea rsi, [rax + STACK_SIZE - 8]
    pop qword [rsi]
    mov rdi, THREAD_FLAGS
    mov rax, SYS_clone
    syscall
    ret

;; void *stack_create(void)
stack_create:
    mov rdi, 0
    mov rsi, STACK_SIZE
    mov rdx, PROT_WRITE | PROT_READ
    mov r10, MAP_ANONYMOUS | MAP_PRIVATE | MAP_GROWSDOWN
    mov r8, -1
    mov r9, 0
    mov rax, SYS_mmap
    syscall
    ret

	; Following part from Alicja Piecha, just to print the result, pretty fast and independant from the code.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                     
	mov byte [rbp-1], 10   
	lea r12, [rbp-2]
	; r12: string pointer
	mov rax, [count]

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
