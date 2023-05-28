import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/model/widgets/score.dart';
import '../colours.dart';
import '../config.dart';
import '../../cubit/cell_cubit.dart';
import '../../cubit/score_cubit.dart';
import '../active_direction.dart';
import '../../screens/scoreboard.dart';
import '../../screens/main_menu.dart';
import 'package:http/http.dart' as http;

class GameBoard extends StatefulWidget {
  final int cellWidth;
  final int selectedLevel;
  Config cfg;

  GameBoard(
    this.selectedLevel,
    this.cellWidth,
    this.cfg, {
    Key? key,
  }) : super(key: key);

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  late List<List<int>> board;
  late List<List<CellCubit>> cells;
  late Map<String, int> delta;
  late Map<String, int> head;
  late Map<String, int> target;
  late int level;
  Map<String, String> portals = {};
  final int numberOfObstacles = 3;
  late Config cfg;
  late Timer timerUpdates;
  late Timer timerObstacles;

  late ActiveDirection activeDirection;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    activeDirection = Provider.of<ActiveDirection>(context, listen: false);
    level = widget.selectedLevel;
    cfg = widget.cfg;
    restart();
  }

  @override
  Widget build(BuildContext context) {
    return gameOver == true ? gameOverWidget() : cellBoard();
  }

  Widget gameOverWidget() {
    return Card(
      child: Container(
        color: Colour.charcoal,
        child: Column(
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(
                  fontSize: 54, color: Colors.amber, fontFamily: "Pixel-extra"),
            ),
            Container(
                margin: const EdgeInsets.only(top: 40, bottom: 20),
                height: 70,
                width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainMenuScreen(cfg)));
                  },
                  child:
                      const Text("MAIN MENU", style: TextStyle(fontSize: 36)),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 70,
                width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
                child: ElevatedButton(
                  onPressed: () {
                    setState(restart);
                  },
                  child: const Text("RESTART", style: TextStyle(fontSize: 36)),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 70,
                width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CHANGE DIFFICULTY LEVEL",
                      style: TextStyle(fontSize: 36)),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 70,
                width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scoreboard(cfg)));
                  },
                  child:
                      const Text("SCOREBOARD", style: TextStyle(fontSize: 36)),
                )),
          ],
        ),
      ),
    );
  }

  Widget cellBoard() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: cells
            .map((e) => Column(
                  children: e.map((e) {
                    return BlocBuilder<CellCubit, CellState>(
                      bloc: e,
                      builder: (context, state) {
                        return state;
                      },
                      buildWhen: (prev, curr) {
                        return (prev.runtimeType == curr.runtimeType)
                            ? false
                            : true;
                      },
                    );
                  }).toList(),
                ))
            .toList(),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => MainMenuScreen(cfg)));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width ~/ 10).toDouble(),
            )
          ])
    ]);
  }

  void restart() {
    initializeBoard();
    cells = List.generate(
        20,
        (i) =>
            List.generate(20, (j) => CellCubit(widget.cellWidth, i, j, this)));

    updateCells();
    gameOver = false;
    BlocProvider.of<ScoreCubit>(context, listen: false).restart();
    Provider.of<ActiveDirection>(context, listen: false).direction =
        Direction.right;
    placeNewFood();
    startGame();
  }

  void startGame() {
    if (level > 0) {
      relocateObstacles();
    }

    timerUpdates =
        Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      updateBoard();
      updateCells();
      if (gameOver) {
        timer.cancel();
        return;
      }
    });

    if (level == 3) {
      timerObstacles =
          Timer.periodic(const Duration(seconds: 20), (Timer timer) {
        if (gameOver) {
          timer.cancel();
          return;
        }

        relocateObstacles();
      });
    }
  }

  void gameover() {
    if (cfg.token.isNotEmpty && globalScore != 0) {
      updateScore();
    }

    if (level == 3) {
      timerObstacles.cancel();
    }
    timerUpdates.cancel();

    setState(() {
      gameOver = true;
    });
  }

  void updateCells() {
    for (var i = 0; i < 20; i++) {
      for (var j = 0; j < 20; j++) {
        cells[i][j].setCell(board[i][j], head['score'] as int);
        activeDirection.lastDirection = activeDirection.direction;
      }
    }
  }

  void updateBoard() {
    delta = activeDirection.getDelta();
    target = {
      'x': (head['x']! + (delta['dx'] as num)) % 20 as int,
      'y': (head['y']! + (delta['dy'] as num)) % 20 as int,
      'score': head['score'] as int,
    };
    doTargetCellAction();
  }

  void doTargetCellAction() {
    cells[target['x'] as int][target['y'] as int].state.cellAction();
  }

  void placeNewFood() {
    bool foodPlaced = false;
    int newFoodLocation = Random().nextInt(
        400 - (head['score'] as int) - portals.length - numberOfObstacles);
    board = board
        .map((e) => e.map((cell) {
              if (!foodPlaced) {
                if (cell == 0) {
                  --newFoodLocation;
                  if (newFoodLocation == -1) {
                    foodPlaced = true;
                    return -1;
                  }
                }
              }
              return cell;
            }).toList())
        .toList();
  }

  void relocateObstacles() {
    if (gameOver) {
      return;
    }

    board = board
        .map((e) => e.map((cell) {
              if (cell == -2) {
                return 0;
              }
              return cell;
            }).toList())
        .toList();

    for (int i = 0; i < numberOfObstacles; ++i) {
      placeNewObstacle();
    }
  }

  void placeNewObstacle() {
    bool obstaclePlaced = false;
    int newObstacleLocation =
        Random().nextInt(400 - (head['score'] as int) - portals.length - 3);

    board = board
        .map((e) => e.map((cell) {
              if (!obstaclePlaced) {
                if (cell == 0) {
                  --newObstacleLocation;
                  if (newObstacleLocation == -1) {
                    obstaclePlaced = true;
                    return -2;
                  }
                }
              }
              return cell;
            }).toList())
        .toList();
  }

  void initializeBoard() {
    board = List.generate(
        20, (index) => List.generate(20, (index) => 0)); // empty == 0
    board[5][5] = 2; // head
    board[4][5] = 1; // tail
    head = {'x': 5, 'y': 5, 'score': 2};
    if (level > 1) {
      // portals
      board[15][5] = -3;
      board[5][15] = -3;
      portals = {
        '15,5': '5,15',
        '5,15': '15,5',
      };
    }
  }

  void updateScore() async {
    http.post(Uri.parse("${cfg.url}/scores/1"),
        body: jsonEncode({"score": globalScore}),
        headers: {HttpHeaders.authorizationHeader: "Bearer ${cfg.token}"});
  }
}
