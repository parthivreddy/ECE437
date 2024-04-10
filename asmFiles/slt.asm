org 0x0000
ori $1, $0, 0xFF00
addi $2, $0, 0xFFFF
ori $3, $0, 2

slti $4, $2, 1
sltiu $5, $2, 1

sw $4, 0($1)
sw $5, 4($1)

lw $6, 0($1)
lw $7, 4($1)

halt

org 0x200
halt
