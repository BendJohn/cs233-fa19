module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire [31:0] interrupt_out, cycle_out, add_one;
    wire TimerWrite, ci_equal, line_reset, Acknowledge;
    wire ac_equal, ack_equal, TimerRead;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

    // Registers
    register cycle_counter(cycle_out, add_one, clock, 1'b1, reset);
    register #(1) interrupt_line(TimerInterrupt, 1'b1, clock, ci_equal, line_reset);
    register #(32, 32'hffffffff) interrupt_counter(interrupt_out, data, clock, TimerWrite, reset);

    // ALU
    alu32 adder(add_one, , , 3'h0, cycle_out, 32'b1);

    // tri-state buffers
    tristate tris(cycle, cycle_out, TimerRead);

    // Equals
    assign ci_equal = (interrupt_out == cycle_out);
    assign ac_equal = (address == 32'hffff001c);
    assign ack_equal = (address == 32'hffff006c);

    // and
    assign Acknowledge = (ack_equal & MemWrite);
    assign TimerWrite = (ac_equal & MemWrite);
    assign TimerRead = (ac_equal & MemRead);

    // or
    assign line_reset = (Acknowledge | reset);
    assign TimerAddress = (ac_equal | ack_equal);
endmodule
