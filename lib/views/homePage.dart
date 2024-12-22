import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/providers/opp_provider.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';
import 'package:volunteers_app/views/widgets/recentlyAddedWidget.dart';
import 'package:volunteers_app/views/services/assets_manager.dart';
import 'package:volunteers_app/views/services/app_constants.dart';
import 'package:volunteers_app/views/widgets/ctg_rounded_widget.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: ClipRRect(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        'assets/images/carousel-1.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    itemCount: 3,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const TitlesTextWidget(
                label: "Recently Added",
                fontSize: 22,
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                   itemCount: 10,
                   itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: productProvider.getProducts[index],
                          child: const recentlyAddedWidget());
                    }),
              ),
              const SizedBox(
                height: 18,
              ),
              const TitlesTextWidget(
                label: "Services",
                fontSize: 22,
              ),
              const SizedBox(
                height: 18,
              ),
              GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(AppConstants.categoriesList.length,
                      (index) {
                    return CategoryRoundedWidget(
                      image: AppConstants.categoriesList[index].image,
                      name: AppConstants.categoriesList[index].name,
                    );
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
