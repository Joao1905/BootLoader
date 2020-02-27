;To hop from 16-bit mode to 32-bit proteted mode, we must define a GDT. It will 
; replace the offset method used in 16-bit mode and will also implement memory
; segments, which have attributes (such as write permissions). a GDT and a GDT
; descriptor are needed to implement the protected mode

;Global Descriptor Table (GDT)
gdt_start:	;Usefull for us to have the exact address where GDT starts

gdt_null:	;Mandatory null descriptor
	dd 0x0	;dd = 32 bits
	dd 0x0

gdt_code:	;Code segment descriptor
	dw 0xffff	; Limit (bits 0-15)
	dw 0x0		; Base (bits 0-15)
	db 0x0		; Base (bits 16-23)
	db 10011010b	; 1st Flags and type flags
	db 11001111b	; 2nd Flags and limits (16-19)
	db 0x0		; Base (24-31)

gdt_data:       ;Data segment descriptor
        dw 0xffff       ; Limit (bits 0-15)
        dw 0x0          ; Base (bits 0-15)
        db 0x0          ; Base (bits 16-23)
        db 10010010b    ; 1st Flags and type flags
        db 11001111b    ; 2nd Flags and limits (16-19)
        db 0x0          ; Base (24-31)

gdt_end:	;With a start and an end label we can calculate the size of our GDT

;GDT Descriptor (requires both the GDT size and start point)
gdt_descriptor:
	dw gdt_end - gdt_start -1	;Size of GDT, always true size minus 1
	dd gdt_start			;Initial address of our GDT

;Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0 x0 -> NULL ; 0x08 -> CODE ; 0 x10 -> DATA )
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start



