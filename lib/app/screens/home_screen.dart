import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/mwwwLkqAAIL6rb6cqD0V/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = streamSnapshot.data.documents;
          return ListView.builder(
              itemBuilder: (ctx, index) {
                return Container(
                  child: Text(documents[index]['text']),
                  padding: EdgeInsets.all(8),
                );
              },
              itemCount: documents.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/mwwwLkqAAIL6rb6cqD0V/messages')
              .add({'text': 'New message!'});
        },
      ),
    );
  }
}
