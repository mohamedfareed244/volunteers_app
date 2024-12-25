import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/WelcomeScreen.dart';

class OrganizationDashboard extends StatelessWidget {
  OrganizationDashboard({super.key});

  final CollectionReference myItems =
      FirebaseFirestore.instance.collection("users");
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DrawerWidget(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Information Card
            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
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
                    Text("Name: Resala "),
                    Text("Email: Resala@gmail.com"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Total Customers & Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Customers
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total number of volunteers",
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
                          return CircularProgressIndicator(); // Loading indicator
                        }
                        if (snapshot.hasError) {
                          return Text("Error loading data");
                        }
                        // Get the document count
                        int volunteerCount = snapshot.data?.docs.length ?? 0;
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

                // Buttons Section - Prevent overflow
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, color: Colors.orange),
                          label: Text(
                            "Add New Opportunity",
                            style: TextStyle(color: Colors.orange),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: [
                      tableCell("Donor Name", true),
                      tableCell("Donor Email", true),
                      tableCell("Amount", true),
                      tableCell("Status", true),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableCell("Nouran Mohamed"),
                      tableCell("Nouran211018@miuegypt.edu.eg"),
                      tableCell("200 USD"), // Added sample amount
                      tableCell("Completed"),
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
