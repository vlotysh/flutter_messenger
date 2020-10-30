import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/widgets/chat/messageInput.dart';
import 'package:messenger/app/widgets/chat/messages.dart';

class ChatsListScreen extends StatefulWidget implements AppBarActions {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [Expanded(child: Messages()), MessageInput()],
    ));
  }
}
