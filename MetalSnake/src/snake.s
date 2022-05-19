
.data
    // All game state is stored here.

    // snake direction:
    //   0 right
    //   1 down
    //   2 left
    //   3 up
.global snake_dir
.align 4
snake_dir: .word 0

    // snake length: up to 24
    // We preallocate the whole snake and give it a maximum length
    // because dynamic allocation is hard.
.global snake_len
.align 4
snake_len: .word 4

    // We preallocate the whole snake and give it a maximum length
    // because dynamic allocation is hard.
.global food_idx
.align 4
food_idx: .word 0

    // 1 if we collided, 0 otherwise
.global collide
.align 4
collide: .word 0

    // The snake is stored as an array of 24 {int x, int y} structs.
    // The first element of the array is the 'head' of the snake.
.global snake_body
.align 16
snake_body:
.word 8, 8 // head is initially at 8, 8
.word 7, 8
.word 6, 8
.word 5, 8
.word 4, 8
.word 3, 8
.word 2, 8
.word 1, 8
.word 0, 8
.word 0, 9
.word 0, 10
.word 0, 11
.word 0, 12
.word 0, 13
.word 0, 14
.word 0, 15
.word 0, 16
.word 0, 17
.word 0, 18
.word 0, 19
.word 0, 20
.word 0, 21
.word 0, 22
.word 0, 23

    // The food array is stored as an array of 8 {int x, int y} structs.
    // These are our psuedo-random seeds for positions of the food
.global food_array
.align 16
food_array:
.word  8, 2
.word  13, 12
.word  3, 13
.word 12, 12
.word 12, 11
.word 20, 7
.word  7, 7
.word  3, 11

.text

    // Move the snake, check for collisions.
.global snake_update
snake_update:


    ldr x0, =snake_body
    ldr x1, [x0] // x1 = old head position


    // === snake head movement ===

    ldr x2, snake_dir
    cmp x2, #0
    beq _snake_move_right
    cmp x2, #1
    beq _snake_move_down
    cmp x2, #2
    beq _snake_move_left
    cmp x2, #3
    beq _snake_move_up

_snake_move_right:
    add x2, x1, #1
    str x2, [x0]
    b _snake_end_move
_snake_move_down:
    lsr x2, x1, #32
    add x2, x2, #1
    lsl x3, x1, #32
    lsr x3, x3, #32
    lsl x2, x2, #32
    orr x2, x2, x3
    str x2, [x0]
    b _snake_end_move
_snake_move_left:
    sub x2, x1, #1
    str x2, [x0]
    b _snake_end_move
_snake_move_up:
    lsr x2, x1, #32
    sub x2, x2, #1
    lsl x3, x1, #32
    lsr x3, x3, #32
    lsl x2, x2, #32
    orr x2, x2, x3
    str x2, [x0]
    b _snake_end_move
_snake_end_move:

    // === /snake head movement ===



    // === snake body movement ===

    mov x2, #1
_snake_movement_loop:

    ldr x3, [x0, x2, lsl #3]
    str x1, [x0, x2, lsl #3]
    mov x1, x3

    add x2, x2, #1
    cmp x2, #24
    blt _snake_movement_loop

    // === /snake body movement ===

    ret



    // Check for collisions. CHANGE BOUNDARY NUMBER TODO
.global collision_check
collision_check:
     // ==== Snake ====
     // w0 = y, w1 = x
     ldr x0, snake_body
     mov w1, w0
     lsr x0, x0, #32


    ldr x2, food_idx
    ldr x3, =food_array

     // ==== Food ====
     // w2 = y, w3 = x
     ldr x2, [x3, x2, lsl #3]
     mov w3, w2
     lsr x2, x2, #32

     
_collide_with_food:
     // Check if y and x coords are the same
     // and increase snake_len if true
     cmp w0, w2
     bne _collide_with_wall
     cmp w1, w3
     bne _collide_with_wall

     ldr x0, =snake_len
     ldr x1, [x0]
     cmp x1, #24
     bge _snake_update_dont_grow
     add x1, x1, #1
_snake_update_dont_grow:
     str x1, [x0]

    // === food index increment ===

    ldr x0, =food_idx
    ldr x1, [x0]
    add	x1, x1, #1
    and x1, x1, #0b111
    str x1, [x0, #0]

    // === /food index increment ===
   b _return


_collide_with_wall:
    // Bump bottom wall (y = 0)
    cmp w0, #-1
    beq _set_collide_to_one

    // Bump top wall (y = ?)
    cmp w0, #31
    beq _set_collide_to_one

    // Bump right wall (x = 0)
    cmp w1, #-1
    beq _set_collide_to_one

    // Bump left wall (x = ?)
    cmp w1, #41
    beq _set_collide_to_one



    mov x2, #1
    ldr x3, snake_len
    ldr x4, =snake_body
_collide_with_self:
    // If acc > snake_len, no collsion
    cmp x2, x3
    beq _return
    add x2, x2, #1

    // Get next x and y
    // w5 = y, w6 = x
    ldr x5, [x4, x2, lsl #3]
    mov w6, w5
    lsr x5, x5, #32

    // Check if head coords = cur coords
    cmp w0, w5
    bne _collide_with_self
    cmp w1, w6
    bne _collide_with_self
    b _set_collide_to_one


_return:
     ret

_set_collide_to_one:
    mov x0, #1
    ldr x1, =collide
    str x0, [x1]
    b _return
