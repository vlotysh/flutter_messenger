import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';

class ContactsScreen extends StatefulWidget implements AppBarActions {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Firestore.instance
            .collection('users')
            .orderBy('username')
            .getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot));
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(doc["avatarUrl"]),
            ),
            title: new Text(doc["username"]),
            subtitle: new Text(doc["email"])))
        .toList();
  }
}
