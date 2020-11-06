import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/models/chat_user.dart';
import 'package:messenger/app/provider/UserProvider.dart';
import 'package:messenger/app/widgets/chat/chat_screen.dart';
import 'package:messenger/app/widgets/chat/contacts_screen.dart';
import 'package:messenger/app/widgets/chat/settings_screen.dart';
import 'package:messenger/app/widgets/pages/app_bar_messages.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isInitialized = false;
  String _title = 'Messages';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized == true) {
      return;
    }

    FirebaseAuth.instance.currentUser().then((currentFbUser) {
      Firestore.instance
          .collection('users')
          .document(currentFbUser.uid)
          .get()
          .then((userInfo) {
        Provider.of<UserProvider>(context, listen: false).setUser(ChatUser(
            id: currentFbUser.uid,
            username: userInfo.data['username'],
            email: userInfo.data['email'],
            avatarUrl: userInfo.data['avatarUrl']));

        setState(() {
          _isInitialized = true;
        });
      });
    });
    // TODO: implement didChangeDependencies
  }

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
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Contact screen',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _isInitialized
          ? tabWidget['body']
          : Center(child: CircularProgressIndicator()),
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
