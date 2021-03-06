bits 16
org 0x7c00

NUM 	equ		0x11
DISK 	equ		0x00
POS 	equ		0x0002
HEAD 	equ		0x00		
STAGE1_ADR 	equ		0x1000
		
start:
		jmp	stage0				; Normalize the start address
		
stage0:
		cli						; disable interrupts
		xor	ax, ax				; load segment registers
		mov	ds, ax
		mov	ss, ax
		mov	es, ax
		mov	sp, 0x7c00			; set the stack pointer
		sti						; enable intterupts

		;; reset floppy disk(dl = 0) controller
		mov	ah, 0x00
		int	0x13

		;; read stage1 sectors from floopy
		mov	al, NUM				; 17 sectors to read
		mov	cx, POS				; Track/Sector
		mov	dh, HEAD			; Head
		mov	bx, STAGE1_ADR			; es:bx = 0x1000, buffer
		mov	ah, 0x02			
		int	0x13
		
		jc	hang				; jump if error

		;; print string if ok
		mov	si, msg
print:	lodsb
		or	al, al
		jz	next_stage
		mov	ah, 0x0e
		int	0x10
		jmp	print

next_stage:
		mov	bx, STAGE1_ADR
		jmp	far bx
		
hang:
		jmp	hang

		
msg		db	"ok", 0
		times	510-($-$$)	db	0
		db	0x55
		db	0xAA
