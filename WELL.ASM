;wersja ekskluzywna specjalnie dla mesiaha


;
;\ gí¢wny source intra64k "klÜtwa" code by nazgul and maneo \
;
.386
code32 segment public use32 page 'code'
Assume cs:code32, ds:code32, es:code32
;
;\ BIBLIOTEKI \
  include eos.inc         ;kelner
  include vesa.inc        ;biblioteka do vesy by maneo/delirium^tB
  include prerout.inq     ;procedurki do przygotowujace i pobierajace dane
                          ;+ tworzenie textur i map odsíoniëç
  include routines.inq    ;przydatne procedury
  include tunas.inc       ;tunele
;
;\ INNE \
  include font.inc        ;zaincludowany font
  include pnacze2.inc     ;panel
  include mp5m.inc        ;tablica odsloniec (320x200)
  include textrm.inc      ;tablica odsloniec (256x256)
  include klatwa.inc      ;logo "klÜtwa" by maneo
;  include mneo.inc
 ; include nzgul.inc
  ;include unsen.inc
 ; include kllo.inc
  include textura1.inc    ;ripowana textura
  include textura2.inc    ;ripowana textura
;
;\ ZMIENNE \
   timer dw 0             ;do odslaniania
;
;\ PROGRAM \
start32:
        ;/ preroutines /

        sti                    ;ustaw przerwania
;        cld                    ;zeruj kierunek
        call alokuj_pamiec         ;alokuj pamiec
        call load_data             ;pobierz pliki (modul) +autodetect sound
        call textury_rob           ;przygotuj textury
        call tablice_ods           ;i tablice odsloniec
        call rgb_tab               ;pomoc do dodawania ekranow
        call porod                 ;tablica do kwiata
        call bloody_fist           ;tablica do pcv
        call szyb                  ;tablica do windy
        call obiad                 ;tablica do obrusa
        call mala_tuba             ;tablica do malego tunelu
        call texture               ;przygotowuje panel
        mov edi, krzywa_address    ;tablica dla krzywego pcv
        call watroba
        mov edi, krzywb_address    ;tablica dla drugiego krzywego
        mov ax, -180
        mov krzywe_x, ax
        call watroba

        mov edi, grey1_address
        mov esi, texture_address
        call grey_tex              ;przelicza texturki na odcienie szarosci
        mov edi, grey2_address
        mov esi, texture1_address  ;i tu druga
        call grey_tex

        mov edi, nowy_szary        ;ze wzgledu na problemy robi zapas kopie
        mov esi, grey1_address
        mov ecx, 65536/2
        rep movsd


        mov ah, play_module         ;inicjalizuje playera
        int_eos

        mov cx, 10eh
        call sprawdz_vese           ;sprawdza czy jest vesa

        mov bx, 10eh
        call init_vesa_mode         ;i uruchamia nasz tryb 320x200x16bpp

        clrscr scr_buffer           ;czysci bufor ekranu
        mov edi, scr_buffer
        mov text_dest, edi          ;text destination to bufor ekranu

;------------------------------
;
;
; !the begining!
;
;
;------------------------------
;jmp klk
        czekaj 0, 1                 ;routynka by Nazgul czeka na pattern i rzÜd
        mov edi, text_address
        mov text_2 , edi
        mov ax, 00000100001000001b
        mov text_col, ax
        call fade_in                ;wjazd pierwszego textu
        czekaj 0,10                 ;czeka chwile i
        call fade_out               ;zciema
        czekaj 0,12
        mov edi, text_address
        mov text_2, edi
        call fade_in                ;drugi
        czekaj 0, 22
        call fade_out
        czekaj 0, 24
        mov edi, text_address
        mov text_2, edi
        call fade_in                ;trzeci
        czekaj 0, 34
        call fade_out
        czekaj 0, 36
        mov edi, text_address
        mov text_2, edi
        zmien_wsp 100, 90
        call fade_in                ;czwarty
        czekaj 0, 46
        call fade_out
        czekaj 0, 48
        zmien_wsp 125,90
        mov edi, text_address
        mov text_2, edi
        call fade_i_logo            ;logo
        czekaj 1, 0
 ;       call fade_o_logo
