import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/model/colours.dart';
import '../../cubit/score_cubit.dart';

int globalScore = 0;

class Score extends StatefulWidget {
  int level;

  Score(
    this.level, {
    Key? key,
  }) : super(key: key);

  @override
  ScoreState createState() => ScoreState();
}

class ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0,
      upperBound: 10,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colour.charcoal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Score:  ",
                style: TextStyle(
                    fontSize: 32,
                    color: Colour.fontEcru,
                    fontFamily: "Pixel-extra"),
              ),
              BlocBuilder<ScoreCubit, int>(
                builder: (context, state) {
                  controller.reset();
                  controller.forward();
                  globalScore = (state * (widget.level + 1));
                  return Text(
                    (state * (widget.level + 1)).toString(),
                    style: const TextStyle(
                        fontSize: 48,
                        color: Colour.fontEcru,
                        fontFamily: "Pixel-extra"),
                  );
                },
              )
            ]));
  }
}
