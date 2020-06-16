print_hex:
	pusha
	mov cx, 0	;; 'cx' will be our incrementer

hex_loop:
	cmp cx, 4	;; Check to see if we are at the last character
	je end		;; If so, end

	mov ax, dx	;; Move the character (in dx) to ax
	and ax, 0x000f	;; Get the specific byte
	add al, 0x30	;; Convert to ASCII 0-9 and special characters
	cmp al, 0x39	;; If it is not in the special characters
	jle step2	;; Continue operation
	add al, 7	;; Otherwise adjust to Ascii A-F

step2:
	mov bx, HEX_OUT + 5	;; Point BX to the end of the hex string
	sub bx, cx		;; Go back to the current hex being read
	mov [bx], al		;; Move the converted ASCII to memory
	ror dx, 4		;; Get the next byte

	add cx, 1		;; Increment
	jmp hex_loop		;; Start over

end:
	mov bx, HEX_OUT		;; bx is where the pointer goes for the print
	call print		;; Call print from 16 bit print routine
	popa
	ret

HEX_OUT:
	db '0x0000', 0
