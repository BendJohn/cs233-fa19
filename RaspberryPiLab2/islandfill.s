	.text
	.global islandfill

islandfill:
	push {v1, v2, v3, v4, v5, v6, v7, lr}

	mov a2, #65	// marker = 65
	mov a3, #0	// i = 0
	ldr v2, [a1, #0] // v2 = puzzle->NUM_ROWS
loop1:
	cmp a3, v2
	bge end_loop1

	mov a4, #0	// j = 0
	ldr v5, [a1, #4]	// v5 = puzzle->NUM_COLS
loop2:
	cmp a4, v5
	bge end_loop2

	push {a1, a2, a3, a4}
	bl floodfill
	mov v7, r0	// v7 = marker
	pop {a1, a2, a3, a4}
	mov a2, v7	// restore marker

	add a4, a4, #1	// ++j
	b loop2
end_loop2:
	
	add a3, a3, #1	// ++i
	b loop1
end_loop1:

	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr


floodfill:
	push {v1, v2, v3, v4, v5, v6, v7, lr}

	cmp a3, #0
	bge else1
	mov r0, a2
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr

else1:
	cmp a4, #0
	bge else2
	mov r0, a2
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr
	
else2:
	ldr v1, [a1, #0]	// v1 = puzzle->NUM_ROWS
	ldr v2, [a1, #4] 	// v2 = puzzle->NUM_COLS

	cmp a3, v1
	blt else3
	mov r0, a2
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr

else3:
	cmp a4, v2
	blt else4	
	mov r0, a2
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr

else4:
	ldr v1, [a1, #8]	// v1 = puzzle->board
	ldr v2, [v1, a3, lsl #2]	// v2 = board[row]
	ldrb v3, [v2, a4]	// v2 = board[row][col]


	cmp v3, #35	// '#' == 35
	beq else5
	mov r0, a2
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr

else5:
	strb a2, [v2, a4]	// board[row][col] = marker

	push {a1, a2, a3, a4}
	add a3, a3, #1
	add a4, a4, #1
	bl floodfill
	pop {a1, a2, a3, a4}

	push {a1, a2, a3, a4}
	add a3, a3, #1
	// add a4, a4, #1
	bl floodfill
	pop {a1, a2, a3, a4}

	push {a1, a2, a3, a4}
	add a3, a3, #1
	add a4, a4, #-1
	bl floodfill
	pop {a1, a2, a3, a4}


	push {a1, a2, a3, a4}
	// add a3, a3, #1
	add a4, a4, #1
	bl floodfill
	pop {a1, a2, a3, a4}

	push {a1, a2, a3, a4}
	// add a3, a3, #1
	add a4, a4, #-1
	bl floodfill
	pop {a1, a2, a3, a4}


	push {a1, a2, a3, a4}
	add a3, a3, #-1
	add a4, a4, #1
	bl floodfill
	pop {a1, a2, a3, a4}

	push {a1, a2, a3, a4}
	add a3, a3, #-1
	// add a4, a4, #1
	bl floodfill
	pop {a1, a2, a3, a4}

	push {a1, a2, a3, a4}
	add a3, a3, #-1
	add a4, a4, #-1
	bl floodfill
	pop {a1, a2, a3, a4}

	add r0, a2, #1
	pop {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr
	

