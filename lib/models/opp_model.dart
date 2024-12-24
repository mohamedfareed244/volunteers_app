import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OppModel with ChangeNotifier {
  final String OppId, OppTitle, OppDescription, OppImage;
  Timestamp? createdAt;

  OppModel({
    required this.OppId,
    required this.OppTitle,
    required this.OppDescription,
    required this.OppImage,
    this.createdAt,
  });

  get productCategory => null;
}
