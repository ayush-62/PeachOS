[BITS 32]
global _start
CODE_SEG equ 0x08
DATA_SEG equ 0x10
_start:
    ; set up segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov gs, ax
    mov fs, ax
    mov es, ax
    mov ebp, 0x00200000     
    mov esp, ebp 

    ; Set up A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $