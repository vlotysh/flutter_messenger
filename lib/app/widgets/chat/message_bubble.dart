import 'package:flutter/material.dart';
import 'package:messenger/app/provider/SelectProvider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final String id;
  final String message;
  final bool isMe;
  final String username;
  final String avatarUrl;
  final bool selectMode;
  final bool isSelected;
  final Key key;

  MessageBubble(this.id, this.message, this.username, this.avatarUrl, this.isMe,
      {this.key, this.selectMode = false, this.isSelected = null});

  @override
  Widget build(BuildContext context) {
    SelectProvider selectProvider =
        Provider.of<SelectProvider>(context, listen: false);

    return GestureDetector(
      onLongPress: () {
        if (!selectMode) {
          print('Long press');
          selectProvider.toggleSelect(id);
        }
      },
      child: Stack(overflow: Overflow.visible, children: [
        Row(
          mainAxisAlignment:
              this.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Radio(
              value: id,
              groupValue: isSelected,
              onChanged: (id) {
                selectProvider.toggleSelect(id);
              },
            ),
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
      ]),
    );
  }
}
