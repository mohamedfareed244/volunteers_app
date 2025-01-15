import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/controllers/Notifications.dart';
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
          color: isMe?Colors.grey[300]:Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style:isMe?const TextStyle(color: Colors.black):const TextStyle(color: Colors.white),
        ),
      ),
    );
  }


Stream<List<Widget>> getChatMessages(BuildContext context, String id,String? type) {
  // Get Firestore connection
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef =
      connection.collection('chats').doc(id).collection('messages');


  // Stream the data and build widgets dynamically
  return collectionRef.orderBy('date',descending: false).snapshots().map((querysnapshot) {
    
    List<Widget> chatList = [];
    
    for (var doc in querysnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      // Build a new message widget for each document
      chatList.add(buildMessage(context, data['text'], MsgLoc(data['fromuser'],type)));
    }

    // Return the new list
    return chatList;
  });
}



Future<void> sendMessage(String message,String chatid,String? type) async{
  //get the required collection
  FirebaseFirestore connection = FirebaseFirestore.instance;
  DocumentReference docref =connection.collection('chats').doc(chatid);
  //get the current date 
  DateTime now = DateTime.now();
  //check if the sender user or organization
    //save the document
await docref.collection("messages").add({
  'text':message,
  'date':now,
  'fromuser':type=="user"?true:false,
}
);
DocumentSnapshot snapshot=await docref.get();
Map<String,dynamic> chatobj= snapshot.data() as Map<String,dynamic>;
Notifyuser(chatobj, type, message);


}

Future<void> Notifyuser(Map<String,dynamic> chatobj, String? type ,String message) async {
  FirebaseFirestore connection = FirebaseFirestore.instance;
  
  NotificationService NotifService=new NotificationService();

//fetch the chat org data 
 DocumentSnapshot org= await connection.collection('Organization').doc(chatobj["orgid"]).get();
  Map<String,dynamic> orgdata = org.data() as Map<String,dynamic>;
  //fetch the chat user data 
    DocumentSnapshot User= await connection.collection('users').doc(chatobj["userid"]).get();
   Map<String,dynamic> UserData = User.data() as Map<String,dynamic>;

if(type=="user"){
  //get the org id from the chatobj 
  String OrgToken=orgdata["token"];
  //get the sender name 
   String username="${UserData["firstName"]} ${UserData["lastName"]}";
  //send the notification  
await NotifService.sendNotification(OrgToken, "New Message From : $username", message);
}else{
  //get the user token 
String UserToken = UserData["token"];
//get the organization name 
String Orgname= orgdata["Name"];
//send the notification 
await NotifService.sendNotification(UserToken, "New Message From Organization : $Orgname", message);
}

}

bool MsgLoc(bool fromuser,String? type){
  if(type=="user"){
    if(fromuser){
      return true;
    }
return false;
  }else{
    if(!fromuser){
      return true;
    }
    return false;

  }

  
}
