import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/services/AuthService.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[600],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Volunteens!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Your platform for community volunteering',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                color: Colors.orange[600],
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Explore Opportunities',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              onPressed: () {
                // Add navigation to the volunteer opportunities page
              },
            ),
          ],
        ),
      ),
    );
  }
}
