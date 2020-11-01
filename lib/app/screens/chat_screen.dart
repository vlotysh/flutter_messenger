import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/interfaces/appBarActions.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider = Provider.of<SelectProvider>(context);
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
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

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Provider.of<SelectProvider>(context, listen: false).clean();
              Navigator.of(context).pop();
            },
          ),
          title: Center(
              child: selectProvider.items.length > 0
                  ? Text('Selected ${selectProvider.items.length}')
                  : Text('Chat')),
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
        body: Container(
          child: FutureBuilder(
              future: loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                print(snapshot.data.conversationId);

                return Column(
                  children: [
                    Expanded(child: Messages(conversation: snapshot.data)),
                    MessageInput(conversation: snapshot.data, userId: userId)
                  ],
                );
              }),
        ));
  }
}
