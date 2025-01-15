import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHeaderDrawer extends StatefulWidget {
  final String role;

  const MyHeaderDrawer({super.key, required this.role});

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String name = "Loading...";
  String email = "Loading...";
  String imageUrl = "assets/images/image1.png"; // Default local placeholder

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get current user
      if (user != null) {
        String collection = widget.role == "user" ? "users" : "Organization";

        // Fetch user data from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection(collection)
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            name = widget.role=="user"?snapshot["firstName"] ?? "No Name":snapshot["Name"] ?? "No Name"; 
            email = widget.role=="user"?snapshot["email"] ?? "No Email":snapshot["Email"] ?? "No Email"; 
            imageUrl = snapshot["imageUrl"]??imageUrl; // Replace with Firestore field name
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Theme.of(context).cardColor,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            width: 70, // Explicit width for circular avatar
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover, // Ensure the image fills the circle
                image: imageUrl.startsWith("http") // Check if it's a network URL
                    ? NetworkImage(imageUrl) as ImageProvider
                    : AssetImage(imageUrl),
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            email,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
