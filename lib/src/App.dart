import 'package:flutter/material.dart';
import 'package:news/src/ui/NavigationScreen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/NavigationScreen': (context) => NavigationScreen(),
    }, theme: ThemeData.light(), home: NavigationScreen());
  }
}
