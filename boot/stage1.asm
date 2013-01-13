bits 16
org 0x1000

%macro	LGDT32	1
		db	66h
		db	8dh
		db	1eh
		dd	$1
		db	0fh
		db	01h
		db	17h
%endmacro

%macro	FJMP32	2
		db	66h
		db	0eah
		dd	$2
		dw	$1
%endmacro		
		
stage1:
		LGDT32	fword ptr gdt_desc

		mov	eax, cr0
		or	ax, 1
		mov	cr0, eax
		jmp	$+2

		FJMP32	08h, Start32

		
		align	4
gdt:	
		;; GDT[0]: Null entry
		dd	0
		dd	0
		;; GDT[1]: read-only code, base address of 0xf000
		dw	0x9000				; Limit[15:0]
		dw	0x000f				; Base[15:0]
		db	0x00				; Base[23:16]
		db	10011010b			; P(1), DPL(00), S(1), 1, C(0), R(1), A(0)
		db	11000000b			; G(1), D(1), 0, 0, Limit[19:16]
		db	0x00				; Base[31:24]
		;; GDT[2]: Writeable data segment
		dw	0xff47				; Limit[15:0]
		dw	0x0080				; Base[15:00]
		db	0x00				; Base[23:16]
		db	10010010b			; P(1), DPL(00), S(1), 0, E(0), W(1), A(0)
		db	01000000b			; G(1), B(1), 0, 0, Limit[19:16]
		db	0x00				; Base[31:24]
		
GDT_SIZE	equ		$ - gdt
gdt_desc:	dw		GDT_SIZE - 1
			dd		gdt

Start32:
		mov	ax, 10h
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		mov	ss, ax

		mov	esp, 0xf000
		
		
		times	512*17-($-$$)	db	0
