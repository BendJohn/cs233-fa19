	.text
	.global floyd_warshall

floyd_warshall:
	// Complete this function
	push {v1, v2, v3, v4, v5, v6, v7, lr}
	mov v1, #0		// v1 = i = 0

	mov a4, #24

for_1:
	cmp v1, #6
	bge endLoop_1		// i < 6
	mov v2, #0		// v2 = j = 0
	
for_2:
	cmp v2, #6
	bge endLoop_2		// j < 6

	cmp v1, v2
	bne else_1		// if (i == j)

	// ldr v3, [a2, v1, lsl #2]
	// lsl v7, v1, #2
	// add v3, a2, v7

	mul v7, v1, a4	// i * 24
	lsl v6, v2, #2	// j << 2
	add v7, v7, v6	// v7 = i * 24  + j << 2
	add v3, a2, v7

	mov v4, #0
	str v4, [v3, #0]
	b endIf_1
else_1:	
	// ldr v4, [a1, v1, lsl #2]
	mul v7, v1, a4	// i * 24
	lsl v6, v2, #2	// j << 2
	add v7, v7, v6	// v7 = i * 24  + j << 2

	add v4, a1, v7

	ldr v4, [v4, #0]
	
	// ldr v3, [a2, v1, lsl #2]
	// lsl v7, v1, #2
	add v3, a2, v7

	str v4, [v3, #0]

endIf_1:
	add v2, v2, #1		// ++j
	b for_2

endLoop_2:
	add v1, v1, #1		// ++i
	b for_1

endLoop_1:
	mov v1, #0		// v1 = k = 0

for_3:
	cmp v1, #6
	bge endLoop_3
	
	mov v2, #0		// v2 = i = 0

for_4:
	cmp v2, #6
	bge endLoop_4

	mov v3, #0		// v3 = j = 0

for_5:
	cmp v3, #6
	bge endLoop_5

	// ldr v4, [a2, v2, lsl #2]
	mul a3, v2, a4	// a3 = i * 24
	lsl v7, v1, #2
	add a3, a3, v7  // a3 = i * 24 + k << 2
	add v4, a3, a2
	ldr v4, [v4, #0]	// v4 = shortest_Distance[i][k]

	// ldr v5, [a2, v1, lsl #2]
	mul a3, v1, a4
	lsl v7, v3, #2
	add a3, a3, v7	// a3 = k * 24 + j << 2
	add v5, a3, a2
	ldr v5, [v5, #0]	// v5 = shortest_Distance[k][j]

	//ldr v6, [a2, v2, lsl #2]
	mul a3, v2, a4
	add v6, a3, a2
	ldr v6, [v6, v3, lsl #2]	// v6 = shortest_Distance[i][j]

	add v4, v4, v5			// v4 += v5
	cmp v4, v6
	bge else_2
	// ldr v7, [a2, v2, lsl #2]
	mul a3, v2, a4
	add v7, a3, a2
	str v4, [v7, v3, lsl #2]	// v7 += v4

else_2:
	add v3, v3, #1		// ++j
	b for_5

endLoop_5:

	add v2, v2, #1
	b for_4

endLoop_4:
	add v1, v1, #1
	b for_3

endLoop_3:

	push {v1, v2, v3, v4, v5, v6, v7, lr}
	bx lr					// return
