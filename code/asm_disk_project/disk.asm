;; File create
%macro fcreate 2
	push rax
	push rdi
	push rsi

	jmp %%createCode
	%%fileName db %1, 0
%%createCode:
	mov rax, 85		;; Create
	mov rdi, %%fileName	;; Filename
	mov rsi, %2		;; File Permissions
	syscall

	pop rsi
	pop rdi
	pop rax	;; Preserve stack frame
%endmacro

;; File open
%macro fopen 2
	push rdi	;; Preserve stack frame
	push rsi
	push rdx

	jmp %%openCode
	%%fileName db %1, 0
%%openCode:
	mov rax, 0x02		;; Open
	mov rdi, %%fileName	;; Filename
	mov rsi, %2		;; File read flags 00=RD,01=WT,02=RDWT
	mov rdx, 0644o
	syscall

	pop rdx
	pop rsi
	pop rdi	;; Preserve stack frame

	push rax	;; Keep rax at top of stack
%endmacro

;; File write
%macro fwrite 1
	push rdi	;; Preserve stack frame
	push rsi
	push rdx

	mov rdi, rax		;; File handler to rdi
	jmp %%writeCode
	%%bufferS db %1
	%%bufferLen equ $ - %%bufferS
%%writeCode:
	mov rax, 1		;; Write to file
	mov rsi, %%bufferS	;; Data to write
	mov rdx, %%bufferLen	;; Data Length
	syscall
	mov rax, rdi

	pop rdx
	pop rsi
	pop rdi	;; Preserve stack frame
%endmacro

;; File read
%macro fread 2
	push rax	;; Preserve stack frame
	push rdi
	push rsi
	push rdx

	mov rdi, rax
	mov rax, 0		;; Read
	mov rsi, %1		;; Where to store the data
	mov rdx, %2		;; Length of read
	syscall

	pop rdx
	pop rsi
	pop rdi
	pop rax	;; Preserve stack frame
%endmacro


;; File close - File handle from stack
%macro fclose 1
	push rax	;; Preserve stack frame
	push rdi

	mov rax, 3
	mov rdi, %1
	syscall

	pop rdi
	pop rax
%endmacro
