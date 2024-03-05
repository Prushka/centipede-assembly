#####################################################################
#
# CSC258H Winter 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Dan Lyu
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# 1,2,3,4
#
# Which approved additional features have been implemented?
# Milestone 4:
# 1. The bug has 5 hp and the number is displayed on the top left corner in real time, the bug dies when hp becomes 0.
#    Hp drops when bug gets hit by a flea.
# 2. The game ends with a "WOW!" screen with the score achieved (in decimal number of format 000) if the player successfully killed the centipede (by hitting it 3 times).
#    If the bug died, an "Oh..." message would appear with the score obtained. The message with "RE:S" is indicating that pressing the button 'S' would restart the entire game.
#    Score gets increased by 1 when the player hits one mushroom
#    Score gets increased by 10 when the player kills the centipede
# These features use multiple 5*5 2d text arrays, which can be found in the data section. The implementation used to display any number given the number value and these 2d arrays can be found in print_letter and print_number.
#
#
#####################################################################

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
	winColor: .word 0x43A047
	loseColor: .word 0xF44336
	scoreColor: .word 0xE040FB
	restartColor: .word 0xF50057
	hpCounterColor: .word 0x90CAF9
	
	fleaSpawnChance: .word 15	
	fleaMushroomSpawnChance: 28

	bugLocation: .word 1007
	centipedeHP: .word 3
	centipedeHeadCurrLocation: .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
	centipedeDirection: .word 1
	bugHP: .word 5
	
	dartLocation: .word -33
	fleaLocation: .word 1056
	gameState: .word 0 # -1: lose 1: win
	loopCounter: .word 0
	fleaPrevColor: .word 0x000000
	mushroomsScore: .word 0
	
	paintedHPCache: .word -1
	
	colon: .word
	0,0,1,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,1,0,0
	
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
	
	num_0: .word
	1,1,1,1,1,
	1,0,0,1,1,
	1,0,1,0,1,
	1,1,0,0,1,
	1,1,1,1,1

	num_1: .word
	0,0,1,0,0,
	0,1,1,0,0,
	0,0,1,0,0,
	0,0,1,0,0,
	0,1,1,1,0

	num_2: .word
	1,1,1,1,0,
	0,0,0,0,1,
	0,1,1,1,0,
	1,0,0,0,0,
	1,1,1,1,1
	
	num_3: .word
	1,1,1,1,1,
	0,0,0,0,1,
	0,1,1,1,0,
	0,0,0,0,1,
	1,1,1,1,1
	
	num_4: .word
	1,0,0,0,0,
	1,0,0,0,0,
	1,0,1,0,0,
	1,1,1,1,1,
	0,0,1,0,0
	
	num_5: .word
	1,1,1,1,1,
	1,0,0,0,0,
	1,1,1,1,0,
	0,0,0,0,1,
	1,1,1,1,0
	
	num_6: .word
	1,1,1,1,1,
	1,0,0,0,0,
	1,1,1,1,1,
	1,0,0,0,1,
	1,1,1,1,1
	
	num_7: .word
	1,1,1,1,1,
	0,0,0,0,1,
	0,0,0,1,0,
	0,0,1,0,0,
	0,0,1,0,0
	
	num_8: .word
	1,1,1,1,1,
	1,0,0,0,1,
	1,1,1,1,1,
	1,0,0,0,1,
	1,1,1,1,1
	
	num_9: .word
	1,1,1,1,1,
	1,0,0,0,1,
	1,1,1,1,1,
	0,0,0,0,1,
	1,1,1,1,1
	
	excl: .word
	0,0,1,0,0,
	0,0,1,0,0,
	0,0,1,0,0,
	0,0,0,0,0,
	0,0,1,0,0
	
	dot: .word
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,1,0,0
	
	R: .word
	1,1,1,1,0,
	1,0,0,0,1,
	1,1,1,1,0,
	1,0,0,0,1,
	1,0,0,0,1
	
	E: .word
	1,1,1,1,1,
	1,0,0,0,0,
	1,1,1,1,0,
	1,0,0,0,0,
	1,1,1,1,1
	
	S: .word
	1,1,1,1,1,
	1,0,0,0,0,
	1,1,1,1,1,
	0,0,0,0,1,
	1,1,1,1,1
	
.text 


