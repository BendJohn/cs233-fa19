
.text

.comm mbox, 144, 16

.global mbox_call
mbox_call:
    // w0 = ch

    // w1 = ch & 0xF
    and w1, w0, #0xF

    // w2 = ~0xF
    movn w2, #0xF

    // w3 = &mbox
    ldr x3, =mbox

    // w2 = &mbox & ~0xF
    and w2, w2, w3

    // w1 = r = w2 | w1
    orr w1, w1, w2

    // x2 = MBOX_STATUS
    ldr x2, =0x3f00b898

    // w4 = MBOX_FULL
    ldr w4, =0x80000000

_mbox_call_loop_1:
    // w3 = *MBOX_STATUS
    ldr w3, [x2]

    // while (*MBOX_STATUS & MBOX_FULL)
    and w3, w3, w4
    cbnz w3, _mbox_call_loop_1

    // x2 = MBOX_WRITE
    ldr x2, =0x3f00b8a0

    // *MBOX_WRITE = r
    str w1, [x2]

_mbox_call_loop_2:

    // x2 = MBOX_STATUS
    ldr x2, =0x3f00b898

    // w4 = MBOX_EMPTY
    ldr w4, =0x40000000

_mbox_call_loop_3:

    // w3 = *MBOX_STATUS
    ldr w3, [x2]

    // while (*MBOX_STATUS & MBOX_EMPTY)
    and w3, w3, w4
    cbnz w3, _mbox_call_loop_3

    // x2 = MBOX_READ
    ldr x2, =0x3f00b880

    // w3 = *MBOX_READ
    ldr w3, [x2]

    // if (r != *MBOX_READ) continue ;
    cmp w1, w3
    bne _mbox_call_loop_2

    // w3 = MBOX_RESPONSE
    ldr w3, =0x80000000

    // w2 = mbox[1]
    ldr x2, =mbox
    ldr w2, [x2, #4]

    // return mbox[1] == MBOX_RESPONSE
    mov w0, #0
    cmp w2, w3
    bne _mbox_call_return
    mov w0, #1

_mbox_call_return:
    ret
