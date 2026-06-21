import 'package:collection/collection.dart';
import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.byCategory,
    required this.byMonth,
    required this.highestCategory,
    required this.highestMonth,
  });

  final Map<String, double> byCategory;
  final Map<String, double> byMonth;
  final String highestCategory;
  final String highestMonth;
}

final analyticsRangeProvider = StateProvider<AnalyticsRange>((ref) => AnalyticsRange.currentMonth);

final analyticsSummaryProvider = Provider<AsyncValue<AnalyticsSummary>>((ref) {
  final expensesAsync = ref.watch(expensesProvider);
  return expensesAsync.whenData((expenses) {
    final byCategory = <String, double>{};
    final byMonth = <String, double>{};

    for (final e in expenses) {
      byCategory.update(e.category.name, (value) => value + e.amount, ifAbsent: () => e.amount);
      final monthKey = '${e.dateTime.year}-${e.dateTime.month.toString().padLeft(2, '0')}';
      byMonth.update(monthKey, (value) => value + e.amount, ifAbsent: () => e.amount);
    }

    final highestCategory = byCategory.entries.sorted((a, b) => b.value.compareTo(a.value)).firstOrNull?.key ?? 'n/a';
    final highestMonth = byMonth.entries.sorted((a, b) => b.value.compareTo(a.value)).firstOrNull?.key ?? 'n/a';

    return AnalyticsSummary(
      byCategory: byCategory,
      byMonth: byMonth,
      highestCategory: highestCategory,
      highestMonth: highestMonth,
    );
  });
});