reset:
	li $s0, -1
	la $t1, centipedeHP
	li $t2, 3
	sw $t2, 0($t1)
	
	la $t1, bugLocation
	li $t2, 1007
	sw $t2, 0($t1)
	
	la $t1, bugHP
	li $t2, 5
	sw $t2, 0($t1)
	
	la $t1, paintedHPCache
	li $t2, -1
	sw $t2, 0($t1)
	
	la $t1, centipedeDirection
	li $t2, 1
	sw $t2, 0($t1)
	
	la $t1, dartLocation
	li $t2, -33
	sw $t2, 0($t1)

	la $t1, fleaLocation
	li $t2, 1056
	sw $t2, 0($t1)
		
	la $t1, gameState
	li $t2, 0
	sw $t2, 0($t1)
	
	la $t1, mushroomsScore
	li $t2, 0
	sw $t2, 0($t1)
	
	la $t1, fleaPrevColor
	li $t2, 0x000000
	sw $t2, 0($t1)
	
	# reset centipedeHeadCurrLocation
	la $t0, centipedeHeadCurrLocation
	li $t1, 0 # counter
	li $t2, 9
	j reset_centipedeHeadCurrLocation
	

reset_centipedeHeadCurrLocation:
	bge $t1, 10, reset_loop
	sll $t3, $t1, 2
	add $t3, $t3, $t0
	sub $t4, $t2, $t1
	sw $t4, 0($t3)
	addi $t1, $t1, 1
	j reset_centipedeHeadCurrLocation
	
reset_loop:
	bge $s0, 1024, reset_end
	addi $s0, $s0, 1
	lw $t1, displayAddress
	lw $t2, black
	sll $t3, $s0, 2
	add $t3, $t3, $t1
	sw $t2, 0($t3)
	
	
	j reset_loop

reset_end:
	jal paint_mushrooms
	lw $t0, displayAddress
	lw $t1, bugLocation
	sll $t1, $t1, 2
	add $t1, $t1, $t0
	lw $t2, bugColor
	sw $t2, 0($t1)
	


Loop:
	lw $t0, gameState
	beq $t0, 0, game_running
	beq $t0, 1, game_won
	beq $t0, -1, game_lost
	
	
Exit:
	li $v0, 10		# terminate the program gracefully
	syscall

	
print_letter: # print letter $a0 (array address) at $a1 (location value) with $a3 color
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
	
	
	
game_lost:
	jal check_keystroke
	j loop_delay
	
game_won:
	jal check_keystroke
	j loop_delay

game_running:
	jal check_keystroke
	jal update_dart
	jal paint_centipede
	jal find_next_locations
	jal update_flea
	jal update_bug_hp
	j loop_delay


update_bug_hp:
	addi $v1, $ra, 0
	lw $a2, bugHP
	lw $t0, paintedHPCache
	
	li $s0, 32
	lw $s1, displayAddress 
	li $s2, 0 # counter
	li $s3, 5
	bne $t0, $a2, reset_hp_area

paint_hp:
	lw $a3, hpCounterColor
	li $a1, 0
	jal print_number
	
	jr $v1

reset_hp_area:
	div $s2, $s3
	mflo $t3
	mfhi $t5
	mul $t4, $t3, $s0
	
	add $t4, $t4, $t5
	sll $t4, $t4, 2
	add $t4, $t4, $s1 # t4 is the address of the curr location
	lw $t5, black
	sw $t5, 0($t4)
	
	addi $s2, $s2, 1
	ble $s2, 24, reset_hp_area
	la $t0, paintedHPCache
	sw $a2, 0($t0)
	j paint_hp
	
game_over_win:
	# the player killed the centipede, add another 10 pts?
	lw $t0, mushroomsScore
	la $t1, mushroomsScore
	addi $t0, $t0, 10
	sw $t0, 0($t1)
	
	la $t0, gameState
	li $t1, 1
	sw $t1, 0($t0)
	
	la $a0, W
	li $a1, 164
	lw $a3, winColor
	jal print_letter
	
	la $a0, O
	li $a1, 170
	jal print_letter
	
	la $a0, W
	li $a1, 176
	jal print_letter
	
	la $a0, excl
	li $a1, 182
	jal print_letter
	
	j print_score

	
game_over_lose:
	la $t0, gameState
	li $t1, -1
	sw $t1, 0($t0)
	
	
	la $a0, O
	li $a1, 164
	lw $a3, loseColor
	jal print_letter
	
	la $a0, H
	li $a1, 170
	jal print_letter
	
	la $a0, dot
	li $a1, 176
	jal print_letter
	
	la $a0, dot
	li $a1, 182
	jal print_letter
	
	
	j print_score

