;http://shaunbebbington.blogspot.ie/2011/12/introduction-to-z80-assembly-part-i.html
;http://sgate.emt.bme.hu/patai/publications/z80guide/index.html
;RANDOMIZE USR 24576   
          
     org $6000          ; Start of code (6x4096 in decimal)  
     ld b, 1
     ld c, 1
     ld de, dwarf
     call DRAW 
     ld b, 2
     ld c, 1
     ld de, troll
     call DRAW 
     ld b, 3
     ld c, 1
     ld de, elf_mage
     call DRAW
     ld b, 4
     ld c, 1
     ld de, goblin_brute
     call DRAW
     ld b, 5
     ld c, 1
     ld de, sprite
     call DRAW
     jp EXIT
EXIT                    
     ret                ; This will return us to BASIC 
     
     include draw.asm
     include sprites.asm  

         
                                                             