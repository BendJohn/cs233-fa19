struct Puzzle {
  int NUM_ROWS;
  int NUM_COLS;
  char** board;
};


char floodfill (Puzzle* puzzle, char marker, int row, int col) {
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

  floodfill(puzzle, marker, row + 1, col + 1);
  floodfill(puzzle, marker, row + 1, col + 0);
  floodfill(puzzle, marker, row + 1, col - 1);

  floodfill(puzzle, marker, row, col + 1);
  floodfill(puzzle, marker, row, col - 1);

  floodfill(puzzle, marker, row - 1, col + 1);
  floodfill(puzzle, marker, row - 1, col + 0);
  floodfill(puzzle, marker, row - 1, col - 1);

  return marker + 1;
}

void islandfill(Puzzle* puzzle) {
  char marker = 'A';
  for (int i = 0; i < puzzle->NUM_ROWS; i++) {
    for (int j = 0; j < puzzle->NUM_COLS; j++) {
      marker = floodfill(puzzle,marker,i,j);
    }
  }
}
