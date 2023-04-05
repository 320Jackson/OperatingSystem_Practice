; This MBR program is called the BIOS interrupt to show the message.
; MBR program start from '0x7c00'. This is rule!!
SECTION MBR vstart=0x7c00
    ; Initialize caches.
    ; cs:ip --> 0:0x7c00, so we use cs to initialize other reg
    mov ax, cs

    ; sreg can't initialize by immediate, so we use a universal reg to transit.
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    
    ; Register for stack, express the following 0x7c00 are safe.
    mov sp, 0x7c00

    ; Clear screen, use 0x06 function.
    mov ax, 0x600
    mov bx, 0x700

    ; Top left (0, 0), right bottom (80, 25)
    ; When your computer boot, basic display mode are 25 lines / 80 columns or 25 lines / 40 columns
    mov cx, 0       ; Top left
    mov dx, 0x184f  ; Right bottom
    int 0x10        ; Call BIOS interrupt 0x10

    ; Get cursor, to print charactor.
    mov ah, 3   ; Get cursor function number, save to ah reg.
    mov bh, 0   ; bh get page number.

    int 0x10    ; Call BIOS interrupt 0x10

    ; Show string
    mov ax, msg
    mov bp, ax  ; es:bp express string's starting address
                ; Now cs = es
    
    mov cx, 10  ; String length
    mov ax, 0x1301  ; Set function number 13, to show string.(ah)
                    ; 01 is function's attribute.(al)
    mov bx, 0x2 ; bh = page number, bl = attribute.
    int 0x10

    msg db "MBR hello!"
    times 510 - ($ - $$) db 0 ; Filling 0 to unuse space.
    db 0x55, 0xaa ; Set this drive is active.