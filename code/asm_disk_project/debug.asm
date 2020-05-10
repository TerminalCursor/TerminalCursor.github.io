section .data
	hexOut db "0x00000000", 0x0A
	hexLen equ $ - hexOut

section .text
%macro dumpRegister 1
	push rax	;; Preserve stack
	push rbx
	push rcx
	push rdx
	push r9
	push r10
	push r11
	push r12
	push rsi
	push rdi

	push %1
	pop r12		;; Move the data to r12
	xor r10, r10	;; r10 will be the incrementer
	mov r9, 0xF	;; r9 will grab individual bytes
	mov r11, hexOut	;; r11 holds the hex output
	add r11, 2	;; Omit 0x from write
%%btoa:			;; Byte to ascii
	xor rax, rax	;; Clear rax
	add rax, 7	;; Start at the leading byte
	sub rax, r10	;; Go from MSB to LSB
	mov rdx, 4	;; Multiply by 4
	mul rdx		;; Multiply rax by 4, move 4 bits for every increment
	mov rcx, rax	;; Set rcx to (7 - r10)*4
	mov rax, r12	;; Set rax to the hex we want to display
	shr rax, cl	;; Shift data by 4 bits per increment
	and rax, r9	;; Get the current byte
	cmp rax, 10	;; Check if hex
	jge %%hex	;; If so, treat as hex
	add rax, 0x30	;; Adjust to ascii number if not hex
	jmp %%check
%%hex:
	add rax, 0x37	;; Adjust to ascii hex
%%check:
	mov [r11], rax	;; Insert the byte to the string
	cmp r10, 7	;; See if we have reached the end
	jge %%appendNL	;; If we have, add the new line and call it good
	inc r10		;; If not, increment and start again
	inc r11
	jmp %%btoa
%%appendNL:
	inc r11		;; Go to the last position of the string
	mov rax, 0x0A	;; Insert a new line
	mov [r11], rax

	;; Print the hex
	mov rax, 1
	mov rdi, 1
	mov rsi, hexOut
	mov rdx, hexLen
	syscall

	pop rdi
	pop rsi
	pop r12
	pop r11
	pop r10
	pop r9
	pop rdx
	pop rcx
	pop rbx
	pop rax		;; Preserve stack
%endmacro
