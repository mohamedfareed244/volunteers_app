import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/models/opp_model.dart';



class ProductProvider with ChangeNotifier {
  List<ProductModel> get getProducts {
    return _products;
  }
    ProductModel? findByProdId(String productId) {
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return _products.firstWhere((element) => element.productId == productId);
  }

  final List<ProductModel> _products = [

    ProductModel(
      //4
      productId: const Uuid().v4(),
      productTitle:
          "dskdwlfjeij",
      productDescription:
          "About this item\n6.8 inch Dynamic AMOLED 2X display with a 3200 x 1440 resolution\n256GB internal storage, 12GB RAM\n108MP triple camera system with 100x Space Zoom and laser autofocus\n40MP front-facing camera with dual pixel AF\n5000mAh battery with fast wireless charging and wireless power share\n5G capable for lightning fast download and streaming",
      productImage:
          "https://media.gettyimages.com/id/1498170916/photo/a-couple-is-taking-a-bag-of-food-at-the-food-and-clothes-bank.jpg?s=612x612&w=gi&k=20&c=OQXzpRYIt4_vr0b2tTz9Wsz8aCPi9FgUBwGSEeJaToM=",
    ),
    ProductModel(
      //5
      productId: const Uuid().v4(),
      productTitle:
          "Samsun"*5,
      productDescription:
          "About this item\nPro Grade Camera: Zoom in close with 100X Space Zoom, and take photos and videos like a pro with our easy-to-use, multi-lens camera.\n100x Zoom: Get amazing clarity with a dual lens combo of 3x and 10x optical zoom, or go even further with our revolutionary 100x Space Zoom.\nHighest Smartphone Resolution: Crystal clear 108MP allows you to pinch, crop and zoom in on your photos to see tiny, unexpected details, while lightning-fast Laser Focus keeps your focal point clear\nAll Day Intelligent Battery: Intuitively manages your cellphone’s usage, so you can go all day without charging (based on average battery life under typical usage conditions).\nPower of 5G: Get next-level power for everything you love to do with Samsung Galaxy 5G; More sharing, more gaming, more experiences and never miss a beat",
      productImage:
          "https://www.shutterstock.com/image-photo/happy-volunteer-portrait-people-park-260nw-2507688333.jpg",
    ),
    ProductModel(
      //6
      productId: const Uuid().v4(),
      productTitle:
          "Morning Mist",
      productDescription:
          "About this item\n6.7 inch LTPO Fluid2 AMOLED, 1B colors, 120Hz, HDR10+, 1300 nits (peak)\n256GB internal storage, 12GB RAM\nQuad rear camera: 48MP, 50MP, 8MP, 2MP\n16MP front-facing camera\n4500mAh battery with Warp Charge 65T (10V/6.5A) and 50W Wireless Charging\n5G capable for lightning fast download and streaming",
      productImage:
          "https://media.istockphoto.com/id/1625310710/photo/happy-group-of-volunteer-people-stacking-hands-celebrating-together-outdoor-teamwork-and.jpg?s=612x612&w=0&k=20&c=KrkTdMYjObaAhhwzsTnHf8dIDpdmc5pvAujfCl6riXU=",
    ),


  ];
}
