import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';
import 'package:volunteers_app/views/widgets/heart_btn.dart';
import 'package:volunteers_app/views/widgets/recentlyAddedWidget.dart';
import 'package:volunteers_app/views/services/assets_manager.dart';
import 'package:volunteers_app/views/services/app_constants.dart';
import 'package:volunteers_app/views/widgets/ctg_rounded_widget.dart';


class OppDetails extends StatefulWidget {
  static const routName = '/OpportunityDetails';
  const OppDetails({super.key});

  @override
  State<OppDetails> createState() => _OppDetailsState();
}

class _OppDetailsState extends State<OppDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero, // Remove padding from IconButton
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          FancyShimmerImage(
            imageUrl: AppConstants.productImageUrl,
            height: size.height * 0.38,
            width: double.infinity,
            boxFit: BoxFit.contain,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      // flex: 5,
                      child: Text(
                        "Title " * 16,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                   
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HeartButtonWidget(
                        color: Colors.amber.shade300,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: kBottomNavigationBarHeight - 10,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                              ),
                            ),
                            onPressed: () {},
                           icon: const Icon(Icons.people),
                            label: const Text(
                              "Apply Now",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitlesTextWidget(label: "About this Event"),
                  
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                SubtitleTextWidget(label: "description " * 15),
              ],
            ),
          )
        ],
      ),
    );
  }
}
