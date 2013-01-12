bits 16
org 0x1000

stage1:
		mov	sp, 0x7000

		cli
		lgdt [gdt_desc]
		mov	eax, cr0
		or	al, 1
		mov	cr0, eax
		jmp next

next:
		sti
		jmp	$
		

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
		
		times	512*17-($-$$)	db	0
