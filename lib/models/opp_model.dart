import 'package:flutter/material.dart';


class ProductModel with ChangeNotifier {
  final String productId, productTitle, productDescription, productImage;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productDescription,
    required this.productImage,
  });

  get productCategory => null;
}
