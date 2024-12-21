import 'package:volunteers_app/models/categories_model.dart';

import '../services/assets_manager.dart';

class AppConstants {
  static const String productImageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';
  static List<String> bannersImages = [

  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "events",
      image: AssetsManager.events,
      name: "events",
    ),
    CategoryModel(
      id: "donations",
      image: AssetsManager.donations,
      name: "donations",
    ),
    CategoryModel(
      id: "volunteering",
      image: AssetsManager.volunteering,
      name: "volunteering",
    ),
   
    
  ];
}
