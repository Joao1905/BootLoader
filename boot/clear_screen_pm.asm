[bits 32]

;Clears screen. Parameters(EBX=starting point)
clear_screen_pm:
        pusha

clear_screen_pm_loop:
        mov [0xb8000+ebx], byte 0
        add ebx, 2
        cmp ebx, 1800
        jg clear_screen_pm_end
        jmp clear_screen_pm_loop

clear_screen_pm_end:
        popa
        ret

