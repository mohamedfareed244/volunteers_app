import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OppModel with ChangeNotifier {
  final String OppId, OppTitle, OppDescription, OppImage,Orgid;
  Timestamp? createdAt;

  OppModel({
    required this.OppId,
    required this.OppTitle,
    required this.OppDescription,
    required this.OppImage,
    this.createdAt,
    required this.Orgid
  });

  get productCategory => null;



  factory OppModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OppModel(
      OppId: data['oppId'],
      OppTitle: data['oppTitle'],
      OppDescription: data['oppDescription'],
      OppImage: data['oppImage'],
      createdAt: data['createdAt'],
      Orgid: data["orgid"]
    );
  }
}
