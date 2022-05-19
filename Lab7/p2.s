.text

# bool rule1(unsigned short* board) {
#   bool changed = false;
#   for (int y = 0 ; y < GRIDSIZE ; y++) {
#     for (int x = 0 ; x < GRIDSIZE ; x++) {
#       unsigned value = board[y*GRIDSIZE + x];
#       if (has_single_bit_set(value)) {
#         for (int k = 0 ; k < GRIDSIZE ; k++) {
#           // eliminate from row
#           if (k != x) {
#             if (board[y*GRIDSIZE + k] & value) {
#               board[y*GRIDSIZE + k] &= ~value;
#               changed = true;
#             }
#           }
#           // eliminate from column
#           if (k != y) {
#             if (board[k*GRIDSIZE + x] & value) {
#               board[k*GRIDSIZE + x] &= ~value;
#               changed = true;
#             }
#           }
#         }
#       }
#     }
#   }
#   retuan changed;
# }
#a0: board

.globl rule1
rule1:
	addi	$sp, $sp, -32		# Push 8 registers (s0 - s7)
	sw	$s0, 0($sp)		# s0 = GRIDSIZE = 4
	sw	$s1, 4($sp)		# s1 = y
	sw	$s2, 8($sp)		# s2 = x
	sw	$s3, 12($sp)		# s3 = value
	sw	$s4, 16($sp)		# s4 = k
	sw	$s5, 20($sp)		# s5 = temp arr
	sw	$s6, 24($sp)		# 
	sw	$s7, 28($sp)		# 

	li	$v0, 0			# bool changed = false
	li	$s0, 4			# GRIDSIZE = 4
	li	$s1, 0			# int y = 0

for_1:
	bge	$s1, $s0, end_1		# if (y >= GRIDSIZE), end loop
	li	$s2, 0			# int x = 0

for_2:
	bge	$s2, $s0, end_2		# if (x >= GRIDSIZE), end loop
	li	$s3, 0			# ----s3 = 0
	sll	$s3, $s1, 2		# ----y*GRIDSIZE
	add	$s3, $s3, $s2		# ----y*GRIDSIZE + x
	sll	$s3, $s3, 1		# ----sizeof(short) * index
	add	$s3, $s3, $a0		# ----board[y*GRIDSIZE + x] addr
	lh	$s3, 0($s3)		# value = board[y*GRIDSIZE + x]

	move	$s4, $a0		# ----store board in s4
	move	$s7, $ra		# ----store ra in s7
	move	$s5, $v0		# ----store v0 in s5
	move	$a0, $s3		# ----Set up args for has_single_bit_set
	jal	has_single_bit_set	# has_single_bit_set
	move	$s6, $v0		# s4 = v0 = has_single_bit_set(value) 
	move	$a0, $s4		# ----revert board in a0
	move	$ra, $s7		# ----revert ra in ra
	move	$v0, $s5		# ----revert return in v0
	move	$s4, $s6		# ----s4 = has_single_bit_Set(value)

if_1:
	beq	$s4, $zero, else_1	# if(has_single_bit_set(value))
	li	$s4, 0			# int k = 0

for_3:
	bge	$s4, $s0, end_3		# if (k >= GRIDSIZE), end loop

if_2:
	beq	$s4, $s2, else_2	# if (k == x), end if
	sll	$s5, $s1, 2		# ----y*GRIDSIZE
	add	$s5, $s5, $s4		# ----y*GRIDSIZE + k
	sll	$s5, $s5, 1		# ----sizeof(short) * index
	add	$s5, $s5, $a0		# ----board[y*GRIDSIZE + k] addr
	lh	$s6, 0($s5)		# s6 = board[y*GRIDSIZE + k]	
	and	$s6, $s6, $s3		# board[y*GRIDSIZE + k] & value

if_3:
	beq	$s6, $zero, else_3	# if (board[y*GRIDSIZE + k] & value == 0), end if
	lh	$s6, 0($s5)		# s6 = board[y*GRIDSIZE + k]
	not	$s7, $s3		# ~value
	and	$s6, $s6, $s7		# board[y*GRIDSIZE + k] & ~value
	sh	$s6, 0($s5)		# board[y*GRIDSIZE + k] &= ~value
	li	$v0, 1			# changed = true

else_3:

else_2:

if_4:
	beq	$s4, $s1, else_4	# if (k == y), end if
	sll	$s5, $s4, 2		# ----k*GRIDSIZE
	add	$s5, $s5, $s2		# ----k*GRIDSIZE + x
	sll	$s5, $s5, 1		# ----sizeof(short) * index
	add	$s5, $s5, $a0		# ----board[k*GRIDSIZE + x] addr
	lh	$s6, 0($s5)		# s6 = board[k*GRIDSIZE + x]	
	and	$s6, $s6, $s3		# board[k*GRIDSIZE + x] & value

