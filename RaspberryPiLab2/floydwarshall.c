void floyd_warshall (int graph[6][6], int shortest_distance[6][6]) {
  for (int i = 0; i < 6; ++i) {
    for (int j = 0; j < 6; ++j) {
      if (i == j) {
        shortest_distance[i][j] = 0;
      } else {
        shortest_distance[i][j] = graph[i][j];
      }
    }
  }
  for (int k = 0; k < 6; k++) {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        if (shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]) {
          shortest_distance[i][j] = shortest_distance[i][k] + shortest_distance[k][j];
        }
      }
    }
  }
}
