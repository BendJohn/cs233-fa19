// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    // Program Counter wires
    wire [31:0] nextPC, pc0, pc1, pc2, branchOff; 
    // Memory File wires
    wire [31:0] data_out, out_load;
    wire [7:0] out_byte;
    // Arithmetic Machine wires
    wire [31:0] inst, sign_extend, out, rsData, rtData, B;  
    wire [31:0] PC;
    wire [4:0] rdest;
    wire [2:0] alu_op;
    wire alu_src2, rd_src, writeenable, overflow, zero, negative;
    // Arithmetic Machine new wires
    wire [31:0] out_slt, slt_result, out_mem, out_lui, lui_result, out_addm, addm_result, out_imm;
    // Decoder new wires
    wire mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    wire [1:0] control_type;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rdest, out_addm, writeenable, clock, reset);

    // The Data Memory
    data_mem data_memory(data_out, out, rtData, word_we, byte_we, clock, reset);

    /* add other modules */
    // Decoder
    mips_decode mid(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], zero);

    // PC Part
    alu32 pcplus4(pc0, , , , PC, 32'h4, `ALU_ADD);
    assign branchOff = {sign_extend[29:0], 2'b0};
    alu32 pcplusbranch(pc1, , , , pc0, branchOff, `ALU_ADD);
    assign pc2 = {PC[31:28], inst[25:0], 2'b00};
    mux4v mux_control(nextPC, pc0, pc1, pc2, rsData, control_type);

    // Old Register Part
    alu32 alu_arith(out, overflow, zero, negative, rsData, B, alu_op);
    assign sign_extend = {{16{inst[15]}}, inst[15:0]};
    mux2v mux_imm(out_imm, rtData, sign_extend, alu_src2);
    mux2v #(5) mux_dest(rdest, inst[15:11], inst[20:16], rd_src);
    // New Register Part
    mux2v mux_addm1(B, out_imm, 32'b0, addm);
    assign slt_result = {31'b0, negative};
    mux2v mux_slt(out_slt, out, slt_result, slt);
    assign lui_result = {inst[15:0], 16'b0};
    mux2v mux_lui(out_lui, out_mem, lui_result, lui);
    alu32 alu_addm(addm_result, , , , rtData, out_lui, `ALU_ADD);
    mux2v mux_addm(out_addm, out_lui, addm_result, addm);

    // Memory
    mux2v mux_mem(out_mem, out_slt, out_load, mem_read);
    mux4v #(8) mux_byte(out_byte, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
    mux2v mux_load(out_load, data_out, {24'b0, out_byte}, byte_load);

endmodule // full_machine
