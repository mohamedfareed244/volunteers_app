import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String? id;
  final String name;
  final String email;
  final String description;
  final String contactNumber;
  final String? imageUrl;

  Organization({
    this.id,
    required this.name,
    required this.email,
    required this.description,
    required this.contactNumber,
    this.imageUrl,
  });

  toJson() {
    return {
      'Name': name,
      'Email': email,
      'Description': description,
      'contactNumber': contactNumber,
      'imageUrl': imageUrl,
    };
  }

  //Map  Organization fetched from the database to Organization object
  factory Organization.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> snapshot){
    return Organization(
      id: snapshot.id,
      name: snapshot.data()!['Name'],
      email: snapshot.data()!['Email'],
      description: snapshot.data()!['Description'],
      contactNumber: snapshot.data()!['contactNumber'],
      imageUrl: snapshot.data()!['imageUrl'],
    );
  }

}
