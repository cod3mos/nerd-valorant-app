import 'package:flutter/cupertino.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nerdvalorant/mobile/local_notifications.dart';

class FirebaseMessageService {
  List<NotifyDetails> notificationsStorage = LocalStorage.readNotifications();

  final NotificationService _notificationService;

  FirebaseMessageService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(_getOfflineMessage);

    _onMessage();
  }

  _onMessage() async {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showNotification(
          NotifyDetails(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '/notifications',
            dateTime: DateTime.now(),
          ),
        );
      }
    });
  }

  _getOfflineMessage(message) async {
    if (message != null) {
      RemoteNotification? notification = message.notification;
      String pageRoute = message.data['route'] ?? '/notifications';
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        notificationsStorage.add(
          NotifyDetails(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: pageRoute,
            dateTime: DateTime.now(),
          ),
        );

        await LocalStorage.writeNotifications(notificationsStorage);

        Navigator.of(Routes.navigatorKey.currentContext!).pushNamed(pageRoute);
      }
    }
  }
}
