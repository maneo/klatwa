
zmien_wsp macro wspx,wspy
   mov ax, wspx
   mov bx, wspy
   mov x_t, ax
   mov y_t,  bx
   endm
;
; pisze text fontem u§ytkownika
;
pisz_tekx proc
        mov esi, offset font_address
        mov edi, text_address
        ; na poczatek trzeba by bylo obliczyc offset
        ; w pamieci ekranu
        xor eax, eax
        xor ebx, ebx
        mov bx, x_t
        mov ax, y_t
        mov dx, 320*2
        mul dx
        shl bx, 1
        add ax, bx
        mov ebp, eax             ;zachowaj offset
        ;
        ; teraz sprawdzimy jaki jest pierwszy znak
        ;
check:  push ebp
        mov bl, [edi]
        inc edi
        cmp bl, 0dh
        jnz znak_ok
        inc edi
        jmp koniec
        ;
        ; mamy znak to go trza rozrysowac
        ;
znak_ok: xor bh, bh
         shl bx, 4
         mov cx, 16
         push edi
         mov edi, text_dest
lini:    mov al, [esi+ebx]
         mov dl, 10000000b
         mov dh, 8
pix_ok:  test al, dl     ;sprawdz czy w tym miejscu postawic pixel
         jz pix_fix      ; :)
;        call dodaj
         push ax
         mov ax, text_col
         mov [edi+ebp], ax
         pop ax
pix_fix: add ebp, 2
         shr dl, 1
         dec dh
         jnz pix_ok

         add ebp, 312*2
         inc bl             ;nastepna linia
         loop lini
         pop edi
         pop ebp
         add ebp, 9*2
         jmp check
koniec:
         mov text_address, edi
         pop edi
           ret
pisz_tekx endp
dodaj:
         push ax
         push bx
         push dx
         mov ax, text_col
         and ax, 0000000000011111b
         mov bx, [edi+ebp]
         and bx, 0000000000011111b
         add ax, bx
         xor ah, ah
         cmp ax, 0000000000011111b
         jng added
         mov ax, 0000000000011111b
added:
         mov bx, text_col
         and bx, 0000011111100000b
 ;        shr bx, 5
         mov dx, [edi+ebp]
         and dx, 0000011111100000b
;         shr bx, 5
         add dx,bx
         cmp dx, 0000011111100000b
         jng added1
         mov dx, 0000011111100000b
added1:
         add ax, dx
         mov bx, text_col
         and bx, 111110000000000b
         mov dx, [edi+ebp]
         and dx, 111110000000000b
         shr dx, 11
         shr bx, 11
         add dx, bx
         cmp dx, 000000000011111b
         jng added2
         mov dx, 000000000011111b
added2:
         shl bx, 11
         shl dx, 11
         add ax, dx
         mov [edi+ebp], ax
         pop dx
         pop bx
         pop ax
ret
