import 'package:volunteers_app/models/categories_model.dart';

import 'assets_manager.dart';

class AppConstants {
  static const String productImageUrl =
      'https://media.gettyimages.com/id/1498170916/photo/a-couple-is-taking-a-bag-of-food-at-the-food-and-clothes-bank.jpg?s=612x612&w=gi&k=20&c=OQXzpRYIt4_vr0b2tTz9Wsz8aCPi9FgUBwGSEeJaToM=';
  static List<String> bannersImages = [

  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "events",
      image: AssetsManager.events,
      name: "Events",
    ),
    CategoryModel(
      id: "donations",
      image: AssetsManager.donations,
      name: "Workshops",
    ),
    CategoryModel(
      id: "volunteering",
      image: AssetsManager.volunteering,
      name: "Volunteering",
    ),
   
    
  ];
}
