#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    int TILE = 64;
    for (int i = 0; i < SIZE; i += TILE) {
        for (int j = 0; j < SIZE; j += TILE) {
		for (int x = i; x < min(i + TILE, SIZE); ++x) {
			for (int y = j; y < min(j + TILE, SIZE); ++y) {
        	    		dest[x][y] = src[y][x];
			}
		}
        }
    }
}
