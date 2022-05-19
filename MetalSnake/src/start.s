
.section ".text.boot"

.global _start
_start:
    // read cpu id, stop slave cores
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz x1, _work

_stop:
    // cpu id > 0, stop
    wfe
    b _stop

_work:
    // cpu id == 0
    // set stack to point before _start
    ldr x1, =_start
    mov sp, x1

    // clear bss
    ldr x1, =__bss_start
    ldr w2, =__bss_size
_bss_clear_loop:
    cbz  w2, _call_main
    str  xzr, [x1], #8
    sub  w2, w2, #1
    cbnz w2, _bss_clear_loop

_call_main:
    // jump to main function
    bl main
    // for failsafe, halt this core too
    b _stop
