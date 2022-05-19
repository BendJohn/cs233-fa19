module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction
        // add more tests here!

	# 10 opcode = `OP_OTHER0; funct = `OP0_OR; // try or

	# 10 opcode = `OP_OTHER0; funct = `OP0_NOR; // try nor

	# 10 opcode = `OP_OTHER0; funct = `OP0_XOR; // try xor

	# 10 opcode = `OP_OTHER0; funct = `OP0_AND; // try xor

	# 10 opcode = `OP_ADDI; funct = `OP0_ADD; // try correct immediate opcode/funct

	# 10 opcode = `OP_OTHER1; funct = `OP0_ADD; // try incorrect opcode/funct

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       alu_src2, rd_src, writeenable, except;
    mips_decode decoder(alu_src2, rd_src, writeenable, alu_op, except,
                        opcode, funct);
endmodule // decoder_test
