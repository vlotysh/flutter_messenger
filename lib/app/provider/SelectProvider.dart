import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';

class SelectProvider extends ChangeNotifier {
  List<Message> _items = [];

  List<Message> get items {
    return [..._items];
  }

  bool isSelected(String messageId) {
    Message selectedMessage = _items.firstWhere(
        (Message element) => element.id == messageId,
        orElse: () {});

    return selectedMessage != null;
  }

  Message findById(String messageId) {
    return _items.firstWhere((Message element) => element.id == messageId,
        orElse: () {});
  }

  void toggle(Message message) {
    if (findById(message.id) == null) {
      _items.add(message);
    } else {
      _items.removeWhere((Message element) => element.id == message.id);
    }

    notifyListeners();
  }

  void clean() {
    _items = [];

    notifyListeners();
  }
}
