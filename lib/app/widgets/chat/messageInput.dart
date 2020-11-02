import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/models/conversation.dart';
import 'package:messenger/app/service/conversation_service.dart';

class MessageInput extends StatefulWidget {
  final Conversation conversation;
  final String userId;

  MessageInput({this.conversation, this.userId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  String _enteredMessage = '';

  void _sendMessage() async {
    //  FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Map<String, dynamic> messageBody = {
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'conversationId': widget.conversation.conversationId,
      'userId': user.uid,
      'avatarUrl': userData['avatarUrl'],
      'username': userData['username']
    };

    print(userData['avatarUrl']);
    Firestore.instance.collection('chat').add(messageBody);
    List<dynamic> participants = widget.conversation.participants;

    if (widget.userId != null) {
      participants = [user.uid, widget.userId];
    }

    ConversationService()
        .createOrUpdate(messageBody, participants, widget.conversation);

    setState(() {
      _enteredMessage = '';
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              onEditingComplete: () {
                if (_enteredMessage.trim().isNotEmpty) {
                  _enteredMessage = _controller.value.text;
                  _sendMessage();
                }
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
