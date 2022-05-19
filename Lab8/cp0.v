`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    // Make sure you have the following
    // 	xxx	User Status Register
    // 	xxx	Exception Level Register
    // 	xxx	EPC Register
    // 	xxx	Decoder
    // 	xxx	#(30) Mux to d_epc
    // 	xxx	Or to exception
    // 	xxx	Or to EPC
    // 		Not
    // 		And - not stat[1] and stat[0]
    // 		And - cause[15] and sat[15]
    // 		And - for both above
    // 	xxx	3to1 mux
    // wires
    wire [31:0] status_register, cause_register;
    wire [31:0] user_status;
    wire [31:0] decoder_out, EPC_out;
    wire [29:0] EPC_in;
    wire exception_level;

    // registers
    register userStatus(user_status, wr_data, clock, decoder_out[12], reset);
    register #(1) exceptionLevel(exception_level, 1'b1, clock, TakenInterrupt, reset | ERET);
    register #(30) EPCRegister(EPC, EPC_in, clock, TakenInterrupt | decoder_out[14], reset);

    // decoder
    decoder32 decoderCP(decoder_out, regnum, MTC0);

    // mux
    mux2v #(30) EPCIn(EPC_in, wr_data[31:2], next_pc, TakenInterrupt);
    mux3v rdData(rd_data, status_register, cause_register, EPC_out, regnum[1:0]);

    // Timer interrupts
    assign TakenInterrupt = (cause_register[15] & status_register[15]) & (~status_register[1] & status_register[0]);

    // Assignments
    assign EPC_out = {EPC, 2'b00};
    assign status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};
    assign cause_register = {16'b0, TimerInterrupt, 15'b0};

endmodule
