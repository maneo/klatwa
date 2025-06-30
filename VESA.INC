;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
;²  sprawdz_vese - sprawdza czy karta gfx
;²  supportuje vese i rz†dany tryb
;²   in: cx - Vesa mode
;²   out: -
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
sprawdz_vese proc

  init_es_di VesaInfoBlock
  mov ax, 4f00h
  int 10h

  cmp ah, 1
  je @niet_vesy_today                ;vesy brok

  init_es_di ModeInfoBlock                ;w cx numer trybu vesy
  mov ax, 4f01h
  int 10h

  cmp ah, 1
  je @wysraj_sie_z_tym_trybem

ret
; Vesa init errors
@niet_vesy_today:
  mov ah, exit_error                  ;exit program
  mov edx, offset Vesa_no
  int_eos
@wysraj_sie_z_tym_trybem:
  mov ah, exit_error
  mov edx, offset Vesa_mode_error
  int_eos
sprawdz_vese endp
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
;²  init_vesa_mode - pr
;²  in: bx - vesa mode
;²  out:
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
init_vesa_mode proc

    mov ax, 4f02h
    dosint 10h

    cmp ah, 1
    je @za_niskie_podejscie       ;b’†d!

ret
@za_niskie_podejscie:
     mov ah, exit_error
     mov edx, offset Vesa_init_error
     int_eos
init_vesa_mode endp

;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
;² set_bank -
;² in: edx - number of bank
;² out: al = 0 - ok
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
setbank MACRO	bank_nr

      mov dx, bank_nr
      mov ax, 4f05h
      xor bx, bx
      dosint 10h

         ENDM
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
;² draw buffer
;² in: esi - buffer address
;² out:
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
draw_buffer proc
     setbank 0
     mov ecx, 65536/2
     mov edi, [_0a0000h]
     rep movsw
     setbank 1
     mov ecx, 65536/2
     mov edi, [_0a0000h]
     rep movsw
ret
endp      
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
; to wszystko ponizej (z wyjatkiem komunikatow
; o bledzie)jest przepisane!
;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

; errors
Vesa_mode_error db '    þÿVeSa mOde nOt fOUnd$'
Vesa_init_error db '    þ VeSa inIT erRoR$'
Vesa_no db '    þ VeSa nOt fOUnd, tRy uNiVBe$' ;vesy brak

VesaInfoBlock           Label   Byte
VbeSignature            db   'VESA'     ; VBE Signature
VbeVersion              dw   0120h      ; VBE Version
OemStringPtr            dd   ?          ; Ptr to OEM String
Capabilities            db   4 dup (?)  ; Capabilities of graphics cont.
VideoModePtr            dd   ?          ; Pointer to Video Mode List
TotalMemory             dw   ?          ; Number of 64kb memory blocks Added for VBE 2.0
OemSoftwareRev          dw   ?          ; VBE implementation Software revision
OemVendorNamePtr        dd   ?          ; Pointer to Vendor Name String
OemProductNamePtr       dd   ?          ; Pointer to Product Name String
OemProductRevPtr        dd   ?          ; Pointer to Product Revision String
_Reserved_              db   222 dup (?); Reserved for VBE implementation scratch area
OemData                 db   256 dup (?); Data Area for OEM Strings

;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

ModeInfoBlock   Label   Byte

; Mandatory information for all VBE revisions
ModeAttributes          dw ?      ; mode attributes
WinAAttributes          db ?      ; window A attributes
WinBAttributes          db ?      ; window B attributes
WinGranularity          dw ?      ; window granularity
WinSize                 dw ?      ; window size
WinASegment             dw ?      ; window A start segment
WinBSegment             dw ?      ; window B start segment
WinFuncPtr              dd ?      ; pointer to window function
BytesPerScanLine        dw ?      ; bytes per scan line

; Mandatory information for VBE 1.2 and above
XResolution             dw ?      ; horizontal resolution in pixels or chars
YResolution             dw ?      ; vertical resolution in pixels or chars
XCharSize               db ?      ; character cell width in pixels
YCharSize               db ?      ; character cell height in pixels
NumberOfPlanes          db ?      ; number of memory planes
BitsPerPixel            db ?      ; bits per pixel
NumberOfBanks           db ?      ; number of banks
MemoryModel             db ?      ; memory model type
BankSize                db ?      ; bank size in KB
NumberOfImagePages      db ?      ; number of images
_Reserved               db ?      ; reserved for page function

; Direct Color fields (required for direct/6 and YUV/7 memory models)
RedMaskSize             db ?      ; size of direct color red mask in bits
RedFieldPosition        db ?      ; bit position of lsb of red mask
GreenMaskSize           db ?      ; size of direct color green mask in bits
GreenFieldPosition      db ?      ; bit position of lsb of green mask
BlueMaskSize            db ?      ; size of direct color blue mask in bits
BlueFieldPosition       db ?      ; bit position of lsb of blue mask
RsvdMaskSize            db ?      ; size of direct color reserved mask in bits
RsvdFieldPosition       db ?      ; bit position of lsb of reserved mask
DirectColorModeInfo     db ?      ; direct color mode attributes

; Mandatory information for VBE 2.0 and above
PhysBasePtr             dd ?      ; physical address for flat frame buffer
OffScreenMemOffset      dd ?      ; pointer to start of off screen memory
OffScreenMemSize        dw ?      ; amount of off screen memory in 1k units
__Reserved              db 206 dup (?)  ; remainder of ModeInfoBlock

; end of include