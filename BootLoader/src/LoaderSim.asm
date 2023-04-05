;; This program is a boot loader simulator.
SECTION BOOT vstart=0x900
    ;; Output boot loader message.
    mov byte [gs:0x00], 'L'
    mov byte [gs:0x02], 'o'
    mov byte [gs:0x04], 'a'
    mov byte [gs:0x06], 'd'
    mov byte [gs:0x08], 'e'
    mov byte [gs:0x10], 'r'
    mov byte [gs:0x01], 0x00
    mov byte [gs:0x03], 0x00
    mov byte [gs:0x05], 0x00
    mov byte [gs:0x07], 0x00
    mov byte [gs:0x09], 0x00
    mov byte [gs:0x11], 0x00

    jmp $ ;; loop