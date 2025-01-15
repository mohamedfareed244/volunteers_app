import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:volunteers_app/controllers/Notifications.dart';
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
          user = UserModel.fromMap(
              userDoc); // Assuming `UserModel.fromMap()` exists
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
          .doc(widget.application.appId)
          .update({"status": status});

      // Notify the user if the application is accepted
      if (status == "Accepted") {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.application.userId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userToken = userData["token"];
          final opportunityTitle =
              widget.application.opportunityTitle ?? "an opportunity";

          // Send notification using NotificationService
          NotificationService notificationService = NotificationService();
          await notificationService.sendNotification(
              userToken,
              "Application Accepted",
              "Congratulations! Your application for $opportunityTitle has been accepted!");

          print("Notification sent to the user.");
        }
      }

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
    String formattedDate = '';
    if (widget.application.applicationDate != null) {
      DateTime applicationDate = widget.application.applicationDate;
      formattedDate = DateFormat('dd/MM/yyyy').format(applicationDate);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Review Details"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center( // Center the entire body content
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: 600), // Optional: Set a max width for the card
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Personal Data",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Divider(thickness: 1.5, height: 24),
                            Text(
                              "Opportunity Title: ${widget.application.opportunityTitle ?? 'No title'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Application Date: ${formattedDate ?? 'N/A'}",
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
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                   fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: [
                                  TextSpan(text: "Application Status: "),
                                  TextSpan(
                                    text: widget.application.status,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      color: widget.application.status ==
                                              'Accepted'
                                          ? Colors.green
                                          : (widget.application.status == 
                                                  'Rejected'
                                              ? Colors.red
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
