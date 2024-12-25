import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/providers/opp_provider.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/dashboard/upload_opp.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';
import 'package:volunteers_app/views/inner_screens/opp_details.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OppProvider()),
        StreamProvider<User?>.value(
        value: AuthService().user,
        initialData: null,)
      ],
    
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.amber[700],
              )),
          home: const AuthWrapper(),
          routes: {
            OppDetails.routName: (context) => const OppDetails(),
            UploadOpp.routeName: (context) => const UploadOpp(),
            // Add more routes here
          },
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
