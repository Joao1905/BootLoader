[bits 32]

;Define constants
VIDEO_MEMORY equ 0xb8000	;Start of video_memory (80rows x 25cols grid starting at 0xb8000)
WHITE_ON_BLACK equ 0x0f

;Prints null-terminated string at protected mode. Parameters(EBX=string)
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	;put "0xb8000" inside EDX

print_string_pm_loop:
	mov al, [ebx]	;Puts the content of the address written in ebx (address of first letter) inside AL
	mov ah, WHITE_ON_BLACK	;Store text attributes in AH

	cmp al, 0
	je print_string_pm_end

	mov [edx], ax	;Puts AX (AH+AL) inside the address written in EDX
			;The video memory system will print this letter on the first
			;space of the 80x25 grid.
	add ebx, 1	;Moves to the next character of the string
	add edx, 2	;Moves to the next address of video memory

	jmp print_string_pm_loop

print_string_pm_end:
	popa
	ret		;Return from the function
