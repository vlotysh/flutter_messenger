import 'package:flutter/material.dart';
import 'package:messenger/app/models/conversation.dart' as models;

class ConversationProvider extends ChangeNotifier {
  models.Conversation _conversation;

  models.Conversation get conversation {
    return _conversation;
  }

  void setConversation(models.Conversation conversation) {
    _conversation = conversation;

    notifyListeners();
  }

  void clear() {
    _conversation = null;

    notifyListeners();
  }
}
