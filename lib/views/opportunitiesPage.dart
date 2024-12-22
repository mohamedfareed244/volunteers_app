import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/providers/opp_provider.dart';
import 'package:volunteers_app/views/services/assets_manager.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';
import 'package:volunteers_app/views/widgets/oppWidget.dart';

class opportunitiesPage extends StatefulWidget {
  const opportunitiesPage({super.key});

  @override
  State<opportunitiesPage> createState() => _opportunitiesPageState();
}

class _opportunitiesPageState extends State<opportunitiesPage> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    
         child: Scaffold(

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // setState(() {
                        searchTextController.clear();
                        FocusScope.of(context).unfocus();
                        // });
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                  onSubmitted: (value) {
                    log(searchTextController.text);
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: DynamicHeightGridView(
                    itemCount: productProvider.getProducts.length,
                    builder: ((context, index) {
                      return ChangeNotifierProvider.value(
                        value: productProvider.getProducts[index],
                        child: oppWidget(
                          productId:
                              productProvider.getProducts[index].productId,
                        ),
                      );
                    }),
                    crossAxisCount: 2,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
