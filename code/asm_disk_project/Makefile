SRC=main
OUT=build
EXTRAS=data.dat
SOURCE=main.asm debug.asm disk.asm useful.asm
build: ${SRC}.asm
	nasm -f elf64 -o ${SRC}.o ${SRC}.asm
	ld ${SRC}.o -o ${OUT}
	chmod +x ${OUT}

clean:
	rm -rf ${OUT} ${SRC}.o ${EXTRAS}

backup:
	cp Makefile ${SOURCE} ./backups.d
