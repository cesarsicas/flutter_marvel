import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/characters_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
      ),
      home: CharactersScreen(),
    );
  }
}