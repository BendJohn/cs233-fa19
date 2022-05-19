#include "mv-mult.h"
#include <xmmintrin.h>

// Matrix-Vector multiplication
// mat is a SIZE by SIZE matrix, that is arranged in row-column, format,
// That is, you first select a particular row, and then a particular column.
// Each row is laid out as a one-dimensional, array, so if you wanted
// to select a particular row, you would use mat[row].  You can
// also select smaller intervals, by using &mat[row][col].
// The vector is also laid out as a one-dimensional arrow, similar to a row.
// M-V multiplication proceeds by taking the dot product of a matrix row
// with the vector, and doing this for each row in the matrix

// vectorize the below code using SIMD intrinsics
float *
mv_mult_vector(float mat[SIZE][SIZE], float vec[SIZE]) {
    /*static float ret[SIZE];

    for (int i = 0; i < SIZE; i ++) {
        ret[i] = 0;
        for (int j = 0; j < SIZE; j ++) {
            ret[i] += mat[i][j] * vec[j];
        }
    }

    return ret;*/

    static float ret[SIZE], ret4[4];
    __m128 acc, mat4, vec4;

    for (int i = 0; i < SIZE; i ++) {
	acc = _mm_set1_ps(0.0);
        ret[i] = 0.0;

	int j = 0;
        for (; j < (SIZE - 3); j += 4) {
		mat4 = _mm_loadu_ps(&mat[i][j]);
		vec4 = _mm_loadu_ps(&vec[j]);
		acc = _mm_add_ps(acc, _mm_mul_ps(mat4, vec4));
        }

	_mm_storeu_ps(ret4, acc);
	ret[i] = ret4[0] + ret4[1] + ret4[2] + ret4[3];

	// Get the rest of the j's
	for (; j < SIZE; j++) {
		ret[i] += mat[i][j] * vec[j];
	}
    }

    return ret;
}
