;Prints a null-terminated string. Parameters(BX=string)
print_string:
	pusha	;Push the value of every register to the top of the stack

print_string_loop:
	mov al, [bx]	;Puts the content of the address written in BX inside AL
	cmp al, 0	;Compare al and 0. by default, 0 size is 1 byte (don't 
				;need to specify since al is also 1 byte long)
	je print_string_end	;If AL=0, jumps to the end

	mov ah, 0x0e	;If AL!=0 (not the end of the string), set tty mode and
	int 0x10	;Execute BIOS interupt call

	add bx, 1	;Add 1 to the address writen in BX (address of current letter)
	jmp print_string_loop	;Next iteration

print_string_end:	
	popa	;Retrieve every register's value from the top of the stack
	ret	;"call" pushes the current address and jump, while "ret" pops
		;that address and jumps back
