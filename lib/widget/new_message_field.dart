import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageField extends StatefulWidget {
  @override
  _NewMessageFieldState createState() => _NewMessageFieldState();
}

class _NewMessageFieldState extends State<NewMessageField> {
  TextEditingController _controller = TextEditingController();
  var _newText = '';

  void _onSend() async {
    FocusScope.of(context).unfocus();
    var user = await FirebaseAuth.instance.currentUser();
    var userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _newText,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['userName'],
      'userImage': userData['imageUrl'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'send new message....',
              ),
              onChanged: (value) {
                setState(() {
                  _newText = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (_newText.trim().isEmpty) ? null : _onSend,
          ),
        ],
      ),
    );
  }
}
