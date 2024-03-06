ori $1, $0, 2
ori $2, $0, 0xFFC0
ori $3, $0, 3

LOOP:
    sw  $3, 0($2)
    addi $1, $1, -1
    addi $3, $3, 1
    addi $2, $2, 4
    bne $1, $0, LOOP


halt

#loop so i is from cache but incr daddr so d is from RAM
