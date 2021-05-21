import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  void onSubmitAuth(
    String email,
    String username,
    File image,
    String pass,
    bool isLogIn,
    BuildContext ctx,
  ) async {
    AuthResult _authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogIn) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);

        final ref = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child(_authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'userName': username,
          'email': email,
          'imageUrl': url,
        });
      }
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink,
        child: Center(
          child: AuthWidget(onSubmitAuth, isLoading),
        ),
      ),
    );
  }
}
