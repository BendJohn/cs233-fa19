	.text
	.global	dfs

dfs:
	// Complete this function
	push {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs

	cmp a2, #127
	ble else_1		// if (i > 127)
	mov r0, #-1
	pop {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs
	bx lr			// return -1

else_1:
	ldr v1, [a3, a2, lsl #2]	// v1 = tree[i]
	cmp a1, v1
	bne else_2			// if (target == tree[i])
	mov r0, #0
	pop {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs
	bx lr			// return 0

else_2:
	push {a1, a2, a3} 	// save arguments
	lsl a2, a2, #1		// i*2
	bl dfs
	mov v1, r0		// dfs()	
	pop {a1, a2, a3}
	
	cmp v1, #0
	blt else_3		// if(ret >= 0)
	add r0, v1, #1		// return ret + 1
	pop {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs
	bx lr

else_3:
	push {a1, a2, a3}
	lsl a2, a2, #1
	add a2, a2, #1		// 2*i + 1
	bl dfs
	mov v1, r0
	pop {a1, a2, a3}
	
	cmp v1, #0
	blt else_4
	add r0, v1, #1		// return ret + 1
	pop {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs
	bx lr

else_4:
	mov r0, v1
	pop {v1, v2, v3, v4, v5, v6, v7, v8, lr}	// save all regs
	bx lr

