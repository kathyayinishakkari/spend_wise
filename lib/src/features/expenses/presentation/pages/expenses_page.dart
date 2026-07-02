import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/core/widgets/app_refresh_indicator.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/widgets/expense_form_sheet.dart';
import 'package:expense_tracker_app/src/core/provider/date_provider.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker_app/src/core/theme/app_theme.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  static const _categoryIcons = {
    ExpenseCategory.food: Icons.restaurant_rounded,
    ExpenseCategory.transport: Icons.directions_car_rounded,
    ExpenseCategory.shopping: Icons.shopping_bag_rounded,
    ExpenseCategory.bills: Icons.receipt_long_rounded,
    ExpenseCategory.health: Icons.favorite_rounded,
    ExpenseCategory.travel: Icons.flight_takeoff_rounded,
    ExpenseCategory.entertainment: Icons.movie_rounded,
    ExpenseCategory.education: Icons.school_rounded,
    ExpenseCategory.other: Icons.category_rounded,
  };

  static const _categoryColors = {
    ExpenseCategory.food: AppTheme.food,
    ExpenseCategory.transport: AppTheme.transport,
    ExpenseCategory.shopping: AppTheme.shopping,
    ExpenseCategory.bills: AppTheme.bills,
    ExpenseCategory.health: AppTheme.health,
    ExpenseCategory.travel: AppTheme.travel,
    ExpenseCategory.entertainment: AppTheme.entertainment,
    ExpenseCategory.education: AppTheme.education,
    ExpenseCategory.other: AppTheme.other,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    final now = ref.watch(currentDateProvider);

    return AppShell(
      currentIndex: 1,
      title: 'Expenses',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: expenses.when(
          data: (items) {
            final currentMonthItems = items.where((e) {
              return e.dateTime.year == now.year && e.dateTime.month == now.month;
            }).toList();

            final total = currentMonthItems.fold<double>(0, (sum, e) => sum + e.amount);
            
            return ListView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _TotalExpensesCard(total: total, count: currentMonthItems.length),
                const SizedBox(height: 24),
                const Text('Recent Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (currentMonthItems.isEmpty) const _EmptyState(),
                ...currentMonthItems.map((expense) => _ExpenseItem(expense: expense)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => const ExpenseFormSheet(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add Expense'),
        ),
      ),
    );
  }
}

class _TotalExpensesCard extends StatelessWidget {
  final double total;
  final int count;
  const _TotalExpensesCard({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.dashboardGradientStart, AppTheme.dashboardGradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.dashboardGradientStart.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Expenses',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₹${total.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count Transactions',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 48),
            SizedBox(height: 12),
            Text('No expenses yet'),
          ],
        ),
      ),
    );
  }
}

class _ExpenseItem extends ConsumerWidget {
  final dynamic expense;
  const _ExpenseItem({required this.expense});

  String _getEnumName(dynamic enumValue) {
    return enumValue.toString().split('.').last;
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expense Actions'),
        content: const Text('Would you like to modify or delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (_) => ExpenseFormSheet(expense: expense as ExpenseModel),
              );
            },
            child: const Text('Modify'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to permanently delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(expenseRepositoryProvider).deleteExpense(expense.userId, expense.id);
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryColor = ExpensesPage._categoryColors[expense.category] ?? theme.colorScheme.primary;

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                ExpensesPage._categoryIcons[expense.category],
                color: categoryColor,
                size: 26,
              ),
            ),
            title: Text(
              _getEnumName(expense.category).toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  expense.description ?? 'No description',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getEnumName(expense.expenseType).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy').format(expense.dateTime),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${expense.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    _getEnumName(expense.paymentMethod).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            onPressed: () => _showActions(context, ref),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
