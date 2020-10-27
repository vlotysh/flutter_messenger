import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';
import 'package:messenger/app/provider/Messages.dart' as provider;
import 'package:messenger/app/widgets/chat/message_bubble.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      provider.Messages messages =
          Provider.of<provider.Messages>(context, listen: false);

      FirebaseAuth.instance.currentUser().then((FirebaseUser value) {
        Firestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen((streamSnapshot) {
          final chatDocs = streamSnapshot.documents;

          for (int i = 0; i < chatDocs.length; i++) {
            print(chatDocs[i]['text']);
            messages.addMessage(
                chatDocs[i].documentID,
                Message(
                  id: chatDocs[i].documentID,
                  text: chatDocs[i]['text'],
                  username: chatDocs[i]['username'],
                  avatarUrl: chatDocs[i]['avatarUrl'],
                  isMe: chatDocs[i]['userId'] == value.uid,
                  isSelected: false,
                ));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.Messages>(
      builder: (context, provider.Messages messages, child) {
        Map<String, Message> messagesMap = messages.messages;
        var keys = messagesMap.keys.toList();

        return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                // DO NOT USER ChangeNotifierProvider -> builder for grid or list
                value: messagesMap[keys[index]],
                child:
                    MessageBubble(key: ValueKey(messagesMap[keys[index]].id))),
            itemCount: messagesMap.length);
      },
      // Build the expensive widget here.
    );
  }
}
