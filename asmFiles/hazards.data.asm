addi $2, $0, 2
addi $3, $0, 3
addi $4, $0, 4
addi $5, $0, 5

and $2, $2, $3
or $2, $2, $4
sub $2, $2, $5
sllv $2, $2, $3
add $2, $2, $4

sw $2, 0($28)

halt
