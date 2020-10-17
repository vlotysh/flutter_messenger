import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/screens/auth_screen.dart';
import 'package:messenger/app/screens/home_screen.dart';

class Messenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Messenger',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.deepPurple,
            backgroundColor: Colors.pink,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (cxt, userSnapshot) {
              if (userSnapshot.hasData) {
                return HomeScreen();
              }

              return AuthScreen();
            }),
      );
}
