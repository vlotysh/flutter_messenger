import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
import 'package:messenger/app/models/conversation.dart';
import 'package:messenger/app/provider/ConversationProvider.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:messenger/app/service/conversation_service.dart';
import 'package:messenger/app/widgets/chat/messageInput.dart';
import 'package:messenger/app/widgets/chat/messages.dart';
import 'package:messenger/app/widgets/pages/app_bar_messages.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget implements AppBarActions {
  static const routeName = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();

  static Widget getAppBar() {
    return AppBarMessages();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    ConversationProvider conversationProvider =
        Provider.of<ConversationProvider>(context, listen: false);

    if (conversationProvider.conversation != null) {
      return;
    }

    Future.delayed(Duration.zero, () {
      Map<String, dynamic> arguments =
          ModalRoute.of(context).settings.arguments;
      String userId =
          arguments.containsKey('userId') ? arguments['userId'] : null;
      String conversationId = arguments.containsKey('conversationId')
          ? arguments['conversationId']
          : null;

      Future loadFuture;

      if (conversationId != null) {
        loadFuture = ConversationService().findById(conversationId);
      } else {
        loadFuture = ConversationService().findByUserId(userId);
      }

      loadFuture.then((conversation) {
        Provider.of<ConversationProvider>(context, listen: false)
            .setConversation(conversation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider = Provider.of<SelectProvider>(context);

    const String title = 'User name';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Provider.of<SelectProvider>(context, listen: false).clean();
            Provider.of<ConversationProvider>(context, listen: false).clear();
            Navigator.of(context).pop();
          },
        ),
        title: Center(
            child: selectProvider.items.length > 0
                ? Text('Selected ${selectProvider.items.length}')
                : Text(title)),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color),
              items: [
                DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(height: 10),
                          Text('Logout')
                        ],
                      ),
                    ))
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Consumer<ConversationProvider>(
        builder: (context, ConversationProvider conversationProvider, child) {
          Conversation conversation = conversationProvider.conversation;

          if (conversation == null) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> arguments =
              ModalRoute.of(context).settings.arguments;
          String userId =
              arguments.containsKey('userId') ? arguments['userId'] : null;

          return Column(
            children: [
              Expanded(child: Messages(conversation: conversation)),
              MessageInput(conversation: conversation, userId: userId)
            ],
          );
        },
        // Build the expensive widget here.
      ),
    );
  }
}
