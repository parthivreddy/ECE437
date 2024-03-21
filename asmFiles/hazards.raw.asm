org   0x0000

#RAW hazard, $2 is a dependency
ori $1, $0, 0x1234
ori $2, $0, 0x4321
add $3, $1, $2 #$2 is dependent on ori
ori $4, $zero, 0xFFFC
sw  $3, 0($4)

ori $5, $zero, 0x0800 #mem address
sw  $1, 0($5)
lw  $6, 0($5)
addi $7, $6, 0x0001 # $6 is dependent on lw
halt
