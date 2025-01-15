import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/providers/wishlist_provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    Key? key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  }) : super(key: key);

  final double size;
  final Color color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isFavorite = wishlistProvider.isProductInWishlist(
      OppId: widget.productId,
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        onPressed: () {
          wishlistProvider.addOrRemoveFromWishlist(
            OppId: widget.productId,
          );
        },
        icon: Icon(
          isFavorite ? IconlyBold.heart : IconlyLight.heart,
          size: widget.size,
          color: isFavorite ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
