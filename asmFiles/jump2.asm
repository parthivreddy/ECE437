# code segment
  org 0x0000

  ori   $10, $0, 0xB00F
  ori   $11, $0, 0x0BAD
  ori   $12, $0, 0xBEEF
  ori	$6, $0, 0xFF00	# $6 = 01 | 0
  

  j	 jump_right	# if $t0 == $t1 then goto target
  sw		$11, 0($6)		# 
  
jump_return:
  jal jal_correct
jal_return:
  sw		$10, 8($6)
  
  # jr $12
  sw $12, 12($6)
  
  halt

  jump_right:
    sw		$10, 0($6)
    j jump_return

  jal_correct:
    sw		$10, 4($6)
    j jal_return
