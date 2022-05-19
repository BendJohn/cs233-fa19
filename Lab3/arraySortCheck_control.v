
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array;
	input clock, reset;

	wire garbage, ready, nop, inv, noinv, sort;

	// Assign next logic
	wire garbage_next = (~go & garbage) | reset;
	wire ready_next = ((garbage & go) | ((sort | inv) & go) | (ready & go)) & ~reset;
	wire nop_next = ((ready & ~go) | noinv) & ~reset;
	wire sort_next = (nop & end_of_array) & ~reset | (~reset & ~go & sort);
	wire noinv_next = nop & ~inversion_found & ~end_of_array & ~reset;
	wire inv_next = (nop & inversion_found & ~end_of_array) & ~reset | (~reset & ~go & inv);

	dffe fsGarbage(garbage, garbage_next, clock, 1'b1, 1'b0);
	dffe fsReady(ready, ready_next, clock, 1'b1, reset);
	dffe fsNop(nop, nop_next, clock, 1'b1, reset);
	dffe fsSort(sort, sort_next, clock, 1'b1, reset);
	dffe fsNoinv(noinv, noinv_next, clock, 1'b1, reset);
	dffe fsInv(inv, inv_next, clock, 1'b1, reset);

	assign sorted = sort & ~inv;
	assign done = sort | inv;
	assign load_input = ready;
	assign load_index = ready | noinv;
	assign select_index = noinv;

endmodule
