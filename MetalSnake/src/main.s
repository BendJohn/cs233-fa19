
.text

.global main
main:
    bl lfb_init
    bl gpio_init

    mov w28, #0

_main_loop:
    bl lfb_drawsnake
    bl gpio_poll_input

    add w28, w28, #1
    lsl w0, w28, #31
    //cbnz w0, _main_loop

    bl snake_update

    // ======== collision_check ======== //
    bl collision_check
    ldr x0, collide
    cmp x0, #0
    bne lfb_game_over 
    // ======== /collision_check ======== //
    

    b _main_loop
