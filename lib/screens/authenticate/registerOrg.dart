import 'package:flutter/material.dart';
import 'package:volunteers_app/screens/Home/home.dart';
import 'package:volunteers_app/screens/authenticate/sign_in.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';
import 'package:volunteers_app/views/dashboard/edit_organization.dart';

class RegisterOrg extends StatefulWidget {
  const RegisterOrg({super.key});

  @override
  State<RegisterOrg> createState() => _RegisterOrgState();
}

class _RegisterOrgState extends State<RegisterOrg> {
 final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Organization input fields
  String name = '';
  String email = '';
  String password = '';
  String description = '';
  String contactNumber = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        elevation: 5.0,
        title: Text('Sign Up to Organization',
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
                          'Name', Icons.person, (val) => name = val),
                      SizedBox(height: 20.0),
                      buildTextFormField('Email', Icons.email,
                          (val) => email = val, isEmail: true),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Password', Icons.lock, (val) => password = val,
                          obscureText: true),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Description', Icons.description, (val) => description = val,maxlines: 5),
                      SizedBox(height: 20.0),
                      buildTextFormField(
                          'Contact Number', Icons.phone_outlined, (val) => contactNumber = val),
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
                          child: Center(
                            child: Text('Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                                     textAlign: TextAlign.center,),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            // Register the user with all input fields
                            dynamic result =
                                await _authService.registerWithEmailAndPasswordOrg(
                              email,
                              password,
                              name,
                              description,
                              contactNumber,
                            );

                            setState(() => loading = false);

                           if (result == null) {
                              setState(() => error = 'Registration failed. Try again.');
                            } else {
                              // Show verification prompt
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Verification Email Sent'),
                                  content: const Text(
                                    'Please verify your email before logging in.',
                                  ),
                                  actions: [
                                    TextButton(
                                     onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SignIn()));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );

                              print("Organization registered: ${result.id}");
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTextFormField(
    String label,
    IconData icon,
    Function(String) onChanged, {
    bool obscureText = false,
    bool isEmail = false,
    int maxlines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: Icon(icon, color: Colors.orange[600]),
        fillColor: Colors.white,
        filled: true,
      ),
      obscureText: obscureText,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      maxLines: maxlines,
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