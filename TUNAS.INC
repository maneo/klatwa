;
; tunel-kwiat 
;
Porod proc

         mov edi, tuna_address
@licz:
         mov ax, x        ;sqrt(x*x+y*y)
         imul x
         mov bx, ax
         mov ax, y
         imul y
         add bx, ax
         mov wyn, bx
         fild wyn
         fsqrt
         frndint
         fistp wyn
;tablica nr 2

         fild x
         fild y
         fpatan
         fimul cos
         fistp wyn2
         fldpi
         fidivr wyn2
         frndint
         fistp wyn2
          

         mov ax,  wyn2
         mov bx,  wyn
         xor bh, bh
         xor ah, ah
         xor edx, edx
         mov dx, ax
         xchg bh, bl
         add dx, bx
         shl dx, 1
              

         mov [edi], edx
         add edi, 4
         inc x
         mov ax, x
         cmp ax, 161
         jnz @licz

         mov ax, -159
         mov x, ax

         inc y
         mov ax, y
         cmp ax, 101
         jnz @licz
         mov ax, -159
         mov bx, -99
         mov x, ax
         mov y, bx

  ret
porod endp
;
; tunel-pcv
;
bloody_fist proc

         mov edi, pcv_address
@blood:
         mov ax, x        ;sqrt(x*x+y*y)
         imul x
;         idiv a
         mov bx, ax
         mov ax, y
         imul y
 ;        idiv be
         add bx, ax
         mov wyn, bx
         fild wyn
         fsqrt
         fidivr radius3
         frndint
         fistp wyn
;tablica nr 2

         fild x
         fild y
         fpatan
         fimul cos
         fistp wyn2
         fldpi
         fidivr wyn2
         frndint
         fistp wyn2
          

         mov ax,  wyn2
         mov bx,  wyn
         xor bh, bh
         xor ah, ah
         xor edx, edx
         mov dx, ax
         xchg bh, bl
         add dx, bx
         shl dx, 1
              

         mov [edi], edx
         add edi, 4
         inc x
         mov ax, x
         cmp ax, 161
         jnz @blood

         mov ax, -159
         mov x, ax

         inc y
         mov ax, y
         cmp ax, 101
         jnz @blood

         mov ax, -159
         mov bx, -99
         mov x, ax
         mov y, bx
   ret
bloody_fist endp
;
; tunel-pcv ale troche inny
;
watroba proc
         mov ax, krzywe_x
         mov bx, krzywe_y
         mov x, ax
         mov y, bx
         mov dx, ax
         add dx, 320
         mov x_max, dx
         mov dx, bx
         add dx, 200
         mov y_max, dx

;         mov edi, krzywa_address
@zolc:
         mov ax, x        ;sqrt(x*x+y*y)
         imul x
         mov bx, ax
         mov ax, y
         imul y
         add bx, ax
         mov wyn, bx
         fild wyn
         fsqrt
         fidivr radius3
         frndint
         fistp wyn
;tablica nr 2

         fild x
         fild y
         fpatan
         fimul cos
         fistp wyn2
         fldpi
         fidivr wyn2
         frndint
         fistp wyn2
          

         mov ax,  wyn2
         mov bx,  wyn
         xor bh, bh
         xor ah, ah
         xor edx, edx
         mov dx, ax
         xchg bh, bl
         add dx, bx
         shl dx, 1
              

         mov [edi], edx
         add edi, 4
         inc x
         mov ax, x
         cmp ax, x_max
         jnz @zolc

         mov ax, krzywe_x
         mov x, ax

         inc y
         mov ax, y
         cmp ax, y_max
         jnz @zolc

         mov ax, -159
         mov bx, -99
         mov x, ax
         mov y, bx
   ret
watroba endp
;
; tunel-winda
;
szyb proc

         mov edi, winda_address

na_pierwsze_prosze:

         mov ax, x        ;sqrt(x*x+y*y)
         imul x
         mov bx, ax
         mov ax, y
         imul y
         sub ax, bx
         mov wyn, ax
         fild wyn
         fidivr radius
         frndint
         fistp wyn
;tablica nr 2

         fild x
         fild y
         fpatan
         fimul cos
         fistp wyn2
         fldpi
         fidivr wyn2
         frndint
         fistp wyn2
          

         mov ax,  wyn2
         mov bx,  wyn
         xor bh, bh
         xor ah, ah
         xor edx, edx
         mov dx, ax
         xchg bh, bl
         add dx, bx
         shl dx, 1
              

         mov [edi], edx
         add edi, 4
         inc x
         mov ax, x
         cmp ax, 161
         jnz na_pierwsze_prosze

         mov ax, -159
         mov x, ax

         inc y
         mov ax, y
         cmp ax, 101
         jnz na_pierwsze_prosze
         mov ax, -159
         mov bx, -99
         mov x, ax
         mov y, bx


  ret
szyb endp
;
; tunel-obrus
;
obiad proc

         mov edi, obrus_address
@jesc:
 ;        mov ax, x        ;sqrt(x*x+y*y)
 ;        imul x
 ;        mov bx, ax
         mov ax, y
         imul y
         mov wyn, ax
         fild wyn
         fsqrt
         fidivr radius2
         frndint
         fistp wyn
;tablica nr 2

         fild x
         fild y
         fpatan
         fimul cos
         fistp wyn2
         fldpi
         fidivr wyn2
         frndint
         fistp wyn2
          

         mov ax,  wyn2
         mov bx,  wyn
         xor bh, bh
         xor ah, ah
         xor edx, edx
         mov dx, ax
         xchg bh, bl
         add dx, bx
         shl dx, 1
              

         mov [edi], edx
         add edi, 4
         inc x
         mov ax, x
         cmp ax, 161
         jnz @jesc

         mov ax, -159
         mov x, ax

         inc y
         mov ax, y
         cmp ax, 101
         jnz @jesc
         mov ax, -159
         mov bx, -99
         mov x, ax
         mov y, bx
  ret
