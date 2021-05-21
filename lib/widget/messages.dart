import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapShot) {
        if (futureSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapShot) {
              if (chatSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatData = chatSnapShot.data.documents;
              return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, i) {
                  return MessageBubble(
                    chatData[i]['text'],
                    chatData[i]['userId'] == futureSnapShot.data.uid,
                    chatData[i]['username'],
                    chatData[i]['userImage'],
                    key: ValueKey(chatData[i].documentID),
                  );
                },
                itemCount: chatData.length,
              );
            });
      },
    );
  }
}
