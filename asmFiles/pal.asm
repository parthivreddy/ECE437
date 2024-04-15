#--------------------------------------------------------------
# core 0
org 0x0000
ori $s0, $zero, 7               #set initial seed
ori $s1, $zero, 0               #set initial counter
ori $s7, $zero, 256             #set final counter value
ori $sp, $zero, 0xAFFC
j mainp0                        #producer loop
end0:

halt


# core 1
org 0x0200
ori $s1, $zero, 0               #set initial counter
ori $s7, $zero, 256             #set final counter value
ori $sp, $zero, 0xCFFC

ori $s2, $zero, 0xFFFFFFFF      #set initial min
ori $s3, $zero, 0               #set initial max
ori $s4, $zero, 0               #set initial total
j mainp1
end1:

ori $t0, $zero, 8               #set denominator to 8
srlv $s4, $t0, $s4              #shift right by 8 to divide total by 256

halt


#------------------------------------------------------


#-MAIN0-----------------------------------------------------
mainp0:
ori $a0, $zero, lock_location   #set lock location as argument
jal lock                        #p0 gets lock

ori $a0, $s0, 0                 #set argument to bottom 16 bits of saved result
jal crc32                       #generates random number at $v0

or $s0, $v0, $zero              #save random number for use in next iter
or $a0, $v0, $zero              #move random number to argument
jal push1                       #push crc32 result onto shared stack

ori $a0, $zero, lock_location   #move lock to arguement register
jal unlock                      #store done signal

addi $s1, $s1, 1                #increment counter
bne $s1, $s7, mainp0            #loop until counter hits 256

j end0
#------------------------------------------------------


#-MAIN1-----------------------------------------------------
mainp1:

ori $a0, $zero, lock_location   #set lock location as argument
jal lock                        #p1 gets lock

ori $t0, $zero, stack_size      #get stack size address
lw $t1, 0($t0)                  #load stack size
beq $t1, $zero, stack_empty     #check if stack is empty and branch
j stack_not_empty

#if stack is empty, wait for stack to be populated
stack_empty:

ori $a0, $zero, lock_location   #move lock to arguement register
jal unlock  
j mainp1


#if stack not empty, do operations
stack_not_empty:
jal pop1                         #pop element off stack into $v0

ori $a0, $zero, lock_location   #move lock to arguement register
jal unlock  

andi $v0, $v0, 0xFFFF           #get bottom 16 bits of popped element

#min
ori $a0, $v0, 0                 #move popped element into argument of min function
ori $a1, $s2, 0                 #move current min into arg of min function
jal min                         #call min
ori $s2, $v0, 0                 #save result of min to s2

#max
                                #popped elemnt already in a0
ori $a1, $s3, 0                 #move current min into arg of max function
jal max                         #call max
ori $s3, $v0, 0                 #save result of max to s3

#total
add $s4, $s4, $a0               #add popped element to total
ori $s3, $v0, 0                 #save result of total to s4


addi $s1, $s1, 1                #increment counter
bne $s1, $s7, mainp1            #loop until counter hits 256

j end1

#------------------------------------------------------


#-LOCK-----------------------------------------------------
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra

#------------------------------------------------------


#-UNLOCK-----------------------------------------------------
unlock:
  sw    $0, 0($a0)
  jr    $ra

#------------------------------------------------------


#-PUSH-----------------------------------------------------
push1:
    ori $t6, $zero, stack_pointer #get address where value of stack pointer is stored
    lw $gp, 0($t6)                #load stack pointer value
    addi $gp, $gp, -4             #decrement stack pointer by 4
    sw $a0, 0($gp)                #store value into stack pointer
    sw $gp, 0($t6)                #put updated stack pointer back at stack pointer value location

    ori $t5, $zero, stack_size    #get address of stack size
    lw $t4, 0($t5)                #load stack size into t4
    addi $t4, $t4, 1              #increment stack size
    sw $t4, 0($t5)                #store new stack size into mem

    jr $ra

#------------------------------------------------------


#-POP-----------------------------------------------------
pop1:
    ori $t6, $zero, stack_pointer #get address where value of stack pointer is stored
    lw $gp, 0($t6)                #load stack pointer value
    lw $v0, 0($gp)                #load top element from stack
    sw $zero, 0($gp)              #zero out element thats been popped
    addi $gp, $gp, 4              #increment stack pointer by 4
    sw $gp, 0($t6)                #put updated stack pointer back at stack pointer value location
   

    ori $t5, $zero, stack_size    #get address of stack size
    lw $t4, 0($t5)                #load stack size into t4
    addi $t4, $t4, -1             #decrement stack size
    sw $t4, 0($t5)                #store new stack size into mem

    jr $ra
#------------------------------------------------------



#-CRC-----------------------------------------------------
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



org 0x4000

lock_location: #4000
cfw 0x0

stack_size: #4004
cfw 0x0

stack_pointer: #4008
cfw 0x8000     #stack base at 0x8000
