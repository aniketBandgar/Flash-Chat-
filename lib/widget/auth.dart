import 'dart:io';
import 'package:flutter/material.dart';
import './image_picker.dart';

class AuthWidget extends StatefulWidget {
  final void Function(
    String email,
    String username,
    File image,
    String pass,
    bool isLogIn,
    BuildContext ctx,
  ) onSubAuthFn;

  final bool isLoading;

  AuthWidget(this.onSubAuthFn, this.isLoading);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  var _logIn = true;
  var _userEmail = '';
  var _userName = '';
  var _userPass = '';
  File _userImageFile;

  void _getPickedImageFile(File _pickedIamge) {
    setState(() {
      _userImageFile = _pickedIamge;
    });
  }

  void _trySubmit() {
    bool isValidate = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_logIn) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('please picked image'),
        ),
      );
      return;
    }

    if (isValidate) {
      _formKey.currentState.save();
      widget.onSubAuthFn(
        _userEmail.trim(),
        _userName.trim(),
        _userImageFile,
        _userPass.trim(),
        _logIn,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!_logIn) ImagePickerWidget(_getPickedImageFile),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (v) {
                    if (v.isEmpty || !v.contains('@')) {
                      return 'please enter valid email adress';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email adress',
                  ),
                  onSaved: (v) {
                    _userEmail = v;
                  },
                ),
                if (!_logIn)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (v) {
                      if (v.isEmpty || v.length < 4) {
                        return 'username at least contains 4 char';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'user name ',
                    ),
                    onSaved: (v) {
                      _userName = v;
                    },
                  ),
                TextFormField(
                  key: ValueKey('pass'),
                  validator: (v) {
                    if (v.isEmpty || v.length < 6) {
                      return 'passowrd contains at least 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'password',
                  ),
                  obscureText: true,
                  onSaved: (v) {
                    _userPass = v;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!widget.isLoading)
                  RaisedButton(
                    onPressed: _trySubmit,
                    child: Text(_logIn ? 'Log In' : 'Sign Up'),
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_logIn
                        ? 'Create New Account'
                        : 'i already have account'),
                    onPressed: () {
                      setState(() {
                        _logIn = !_logIn;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
