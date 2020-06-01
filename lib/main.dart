import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nix Messenger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.black,
            appBarTheme: AppBarTheme(
                color: Colors.black,
                centerTitle: false,
                elevation: 0,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: Colors.white),
                actionsIconTheme: IconThemeData(color: Colors.white))),
        home: HomeScreen());
  }
}
