import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/screens/chat_screen.dart';

class ContactsScreen extends StatefulWidget implements AppBarActions {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          FirebaseUser currentUser = userSnapshot.data;

          return FutureBuilder(
              future: Firestore.instance
                  .collection('users')
                  .orderBy('username')
                  .getDocuments(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];

                      if (document.documentID != currentUser.uid) {
                        return getContactItem(document);
                      } else {
                        return null;
                      }
                    });
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ListTile getContactItem(DocumentSnapshot document) {
    return ListTile(
        onTap: () {
          Navigator.pushNamed(context, ChatScreen.routeName,
              arguments: {'userId': document.documentID});
        },
        leading: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(document["avatarUrl"]),
        ),
        title: new Text(document["username"]),
        subtitle: new Text(document["email"]));
  }
}
