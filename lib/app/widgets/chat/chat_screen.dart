import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/models/chat_user.dart';
import 'package:messenger/app/provider/UserProvider.dart';
import 'package:messenger/app/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class ChatsListScreen extends StatefulWidget implements AppBarActions {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    ChatUser user = Provider.of<UserProvider>(context, listen: false).getUser();

    return new FutureBuilder(
        future: Firestore.instance
            .collection('conversations')
            .where('participants', arrayContainsAny: [user.id]).getDocuments(),
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
