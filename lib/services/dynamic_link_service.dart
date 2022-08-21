import 'package:flutter/material.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService extends ChangeNotifier {
  Future checkForLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _openDeepLink(data);

    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) => _openDeepLink(dynamicLinkData),
    );
  }

  _openDeepLink(PendingDynamicLinkData? data) {
    if (data != null) {
      Navigator.of(Routes.navigatorKey.currentContext!).popAndPushNamed(
        data.link.path,
        arguments: data.link.queryParameters['id'],
      );
    }
  }
}
