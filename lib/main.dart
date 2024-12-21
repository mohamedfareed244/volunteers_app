import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';

import 'screens/AuthWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

 @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user, // Stream from AuthService
      initialData: null,
      child: MaterialApp(
        home: drawerr(),
      ),
    );
  }
}



  // Future<void> _addDataToFirestore() async {
  //   try {
  //     final doc = FirebaseFirestore.instance.collection('users').doc('user1');
  //     await doc.set({'name': 'Eslam', 'age': 30});
  //     print('Data written to Firestore successfully!'); 
  //   } catch (e) {
  //     print('Error writing to Firestore: $e');
  //   }
  // }