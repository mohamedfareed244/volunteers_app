import 'package:flutter/cupertino.dart';

class WishlistModel with ChangeNotifier {
  final String id, OppsId;

  WishlistModel({
    required this.id,
    required this.OppsId,
  });
}
