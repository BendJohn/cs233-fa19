module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

   // Added
   wire [29:0] eret_out, interrupt_out;
   wire [31:0] cp0_rd_data;
   wire TimerInterrupt, TimerAddress, TakenInterrupt;
   wire [31:0] mem_out;
   wire [31:0] add_wire;
   wire [31:0] cycle;
   wire  MemRead_out, MemWrite_out;
   wire [29:0] EPC;

   register #(30, 30'h100000) PC_reg(PC[31:2], interrupt_out, clk, /* enable */1'b1, reset);			// Edited
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

   data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead_out, MemWrite_out, clk, reset);

   mux2v #(32) wb_mux(mem_out, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

   // Please include the following
   //    xxx	ERET mux
   // 	 xxx	TakenInterrupt mux
   // 	 xxx	mfc0 mux
   // 	 xxx	TimerAddress Not
   // 	 xxx	CP0
   // 	 xxx	Timer
   // Muxes

   assign add_wire = 32'h80000180;

   mux2v #(30) eretMux(eret_out, next_PC[31:2], EPC, ERET);
   mux2v #(30) takenInterrupMux(interrupt_out, eret_out, add_wire[31:2], TakenInterrupt);
   mux2v mfc0Mux(wr_data, mem_out, cp0_rd_data, MFC0);

   assign MemRead_out = ~TimerAddress & MemRead;
   assign MemWrite_out = ~TimerAddress & MemWrite;
   assign load_data = cycle;

   // CP0
   cp0 coprocessor0(cp0_rd_data, EPC, TakenInterrupt, rd2_data, rd, next_PC, MTC0, ERET, TimerInterrupt, clk, reset);

   // Timer
   timer t(TimerInterrupt, cycle, TimerAddress, rd2_data, alu_out_data, MemRead, MemWrite, clk, reset);

endmodule // machine
