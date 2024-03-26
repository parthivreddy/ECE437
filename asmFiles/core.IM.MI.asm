ori $3, $0, 0xFF00
lw $4, 0($3) #C0: I->S C1: I->I
nop
lw $4, 0($3) #C0: S->S C1: S->S direct hit
sw $4, 0($4) #C0: S->M C1: S->I



halt





org 0x200
nop
nop
lw $2, 0($3) #C0: S->S C1: I->S
nop
nop
sw $2, 0($3) #C0: M->I C1: I->M

halt


org 0xFF00
cfw 5
cfw 6
cfw 7