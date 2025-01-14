import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/screens/AuthWrapper.dart';
import 'package:volunteers_app/views/userchat.dart';
import 'package:intl/intl.dart';

// Builds a single chat item widget
Future<Widget> buildChatItem(BuildContext context, String name,String date, Color backgroundColor,String chatid) async {
  String? role=await getUserRole(FirebaseAuth.instance.currentUser!.uid);

  return InkWell(
  onTap: () {
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(chatid,role,name))
              );
  },
  child: Container(
    margin: const EdgeInsets.only(bottom: 10.0), // Add bottom margin
    padding: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8.0), // Rounded corners
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero, // Remove any default padding
      leading:  Icon(
        Icons.person,
        size: 30, // Adjust icon size as needed
        color: backgroundColor==Colors.green?Colors.white:Colors.black,
      ),
      title: Text(
        name,
        style:  TextStyle(fontSize: 18, color: backgroundColor==Colors.green?Colors.white:Colors.black),
      ),
      subtitle: Text(
        date,
        style:  TextStyle(fontSize: 18, color:backgroundColor==Colors.green?Colors.white:Colors.black),
      ),
    ),
  ),
);

}
//fetch the current users for the logged in organization 
Stream<List<Widget>> getOrganizationUsers(
    String orgid, BuildContext context) async* {
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef = connection.collection('chats');

  // Listen to the stream and process data
  yield* collectionRef
      .where('orgid', isEqualTo: orgid)
      .orderBy('order', descending: true)
      .orderBy('lastupdate', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async{ 
        List<Map<String,dynamic>> users=await FetchUsers(querySnapshot);
        return processChatData(querySnapshot, context, users);// proccess the data 
      }//end map functio 
      ); //end map 
}

//fetch the current organizations for the logged in user 
Stream<List<Widget>> getUsersOrganizations(
    String userid, BuildContext context) async* {
      
       try{
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef = connection.collection('chats');

  // Listen to the stream and process data
  yield* collectionRef
      .where('userid', isEqualTo: userid)
      .orderBy('order', descending: true)
      .orderBy('lastupdate', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async{ 
        List<Map<String,dynamic>> users=await FetchUserOrganizations(querySnapshot);
        return processChatData(querySnapshot, context, users);// proccess the data 
      }//end map functio 
      );
       }catch(e){
         print('\x1B[31mError Happened : ${e.toString()}\x1B[0m');
       }
 //end map 
}
Future<List<Map<String, dynamic>>> FetchUserOrganizations(QuerySnapshot snapshot) async {
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef = connection.collection('Organization');

  // Create the users list
  List<Map<String, dynamic>> orglist = [];

  // Iterate over the current snapshot
  for (var docs in snapshot.docs) {
    // Fetch the document
    DocumentSnapshot user = await collectionRef.doc((docs.data() as Map<String, dynamic>)['orgid']).get();
    
    // Add the document data along with the document ID
    Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
    userData['id'] = user.id; // Add document ID

    // Add to the list
    orglist.add(userData);
  }

  return orglist;
}



Future<List<Map<String, dynamic>>> FetchUsers(QuerySnapshot snapshot) async {
  FirebaseFirestore connection = FirebaseFirestore.instance;
  CollectionReference collectionRef = connection.collection('users');

  // Create the users list
  List<Map<String, dynamic>> userlist = [];

  // Iterate over the current snapshot
  for (var docs in snapshot.docs) {
    // Fetch the user document
    DocumentSnapshot user = await collectionRef.doc(
        (docs.data() as Map<String, dynamic>)['userid']).get();

    // Add document data along with its ID
    Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
    userData['id'] = user.id; // Add the document ID

    // Add to the user list
    userlist.add(userData);
  }

  return userlist;
}


// Process the chat data synchronously
Future<List<Widget>> processChatData(QuerySnapshot querySnapshot,
    BuildContext context, List<Map<String,dynamic>> users) async{
        List<Widget> usersList = [];
     try{
  for (var i=0;i<querySnapshot.docs.length;i++) {

    var data = querySnapshot.docs[i].data() as Map<String, dynamic>;
    var user =users[i];
 
    // Format the date
    String formattedDate = formatTimestamp(data['lastupdate']);
    String formattedTime = DateFormat('h:mm a').format(data['lastupdate'].toDate());
    formattedDate+=" at $formattedTime";

    // Use pre-fetched user data as needed

    String? userRole=await getUserRole(user['id']);
  
    print("the current user role is : ${userRole}");
    String userName =  userRole == 'organization' ? user['Name'] : user['firstName'] ;
    // Build chat item
    usersList.add(await buildChatItem(
      context,
      userName, 
      formattedDate,
      data['isupdated'] ? Colors.green : Colors.grey[300]!,
      querySnapshot.docs[i].id
    ));
  }
     }catch(e,stack){
      print("error in process chat data function ${stack}");
     }




  return usersList;
}

// Formats Firestore timestamp to MM dd yyyy
String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate(); // Convert to DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format to MM dd yyyy
}

   Future<String?> getUserRole(String userId) async {
    print("finding the one with id : ${userId}");
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return 'user';
    }
    final orgDoc = await FirebaseFirestore.instance
        .collection('Organization')
        .doc(userId)
        .get();
    if (orgDoc.exists) {
      return 'organization';
    }
    return null;
  }


//function to start new chat
Future<void> StartNewChat (String orgid,BuildContext context) async{
  //fetch the current user id 
  String currentUserId= await FirebaseAuth.instance.currentUser!.uid;
  //get the current date for last update
  Timestamp currentDate=Timestamp.now();
  //set the isupdated 
  bool isupdated=false;
  //set the order 
  int order=0;

  //create the new object in chats 
Map<String,dynamic> obj ={};
obj["userid"]=currentUserId;
obj["lastupdate"]=currentDate;
obj["order"]=order;
obj["isupdated"]=isupdated;
obj["orgid"]=orgid;
DocumentReference newdoc= await FirebaseFirestore.instance.collection("chats").add(obj);
//fetch the current user data 
DocumentSnapshot Org=await FirebaseFirestore.instance.collection("Organization").doc(orgid).get();
Map<String,dynamic> org=Org.data() as Map<String,dynamic>;
//Navigate to the chatpage directly 
 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(newdoc.id,"user",(org["Name"])))
              );


}
