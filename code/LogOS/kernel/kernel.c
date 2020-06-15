#include "../drivers/screen.h"
#include "util.h"
#include "../cpu/isr.h"
#include "../cpu/idt.h"

void main() {
	isr_install();
	__asm__ __volatile__("int $2");

	/*
	clear_screen();
	kprint_at("LogOS Kernel was Successfully Loaded!", 0, 0);

	int i;
	for(i = -19; i < -19+23; i++) {
		char str[255];
		int_to_ascii(i, str);
		kprint_at(str, 0, i+20);
	}
	*/

//	kprint_at("This forces the kernel to scroll. Row 0 will disappear!", 60, 24);
//	kprint("And with this text, the kernel will scroll again, and row 1 will disappear too!");
}
