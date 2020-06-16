%macro PRINT 1
	push rax
	push rdi
	push rsi
	push rdx
	pushf

    	jmp %%astr

	%%str db %1,0
	%%strln equ $-%%str

%%astr: _syscall_write %%str, %%strln

	popf
	pop rdx
	pop rsi
	pop rdi
	pop rax
%endmacro

%macro _syscall_write 2
	mov rax, 1
        mov rdi, 1
        mov rsi, %1
        mov rdx, %2
        syscall
%endmacro
