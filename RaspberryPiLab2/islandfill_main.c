#include<stdio.h>
#include<stdlib.h>

struct Puzzle {
  int NUM_ROWS;
  int NUM_COLS;
  char** board;
};

void islandfill_c(struct Puzzle* puzzle);
void islandfill(struct Puzzle* puzzle);
char floodfill_c (struct Puzzle* puzzle, char marker, int row, int col);
char floodfill (struct Puzzle* puzzle, char marker, int row, int col);
void printPuzzle(struct Puzzle* puzzle);
void printError(struct Puzzle* result, struct Puzzle* expected);
void test1();
void test2();
void test3();
void test4();
void test5();
void test6();
void test7();
void test8();
void test9();
void test10();

int main(){
  // Test 1
  test1();
  test2();
  test3();
  test4();
  test5();
  test6();
  test7();
  test8();
  test9();
  test10();

  return 0;
}


void printPuzzle(struct Puzzle* puzzle){
  printf("\n\n");
  printf("Rows = %d\n", puzzle->NUM_ROWS );
  printf("Columns = %d\n\n", puzzle->NUM_COLS);
  for (int i = 0; i < puzzle->NUM_ROWS; i++){
    printf("%s\n", puzzle->board[i]);
  }
  printf("\n\n");
}

char floodfill_c (struct Puzzle* puzzle, char marker, int row, int col) {
  if (row < 0 || col < 0) {
    return marker;
  }

  if (row >= puzzle->NUM_ROWS || col >= puzzle->NUM_COLS) {
    return marker;
  }

  char ** board = puzzle->board;

  if (board[row][col] != '#') {
    return marker;
  }

  board[row][col] = marker;

  floodfill_c(puzzle, marker, row + 1, col + 1);
  floodfill_c(puzzle, marker, row + 1, col + 0);
  floodfill_c(puzzle, marker, row + 1, col - 1);

  floodfill_c(puzzle, marker, row, col + 1);
  floodfill_c(puzzle, marker, row, col - 1);

  floodfill_c(puzzle, marker, row - 1, col + 1);
  floodfill_c(puzzle, marker, row - 1, col + 0);
  floodfill_c(puzzle, marker, row - 1, col - 1);

  return marker + 1;
}

void islandfill_c(struct Puzzle* puzzle) {
  char marker = 'A';
  for (int i = 0; i < puzzle->NUM_ROWS; i++) {
    for (int j = 0; j < puzzle->NUM_COLS; j++) {
      marker = floodfill_c(puzzle,marker,i,j);
    }
  }
}

void printError(struct Puzzle* result, struct Puzzle* expected){
  printf("Test failed \n\n");
  printf("Result is: \n");
  printPuzzle(result);
  printf("Expected is: \n");
  printPuzzle(expected);
}

