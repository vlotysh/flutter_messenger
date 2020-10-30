import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';

class ContactsScreen extends StatefulWidget implements AppBarActions {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('contacts'));
  }
}
