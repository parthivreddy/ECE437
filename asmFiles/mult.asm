org     0x0000
andi    $29, $29, 0
ori     $29, $29, 0xFFFC    
andi    $8, $8, 0
andi    $9, $9, 0
ori     $8, $8, 3
ori     $9, $9, 6
andi    $10, $10, 0
andi    $11, $11, 0


addloop:
    beq     $10, $9,  LOOPDONE
    add     $11, $11, $8
    addi    $10, $10, 1
    j       addloop
  
LOOPDONE:
    push    $11

halt





