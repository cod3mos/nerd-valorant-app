import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments ?? 'Intro';

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$arguments',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              TextButton.icon(
                label: const Text('Finalizar Tutorial'),
                onPressed: () => navigation(context, '/login'),
                icon: const Icon(
                  Icons.navigate_before,
                  color: Colors.red,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigation(context, destiny) {
    LocalStorage.writeBool(key: 'seenIntro', data: true);

    Navigator.pushNamed(
      context,
      destiny,
    );
  }
}
