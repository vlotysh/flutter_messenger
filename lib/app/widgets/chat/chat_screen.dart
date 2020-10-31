import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/screens/chat_screen.dart';

class ChatsListScreen extends StatefulWidget implements AppBarActions {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Firestore.instance.collection('conversations').getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(children: getContactItem(snapshot));
        });
  }

  getContactItem(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      return ListTile(
          key: ValueKey(doc.documentID),
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.routeName,
                arguments: {'conversationId': doc.data['conversationId']});
          },
          title: new Text(doc["title"]));
    }).toList();
  }
}
