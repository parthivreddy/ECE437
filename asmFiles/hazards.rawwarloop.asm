ori $1, $0, 0xBEEF
ori $2, $0, 0xFEED
ori $4, $0, 0x8 # loop counter
ori $5, $zero, 0x0800 # mem address

start:
sw  $1, 0($5)
addi $5, $5, 4
sw  $2, 0($5)
lw  $6, 0($5)
lw  $7, 0($5)
sw  $7, 4($5)
sw  $6, 8($5)

addi $5, $5, 16
addi $4, $4, -1  

bne $4, $0, start

halt
