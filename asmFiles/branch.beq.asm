# beq unit test
org   0x0000
ori   $1,$zero,0xF0
ori   $2,$zero,0xF0
beq   $1, $2, exit
ori   $3,$zero,0xBBBB #failed
ori   $4, $zero, 0xFFFC
sw    $3, 0($4)
halt

exit:
ori   $3,$zero,0xAAAA #passed
ori   $4, $zero, 0xFFFC
sw    $3, 0($4)
halt
