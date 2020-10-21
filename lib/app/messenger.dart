import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/app/screens/auth_screen.dart';
import 'package:messenger/app/screens/home_screen.dart';
import 'package:messenger/app/widgets/auth/splash_screen.dart';

class Messenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (Platform.isIOS) hideKeyboard(context);
        },
        child: MaterialApp(
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
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }

                if (userSnapshot.hasData) {
                  return HomeScreen();
                }

                return AuthScreen();
              }),
        ),
      );

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    FocusManager.instance.primaryFocus.unfocus();

    if (!currentFocus.hasPrimaryFocus) {
      //SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
