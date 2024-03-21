ori $1, $0, 0xBEEF
ori $5, $zero, 0x0800 # mem address
sw  $1, 0($5)
lw  $6, 0($5)
addi $7, $6, 0x0001
sw  $7, 4($5)

halt
