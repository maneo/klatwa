;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; basic functions by maneo.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=
; wait 5 frames working with "use int 08"
;-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=--
waitki proc
       xor edx, edx
waituj:
       mov ah, wait_vbl
       int_eos
       add edx, eax
       cmp edx, 15
       jb waituj
ret
endp

;ÄÄ random numbers...rndhi, rndlo, seed ÄÄ

random proc
      mov ax, seed
      add ax, 3564h
      ror ax, 3
      mov seed, ax
      mov bx, rndhi
      sub bx, rndlo
      mul bx
      add bx, rndlo
      ret
random endp
;=-=-=-=-=-=-=-=-==-=-=-=-=-=
;=make sinuses and cosinuses
;=tables -255 words each
;=in:
;=out:
make_sincos_tables proc

     mov edi, sin_table
siny:fild kacik
     fsin
;     fimul mnoznik
     frndint
     fistp word ptr[edi]
     add edi, 2

     inc kacik
     mov ax, kacik
     cmp ax, 255
     jb siny

     xor ax, ax
     mov kacik, ax

     mov edi, cos_table
cosy:fild kacik
     fcos
 ;    fimul mnoznik
     frndint
     fistp word ptr [edi]
     add edi, 2

     inc kacik
     mov ax, kacik
     cmp ax, 255
     jb cosy
ret
endp
fastdiv macro 
endm
;
; x,y- wspolrzedne textu
; colorek- color textu
; wypisuje ciag znakow az do EOL
; zapamietuje adres i przy ponownym
; uruchomieniu wypisuje nastepny
;
pisz_tekx proc
        mov esi, font_address
        mov edi, scr_buffer
        ; na poczatek trzeba by bylo obliczyc offset
        ; w pamieci ekranu
        xor ebp, ebp
        xor ebx, ebx
        mov ax, x_t
        mov bx, y_t
        xchg bh, bl
        add ax, bx
        shr bx, 2
        add ax, bx
        shl ax, 1
        mov ebp, eax             ;zachowaj offset
        ;
        ; teraz sprawdzimy jaki jest pierwszy znak
        ;
        mov ah, colorek
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
linia:   mov al, [esi+ebx]
         mov dl, 10000000b
         mov dh, 8
pix_ok:  test al, dl     ;sprawdz czy w tym miejscu postawic pixel
         jz pix_fix      ; :)
;         mov ah, colorek
         mov [edi+ebp], ah
pix_fix: inc bp
         shr dl, 1
         dec dh
         jnz pix_ok

         add bp, 312
         inc bl             ;nastepna linia
         loop linia
         pop edi
         pop ebp
         add ebp, 9
         jmp check
koniec:
         mov text_address, edi
         pop edi
           ret
pisz_tekx endp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;         zmienne
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄ random proc vars ÄÄ
rndhi dw 255
rndlo dw 0
seed dw 1234h
;ÄÄ pisz_tekx proc vars ÄÄ
colorek db 255
x_t dw 100
y_t dw 96
font_address dd ?
;ÄÄ make sin and cos table ÄÄ
kacik dw 0
sinus dd ?
cosinus dd ?
sin_table dd ?
cos_table dd ?
mnoznik dw 255
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