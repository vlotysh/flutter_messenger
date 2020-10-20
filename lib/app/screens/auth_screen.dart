import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/app/widgets/auth/auth_form.dart';
import 'package:path/path.dart' as Path;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isInProgress = false;

  void _submitAuthForm(String email, String password, String username,
      File _userImage, bool isLogin, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isInProgress = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('avatars/${Path.basename(_userImage.path)}');

      StorageUploadTask uploadTask = storageReference.putFile(_userImage);
      await uploadTask.onComplete;

      var url = await storageReference.getDownloadURL();

      await Firestore.instance
          .collection('users')
          .document('${authResult.user.uid}')
          .setData({
        'username': username,
        'email': email,
        'url': url,
      });
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: Theme.of(ctx).errorColor));
      setState(() {
        _isInProgress = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isInProgress = false;
      });
    }

    // FirebaseAuth.instance.onAuthStateChanged.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isInProgress),
    );
  }
}
