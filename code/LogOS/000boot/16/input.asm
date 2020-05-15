getch:
	mov ah, 0x00	;; Get keystroke (int 16h)
	int 0x16
