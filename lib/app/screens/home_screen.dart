import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              child: Text('$index'),
              padding: EdgeInsets.all(8),
            );
          },
          itemCount: 10),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/mwwwLkqAAIL6rb6cqD0V/messages')
              .snapshots()
              .listen((data) {
            print(data.documents[0].data);
          });
        },
      ),
    );
  }
}
