import 'package:flutter/material.dart';

class SnakeTail extends StatefulWidget {
  const SnakeTail({
    Key? key,
    required this.width,
  }) : super(key: key);

  final int width;

  @override
  SnakeTailState createState() => SnakeTailState();
}

class SnakeTailState extends State<SnakeTail>
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
    return Stack(
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.all(widget.width / 2 - 1),
          margin: const EdgeInsets.all(1),
        ),
        Container(
          color: const Color(0xFF43D08C).withOpacity(1 - controller.value),
          padding: EdgeInsets.all(widget.width / 2 - 1),
          margin: const EdgeInsets.all(1),
        ),
      ],
    );
  }
}
