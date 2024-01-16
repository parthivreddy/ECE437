org     0x0000
andi    $29, $29, 0
ori     $29, $29, 0xFFFC 

ori $1, $0, 5
ori $2, $0, 1
ori $3, $0, 2024



addi $2, $2, -1
ori  $7, $0, 30
push $2
push $7
or  $14, $0, $29
jal MULT
pop  $7

addi $3, $3, -2000
ori  $5, $0, 365
push $3
push $5
jal MULT
pop  $6
add  $17, $1, $6
add  $1, $17, $7

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
