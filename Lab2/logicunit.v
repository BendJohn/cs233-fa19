// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;

    mux4 mux(out, A&B, A|B, A~|B, A^B, control);

endmodule // logicunit
