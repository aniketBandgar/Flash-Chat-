import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/a945qXQxMDCRsL10vgkD/message')
              .snapshots(),
          builder: (ctx, streamSnapShot) {
            if (streamSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final loadedData = streamSnapShot.data.documents;
            return ListView.builder(
              itemBuilder: (ctx, i) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(loadedData[i]['Text']),
                );
              },
              itemCount: loadedData.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance
              .collection('chats/a945qXQxMDCRsL10vgkD/message')
              .add({'Text': 'this is added due to pressing button'});
        },
      ),
    );
  }
}
