ori $3, $0, 0x0400
ori $4, $0, 5
sw $4, 0($3) #C0: I->M C1: I->I
nop




halt





org 0x200
nop
nop
nop
lw $2, 0($3) #C0: M->S C1: I->S


halt


org 0xFF00
cfw 5
cfw 6
cfw 7
