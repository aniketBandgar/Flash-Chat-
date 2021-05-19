import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/auth/auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  void onSubmitAuth(
    String email,
    String username,
    String pass,
    bool isLogIn,
    BuildContext ctx,
  ) async {
    AuthResult _authResult;
    try {
      if (isLogIn) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
      }
    } on PlatformException catch (e) {
      var message = 'an error occured please check ur credential';

      if (e.message != null) {
        message = e.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink,
        child: Center(
          child: AuthWidget(onSubmitAuth),
        ),
      ),
    );
  }
}
