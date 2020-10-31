import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';

class SettingsScreen extends StatefulWidget implements AppBarActions {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  FirebaseUser _user;
  String _userName;
  String _email;
  String _avatarUrl;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((FirebaseUser value) {
      Firestore.instance
          .collection('users')
          .document(value.uid)
          .get()
          .then((userData) {
        setState(() {
          _isLoading = false;
          _user = value;
          _userName = userData.data['username'];
          _email = userData.data['email'];
          _avatarUrl = userData.data['avatarUrl'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Text('Name ${_userName}'),
                  Text('Email ${_email}'),
                  Image.network(
                    _avatarUrl,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ));
  }
}