print_score:
	lw $a3, restartColor
	
	la $a0, R
	li $a1, 388
	jal print_letter
	
	la $a0, E
	li $a1, 394
	jal print_letter
	
	la $a0, colon
	li $a1, 400
	jal print_letter
	
	la $a0, S
	li $a1, 406
	jal print_letter
	
	#hmm 000 @389
	lw $a3, scoreColor
	
	li $s5, 10
	lw $s4, mushroomsScore
	div $s4, $s5
	mfhi $a2 # 00?
	mflo $s6 # xx?
	
	li $a1, 626
	jal print_number
	
	
	div $s6, $s5
	mfhi $a2 # 0?0
	mflo $s6 # ?00
	
	li $a1, 619
	jal print_number
	
	div $s6, $s5
	mfhi $a2
	li $a1, 612
	jal print_number
	
	
	j Loop

print_number: # print a number $a2
	addi $v0, $ra, 0 # .
	la $a0, num_0
	beq $a2, 0, print_letter
	la $a0, num_1
	beq $a2, 1, print_letter
	la $a0, num_2
	beq $a2, 2, print_letter
	la $a0, num_3
	beq $a2, 3, print_letter
	la $a0, num_4
	beq $a2, 4, print_letter
	la $a0, num_5
	beq $a2, 5, print_letter
	la $a0, num_6
	beq $a2, 6, print_letter
	la $a0, num_7
	beq $a2, 7, print_letter
	la $a0, num_8
	beq $a2, 8, print_letter
	la $a0, num_9
	beq $a2, 9, print_letter
	jr $v0
	
loop_delay:
	li $v0, 32
	li $a0, 50
	syscall
	la $t0, loopCounter
	lw $t1, loopCounter
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j Loop

update_flea:
	addi $sp, $sp, -4
	sw $ra, 0($sp) # store the return address to stack
	
	lw $t0, fleaLocation
	bge $t0, 1056, add_flea # there's no flea in the game
	
	j paint_flea
	jr $ra
	
add_flea:
	lw $t0, loopCounter
	li $v0, 42
	li $a0, 0
	lw $a1, fleaSpawnChance
	syscall
	beq $a0, 0, add_flea_2
	
	lw $ra, 0($sp) # don't add
    	addi $sp, $sp, 4

    	jr $ra
	

add_flea_2:
	li $v0, 42
	li $a0, 1
	li $a1, 30 # spawning at edges would cause incorrect mushroom locations (in case two mushrooms spawn at the same row at index 0 and 31)
	syscall
	# flea starts from a random location, which is $a0
	
	la $t0, fleaLocation
	sw $a0, 0($t0)
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra

paint_flea:
	lw $t0, displayAddress
	lw $t1, fleaLocation
	lw $t2, fleaColor
	sll $t3, $t1, 2
	add $t3, $t3, $t0
	
	la $t4, fleaLocation
	
	lw $t7, 0($t3) # $t7: the color of the current pixel
	lw $t6, bugColor
	bne $t7, $t6, paint_flea_2 # did not collide with the bug
	jal bug_lose_hp

paint_flea_2:
	add $t6, $t1, -32
	sll $t6, $t6, 2
	add $t6, $t6, $t0
	lw $t5, 0($t6) # get the pixel color from the line above
	beq $t5, $t2, remove_previous_flea

paint_flea_3:
	lw $s0, 0($t3)
	la $s1, fleaPrevColor
	sw $s0, 0($s1)
	
	sw $t2, 0($t3) # paint the flea
	add $t2, $t1, 32
	sw $t2, 0($t4) # save the next flea
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra

bug_lose_hp:
	add $v1, $ra, 0
	lw $s6, bugHP
	add $s6, $s6, -1
	ble $s6, 0, game_over_lose
	la $s5, bugHP
	sw $s6, 0($s5)
	jr $v1
	
remove_previous_flea:
	lw $t7, fleaPrevColor
	sw $t7, 0($t6)
	
	li $v0, 42
	li $a0, 0
	lw $a1, fleaMushroomSpawnChance
	syscall 
	beq $a0, 0, add_flea_mushroom
	j paint_flea_3

add_flea_mushroom:
	bge $t1, 1023, paint_flea # do not add mushrooms at the bottom line
	lw $t7, mushroomColor
	sw $t7, 0($t6)
	j paint_flea_3
	
update_dart:
	addi $sp, $sp, -4
	sw $ra, 0($sp) # store the return address to stack
	lw $t0, dartLocation
	bge $t0, -32, paint_dart # change this later?
	jr $ra

paint_dart:
	lw $t0, displayAddress
	lw $t1, dartColor
	lw $t2, dartLocation
	
	add $t4, $t2, 32
	sll $t4, $t4, 2
	add $t4, $t0, $t4
	lw $t5, 0($t4) # get the pixel color from the line below
	beq $t5, $t1, remove_previous_dart
	
