import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:snake_game/screens/main_menu.dart';
import '../model/colours.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;
import 'level_selection.dart';

enum LoginState {
  success,
  fail;
}

class LoginScreen extends StatefulWidget {
  Config cfg;
  LoginScreen(
    this.cfg, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  String exception = '';
  bool newUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'username',
                hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                username = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () async {
                newUser = false;
                final loginState = await signInUser();
                if (loginState == LoginState.success) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => successWidget(context)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => tryAgainWidget(context)));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("LOGIN",
                    style: TextStyle(fontSize: 32, color: Colour.lightRed)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () async {
                newUser = true;
                final loginState = await signInUser();
                if (loginState == LoginState.success) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => successWidget(context)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => tryAgainWidget(context)));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("SIGN UP",
                    style: TextStyle(fontSize: 32, color: Colour.lightPurple)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width ~/ 3).toDouble(),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuScreen(widget.cfg)));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: const Text("GO BACK",
                    style: TextStyle(fontSize: 32, color: Colour.fontEcru)),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget successWidget(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          const Text(
            "GREAT! NOW YOU'RE READY TO PLAY",
            style: TextStyle(fontSize: 54, color: Colors.amber),
          ),
          Container(
              margin: const EdgeInsets.only(top: 40, bottom: 20),
              height: 70,
              width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LevelSelection(widget.cfg)));
                },
                child: const Text("PLAY",
                    style: TextStyle(fontSize: 36, color: Colour.aquaGreen)),
              )),
          Container(
              height: 70,
              width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainMenuScreen(widget.cfg)));
                },
                child: const Text("GO BACK", style: TextStyle(fontSize: 36)),
              )),
        ])));
  }

  Widget tryAgainWidget(BuildContext context) {
    String message = "LOGIN FAILURE";
    if (newUser) {
      message = "SIGN-UP FAILURE\nPLEASE CHOOSE A DIFFERENT USERNAME";
    }

    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Text(
            message,
            style: const TextStyle(fontSize: 32, color: Colour.orange),
          ),
          Container(
              margin: const EdgeInsets.all(40),
              height: 70,
              width: (MediaQuery.of(context).size.width ~/ 2.5).toDouble(),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("TRY AGAIN",
                    style: TextStyle(fontSize: 36, color: Colour.aquaGreen)),
              )),
        ])));
  }

  Future<LoginState> signInUser() async {
    if (username.isEmpty || password.isEmpty) {
      exception = "Both username and password must be non-empty";
      return LoginState.fail;
    }

    String urlEnd = "/auth/sign-in";
    if (newUser) {
      urlEnd = "/auth/sign-up";
    }

    final response = await http.post(Uri.parse(widget.cfg.url + urlEnd),
        body: jsonEncode({"username": username, "password": password}));

    if (response.statusCode == 200) {
      widget.cfg.token = jsonDecode(response.body)['token'];
      widget.cfg.username = username;
      return LoginState.success;
    }

    exception = response.body;
    return LoginState.fail;
  }
}
