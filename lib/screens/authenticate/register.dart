import 'package:flutter/material.dart';
import 'package:volunteers_app/services/AuthService.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // User input fields
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String address = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], 
      appBar: AppBar(
        backgroundColor: Colors.orange[700], 
        elevation: 5.0,
        title: Text('Sign Up to Volunteens', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              widget.toggleView!();
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      buildTextFormField('First Name', Icons.person, (val) => firstName = val),
                      SizedBox(height: 20.0),
                      buildTextFormField('Last Name', Icons.person_outline, (val) => lastName = val),
                      SizedBox(height: 20.0),
                      buildTextFormField('Email', Icons.email, (val) => email = val, isEmail: true),
                      SizedBox(height: 20.0),
                      buildTextFormField('Password', Icons.lock, (val) => password = val, obscureText: true),
                      SizedBox(height: 20.0),
                      buildTextFormField('Address', Icons.home, (val) => address = val),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _authService.registerWithEmailAndPassword(email, password);
                            setState(() => loading = false);
                            if (result == null) {
                              setState(() => error = 'Registration failed. Try again.');
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTextFormField(String label, IconData icon, Function(String) onChanged, {bool obscureText = false, bool isEmail = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: Icon(icon, color: Colors.orange[600]),
        fillColor: Colors.white,
        filled: true,
      ),
      obscureText: obscureText,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your $label';
        } else if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        } else if (label == 'Password' && value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