klk:

        mov ecx, 18432              ;bufor na texty 72x256*2 jest czyszczony
        xor ax, ax
        mov edi, text_show
        rep stosw

;-------------------------------
;
;
;
; the krowa czyli czas zaczac
;
;
;-------------------------------

      clrscr grey_address            ;czysc bufor
      mov edi,  grey_address         ;ktory jest czyms na ksztaít scr_bufor
      mov esi,  scr_buffer           ;tutaj jako zrodla
      mov ebx,  ods_address          ;tablica odsíoniec

tylkoo:
      push edi                       ;odloz poczÜtkowe warotsci na stos
      push esi
      push ebx
      xor ax, ax
      mov cx, 64000                  ;ekran 320x200 pixli
tylko:
      mov al, [ebx]
;      inc ebx
      cmp ax, timer                  ;jezeli timer jest wiekszy to nie
      jg nie_tylko
      mov ax, [esi]
      mov [edi], ax
nie_tylko:
      inc ebx
      add esi, 2
      add edi, 2
      xor ax, ax
      dec cx
      jnz tylko

      mov edi, tuna_address          ;adres tablicy efektu
      mov esi, grey1_address         ;adres textury dla efektu
      call oto_tunel                 ;rysuj efekt
      inc licznik_kl
      inc licznik_kl
                                     ;makro wstawia odpowiednie wartosci
                                     ; do rejestrow dla procki d_spr
      sizes 256,200,0,0,panel_address,scr_buffer
      call d_spr                     ;rysuj panel
      inc timer

      mov esi, grey_address          ;wrzuc zastepczy bufor na ekran
      call draw_buffer
;      mov ah, wait_vbl               ;czekaj na ramke
;     int_eos

       pop ebx                       ;przywroc wartosci rejestrom
       pop esi                       ;z adresami
       pop edi

       mov ax, 0100h
       int 16h
       jnz papa                      ;czy wcisniëto esc?
;       check_esc

       mov ah,[Current_Pattern];     ;\
       mov dl,[Current_Note]         ; \
      cmp ah, 2                      ;  \
       jne tylkoo                    ;  / routynka do synchronizacji
      cmp dl, 5                      ; /
       jb tylkoo                     ;/

       mov ax, 0ffffh
       mov text_col, ax
       partia texture1_address     ;makro ktore robi nam buforek z textem
                                   ;texturuje je texturÜ z podanego bufora

       xor ax, ax                  ;wyzyrej timer...
       mov timer, ax
;--------------------------------
;
;
; text pierwszy
;
;
;--------------------------------

       mov edi, text_show         ; bufor ktory bëde rysowaí
       mov ebx, text_buffer       ; bufor z partiÜ textu do wyûwietlenia
       mov esi, mp2_address       ; tablica odsíoniëc
poezja1:
       push edi
       push esi
       push ebx
       mov ecx, 18432             ;bufor ma wielkosc 72x256*2
byc_albo:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _nie_byc
       mov ax, [ebx]
       mov [edi], ax
_nie_byc:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz byc_albo

       mov ah, wait_vbl
     int_eos

      mov edi, tuna_address
      mov esi, grey1_address
      call oto_tunel
      inc licznik_kl
      inc licznik_kl
      sizes 256,200,0,0,panel_address, scr_buffer
     call d_spr
      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr                            ;rysuje bufor do ktorego odslaniamy

      mov esi, scr_buffer
      call draw_buffer                      ;rysuje go na ekranie

      inc timer

      pop ebx
      pop esi
      pop edi

      mov ax, 0100h
      int 16h
       jnz papa

       mov ah,[Current_Pattern];
       mov dl,[Current_Note]
      cmp ah, 1
       jne poezja1
      cmp dl, 0
       jb poezja1
;-----------------------------
;
;
; znika text nr 1
;
;
;-----------------------------
       xor ax, ax
       mov timer, ax           ;zeruj timmer

       mov edi, text_buffer    ;czysc bufor textu
       mov ecx, 18432
       rep stosw

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
poezja1a:
       push edi
       push esi
       push ebx
       mov ecx, 18432
