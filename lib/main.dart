import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'cubit/score_cubit.dart';
import 'model/active_direction.dart';
import 'model/colours.dart';
import 'screens/main_menu.dart';
import 'model/config.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rootBundle
      .loadString('assets/config.yaml')
      .then(((yamlString) => runApp(MyApp(loadYaml(yamlString)))));
}

class MyApp extends StatelessWidget {
  final dynamic parsedYaml;
  const MyApp(this.parsedYaml, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoreCubit(),
      child: Provider<ActiveDirection>(
        create: (_) => ActiveDirection(),
        child: MaterialApp(
          title: 'Snake game',
          theme: ThemeData(
            backgroundColor: Colour.charcoal,
            scaffoldBackgroundColor: Colour.charcoal,
            primaryColor: Colour.lightPurple,
            fontFamily: 'Pixel-basic',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colour.darkGrey,
                  foregroundColor: Colour.fontEcru,
                  textStyle: const TextStyle(
                      color: Colour.fontEcru, fontFamily: 'Pixel-basic'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SafeArea(
            child: MainMenuScreen(Config(parsedYaml['SERVER_URL'])),
          ),
        ),
      ),
    );
  }
}
