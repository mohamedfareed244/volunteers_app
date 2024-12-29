import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/models/application.dart';

class ReviewApplications extends StatefulWidget {
  const ReviewApplications({super.key});

  @override
  State<ReviewApplications> createState() => _ReviewApplicationsState();
}

class _ReviewApplicationsState extends State<ReviewApplications> {
  final _db = FirebaseFirestore.instance.collection("applications");

  // Fetch applications from Firestore
  Future<List<Application>> getApplications() async {
    final applicationsSnapshot = await _db.get();
    final List<Application> applications = applicationsSnapshot.docs
        .map((doc) => Application.fromSnapshot(doc))
        .toList();
    return applications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Application>>(
        future: getApplications(),  // Fetch applications
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No applications found"));
          }

          final applications = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0), // Add padding to the body
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Review Applications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16), // Add some space between title and list
                Expanded(
                  child: ListView.builder(
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index];
                      return ListTile(
                        title: Text(application.userEmail ?? 'No email',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Text(application.opportunityTitle ?? 'No opportunity title',
                            style: TextStyle(fontSize: 12)),
                        trailing: Text(application.status ?? 'Pending',
                            style: TextStyle(fontSize: 12)),
                        onTap: () {
                          // Handle tap (e.g., show details or review)
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
