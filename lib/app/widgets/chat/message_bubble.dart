import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Key key;

  MessageBubble({this.key});

  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider =
        Provider.of<SelectProvider>(context, listen: false);

    Message message = Provider.of<Message>(context, listen: false);

    return GestureDetector(
      onLongPress: () {},
      child: Stack(overflow: Overflow.visible, children: [
        Row(
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Checkbox(
              value: message.isSelected ? true : false,
              onChanged: (_) {
                message.toggleSelect();
              },
            ),
            Container(
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
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
          ],
        ),
        Positioned(
            top: 0,
            left: message.isMe ? null : 130,
            right: message.isMe ? 130 : null,
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message.avatarUrl),
            )),
      ]),
    );
  }
}
