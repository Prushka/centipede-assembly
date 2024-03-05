.data
	displayAddress:	.word 0x10008000
	centipedeHeadColor: .word 0xF1BFB5
	centipedeBodyColor: .word 0x9c5f52
	mushroomColor: .word 0x36A18C
	mushroomRandGap: .word 120
	mushroomGenBottom: .word 800
	black: .word 0x000000
	bugColor: .word 0xFF5776
	dartColor: .word 0x7530FF
	fleaColor: .word 0xFFFC57
	centipedeBodySegments: .word 9
	
	fleaSpawnChance: .word 15	
	fleaMushroomSpawnChance: 28

	bugLocation: .word 1007
	centipedeHP: .word 3
	centipedeHeadCurrLocation: .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
	centipedeDirection: .word 1
	
	dartLocation: .word -33
	fleaLocation: .word 1056
	gameState: .word 0 # -1: lose 1: win
	loopCounter: .word 0
	fleaPrevColor: .word 0x000000
	mushroomsScore: .word 0
	
	W: .word 
	1,0,0,0,1,
	1,0,0,0,1,
	1,0,0,0,1,
	1,0,1,0,1,
	1,1,0,1,1

	O: .word
	1,1,1,1,1,
	1,0,0,0,1,
	1,0,0,0,1,
	1,0,0,0,1,
	1,1,1,1,1

	H: .word
	1,0,0,0,1,
	1,0,0,0,1,
	1,1,1,1,1,
	1,0,0,0,1,
	1,0,0,0,1
	
.text 


	
main:
	
	la $a0, W
	li $a1, 0
	lw $a3, mushroomColor
	
	jal print_letter
	
	la $a0, O
	li $a1, 6
	lw $a3, mushroomColor
	
	jal print_letter
	
	la $a0, W
	li $a1, 12
	lw $a3, mushroomColor
	jal print_letter

	
exit:
	li $v0, 10
	syscall
	
	
print_letter: # print letter $a0 (array) at $a1 (location) with $a3 color
	li $t0, 0 # counter
	li $s0, 32
	lw $s1, displayAddress 
	addi $s2, $ra, 0 # .
	li $s3, 5
	
	
print_letter_loop:
	div $t0, $s3
	mflo $t3
	mfhi $t5
	mul $t4, $t3, $s0
	
	add $t4, $a1, $t4
	add $t4, $t4, $t5
	sll $t4, $t4, 2
	add $t4, $t4, $s1 # t4 is the address of the curr location
	
	sll $t6, $t0, 2
	add $t6, $t6, $a0
	lw $t6, 0($t6)
	bne $t6, 1, dont_print_me
	sw $a3, 0($t4)
	
dont_print_me:
	addi $t0, $t0, 1
	ble $t0, 24, print_letter_loop
	jr $s2
	