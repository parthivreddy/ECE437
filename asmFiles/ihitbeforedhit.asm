# have a icache populated but dcache empty, have a miss on dcache while it fetches/writes to ram instruction fetch for ihit
  org 0x0000
  ori $1, $0, 0xFFC0
  ori $2, $0, 0xB00F
  ori $5, $0, 10
loop:
  sw $2, 0($1) # miss every time since addr is changing 
  addi $1, $1, -4 #decrement daddr
  addi $3, $3, 1
  bne $3, $5, loop
  
  halt # B00F should be written to 10 memory addresses
