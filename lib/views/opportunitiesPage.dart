import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/opp_model.dart';
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

  List<OppModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final oppProvider = Provider.of<OppProvider>(context);

    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    final List<OppModel> oppList = passedCategory == null
        ? oppProvider.getOpp
        : oppProvider.findByCategory(ctgName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: oppList.isEmpty
              ? const Center(
                  child: TitlesTextWidget(label: "No result found"),
                )
              : StreamBuilder<List<OppModel>>(
                  stream: oppProvider.fetchOppsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: TitlesTextWidget(
                          label: snapshot.error.toString(),
                        ),
                      );
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: TitlesTextWidget(
                          label: "No opportunities has been added",
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            controller: searchTextController,
                            decoration: InputDecoration(
                              hintText: "Search",
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
                            onChanged: (value) {
                              setState(() {
                                productListSearch = oppProvider.searchQuery(
                                    searchText: searchTextController.text);
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                productListSearch = oppProvider.searchQuery(
                                    searchText: searchTextController.text);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          if (searchTextController.text.isNotEmpty &&
                              productListSearch.isEmpty) ...[
                            const Center(
                                child: TitlesTextWidget(
                              label: "No results found",
                              fontSize: 40,
                            ))
                          ],
                          Expanded(
                            child: DynamicHeightGridView(
                              itemCount: searchTextController.text.isNotEmpty
                                  ? productListSearch.length
                                  : oppList.length,
                              builder: ((context, index) {
                                return oppWidget(
                                  productId:
                                      searchTextController.text.isNotEmpty
                                          ? productListSearch[index].OppId
                                          : oppList[index].OppId,
                                );
                              }),
                              crossAxisCount: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
    );
  }
}
