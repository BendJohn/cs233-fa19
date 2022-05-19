// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire op0, opAdd, opSub, opAnd, opOr, opNor, opXor, opAddi, opAndi, opOri, opXori, opBne, opBeq, opJ, opJr, opLui, opSlt, opLw, opLbu, opSw,/**/ opSb, opAddm;

    // R-type instructions
    assign op0 = (opcode == `OP_OTHER0);
    assign opAdd = op0 & (funct == `OP0_ADD);
    assign opSub = op0 & (funct == `OP0_SUB);
    assign opAnd = op0 & (funct == `OP0_AND);
    assign opOr = op0 & (funct == `OP0_OR);
    assign opNor = op0 & (funct == `OP0_NOR);
    assign opXor = op0 & (funct == `OP0_XOR);
    assign opJr = op0 & (funct == `OP0_JR); 
    assign opSlt = op0 & (funct == `OP0_SLT); 
    assign opAddm = op0 & (funct == `OP0_ADDM);

    // I-type instructions
    assign opAddi = (opcode == `OP_ADDI);
    assign opAndi = (opcode == `OP_ANDI);
    assign opOri = (opcode == `OP_ORI);
    assign opXori = (opcode == `OP_XORI);
    assign opBne = (opcode == `OP_BNE);
    assign opBeq = (opcode == `OP_BEQ);
    assign opLui = (opcode == `OP_LUI);
    assign opLw = (opcode == `OP_LW);
    assign opLbu = (opcode == `OP_LBU);
    assign opSw = (opcode == `OP_SW);
    assign opSb = (opcode == `OP_SB);

    // J-type instructions
    assign opJ = (opcode == `OP_J);


    assign alu_src2 = rd_src;

    assign rd_src = opSb | opSw | opLbu | opLw | opLui | opAddi | opAndi | opOri | opXori;

    assign writeenable = opAdd | opSub | opAnd | opOr | opNor | opXor | opAddi | opAndi | opOri | opXori | opLui | opSlt | opLw | opLbu | opAddm;

    assign except = ~(opAdd | opSub | opAnd | opOr | opNor | opXor | opAddi | opAndi | opOri | opXori | opBne | opBeq | opJ | opJr | opLui | opSlt | opLw | opLbu | opSw | opSb | opAddm);

    assign mem_read = opLw | opLbu | opAddm;

    assign word_we = opSw;

    assign byte_we = opSb;

    assign byte_load = opLbu;

    assign slt = opSlt;

    assign lui = opLui;

    assign addm = opAddm;

    //assign alu_op[0] = opSub | opXor | opXori | opOr | opOri;
    //assign alu_op[1] = opAdd | opAddi | opXor | opXori | opNor | opSub;
    //assign alu_op[2] = opAnd | opAndi | opNor | opXori | opXor | opOr | opOri; 
    assign alu_op = opSub | opBne | opBeq | opSlt ? 3'b011 :
	opXor | opXori ? 3'b111 :
	opOr | opOri ? 3'b101 :
	opAdd | opAddi | opLui | opLw | opLbu | opSw | opSb | opAddm ? 3'b010 :
	opNor ? 3'b110 :
	opAnd | opAndi ? 3'b100 :
	3'b000;

    assign control_type = ~zero & opBne ? 2'b01 :
	zero & opBeq ? 2'b01 :
	opJ ? 2'b10 :
	opJr ? 2'b11 :
	2'b00;

endmodule // mips_decode
