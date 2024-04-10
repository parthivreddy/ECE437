#want to write to one of the sets then try and get diff info from other set
#Want same idx but diff tags for each set

ori $1, $0, 10
ori $2, $0, 20
ori $3, $0, 0xFFC0 #idx is 0 for both
ori $4, $0, 0xF0C0
sw  $1, 0($3)
sw  $2, 0($4)
lw  $5, 0($3)
lw  $6, 0($4)

halt

org 0x200
halt
