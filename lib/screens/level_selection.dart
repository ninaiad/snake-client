import 'package:flutter/material.dart';
import 'package:snake_game/model/config.dart';
import '../model/colours.dart';
import 'game.dart';
import 'main_menu.dart';

const double width = 2.8;

class LevelSelection extends StatelessWidget {
  Config cfg;

  LevelSelection(
    this.cfg, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width ~/ 12).toDouble(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: const Text(
                "CHOOSE YOUR LEVEL:",
                style: TextStyle(fontSize: 48, color: Colour.yellow),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Game(cfg, 0)));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text("0. BABY", style: TextStyle(fontSize: 48)),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Game(cfg, 1)));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text("1. MID", style: TextStyle(fontSize: 48)),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Game(cfg, 2)));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child:
                      const Text("2. ADVANCED", style: TextStyle(fontSize: 48)),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Game(cfg, 3)));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child:
                      const Text("3. DEMIGOD", style: TextStyle(fontSize: 48)),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width ~/ width).toDouble(),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainMenuScreen(cfg)));
                },
                child: const Text("GO BACK", style: TextStyle(fontSize: 48)),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: const Text(
                "HOW TO MOVE:",
                style: TextStyle(fontSize: 48, color: Colour.orange),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                child: Expanded(
                    child: Image.asset('assets/images/how-to-move.jpg',
                        fit: BoxFit.contain))),
          ],
        ),
      ],
    )));
  }
}
