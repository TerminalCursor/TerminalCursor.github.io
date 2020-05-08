global _start

extern printHex
extern getStr
extern printStr
extern createFile
extern deleteFile
extern appendToFile
extern writeToFile

section .data
	prompts db "Please enter your name: "
	outP db "Hello: "
	fileName db "./nameData.dat",0x00
	fileSucc db "File Write Successful"
	fileFail db "File Write Failed"

section .bss
	data times 20 resb 0x20
	charInput resb 0x20

section .text

_start:
	;;
	;; Conditional Removal of File
	;;
	lea rdi, [charInput]	;; One byte buffer
	mov rsi, 1		;; One byte
	call getStr		;; Read

	mov rdi, [charInput]	;; Load user input
	cmp rdi, 0x79		;; Check if 'y'
	je remFile		;; Remove if 'y'
	jmp wFile		;; Else get the data

remFile:
	lea rdi, [fileName]	;; Get the file name
	call deleteFile		;; Delete the file
	mov rdi, rax		;; Move return code
	call printHex		;; Print the hex of the return code in rdi
	jmp exit

wFile:
	;;
	;; Get Name
	;;
	lea rdi, [prompts]	;; Prompt location
	mov rsi, 24		;; Prompt length
	call printStr		;; Write to STDOUT

	lea rdi, [data]		;; Name location
	mov rsi, 20		;; Name max length
	call getStr		;; Read STDIN

	lea rdi, [outP]		;; Print the Hello message
	mov rsi, 7		;; Length of message
	call printStr		;; Write to STDOUT

	lea rdi, [data]		;; Location of the name
	mov rsi, 20		;; Max length
	call printStr		;; Write to STDOUT

	;; WRITE NAME TO FILE
	lea rdi, [fileName]	;; Filename - first parameter
	lea rsi, [data]		;; File data - second parameter
	mov rdx, 20		;; Buffer length - third parameter
	call appendToFile	;; Write to file, creating if doesn't exist

	cmp rax, 0x0		;; Check if the write was successful
	je fileSuccessfulWrite	;; If so, say so, else say that it didn't and exit

fileFailWrite:
	lea rdi, [fileFail]	;; Write Fail Message
	mov rsi, 17		;; Write Fail Message Length
	call printStr		;; Write to STDOUT

	jmp exit		;; Exit

fileSuccessfulWrite:
	lea rdi, [fileSucc]	;; Write Successful Message
	mov rsi, 21		;; Write Successful Message Length
	call printStr		;; Write to STDOUT

	jmp exit

exit:
	;;
	;; Exit
	;;
	mov rax, 60		;; Exit
	mov rdi, 0		;; Exit code
	syscall