paint_dart_2:
	sll $t3, $t2, 2
	add $t3, $t3, $t0
	la $t0, dartLocation
	
	lw $t5, 0($t3)
	lw $t6, mushroomColor
	beq $t5, $t6, dart_collides_mushroom # collides mushroom
	
	lw $t6, centipedeHeadColor
	beq $t5, $t6, dart_collides_centipede # collides centipede
	lw $t6, centipedeBodyColor
	beq $t5, $t6, dart_collides_centipede # collides centipede
	
	
	sw $t1, 0($t3) # paint the dart
	add $t2, $t2, -32 # save the next dart
	sw $t2, 0($t0)
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra

dart_collides_centipede:
	lw $t5, centipedeHP # $t0: curr hp
	add $t5, $t5, -1
	ble $t5, 0, game_over_win
	la $t6, centipedeHP
	sw $t5, 0($t6)
	li $t2, -33
	sw $t2, 0($t0) # remove dart
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra
    	
dart_collides_mushroom:
	lw $t1, black
	sw $t1, 0($t3)
	li $t2, -33
	sw $t2, 0($t0) # remove dart
	
	la $s0, mushroomsScore
	lw $s1, mushroomsScore
	addi $s1, $s1, 1
	sw $s1, 0($s0)
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra

remove_previous_dart:
	lw $t6, black
	sw $t6, 0($t4)
	j paint_dart_2

    	
paint_centipede:
	lw $s0, centipedeHeadColor
	lw $s1, centipedeBodyColor
	lw $s2, displayAddress
	li $s3, 1
	la $s4, centipedeHeadCurrLocation
	lw $t1, 0($s4)
	sll $t0, $t1, 2
	add $t0, $t0, $s2
	sw $s0, 0($t0)
	j paint_centipede_loop
	
paint_centipede_loop:
	sll $t4, $s3, 2
	add $t5, $s4, $t4 # t5 is the address of currlocation array element
	lw $t6, 0($t5)
	sll $t6, $t6, 2 # t6 is the value of currlocation
	add $t7, $t6, $s2
	sw $s1, 0($t7)
	
	addi $s3, $s3, 1
	bne $s3, 10, paint_centipede_loop

	
    	jr $ra

find_next_locations:
	addi $sp, $sp, -4
	sw $ra, 0($sp) # store the return address to stack
	
	la $s1, centipedeHeadCurrLocation # load curr location address
	lw $s2, 0($s1) # centipedeHeadCurrLocation
	
	lw $s3, centipedeDirection # s3: direction
	add $s4, $s3, $s2 # s4: test location of the next centipede head
	
	li $t0, 32
	div $s4, $t0
	mfhi $s5 # s5: remainder
	beq $s3, -1, going_back # centipede's going backwards
	j going_forward # centipede's going forwards

going_back:
	beq $s5, 31, centipede_go_down # it meets the left bound
	j go_centipede_go

going_forward:
	beq $s5, 0, centipede_go_down # it meets the right bound
	j go_centipede_go
	
centipede_go_down:
	addi $s4, $s2, 32 # centipede goes to next row (s4 is the next position)
	sub $t2, $zero, $s3
	la $t0, centipedeDirection 
	sw $t2, 0($t0) # set direction = - direction
	
	j shift_store

go_centipede_go:
	lw $t0, displayAddress
	sll $t1, $s4, 2
	add $t1, $t1, $t0 # get the address of the next display address
	lw $t2, 0($t1) # get the color of the next display pixel
	
	lw $t3, mushroomColor # get the color of the mushroom
	beq $t2, $t3, centipede_go_down # next block is a mushroom

	j shift_store
	
shift_store:
	# store the new location to location[0] and shift all elements in the array down by 1
	add $s5, $s4, $zero # s5 is the new location
	li $s3, 9
	la $s4,centipedeHeadCurrLocation
	
	# remove the last body
	lw $t0, displayAddress
	lw $t1, black
	li $t2, 36
	# check if the head collides bug
	sll $t3, $s5, 2
	add $t3, $t3, $t0
	lw $t3, 0($t3)
	lw $t4, bugColor
	beq $t4, $t3, game_over_lose
	
	add $t2, $s4, $t2 # t2: the last element address of centipedeHeadCurrLocation
	lw $t3, 0($t2) # t3: the value of the last location
	sll $t3, $t3, 2
	add $t3, $t3, $t0
	sw $t1, 0($t3)
	j shift_loop

