import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/score_cubit.dart';
import '../model/widgets/apple.dart';
import '../model/widgets/snake_head.dart';
import '../model/widgets/portal.dart';
import '../model/widgets/snake_tail.dart';
import '../model/widgets/obstacle.dart';
import '../model/widgets/game_board.dart';

class CellCubit extends Cubit<CellState> {
  dynamic width;
  dynamic coordX;
  final int coordY;
  GameBoardState gameBoardState;
  CellCubit(
    this.width,
    this.coordX,
    this.coordY,
    this.gameBoardState,
  ) : super(EmptyCell(width, coordX, coordY, gameBoardState));

  void setCell(int i, int head) {
    if (i == head) {
      emit(HeadCell(width, coordX, coordY, gameBoardState));
    } else if (i == 1) {
      emit(TailCell(width, coordX, coordY, gameBoardState));
    } else if (i > 0) {
      emit(SnakeCell(width, coordX, coordY, gameBoardState));
    } else if (i == -1) {
      emit(FoodCell(width, coordX, coordY, gameBoardState));
    } else if (i == -2) {
      emit(ObstacleCell(width, coordX, coordY, gameBoardState));
    } else if (i == -3) {
      List<int> targetCoord = gameBoardState
          .portals['$coordX,$coordY']!
          .split(',')
          .map((e) => int.parse(e))
          .toList();

      emit(PortalCell(width, coordX, coordY, targetCoord[0], targetCoord[1],
          gameBoardState));
    } else {
      emit(EmptyCell(width, coordX, coordY, gameBoardState));
    }
  }
}

abstract class CellState extends StatefulWidget {
  dynamic width;
  dynamic coordX;
  dynamic coordY;
  final GameBoardState gameBoardState;
  CellState(
    this.width,
    this.coordX,
    this.coordY,
    this.gameBoardState, {
    Key? key,
  }) : super(key: key);
  void cellAction() {
    gameBoardState.gameover();
  }
}

class EmptyCell extends CellState {
  EmptyCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  createState() => EmptyCellState();
  @override
  void cellAction() {
    gameBoardState.head = gameBoardState.target;
    gameBoardState.board[gameBoardState.target['x'] as int]
            [gameBoardState.target['y'] as int] =
        gameBoardState.target['score']! + 1;
    gameBoardState.board = gameBoardState.board
        .map((e) => e.map((e) => e > 0 ? e - 1 : e).toList())
        .toList();
  }
}

class EmptyCellState extends State<EmptyCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(widget.width / 2 - 2),
      margin: const EdgeInsets.all(2),
    );
  }
}

class HeadCell extends CellState {
  HeadCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  HeadCellState createState() => HeadCellState();
}

class HeadCellState extends State<HeadCell> {
  @override
  Widget build(BuildContext context) {
    return SnakeHead(width: widget.width);
  }
}

class TailCell extends EmptyCell {
  TailCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  TailCellState createState() => TailCellState();
}

class TailCellState extends State<TailCell> {
  @override
  Widget build(BuildContext context) {
    return SnakeTail(width: widget.width);
  }
}

class SnakeCell extends CellState {
  SnakeCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  SnakeCellState createState() => SnakeCellState();
}

class SnakeCellState extends State<SnakeCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      padding: EdgeInsets.all(widget.width / 2 - 1),
      margin: const EdgeInsets.all(1),
    );
  }
}

class FoodCell extends CellState {
  FoodCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  FoodCellState createState() => FoodCellState();

  @override
  void cellAction() {
    gameBoardState.head = gameBoardState.target;
    gameBoardState.head['score'] = gameBoardState.head['score']! + 1;
    gameBoardState.board[gameBoardState.head['x'] as int]
        [gameBoardState.head['y'] as int] = gameBoardState.head['score'] as int;
    BlocProvider.of<ScoreCubit>(gameBoardState.context, listen: false)
        .increment();
    gameBoardState.placeNewFood();
  }
}

class FoodCellState extends State<FoodCell> {
  @override
  Widget build(BuildContext context) {
    return Apple(width: widget.width);
  }
}

class ObstacleCell extends CellState {
  ObstacleCell(int width, int coordX, int coordY, GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  ObstacleCellState createState() => ObstacleCellState();
}

class ObstacleCellState extends State<ObstacleCell> {
  @override
  Widget build(BuildContext context) {
    return Obstacle(width: widget.width);
  }
}

class PortalCell extends CellState {
  final int targetX;
  final int targetY;

  PortalCell(int width, int coordX, int coordY, this.targetX, this.targetY,
      GameBoardState gameBoardState, {Key? key})
      : super(width, coordX, coordY, gameBoardState, key: key);

  @override
  PortalCellState createState() => PortalCellState();

  @override
  void cellAction() {
    gameBoardState.target = {
      'x': targetX + (gameBoardState.delta['dx'] as num) as int,
      'y': targetY + (gameBoardState.delta['dy'] as num) as int,
      'score': gameBoardState.head['score'] as int
    };
    gameBoardState.doTargetCellAction();
  }
}

class PortalCellState extends State<PortalCell> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.all(widget.width / 2 - 2),
          margin: const EdgeInsets.all(2),
        ),
        Portal(width: widget.width)
      ],
    );
  }
}
