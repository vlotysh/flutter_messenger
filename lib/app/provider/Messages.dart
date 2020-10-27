import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';

import 'Message.dart';

class Messages extends ChangeNotifier {
  Map<String, Message> _messages = {};

  Map<String, Message> get messages {
    return {..._messages};
  }

  void addMessage(String key, Message message) {
    _messages.putIfAbsent(key, () => message);
    print(_messages.length);

    notifyListeners();
  }

  bool hasSelect() {
    _messages.forEach((key, value) {
      if (value.isSelected) {
        return true;
      }
    });

    return false;
  }
}
