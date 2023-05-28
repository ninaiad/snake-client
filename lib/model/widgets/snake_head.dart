import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/model/colours.dart';
import '../active_direction.dart';

class SnakeHead extends StatefulWidget {
  const SnakeHead({
    Key? key,
    required this.width,
  }) : super(key: key);

  final int width;

  @override
  SnakeHeadState createState() => SnakeHeadState();
}

class SnakeHeadState extends State<SnakeHead>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    controller.addListener(() {
      setState(() {});
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
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        color: Colors.black,
        padding: EdgeInsets.all(widget.width / 2 - 1),
        margin: const EdgeInsets.all(1),
      ),
      drawWithDirection(Provider.of<ActiveDirection>(context).direction)
    ]);
  }

  Widget drawWithDirection(Direction direction) {
    double padding = (widget.width / 2 - 1) * controller.value;
    double margin = widget.width / 2 - padding;
    switch (direction) {
      case Direction.up:
        return Container(
          color: Colour.greenSnakeHead,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            padding,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            margin,
            1,
            1,
          ),
        );
      case Direction.down:
        return Container(
          color: Colour.greenSnakeHead,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            padding,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            1,
            1,
            margin,
          ),
        );
      case Direction.right:
        return Container(
          color: Colour.greenSnakeHead,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            padding,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            1,
            margin,
            1,
          ),
        );
      case Direction.left:
      // default:
        return Container(
          color: Colour.greenSnakeHead,
          padding: EdgeInsets.fromLTRB(
            padding,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            margin,
            1,
            1,
            1,
          ),
        );
    }
  }
}
