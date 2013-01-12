all: stage0.bin stage1.bin
	dd if=/dev/zero of=bin/disk.img bs=1024 count=1440
	dd if=bin/stage0.bin of=bin/disk.img conv=notrunc
	dd if=bin/stage1.bin of=bin/disk.img bs=1 seek=512

stage0.bin: boot/stage0.asm
	@mkdir -p bin
	nasm -f bin -o bin/stage0.bin boot/stage0.asm

stage1.bin: boot/stage1.asm
	@mkdir -p bin
	nasm -f bin -o bin/stage1.bin boot/stage1.asm

start: all
	qemu-system-i386 -fda bin/disk.img -boot a

clean:
	rm bin/*.bin
	rm bin/disk.img
