ori $1, $0, 5
ori $2, $0, 0xFFC0
sw  $1, 0($2)
ori $3, $0, 1
ori $4, $0, 2
ori $1, $0, 5
lw  $6, 0($2)
sw  $6, 4($2)

halt
