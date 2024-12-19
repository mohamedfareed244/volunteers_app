import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(onPressed: _addDataToFirestore, child: Text("Click")),
        ),
      ),
    );
  }


}
  Future<void> _addDataToFirestore() async {
    try {
      final doc = FirebaseFirestore.instance.collection('users').doc('user1');
      await doc.set({'name': 'Mohamed fareed', 'age': 30});
      print('Data written to Firestore successfully!'); 
    } catch (e) {
      print('Error writing to Firestore: $e');
    }
  }