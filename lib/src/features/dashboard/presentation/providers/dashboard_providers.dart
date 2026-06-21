import 'package:expense_tracker_app/src/features/budget/presentation/providers/budget_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.monthSpend,
    required this.monthBudget,
    required this.remainingBudget,
    required this.dailyAverage,
    required this.utilization,
    required this.pendingReimbursements,
  });

  final double monthSpend;
  final double monthBudget;
  final double remainingBudget;
  final double dailyAverage;
  final double utilization;
  final double pendingReimbursements;
}

final reimbursementsStateProvider =
StateProvider<List<Reimbursement>>(
      (ref) => const [],
);

final dashboardSummaryProvider =
Provider<AsyncValue<DashboardSummary>>(
      (ref) {
    final expensesAsync =
    ref.watch(expensesProvider);

    final budgetAsync =
    ref.watch(currentMonthBudgetProvider);

    final reimbursements =
    ref.watch(
      reimbursementsStateProvider,
    );

    return expensesAsync.whenData(
          (expenses) {
        final now = DateTime.now();

        final monthly = expenses.where(
              (e) =>
          e.dateTime.year == now.year &&
              e.dateTime.month == now.month,
        ).toList();

        final spend = monthly.fold<double>(
          0,
              (sum, e) => sum + e.amount,
        );

        final pending =
        reimbursements.fold<double>(
          0,
              (sum, r) =>
          sum + r.pendingAmount,
        );

        final budget =
            budgetAsync.valueOrNull;

        final budgetAmount =
            budget?.amount ?? 0;

        return DashboardSummary(
          monthSpend: spend,
          monthBudget: budgetAmount,
          remainingBudget:
          budgetAmount - spend,
          dailyAverage:
          monthly.isEmpty
              ? 0
              : spend / now.day,
          utilization:
          budgetAmount <= 0
              ? 0
              : (spend / budgetAmount)
              .clamp(0.0, 1.0),
          pendingReimbursements:
          pending,
        );
      },
    );
  },
);