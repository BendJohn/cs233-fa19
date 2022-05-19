.text

# short count_odd_nodes(TreeNode* head) {
#     // Base case
#     if (head == NULL) {
#         return 0;
#     }
#     // Recurse once for each child
# 	short count_left = count_odd_nodes(head->left);
#     short count_right = count_odd_nodes(head->right);
#     short count = count_left + count_right;
#     // Determine if this current node is odd
#     if (head->value%2 != 0) {
#         count += 1;
#     }
#     return count;
# }

.globl count_odd_nodes
count_odd_nodes:
	bne	$a0, $zero, end_if1	# if (head == 0)
	li	$v0, 0			# return 0
	jr	$ra

end_if1:
	addi	$sp, $sp, -12		# Push 8 registers (s0 - s7)
	sw	$s0, 0($sp)		# For head
	sw	$s1, 4($sp)		# For count_left
	sw	$s2, 8($sp)		# For $ra

	move	$s0, $a0		# Save head
	move	$s2, $ra		# Save $ra
	lw	$a0, 0($s0)		# head->left
	jal	count_odd_nodes		# recurse
	move	$s1, $v0		# Save count_left
	lw	$a0, 4($s0)		# head->right
	jal	count_odd_nodes		# recurse
	add	$t0, $s1, $v0		# count = count_left + count_right

	lh	$t1, 8($s0)		# head->value
	andi	$t1, $t1, 1		# head->value%2
	beq	$t1, $zero, end_if2	# if (head->value%2 != 0)
	addi	$t0, $t0, 1		# count += 1

end_if2:
	move	$ra, $s2		# get correct $ra
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	addi	$sp, $sp, 12		# Pop 8 registers (s0 - s7)

	move	$v0, $t0
	jr	$ra
