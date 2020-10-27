import 'package:flutter/material.dart';

class Message extends ChangeNotifier {
  final String id;
  final String text;
  final String username;
  final String avatarUrl;
  final bool isMe;
  bool isSelected = false;

  Message(
      {this.id,
      this.text,
      this.username,
      this.avatarUrl,
      this.isMe,
      this.isSelected});

  void toggleSelect() {
    isSelected = !isSelected;

    notifyListeners();
  }
}
