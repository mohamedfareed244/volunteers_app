  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart'; // Import the image_picker package
  import 'dart:io';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:volunteers_app/models/organization.dart';
  import 'package:volunteers_app/models/user.dart'; // To handle File object

  class Userprofile extends StatefulWidget {
    const Userprofile({super.key});

    @override
    State<Userprofile> createState() => _UserprofileState();
  }

  class _UserprofileState extends State<Userprofile> {
    final _db = FirebaseFirestore.instance.collection("users");
    final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
    final FirebaseStorage _storage = FirebaseStorage.instance;// Firebase Storage instance

      File? _imageFile; // Variable to hold the selected image file
      final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  //get single the user data

    Future<UserModel> getUserModel(String Useruid) async {
      final snapshot = await _db.doc(Useruid).get(); //json firsestore
      final UserData = UserModel.fromMap(snapshot);
      return UserData;
    }

    // Function to get the current user's email from Firebase Authentication
    Future<UserModel?> fetchUserData() async {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          String Useruid = user.uid ?? ''; // Get the email of the current user
          if (Useruid.isNotEmpty) {
            // Call the getOrganization function with the email
            try {
              UserModel userModel = await getUserModel(Useruid);
              print('Organization data fetched for email: ${userModel.toMap()}');
              return userModel;
              // Successfully fetched organization data
            } catch (e) {
              // Error while fetching organization data
              print('Error fetching organization data for email "$Useruid": $e');
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

   // Save changes to Firestore
  Future<void> saveChanges(UserModel user) async {
    String? imageUrl = await _uploadImage(user.uid); // Upload image and get URL
    if (imageUrl != null) {
      user.imageUrl = imageUrl; // Update the imageUrl in the user model
    }

    await _db.doc(user.uid).update(user.toMap()); // Save changes to Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully Updated"),
      ),
    );
  }

    //Delete Account Function
    Future<void> deleteAccount(String id) async {
      await _db.doc(id).delete();
    }

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

      // Upload the selected image to Firebase Storage
  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null) return null;

    try {
      // Define the path in Firebase Storage
      final ref = _storage.ref().child('user_images').child('$userId.jpg');

      // Upload the file
      await ref.putFile(_imageFile!);

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(50.0),
            child: FutureBuilder(
              future: fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel userModel = snapshot.data as UserModel;
                    final TextEditingController _firstnameController =
                        TextEditingController(text: userModel.firstName);
                    final TextEditingController _lastnameController =
                        TextEditingController(text: userModel.lastName);
                    final TextEditingController _emailController =
                        TextEditingController(text: userModel.email);
                    final TextEditingController _addressController =
                        TextEditingController(text: userModel.address);

                    return Column(
                      children: [
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircleAvatar(
                                radius: 60, // Adjust the size
                                // Placeholder color
                               backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (userModel.imageUrl != null
                                      ? NetworkImage(userModel.imageUrl!)
                                          as ImageProvider
                                      : AssetImage('assets/images/image1.png')),
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
                                controller: _firstnameController,
                                decoration: InputDecoration(
                                    labelText: "First Name",
                                    prefixIcon:
                                        Icon(Icons.person_outline_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                              SizedBox(height: 14),
                              TextFormField(
                                controller: _lastnameController,
                                decoration: InputDecoration(
                                    labelText: "Last Name",
                                    prefixIcon:
                                        Icon(Icons.person_outline_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                              SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
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
                                controller: _addressController,
                                // initialValue: org.description,
                                decoration: InputDecoration(
                                    labelText: "Address",
                                    prefixIcon: Icon(Icons.home),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                              
                              SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final UserModel UpadtedOrg = UserModel(
                                      uid: userModel.uid,
                                      firstName: _firstnameController.text,
                                      lastName: _lastnameController.text,
                                      email: _emailController.text,
                                      address: _addressController.text,
                                      role: userModel.role,
                                      imageUrl: userModel.imageUrl
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
                                        style: TextStyle(fontSize: 12),
                                        children: [
                                          TextSpan(
                                              text: " 2/12/2024",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ))
                                        ]),
                                  ),
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        await deleteAccount(userModel.uid);
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
