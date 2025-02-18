import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/opp_model.dart';
import 'package:volunteers_app/models/organization.dart';
import 'package:volunteers_app/views/dashboard/OpportunityDetailsPage.dart';
import 'package:volunteers_app/views/dashboard/editOpportunity.dart';

class OpportunityManagment extends StatefulWidget {
  const OpportunityManagment({super.key});

  @override
  State<OpportunityManagment> createState() => _OpportunityManagmentState();
}

class _OpportunityManagmentState extends State<OpportunityManagment> {
  final TextEditingController searchController = TextEditingController();
  final CollectionReference opportunitiesCollection =
      FirebaseFirestore.instance.collection("opportunitites");

  String searchValue = '';
  void onSearchChange(String value) {
    setState(() {
      searchValue = value.trim().toLowerCase();
    });
  }

  Future<void> delete(DocumentSnapshot documentSnapshot) async {
    try {
      await opportunitiesCollection.doc(documentSnapshot.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Deleted Successfully"),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Delete failed: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final organization = Provider.of<User?>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChange,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Avalivable Opportunities:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: opportunitiesCollection
                  .where('orgid', isEqualTo: organization?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> opportunities = snapshot
                      .data!.docs
                      .where((doc) =>
                          searchValue.isEmpty ||
                          doc['oppTitle']
                              .toString()
                              .toLowerCase()
                              .contains(searchValue))
                      .toList();

                  return ListView.builder(
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          opportunities[index];
                      final Timestamp timestamp =
                          documentSnapshot['createdAt'] ?? Timestamp.now();
                      final DateTime createdAt = timestamp.toDate();
                      final formattedDate =
                          "${createdAt.day}/${createdAt.month}/${createdAt.year}";

                      return  Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Section
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      documentSnapshot['oppImage'],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Title and Subtitle Section
                                  Text(
                                    documentSnapshot['oppTitle'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${documentSnapshot['oppDescription']}\nCreated on: $formattedDate",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  // Buttons Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          final opportunity = OppModel(
                                            OppId: documentSnapshot['oppId'],
                                            OppTitle:
                                                documentSnapshot['oppTitle'],
                                            OppDescription: documentSnapshot[
                                                'oppDescription'],
                                            OppImage:
                                                documentSnapshot['oppImage'],
                                            Orgid: documentSnapshot['orgid'],
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditOpp(
                                                  oppModel:
                                                      opportunity), // Pass oppModel
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit,
                                            color:
                                                Color.fromARGB(255, 1, 28, 50)),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          delete(documentSnapshot);
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      
                    },
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
