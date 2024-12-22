
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io';

import 'package:volunteers_app/models/organization.dart'; // To handle File object

class Orgprofile extends StatefulWidget {
  const Orgprofile({super.key});

  @override
  State<Orgprofile> createState() => _OrgprofileState();
}

class _OrgprofileState extends State<Orgprofile> {
  final _db = FirebaseFirestore.instance.collection("Organization");
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

//get single the organization data

  Future<Organization> getOrganization(String email) async {
    final snapshot = await _db.where('Email', isEqualTo: email).get();
    final orgData =
        snapshot.docs.map((doc) => Organization.fromSnapshot(doc)).single;
    return orgData;
  }

  //get all the organization data

  Future<List<Organization>> getOrganizations() async {
    final snapshot = await _db.get();
    final orgData =
        snapshot.docs.map((doc) => Organization.fromSnapshot(doc)).toList();
    return orgData;
  }

  // Function to get the current user's email from Firebase Authentication
  Future<Organization?> fetchOrganizationData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String email = user.email ?? ''; // Get the email of the current user
        if (email.isNotEmpty) {
          // Call the getOrganization function with the email
          try {
            Organization org = await getOrganization(email);
            print('Organization data fetched for email: ${org.toJson()}');
            return org;
            // Successfully fetched organization data
          } catch (e) {
            // Error while fetching organization data
            print('Error fetching organization data for email "$email": $e');
          }
        } else {
          print('Error: Email is empty.');
        }
      } else {
        print('Error: No authenticated user found.');
      }
    } catch (e) {
      // Log any unexpected errors
      print('Unexpected error in fetchOrganizationData: $e');
    }
  }

  //Save Changes Function

  Future<void> saveChanges(Organization org) async {
    await _db.doc(org.id).update(org.toJson());
  }

  //Delete Account Function
  Future<void> deleteAccount(String id) async {
    await _db.doc(id).delete();
  }

  File? _imageFile; // Variable to hold the selected image file
  final ImagePicker _picker =
      ImagePicker(); // Create an instance of ImagePicker

  // Function to select an image from the gallery
  Future<void> _pickImage() async {
    final XFile? selected =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: FutureBuilder(
            future: fetchOrganizationData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  Organization org = snapshot.data as Organization;
                  final TextEditingController _nameController =
                      TextEditingController(text: org.name);
                  final TextEditingController _emailController =
                      TextEditingController(text: org.email);
                  final TextEditingController _descriptionController =
                      TextEditingController(text: org.description);
                  final TextEditingController _contactNumberController =
                      TextEditingController(text: org.contactNumber);

                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircleAvatar(
                              radius: 60, // Adjust the size
                              // Placeholder color
                              backgroundImage: _imageFile == null
                                  ? AssetImage('lib/assets/images/image.png')
                                  : FileImage(_imageFile!),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.yellow[900],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: InkWell(
                                onTap: _pickImage,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 60),
                      Form(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              // initialValue: org.name,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  prefixIcon:
                                      Icon(Icons.person_outline_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _emailController,
                              // initialValue: org.email,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              maxLines: 5, // Allows for multiple lines of text
                              minLines: 1,
                              controller: _descriptionController,
                              // initialValue: org.description,
                              decoration: InputDecoration(
                                  labelText: "Description",
                                  prefixIcon: Icon(Icons.description_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _contactNumberController,
                              // initialValue: org.contactNumber,
                              decoration: InputDecoration(
                                  labelText: "Contact Number",
                                  prefixIcon: Icon(Icons.phone_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final Organization UpadtedOrg = Organization(
                                    id: org.id,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    description: _descriptionController.text,
                                    contactNumber:
                                        _contactNumberController.text,
                                    imageUrl: org.imageUrl,
                                  );
                                  await saveChanges(UpadtedOrg);
                                },
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[900],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Joined",
                                    style: TextStyle(
                                       fontSize: 12),
                                       children: [
                                        TextSpan(
                                          text: " 2/12/2024",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )
                                        )
                                       ]
                                  ),
                                  
                                ),
                                
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      await deleteAccount(org.id!);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    label: Text(
                                      "Delete Account",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
