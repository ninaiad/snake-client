import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../model/colours.dart';
import '../model/config.dart';
import 'main_menu.dart';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final num score;

  const User({
    required this.username,
    required this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      score: json['score'],
    );
  }
}

class Pair {
  final dynamic left;
  final dynamic right;
  Pair(this.left, this.right);
}

class Scoreboard extends StatefulWidget {
  Config cfg;
  Scoreboard(
    this.cfg, {
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ScoreBoardState();
  }
}

class ScoreBoardState extends State<Scoreboard> {
  late Future<List<User>> futureUsers;

  ScoreBoardState();

  @override
  Widget build(BuildContext context) {
    if (widget.cfg.token.isEmpty) {
      return loggedOutScreen(context);
    }

    futureUsers = fetchUsers(widget.cfg);
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
            child: Container(
                margin: const EdgeInsets.only(top: 60, bottom: 20),
                child: const Text(
                  'TOP SCORES',
                  style: TextStyle(fontSize: 64, color: Colour.lightGreen),
                ))),
        FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var topTenUsers = getTopTen(snapshot.data!);
              return Container(
                  height:
                      (MediaQuery.of(context).size.height ~/ 1.5).toDouble(),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          width: (MediaQuery.of(context).size.width ~/ 3)
                              .toDouble(),
                          child: Table(
                            border: TableBorder.symmetric(
                                inside: const BorderSide(
                                    color: Colour.yellow, width: 3.0),
                                outside: BorderSide.none),
                            children: [
                              for (Pair pair in topTenUsers)
                                TableRow(children: [
                                  Container(
                                    margin: const EdgeInsets.all(14),
                                    child: Text(
                                      "${pair.left.toString()}. ${pair.right.username}",
                                      style: TextStyle(
                                          fontSize: 28,
                                          color:
                                              chooseColor(pair.right.username)),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.all(14),
                                      child: Text(pair.right.score.toString(),
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: chooseColor(
                                                  pair.right.username))))
                                ])
                            ],
                          ))));
            } else if (snapshot.hasError) {
              return Container(
                  margin: const EdgeInsets.all(20),
                  child: Text('${snapshot.error}',
                      style: const TextStyle(
                          fontSize: 48, color: Colour.ligthBlue)));
            }

            return const CircularProgressIndicator();
          },
        ),
        Container(
          width: (MediaQuery.of(context).size.width ~/ 5).toDouble(),
          margin: const EdgeInsets.all(10),
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainMenuScreen(widget.cfg)));
            },
            child: const Text("GO BACK", style: TextStyle(fontSize: 32)),
          ),
        ),
      ]),
    );
  }

  Widget loggedOutScreen(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          const Text(
            "TO ACCESS THE SCOREBOARD YOU MUST LOG IN FIRST",
            style: TextStyle(fontSize: 40, color: Colour.yellow),
          ),
          Container(
            width: (MediaQuery.of(context).size.width ~/ 5).toDouble(),
            margin: const EdgeInsets.all(20),
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuScreen(widget.cfg)));
              },
              child: const Text("GO BACK", style: TextStyle(fontSize: 32)),
            ),
          ),
        ])));
  }

  Future<List<User>> fetchUsers(Config cfg) async {
    final response = await http.get(Uri.parse("${cfg.url}/scores/"),
        headers: {HttpHeaders.authorizationHeader: "Bearer ${cfg.token}"});

    if (response.statusCode == 200) {
      return makeUsersList(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  List<User> makeUsersList(List<dynamic> jsons) {
    return List.of(jsons.map((json) => User.fromJson(json)));
  }

  List<Pair> getTopTen(List<User> all) {
    all.sort((lhs, rhs) => rhs.score.compareTo(lhs.score));
    List<Pair> result =
        List.generate(all.length, (index) => Pair(index + 1, all[index]));
    if (result.length < 11) {
      return result;
    }

    if (result
        .sublist(0, 10)
        .firstWhere((element) => element.right.username == widget.cfg.username,
            orElse: () => Pair(0, const User(score: 0, username: '')))
        .right
        .username
        .isEmpty) {
      result[9] =
          result.firstWhere((e) => e.right.username == widget.cfg.username);
    }

    return result.sublist(0, 10);
  }

  Color chooseColor(String username) {
    if (username == widget.cfg.username) {
      return Colour.orange;
    }

    return Colour.fontEcru;
  }
}
