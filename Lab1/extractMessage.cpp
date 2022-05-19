/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here
	for (size_t i=0; i<length/8; i++) {	
		for (size_t j=0; j<8; j++) {
			char letter = 0;
			for (size_t k=0; k<8; k++) {
				unsigned char curr_input = message_in[8*i+k];
				curr_input = curr_input>>j;		// shift right to get rid of useless LSBs
				curr_input = curr_input<<j;		// get it back to original position
				curr_input = curr_input<<(7-j);		// shift left based on what letter I'm trying to find
				curr_input = curr_input>>(7-k);		// shift right to the position of bit in the letter
				letter = letter | curr_input;		// add it to the letter we have		
			}
			message_out[8*i+j] = letter;
		}
	}
	return message_out;
}
