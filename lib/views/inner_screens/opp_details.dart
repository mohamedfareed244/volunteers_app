import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/controllers/ChatsController.dart';
import 'package:volunteers_app/models/opp_model.dart';
import 'package:volunteers_app/providers/opp_provider.dart';
import 'package:volunteers_app/views/inner_screens/application_form.dart';
import 'package:volunteers_app/views/widgets/subtitle_text.dart';
import 'package:volunteers_app/views/widgets/title_text.dart';
import 'package:volunteers_app/views/widgets/heart_btn.dart';

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

    final oppProvider = Provider.of<OppProvider>(context, listen: false);
    final oppId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrOpp = oppProvider.findByOppId(oppId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
      ),
      body: getCurrOpp == null
          ? const SizedBox.shrink()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      FancyShimmerImage(
                        imageUrl: getCurrOpp.OppImage,
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
                                  child: Text(
                                    getCurrOpp.OppTitle,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            ApplicationForm.routName,
                                            arguments: oppId,
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.volunteer_activism),
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
                              children:  [
                                TitlesTextWidget(
                                    label: "About this Opportunity"),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SubtitleTextWidget(
                              label: getCurrOpp.OppDescription,
                            ),
                            const SizedBox(height: 100), // Spacer
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    onPressed:(){
                     StartNewChat(oppId,context);
                    } ,
                    backgroundColor: Colors.blue,
                    icon: const Icon(Icons.chat),
                    label: const Text("Chat"),
                  ),
                ),
              ],
            ),
    );
  }
}
