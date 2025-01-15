import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/controllers/my_app_method.dart';
import 'package:volunteers_app/services/assets_manager.dart';
import 'package:volunteers_app/views/widgets/empty_fav.dart';
import 'package:volunteers_app/views/widgets/oppWidget.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';


import '../../providers/wishlist_provider.dart';


class WishlistScreen extends StatelessWidget {
  static const routName = '/favorites';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.volunteering,
              title: "Your Favorites is empty",
              subtitle:
                  'Looks like you didn\'t add anything yet to your favorites page \ngo ahead and start exploring now',
              buttonText: "Explore Now",
            ),
          )
        : Scaffold(
  body: Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            MyAppMethods.showErrorORWarningDialog(
              isError: false,
              context: context,
              subtitle: "Remove items",
              fct: () {
                wishlistProvider.clearLocalWishlist();
              },
            );
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
        ),
      ),
      Expanded(
        child: DynamicHeightGridView(
          itemCount: wishlistProvider.getWishlistItems.length,
          builder: ((context, index) {
            return oppWidget(
              productId: wishlistProvider.getWishlistItems.values
                  .toList()[index]
                  .OppsId,
            );
          }),
          crossAxisCount: 2,
        ),
      ),
    ],
  ),
);
  }
}
