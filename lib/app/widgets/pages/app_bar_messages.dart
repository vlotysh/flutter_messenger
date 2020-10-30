import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarMessages extends StatefulWidget {
  @override
  _AppBarMessagesState createState() => _AppBarMessagesState();
}

class _AppBarMessagesState extends State<AppBarMessages> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        underline: Container(),
        icon: Icon(Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color),
        items: [
          DropdownMenuItem(
              value: 'logout',
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(height: 10),
                    Text('Logout')
                  ],
                ),
              ))
        ],
        onChanged: (itemIdentifier) {
          if (itemIdentifier == 'logout') {
            FirebaseAuth.instance.signOut();
          }
        });
  }
}
