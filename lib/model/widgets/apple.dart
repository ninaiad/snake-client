import 'package:flutter/material.dart';
import '../colours.dart';

class Apple extends StatefulWidget {
  const Apple({
    Key? key,
    required this.width,
  }) : super(key: key);

  final int width;

  @override
  AppleState createState() => AppleState();
}

class AppleState extends State<Apple> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
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
      color: Colour.greenApple,
      padding: EdgeInsets.all((widget.width / 2) * (1 - controller.value)),
      margin: EdgeInsets.all((widget.width / 2) * controller.value),
    );
  }
}
