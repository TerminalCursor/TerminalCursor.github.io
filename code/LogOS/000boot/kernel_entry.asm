[bits 32]
[extern main]	; Same 'main' as found in kernel.c
call main	; Call c function, linker will know where it is in memory
jmp $
