import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/app/models/conversation.dart';

class ConversationService {
  void createConversation(List<String> participants, String id) {}

  void loadConversation(String id) {}

  Conversation _buildConversation(Map<String, dynamic> data) {
    return Conversation(
      conversationId: data['conversationId'],
      avatarUrl: data['avatarUrl'],
      name: data['name'],
      title: data['title'],
      participants: data['participants'],
    );
  }

  Future<Conversation> findById(String conversationId) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('conversationId', isEqualTo: conversationId)
        .getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      return await createDefaultConversation();
    }

    return _buildConversation(snapShot.documents.first.data);
  }

  Future<Conversation> findByUserId(String userId) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('participants', arrayContainsAny: [userId]).getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      return await createDefaultConversation();
    }

    return _buildConversation(snapShot.documents.first.data);
  }

  Future<Conversation> createDefaultConversation() async {
    String newId =
        Firestore.instance.collection('conversations').document().documentID;

    return Conversation(conversationId: newId);
  }

  Future<void> createOrUpdate(Map<String, dynamic> messageBody,
      List<dynamic> participants, Conversation conversation) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('conversationId', isEqualTo: conversation.conversationId)
        .getDocuments();
    print(participants);

    if (snapShot == null || snapShot.documents.length == 0) {
      conversation.participants = participants;
      conversation.avatarUrl = messageBody['avatarUrl'];
      conversation.title = messageBody['text'];
      conversation.name = messageBody['username'];

      await Firestore.instance
          .collection('conversations')
          .add(conversation.map);
    } else {
      DocumentSnapshot document = snapShot.documents.first;
      conversation = Conversation(
        participants: participants,
        avatarUrl: messageBody['avatarUrl'],
        conversationId: conversation.conversationId,
        title: messageBody['text'],
        name: messageBody['username'],
      );

      await Firestore.instance
          .collection('conversations')
          .document(document.documentID)
          .updateData(conversation.map);
    }

    return null;
  }
}
