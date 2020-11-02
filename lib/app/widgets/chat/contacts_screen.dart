import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/models/chat_user.dart';
import 'package:messenger/app/provider/UserProvider.dart';
import 'package:messenger/app/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget implements AppBarActions {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    ChatUser currentUser = Provider.of<UserProvider>(context).getUser();
    return FutureBuilder(
        future: Firestore.instance
            .collection('users')
            .orderBy('username')
            .getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              itemCount: snapshot.data.documents.length - 1,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data.documents[index];

                return getContactItem(document, currentUser);
              });
        });
  }

  Widget getContactItem(DocumentSnapshot document, ChatUser currentUser) {
    return Opacity(
      opacity: currentUser.id == document.documentID ? .5 : 1,
      child: ListTile(
          onTap: () {
            if (currentUser.id == document.documentID) {
              return;
            }
            Navigator.pushNamed(context, ChatScreen.routeName,
                arguments: {'userId': document.documentID});
          },
          leading: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(document["avatarUrl"]),
          ),
          title: new Text(document["username"]),
          subtitle: new Text(document["email"])),
    );
  }
}
