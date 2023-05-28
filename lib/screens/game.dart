import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/colours.dart';
import '../model/config.dart';
import '../model/active_direction.dart';
import '../model/widgets/game_board.dart';
import '../model/widgets/score.dart';

class Game extends StatelessWidget {
  int selectedLevel;
  Config cfg;

  Game(this.cfg, this.selectedLevel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActiveDirection activeDirection =
        Provider.of<ActiveDirection>(context, listen: false);
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        checkMove(event, activeDirection);
      },
      child: Container(
        color: Colour.charcoal,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Score(selectedLevel),
              GameBoard(
                  selectedLevel, MediaQuery.of(context).size.width ~/ 50, cfg),
            ],
          ),
        ),
      ),
    );
  }

  void checkMove(RawKeyEvent event, ActiveDirection activeDirection) {
    if (event.isKeyPressed(LogicalKeyboardKey.keyH) ||
        event.isKeyPressed(LogicalKeyboardKey.keyA) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      activeDirection.direction =
          (activeDirection.lastDirection == Direction.right)
              ? Direction.right
              : Direction.left;
    } else if (event.isKeyPressed(LogicalKeyboardKey.keyL) ||
        event.isKeyPressed(LogicalKeyboardKey.keyD) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      activeDirection.direction =
          (activeDirection.lastDirection == Direction.left)
              ? Direction.left
              : Direction.right;
    } else if (event.isKeyPressed(LogicalKeyboardKey.keyK) ||
        event.isKeyPressed(LogicalKeyboardKey.keyW) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      activeDirection.direction =
          (activeDirection.lastDirection == Direction.down)
              ? Direction.down
              : Direction.up;
    } else if (event.isKeyPressed(LogicalKeyboardKey.keyJ) ||
        event.isKeyPressed(LogicalKeyboardKey.keyS) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      activeDirection.direction =
          (activeDirection.lastDirection == Direction.up)
              ? Direction.up
              : Direction.down;
    }
  }
}
