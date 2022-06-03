import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)?.settings.arguments ?? 'Login';

    ScreenSize.init(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: blackColor,
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: blackColor,
                  ),
                  child: Text(
                    'Voltar para tela de introdução',
                    style: TextStyle(color: whiteColor),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/onboarding'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
