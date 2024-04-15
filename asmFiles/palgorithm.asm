# Core 1 is the producer
# Core 2 is the consumer

# Core 1
org   0x0000
ori   $sp, $zero, 0xAFFC  # stack
ori   $s0, $0, 0xEFFC     # shared stack
jal   mainp0              # go to program
halt

# lock and unlock function taken from example.asm
# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a2)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a2)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a2)
  jr    $ra

# subroutine_crc (random number generator)
#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  ori $t5, $0, 31
  srlv $t4, $t5, $a0
  ori $t5, $0, 1
  sllv $a0, $t5, $a0
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------


# subroutine_mm (maximum and minimum)
# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------


mainp0:
  push  $ra                 # save return address
  ori   $a0, $0, 0xFEED     # seed
  ori   $s1, $0, 256        # number of random numbers

  randomN:
    ori   $a2, $zero, lock_addr  # move lock to arguement register
    jal   lock                # try to aquire the lock
    
    jal   crc32             # random number
    sw    $v0, 0($s0)       # store to shared stack
    addi  $s0, $s0, -4      # decrease shared stack pointer
    or    $a0, $0, $v0      # write result to input of next iteration

    ori   $a2, $zero, lock_addr  # move lock to arguement register
    jal   unlock              # release the lock
    addi	$s1, $s1, -1      # decrease loop iteration
    bne   $s1, $0, randomN

  pop   $ra                 # get return address
  jr    $ra                 # return to caller


# Core 2
org   0x0200
ori   $sp, $zero, 0xBFFC  # stack
ori   $s0, $0, 0xEFFC     # shared stack
jal   mainp1              # go to program
halt

mainp1:
  push  $ra                 # save return address
  ori   $s1, $0, 256        # loop iteration
  ori   $s7, $0, 0          # initialize total

  get_first_num:
    lw    $a0, 0($s0)
    beq   $a0, $0, get_first_num

  andi  $a0, $a0, 0xFFFF    # clear upper bits
  push  $a0                 # initialize stack (min, max, total for average)
  push  $a0
  # push  $0

  stats:
    
    # pop   $s7                 # total
    pop   $s6                 # max
    pop   $s5                 # min

    # find minimum
    or    $a1, $0, $s5
    jal   min
    push  $v0

    # find maximum
    or    $a1, $0, $s6
    jal   max
    push  $v0

    # add to total
    add   $s7, $a0, $s7
    # push  $s7

    ori   $a2, $zero, lock_addr  # move lock to arguement register
    jal   lock                # try to aquire the lock

    sw    $0, 0($s0)          # clear top of shared stack
    addi  $s0, $s0, -4        # move pointer
    lw    $a0, 0($s0)         # load new number at address
    andi  $a0, $a0, 0xFFFF    # clear upper bits
    
    addi  $s1, $s1, -1        # decrease loop iteration
  
    ori   $a2, $zero, lock_addr  # move lock to arguement register
    jal   unlock              # release the lock

    bne		$s1, $0, stats

  ori   $t0, $0, 8
  srlv  $s7, $t0, $s7
  push  $s7
  lw    $s6, 4($sp)         # store final stats back into registers cause it's easier to read
  lw    $s5, 8($sp)
  lw    $ra, 12($sp)        # get return address
  jr    $ra                 # return to caller

org 0x3000
lock_addr:
  cfw 0x0
