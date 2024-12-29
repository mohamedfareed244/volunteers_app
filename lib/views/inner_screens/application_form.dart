import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/application.dart';
import 'package:volunteers_app/models/user.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});
  static const routName = '/ApplicationForm';

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  UserModel? userModel;
  String? opportunityTitle;
  bool isLoading = true;

  Future<void> fetchData(User user, String opportunityId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await getUser(user);
      await getOpportunityTitle(opportunityId);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveApplication(Application application) async {
    try {
      await FirebaseFirestore.instance.collection("applications").doc(application.appId).set(
        application.toJson(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Application submitted successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error saving application: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getUser(User user) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        userModel = UserModel.fromMap(userDoc);
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> getOpportunityTitle(String opportunityId) async {
    try {
      final opportunityDoc = await FirebaseFirestore.instance
          .collection("opportunitites")
          .doc(opportunityId)
          .get();

      if (opportunityDoc.exists) {
        opportunityTitle = opportunityDoc['oppTitle'];
      }
    } catch (e) {
      print("Error fetching opportunity: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final String opportunityId = ModalRoute.of(context)?.settings.arguments as String;

    // Fetch data when the widget builds
    if (isLoading && user != null) {
      fetchData(user, opportunityId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Form"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (opportunityTitle != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            "Opportunity: $opportunityTitle",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const Text(
                        "Personal Data",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _firstNameController..text = userModel?.firstName ?? '',
                        decoration: const InputDecoration(
                          labelText: "First Name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController..text = userModel?.email ?? '',
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController..text = userModel?.address ?? '',
                        decoration: const InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Skills & Motivation",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _skillsController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Relevant Skills",
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please describe your relevant skills";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _motivationController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Why Are You Interested?",
                          prefixIcon: Icon(Icons.edit_document),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please explain why you are interested";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 80),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final application = Application(
                                  userId: userModel!.uid,
                                  opportunityId: opportunityId,
                                  userEmail: userModel!.email,
                                  status: "Pending",
                                  applicationDate: DateTime.now(),
                                  relevantSkills: _skillsController.text,
                                  interestReason: _motivationController.text,
                                  opportunityTitle: opportunityTitle);
                              saveApplication(application);
                            }
                          },
                          label: const Text(
                            "Submit Application",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            backgroundColor: Colors.orange[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _skillsController.dispose();
    _motivationController.dispose();
    super.dispose();
  }
}
