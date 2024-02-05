and $1, $1, $0
ori $1, $1, 3

and $2, $2, $0
ori $2, $2, 5

nop
nop

add $3, $1, $2

ori $4, $0, 0xFF0C

nop
nop

sw $3, 0($4)

nop
nop

lw $5, 0($4)

nop
nop

halt
