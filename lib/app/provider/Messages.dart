import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';

import 'Message.dart';

class Messages extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages {
    return [..._messages];
  }

  void addMessage(Message message) {
    Message value = _messages.firstWhere((element) => element.id == message.id,
        orElse: () => null);

    if (value == null) {
      _messages.insert(0, message);
      notifyListeners();
    }
  }
}
