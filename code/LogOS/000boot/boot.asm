[org 0x7c00]	; Bootloader Offset
KERNEL_OFFSET equ 0x1000	;; Same one used as when we linked kernel

	mov [BOOT_DRIVE], dl	;; Remember that the BIOS sets us the boot drive in 'dl' on boot
	mov bp, 0x9000		;; Set the stack safely away
	mov sp, bp

	call clear_screen	;; Clear the screen
	push 0x0000		;; Top Left
	call move_cursor	;; Move the cursor to the top left

	mov bx, MSG_REAL_MODE	;; Move the message pointer to the bx register
	call print 		;; Write the message
	call print_nl		;;  w/ new line

	call load_kernel	;; Load the kernel

	mov ah, 0x00	;; Get character input
	int 0x16	;;

	call switch_to_pm	;; Switch to 32bit protected mode
	jmp $ 			;; this will actually never be executed since the program should never return here

;;
;; Boot Files
;;
%include "000boot/16/color.asm"
%include "000boot/16/print.asm"
%include "000boot/16/print_hex.asm"
%include "000boot/16/disk.asm"
%include "000boot/32/gdt.asm"
%include "000boot/32/print.asm"
%include "000boot/32/switch.asm"

;;
;; Loading the Kernel
;;
[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL	;; Print that the kernel loading process has started
	call print		;; Print
	call print_nl		;;  w/ New Line

	mov bx, KERNEL_OFFSET	;; Read from disk and store in 0x1000
	mov dh, 16		;; Num to read
	mov dl, [BOOT_DRIVE]	;; Move boot drive number to dl
	call disk_load		;; Load the kernel code
	ret

;;
;; Loading the Kernel
[bits 32]
BEGIN_PM: ; after the switch we will get here
	mov ebx, MSG_PROT_MODE	;; Message to output - 32 mode enabled
	call print_string_pm 	;; Note that this will be written at the top left corner
	call KERNEL_OFFSET	;; Give control to kernel
	jmp $	;; Infinite loop when kernel returns control

;; Literals stored in the image
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started LogOS in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded LogOS in 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading LogOS kernel into memory", 0

;; Boot Sector Marker
times 0x1FE-($-$$) db 0
dw 0xaa55
