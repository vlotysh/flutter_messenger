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
    );
  }
}
