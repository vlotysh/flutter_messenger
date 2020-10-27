import 'package:flutter/material.dart';
import 'package:messenger/app/provider/Message.dart';

class SelectProvider extends ChangeNotifier {
  List<Message> _items = [];

  List<Message> get items {
    return [..._items];
  }

  bool isSelected(Message message) {
    return _items.contains(message);
  }

  void toggle(Message message) {
    if (!_items.contains(message)) {
      _items.add(message);
    } else {
      _items.remove(message);
    }

    notifyListeners();
  }
}
