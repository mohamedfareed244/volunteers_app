import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final List<String> imagePaths = [
    "assets/images/carousel-1.jpg",
    "assets/images/carousel-2.jpg",
    "assets/images/about-1.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 200.0,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                  autoplay: true,
                  itemCount: imagePaths.length,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,builder: DotSwiperPaginationBuilder(
                      color: Colors.amber,
                      activeColor: Colors.blueGrey
                    )
                  ),
                  control: SwiperControl(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}