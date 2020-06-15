disk_load:
	pusha

	push dx

	mov ah, 0x02	;; Read
	mov al, dh	;; Number of sectors to read
	mov cl, 0x02	;; First available sector (0x01) is boot
	mov ch, 0x00	;; Cylinder
	mov dh, 0x00	;; Head number
	int 0x13

	jc disk_error	;; If there is a disk error, output the hex

	pop dx
	cmp al, dh	;; BIOS sets 'al' to the number of sectors read
	jne sectors_error	;; If there is an incorrect number of sectors read, outupt it
	popa
	ret

disk_error:
	mov bx, DISK_ERROR	;; Move the disk error message to be written
	call print
	call print_nl
	mov dh, ah		;; Print the error code
	call print_hex
	jmp disk_loop		;; Halt operation

sectors_error:
	mov bx, SECTORS_ERROR	;; Move the sectors error message to be written
	call print

disk_loop:
	jmp $			;; Halt operation

;; Literals to be written to the image
DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
