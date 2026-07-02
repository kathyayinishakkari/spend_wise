import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/core/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flutterLocalNotificationsPluginProvider =
Provider<FlutterLocalNotificationsPlugin>((ref) => FlutterLocalNotificationsPlugin());

final notificationInitializerProvider = FutureProvider<void>((ref) async {
  final messaging = ref.watch(firebaseMessagingProvider);
  
  await NotificationService.instance.initialize();
  
  await messaging.requestPermission();
  await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  // Initial data check
  await NotificationService.instance.checkAll(ref);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      NotificationService.instance.showNotification(
        id: notification.hashCode,
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    }
  });
});