addi $2, $0, 4
addi $3, $0, 3
ori $4, $0, 3

beq $2, $3, wrong
sw $2, 0($28)

bne $3, $4 , yes
sw $2, 4($28)
add $5, $2, $3

yes:
sw $3, 0($28)
wrong:
halt
