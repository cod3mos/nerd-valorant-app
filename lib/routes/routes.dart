import 'package:flutter/material.dart';
import 'package:nerdvalorant/pages/login/login.dart';
import 'package:nerdvalorant/pages/onboarding/onboarding.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/onboarding': (context) => const OnboardingPage(),
    '/login': (context) => const LoginPage(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