obiad endp
;
; rysuje 
;
; in: edi- offset table
oto_tunel proc

        mov dx, licznik_kl
;        mov edi, tuna_address
        xchg dh, dl
;        mov esi, texture1_address
        shl dx, 1
        mov ebp, scr_buffer
        mov ecx, 64000
        sub ebp, 2
@otuj:
        mov ebx, [edi]
        add edi, 4

        add bx, dx
        add ebp, 2
        add bx, licznik_kl

        mov ax, [esi+ebx]
        mov [ebp], ax

        dec ecx
        jnz @otuj
ret
endp
;
; rysuje 
;
; in: edi- offset table
oto2_tunel proc
        
        mov dx, licznik_kl
        neg dx
;        mov edi, tuna_address
        xchg dh, dl
;        mov esi, texture_address
        shl dx, 1
        mov ebp, scr2_buffer
        mov ecx, 64000
        sub ebp, 2
@otu:
        mov ebx, [edi]
        add edi, 4

        add bx, dx
        add ebp, 2
        sub bx, licznik_kl

        mov ax, [esi+ebx]
        mov [ebp], ax

        dec ecx
        jnz @otu
ret
endp
;
; tunelik 80x50 
; 
mala_tuba proc
   mov ax, -40
   mov bx, -25
   mov x, ax
   mov y, bx
   mov edi, tuna_mini
 mala:
   mov ax, x        ;sqrt(x*x+y*y)
   imul x
   mov bx, ax
   mov ax, y
   imul y
   add bx, ax
   mov wyn, bx
   fild wyn
   fsqrt
   frndint
   fistp wyn
;tablica nr 2
   fild x
   fild y
   fpatan
   fimul cos2
   fistp wyn_tunb
   fldpi
   fidivr wyn_tunb
   frndint
   fistp wyn_tunb
   mov ax,  wyn_tunb
   mov bx, wyn
   xor bh, bh
   xor ah, ah
   xchg bh, bl
   add ax, bx
   shl ax, 1

   mov [edi], ax
   add edi, 4
  inc x
 mov ax, x
 cmp ax, 40
  jnz mala

   mov ax, -40
   mov x, ax
  inc y
 mov ax, y
 cmp ax, 25
  jnz mala
  mov ax, -159
  mov bx, -99
  mov x, ax
  mov y, bx

ret
endp
;
; rysuje matryce dla scrolla
; 
rysuj_maly proc

   mov dx, licznik_kl
   mov edi, tuna_pattern
   xchg dh, dl
   xor ebx, ebx
   shl dx, 1
   mov esi, texture1_address
   mov ebp, tuna_mini
;   sub edi, 2
   mov ecx, 80*50
drugi:
   mov ebx, [ebp]
   add ebp, 4
   sub bx, dx
 ;  add edi, 2
   mov ax, [esi+ebx]
 mov [edi], ax
 add edi, 2
 dec ecx
 jnz drugi
ret
endp 
;
; scroll o wymiarach 80x200 na matrycy 80x50 
;
x_scroll dd 0
scroll_tuna proc

  mov esi, tuna_pattern
  mov bp, first_line
  mov ax, bp
  mov dx, 80*2
  mov edi, scr_buffer
   mul dx
  mov edx, x_scroll
   add si, ax
    shl edx, 1
   add edi, edx
  mov edx, 200
rysuj_linie:
  mov ecx, 80/2
  cli
  rep movsd
   add edi, 240*2
 cmp bp, 49
 jnz dobra_linia
    xor bp, bp
  mov esi, tuna_pattern
 jmp dalej_z_tym
dobra_linia:
  inc bp
dalej_z_tym:
  dec edx
 jnz rysuj_linie

  mov ax, first_line
 cmp ax, 49
 jnz bedzie_dobrze
    xor ax, ax
  mov first_line, ax
 jmp czas_konczyc
bedzie_dobrze:
  inc first_line
czas_konczyc:
 ret
endp
;
; scroll o wymiarach 80x200 na matrycy 80x50 
;
first_line2 dw 49
scroll_tuna_up proc

  mov esi, tuna_pattern
  mov bp, first_line2
  mov ax, bp
  mov dx, 80*2
  mov edi, scr_buffer
   mul dx
  mov edx, x_scroll
   add si, ax
    shl edx, 1
   add edi, edx
  mov edx, 200
rysuj_lini:
  mov ecx, 80/2
 rep movsd
   add edi, 240*2
;   sub esi, 160*2
 cmp bp, 49
 jnz dobra_lini
   xor bp, bp
   mov esi, tuna_pattern
;   add esi, przesun
 jmp dalej_z_ty
dobra_lini:
  inc bp
dalej_z_ty:
  dec edx
 jnz rysuj_lini

  mov ax, first_line2
 cmp ax, 0
 jnz bedzie_dobrz
  mov ax, 49
  mov first_line2, ax
 jmp czas_konczy
bedzie_dobrz:
  dec first_line2
czas_konczy:
 ret
endp
;
; zmienne
; 
  licznik_kl dw 0
  x dw -159
  radius dw 50000
  radius2 dw 256
  radius3 dw 512*4
  radius4 dw 64
  y dw -99
  cos dw 128
  cos2 dd 128
  wyn dw ?
  wyn3 dd ?
  wyn2 dw ?
  x_o equ -159
  first_line dw 0
  cur_pos dw ?
  wyn_tuna dw ?
  wyn_tunb dw ?
  krzywe_x dw -120
  krzywe_y dw -99
  x_max dw 201
  y_max dw 101
  a dw 256
  be dw 64
;
;
; 