byc_albo_:
       xor ah, ah
       mov al, [esi]
       cmp ax, timer
       jg _nie_byc_
       mov ax, [ebx]
       mov [edi], ax
_nie_byc_:
       add edi, 2
       add ebx, 2
       inc esi
       dec ecx
       jnz byc_albo_

       mov ah, wait_vbl
     int_eos

      mov edi, tuna_address
      mov esi, grey1_address
      call oto_tunel
      inc licznik_kl
      inc licznik_kl

      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr

      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer

      inc timer

      pop ebx
      pop esi
      pop edi

      mov ax, 0100h
      int 16h
       jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 2
       jne poezja1a
      cmp dl, 0
       jb poezja1a

;--------------------------------
;
;
;      w tío wchodzi winda
;
;
;
;--------------------------------
      xor ax, ax
      mov timer, ax         ;a zgadnij?
      clrscr grey_address   ;czysc pseudo scr_buffer
      mov edi,  grey_address
      mov esi,  scr2_buffer
      mov ebx,  ods_address

tylkoo2:
      push edi
      push esi
      push ebx
      mov cx, 64000
tylk2:
      xor ax, ax
      mov al, [ebx]
      cmp ax, timer
      jg nie_tylko2
      mov ax, [esi]
      mov [edi], ax
nie_tylko2:
      add esi, 2
      add edi, 2
      inc ebx
      dec cx
      jnz tylk2

      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer
      mov ah, wait_vbl
     int_eos

      mov esi, grey1_address
      mov edi, tuna_address
      call oto_tunel
      mov esi, grey1_address
      mov edi, winda_address
      call oto2_tunel
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      mov edi, grey_address
      call rgb_add
;      clrscr grey_address

       inc timer
       inc timer

       pop ebx
       pop esi
       pop edi

   mov ax, 0100h
  int 16h
;    jz tylkoo2
   jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
     cmp ah, 3
       jne tylkoo2
     cmp dl, 0
       jb tylkoo2


         partia texture1_address
         xor ax, ax
         mov timer, ax
;------------------------------
;
;
; zycie to makabryczny wybor :)
;
; albo kolejny text na ekranie
;------------------------------
        mov ecx, 18432
        xor ax, ax
        mov edi, text_show
        rep stosw

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
zycie1:
       push edi
       push esi
       push ebx
       mov ecx, 18432
zycie_po:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _zyciu
       mov ax, [ebx]
       mov [edi], ax
_zyciu:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz zycie_po

      mov esi, grey1_address
      mov edi, tuna_address
      call oto_tunel
      mov esi, grey1_address
      mov edi, winda_address
      call oto2_tunel
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      mov edi, scr2_buffer
      call rgb_add

      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr

      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer
      mov ah, wait_vbl
     int_eos

       inc timer
       inc timer
       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
      int 16h
   jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 2
       jne zycie1
      cmp dl, 0
       jb zycie1

;-------------------------------
;
;
; chce sie urodzic jeszcze raz!
;
; text znika i nadzieje odßywajÜ :)
;-------------------------------
       xor ax, ax
       mov timer, ax

       mov edi, text_buffer
       mov ecx, 18432
       rep stosw

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
narodziny:
       push edi
       push esi
       push ebx
       mov ecx, 18432
swiatlo:
       xor ah, ah
       mov al, [esi]
       cmp ax, timer
       jg glowka
       mov ax, [ebx]
       mov [edi], ax
glowka:
       add edi, 2
       add ebx, 2
       inc esi
       dec ecx
       jnz swiatlo

      mov esi, grey1_address
      mov edi, tuna_address
      call oto_tunel
      mov esi, grey1_address
      mov edi, winda_address
      call oto2_tunel
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      mov edi, scr2_buffer
      call rgb_add

      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr

      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer
      mov ah, wait_vbl
     int_eos

       inc timer
       inc timer
       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
      int 16h
     jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 3
       jne narodziny
      cmp dl, 0
       jb narodziny

