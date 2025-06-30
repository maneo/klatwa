;
; blurr for 16bpp mode pix
;
blurrm proc
    add esi, 640
    mov ecx, 320*200-200
@blurrm:
    mov ax, [esi]
    mov bx, [esi+2]
    and ax,00000000000011111b
    and bx,00000000000011111b
    add ax, bx
    mov bx, [esi-640]
    and bx,00000000000011111b
    add ax, bx
    mov bx, [esi+640]
    and bx,00000000000011111b
    add ax, bx
    shr ax, 2
    mov [edi], ax

    mov ax, [esi]
    mov bx, [esi+2]
    and ax,00000011111100000b
    and bx,00000011111100000b
    shr ax, 5
    shr bx, 5
    add ax, bx
    mov bx, [esi+640]
    and bx,00000011111100000b
    shr bx, 5
    add ax, bx
    mov bx, [esi-640]
    and bx,00000011111100000b
    shr bx, 5
    add ax, bx
    shr ax, 2
    shl ax, 5
    mov bx, [edi]
    add ax, bx

    mov [edi], ax
    mov ax, [esi-2]
    mov bx, [esi+2]
    and bx, 01111100000000000b
    and ax, 01111100000000000b
    shr ax, 11
    shr bx, 11
    add ax, bx
    mov bx, [esi+640]
    and bx, 01111100000000000b
    shr bx, 11
    add ax, bx
    mov bx, [esi-640]
    and bx, 01111100000000000b
    shr bx, 11
    add ax, bx
    shr ax, 2
    shl ax, 11

    mov bx, [edi]
    add ax, bx
    mov [edi], ax
    add esi, 2
    add edi, 2
    dec ecx
  jnz @blurrm
ret
endp
