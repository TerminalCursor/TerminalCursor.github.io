print:
    pusha

;; keep this in mind:
;; while (string[i] != 0) { print string[i]; i++ }

;; the comparison for string end (null byte)
start:
    mov al, [bx]	;; 'bx' is the base address for the string
    cmp al, 0		;; Compare with null byte
    je done		;; If null, exit

    ; the part where we print with the BIOS help
    mov ah, 0x0e	;; Teletype output (al is the character to output)
    int 0x10 		;; 'al' already contains the char

    ; increment pointer and do next loop
    add bx, 1		;; Next character
    jmp start

done:
    popa
    ret



print_nl:
    pusha

    mov ah, 0x0e	;; Teletype output
    mov al, 0x0a	;; Newline Char
    int 0x10
    mov al, 0x0d	;; Carriage Return
    int 0x10

    popa
    ret
