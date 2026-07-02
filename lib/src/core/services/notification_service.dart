import 'package:expense_tracker_app/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin notifications =  FlutterLocalNotificationsPlugin();
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'expense_tracker_channel',
      'Expense Tracker',
      channelDescription: 'Expense Tracker Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
      ),
    );
  }

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);
  }
  Future<void> checkBudgetNotifications(Ref ref) async {
    final summary =
        ref.read(dashboardSummaryProvider).valueOrNull;

    if (summary == null || summary.monthBudget <= 0) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final monthKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final percent =
        (summary.monthSpend / summary.monthBudget) * 100;

    if (percent >= 60 &&
        now.day <= 15 &&
        !(prefs.getBool('budget60_$monthKey') ?? false)) {
      await showNotification(
        id: 60,
        title: 'Budget Alert',
        body:
        'You have already used 60% of your monthly budget.',
      );

      await prefs.setBool(
        'budget60_$monthKey',
        true,
      );
    }

    if (percent >= 90 &&
        !(prefs.getBool('budget90_$monthKey') ?? false)) {
      await showNotification(
        id: 90,
        title: 'Budget Alert',
        body:
        'You have used 90% of your monthly budget.',
      );

      await prefs.setBool(
        'budget90_$monthKey',
        true,
      );
    }

    if (percent >= 100 &&
        !(prefs.getBool('budget100_$monthKey') ?? false)) {
      await showNotification(
        id: 100,
        title: 'Budget Exhausted',
        body:
        'You have reached your monthly budget.',
      );

      await prefs.setBool(
        'budget100_$monthKey',
        true,
      );
    }

    if (percent > 100) {
      await showNotification(
        id: now.millisecondsSinceEpoch,
        title: 'Budget Exceeded',
        body:
        'You are ₹${(summary.monthSpend - summary.monthBudget).toStringAsFixed(0)} over budget.',
      );
    }
  }

}