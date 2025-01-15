import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/models/user.dart';

class Application {
  final String appId; // ID of the application
  final String userId; // ID of the user applying
  final String opportunityId; // ID of the opportunity
  final String? userEmail; // Email of the user (optional)
  final String? opportunityTitle; // Title of the opportunity (optional)
  String status; // Status of the application, e.g., "pending"
  final DateTime applicationDate; // Timestamp for when the application was submitted
  final String relevantSkills; // Relevant skills provided by the user
  final String interestReason;
  UserModel? user;   // Why the user is interested in the opportunity

  Application({
    required this.userId,
    required this.opportunityId,
    this.userEmail,
    this.opportunityTitle,
    required this.status ,
    required this.applicationDate,
    required this.relevantSkills,
    required this.interestReason,
     String? appId, 
     this.user,
  }):appId= appId ?? const Uuid().v4();

  // Convert Application object to a map for Firestore
  toJson() {
    return {
      'appId': appId,
      'userId': userId,
      'opportunityId': opportunityId,
      'userEmail': userEmail,
      'opportunityTitle': opportunityTitle,
      'status': status,
      'applicationDate': applicationDate,
      'relevantSkills': relevantSkills,
      'interestReason': interestReason,
    };
  }

  // Create Application object from Firestore document snapshot
  factory Application.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> DcoumentSnapshot) {
    return Application(
      appId: DcoumentSnapshot.id,
      userId: DcoumentSnapshot.data()!['userId'] ,
      opportunityId: DcoumentSnapshot.data()!['opportunityId'] ,
      userEmail: DcoumentSnapshot.data()!['userEmail'] ,
      opportunityTitle: DcoumentSnapshot.data()!['opportunityTitle'] ,
      status: DcoumentSnapshot.data()!['status'] ,
      applicationDate: (DcoumentSnapshot.data()!['applicationDate'] as Timestamp).toDate(),
      relevantSkills: DcoumentSnapshot.data()!['relevantSkills'],
      interestReason: DcoumentSnapshot.data()!['interestReason'] ,
    );
  }
}
