module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    // =========== My wires ===========
    // Register wires
    wire [29:0] PC_plus4_reg;
    wire [31:0]	inst_reg;

    wire	MemToReg_MW;
    wire	RegWrite_MW;
    wire	MemWrite_MW;
    wire	MemRead_MW;
    wire [4:0]	wr_regnum_MW;

    wire [31:0]	alu_out_data_reg;

    wire	ForwardA;
    wire	ForwardB;
    wire [31:0]	ForwardedA;
    wire [31:0]	ForwardedB;
    wire [31:0]	ForwardedB_reg;

    wire	Stall;
    wire	Flush;
    // =========== My wires ===========

    wire [31:0]  imm = {{ 16{inst_reg[15]} }, inst_reg[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_reg[25:21];
    wire [4:0]   rt = inst_reg[20:16];
    wire [4:0]   rd = inst_reg[15:11];
    wire [5:0]   opcode = inst_reg[31:26];
    wire [5:0]   funct = inst_reg[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~Stall, reset);				// Edited

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_reg, imm[29:0]);						// Edited
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, ForwardedB, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, ForwardedA, B_data);							// Edited

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_reg, ForwardedB_reg, MemRead_MW, MemWrite_MW, clk, reset);	// Edited

    mux2v #(32) wb_mux(wr_data, alu_out_data_reg, load_data, MemToReg_MW);					// Edited
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

    // ============ My Code ============
    // Register -- IF/DE Registers
    register #(30) ifde_add4(PC_plus4_reg, PC_plus4, clk, ~Stall, Flush);
    register #(32) ifde_inst(inst_reg, inst, clk, ~Stall, Flush);

    // Register -- DE/MW Registers
    // Control signals
    register #(1) MemoryToReg(MemToReg_MW, MemToReg, clk, 1'b1, reset);
    register #(1) RegisterWrite(RegWrite_MW, RegWrite, clk, 1'b1, reset);
    register #(1) MemoryWrite(MemWrite_MW, MemWrite, clk, 1'b1, reset);
    register #(1) MemoryRead(MemRead_MW, MemRead, clk, 1'b1, reset);
    // New ALU out
    register #(32) aluOut(alu_out_data_reg, alu_out_data, clk, 1'b1, reset);
    // rt data
    register #(32) rtData(ForwardedB_reg, ForwardedB, clk, 1'b1, reset);
    // wr_regnum
    register #(5) wrRegnum(wr_regnum_MW, wr_regnum, clk, 1'b1, reset);

    // Forwarding unit
    mux2v #(32) ForwarderA(ForwardedA, rd1_data, alu_out_data_reg, ForwardA);
    mux2v #(32) ForwarderB(ForwardedB, rd2_data, alu_out_data_reg, ForwardB);
    assign ForwardA = RegWrite_MW & (wr_regnum_MW == rs) & !(rs == 5'b0);
    assign ForwardB = RegWrite_MW & (wr_regnum_MW == rt) & !(rt == 5'b0);

    // Stalling signal
    assign Stall = MemToReg_MW & ((rs == wr_regnum_MW) & !(rs == 5'b0) | (rt == wr_regnum_MW) & !(rt == wr_regnum) & (rt != 5'b0));

    // Flushing Signal
    assign Flush = PCSrc | reset;
    // ============ My Code ============

endmodule // pipelined_machine
