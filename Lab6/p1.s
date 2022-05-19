.text

# // Finds the dot product between two different arrays of size n
# // Ignore integer overflow for the multiplication
# int paint_cost(unsigned int n, unsigned int* paint, unsigned int* cost) {
# 	int total = 0;
# 	for (int i = 0; i < n; i++) {
# 		total += paint[i] * cost[i];
# 	}
# 	return total; 
# }

.globl paint_cost
paint_cost:
	li	$t1, 0			# Load total
	li	$t0, 0			# Load i

whileLoop:
	bge	$t0, $a0, endLoop	# Condition

	sll	$t2, $t0, 2		# 4 * i
	add	$t3, $t2, $a1		# paint[i] address
	add	$t4, $t2, $a2		# cost[i] address
	
	lw	$t3, 0($t3)		# paint[i]
	lw	$t4, 0($t4)		# cost[i]

	mul	$t5, $t3, $t4		# $t5 = paint[i] * cost[i]
	add	$t1, $t1, $t5		# total += paint[i] * cost[i]

	addi	$t0, $t0, 1		# i++
	j	whileLoop

endLoop:
	move	$v0, $t1
	jr	$ra
