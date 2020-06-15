clear_screen:
	push bp
	mov bp, sp
	pusha

	mov ah, 0x07	;; Scroll Down
	mov al, 0x00	;; 00 = Clear entire window
	mov bh, 0x0F	;; Attribute to write blank lines at top of window
	mov cx, 0x00	;; Row/col of window's top left corner
	mov dh, 0x18	;; Row of window's lower right corner
	mov dl, 0x4f	;; Col of window's lower right corner
	int 0x10

	popa
	mov sp, bp
	pop bp
	ret

move_cursor:
	push bp
	mov bp, sp
	pusha

	mov dx, [bp+4]	;; Row/Column
	mov ah, 0x02	;; Set cursor position
	mov bh, 0x00	;; Page number (irrelevant right now)
	int 0x10

	popa
	mov sp, bp
	pop bp
	ret
