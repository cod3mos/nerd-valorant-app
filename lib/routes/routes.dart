import 'package:flutter/material.dart';
import 'package:nerdvalorant/main.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/verify_auth': (context) => const VerifyAuth(),
  };

  static String initialRoute = '/verify_auth';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
