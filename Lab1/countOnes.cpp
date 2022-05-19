/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned right_mask_16 = 0b01010101010101010101010101010101;
	unsigned right_input_16 = input & right_mask_16;
	unsigned left_mask_16 = 0b10101010101010101010101010101010;
	unsigned left_input_16 = input & left_mask_16;
	input = (left_input_16>>1) + (right_input_16);

	unsigned right_mask_8 = 0b00110011001100110011001100110011;
	unsigned right_input_8 = input & right_mask_8;
	unsigned left_mask_8 = 0b11001100110011001100110011001100;
	unsigned left_input_8 = input & left_mask_8;
	input = (left_input_8>>2) + (right_input_8);

	unsigned right_mask_4 = 0b00001111000011110000111100001111;
	unsigned right_input_4 = input & right_mask_4;
	unsigned left_mask_4 = 0b11110000111100001111000011110000;
	unsigned left_input_4 = input & left_mask_4;
	input = (left_input_4>>4) + (right_input_4);

	unsigned right_mask_2 = 0b00000000111111110000000011111111;
	unsigned right_input_2 = input & right_mask_2;
	unsigned left_mask_2 = 0b11111111000000001111111100000000;
	unsigned left_input_2 = input & left_mask_2;
	input = (left_input_2>>8) + (right_input_2);

	unsigned right_mask_1 = 0b00000000000000001111111111111111;
	unsigned right_input_1 = input & right_mask_1;
	unsigned left_mask_1 = 0b11111111111111110000000000000000;
	unsigned left_input_1 = input & left_mask_1;
	input = (left_input_1>>16) + (right_input_1);
	return input;
}
