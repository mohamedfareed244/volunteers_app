import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteers_app/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(
  String email,
  String password,
  String firstName,
  String lastName,
  String address,
) async {
  try {
    // Register the user with Firebase Authentication
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null) {
      // Create a UserModel instance with all user attributes
      UserModel newUser = UserModel(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        address: address,
        createdAt: DateTime.now(),
      );

      // Save the user details to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(newUser.toMap());

      return newUser; // Return the UserModel instance
    }

    return null; // Return null if user creation failed
  } catch (e) {
    print('Registration error: $e');
    return null; // Return null if an error occurred
  }
}


  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
