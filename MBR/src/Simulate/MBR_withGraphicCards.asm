; This program is a MBR testing program with graphic cards support.
; MBR program start at 0x7c00, This is rules!!
SECTION MBR vstart=0x7c00
    ; Initialize register.
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax

    ; Let sp point to 0x7c00 and ax point to 0xb800(Graphic card)
    mov sp, 0x7c00
    mov ax, 0xb800
    mov gs, ax

    ; Clean the screen
    mov ax, 0600h
    mov bx, 0700h
    ; Set the window size (cl, ch) top left, (dl, dh) right bottom.
    mov cx, 0
    mov dx, 184fh
    int 10h

    mov byte [gs:0x00], '1'
    mov byte [gs:0x01], 0xA4

    mov byte [gs:0x02], 'M'
    mov byte [gs:0x03], 0x00

    hlt ; This command is halt, it can let CPU work into halt mode.

    times 510 - ($ - $$) db 0
    db 0x55, 0xaa
