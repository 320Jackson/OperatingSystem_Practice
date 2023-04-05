SECTION MBR vstart=0x7c00
    ;; Initalize
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax

    mov sp, 0x7c00 ;; Stack start point, 0x7c00.
    mov ax, 0xb800 ;; GraphicCard address point.
    mov gs, ax

    ;; Clean screan
    mov ax, 0600h
    mov bx, 0700h
    ;; Set window size
    mov cx, 0
    mov dx, 1950h
    int 0x10
    call MBR_loading
    nop
    call DiskOperate
    jmp 0x900

    times 510 - ($ - $$) db 0
    db 0x55, 0xaa ;; MBR rules(Last in block should write 55aa.)

    ;; MBR loading message.
    MBR_loading:
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
        ret

    ;; Read hardisk
    DiskOperate:
        mov eax, 0x1 ;; LBA address start point.
        mov bx, 0x900 ;; Loader address.
        mov cx, 1 ;; Read sector number
        call ReadDisk
        ret

    ReadDisk:
        mov esi, eax
        mov di, cx
        ;; Get reading sector number.
        mov dx, 0x1f2 ;; Primary disk sector count.
        mov al, cl
        out dx, al

        mov eax, esi

        ;; LBA address save as 0x1f3~0x1f6
        mov dx, 0x1f3
        out dx, al
        mov cl, 8
        shr eax, cl
        mov dx, 0x1f4
        out dx, al
        shr eax, cl
        mov dx, 0x1f5
        out dx, al
        shr eax, cl

        and al, 0x0f ;; LBA 24~27bits = 1111
        or al, 0xe0 ;; LBA 4~7bits = 1110(LBA Mode)
        mov dx, 0x1f6
        out dx, al

        ;; Send read command to port.
        mov dx, 0x1f7
        mov al, 0x20
        out dx, al
    
    ;; Cheak disk state.
    .not_ready:
        nop
        in al, dx
        and al, 0x88 ;; If 3rd bit = 1, Ready to go. 7th bit = 1, Still working
        cmp al, 0x08
        jnz .not_ready

        ;; Read data from 0x1f0
        mov ax, di
        mov dx, 0x100
        mul dx
        mov cx, ax
        ;; di = read sector number, 1 sector = 512 bytes
        ;; Need di*512/2 times to read all data.
        mov dx, 0x1f0

    .success:
        in ax, dx
        mov [bx], ax
        add bx, 2
        loop .success
        ret