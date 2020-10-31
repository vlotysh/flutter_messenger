import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Key key;

  MessageBubble({this.key});

  void toggleSelected(context, Message message) {
    Provider.of<SelectProvider>(context, listen: false).toggle(message);
  }

  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider = Provider.of<SelectProvider>(context);
    List<Message> selectedItems = selectProvider.items;
    Message message = Provider.of<Message>(context);
    bool isSelected = selectProvider.isSelected(message);

    return GestureDetector(
      onLongPress: () {
        if (selectedItems.length == 0) {
          toggleSelected(context, message);
        }
      },
      onTap: () {
        if (selectedItems.length > 0) {
          selectProvider.toggle(message);
        }
      },
      child: Stack(overflow: Overflow.visible, children: [
        Column(
          children: [
            Container(
              color: isSelected ? Colors.tealAccent[200] : null,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: message.isMe
                                ? Colors.grey[300]
                                : Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: !message.isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                              bottomRight: message.isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                            )),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        margin: message.isMe
                            ? EdgeInsets.only(left: 100, top: 15, bottom: 8)
                            : EdgeInsets.only(
                                right: 100, left: 35, top: 15, bottom: 8),
                        child: Column(
                          crossAxisAlignment: message.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: message.isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Text(message.username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: message.isMe
                                            ? Colors.black
                                            : Theme.of(context)
                                                .accentTextTheme
                                                .headline1
                                                .color)),
                              ],
                            ),
                            Text(message.text,
                                style: TextStyle(
                                    color: message.isMe
                                        ? Colors.black
                                        : Theme.of(context)
                                            .accentTextTheme
                                            .headline1
                                            .color)),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!message.isMe)
          Positioned(
              left: 0,
              bottom: 10,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.avatarUrl),
              )),
      ]),
    );
  }
}