if_5:
	beq	$s6, $zero, else_5	# if (board[k*GRIDSIZE + x] & value == 0), end if
	lh	$s6, 0($s5)		# s6 = board[k*GRIDSIZE + x]
	not	$s7, $s3		# ~value
	and	$s6, $s6, $s7		# board[k*GRIDSIZE + x] & ~value
	sh	$s6, 0($s5)		# board[k*GRIDSIZE + x] &= ~value
	li	$v0, 1			# changed = true

else_5:

else_4:

	addi	$s4, $s4, 1		# ++k
	j	for_3
end_3:

else_1:

	addi	$s2, $s2, 1		# ++x
	j	for_2
end_2:

	addi	$s1, $s1, 1		# ++y
	j	for_1
end_1:
	# move	$ra, $s7

	lw	$s0, 0($sp) 
	lw	$s1, 4($sp) 
	lw	$s2, 8($sp) 	
	lw	$s3, 12($sp) 	
	lw	$s4, 16($sp) 
	lw	$s5, 20($sp) 	
	lw	$s6, 24($sp) 	
	lw	$s7, 28($sp)
	addi	$sp, $sp, 32		# Pop 8 registers (s0 - s7)

	jr	$ra
	
	
	
# bool solve(unsigned short *current_board, unsigned row, unsigned col, Puzzle* puzzle) {
#     if (row >= GRIDSIZE || col >= GRIDSIZE) {
#         bool done = board_done(current_board, puzzle);
#         if (done) {
#             copy_board(current_board, puzzle->board);
#         }

#         return done;
#     }
#     current_board = increment_heap(current_board);

#     bool changed;
#     do {
#         changed = rule1(current_board);
#         changed |= rule2(current_board);
#     } while (changed);

#     short possibles = current_board[row*GRIDSIZE + col];
#     for(char number = 0; number < GRIDSIZE; ++number) {
#         // Remember & is a bitwise operator
#         if ((1 << number) & possibles) {
#             current_board[row*GRIDSIZE + col] = 1 << number;
#             unsigned next_row = ((col == GRIDSIZE-1) ? row + 1 : row);
#             if (solve(current_board, next_row, (col + 1) % GRIDSIZE, puzzle)) {
#                 return true;
#             }
#             current_board[row*GRIDSIZE + col] = possibles;
#         }
#     }
#     return false;
# }

.globl solve
solve:
	addi	$sp, $sp, -32		# Push 8 registers (s0 - s7)
	sw	$s0, 0($sp)		# s0 = GRIDSIZE
	sw	$s1, 4($sp)		#
	sw	$s2, 8($sp)		#
	sw	$s3, 12($sp)		#
	sw	$s4, 16($sp)		#
	sw	$s5, 20($sp)		#
	sw	$s6, 24($sp)		# s6 = number
	sw	$s7, 28($sp)		# s7 = changed / possibles

	li	$s0, 4

sif_1:
	blt	$a1, $s0, selse_1	# if (row < GRIDSIZE), check col
sif_1_2:
	move	$s1, $a0		# ----Save *current_board
	move	$s2, $a1		# ----Save row
	move	$s3, $a2		# ----Save col
	move	$s4, $a3		# ----Save *puzzle
	move	$s5, $ra		# ----Save ra
	move	$a1, $a3		# ----Setup arguments
	jal	board_done		# board_done(current_board, puzzle)
	move	$a0, $s1		# ----Restore a0
	move	$a1, $s2		# ----Restore a1
	move	$a2, $s3		# ----Restore a2
	move	$a3, $s4		# ----Restore a3
	move	$ra, $s5		# ----Restore ra

sif_3:
	beq	$v0, $zero, selse_3	# if (!done), end if
	move	$s1, $a0		# ----Save *current_board
	move	$s2, $a1		# ----Save row
	move	$s3, $a2		# ----Save col
	move	$s4, $a3		# ----Save *puzzle
	move	$s5, $ra		# ----Save ra
	move	$s6, $v0		# ----Save Done
	move	$a1, $a3		# ----Setup arguments
	jal	copy_board		# current_board(current_board, puzzle->board)
	move	$a0, $s1		# ----Restore a0
	move	$a1, $s2		# ----Restore a1
	move	$a2, $s3		# ----Restore a2
	move	$a3, $s4		# ----Restore a3
	move	$ra, $s5		# ----Restore ra	
	move	$v0, $s6		# ----Restore v0

selse_3:
	j	sreturn			# return done

selse_1:
sif_2:
	blt	$a2, $s0, selse_2

	j	sif_1_2
selse_2:
	move	$s1, $a1		# ----Save row
	move	$s2, $a2		# ----Save col
	move	$s3, $a3		# ----Save *puzzle
	move	$s4, $ra		# ----Save ra
	jal	increment_heap		# increment_heap(current_board)
	move	$a0, $v0		# current_board = increment_heap(current_board)
	move	$a1, $s1		# ----Restore a1
	move	$a2, $s2		# ----Restore a2
	move	$a3, $s3		# ----Restore a3
	move	$ra, $s4		# ----Restore ra	

