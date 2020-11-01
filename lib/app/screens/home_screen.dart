import 'package:flutter/material.dart';
import 'package:messenger/app/widgets/chat/chat_screen.dart';
import 'package:messenger/app/widgets/chat/contacts_screen.dart';
import 'package:messenger/app/widgets/chat/settings_screen.dart';
import 'package:messenger/app/widgets/pages/app_bar_messages.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _title = 'Messages';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Widget>> _tabs = [
      {
        'body': ChatsListScreen(),
        'appBar': AppBarMessages(),
      },
      {
        'body': ContactsScreen(),
        'appBar': null,
      },
      {
        'body': SettingsScreen(),
        'appBar': null,
      },
    ];

    Map<String, Widget> tabWidget = _tabs[_currentIndex];
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
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text('Settings'),
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
