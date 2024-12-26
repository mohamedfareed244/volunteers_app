import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Text controllers
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final CollectionReference myItems =
      FirebaseFirestore.instance.collection("users");

  Future<void> update(DocumentSnapshot documentSnapshot) async {
    // Pre-fill the controllers with existing data
    fnameController.text = documentSnapshot['firstName'] ?? '';
    lnameController.text = documentSnapshot['lastName'] ?? '';
    emailController.text = documentSnapshot['email'] ?? '';
    addressController.text = documentSnapshot['address'] ?? '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return myDialogBox(
          name: "Update User",
          condition: "Update",
          onPressed: () async {
            String firstName = fnameController.text.trim();
            String lastName = lnameController.text.trim();
            String email = emailController.text.trim();
            String address = addressController.text.trim();

            // Validation for empty fields
            if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Please fill all the required fields."),
                ),
              );
              return;
            }

            try {
              await myItems.doc(documentSnapshot.id).update({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'address': address,
              });
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Updated Successfully!"),
                ),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Update failed: $error"),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> delete(DocumentSnapshot documentSnapshot) async {
    try {
      await myItems.doc(documentSnapshot.id).delete();
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

  String searchValue = '';
  void onSearchChange(String value) {
    setState(() {
      searchValue = value.trim().toLowerCase();
    });
  }

  bool isSearchClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
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
        Expanded(
          child: StreamBuilder(
          stream: myItems.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final List<DocumentSnapshot> users = streamSnapshot.data!.docs
                  .where(
                    (doc) =>
                        searchValue.isEmpty ||
                        doc['firstName']
                            .toString()
                            .toLowerCase()
                            .contains(searchValue),
                  )
                  .toList();
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = users[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(20),
                      child: ListTile(
                        title: Text(
                          '${documentSnapshot['firstName']} ${documentSnapshot['lastName']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(documentSnapshot["email"]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => update(documentSnapshot),
                              icon: Icon(Icons.edit, color: Colors.indigo[900]),
                            ),
                            IconButton(
                              onPressed: () => delete(documentSnapshot),
                              icon: Icon(Icons.delete, color: Colors.red[900]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
                ),
        ),]),
   
       
    );
  }

  Widget myDialogBox({
    required String name,
    required String condition,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              controller: fnameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'e.g. John',
              ),
            ),
            TextField(
              controller: lnameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'e.g. Doe',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'e.g. john.doe@gmail.com',
              ),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'e.g. 123 Main St',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(condition),
            ),
          ],
        ),
      ),
    );
  }
}
