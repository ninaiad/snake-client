import 'package:flutter/material.dart';
import 'package:snake_game/model/colours.dart';

class Obstacle extends StatefulWidget {
  const Obstacle({
    Key? key,
    required this.width,
  }) : super(key: key);

  final int width;

  @override
  ObstacleState createState() => ObstacleState();
}

class ObstacleState extends State<Obstacle>
  with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colour.redObstacle,
      padding: EdgeInsets.all((widget.width / 2) * (1 - controller.value)),
      margin: EdgeInsets.all((widget.width / 2) * controller.value),
    );
  }
}
