import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/app/models/conversation.dart';

class ConversationService {
  void createConversation(List<String> participants, String id) {}

  void loadConversation(String id) {}

  Future<Conversation> findById(String conversationId) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('conversationId', isEqualTo: conversationId)
        .getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      return await createDefaultConversation();
    }

    DocumentSnapshot document = snapShot.documents.first;

    return Conversation(conversationId: document.documentID);
  }

  Future<Conversation> findByUserId(String userId) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('participants', arrayContainsAny: [userId]).getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      return await createDefaultConversation();
    }

    DocumentSnapshot document = snapShot.documents.first;

    return Conversation(
        conversationId: document.documentID); // snapShot.documents.first.data;
  }

  Future<Conversation> createDefaultConversation() async {
    String newId =
        Firestore.instance.collection('conversations').document().documentID;

    return Conversation(conversationId: newId);
  }

  Future<void> createOrUpdate(Map<String, dynamic> messageBody,
      List<String> participants, Conversation conversation) async {
    final snapShot = await Firestore.instance
        .collection('conversations')
        .where('conversationId', isEqualTo: conversation.conversationId)
        .getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      conversation.participants = participants;
      conversation.avatarUrl = messageBody['avatarUrl'];
      conversation.title = messageBody['text'];
      conversation.name = messageBody['username'];

      print('CREATE!!!!');
      await Firestore.instance
          .collection('conversations')
          .add(conversation.map);
    } else {
      DocumentSnapshot document = snapShot.documents.first;
      print('UPDATE!!!!');
      conversation = Conversation(
        conversationId: document.documentID,
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
