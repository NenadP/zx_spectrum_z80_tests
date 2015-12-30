
; will output characters 129 - 143 to the screen
; character map: http://www.worldofspectrum.org/ZXBasicManual/zxmanappa.html

DRAW:                     ; routine expects sprite data in DE, and sprite coords
                          ; in BC (B = x, C = y, x max = 15, y max = 11 
    ;call 3503            ; clears the screen TODO
    push de               ; we push, pop DE (sprite data), BC (coords) to 
    call TRANSLATE_COORDS ; free it up to use in routines                                           
    pop de                ; we call translating/drawing routines to draw given
    push bc               ; sprite to pixel/attrs mem locations
    call DRAW_PIXELS
    pop bc
    push de
    call TRANSLATE_ATTR_COORDS
    pop de
    call DRAW_ATTRS
    ret
DRAW_PIXELS:              ; routine to daraw 16x16 sprite to given screen location in HL
    ld b, 8               ; first row of the sprite
    ld c, 1               ; flag indicates number of rows
DRAW_LOOP:
    call DE_TO_HL_INC     ; routine to load de to hl and increment
    ld a, (de)            ; slightly different, cause we increment h, and decrement l
    ld (hl), a
    inc de
    inc h                 ; increase video mem high byte to match next line
    dec l                 ; also decrease low bite to get pointer under the first byte
    djnz DRAW_LOOP        ; repeat
    ld a, h               ; when first row is finished, get high byte,
    sub 8                 ; substract by 8 to rewind to the start...
    ld h, a
    ld a, l
    add a, 32             ; and add 32 to get forward to second row
    ld l, a
    ld a, c               ; get the number of rows
    cp 0
    jr nz, NEXT_ROW       ; if not zero, draw a second row, by calling NEXT_ROWttt
    ret
NEXT_ROW:            
    dec c                 ; it decreases row counter
    ld b, 8               ; sets b again to 8 for DRAW_LOOP
    jr DRAW_LOOP          ; and go there
TRANSLATE_COORDS:         ; routine to translate x,y stored in BC to attr coords
    ld hl, #4000          ; video memory address
    ld d, 0
Y_POS_LOOP:               ; execute each C (Ypos) value
    ld a, d 
    cp 4                  ; we need to check if we are in 2rd or 3rd screen region
                          ; to add needed bytes
    call z, ADVANCE_SCR_REGION    
    cp 8
    call z, ADVANCE_SCR_REGION  
    cp c
    jr z, X_POS_ADD 
    inc d
    ld a, l
    add a, #40            ; advance 64 bytes to get to the next row
    ld l,a
    jr Y_POS_LOOP
X_POS_ADD:                ; add X offset to get precise translation of x,y to
    call DOUBLE_B_TO_L    ; address, and return from routine 
    ret
ADVANCE_SCR_REGION:       ; advance to next spectrum screen 1/3 region by adding
    push de               ; 2048 bytes
    ld de, #800
    add hl, de
    pop de
    ret    
TRANSLATE_ATTR_COORDS:    ; routine to translate x,y stored in BC to attr coords
    ld hl, #5800          ; attribute memory location
    ld d, 0               ; d will be our iterator
Y_POS_ATTRS_LOOP:         ; execute each C (Ypos) value
    ld a, d
    cp c
    jr z, X_POS_ATTRS_ADD ; if we reach y pos, jump to x pos offset addition
    inc d
    push bc             
    ld bc, #40            ; advance 64 bytes to get to the next row
    add hl, bc
    pop bc
    jr Y_POS_ATTRS_LOOP
X_POS_ATTRS_ADD:          ; add X offset to get precise translation of x,y to
    call DOUBLE_B_TO_L    ; address, and return from routine 
    ret
DRAW_ATTRS:               ; we should have right address in hl now where to output
                          ; attributes, so we load attribute data for our 2x2 sprite
    call DE_TO_HL_INC
    call DE_TO_HL_INC
    ld a, l
    add a, #1e            ; get to the next row (30 = 32 - 2(sprite width))
    ld l, a
    call DE_TO_HL_INC
    call DE_TO_HL_INC
    ret
DE_TO_HL_INC:
    ld a, (de)          
    ld (hl), a
    inc de
    inc hl
    ret
DOUBLE_B_TO_L:     
    ld a, l
    add a, b
    add a, b
    ld l, a  
    ret