import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/screens/authenticate/register.dart';
import 'package:volunteers_app/screens/authenticate/registerOrg.dart';
import 'package:volunteers_app/screens/authenticate/sign_in.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/4207.jpg'),
              SizedBox(height: 80),
              Text(
                'Welcome to Volunteens',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60),
              Text(
                'Register as',style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'Volunteer',
                      style: TextStyle(color: Colors.white,fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterOrg()));
                      },
                      child: Text('Organization', style: TextStyle(color: Colors.white,fontSize: 18),),
                       style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                ],
              ),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignIn()));
              }, child: Text("Already have an account? Log in",style: TextStyle(color: Colors.indigo[900], decoration: TextDecoration.underline,)))
            ],
          ),
        ),
      ),
    );
  }
}
