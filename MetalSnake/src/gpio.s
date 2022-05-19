

.text

.comm prev_input_left, 4, 4
.comm prev_input_right, 4, 4

.equ GPIO_BASE_ADDR, 0x3F000000
.equ GPIO_INPUT, 0
.equ GPIO_OUTPUT, 1

.global gpio_init
gpio_init:
    // === set pins 10 to 19 to input, 11 to output ===
    ldr x0, =GPIO_BASE_ADDR
    orr x0, x0, #0x200000
    orr x0, x0, #0x4
    //mov w1, #1 << 3
    str w1, [x0]
    // === /set pins 10 to 19 to input, 11 to output ===

    // === set pin 11 to 1 ===
    //ldr x0, =GPIO_BASE_ADDR
    //orr x0, x0, #0x200000
    //orr x0, x0, #0x1C
    //mov w1, #1 << 11
    //str w1, [x0]
    // === /set pin 11 to 1 ===

    ret


.global gpio_poll_input
gpio_poll_input:

    // === check pin 17 (move left) ===
    ldr x0, =GPIO_BASE_ADDR
    orr x0, x0, #0x200000
    orr x0, x0, #0x30
    orr x0, x0, #0x4
    
    // bitmask to check correct input bit
    mov w1, #1 << 17
    ldr w2, [x0]
    and w1, w1, w2

    ldr w3, prev_input_left
    cbz w3, _gpio_dont_move_left
    cbnz w1, _gpio_dont_move_left

    ldr x0, =snake_dir
    ldr w1, [x0]
    sub w1, w1, #1
    and w1, w1, #0b11
    str w1, [x0]
 
_gpio_dont_move_left:
    ldr x0, =prev_input_left
    str w1, [x0]
    // === /check pin 17 (move left) ===


// === check pin 18 (move right) ===
    ldr x0, =GPIO_BASE_ADDR
    orr x0, x0, #0x200000
    orr x0, x0, #0x30
    orr x0, x0, #0x4

    // bitmask to check correct input bit
    mov w1, #1 << 18
    ldr w2, [x0]
    and w1, w1, w2

    ldr w3, prev_input_right
    cbz w3, _gpio_dont_move_right
    cbnz w1, _gpio_dont_move_right

    ldr x0, =snake_dir
    ldr w1, [x0]
    add w1, w1, #1
    and w1, w1, #0b11
    str w1, [x0]

_gpio_dont_move_right:
    ldr x0, =prev_input_right
    str w1, [x0]
    // === /check pin 18 (move right) ===


    ret
