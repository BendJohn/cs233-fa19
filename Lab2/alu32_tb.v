//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
	# 10 A = 8; B = 2; control = `ALU_ADD; 
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
        // test 0 signal arithmatic
        # 10 A = 55; B = 45; control = `ALU_ADD;
 
        // test 0 signal logical
        # 10 A = 1234; B = 0; control = `ALU_AND;

        // test negative signal
        # 10 A = 27; B = 55; control = `ALU_SUB;

        // test overflow positive
        # 10 A = 2147483647; B = 2147483647; control = `ALU_ADD;

        // test overflow negative
        # 10 A = -2147483647; B = 2147483647; control = `ALU_SUB;

        // test logic AND (0)
        # 10 A = 2; B = 5; control = `ALU_AND;

        // test logic OR (7)
        # 10 A = 2; B = 5; control = `ALU_OR;

        // test logi NOR (7)
        # 10 A = 2147483640; B = 256; control = `ALU_NOR;

        // test logic XOR (31)
        # 10 A = 21; B = 10; control = `ALU_XOR;

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
