SECTION MBR vstart=0x7c00
;; Initialize
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax

    mov sp, 0x7c00 ;; Stack start point, 0x7c00(MBR Start point).
    mov ax, 0xb800 ;; GraphicCard address point.
    mov gs, ax

    ;; Clean screen by 0x10 interrupt.
    mov ax, 0x0600
    mov bx, 0x0700
    ;; Set window size
    mov cx, 0x00 ;; Top left
    mov dx, 0x1950 ;; Bottom right
    int 0x10

    ;; MBR loading message
    mov byte [gs:0x00], 'M'
    mov byte [gs:0x02], 'B'
    mov byte [gs:0x04], 'R'
    mov byte [gs:0x06], ' '
    mov byte [gs:0x08], 'L'
    mov byte [gs:0x10], 'o'
    mov byte [gs:0x12], 'a'
    mov byte [gs:0x14], 'd'
    mov byte [gs:0x16], 'i'
    mov byte [gs:0x18], 'n'
    mov byte [gs:0x20], 'g'
    mov byte [gs:0x01], 0x00
    mov byte [gs:0x03], 0x00
    mov byte [gs:0x05], 0x00
    mov byte [gs:0x07], 0x00
    mov byte [gs:0x09], 0x00
    mov byte [gs:0x11], 0x00
    mov byte [gs:0x13], 0x00
    mov byte [gs:0x15], 0x00
    mov byte [gs:0x17], 0x00
    mov byte [gs:0x19], 0x00
    mov byte [gs:0x21], 0x00


    ;; The end of MBR.
    times 510 - ($ - $$) db 0
    db 0x55, 0xaa