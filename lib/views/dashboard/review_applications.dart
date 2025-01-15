import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/application.dart';
import 'review_details.dart';

class ReviewApplications extends StatefulWidget {
  const ReviewApplications({super.key});

  @override
  State<ReviewApplications> createState() => _ReviewApplicationsState();
}

class _ReviewApplicationsState extends State<ReviewApplications> {
  final _firestore = FirebaseFirestore.instance;

  // Fetch applications for the organization's opportunities
  Stream<List<Application>> getApplicationsForOrganization(String organizationId) async* {
    // Fetch opportunities for the organization
    final opportunitiesQuery = await _firestore
        .collection('opportunitites')
        .where('orgid', isEqualTo: organizationId)
        .get();

    final opportunityIds = opportunitiesQuery.docs.map((doc) => doc.id).toList();

    if (opportunityIds.isEmpty) {
      yield [];
      return;
    }

    // Fetch applications for those opportunities
    yield* _firestore
        .collection('applications')
        .where('opportunityId', whereIn: opportunityIds)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Application.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final organization = Provider.of<User>(context);
    final organizationId = organization.uid;
    
    return Scaffold(
      body: StreamBuilder<List<Application>>(
        stream: getApplicationsForOrganization(organizationId),
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
            padding: const EdgeInsets.all(16.0),
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
                  color: Colors.grey[400], // This is fine without const
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index];
                      return ListTile(
                        title: Text(
                          application.userEmail ?? 'No email',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          application.opportunityTitle ?? 'No opportunity title',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          application.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: application.status == 'Accepted'
                                ? Colors.green
                                : (application.status == 'Rejected'
                                    ? Colors.red
                                    : Colors.black),
                          ),
                        ),
                        onTap: () {
                          // Navigate to ReviewDetails screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewDetails(
                                application: application,
                              ),
                            ),
                          );
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
