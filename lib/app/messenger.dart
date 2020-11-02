import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/app/provider/ConversationProvider.dart';
import 'package:messenger/app/provider/Messages.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/provider/UserProvider.dart';
import 'package:messenger/app/screens/auth_screen.dart';
import 'package:messenger/app/screens/chat_screen.dart';
import 'package:messenger/app/screens/home_screen.dart';
import 'package:messenger/app/widgets/auth/splash_screen.dart';
import 'package:provider/provider.dart';

class Messenger extends StatefulWidget {
  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );

    fbm.getToken().then((value) => print(value));
//send it to back end for send specific device
    fbm.subscribeToTopic('chat'); //listen topic it can be user
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (Platform.isIOS) hideKeyboard(context);
        },
        child: MultiProvider(
          providers: [
            ListenableProvider<SelectProvider>(create: (_) => SelectProvider()),
            ListenableProvider<Messages>(create: (_) => Messages()),
            ListenableProvider<ConversationProvider>(
                create: (_) => ConversationProvider()),
            ListenableProvider<UserProvider>(create: (_) => UserProvider()),
          ],
          child: MaterialApp(
            title: 'Messenger',
            routes: {
              ChatScreen.routeName: (context) => ChatScreen(),
            },
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
