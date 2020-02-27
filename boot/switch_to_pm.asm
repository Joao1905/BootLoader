[bits 16]

switch_to_pm:

	cli	;We must switch off BIOS interrupts until we have
		; set up the protected mode interrup vector

	lgdt [gdt_descriptor]	;Load the global descriptor table, which defines
				; the protected mode segments (code and date)

	mov eax, cr0		;To switch to protected mode, we set the first
	or eax, 0x1		; bit of CR0 (control register) to 1. By using
	mov cr0, eax		; "or", we don't alter other bits of CR0

	jmp CODE_SEG:init_pm	;Make a far jump (a jump to a new segment) to the
				; 32-bit code. A far jump also forces the CPU to
				; flush its cache of paralel instructions, which
				; could cause problems. Global var defined in gdt

[bits 32]
; Initialize registers and the stack once in PM
init_pm:
	
	mov ax, DATA_SEG 	;Now in PM, our old segments are meaningless,
	mov ds, ax 		; so we point our segment registers to the
	mov ss, ax 		; data selector we defined in our GDT. Can't
	mov es, ax		; pass values directly to segment registers, so
	mov fs, ax		; we must pass them to AX first
	mov gs, ax

	mov ebp, 0x90000	;Update the stack position to make sure it is
	mov esp, ebp		; right at the top of free space (grows downward)
	
	call BEGIN_PM		;Return to our bootloader, now in 32-bit mode