void test1(){
  char line1[] = "##_____________";
  char line2[] = "_##_________##_";
  char line3[] = "____________#__";
  char line4[] = "_______________";
  char line5[] = "_____#_____#___";
  char line6[] = "___####________";
  char line7[] = "____##_________";
  char line8[] = "______________#";
  char line9[] = "______________#";
  char line10[] = "_#____________#";
  char line11[] = "#_#___________#";
  char line12[] = "_#_____________";
  char line13[] = "__________##___";
  char line14[] = "_______#____#__";
  char line15[] = "_______________";

  char *test1[15] = {line1, line2, line3, line4,
		     line5, line6, line7, line8,
		     line9, line10, line11, line12,
		     line13, line14, line15};

  struct Puzzle testPuzzle1 = {15, 15, test1};

  char line1_c[] = "##_____________";
  char line2_c[] = "_##_________##_";
  char line3_c[] = "____________#__";
  char line4_c[] = "_______________";
  char line5_c[] = "_____#_____#___";
  char line6_c[] = "___####________";
  char line7_c[] = "____##_________";
  char line8_c[] = "______________#";
  char line9_c[] = "______________#";
  char line10_c[] = "_#____________#";
  char line11_c[] = "#_#___________#";
  char line12_c[] = "_#_____________";
  char line13_c[] = "__________##___";
  char line14_c[] = "_______#____#__";
  char line15_c[] = "_______________";

  char *test1_c[15] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c,
		     line9_c, line10_c, line11_c, line12_c,
		     line13_c, line14_c, line15_c};
   
  
  struct Puzzle testPuzzle1_c = {15, 15, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test2(){
  char line1[] = "____#_##_#__##__";
  char line2[] = "#__#___#___####_";
  char line3[] = "##___###_##_#__#";
  char line4[] = "_____##__###____";
  char line5[] = "#_###_##__##_#__";
  char line6[] = "#__#_####_____##";
  char line7[] = "##______##____##";
  char line8[] = "##_###______##__";
  char line9[] = "#__##_#_###__##_";
  char line10[] = "__###__##__#_#_#";
  char line11[] = "_#_#___#_##_#_##";
  char line12[] = "#___##_###______";
  char line13[] = "##__##__##__#_##";
  char line14[] = "_#__##_#___####_";
  char line15[] = "__##_###_####_##";
  char line16[] = "_#_##____#_#__##";
  char *test1[16] = {line1, line2, line3, line4,
		     line5, line6, line7, line8,
		     line9, line10, line11, line12,
		     line13, line14, line15, line16};

  struct Puzzle testPuzzle1 = {16, 16, test1};

  char line1_c[] = "____#_##_#__##__";
  char line2_c[] = "#__#___#___####_";
  char line3_c[] = "##___###_##_#__#";
  char line4_c[] = "_____##__###____";
  char line5_c[] = "#_###_##__##_#__";
  char line6_c[] = "#__#_####_____##";
  char line7_c[] = "##______##____##";
  char line8_c[] = "##_###______##__";
  char line9_c[] = "#__##_#_###__##_";
  char line10_c[] = "__###__##__#_#_#";
  char line11_c[] = "_#_#___#_##_#_##";
  char line12_c[] = "#___##_###______";
  char line13_c[] = "##__##__##__#_##";
  char line14_c[] = "_#__##_#___####_";
  char line15_c[] = "__##_###_####_##";
  char line16_c[] = "_#_##____#_#__##";
  char *test1_c[16] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c,
		     line9_c, line10_c, line11_c, line12_c,
		     line13_c, line14_c, line15_c, line16_c};
   
  
  struct Puzzle testPuzzle1_c = {16, 16, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test3(){
  char line1[] = "_";
  char line2[] = "#";
  char line3[] = "#";
  char line4[] = "_";
  char line5[] = "_";
  char line6[] = "#";
  char line7[] = "_";
  char line8[] = "_";
  char line9[] = "#";
  char *test1[9] = {line1, line2, line3, line4,
		     line5, line6, line7, line8,
		     line9};

  struct Puzzle testPuzzle1 = {9, 1, test1};

  char line1_c[] = "_";
  char line2_c[] = "#";
  char line3_c[] = "#";
  char line4_c[] = "_";
  char line5_c[] = "_";
  char line6_c[] = "#";
  char line7_c[] = "_";
  char line8_c[] = "_";
  char line9_c[] = "#";
  char *test1_c[9] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c,
		     line9_c};
   
  
  struct Puzzle testPuzzle1_c = {9, 1, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test4(){
  char line1[] = "##_____#";
  char line2[] = "_______#";
  char line3[] = "#_#__#_#";
  char line4[] = "_#_____#";
  char line5[] = "________";
  char line6[] = "########";
  char line7[] = "_______#";
  char line8[] = "_######_";
  char *test1[8] = {line1, line2, line3, line4,
		     line5, line6, line7, line8};

  struct Puzzle testPuzzle1 = {8, 8, test1};

  char line1_c[] = "##_____#";
  char line2_c[] = "_______#";
  char line3_c[] = "#_#__#_#";
  char line4_c[] = "_#_____#";
  char line5_c[] = "________";
  char line6_c[] = "########";
  char line7_c[] = "_______#";
  char line8_c[] = "_######_";
  char *test1_c[8] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c};
   
  
  struct Puzzle testPuzzle1_c = {8, 8, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test5(){
  char line1[] = "#_#__#_#";
  char line2[] = "________";
  char line3[] = "#_#__#_#";
  char line4[] = "________";
  char line5[] = "________";
  char line6[] = "#_#__#_#";
  char line7[] = "________";
  char line8[] = "#_#__#_#";
  char *test1[8] = {line1, line2, line3, line4,
		     line5, line6, line7, line8};

  struct Puzzle testPuzzle1 = {8, 8, test1};

  char line1_c[] = "#_#__#_#";
  char line2_c[] = "________";
  char line3_c[] = "#_#__#_#";
  char line4_c[] = "________";
  char line5_c[] = "________";
  char line6_c[] = "#_#__#_#";
  char line7_c[] = "________";
  char line8_c[] = "#_#__#_#";
  char *test1_c[8] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c};
   
  
  struct Puzzle testPuzzle1_c = {8, 8, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }  
}

void test6(){
  char line1[] = "#_#_#_#_";
  char line2[] = "_#_#_#_#";
  char line3[] = "#_#_#_#_";
  char line4[] = "_#_#_#_#";
  char line5[] = "#_#_#_#_";
  char line6[] = "_#_#_#_#";
  char line7[] = "#_#_#_#_";
  char line8[] = "_#_#_#_#";
  char *test1[8] = {line1, line2, line3, line4,
		     line5, line6, line7, line8};

  struct Puzzle testPuzzle1 = {8, 8, test1};

  char line1_c[] = "#_#_#_#_";
  char line2_c[] = "_#_#_#_#";
  char line3_c[] = "#_#_#_#_";
  char line4_c[] = "_#_#_#_#";
  char line5_c[] = "#_#_#_#_";
  char line6_c[] = "_#_#_#_#";
  char line7_c[] = "#_#_#_#_";
  char line8_c[] = "_#_#_#_#";
  char *test1_c[8] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c};
   
  
  struct Puzzle testPuzzle1_c = {8, 8, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test7(){
  char line1[] = "________";
  char line2[] = "________";
  char line3[] = "________";
  char line4[] = "________";
  char line5[] = "________";
  char line6[] = "________";
  char line7[] = "________";
  char line8[] = "________";
  char *test1[8] = {line1, line2, line3, line4,
		     line5, line6, line7, line8};

  struct Puzzle testPuzzle1 = {8, 8, test1};

  char line1_c[] = "________";
  char line2_c[] = "________";
  char line3_c[] = "________";
  char line4_c[] = "________";
  char line5_c[] = "________";
  char line6_c[] = "________";
  char line7_c[] = "________";
  char line8_c[] = "________";
  char *test1_c[8] = {line1_c, line2_c, line3_c, line4_c,
		     line5_c, line6_c, line7_c, line8_c};
   
  
  struct Puzzle testPuzzle1_c = {8, 8, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test8(){
  char line1[] = "#____###___#___#";
  char *test1[1] = {line1};

  struct Puzzle testPuzzle1 = {1, 16, test1};

  char line1_c[] = "#____###___#___#";
  char *test1_c[1] = {line1_c};
   
  
  struct Puzzle testPuzzle1_c = {1, 16, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test9(){
  char line1[] = "#";
  char *test1[1] = {line1};

  struct Puzzle testPuzzle1 = {1, 1, test1};

  char line1_c[] = "#";
  char *test1_c[1] = {line1_c};
   
  
  struct Puzzle testPuzzle1_c = {1, 1, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}

void test10(){
  char line1[] = "_";
  char *test1[1] = {line1};

  struct Puzzle testPuzzle1 = {1, 1, test1};

  char line1_c[] = "_";
  char *test1_c[1] = {line1_c};
   
  
  struct Puzzle testPuzzle1_c = {1, 1, test1_c};
  islandfill_c(&testPuzzle1_c);
  islandfill(&testPuzzle1);

  for (int i = 0; i < testPuzzle1_c.NUM_ROWS; i ++){
    for (int j = 0; j < testPuzzle1_c.NUM_COLS; j ++){
      if (testPuzzle1.board[i][j] != testPuzzle1_c.board[i][j]){
        printError(&testPuzzle1, &testPuzzle1_c);
        return;
      }
    }
  }
}