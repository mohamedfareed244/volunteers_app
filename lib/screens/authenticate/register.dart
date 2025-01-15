import 'package:flutter/material.dart';
import 'package:volunteers_app/screens/Home/home.dart';
import 'package:volunteers_app/screens/authenticate/registerOrg.dart';
import 'package:volunteers_app/screens/authenticate/sign_in.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';

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
      backgroundColor: Theme.of(context).cardColor,
        elevation: 5.0,
        title: Text('Sign Up to Volunteens',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Sign In',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              // widget.toggleView!();

             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignIn()));
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
                      buildTextFormField(
                          'First Name', Icons.person, (val) => firstName = val),
                      SizedBox(height: 20.0),
                      buildTextFormField('Last Name', Icons.person_outline,
                          (val) => lastName = val),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Email', Icons.email, (val) => email = val,
                          isEmail: true),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Password', Icons.lock, (val) => password = val,
                          obscureText: true),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Address', Icons.home, (val) => address = val),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),textAlign:TextAlign.center,),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            // Register the user with all input fields
                            dynamic result =
                                await _authService.registerWithEmailAndPassword(
                              email,
                              password,
                              firstName,
                              lastName,
                              address,
                            );

                            setState(() => loading = false);

                            if (result == null) {
                              setState(() =>
                                  error = 'Registration failed. Try again.');
                            } else {
                                 // Show verification dialog after successful registration
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Email Verification'),
                                  content: Text(
                                      'A verification link has been sent to your email. Please verify your email before signing in.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SignIn()));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(height: 20.0),
                      TextButton(onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterOrg()));
                      }, child: Text("Register as Organization",style: TextStyle(color: Colors.indigo[900], decoration: TextDecoration.underline,),))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTextFormField(
      String label, IconData icon, Function(String) onChanged,
      {bool obscureText = false, bool isEmail = false}) {
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