;------------------------------
;
;
;   czesc trzy
;
; krzyz na ekran a na razie tylko
; text
;------------------------------
        xor ax, ax
        mov timer, ax

        mov ecx, 18432
        xor ax, ax
        mov edi, text_show
        rep stosw

        partia texture1_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
tylkoo3:
       push edi
       push esi
       push ebx
       mov ecx, 18432
trzy:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _a_moze_nie
       mov ax, [ebx]
       mov [edi], ax
_a_moze_nie:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz trzy


      mov esi, grey1_address
      mov edi, tuna_address
      call oto_tunel
      mov esi, grey1_address
      mov edi, winda_address
      call oto2_tunel

      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl

      mov edi, scr2_buffer
      call rgb_add             ;dodaj ekrany

      call skrzat              ;pomniejsz ekran 8 razy

      sizes 80,50,135,20,maly_buffer, scr_buffer
      call D_S_O
      sizes 80,50,135,100,maly_buffer, scr_buffer
      call d_s_o
      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer

      inc timer
      inc timer
      inc timer
      inc timer

       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
      int 16h
     jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 3
       jne tylkoo3
      cmp dl, 32
       jb tylkoo3

;------------------------------
;
;
;   czesc trztery :)
;
; ostatnie tchnienie pod krzyßem
;------------------------------
tylkoo4:

      mov esi, grey1_address
      mov edi, tuna_address
      call oto_tunel

      mov esi, grey1_address
      mov edi, winda_address
      call oto2_tunel

      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      inc licznik_kl
      mov edi, scr2_buffer
      call rgb_add
      call skrzat

      sizes 80,50,55,75,maly_buffer, scr_buffer
      call d_sp
      sizes 80,50,185,75,maly_buffer, scr_buffer
      call d_sp
      sizes 80,50,135,20,maly_buffer, scr_buffer
      call D_S_O
      sizes 80,50,135,100,maly_buffer, scr_buffer
      call d_s_o
      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

      mov esi, scr_buffer
      call draw_buffer


       mov ax, 0100h
      int 16h
      jnz papa

       mov ah,[Current_Pattern];
       mov dl,[Current_Note]
      cmp ah, 4
       jne tylkoo4
      cmp dl, 0
       jb tylkoo4
;-------------------------------
;
;
; zycie w 32tys. odcieni szrosci
;
; (2 tunele szare)
;-------------------------------
        xor ax, ax
        mov timer, ax

        mov ecx, 18432
        xor ax, ax
        mov edi, text_show
        rep stosw

        mov ecx, 18432
        xor ax, ax
        mov edi, text_buffer
        rep stosw

        partia texture1_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
greylife:
       push edi
       push esi
       push ebx
       mov ecx, 18432
cztery:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _cztery
       mov ax, [ebx]
       mov [edi], ax
_cztery:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz cztery

       mov edi, krzywa_address
       mov esi, grey1_address
       call oto2_tunel
       mov edi, krzywb_address
       mov esi, grey1_address
       call oto_tunel

       inc licznik_kl
       inc licznik_kl

       mov edi, scr2_buffer
       call rgb_add
       call skrzat

       sizes 256,200,0,0,panel_address,scr_buffer
       call d_spr
       sizes 80,50, 40,200, maly_buffer,scr_buffer
       call d_sp
       sizes 256,72,2,120,text_show, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

          inc timer
          inc timer
          pop ebx
          pop esi
          pop edi

        mov ax, 0100h
       int 16h
      jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 5
       jne greylife
      cmp dl, 0
       jb greylife

;-------------------------------
;
;
;
;  kolor your world
;
; (2 tunele kolorujemy)
;
;-------------------------------
koli:

       mov edi, grey_address
       mov esi, grey1_address
       mov ecx, 65536/4
       rep movsd

       xor ax, ax
       mov timer, ax

       mov esi, mp2_address
       mov ebp, grey1_address
       mov ebx, grey_address

tylko2o:
       push esi
       push ebx
       push ebp
       mov ecx, 0
