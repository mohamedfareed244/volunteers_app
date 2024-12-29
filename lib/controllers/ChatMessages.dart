import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/views/userchat.dart';


//building entire chat messages 
Widget buildMessage(BuildContext context, String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const  EdgeInsets.only(top: 8, bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7, // Set maximum width
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style:const  TextStyle(color: Colors.black),
        ),
      ),
    );
  }


Stream<List<Widget>> getChatMessages(BuildContext context, String id) {
  // Get Firestore connection
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef =
      connection.collection('chats').doc(id).collection('messages');

  // Stream the data and build widgets dynamically
  return collectionRef.orderBy('date',descending: false).snapshots().map((querysnapshot) {
    // Create a **new list** for every snapshot to avoid duplicates
    List<Widget> chatList = [];

    for (var doc in querysnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      // Build a new message widget for each document
      chatList.add(buildMessage(context, data['text'], data['fromuser']));
    }

    // Return the new list
    return chatList;
  });
}

Future<void> sendMessage(String message,String chatid,usertypes usertype) async{
  //get the required collection
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef =connection.collection('chats').doc(chatid).collection('messages');
  //get the current date 
  DateTime now = DateTime.now();
  //check if the sender user or organization
    //save the document
await collectionRef.add({
  'text':message,
  'date':now,
  'fromuser':usertype==usertypes.User?true:false,
}
);

}
