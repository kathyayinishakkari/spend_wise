import 'package:expense_tracker_app/src/features/budget/presentation/providers/budget_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:expense_tracker_app/src/core/provider/date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';

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

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final expensesAsync = ref.watch(expensesProvider);
  final budgetAsync = ref.watch(currentMonthBudgetProvider);
  final reimbursementsAsync = ref.watch(reimbursementsProvider);

  // Combine multiple AsyncValues into one
  if (expensesAsync.isLoading || budgetAsync.isLoading || reimbursementsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (expensesAsync.hasError) {
    return AsyncError(expensesAsync.error!, expensesAsync.stackTrace!);
  }
  if (budgetAsync.hasError) {
    return AsyncError(budgetAsync.error!, budgetAsync.stackTrace!);
  }
  if (reimbursementsAsync.hasError) {
    return AsyncError(reimbursementsAsync.error!, reimbursementsAsync.stackTrace!);
  }

  final expenses = expensesAsync.requireValue;
  final budget = budgetAsync.requireValue;
  final reimbursements = reimbursementsAsync.value ?? const <Reimbursement>[];
  
  final now = ref.watch(currentDateProvider);

  final monthly = expenses.where(
    (e) => e.dateTime.year == now.year && e.dateTime.month == now.month,
  ).toList();

  final spend = monthly.fold<double>(0, (sum, e) => sum + e.amount);

  final pending = reimbursements.fold<double>(
    0,
    (sum, r) => sum + (r.totalAmount - r.receivedAmount),
  );

  final budgetAmount = budget?.amount ?? 0;

  return AsyncData(DashboardSummary(
    monthSpend: spend,
    monthBudget: budgetAmount,
    remainingBudget: budgetAmount - spend,
    dailyAverage: monthly.isEmpty ? 0 : spend / now.day,
    utilization: budgetAmount <= 0 ? 0 : (spend / budgetAmount).clamp(0.0, 1.0),
    pendingReimbursements: pending,
  ));
});
