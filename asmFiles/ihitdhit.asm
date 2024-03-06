ori $1, $0, 2
ori $2, $0, 0xFFC0
ori $3, $0, 3

LOOP:
    sw  $3, 0($2)
    addi $1, $1, -1
    addi $3, $3, 1
    bne $1, $0, LOOP

halt
