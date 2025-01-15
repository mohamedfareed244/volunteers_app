import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/application.dart';
import 'package:volunteers_app/models/organization.dart';
import 'package:volunteers_app/models/user.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/dashboard/review_details.dart';

class OrganizationDashboard extends StatelessWidget {
  OrganizationDashboard({super.key});

  final CollectionReference myItems = FirebaseFirestore.instance.collection("users");
  final opportunities = FirebaseFirestore.instance.collection("opportunitites");
  final AuthService _auth = AuthService();

  // Fetch organization info
  Future<Organization?> getOrganization(User user) async {
    final orgDoc = await FirebaseFirestore.instance.collection('Organization').doc(user.uid).get();
    if (orgDoc.exists) {
      try {
        return Organization.fromSnapshot(orgDoc);
      } catch (e) {
        print('Error: $e');
      }
    }
    return null; // Return null if no organization found or error occurred
  }

  // Stream for applications related to the organization
  Stream<List<Application>> getApplicationsForOrganization(String organizationId) async* {
    final opportunitiesQuery = await FirebaseFirestore.instance
        .collection('opportunitites')
        .where('orgid', isEqualTo: organizationId)
        .get();

    final opportunityIds = opportunitiesQuery.docs.map((doc) => doc.id).toList();
    if (opportunityIds.isEmpty) {
      yield []; // No opportunities, return an empty list
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('applications')
        .where('opportunityId', whereIn: opportunityIds)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Application> applications = [];
      for (var doc in querySnapshot.docs) {
        final application = Application.fromSnapshot(doc);
        final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(application.userId).get();
        
        if (userSnapshot.exists) {
          final userData = UserModel.fromMap(userSnapshot);
          application.user = userData;
        }

        applications.add(application);
      }
      return applications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('User not authenticated')),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Organization Info Card
            FutureBuilder<Organization?>(
              future: getOrganization(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } 
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Error loading organization data');
                }

                final org = snapshot.data;
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.orange,
                          backgroundImage: (org?.imageUrl != null)
                              ? NetworkImage(org!.imageUrl!)
                              : AssetImage('assets/images/image1.png') as ImageProvider,
                         
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Organization Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 8),
                            Text("Name: ${org?.name ?? 'N/A'}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            SizedBox(height: 4),
                            Text("Email: ${org?.email ?? 'N/A'}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
            SizedBox(height: 10),

            // Total Volunteers and Total Opportunities Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Volunteers", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          SizedBox(height: 4),
                          StreamBuilder<QuerySnapshot>(
                            stream: myItems.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading data");
                              }

                              int volunteerCount = snapshot.data?.docs.length ?? 0;
                              return Text("$volunteerCount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Opportunities", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          SizedBox(height: 4),
                          StreamBuilder<QuerySnapshot>(
                            stream: opportunities.where("orgid", isEqualTo: user.uid).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading data");
                              }

                              int opportunitiesCount = snapshot.data?.docs.length ?? 0;
                              return Text("$opportunitiesCount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Recent Applications Section
            Text(
              "Recent Applications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            SizedBox(height: 8),

            // Activity Table
            StreamBuilder<List<Application>>(
              stream: getApplicationsForOrganization(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error loading applications.");
                }

                final applications = snapshot.data ?? [];
                if (applications.isEmpty) {
                  return Text("No applications found.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final app = applications[index];
                    final user = app.user;

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: user?.imageUrl != null ? NetworkImage(user!.imageUrl!) : null,
                          backgroundColor: Colors.grey[200],
                          child: user?.imageUrl == null ? Icon(Icons.person, color: Colors.grey) : null,
                        ),
                        title: Text("${user?.firstName} ${user?.lastName}" ?? "Unknown"),
                        subtitle: Text("Opportunity: ${app.opportunityTitle ?? "N/A"}"),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewDetails(application: app),
                              ),
                            );
                          },
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
