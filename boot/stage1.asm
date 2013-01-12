bits 16
org 0x1000

stage1:
		mov	si, msg
print:	lodsb
		or	al, al
		jz	next
		mov	ah, 0x0e
		int	0x10
		jmp	print

next:
		jmp	next
		
msg		db	"wow", 0
		times	512*17-($-$$)	db	0
