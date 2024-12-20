import 'package:flutter/material.dart';
import 'package:volunteers_app/services/AuthService.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
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
              widget.toggleView!();
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
                validator: (value) =>
                    value!.isEmpty ? 'Enter an email' : null,
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
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    dynamic result = await _authService
                        .signInWithEmailAndPassword(email, password);
                    if (result == null) {
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
