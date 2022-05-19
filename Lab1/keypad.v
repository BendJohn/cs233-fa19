module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire 	w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19;

   and andv1(w1, a, g);
   and andv2(w2, c, g);
   or orv1(w3, w1, w2);
   not notv1(w17, w3);
   or orv2(w18, a, b);
   or orv3(w19, w18, c);
   and andv3(valid, w19, w17);		// find valid

   not notn31(w4, a);
   and andn31(number[3], f, w4);	// finds number[3]

   and andn21(w5, f, a);
   or orn21(number[2], w5, e);		// finds number[2]

   and and11(w6, e, c);
   and and12(w7, d, c);
   and and13(w8, d, b);
   or or11(w9, w5, w6);
   or or12(w10, w7, w8);
   or or13(number[1], w9, w10);		// finds number[1]

  and and01(w11, f, c);
  and and02(w12, e, b);
  and and03(w13, d, a);
  or or01(w14, w11, w5);
  or or02(w15, w12, w7);
  or or03(w16, w14, w15);
  or or04(number[0], w16, w13);		// finds number[0]
   
endmodule // keypad
