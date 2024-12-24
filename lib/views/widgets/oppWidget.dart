import 'dart:developer';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/models/opp_model.dart';
import 'package:volunteers_app/views/inner_screens/opp_details.dart';
import 'package:volunteers_app/views/widgets/heart_btn.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';
import 'package:volunteers_app/providers/opp_provider.dart';

class oppWidget extends StatefulWidget {
  const oppWidget({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<oppWidget> createState() => _oppWidgetState();
}

class _oppWidgetState extends State<oppWidget> {
  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<OppProvider>(context);
    final getCurrProduct = productProvider.findByOppId(widget.productId);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  OppDetails.routName,
                  arguments: getCurrProduct.OppId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.OppImage,
                      width: double.infinity,
                      height: size.height * 0.22,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TitlesTextWidget(
                          label: getCurrProduct.OppTitle,
                          maxLines: 2,
                          fontSize: 18,
                        ),
                      ),
                      const Flexible(
                        flex: 2,
                        child: Align(
                          alignment: Alignment
                              .center, // Center the HeartButtonWidget horizontally
                          child: HeartButtonWidget(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber, // Background color
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0), // Padding around the text
                            child: const Center(
                              // Center the text within the container
                              child: Text(
                                "Apply Now",
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.amber,
                            child: InkWell(
                              splashColor: Colors.red,
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.volunteer_activism,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 1,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
