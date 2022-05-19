#include <stdio.h>
#include <stdlib.h>
#include "filter.h"

#define ITER 64
#define RW 0
#define LOCALITY 3

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {
/*    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }*/

    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);

	// Second loop
	if (i >= 2 && i < SIZE - 2) {
        	filter2(image1, image2, i);
	}

	// Third loop
	if (i >= 6) {
		filter3(image2, i-5);
	}
    }
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
/*    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }*/

    for (int i = 1; i < SIZE - 1; i ++) {
    	__builtin_prefetch(image1[i+ITER], RW, LOCALITY);
    	__builtin_prefetch(image2[i+ITER], RW, LOCALITY);
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
    	__builtin_prefetch(image1[i+ITER], 1, LOCALITY);
    	__builtin_prefetch(image2[i+ITER], 1, LOCALITY);
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
    	__builtin_prefetch(image2[i+ITER], RW, LOCALITY);
        filter3(image2, i);
    }
}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {
/*    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }*/

     for (int i = 1; i < SIZE - 1; i ++) {
	// Prefetching
    	__builtin_prefetch(image1[i+ITER], RW, LOCALITY);
    	__builtin_prefetch(image2[i+ITER], RW, LOCALITY);

        filter1(image1, image2, i);

	// Second loop
	if (i >= 2 && i < SIZE - 2) {
        	filter2(image1, image2, i);
	}

	// Third loop
	if (i >= 6) {
		filter3(image2, i-5);
	}
    }   
}
