;Bootsector with 32-bit protected mode implemented

[org 0x7c00]
KERNEL_OFFSET equ 0x1000	;Memory offset to which the kernel will
				; be loaded

mov [BOOT_DRIVE], dl	;The hard drive where our boot is located is
			; stored inside DL. When passing our kernel
			; from the hard disk to memory, we'll need
			; to know in which hard drive the kernel is
			; (and it's in the same as the boot's)

mov bp, 0x9000		;Set the 16-bit mode stack
mov sp, bp	

mov bx, MSG_REAL_MODE
call print_string	;Use 16-bit print routine

call load_kernel	;Load kernel

call switch_to_pm	;Note that there's no "ret" in this function

jmp $

%include "boot/print_string.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/print_string_pm.asm"
%include "boot/switch_to_pm.asm"
%include "boot/clear_screen_pm.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL	;Print message
	call print_string

	mov bx, KERNEL_OFFSET	;Setting up "disk_load" params. Here,
	mov dh, 15		; we'll load the first 15 sectors (sector 
	mov dl, [BOOT_DRIVE]	; 2 to 16) from the same disk of the boot
	call disk_load		; into the memory address KERNEL_OFFSET

	ret	

[bits 32]
;This is where we arrive after switching to and initialising protected mode
BEGIN_PM:

	mov ebx, MSG_PROT_MODE
	call print_string_pm	;Use 32-bit print routine
	mov ebx, 480	
	call clear_screen_pm	;Clear screen

	call KERNEL_OFFSET	;Jump to the address where our kernel was
				; loaded.
	jmp $

;Global Variables
BOOT_DRIVE db 0 ;Just create variable
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

;Bootsector size adjuster and magic number
times 510-($-$$) db 0
dw 0xaa55
