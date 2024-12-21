import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:volunteers_app/views/inner_screens/opp_details.dart';
import 'package:volunteers_app/views/widgets/heart_btn.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';

class oppWidget extends StatefulWidget {
  const oppWidget({super.key});

  @override
  State<oppWidget> createState() => _oppWidgetState();
}

class _oppWidgetState extends State<oppWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: ()async {
        await  Navigator.pushNamed(context, OppDetails.routName);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/images/carousel-1.jpg',
                width: double.infinity,
                height: size.height * 0.22,
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitlesTextWidget(label: "Title " * 10),
                ),
               const Flexible(
                  child:HeartButtonWidget (
                    color:Colors.amber,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 3,
                  child: SubtitleTextWidget(
                      label:
                          "come and start now come and start now come and start now "),
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
                        child: Text('Apply Now'),
                      ),
                    ),
                  ),
                ),
              ],
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
