org 0x0000
andi $29, $29, 0
ori  $29, $29, 0xFFFC

ori $1, $0, 0xFF00
ori $2, $0, 0xBEAD
sw $2, 0($1)

halt

ori $3, $0, 0xDEAD
sw $3, 0($1)
