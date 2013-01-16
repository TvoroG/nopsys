bits 16
org 0x1000

%macro	ClrScr	0		
		mov	ax, 0003h
		int	10h
%endmacro
		
%macro	EnableA20Gate	0
		in	al, 92h
		or	al, 2
		out	92h, al
%endmacro

%macro	DisableNMI	0
		in	al, 70h
		or	al, 80h
		out	70h, al
%endmacro

%macro	SwitchToPM	0
		mov	eax, cr0
		or	al, 1
		mov	cr0, eax
%endmacro

		
stage1:
		ClrScr					; clear screen
		
		mov	si, loadmsg			; print info message 
		call print
		
		EnableA20Gate

		db	66h					; load gdt register
		lgdt [GDTR]
		
		cli						; disable all interrupts
		DisableNMI
		SwitchToPM				; switching to protected mode

		jmp	clear_label			; clear prefetch queue
clear_label:
		
		jmp	0x08:Start32

print:
		lodsb
		or	al, al
		jz	.done
		mov	ah, 0eh
		mov	bx, 0007h
		int	0x10
		jmp	print
.done:
		ret


		align	4
GDT:
NULL_descr:
		times	8	db	0
CODE_descr:
		db  0FFh,0FFh,00h,00h,00h,10011010b,11001111b,00h
DATA_descr:
		db  0FFh,0FFh,00h,00h,00h,10010010b,11001111b,00h

GDT_size equ   $-GDT    ; size of GDT

GDTR:	dw  GDT_size-1   ; limit of GDT
		dd  GDT
		
loadmsg		dd	"Loading kernel...", 13, 10, 0

		
bits 32		
Start32:
		
		jmp	$

		times	512*17-($-$$)	db	0
