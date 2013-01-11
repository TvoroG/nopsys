all: stage0.bin
	dd if=/dev/zero of=bin/disk.img bs=1024 count=1440
	dd if=bin/stage0.bin of=bin/disk.img conv=notrunc

stage0.bin: boot/stage0.asm
	mkdir -p bin
	nasm -f bin -o bin/stage0.bin boot/stage0.asm

start: all
	qemu-system-i386 -fda bin/disk.img -boot a

clean:
	rm bin/*.bin
	rm bin/disk.img
