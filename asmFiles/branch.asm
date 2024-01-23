org 0x0000
andi $29, $29, 0
ori  $29, $29, 0xFFFC

andi $1, $1, 0
ori  $1, $1, 0xAAAA

andi $2, $2, 0
ori  $2, $2, 0x0BAD

andi $3, $3, 0
ori  $3, $3, 0xFF00

andi $4, $4, 0
ori  $4, $4, 0xFF04

beq $1, $2, EQUAL

bne $1, $2, LESS

addi $2, $2, -1

bne $1, $2, LESS2

beq $1, $2, EQUAL2

EQUAL:
    sw $2, 0($3)

LESS:
    sw $1, 0($3) 

EQUAL2:
    sw $2, 0($4)

LESS2:
    sw $1, 0($4)

lw $5, 0($3)

lw $6, 0($4)

halt 
