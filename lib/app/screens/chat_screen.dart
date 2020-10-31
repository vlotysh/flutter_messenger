import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/widgets/chat/messageInput.dart';
import 'package:messenger/app/widgets/chat/messages.dart';
import 'package:messenger/app/widgets/pages/app_bar_messages.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget implements AppBarActions {
  static const routeName = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();

  static Widget getAppBar() {
    return AppBarMessages();
  }
}

class _ChatScreenState extends State<ChatScreen> {
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
  Widget build(BuildContext context) {
    SelectProvider selectProvider = Provider.of<SelectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
            child: selectProvider.items.length > 0
                ? Text('Selected ${selectProvider.items.length}')
                : Text('Chat')),
        actions: [
          DropdownButton(
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
              })
        ],
      ),
      body: Container(
          child: Column(
        children: [Expanded(child: Messages()), MessageInput()],
      )),
    );
  }
}
