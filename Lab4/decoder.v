// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_src2, rd_src, writeenable, alu_op, except, opcode, funct);
    output       alu_src2, rd_src, writeenable, except;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

    wire op0, opAdd, opSub, opAnd, opOr, opNor, opXor, opAddi, opAndi, opOri, opXori;

    assign op0 = (opcode == `OP_OTHER0);
    assign opAdd = op0 & (funct == `OP0_ADD);
    assign opSub = op0 & (funct == `OP0_SUB);
    assign opAnd = op0 & (funct == `OP0_AND);
    assign opOr = op0 & (funct == `OP0_OR);
    assign opNor = op0 & (funct == `OP0_NOR);
    assign opXor = op0 & (funct == `OP0_XOR);
    assign opAddi = (opcode == `OP_ADDI);
    assign opAndi = (opcode == `OP_ANDI);
    assign opOri = (opcode == `OP_ORI);
    assign opXori = (opcode == `OP_XORI);

    assign alu_src2 = rd_src;
    assign rd_src = opAddi | opAndi | opOri | opXori;
    assign writeenable = ~except;
    assign except = ~(alu_op[0] | alu_op[1] | alu_op[2]) | (alu_op[0] & ~alu_op[1] & ~alu_op[2]);

    assign alu_op[0] = opSub | opXor | opXori | opOr | opOri;
    assign alu_op[1] = opAdd | opAddi | opXor | opXori | opNor | opSub;
    assign alu_op[2] = opAnd | opAndi | opNor | opXori | opXor | opOr | opOri;

endmodule // mips_decode
