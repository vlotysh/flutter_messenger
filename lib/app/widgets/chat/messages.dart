import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/models/conversation.dart';
import 'package:messenger/app/provider/Message.dart';
import 'package:messenger/app/provider/Messages.dart' as provider;
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/widgets/chat/message_bubble.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final Conversation conversation;

  Messages({this.conversation});

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
      SelectProvider selectProvider =
          Provider.of<SelectProvider>(context, listen: false);

      messages.clear(isGlobal: true);

      FirebaseAuth.instance.currentUser().then((FirebaseUser value) {
        Firestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .where('conversationId',
                isEqualTo: widget.conversation.conversationId)
            .snapshots()
            .listen((streamSnapshot) {
          final chatDocs = streamSnapshot.documents;

          for (int i = 0; i < chatDocs.length; i++) {
            messages.addMessage(Message(
              id: chatDocs[i].documentID,
              text: chatDocs[i]['text'],
              username: chatDocs[i]['username'],
              avatarUrl: chatDocs[i]['avatarUrl'],
              isMe: chatDocs[i]['userId'] == value.uid,
              isSelected: selectProvider.isSelected(chatDocs[i].documentID),
            ));
          }
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<provider.Messages>(
      builder: (context, provider.Messages messages, child) {
        List<Message> messagesList = messages.messages;

        return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                // DO NOT USER ChangeNotifierProvider -> builder for grid or list
                value: messagesList[index],
                child: MessageBubble(key: ValueKey(messagesList[index].id))),
            itemCount: messagesList.length);
      },
      // Build the expensive widget here.
    );
  }
}
