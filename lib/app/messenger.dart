import 'package:flutter/material.dart';
import 'package:messenger/app/screens/home_screen.dart';

class Messenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Messenger',
        theme:
            ThemeData(primarySwatch: Colors.yellow, accentColor: Colors.blue),
        home: HomeScreen(),
      );
}
