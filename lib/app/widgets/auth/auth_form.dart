import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/app/widgets/auth/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isInProgress);

  bool isInProgress;
  final void Function(String email, String password, String username,
      File _userImage, bool isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthMod { LOGIN, REGISTER }

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  File _userImage;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // hide soft keyboard

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Plase pick an image'),
          backgroundColor: Theme.of(context).errorColor));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImage, _isLogin, context);
      // send request
    }
  }

  void _setUserImage(File userImage) {
    _userImage = userImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_setUserImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter valid email';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid username';
                        }

                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please enter password with more then 7 symbols';
                      }

                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isInProgress
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: _trySubmit,
                        ),
                  FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
