.text

# int count_painted(int *wall, int width, int radius, int coord) {
# 	int row = (coord & 0xffff0000) >> 16;
# 	int col = coord & 0x0000ffff;
# 	int value = 0;
# 	for (int row_offset = -radius; row_offset <= radius; row_offset++) {
# 		int temp_row = row + row_offset;
# 		if (width <= temp_row || temp_row < 0) {
# 			continue;
# 		}
# 		for (int col_offset = -radius; col_offset <= radius; col_offset++) {
# 			int temp_col = col + col_offset;
# 			if (width <= temp_col || temp_col < 0) {
# 				continue;
# 			}
# 			value += wall[temp_row*width + temp_col];
# 		}
# 	}
# 	return value;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius
# // a3: int coord

# // t0: row
# // t1: col
# // t2: value
# // t3: row_offset
# // t4: temp_row
# // t5: col_offset
# // t6: temp_col

.globl count_painted
count_painted:
	lui	$t0, 0xffff		# //M// t0 = 0xffff0000
	and	$t0, $t0, $a3		# //M// t0 = coord & 0xffff0000
	srl	$t0, $t0, 16		# int row = (coord & 0xffff0000) >> 16;

	li	$t1, 0xffff		# //M// t1 = 0x0000ffff
	and	$t1, $t1, $a3		# int col = coord & 0x0000ffff;
	
	li	$t2, 0			# int value = 0;

	sub	$t3, $zero, $a2		# int row_offset = -radius;

loop01:
	blt	$a2, $t3, endLoop01

	add	$t4, $t0, $t3		# int temp_row = row + row_offset;
	li	$t5, 0
	sle	$t5, $a1, $t4		# //M// t5 = 1 if a1 <= t4
	slt	$t6, $t4, $zero		# //M// t6 = 1 if t4 < 0
	or	$t5, $t5, $t6		# //M// t5 = 1 if t5 | t6

if01:
	beq	$t5, $zero, else01	# if (width <= temp_row || temp_row < 0)
	addi	$t3, $t3, 1		# row_offset++;
	j	loop01			# continue;

else01:
	sub	$t5, $zero, $a2		# int col_offset = -radius;
	
loop02:
	blt	$a2, $t5, endLoop02
	
	add	$t6, $t1, $t5		# int temp_col = col + col_offset;
	li	$t7, 0
	sle	$t7, $a1, $t6		# //M// t7 = 1 if a1 <= t6
	slt	$v1, $t6, $zero		# //M// v1 = 1 if t6 < 0
	or	$t7, $t7, $v1		# //M// t7 = 1 if t7 | v1

if02:
	beq	$t7, $zero, else02	# if (width <= temp_row || temp_row < 0)
	addi	$t5, $t5, 1		# col_offset++;
	j	loop02			# continue;

else02:
	mul	$t7, $t4, $a1		# //M// t7 = temp_row*width
	add	$t7, $t7, $t6		# //M// t7 = temp_row*width + temp_col
	sll	$t7, $t7, 2		# //M// sizeoff(int) * t7
	add	$t7, $t7, $a0		# offset from width address

	lw	$t7, 0($t7)		# //M// t7 = wall[temp_row*width + temp_col]
	add	$t2, $t2, $t7		# value += t7

	addi	$t5, $t5, 1		# col_offset++
	j	loop02
endLoop02:

	addi	$t3, $t3, 1		# row_offset++;
	j	loop01
endLoop01:
	move	$v0, $t2		# return {val} = value
	jr	$ra

	
# int* get_heat_map(int *wall, int width, int radius) {
# 	int value = 0;
# 	for (int col = 0; col < width; col++) {
# 		for (int row = 0; row < width; row++) {
# 			int coord = (row << 16) | (col & 0x0000ffff);
# 			output_map[row*width + col] = count_painted(wall, width, radius, coord);
# 		}
# 	}
# 	return output_map;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius

# // s0: value
# // s1: col
# // s2: row

.globl get_heat_map
get_heat_map:
	addi	$sp, $sp, -32		# Push 8 registers (s0 - s7)
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)

	li	$s0, 0			# int value = 0;
	li	$s1, 0			# int col = 0;
	move	$s3, $a0		# save arguments
	move	$s4, $a1
	move	$s5, $a2

loop1:
	bge	$s1, $s4, endLoop1	# if col >= width skip loop
	
	li	$s2, 0			# int row = 0;

loop2:
	bge	$s2, $s4, endLoop2	# if row >= width skip loop

	sll	$t0, $s2, 16		# row << 16
	li	$t1, 0x0000ffff
	and	$t1, $s1, $t1		# col & 0x0000ffff
	or	$a3, $t0, $t1		# int coord = (row << 16) | (col & 0x0000ffff);

	addi	$sp, $sp, -4		# push ra
	sw	$ra, 0($sp)

	jal	count_painted
	move	$t0, $v0		# t0 = count_painted result

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4		# pop ra

	mul	$t1, $s2, $s4		# row * width
	add	$t1, $t1, $s1		# t1 = row*width + col
	sll	$t1, $t1, 2		# sizeoff(int) * t1
	la	$t2, output_wall
	add	$t1, $t1, $t2
	sw	$t0, 0($t1)		# output_map[row*width + col] = t0

	addi	$s2, $s2, 1		# row++
	j	loop2

endLoop2:
	addi	$s1, $s1, 1		# col++
	j	loop1

endLoop1:

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	addi	$sp, $sp, 32		# Pop 8 registers (s0 - s7)
	# Can access output_wall from p2.s
	la $v0, output_wall
	jr	$ra
	
