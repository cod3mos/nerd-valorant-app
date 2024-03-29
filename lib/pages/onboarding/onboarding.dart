import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/keys/version.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/onboarding/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/pages/onboarding/screen_media.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentScreen = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    AnimatedContainer dotIdicador(index) {
      return AnimatedContainer(
        margin: EdgeInsets.only(right: ScreenSize.width(1.5)),
        duration: const Duration(milliseconds: 400),
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: currentScreen == index ? greenColor : whiteColor,
          shape: BoxShape.circle,
        ),
      );
    }

    setCurrentPage(index) => setState(() => currentScreen = index);

    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(screenBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width(5),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: setCurrentPage,
                    itemCount: screenMedia.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Image.asset(
                              screenMedia[index].image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  screenMedia[index].title,
                                  style: titleStyle,
                                ),
                                SizedBox(height: ScreenSize.height(1.5)),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: screenMedia[index].description,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (var path in screenMedia[index].icons)
                                      SizedBox(
                                        width: ScreenSize.width(10),
                                        height: ScreenSize.height(5),
                                        child: SvgPicture.asset(path),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => skipButton(),
                            style: skipButtonStyle,
                            child: Text(
                              'Pular',
                              style: textStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              screenMedia.length,
                              (index) => dotIdicador(index),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => nextButton(),
                            style: nextButtonStyle,
                            child: Text(
                              'Avançar',
                              style: textStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: ScreenSize.height(1)),
                      child: Text(
                        'Versão $version',
                        style: TextStyle(
                          color: whiteColor,
                        ),
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

  void skipButton() {
    context.read<LocalStorageService>().writeSeenIntro(true);
  }

  void nextButton() {
    if (currentScreen == screenMedia.length - 1) {
      context.read<LocalStorageService>().writeSeenIntro(true);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
