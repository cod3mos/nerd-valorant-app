import 'package:flutter/material.dart';
import 'package:nerdvalorant/main.dart';
import 'package:nerdvalorant/pages/home/home.dart';
import 'package:nerdvalorant/pages/settings/settings.dart';
import 'package:nerdvalorant/pages/notifications/more_details.dart';
import 'package:nerdvalorant/pages/subscriptions/subscriptions.dart';
import 'package:nerdvalorant/pages/notifications/notifications.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
    '/verify_auth': (context) => const VerifyAuth(),
    '/more_details': (context) => const MoreDetailsPage(),
    '/notifications': (context) => const NotificationsPage(),
    '/subscriptions': (context) => const SubscriptionsPage(),
  };

  static String initialRoute = '/verify_auth';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
