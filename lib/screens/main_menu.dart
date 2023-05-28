import 'package:flutter/material.dart';
import 'level_selection.dart';
import 'scoreboard.dart';
import 'login.dart';
import '../model/config.dart';

class MainMenuScreen extends StatelessWidget {
  Config cfg;
  MainMenuScreen(
    this.cfg, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LevelSelection(cfg)));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("PLAY", style: TextStyle(fontSize: 48)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Scoreboard(cfg)));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("SCOREBOARD", style: TextStyle(fontSize: 48)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen(cfg)));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("LOGIN", style: TextStyle(fontSize: 48)),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
