org   0x0000
ori   $1,$zero,0xF0

addi   $3, $3, 10
lw    $3,0($1)
sw    $3,0($2)

halt

org   0x00F0
cfw   0x1
