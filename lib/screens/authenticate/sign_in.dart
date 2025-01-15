import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/screens/authenticate/register.dart';
import 'package:volunteers_app/screens/authenticate/registerOrg.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';
import 'package:volunteers_app/views/dashboard/organization_dashboard.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorMessage = ''; // Error message for unverified email

 void _showRegistrationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "Register as",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              "Choose your role",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600], // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded edges
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: Text("User", style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterOrg(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600], // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded edges
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: Text("Organization", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
         backgroundColor: Theme.of(context).cardColor,
        elevation: 0.0,
        title: Text(
          'Sign In to Volunteens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Register', style: TextStyle(color: Colors.white)),
            onPressed: () {
              _showRegistrationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.orange[600]),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.orange[600]),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) =>
                    value!.length < 6 ? 'Enter a valid password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    dynamic result = await _authService
                        .signInWithEmailAndPassword(email, password);
                    if (result != null) {
                      DocumentSnapshot Doc = await FirebaseFirestore.instance
                          .collection(
                              'users') // Adjust for `Organization` if needed
                          .doc(result.uid)
                          .get();

                      if (Doc.exists && Doc['role'] == 'user') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => drawerr(role: 'user')));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    drawerr(role: 'organization')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign In failed')));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
