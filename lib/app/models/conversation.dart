import 'package:flutter/cupertino.dart';

class Conversation {
  final String pk;
  final String conversationId;
  List<dynamic> participants;
  String title;
  String name;
  String avatarUrl;

  Conversation(
      {this.pk,
      @required this.conversationId,
      this.participants,
      this.title,
      this.name,
      this.avatarUrl});

  Map<String, dynamic> get map {
    return {
      'conversationId': conversationId,
      'participants': participants,
      'title': title,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}
