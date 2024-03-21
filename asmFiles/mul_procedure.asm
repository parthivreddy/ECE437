org     0x0000
andi    $29, $29, 0
ori     $29, $29, 0xFFFC 
andi    $8, $8, 0
ori     $8, $8, 1
andi    $9, $9, 0
ori     $9, $9, 2
ori     $14, $0, 2
ori     $15, $0, 1
push    $8
push    $9
push    $14
push    $15


jal     MULT
halt


MULT:
addi    $10, $29, 4
ori     $12, $0, 0xFFFC
beq     $10, $12, EXIT
pop     $8
pop     $9
andi    $11, $11, 0
andi    $13, $13, 0

ADDLOOP:
    beq     $13, $9, LOOPDONE
    add     $11, $11, $8
    addi    $13, $13, 1
    j     ADDLOOP

LOOPDONE:
    push    $11
    j       MULT

EXIT:
    JR      $31

