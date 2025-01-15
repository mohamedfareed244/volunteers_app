import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/organization.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/WelcomeScreen.dart';

class OrganizationDashboard extends StatelessWidget {
  OrganizationDashboard({super.key});

  final CollectionReference myItems =
      FirebaseFirestore.instance.collection("users");

  final opportunities = FirebaseFirestore.instance.collection("opportunitites");
  final AuthService _auth = AuthService();

  Future<Organization?> getOrganization(User user) async {
    final orgDoc = await FirebaseFirestore.instance
        .collection('Organization')
        .doc(user.uid)
        .get();
    if (orgDoc.exists) {
      try {
        return Organization.fromSnapshot(orgDoc);
      } catch (Error) {
        print('Error $Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Information Card
            SizedBox(height: 16),
            Center(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(width: 16),
                      FutureBuilder(
                          future: getOrganization(user!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: Colors.amber,);
                            }
                            if (snapshot.hasError) {
                              return SnackBar(content: Text("Error loading data"),backgroundColor: Colors.red,);
                            }
                            final org = snapshot.data as Organization;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Organization Information",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("Name: ${org.name}",style: TextStyle(fontSize: 14,color: Colors.grey[600]),),
                                SizedBox(height: 4),
                                Text("Email: ${org.email}",style: TextStyle(fontSize: 14,color: Colors.grey[600])),
                              ],
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('OverView',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),

            // Total Volunteers and Total Opportunites
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total volunteer ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          StreamBuilder<QuerySnapshot>(
                            stream: myItems.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(color: Colors.amber,); // Loading indicator
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading data");
                              }
                              // Get the document count
                              int volunteerCount =
                                  snapshot.data?.docs.length ?? 0;
                              return Text(
                                "$volunteerCount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              );
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
                          Text(
                            "Total opportunitites",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          StreamBuilder<QuerySnapshot>(
                            stream: opportunities.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(color: Colors.amber,); // Loading indicator
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading data");
                              }
                              // Get the document count
                              int opportunitesCount =
                                  snapshot.data?.docs.length ?? 0;
                              return Text(
                                "$opportunitesCount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 24),

            // Recent Activities Section
            Text(
              "Recent Activities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Activity Table
            Card(
              elevation: 2,
              child: Table(
                border: TableBorder.all(color: Colors.grey[300]!),
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(5),
                  3: FlexColumnWidth(3),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration( color: Theme.of(context).canvasColor,),
                    children: [
                      tableCell("Volunteer Name", true),
                      tableCell("Volunteer Email", true),
                      tableCell("Opportunity", true),
                      tableCell("Status", true),
                    ],
                  ),
                  
                  TableRow(
        children: [
          tableCell("John Doe"),
          tableCell("john.doe@example.com"),
          tableCell("Clean Up Drive"),
          tableCell("Completed"),
        ],
      ), TableRow(
        children: [
          tableCell("Jane Smith"),
          tableCell("jane.smith@example.com"),
          tableCell("Food Distribution"),
          tableCell("Pending"),
        ],
      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create table cells
  Widget tableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
