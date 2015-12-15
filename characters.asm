; will output characters 129 - 143 to the screen
; character map: http://www.worldofspectrum.org/ZXBasicManual/zxmanappa.html
CHARS                      ; Start of the routine    
LOOP2                      ; define loop
    ld a, (NUM_TIMES)      ; load NUM_TINES value in accumulator
    cp 143                 ; compare accumulator to value (character)      
    jr z, EXIT             ; exit if reached
    inc a                  ; if not, increase accumulator
    LD (NUM_TIMES), a      ; store accumulator value to NUM_TIMES
    rst $10                ; output accuumulator value to screen
    jr LOOP2               ; loop
RESET                      ; define reset
    ld a, 143              ; load value to a
    ld (NUM_TIMES), a      ; store it to NUM_TIMES
    jr LOOP2               ; loop
NUM_TIMES                  ; variable store
     defb 129              ; define lower boundary