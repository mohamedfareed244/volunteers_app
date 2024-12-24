import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/screens/authenticate/Authenticate.dart';
import 'package:volunteers_app/screens/home/home.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("usert=rrrrr ${user}");
    // Return Authenticate or HomeScreen based on user status
    return user == null ? const Authenticate() : drawerr();
  }
}
