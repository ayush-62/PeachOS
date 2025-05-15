ORG 0x7c00
BITS 16
CODE_SEG equ gdt_code-gdt_start
DATA_SEG equ gdt_data-gdt_start

jmp start
message:
    db "[Boot loader]",0
start:
    mov bx, message
    call loop
    mov ah, 0x0E
    mov al, 0x0D   ; Carriage Return (\r)
    int 0x10

    mov al, 0x0A   ; Line Feed (\n)
    int 0x10
    call load
    jmp load_protected_mode


loop:
    mov ah, 0eh
    mov al, [bx]
    cmp al, 0
    je done
    int 0x10
    inc bx
    jmp loop

done:
    ret
load:
    mov ah, 02h
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov bx, 0x8112
    int 0x13
    call loop
    ret

load_protected_mode:
    cli
    lgdt [gdt_desc]

    ; Load GDT
    ; Enable protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:load32

gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
gdt_code:
    dw 0xFFFF
    dw 0
    db 0
    db 0x9A
    db 11001111b
    db 0x00
gdt_data:
    dw 0xFFFF
    dw 0
    db 0
    db 0x92
    db 11001111b
    db 0x00
gdt_end:
gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
load32:
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

times 510 - ($ - $$) db 0 
dw 0xAA55
db "[Sector 2 is loaded]",0
times 510  db 0 