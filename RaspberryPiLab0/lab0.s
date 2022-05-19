.data
promptstr:  .ascii "Enter 3 integers separated by spaces: \0"
input:      .ascii "%d %d %d\0"
outstr:     .ascii "f(a, b, c) = %d\n\0"

.align 4
a:	.word   0
b:	.word   0
c:	.word   0

.text
numaptr:    .word   a
numbptr:    .word   b
numcptr:    .word   c
promptstrptr:    .word   promptstr
inputptr:   .word   input
outstrptr:   .word   outstr

.global    main
main:
   push   {lr}

   ldr    r0, promptstrptr
   bl     printf
   
   ldr    r0, inputptr
   ldr    r1, numaptr
   ldr    r2, numbptr
   ldr    r3, numcptr

   bl     scanf

   ldr    r1, numaptr
   ldr    r1, [r1, #0]
   ldr    r2, numbptr
   ldr    r2, [r2, #0]
   ldr    r3, numcptr
   ldr    r3, [r3, #0]

   add    r0, r1, r3
   sub    r4, r3, r1
   sdiv    r0, r0, r4

   push   {r0}

   mul    r0, r1, r3
   mul    r4, r2, r3
   add    r0, r0, r4
   
   push   {r0}

   mul    r0, r1, r2
   mul    r4, r1, r3
   sub    r4, r0, r4

   pop    {r0}

   sdiv   r4, r0, r4

   pop   {r0}

   add   r1, r0, r4

   ldr   r0, outstrptr
   bl    printf

   pop   {lr}
   bx    lr
