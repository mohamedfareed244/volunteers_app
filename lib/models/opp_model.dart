import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProductModel with ChangeNotifier {
  final String productId, productTitle, productDescription, productImage; 
   Timestamp? createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productDescription,
    required this.productImage,
      this.createdAt,
  });

  get productCategory => null;
}
