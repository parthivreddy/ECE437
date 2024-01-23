org 0x0000
andi $29, $29, 0
ori  $29, $29, 0xFFFC

andi $1, $1, 0
ori  $1, $1, 0xAAAA

andi $2, $2, 0
ori  $2, $2, 0x0BAD


andi $3, $3, 0
ori  $3, $3, 0xFF00


jal next
sw  $2, 0($3)

nextnext:
    sw $1, 4($3)
    addi $4, $31, 8 
    jr $4
    halt
    sw $1, 8($3)
    halt



next:
    sw $31, 0($3)
    j nextnext
    sw $2, 4($3)

 

