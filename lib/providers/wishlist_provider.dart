import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  bool isProductInWishlist({required String OppId}) {
    return _wishlistItems.containsKey(OppId);
  }

  void addOrRemoveFromWishlist({required String OppId}) {
    if (_wishlistItems.containsKey(OppId)) {
      _wishlistItems.remove(OppId);
    } else {
      _wishlistItems.putIfAbsent(
        OppId,
        () => WishlistModel(
          id: const Uuid().v4(),
          OppsId: OppId,
        ),
      );
    }

    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
