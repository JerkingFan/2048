

import 'dart:math';

import 'package:flutter/material.dart';

class Game2048 extends StatefulWidget {
  @override
  _Game2048State createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  late List<List<int>> grid;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    grid = List<List<int>>.generate(5, (index) => List<int>.filled(5, 0));
    score = 0;
    addNewTile();
    addNewTile();
  }

  void addNewTile() {
    List<int> emptyTiles = [];
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 0) {
          emptyTiles.add(i * grid.length + j);
        }
      }
    }

    if (emptyTiles.isEmpty) return;

    final rng = Random();
    int index = emptyTiles[rng.nextInt(emptyTiles.length)];
    int row = index ~/ grid.length;
    int col = index % grid.length;
    grid[row][col] = rng.nextInt(10) == 0 ? 4 : 2;
  }

  void swipeLeft() {
    setState(() {
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length - 1; col++) {
          if (grid[row][col] == 0) continue;
          int nextCol = col + 1;
          while (nextCol < grid[row].length && grid[row][nextCol] == 0) {
            nextCol++;
          }
          if (nextCol == grid[row].length) break;
          if (grid[row][col] == grid[row][nextCol]) {
            grid[row][col] *= 2;
            score += grid[row][col];
            grid[row][nextCol] = 0;
          } else if (grid[row][nextCol] != 0) {
            continue;
          } else {
            grid[row][nextCol] = grid[row][col];
            grid[row][col] = 0;
          }
        }
      }
    });
    addNewTile();
  }

  void swipeRight() {
    setState(() {
      for (int row = 0; row < grid.length; row++) {
        for (int col = grid[row].length - 1; col > 0; col--) {
          if (grid[row][col] == 0) continue;
          int prevCol = col - 1;
          while (prevCol >= 0 && grid[row][prevCol] == 0) {
            prevCol--;
          }
          if (prevCol < 0) break;
          if (grid[row][col] == grid[row][prevCol]) {
            grid[row][col] *= 2;
            score += grid[row][col];
            grid[row][prevCol] = 0;
          } else if (grid[row][prevCol] != 0) {
            continue;
          } else {
            grid[row][prevCol] = grid[row][col];
            grid[row][col] = 0;
          }
        }
      }
    });
    addNewTile();
  }

  void swipeUp() {
    setState(() {
      for (int col = 0; col < grid[0].length; col++) {
        for (int row = 0; row < grid.length - 1; row++) {
          if (grid[row][col] == 0) continue;
          int nextRow = row + 1;
          while (nextRow < grid.length && grid[nextRow][col] == 0) {
            nextRow++;
          }
          if (nextRow == grid.length) break;
          if (grid[row][col] == grid[nextRow][col]) {
            grid[row][col] *= 2;
            score += grid[row][col];
            grid[nextRow][col] = 0;
          } else if (grid[nextRow][col] != 0) {
            continue;
          } else {
            grid[nextRow][col] = grid[row][col];
            grid[row][col] = 0;
          }
        }
      }
    });
    addNewTile();
  }

  void swipeDown() {
    setState(() {
      for (int col = 0; col < grid[0].length; col++) {
        for (int row = grid.length - 1; row > 0; row--) {
          if (grid[row][col] == 0) continue;
          int prevRow = row - 1;
          while (prevRow >= 0 && grid[prevRow][col] == 0) {
            prevRow--;
          }
          if (prevRow < 0) break;
          if (grid[row][col] == grid[prevRow][col]) {
            grid[row][col] *= 2;
            score += grid[row][col];
            grid[prevRow][col] = 0;
          } else if (grid[prevRow][col] != 0) {
            continue;
          } else {
            grid[prevRow][col] = grid[row][col];
            grid[row][col] = 0;
          }
        }
      }
    });
    addNewTile();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          swipeRight();
        } else if (details.primaryVelocity! < 0) {
          swipeLeft();
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          swipeDown();
        } else if (details.primaryVelocity! < 0) {
          swipeUp();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: 5 * 5,
            itemBuilder: (BuildContext context, int index) {
              int row = index ~/ 5;
              int col = index % 5;
              Color backgroundColor = Colors.transparent;
              if (grid[row][col] != 0) {
                backgroundColor = Color((grid[row][col] * 1000000).hashCode);
              }
              return Container(
                color: backgroundColor,
                child: Center(
                  child: grid[row][col] != 0
                      ? Text(
                          grid[row][col].toString(),
                          style: TextStyle(fontSize: 24.0),
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}