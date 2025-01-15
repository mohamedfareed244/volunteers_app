import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/models/application.dart';
import 'package:volunteers_app/models/user.dart';

class ReviewDetails extends StatefulWidget {
  final Application application;

  const ReviewDetails({super.key, required this.application});

  @override
  State<ReviewDetails> createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.application.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          user = UserModel.fromMap(userDoc); // Assuming `UserModel.fromMap()` exists
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateApplicationStatus(String status) async {
    try {
      // Update status in Firestore
      await FirebaseFirestore.instance
          .collection("applications")
          .doc(widget.application.appId) // Assuming `id` exists in `Application`
          .update({"status": status});

      // Fetch the updated application details after update
      final updatedApplicationDoc = await FirebaseFirestore.instance
          .collection("applications")
          .doc(widget.application.appId)
          .get();

      if (updatedApplicationDoc.exists) {
        setState(() {
          widget.application.status = updatedApplicationDoc["status"];
        });
      }
    } catch (e) {
      print("Error updating application status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Review Details"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1.5, height: 24),
                  Text(
                    "First Name: ${user?.firstName ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Email: ${user?.email ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Address: ${user?.address ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Application Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1.5, height: 24),
                  Text(
                    "Opportunity Title: ${widget.application.opportunityTitle ?? 'No title'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Application Date: ${widget.application.applicationDate ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Relevant Skills: ${widget.application.relevantSkills ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Reason for Interest: ${widget.application.interestReason ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Application Status: ${widget.application.status}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  if (widget.application.status == 'Pending')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateApplicationStatus('Accepted');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text("Accept",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updateApplicationStatus('Rejected');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text("Reject",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
