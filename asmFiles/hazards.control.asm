addi $2, $0, 4
addi $3, $0, 3
ori $4, $0, 6
ori $7, $0, 0xFF00

beq $2, $3, wrong
sw $2, 0($28)

bne $3, $4 , yes
sw $3, 4($7)
add $5, $2, $3
ori $6, $0, 5

yes:
sw $4, 0($7)
wrong:
halt
