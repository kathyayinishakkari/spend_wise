import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flutterLocalNotificationsPluginProvider =
Provider<FlutterLocalNotificationsPlugin>((ref) => FlutterLocalNotificationsPlugin());

final notificationInitializerProvider = FutureProvider<void>((ref) async {
  final messaging = ref.watch(firebaseMessagingProvider);
  final local = ref.watch(flutterLocalNotificationsPluginProvider);

  await messaging.requestPermission();
  await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Budget and reimbursement alerts',
    importance: Importance.max,
  );

  await local
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'Budget and reimbursement alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
});