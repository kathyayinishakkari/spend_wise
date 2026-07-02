import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';
import 'package:expense_tracker_app/src/features/budget/presentation/providers/budget_providers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  // Configuration Thresholds
  static const double largeExpenseThreshold = 5000.0;
  static const int inactivityThresholdDays = 5;
  static const int pendingPaybackThresholdDays = 7;

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: androidSettings);
      await notifications.initialize(settings);
      
      // Schedule daily reminder
      await scheduleDailyReminder();
    } catch (e) {
      print('Notification initialization error: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String channelId = 'expense_tracker_channel',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      'SpendWise Notifications',
      channelDescription: 'Core application alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  /// One-line entry point to check all periodic/background notifications
  Future<void> checkAll(Ref ref) async {
    await checkBudgetNotifications(ref);
    await checkInactivity(ref);
    await checkMonthEnd(ref);
    await checkWeeklySummary(ref);
    await checkStreaks(ref);
    await checkPendingPaybacks(ref);
    await checkMissingBudget(ref);
  }

  // 1. Budget Alerts
  Future<void> checkBudgetNotifications(Ref ref) async {
    final summary = ref.read(dashboardSummaryProvider).valueOrNull;
    if (summary == null || summary.monthBudget <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);
    final percent = (summary.monthSpend / summary.monthBudget) * 100;

    // 60% before 15th
    if (percent >= 60 && now.day <= 15 && !_hasSent(prefs, 'budget60_$monthKey')) {
      await showNotification(id: 60, title: 'Budget Alert', body: 'You have used 60% of your budget before mid-month. Slow down!');
      await _markSent(prefs, 'budget60_$monthKey');
    }

    // 90%
    if (percent >= 90 && !_hasSent(prefs, 'budget90_$monthKey')) {
      await showNotification(id: 90, title: 'Budget Alert', body: 'Caution! You have used 90% of your monthly budget.');
      await _markSent(prefs, 'budget90_$monthKey');
    }

    // 100%
    if (percent >= 100 && !_hasSent(prefs, 'budget100_$monthKey')) {
      await showNotification(id: 100, title: 'Budget Exhausted', body: 'You have reached 100% of your budget limit.');
      await _markSent(prefs, 'budget100_$monthKey');
    }

    // Overspend (Every overspend - use transaction hash or total to avoid spamming every second)
    if (percent > 100) {
      final overspent = summary.monthSpend - summary.monthBudget;
      if (!_hasSent(prefs, 'overspent_${overspent.toInt()}_$monthKey')) {
         await showNotification(id: 101, title: 'Overspending Alert', body: 'You are ₹${overspent.toStringAsFixed(0)} over your budget!');
         await _markSent(prefs, 'overspent_${overspent.toInt()}_$monthKey');
      }
    }
  }

  // 2. Inactivity Reminder (5 days)
  Future<void> checkInactivity(Ref ref) async {
    final expenses = ref.read(expensesProvider).valueOrNull;
    if (expenses == null || expenses.isEmpty) return;

    final lastExpense = expenses.first.dateTime;
    final diff = DateTime.now().difference(lastExpense).inDays;

    if (diff >= inactivityThresholdDays) {
      final prefs = await SharedPreferences.getInstance();
      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (!_hasSent(prefs, 'inactivity_$todayKey')) {
        await showNotification(id: 200, title: 'Missed you!', body: 'You haven\'t logged an expense in 5 days. Keep your tracking streak alive!');
        await _markSent(prefs, 'inactivity_$todayKey');
      }
    }
  }

  // 3. Month End Reminders
  Future<void> checkMonthEnd(Ref ref) async {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    if (now.month == nextDay.month) return; // Not last day

    final prefs = await SharedPreferences.getInstance();
    final monthKey = DateFormat('yyyy-MM').format(now);

    if (!_hasSent(prefs, 'month_end_$monthKey')) {
      await showNotification(
        id: 300, 
        title: 'Monthly Wrap-up', 
        body: 'It\'s the last day of the month! Set next month\'s budget and review your analytics.'
      );
      await _markSent(prefs, 'month_end_$monthKey');
    }
  }

  // 4. Weekly Summary (Every Sunday)
  Future<void> checkWeeklySummary(Ref ref) async {
    final now = DateTime.now();
    if (now.weekday != DateTime.sunday) return;

    final prefs = await SharedPreferences.getInstance();
    final weekKey = '${DateFormat('yyyy-MM').format(now)}-W${(now.day / 7).ceil()}';

    if (!_hasSent(prefs, 'weekly_$weekKey')) {
      final expenses = ref.read(expensesProvider).valueOrNull ?? [];
      final last7Days = now.subtract(const Duration(days: 7));
      final total = expenses
          .where((e) => e.dateTime.isAfter(last7Days))
          .fold<double>(0, (sum, e) => sum + e.amount);

      await showNotification(id: 400, title: 'Weekly Summary', body: 'You spent ₹${total.toStringAsFixed(0)} this week. Check your details in Analytics.');
      await _markSent(prefs, 'weekly_$weekKey');
    }
  }

  // 5. Streaks
  Future<void> checkStreaks(Ref ref) async {
    final expenses = ref.read(expensesProvider).valueOrNull ?? [];
    if (expenses.isEmpty) return;

    // Simplified streak calc: unique days with expenses
    final days = expenses.map((e) => DateFormat('yyyy-MM-dd').format(e.dateTime)).toSet().length;
    final prefs = await SharedPreferences.getInstance();

    if ((days == 7 || days == 30 || days == 100) && !_hasSent(prefs, 'streak_$days')) {
      await showNotification(id: 500, title: 'Incredible Streak!', body: 'Congratulations! You\'ve logged expenses for $days days.');
      await _markSent(prefs, 'streak_$days');
    }
  }

  // 6. Large Expense Alert
  Future<void> checkLargeExpense(double amount) async {
    if (amount >= largeExpenseThreshold) {
      await showNotification(id: 600, title: 'Large Expense Logged', body: 'You just logged a ₹${amount.toStringAsFixed(0)} expense. Remember to stay within your limits!');
    }
  }

  // 7. Payback Alerts
  Future<void> checkPendingPaybacks(Ref ref) async {
    final reimbursements = ref.read(reimbursementsProvider).valueOrNull ?? [];
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    for (final r in reimbursements) {
      if (r.status == ReimbursementStatus.completed) continue;
      
      final age = now.difference(r.createdAt).inDays;
      
      // Older than 7 days
      if (age >= pendingPaybackThresholdDays && !_hasSent(prefs, 'payback_old_${r.id}')) {
        await showNotification(id: 700 + r.hashCode, title: 'Pending Payback', body: 'Reminder: ₹${(r.totalAmount - r.receivedAmount).toStringAsFixed(0)} is still pending from ${r.personName}.');
        await _markSent(prefs, 'payback_old_${r.id}');
      }

      // Partially paid after 3/7 days
      if (r.status == ReimbursementStatus.partial) {
        if ((age == 3 || age == 7) && !_hasSent(prefs, 'payback_partial_${r.id}_$age')) {
          await showNotification(id: 701 + r.hashCode, title: 'Partial Payback', body: 'Follow up: ${r.personName} has only partially paid back for the shared expense.');
          await _markSent(prefs, 'payback_partial_${r.id}_$age');
        }
      }
    }
  }

  Future<void> onPaybackReceived(String personName, double amount) async {
    await showNotification(id: 702, title: 'Payback Received', body: 'Great! You received ₹${amount.toStringAsFixed(0)} from $personName.');
  }

  // 8. Missing Budget
  Future<void> checkMissingBudget(Ref ref) async {
    final budget = ref.read(currentMonthBudgetProvider).valueOrNull;
    if (budget == null) {
      final prefs = await SharedPreferences.getInstance();
      final monthKey = DateFormat('yyyy-MM').format(DateTime.now());
      if (!_hasSent(prefs, 'missing_budget_$monthKey')) {
        await showNotification(id: 800, title: 'Budget Required', body: 'You haven\'t set a budget for this month yet. Set it now to track better!');
        await _markSent(prefs, 'missing_budget_$monthKey');
      }
    }
  }

  // 9. Daily 8 PM Reminder
  Future<void> scheduleDailyReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Nightly check-ins',
      importance: Importance.low,
      priority: Priority.low,
    );

    await notifications.zonedSchedule(
      888,
      'Daily Check-in',
      'Don\'t forget to log your expenses for today!',
      scheduledDate,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  bool _hasSent(SharedPreferences prefs, String key) => prefs.getBool(key) ?? false;
  Future<void> _markSent(SharedPreferences prefs, String key) => prefs.setBool(key, true);
}