shift_loop:
	sll $t4, $s3, 2 # t4: counter * 4
	add $t5, $t4, $s4 # t5: counter * 4 + centipedeCurreLocation Address
	add $t6, $t5, $zero # t6: same as $t5
	addi $t6, $t6, -4 # t6 -= 4
	lw $t6, 0($t6) # load the value at $t5 to $t5
	sw $t6, 0($t5) # store the value at $t5 to $t6
	
	addi $s3, $s3, -1 # counter -= 1
	bge $s3, 1, shift_loop # counter <= 9, continue loop
	
	la $t0, centipedeHeadCurrLocation # t0: the address of the centipedeHeadCurrLocation
	sw $s5, 0($t0) # store the new location to index 0
        
	lw $ra, 0($sp)
    	addi $sp, $sp, 4

    	jr $ra
	
paint_mushrooms:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t3, 0		# mushroom initial position
	
paint_mushrooms_loop:
	li $v0, 42
	li $a0, 0
	lw $a1, mushroomRandGap
	syscall
	add $t3, $t3, $a0
	
	li $t0, 32
	div $t3, $t0
	mfhi $t1 # t1: remainder
	beq $t1, 31, mushroom_at_bound
	beq $t1, 0, mushroom_at_bound
	
paint_mushrooms_loop_2:
	lw $t4, mushroomColor
	lw $t5, displayAddress
	sll $t6, $t3, 2
	add $t5, $t6, $t5
	
	sw $t4, 0($t5)
	lw $t7, mushroomGenBottom
	ble $t3, $t7, paint_mushrooms_loop
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
mushroom_at_bound: # add 2
	addi $t3, $t3, 2
	j paint_mushrooms_loop_2
	
# function to detect any keystroke
check_keystroke:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t8, 0xffff0000
	beq $t8, 1, get_keyboard_input # if key is pressed, jump to get this key
	addi $t8, $zero, 0
	
	# pop a word off the stack and move the stack pointer
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# function to get the input key
get_keyboard_input:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t2, 0xffff0004
	addi $v0, $zero, 0	#default case
	beq $t2, 0x6A, respond_to_j
	beq $t2, 0x6B, respond_to_k
	beq $t2, 0x78, respond_to_x
	beq $t2, 0x73, respond_to_s
	
	# pop a word off the stack and move the stack pointer
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# Call back function of j key
respond_to_j:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, bugLocation	# load the address of buglocation from memory
	lw $t1, 0($t0)		# load the bug location itself in t1
	
	lw $t2, displayAddress  # $t2 stores the base address for display
	lw $t3, black	# $t3 stores the black colour code
	
	sll $t4,$t1, 2		# $t4 the bias of the old buglocation
	add $t4, $t2, $t4	# $t4 is the address of the old bug location
	sw $t3, 0($t4)		# paint the first (top-left) unit white.
	
	beq $t1, 992, skip_movement # prevent the bug from getting out of the canvas
	addi $t1, $t1, -1	# move the bug one location to the right
skip_movement:
	sw $t1, 0($t0)		# save the bug location

	lw $t3, bugColor	# $t3 stores the white colour code
	
	sll $t4,$t1, 2
	add $t4, $t2, $t4
	sw $t3, 0($t4)		# paint the first (top-left) unit white.
	
	
	# pop a word off the stack and move the stack pointer
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Call back function of k key
respond_to_k:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, bugLocation	# load the address of buglocation from memory
	lw $t1, 0($t0)		# load the bug location itself in t1
	
	lw $t2, displayAddress  # $t2 stores the base address for display
	lw $t3, black	# $t3 stores the black colour code
	
	sll $t4,$t1, 2		# $t4 the bias of the old buglocation
	add $t4, $t2, $t4	# $t4 is the address of the old bug location
	sw $t3, 0($t4)		# paint the block with black
	
	beq $t1, 1023, skip_movement2 #prevent the bug from getting out of the canvas
	addi $t1, $t1, 1	# move the bug one location to the right
skip_movement2:
	sw $t1, 0($t0)		# save the bug location
	
	lw $t3, bugColor	# $t3 stores the white colour code
	
	sll $t4,$t1, 2
	add $t4, $t2, $t4
	sw $t3, 0($t4)		# paint the block with white
	
	
	# pop a word off the stack and move the stack pointer
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
respond_to_x:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, dartLocation
	bge $t0, 0, skip_dartmovement
	# pop a word off the stack and move the stack pointer
	la $t0, dartLocation
	lw $t1, bugLocation
	add $t1, $t1, -32 # dart location (initial)
	sw $t1, 0($t0)

skip_dartmovement:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
respond_to_s:
	# move stack pointer a work and push ra onto it
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	j reset
