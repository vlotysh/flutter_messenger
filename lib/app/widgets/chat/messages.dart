import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/widgets/chat/message_bubble.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider = Provider.of<SelectProvider>(context);
    List<String> selectedItems = selectProvider.items;
    print(111);
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapshot) => StreamBuilder(
        stream: Firestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final chatDocs = streamSnapshot.data.documents;
          return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                    chatDocs[index].documentID,
                    chatDocs[index]['text'],
                    chatDocs[index]['username'],
                    chatDocs[index]['avatarUrl'],
                    chatDocs[index]['userId'] == snapshot.data.uid,
                    selectMode: selectedItems.length > 0,
                    isSelected:
                        selectedItems.contains(chatDocs[index].documentID),
                    key: ValueKey(chatDocs[index].documentID));
              },
              itemCount: chatDocs.length);
        },
      ),
    );
  }
}
