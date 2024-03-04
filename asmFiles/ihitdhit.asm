ori $1, $0, 2
ori $2, $0, 0xFFC0
ori $3, $0, 3

LOOP:
    beq $1, $0, END
    lw  $3, 0($2)
    subi $1, $1, 1
    j LOOP

END:
    halt
