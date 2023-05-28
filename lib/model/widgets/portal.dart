import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:snake_game/model/colours.dart';

class Portal extends StatefulWidget {
  const Portal({
    Key? key,
    required this.width,
  }) : super(key: key);

  final int width;

  @override
  PortalState createState() => PortalState();
}

class PortalState extends State<Portal> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    controller1.addListener(() {
      setState(() {});
    });

    controller1.repeat();
    controller2.forward();
    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller2.forward();
      }
    });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi * controller1.value,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          color: Colour.darkpurplePortal,
          padding: EdgeInsets.all(2 * widget.width / 5 -
              controller2.value * (1 * widget.width / 10)),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            color: Colour.purplePortal,
            padding: EdgeInsets.all(2 * widget.width / 5 -
                controller2.value * (1 * widget.width / 5)),
          ),
        ),
      ]),
    );
  }
}
