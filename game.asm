;http://shaunbebbington.blogspot.ie/2011/12/introduction-to-z80-assembly-part-i.html
;http://sgate.emt.bme.hu/patai/publications/z80guide/index.html
;RANDOMIZE USR 24576   
          
     org $6000          ; Start of code (6x4096 in decimal)  
     ld b, 15
     ld c, 9
     ld de, player
     call DRAW 
     ld b, 2
     ld c, 2
     ld de, player
     call DRAW 
     jp EXIT
EXIT                    
     ret                ; This will return us to BASIC 
     
     include draw.asm
     include sprites.asm  

         
     