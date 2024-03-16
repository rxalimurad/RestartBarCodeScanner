import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/Constants.dart';

class AppIntro extends StatelessWidget {
  saveAppIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('appIntro', true);
  }

  var listPagesViewModel = [
    PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "Let's Go Shopping for School/Home Resources",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "RESTART ",
                style: TextStyle(
                  color: darkRedColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                style: TextStyle(
                  fontSize: 18,
                ),
                text:
                    "takes the guesswork out of shopping for school/home resources.\n\n"
                    "You'll become an empowered shopper with the information in this app! ",
              ),
            ],
          ),
        ),
      ),
      image: Center(
        child: Image.asset('assets/logo.png', height: 200.0),
      ),
      decoration: const PageDecoration(
        pageColor: CupertinoColors.white,
      ),
    ),
    PageViewModel(
      titleWidget: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Have ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: "RESTART",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color:
                        darkRedColor, // Setting the color of "RESTART" to red
                  ),
                ),
                TextSpan(
                  text: " on the go. When in doubt, just scan it! ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center, // Center aligning the text
          )),
      bodyWidget: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                  fontSize: 18,
                ),
                text:
                    "Wondering if an item is useful for your classroom or home? Just point your camera, scan the barcode and get an answer immediately. Award winning educators have reviewed the educational items.",
              ),
            ],
          ),
        ),
      ),
      image: Center(
        child: Image.asset('assets/logo.png', height: 200.0),
      ),
      decoration: const PageDecoration(
        pageColor: CupertinoColors.white,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      showSkipButton: true,
      showNextButton: false,
      skip: const Text("Skip"),
      done: const Text("Done"),
      onDone: () {
        saveAppIntro();
        Get.offAllNamed("/LoginScreen");
      },
    );
  }
}
