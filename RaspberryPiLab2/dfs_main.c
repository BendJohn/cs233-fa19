#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define LENGTH 128
#define TESTS 5
#define MAX 1000

int dfs(int target, int i, int* tree);
int print_error(int target, int result, int expected_result, int *array, int testnum);

int main (){
  int array[LENGTH];

  srand(time(0));  
  for (int i = 0; i < LENGTH; i++ ){
    int n = rand() % MAX;
    array[i] = n;
  }

  for (int i = 0; i < TESTS; i++){
    int index = (rand() % (LENGTH - 1)) + 1 ;

    while(1){
      int j;
      for (j = 1; j < LENGTH; j++){
	if ((array[j] == array[index]) && (j != index)){
	  index = (rand() % (LENGTH - 1)) + 1;
	  break;
	}
      }
      if (j == LENGTH){
	break;
      }	  
    }

    int target = array[index];
    int expected_result = 0;
    int index_copy = index;
    while (index_copy != 1){
      expected_result++;
      index_copy = index_copy / 2;
    }
    
    int result = dfs(target, 1, array);

    if (expected_result != result){
      print_error(target, result, expected_result, array, i);
      return 0;
    }
    else{
      printf("Test %d passed \n", i);
    }
  }


 for (int i = 0; i < TESTS; i++){
   int target = rand() % MAX;

    while(1){
      int j;
      for (j = 1; j < LENGTH; j++){
	if (array[j] == target){
	  target = rand() % MAX;
	  break;
	}
      }
      if (j == LENGTH){
	break;
      }	  
    }

    int expected_result = -1;    
    int result = dfs(target, 1, array);

    if (expected_result != result){
      print_error(target, result, expected_result, array, i + TESTS);
      return 0;
    }
    else{
      printf("Test %d passed \n", i + TESTS);
    }
  }
  
  
  return 0;
}

int print_error(int target, int result, int expected_result, int *array, int testnum){
  printf("\n\n\nTest %d Failed\n\n", testnum);
  printf("Target value = %d\n", target);
  printf("Array is : \nindex\t\tvalue\n");
  for (int i = 1; i < LENGTH; i++ ){
    printf("%d\t\t%d\n", i, array[i]);
  }
  printf("\n\nExpected Result : %d \nResult = %d  \n", expected_result, result);
}
