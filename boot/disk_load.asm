;Load DH sectors to ES:BX from drive DL
disk_load:
	push dx		;Store DX so we know how many sectors were
			; requested to be read (and compare to how
			; many were actually read)
	mov ah, 0x02	;Read Hard Disk BIOS function
	mov al, dh	;Read DH sectors
	mov ch, 0x00	;Select cylinder 0 of HD
	mov dh, 0x00	;Select Head 0
	mov cl, 0x02	;Start reading from 2nd sector (BIOS is in 1st)
	int 0x13	;Call BIOS interrupt

	jc disk_error	;Jump if error (carry flag is set)

	pop dx		;Restore DX (sectors requested)
	cmp dh, al	;AL contains how many sectors were actually
			; read, so if they diverge, an error ocurred
	jne disk_error	;Jump not Equal - Error
	ret

disk_error:

	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

DISK_ERROR_MSG db "Error reading disk!", 0










