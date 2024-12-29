import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';
import 'package:volunteers_app/views/WelcomeScreen.dart';
import 'package:volunteers_app/views/dashboard/organization_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  static Future<String?> getUserRole(String userId) async {
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("uuuuser: $user");

    if (user == null) {
      return const WelcomeScreen();
    }

    return FutureBuilder<String?>(
      future: getUserRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }

        final role = snapshot.data;

        // if (role == 'user') {
        //   return  drawerr(); // Screen for regular users
        // } else if (role == 'organization') {
        //   return  drawerr(); // Screen for organizations
        // }

        if (role == 'user' || role == 'organization') {
          print("role: $role");
          return drawerr(role:role!);
        }

        // Role not recognized, log out the user
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false, //removes all the existing routes from the stack
          );
        });

        return const Center(child: Text('Logging out...'));
      },
    );
  }
}