.data       // Data segment of the program
promptstr:  .ascii  "Enter a Number :\0"
input:      .ascii  "%d\0"
outstr:     .ascii  "The Number is %d\n\0"

.align 4    // address of an integer should be multiple of 4
number:     .word

.text       // Code segment
numptr:         .word   number
promptstrptr:   .word   promptstr
inputptr:       .word   input
outstrptr:      .word   outstr

.global    main
main:
    push    {lr}                    // lr register must be saved 
                                    // if the code has any function calls
                                    
    ldr     r0, promptstrptr        // printf argument is passed in r0
    bl      printf                  // call to printf
    
    ldr     r0, inputptr            // scanf 1st argument is passed in r0
    ldr     r1, numptr              // scanf 2nd argument is passed in r1
    bl      scanf                   // call to scanf
    
    ldr     r1, numptr              // get address of number entered by user
    ldr     r1, [r1, #0]            // get number entered by user and put it
                                    //      in r1 as 2nd argument of printf
    ldr     r0, outstrptr           // set up the 1st argument of printf
    bl      printf                  // call printf
    
    mov     r0, #0                  // put return value in r0

    pop     {lr}                    // restore lr register value
    bx      lr                      // return 
