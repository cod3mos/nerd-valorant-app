import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments ?? 'Login';

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
                label: const Text('Realizar login'),
                onPressed: () => navigation(context, '/onboarding'),
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
    Navigator.pushNamed(
      context,
      destiny,
    );
  }
}
