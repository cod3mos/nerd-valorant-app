import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nerdvalorant/keys/version.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/login/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(screenBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  logoNerdValorant,
                  width: ScreenSize.width(60),
                  height: ScreenSize.screenHeight * .65,
                ),
                SizedBox(
                  width: 280,
                  height: 48,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: ScreenSize.width(7),
                          height: ScreenSize.width(7),
                          child: SvgPicture.asset(iconGoogle),
                        ),
                        SizedBox(
                          width: ScreenSize.width(5),
                        ),
                        Text(
                          'Entrar com o google',
                          style: googleButtonStyle,
                        ),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/onboarding'),
                  ),
                ),
                SizedBox(
                  width: ScreenSize.screenWidth * .8,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Ao tocar em entrar, você concorda com os nossos ',
                          style: termStyle,
                        ),
                        TextSpan(
                          text: 'Termos',
                          style: linkStyle,
                        ),
                        TextSpan(
                          text:
                              '. Saiba como processamos seus dados em nossa  ',
                          style: termStyle,
                        ),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: linkStyle,
                        ),
                        TextSpan(
                          text: '.',
                          style: termStyle,
                        ),
                      ],
                    ),
                  ),
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
        ),
      ),
    );
  }
}
