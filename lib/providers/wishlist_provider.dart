import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/models/wishlist_model.dart';
import 'package:volunteers_app/db_helper.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};
  final DBHelper _dbHelper = DBHelper();

  Map<String, WishlistModel> get getWishlistItems => _wishlistItems;

  // Initialize the wishlist from the local database
  Future<void> loadWishlistFromDB() async {
    final data = await _dbHelper.getWishlistItems();
    for (var item in data) {
      _wishlistItems[item['oppId']] = WishlistModel(
        id: item['id'],
        OppsId: item['oppId'],
      );
    }
    print('Loaded wishlist from database: ${_wishlistItems.keys}');

    notifyListeners();
  }

  bool isProductInWishlist({required String OppId}) {
    return _wishlistItems.containsKey(OppId);
  }

  Future<void> addOrRemoveFromWishlist({required String OppId}) async {
    if (_wishlistItems.containsKey(OppId)) {
      _wishlistItems.remove(OppId);
      await _dbHelper.removeWishlistItem(OppId);
      print('Removed from wishlist: $OppId');
    } else {
      final newItem = WishlistModel(
        id: const Uuid().v4(),
        OppsId: OppId,
      );
      _wishlistItems[OppId] = newItem;
      await _dbHelper.insertWishlistItem(newItem.id, newItem.OppsId);
      print('Added to wishlist: $OppId');
    }
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