sdowhile_1:
	move	$s1, $a0		# ----Save current_board
	move	$s2, $a1		# ----Save row
	move	$s3, $a2		# ----Save col
	move	$s4, $a3		# ----Save *puzzle
	move	$s5, $ra		# ----Save ra
	jal	rule1			# rule1(current_board)
	move	$s7, $v0		# s7 = changed = rule1(current_board)
	move	$a0, $s1		# ----Restore a0
	move	$a1, $s2		# ----Restore a1
	move	$a2, $s3		# ----Restore a2
	move	$a3, $s4		# ----Restore a3
	move	$ra, $s5		# ----Restore ra

	move	$s1, $a0		# ----Save current_board
	move	$s2, $a1		# ----Save row
	move	$s3, $a2		# ----Save col
	move	$s4, $a3		# ----Save *puzzle
	move	$s5, $ra		# ----Save ra
	jal	rule2			# rule2(current_board)
	move	$s6, $v0		# s6 = rule2(current_board)
	or	$s7, $s7, $s6		# s7 = changed |= rule1(current_board)
	move	$a0, $s1		# ----Restore a0
	move	$a1, $s2		# ----Restore a1
	move	$a2, $s3		# ----Restore a2
	move	$a3, $s4		# ----Restore a3
	move	$ra, $s5		# ----Restore ra

	bne	$s7, $zero, sdowhile_1	# while (changed), jump to top of loop
sloopend_1:
	sll	$s6, $a1, 2		# ----row*GRIDSIZE
	add	$s6, $s6, $a2		# ----row*GRIDSIZE + col
	sll	$s6, $s6, 1		# ----sizeof(short) * index
	add	$s6, $s6, $a0		# currentBoard[row*GRIDSIZE + col]
	lh	$s7, 0($s6)		# s7 = possibles = ^

	li	$s6, 0			# s6 = number = 0

sfor_1:
	bge	$s6, $s0, send_1	# if (number >= GRIDSIZE), end for
	li	$s1, 1
	sllv	$s1, $s1, $s6		# ----s1 = 1 << number
	and	$s2, $s7, $s1		# s2 = (1 << number) & possibles

sif_4:
	beq	$s2, $zero, selse_4	# if (!(1 << number) & possibles), end if
	sll	$s3, $a1, 2		# ----row*GRIDSIZE
	add	$s3, $s3, $a2		# ----row*GRIDSIZE + col
	sll	$s3, $s3, 1		# ----sizeof(short) * index
	add	$s3, $s3, $a0		# currentBoard[row*GRIDSIZE + col]
	sh	$s1, 0($s3)		# current_board[row*GRIDSIZE + col] = 1 << number;
	addi	$s4, $s0, -1		# ----s4 = GRIDSIZE - 1

sif_5:
	bne	$a2, $s4, selse_5	# if (col != GRIDSZIE -1) : row
	addi	$t0, $a1, 1		# t0 = next_row = row + 1

	j	selseend_5		# skip else
selse_5:
	move	$t0, $a1		# t0 = next_row = row

selseend_5:
	move	$s1, $a0		# ----Save current_board
	move	$s2, $a1		# ----Save row
	move	$s3, $a2		# ----Save col
	move	$s4, $a3		# ----Save *puzzle
	move	$s5, $ra		# ----Save ra
	move	$a1, $t0		# ----a1 = next_row

	addi	$t0, $a2, 1		# t0 = col + 1
sif_7:
	blt	$t0, $s0, selse_7	# if (col + 1 < GRIDSIZE), keep t0
	sub	$t0, $t0, $s0		# col + 1 - GRIDSIZE

selse_7:
	move $a2, $t0			# (col + 1) % GRIDSIZE

	jal	solve			# solve(...)
	move	$a0, $s1		# ----Restore a0
	move	$a1, $s2		# ----Restore a1
	move	$a2, $s3		# ----Restore a2
	move	$a3, $s4		# ----Restore a3
	move	$ra, $s5		# ----Restore ra

sif_6:
	beq	$v0, $zero, selse_6	# if solve(...) is false, jump
	j	sreturn

selse_6:	
	sll	$t0, $a1, 2		# ----row*GRIDSIZE
	add	$t0, $t0, $a2		# ----row*GRIDSIZE + col
	sll	$t0, $t0, 1		# ----sizeof(short) * index
	add	$t0, $t0, $a0		# currentBoard[row*GRIDSIZE + col]
	sh	$s7, 0($t0)		# current_board[row*GRIDSIZE + col] = possibles;

selse_4:

	addi	$s6, $s6, 1		# ++number
	j	sfor_1
send_1:
	li	$v0, 0			# return false

sreturn:
	lw	$s0, 0($sp) 
	lw	$s1, 4($sp) 
	lw	$s2, 8($sp) 	
	lw	$s3, 12($sp) 	
	lw	$s4, 16($sp) 
	lw	$s5, 20($sp) 	
	lw	$s6, 24($sp) 	
	lw	$s7, 28($sp)
	addi	$sp, $sp, 32		# Pop 8 registers (s0 - s7)

	jr $ra






















