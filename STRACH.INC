;
; wrzuca do bufora pomniejszony obrazek 320x200 (np. ekran)
;
skrzat proc
   mov esi, scr_buffer
   mov edi, maly_buffer      ;80x50
  mov dx, 25*2
draw_screen:
  call draw_line
  add esi, 3*640
  dec dx
jnz draw_screen
ret
draw_line:
   mov cx, 80
draluj:
   mov ax, [esi]
   mov [edi], ax
    add esi, 4*2
    add edi, 2
   dec cx
 jnz draluj
ret
endp
;
; draw sprite
;
;     in: ax, bx - [x_lenght, y_lenght]
;         edx, ecx - [x, y]
;
     dsx dd ?
     zmienna dd ?
     mnoznik dw 640
D_Spr PROC

   mov ebp, eax
;   mov edi, scr_buffer
   mov ax, 320*2
   mov zmienna, ecx
   fild zmienna
   fimul mnoznik
   fistp zmienna
   mov ecx, zmienna
   shl dx, 1
   add edx, ecx
   add edi, edx
   mov eax, ebp

   mov ecx, 320
   sub ecx, eax
   shl cx, 1
   mov dsx, ecx

d_sa:
    mov cx, ax
d_sb:
    mov dx, [esi]
    add esi, 2
    cmp  dx, 0
   jz _ie
    mov [edi], dx
_ie:
    add edi,2
    dec cx
    jnz d_sb
    add edi, dsx
    dec bx
   jnz d_sa

ret
endp
;
; rysuje z zerami
;
D_Sp PROC

   mov ebp, eax
;   mov edi, scr_buffer
   mov ax, 320*2
   mov zmienna, ecx
   fild zmienna
   fimul mnoznik
   fistp zmienna
   mov ecx, zmienna
   shl dx, 1
   add edx, ecx
   add edi, edx
   mov eax, ebp

   mov ecx, 320
   sub ecx, eax
   shl cx, 1
   mov dsx, ecx

d_saaa:
    mov cx, ax
d_sba:
    mov dx, [esi]
    add esi, 2
    mov [edi], dx
_iea:
    add edi,2
    dec cx
    jnz d_sba
    add edi, dsx
    dec bx
   jnz d_saaa
ret
endp
;
; draw sprite [y,x]
;
;     in: ax, bx - [x_lenght, y_lenght]
;         edx, ecx - [x, y]
;
D_S_O PROC

   mov ebp, eax
   mov edi, scr_buffer

   mov ax, 320*2
   xchg ecx, edx
   mul dx
   mov edx, eax
   shl cx, 1
   add edx, ecx
   mov eax, ebp
   add edi, edx

   mov ecx, 320
   sub ecx, ebx
   shl cx, 1
   mov dsx, ecx

d_saa:
    mov cx, bx
    push esi
d_sbb:
    mov dx, [esi]
    add esi, 160
    mov [edi], dx
_iee:
    add edi,2
    dec cx
    jnz d_sbb
    add edi, dsx
    pop esi
    add esi, 2
    dec ax
   jnz d_saa

ret
endp

;
; uzyteczne macro wrzuca do odpowiednich rejestrow parametry dla d_spr
;
sizes macro x_length,y_length,x_coord,y_coord,zrodlo, dest
     mov eax, x_length
     mov ebx, y_length
     mov edx, x_coord
     mov ecx, y_coord
     mov esi, zrodlo
     mov edi, dest
endm
