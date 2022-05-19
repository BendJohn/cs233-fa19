/* This is a block comment
   It can span multiple lines
*/

// This is a single line comment
.text                   // Beginning of the code section
.global main            // Telling the compiler that main will be 
                        // globally available. Operating system 
                        // will jump to this point to run our program

main:                   // This is the main label. Entry point of 
                        // the program is always main

    mov r0, #20         // r0 = 20
    mov r1, #30         // r1 = 30
    add r2, r0, r1      // r2 = r0 + r1
    add r2, r2, #40     // r2 = r2 + 40
    mov r0, r2          // copy r2 to return value in r0. r0 = r2
    bx  lr              // return back to Operating system
	
	
