//implement your 32-bit ALU
module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;
    wire cin[31:0];
 
    alu1 aluc0(out[0], cin[0], A[0], B[0], control[0], control);
    alu1 aluc1(out[1], cin[1], A[1], B[1], cin[0], control);
    alu1 aluc2(out[2], cin[2], A[2], B[2], cin[1], control);
    alu1 aluc3(out[3], cin[3], A[3], B[3], cin[2], control);
    alu1 aluc4(out[4], cin[4], A[4], B[4], cin[3], control);
    alu1 aluc5(out[5], cin[5], A[5], B[5], cin[4], control);
    alu1 aluc6(out[6], cin[6], A[6], B[6], cin[5], control);
    alu1 aluc7(out[7], cin[7], A[7], B[7], cin[6], control);
    alu1 aluc8(out[8], cin[8], A[8], B[8], cin[7], control);
    alu1 aluc9(out[9], cin[9], A[9], B[9], cin[8], control);
    alu1 aluc10(out[10], cin[10], A[10], B[10], cin[9], control);
    alu1 aluc11(out[11], cin[11], A[11], B[11], cin[10], control);
    alu1 aluc12(out[12], cin[12], A[12], B[12], cin[11], control);
    alu1 aluc13(out[13], cin[13], A[13], B[13], cin[12], control);
    alu1 aluc14(out[14], cin[14], A[14], B[14], cin[13], control);
    alu1 aluc15(out[15], cin[15], A[15], B[15], cin[14], control);
    alu1 aluc16(out[16], cin[16], A[16], B[16], cin[15], control);
    alu1 aluc17(out[17], cin[17], A[17], B[17], cin[16], control);
    alu1 aluc18(out[18], cin[18], A[18], B[18], cin[17], control);
    alu1 aluc19(out[19], cin[19], A[19], B[19], cin[18], control);
    alu1 aluc20(out[20], cin[20], A[20], B[20], cin[19], control);
    alu1 aluc21(out[21], cin[21], A[21], B[21], cin[20], control);
    alu1 aluc22(out[22], cin[22], A[22], B[22], cin[21], control);
    alu1 aluc23(out[23], cin[23], A[23], B[23], cin[22], control);
    alu1 aluc24(out[24], cin[24], A[24], B[24], cin[23], control);
    alu1 aluc25(out[25], cin[25], A[25], B[25], cin[24], control);
    alu1 aluc26(out[26], cin[26], A[26], B[26], cin[25], control);
    alu1 aluc27(out[27], cin[27], A[27], B[27], cin[26], control);
    alu1 aluc28(out[28], cin[28], A[28], B[28], cin[27], control);
    alu1 aluc29(out[29], cin[29], A[29], B[29], cin[28], control);
    alu1 aluc30(out[30], cin[30], A[30], B[30], cin[29], control);
    alu1 aluc31(out[31], cin[31], A[31], B[31], cin[30], control);

    // Finding stuff
    assign negative = out[31];
    assign zero = !out;
    assign overflow = cin[31]^cin[30];

endmodule // alu32