tylko20:
       mov ax, [esi]
       xor ah, ah
       inc esi
       cmp ax, timer
       jg tylkoja
       mov edi, texture_address
       add edi, ecx
       mov ax, [edi]
       mov edi, texture1_address
       add edi, ecx
       mov dx, [edi]
       mov [ebx], ax
       mov [ebp], dx
tylkoja:
       add ebx, 2
       add ebp, 2
       add ecx, 2
       cmp ecx, 65536*2
       jnz tylko20

tylko2:
       mov edi, krzywa_address
       mov esi, grey_address
       call oto2_tunel
       mov edi, krzywb_address
       mov esi, grey1_address
       call oto_tunel

       inc licznik_kl
       inc licznik_kl

       mov edi, scr2_buffer
       call rgb_add

       call skrzat
       sizes 256,200,0,0,panel_address,scr_buffer
       call d_spr
       sizes 80,50, 40,200, maly_buffer, scr_buffer
       call d_sp
       sizes 256,72,2,120,text_show, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

       inc timer
       pop ebp
       pop ebx
       pop esi

       mov ax, 0100h
       int 16h
       jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 6
       jne tylko2o
      cmp dl, 0
       jb tylko2o

;-----------------------------
;
;
; mile akcenty sa jak koncerty
;
; kolorowy swiat i szare texty
;-----------------------------

        xor ax, ax
        mov timer, ax

        mov ecx, 18432
        xor ax, ax
        mov edi, text_buffer
        rep stosw

        partia grey2_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
greyerlife:
       push edi
       push esi
       push ebx
       mov ecx, 18432
czteryer:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _czteryer
       mov ax, [ebx]
       mov [edi], ax
_czteryer:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz czteryer

       mov edi, krzywa_address
       mov esi, grey_address
       call oto2_tunel
       mov edi, krzywb_address
       mov esi, grey1_address
       call oto_tunel

       inc licznik_kl
       inc licznik_kl
       xor ax, ax
       mov edi, scr2_buffer
       call rgb_add

       call skrzat

       sizes 256,200,0,0,panel_address,scr_buffer
       call d_spr
       sizes 80,50, 40,200, maly_buffer, scr_buffer
       call d_sp
       sizes 256,72,2,120,text_show, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

         inc timer
          inc timer
         pop ebx
          pop esi
         pop edi

        mov ax, 0100h
       int 16h
       jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 7
       jne greyerlife
      cmp dl, 0
      jb greyerlife

;----------------------------
;
;
; a po imprezie kac przy
;         obiedzie!!
;
;----------------------------
       xor ax, ax
       mov timer, ax

       mov edi, text_buffer
       mov ecx, 18432
       rep stosw

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
kac:
       push edi
       push esi
       push ebx
       mov ecx, 18432
generuj_:
       xor ah, ah
       mov al, [esi]
       cmp ax, timer
       jg ladne_fraktale
       mov ax, [ebx]
       mov [edi], ax
ladne_fraktale:
       add edi, 2
       add ebx, 2
       inc esi
       dec ecx
       jnz generuj_

       mov edi, krzywa_address
       mov esi, grey_address
       call oto2_tunel
       mov edi, krzywb_address
       mov esi, grey1_address
       call oto_tunel

       inc licznik_kl
       inc licznik_kl

       xor ax, ax
       mov edi, scr2_buffer
       call rgb_add

       call skrzat

      sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr
      sizes 80,50,40,200, maly_buffer, scr_buffer
      call d_sp

      mov esi, scr_buffer
      call draw_buffer
      mov ah, wait_vbl
     int_eos

       inc timer
       inc timer
       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
      int 16h
       jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
     cmp ah, 8
       jne kac
     cmp dl, 0
       jb kac

;------------------------
;
;
; teraz jestem happy!
;
;
;------------------------
kol:
        xor ax, ax
        mov timer, ax
        mov ecx, 18432
        xor ax, ax
        mov edi, text_show
        rep stosw
        mov ecx, 18432
        xor ax, ax
        mov edi, text_buffer
        rep stosw
        partia grey2_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
