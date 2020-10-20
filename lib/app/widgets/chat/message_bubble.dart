import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String avatarUrl;
  final Key key;

  MessageBubble(this.message, this.username, this.avatarUrl, this.isMe,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(overflow: Overflow.visible, children: [
      Row(
        mainAxisAlignment:
            this.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: this.isMe
                      ? Colors.grey[300]
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !this.isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        this.isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment: this.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: this.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline1
                                      .color)),
                    ],
                  ),
                  Text(message,
                      style: TextStyle(
                          color: this.isMe
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
          left: this.isMe ? null : 130,
          right: this.isMe ? 130 : null,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
          )),
    ]);
  }
}
