// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, nextPC, sign_extend, out, A, B, C;
    wire [31:0] PC;
    wire [4:0] w_addr;
    wire [2:0] alu_op;
    wire alu_src2, rd_src, writeenable, overflow, zero, negative;

    // DO NOT comment out or rename this module
    // or the test bench will break
    // in rf.v
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A, B, inst[25:21], inst[20:16], w_addr, out, writeenable, clock, reset);

    /* add other modules */
    alu32 pcplus4(nextPC, , , , PC, 32'h4, `ALU_ADD);

    mips_decode mid(alu_src2, rd_src, writeenable, alu_op, except, inst[31:26], inst[5:0]);

    alu32 alu_arith(out, overflow, zero, negative, A, C, alu_op);
    assign sign_extend = {{16{inst[15]}}, inst[15:0]};
    mux2v mux_imm(C, B, sign_extend, alu_src2);
    mux2v #(5) mux_r(w_addr, inst[15:11], inst[20:16], rd_src);

endmodule // arith_machine
