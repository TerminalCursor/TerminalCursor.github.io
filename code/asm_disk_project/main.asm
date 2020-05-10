section .data
	NL db 0x0A

section .bss
	fileData resb 201

section .text
	global _start

%include "useful.asm"
%include "disk.asm"
%include "debug.asm"

dumpAll:
	call printNl
	;;;
	;;; Dump Register Contents
	;;;
	PRINT "RAX: "		;; Output the contents of rax (file handle)
	dumpRegister rax
	PRINT "RBX: "		;; Output the contents of rax (file handle)
	dumpRegister rbx
	PRINT "RCX: "		;; Output the contents of rax (file handle)
	dumpRegister rcx
	PRINT "RDX: "		;; Output the contents of rax (file handle)
	dumpRegister rdx
	PRINT "RDI: "		;; Output the contents of rax (file handle)
	dumpRegister rdi
	PRINT "RSI: "		;; Output the contents of rax (file handle)
	dumpRegister rsi
	PRINT "RSP: "		;; Output the contents of rax (file handle)
	dumpRegister rsp
	PRINT "RBP: "		;; Output the contents of rax (file handle)
	dumpRegister rbp
	call printNl
	ret

_start:

	fopen "./data.dat", 01	;; Open the file in 01-WT mode
	push rax		;; Push rax to the stack to preserve the file handle

	call dumpAll

	pop rax			;; Restore rax
	cmp rax, 0xFFFFFFFE	;; Open sets rax to 0xFFFFFFFE if there is no file
	jne regularOperation	;; If there is a file, non 0xFFFFFFFE, continue as usual

createIfNotExist:
	fcreate "./data.dat", 644q	;; Create an empty file
	fopen "./data.dat", 01		;; Open to write
	push rax			;; Preserve file handle

regularOperation:

	fwrite "Testing out macro"	;; Write data to file
	fwrite 0x0A			;; Write new line
	fwrite "Writing some more"	;; Write data to file

	fclose	rax			;; Close the file

	fopen "./data.dat", 00		;; Open the file in RD mode

	fread fileData, 200		;; Read 200 bytes of a file

	fclose	rax			;; Close file

	_syscall_write fileData, 200	;; Write the file data

	call printNl			;; Add a new line

;; Exit, TODO: make this a macro in the useful.asm
exit:
	mov rax, 60		;; Exit
	mov rdi, 0		;; Exit code
	call dumpAll
	syscall

;; Print a new line, TODO: make this a macro in the useful.asm
printNl:
	push rax
	push rdi
	push rsi
	push rdx

	mov rax, 1
	mov rdi, 1
	mov rsi, NL
	mov rdx, 1
	syscall

	pop rdx
	pop rsi
	pop rdi
	pop rax
	ret