tylko4:
       push edi
       push esi
       push ebx
       mov ecx, 18432
oh_yeah_:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg anathema_rules_
       mov ax, [ebx]
       mov [edi], ax
anathema_rules_:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz oh_yeah_


       mov edi, obrus_address
       mov esi, texture_address
       call oto_tunel
       mov edi, obrus_address
       mov esi, texture1_address
       call oto2_tunel
       inc licznik_kl
       inc licznik_kl
       mov edi, scr2_buffer
       call rgb_add
       call skrzat
       sizes 256,200,0,0,panel_address, scr_buffer
       call d_spr
       sizes 80,50,230,15,maly_buffer, scr_buffer
       call d_sp
       sizes 256,72,2,120,text_show, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

        inc timer
        inc timer
        pop ebx
        pop esi
        pop edi

       mov ax, 0100h
       int 16h
       jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 9
       jne tylko4
      cmp dl, 0
       jb tylko4
;-----------------------------
;
;
; klÜtwa: ujëcie kt¢reûtam
; po niebie leniwie snuíy sië
; chmury...
;
;-----------------------------
        xor ax, ax
        mov timer, ax

        mov ecx, 18432
        xor ax, ax
        mov edi, text_buffer
        rep stosw

        partia grey2_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
tylko_nie_4:
       push edi
       push esi
       push ebx
       mov ecx, 18432
anathema:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _rules
       mov ax, [ebx]
       mov [edi], ax
_rules:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz anathema



       mov edi, obrus_address
       mov esi, texture_address
       call oto_tunel
       mov edi, obrus_address
       mov esi, texture1_address
       call oto2_tunel

       inc licznik_kl
       inc licznik_kl

       mov edi, scr2_buffer
       call rgb_add
       call skrzat

       sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
        sizes 80,50,230,75,maly_buffer, scr_buffer
      call d_sp
        sizes 80,50,230,15,maly_buffer, scr_buffer
      call d_sp
        sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

        inc timer
        inc timer
        pop ebx
        pop esi
        pop edi

       mov ax, 0100h
       int 16h
       jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
     cmp ah, 10
       jne tylko_nie_4
     cmp dl, 0
       jb tylko_nie_4

;-----------------------------
;
;  uuuu la, la, la!
;
;-----------------------------
       xor ax, ax
       mov timer, ax

       mov edi, text_buffer
       mov ecx, 18432
       rep stosw

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
kochajmy_disco:
       push edi
       push esi
       push ebx
       mov ecx, 18432
milosc_i_:
       xor ah, ah
       mov al, [esi]
       cmp ax, timer
       jg _pokoj_wszystkim_dresom
       mov ax, [ebx]
       mov [edi], ax
_pokoj_wszystkim_dresom:
       add edi, 2
       add ebx, 2
       inc esi
       dec ecx
       jnz milosc_i_

       mov edi, obrus_address
       mov esi, texture_address
       call oto_tunel
       mov edi, obrus_address
       mov esi, texture1_address
       call oto2_tunel
       inc licznik_kl
       inc licznik_kl
       mov edi, scr2_buffer
       call rgb_add
       call skrzat
       sizes 256,200,0,0,panel_address, scr_buffer
       call d_spr
       sizes 80,50,230,75,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50,230,15,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50, 230,135, maly_buffer, scr_buffer
       call d_sp
       sizes 256,72,2,120,text_show, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

        inc timer
        inc timer
        pop ebx
        pop esi
        pop edi

       mov ax, 0100h
       int 16h
       jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 13
       jne kochajmy_disco
      cmp dl, 0
       jb kochajmy_disco

;-----------------------------
;
;
;  you try to see inside of
;        me... you cannot
;  hide i know you
;  !finaí!
;-----------------------------
;       clrscr grey_address
;       clrscr scr2_buffer
;       clrscr scr_buffer

       mov ebx, ods_address
       mov esi, grey_address
       mov edi, scr_buffer

       xor ax, ax
       mov timer, ax

final:
       push ebx
       push esi
       push edi

       mov ecx, 65535
no_to_uwaga:
       xor ax, ax
       mov al, [ebx]
       cmp ax, timer
       jg _bedzie_bolec
       mov ax, [esi]
       mov [edi], ax
_bedzie_bolec:
       add esi, 2
       add edi, 2
       inc ebx
       dec ecx
       jnz no_to_uwaga
        call skrzat
       sizes 80,50,230,75,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50,230,15,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50, 230,135, maly_buffer, scr_buffer
       call d_sp
       sizes 256,200,0,0,panel_address, scr_buffer
       call d_spr

       mov esi, scr_buffer
      call draw_buffer
       mov ah, wait_vbl
      int_eos

       mov edi, obrus_address
       mov esi, texture_address
       call oto_tunel
       mov edi, obrus_address
       mov esi, texture1_address
       call oto2_tunel
       mov edi, scr2_buffer
       call rgb_add


       mov edi, grey_address
       mov esi, scr_buffer
       mov grey_address, esi
       mov scr_buffer, edi

       mov edi, winda_address
       mov esi, nowy_szary
      call oto_tunel
       mov edi, pcv_address
       mov esi, nowy_szary
      call oto2_tunel
       mov edi, scr2_buffer
      call rgb_add
       mov edi, grey_address
       mov esi, scr_buffer
       mov grey_address, esi
       mov scr_buffer, edi
       clrscr scr2_buffer

       inc licznik_kl
       inc licznik_kl
       inc licznik_kl
       inc licznik_kl

       pop edi
       pop esi
       pop ebx
       inc timer
       inc timer

       mov ax, 0100h
       int 16h
        jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 1
       jne final
      cmp dl, 0
       jb final

;----------------------------
;
; grande (albo granda)mow mi
;          Mieciu!
;
;----------------------------
        xor ax, ax
        mov timer, ax

        mov ecx, 18432
        xor ax, ax
        mov edi, text_buffer
        rep stosw

        clrscr scr2_buffer

        partia texture1_address

       mov edi, text_show
       mov ebx, text_buffer
       mov esi, mp2_address
mietek:
       push edi
       push esi
       push ebx
       mov ecx, 18432
zulem_byl:
       xor ah, ah
       mov al, [esi]
       inc esi
       cmp ax, timer
       jg _denaturat_pil
       mov ax, [ebx]
       mov [edi], ax
_denaturat_pil:
       add edi, 2
       add ebx, 2
       dec ecx
       jnz zulem_byl

       mov edi, winda_address
       mov esi, nowy_szary
       call oto_tunel
       mov edi, pcv_address
       mov esi, nowy_szary
      call oto2_tunel
       mov edi, scr2_buffer
      call rgb_add
      call skrzat
       sizes 80,50,230,75,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50,230,15,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50, 230,135, maly_buffer, scr_buffer
       call d_sp

       sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
      sizes 256,72,2,120,text_show, scr_buffer
      call d_spr

       mov esi, scr_buffer
      call draw_buffer
       mov ah, wait_vbl
      int_eos

       inc licznik_kl
       inc licznik_kl
       inc timer

       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
       int 16h
        jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 2
       jne mietek
      cmp dl, 0
       jb mietek


;------------------------
;
; ciemnosc, ciemnosc widze ciemnosc
;
;------------------------
        xor ax, ax
        mov timer, ax
        clrscr scr2_buffer
        mov ebx, ods_address
        mov esi, scr_buffer
        mov edi, scr2_buffer
ciemniej:
        push ebx
        push edi
        push esi
        mov cx, 65535
_ciemo:
        xor ax, ax
        mov al, [ebx]
        cmp ax, timer
        jng _albo_ciemno
        mov ax, [esi]
        mov [edi], ax
_albo_ciemno:
        add esi, 2
        add edi, 2
        inc ebx
        dec cx
        jnz _ciemo

        mov esi, scr2_buffer
        call draw_buffer
        mov ah, wait_vbl
        int_eos

       mov edi, winda_address
       mov esi, nowy_szary
       call oto_tunel
       mov edi, pcv_address
       mov esi, nowy_szary
      call oto2_tunel
       mov edi, scr2_buffer
      call rgb_add
       call skrzat
        sizes 80,50,230,75,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50,230,15,maly_buffer, scr_buffer
       call d_sp
       sizes 80,50, 230,135, maly_buffer, scr_buffer
       call d_sp
       sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr
       sizes 256,72,2,120,text_show, scr_buffer
      call d_spr
       clrscr scr2_buffer

       inc licznik_kl
       inc licznik_kl
       inc timer
       inc timer

       pop esi
       pop edi
       pop ebx

       mov ax, 0100h
       int 16h
       jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 3
       jne ciemniej
      cmp dl, 0
       jb ciemniej
;-------------------------
;
;
;
;---------------------------
       xor ax,ax
       mov timer, ax
       call prep_scroll              ;przygotuj koncowego scrolla
       clrscr scr2_buffer
       mov edi, scr2_buffer
       mov esi, scr_buffer
       mov ebx, ods_address
scrl:
       push edi
       push esi
       push ebx
       mov ecx, 65535
scrl2:
       xor ax, ax
       mov al, [ebx]
       cmp ax, timer
       jg scrl3
       mov ax, [esi]
       mov [edi], ax
scrl3:
       add esi,2
       add edi,2
       inc ebx
       dec cx
       jnz scrl2

       mov esi, scr2_buffer
       call draw_buffer
       mov ah, wait_vbl
      int_eos

       xor eax, eax
       mov x_scroll, eax
       call rysuj_maly
       inc licznik_kl
       inc licznik_kl
       mov edi, winda_address
       mov esi, texture_address
       call oto2_tunel

       call scroll_tuna_up
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna_up

       xor eax, eax
       mov x_scroll, eax

       mov edi, scr2_buffer
       call rgb_add

       sizes 256,200,32,0,scroll_buffer,scr_buffer
      call d_spr

       call move_scroll        ;ruszaj scroll

        sizes 256,200,0,0,panel_address, scr_buffer
      call d_spr

       clrscr scr2_buffer
       inc timer
       inc timer
       pop ebx
       pop esi
       pop edi

       mov ax, 0100h
       int 16h
       jnz papa

       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 2
       jne scrl
      cmp dl, 0
       jb scrl


;----------------------------
;
; dziekuje akademii
; i jeszcze....
; prosiaczku!
; puchatek walczy!!
;
;---------------------------
       xor eax, eax
       mov x_scroll, eax
tylko5:
       call rysuj_maly
       inc licznik_kl
       inc licznik_kl
       mov edi, winda_address
       mov esi, texture_address
       call oto2_tunel

       call scroll_tuna_up
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna
       mov eax, x_scroll
       add eax, 80
       mov x_scroll, eax
       call scroll_tuna_up
       xor eax, eax
       mov x_scroll, eax
       mov edi, scr2_buffer
       call rgb_add
        sizes 256,200,32,0,scroll_buffer, scr_buffer;
        call d_spr;
        call move_scroll
      sizes 256,200,0,0,panel_address, scr_buffer
       call d_spr

       mov esi, scr_buffer
       call draw_buffer
        mov ah, wait_vbl
      int_eos

       mov ax, 0100h
       int 16h

        jnz papa
       mov ah,[Current_Pattern]
       mov dl,[Current_Note]
      cmp ah, 3
       jne tylko5
      cmp dl, 0
       jb tylko5


papa:
        mov ah, deallocate_memory
       int_eos

        mov ah, stop_module
       int_eos

        mov ah, clear_module
       int_eos

 ;      mov ax, 03h
 ;      int 10h

        mov ax, 4c00h
       int 21h
;
;
;/ koniec klÜtwy /
;
;
code32 ends
end
;____________________________________________
;/ sko§czyíem...
;/ r¢ßnie to byío...
;/ nie wyszío najlepiej...
;/ ale trudno...
;/ zabawy byío przy tym sporo... :)
;/ do nastëpnego razu na ko§cu zr¢díka.? ;)
;--------------------------------------------