import 'package:flutter/cupertino.dart';
import 'package:messenger/app/models/chat_user.dart';

class UserProvider extends ChangeNotifier {
  ChatUser _user;

  void setUser(ChatUser user) {
    _user = user;
    notifyListeners();
  }

  ChatUser getUser() {
    return _user;
  }
}
