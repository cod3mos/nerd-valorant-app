import 'package:flutter/material.dart';
import 'package:nerdvalorant/routes/routes.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final LocalStorageService _localStorage;
  late AndroidNotificationDetails androidDetails;
  late FlutterLocalNotificationsPlugin localNotifications;

  NotificationService(this._localStorage) {
    localNotifications = FlutterLocalNotificationsPlugin();

    _initializeNotifications();
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('icon_notification');

    await localNotifications.initialize(
      const InitializationSettings(android: android),
      onSelectNotification: _onSelectNotification,
    );
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey.currentContext!).pushNamed(payload);
    }
  }

  Future<void> checkForNotify() async {
    final details = await localNotifications.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }
  }

  showNotification(NotifyDetails notification) async {
    List<NotifyDetails> notifications = _localStorage.localNotifications;

    androidDetails = const AndroidNotificationDetails(
      'notificacoes_firebase',
      'notificacoes',
      channelDescription: 'Canal de notificações via firebase',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    notifications.add(notification);

    localNotifications.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
      payload: notification.payload,
    );

    await _localStorage.writeNotifications(notifications);

    notifyListeners();
  }
}
