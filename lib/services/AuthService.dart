import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteers_app/models/organization.dart';
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
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null && user.emailVerified) {
      return user;
    } else if (user != null && !user.emailVerified) {
      print('Email not verified. Please verify your email.');
      return null;
    } else {
      return null;
    }
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
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        //ab3t email verification
        await user.sendEmailVerification();
        // Create a UserModel instance with all user attributes
        UserModel newUser = UserModel(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: email.toLowerCase(),
          address: address,
          role: "user",
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

  Future<Organization?> registerWithEmailAndPasswordOrg(
    String email,
    String password,
    String name,
    String description,
    String contactNumber,
  ) async {
    try {
      // Register the user with Firebase Authentication
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? organization = result.user;

      if (organization != null) {
        // Send email verification
        await organization.sendEmailVerification();

        // Create a organizationModel instance with all user attributes
        Organization newOrganization = Organization(
          id: organization.uid,
          name: name,
          email: email.toLowerCase(),
          description: description,
          contactNumber: contactNumber,
          role: "organization",
        );

        // Save the user details to Firestore
        await FirebaseFirestore.instance
            .collection("Organization")
            .doc(organization.uid)
            .set(newOrganization.toJson());

        return newOrganization; // Return the UserModel instance
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
