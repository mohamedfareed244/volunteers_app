import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';

import 'heart_btn.dart';

class recentlyAddedWidget extends StatelessWidget {
  const recentlyAddedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {},
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/carousel-1.jpg', // Replace with your placeholder image path
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title " * 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          const HeartButtonWidget(),
                          InkWell(
                            splashColor: Colors.amber,
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Apply Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const FittedBox(
                      child: SubtitleTextWidget(
                        label: "Recently Added",
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
