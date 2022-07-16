import 'package:flutter/cupertino.dart';
import 'package:nerdvalorant/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nerdvalorant/pages/home/home.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:nerdvalorant/pages/settings/settings.dart';
import 'package:nerdvalorant/pages/pixels/youtube_player.dart';
import 'package:nerdvalorant/pages/notifications/more_details.dart';
import 'package:nerdvalorant/pages/subscriptions/subscriptions.dart';
import 'package:nerdvalorant/pages/notifications/notifications.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final uri = Uri.parse(routeSettings.name!);
    final params = uri.queryParameters;
    final routeName = uri.path;

    switch (routeName) {
      case '/home':
        return CupertinoPageRoute(builder: (_) => const HomePage());

      case '/verify_auth':
        return CupertinoPageRoute(builder: (_) => const VerifyAuth());

      case '/notifications':
        return CupertinoPageRoute(builder: (_) => const NotificationsPage());

      case '/subscriptions':
        return CupertinoPageRoute(builder: (_) => const SubscriptionsPage());

      case '/youtube_player':
        return CupertinoPageRoute(
          builder: (_) {
            return YoutubeVideoPlayer(
              videoId: routeSettings.arguments as String,
            );
          },
        );

      case '/pixel':
        return CupertinoPageRoute(
          builder: (_) {
            return YoutubeVideoPlayer(
              videoId: params['id']!,
            );
          },
        );

      case '/more_details':
        return CupertinoPageRoute(
          builder: (_) {
            return MoreDetailsPage(
              notify: routeSettings.arguments as NotifyDetails,
            );
          },
        );

      case '/settings':
        return CupertinoPageRoute(
          builder: (_) {
            return SettingsPage(
              userData: routeSettings.arguments as User,
            );
          },
        );

      default:
        return CupertinoPageRoute(builder: (_) => const VerifyAuth());
    }
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
