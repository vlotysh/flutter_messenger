import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/widgets/chat/chat_screen.dart';
import 'package:messenger/app/widgets/chat/contacts_screen.dart';
import 'package:messenger/app/widgets/pages/app_bar_messages.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _title = 'Messages';

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
    final List<Map<String, Widget>> _children = [
      {
        'body': ChatsListScreen(),
        'appBar': AppBarMessages(),
      },
      {
        'body': ContactsScreen(),
        'appBar': null,
      },
    ];

    SelectProvider selectProvider = Provider.of<SelectProvider>(context);

    if (selectProvider.items.length > 0) {
      _title = 'Selected ${selectProvider.items.length}';
    }

    Map<String, Widget> tabWidget = _children[_currentIndex];
    List<Widget> appBarActions = [];

    if (tabWidget.containsKey('appBar') && tabWidget['appBar'] != null) {
      appBarActions.add(tabWidget['appBar']);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
        actions: appBarActions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Contacts'),
          ),
        ],
      ),
      body: tabWidget['body'],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Messages';
          }
          break;
        case 1:
          {
            _title = 'Contacts';
          }
          break;
      }
    });
  }
}
