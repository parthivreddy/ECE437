ori $3, $0, 0xFF00
lw $4, 0($3) #C0: I->S C1: I->I
nop
sw $4, 0($5) #C0: S->M C1: S->I
sw $4, 0($5) #C0: M->M C1: I->I



halt





org 0x200
ori $5, $0, 0x0400
nop
lw $2, 0($3) #C0: S->S C1: I->S
nop
nop

halt


org 0xFF00
cfw 5
cfw 6
cfw 7
