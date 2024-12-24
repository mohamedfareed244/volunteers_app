import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String role ;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.role,
    this.createdAt,
  });

  // Convert UserModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'role': role,
      'createdAt': createdAt,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return UserModel(
      uid: map.data()!['uid'],
      firstName: map.data()!['firstName'],
      lastName: map.data()!['lastName'],
      email: map.data()!['email'],
      address: map.data()!['address'],
      role: map.data()!['role'],
      createdAt: (map.data()!['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
