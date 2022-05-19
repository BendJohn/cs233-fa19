#include<stdio.h>

#define N 6

void test(int testNum, int matrix[N][N]);

void printMatrix(int matrix[N][N]);
void printError(int testNum, int result[N][N], int expected[N][N]);

void floyd_warshall(int graph[N][N], int shortest_distance[N][N]);
void floyd_warshall_c(int graph[N][N], int shortest_distance[N][N]);


int main(){
  int matrices[6][N][N] = {{{0, 8, 8, 9999, 3, 3},
			    {9999, 0, 7, 3, 1, 9999},
			    {1, 9999, 0, 3, 10, 7},
			    {3, 10, 2, 0, 9999, 9999},
			    {1, 9999, 4, 8, 0, 7},
			    {9999, 4, 7, 9999, 1, 0}},

			   {{0, 9999, 9999, 9999, 9999, 9999},
			    {9999, 0, 9999, 9999, 9999, 9999},
			    {9999, 9999, 0, 9999, 9999, 9999},
			    {9999, 9999, 9999, 0, 9999, 9999},
			    {9999, 9999, 9999, 9999, 0, 9999},
			    {9999, 9999, 9999, 9999, 9999, 0}},

			   {{0, -1, 6, 9999, 9999, 9999},
			    {9999, 0, 9, 10, 13, 9999},
			    {14, 9999, 0, 24, 15, 4},
			    {-1, 10, 2, 0, 9999, 9999},
			    {9, 9999, 5, 8, 0, 7},
			    {9999, -1, 7, 9999, 10, 0}},

			   {{0, 1, 9999, 9999, 9999, 9999},
			    {9999, 0, 1, 9999, 9999, 9999},
			    {9999, 9999, 0, 1, 9999, 9999},
			    {9999, 9999, 9999, 0, 1, 9999},
			    {9999, 9999, 9999, 9999, 0, 1},
			    {1, 9999, 9999, 9999, 9999, 0}},

			   {{0, 2, 3, 4, 5, 6},
			    {1, 0, 3, 4, 5, 6},
			    {1, 2, 0, 4, 5, 6},
			    {1, 2, 3, 0, 5, 6},
			    {1, 2, 3, 4, 0, 6},
			    {1, 2, 3, 4, 5, 0}},

			   {{0, 9999, 1, 9999, 1, 9999},
			    {9999, 0, 9999, 2, 2, 9999},
			    {3, 9999, 0, 3, 9999, 9999},
			    {4, 4, 4, 0, 9999, 9999},
			    {9999, 9999, 5, 5, 0, 9999},
			    {9999, 9999, 9999, 9999, 9999, 0}}};
  
  for (int i = 0; i < 6; i++){
    test(i, matrices[i]);
  }

  return 0;
}

void print_error(int testNum, int result[N][N], int expected[N][N]){
  printf("\nFailed test number %d\n\n", testNum);
  printf("Result is : \n");
  printMatrix(result);
  printf("Expected is : \n");
  printMatrix(expected);
}

void printMatrix(int matrix[N][N]){
  printf("[");
  for (int i = 0; i < N; i++){
    if (i != 0){
      printf(" ");
    }
    for (int j = 0; j < N; j++){
      if (j != N-1){
	printf("%d\t", matrix[i][j]);
      }
      else{
	if (i != N-1){
	  printf("%d\n", matrix[i][j]);
	}
	else{
	  printf("%d]\n\n");
	}
      }
    }
  }	  
}

void test(int testNum, int matrix[N][N]){
  int result[N][N] = {{0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0}};

  int expected[N][N] = {{0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0},
		      {0, 0, 0, 0, 0, 0}};

  floyd_warshall_c(matrix, expected);
  floyd_warshall(matrix, result);

  for (int i = 0; i < N; i++){
    for (int j = 0; j < N; j++){
      if (result[i][j] != expected[i][j]){
	print_error(testNum, result, expected);
	return;
      }
    }
  }
}


void floyd_warshall_c(int graph[N][N], int shortest_distance[N][N]) {
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      if (i == j) {
        shortest_distance[i][j] = 0;
      } else {
        shortest_distance[i][j] = graph[i][j];
      }
    }
  }
  for (int k = 0; k < N; k++) {
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        if (shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]) {
          shortest_distance[i][j] = shortest_distance[i][k] + shortest_distance[k][j];
        }
      }
    }
  }
}

