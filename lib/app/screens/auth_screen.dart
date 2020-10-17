import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/app/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isInProgress = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
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

      await Firestore.instance
          .collection('users')
          .document('${authResult.user.uid}')
          .setData({
        'username': username,
        'email': email,
      });

      setState(() {
        _isInProgress = false;
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
