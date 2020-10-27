import 'package:flutter/material.dart';

class SelectProvider extends ChangeNotifier {
  List<String> _itemsId = [];

  List<String> get items {
    return [..._itemsId];
  }

  bool isSelected(String messageId) {
    return _itemsId.contains(messageId);
  }

  toggleSelect(String messageId) {
    print(messageId);
    int index = _itemsId.indexOf(messageId);
    index > -1 ? _itemsId.removeAt(index) : _itemsId.add(messageId);

    notifyListeners();
  }
}
