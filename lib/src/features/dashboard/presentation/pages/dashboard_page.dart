import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/core/widgets/app_refresh_indicator.dart';
import 'package:expense_tracker_app/src/features/budget/presentation/providers/budget_providers.dart';
import 'package:expense_tracker_app/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/src/core/theme/app_theme.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends ConsumerState<DashboardPage> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final summary =
    ref.watch(dashboardSummaryProvider);

    final budgetAsync =
    ref.watch(currentMonthBudgetProvider);

    budgetAsync.whenData((budget) {
      if (budget == null && !_dialogShown) {
        _dialogShown = true;

        WidgetsBinding.instance
            .addPostFrameCallback((_) {
          _showBudgetDialog(context);
        });
      }
    });

    return AppShell(
      currentIndex: 0,
      title: 'SpendWise',
      child: summary.when(
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                padding:
                const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(28),
                  gradient:
                  const LinearGradient(
                    colors: [
                      AppTheme.dashboardGradientStart,
                      AppTheme.dashboardGradientEnd,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Spending',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Text(
                      '₹${data.monthSpend.toStringAsFixed(0)}',
                      style:TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Budget',
                      value:'₹${data.monthBudget.toStringAsFixed(0)}',
                      icon: Icons.account_balance_wallet_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Remaining',
                      value:'₹${data.remainingBudget.toStringAsFixed(0)}',
                      icon: Icons.savings_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Daily Avg',
                      value:'₹${data.dailyAverage.toStringAsFixed(0)}',
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Paybacks',
                      value:'₹${data.pendingReimbursements.toStringAsFixed(0)}',
                      icon: Icons.payments_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Budget Utilization',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ClipRRect(
                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),
                        child:
                        LinearProgressIndicator(
                          minHeight: 12,
                          value:
                          data.utilization,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '${(data.utilization * 100).toStringAsFixed(0)}% Used',
                        style: Theme.of(
                          context,
                        )
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child:
          CircularProgressIndicator(),
        ),
        error: (e, _) =>
            Center(child: Text(e.toString())),
      ),
    );
  }

  Future<void> _showBudgetDialog(
      BuildContext context,
      ) async {
    final controller =
    TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Monthly Budget Required',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Text(
                'You must set a budget for the current month before using the app.\n\n'
                    'This can only be done once and cannot be changed later.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType:
                TextInputType.number,
                decoration:
                const InputDecoration(
                  labelText:
                  'Budget Amount',
                  prefixText: '₹ ',
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                final amount =
                    double.tryParse(
                      controller.text,
                    ) ??
                        0;

                if (amount <= 0) {
                  return;
                }

                await ref.read(
                  saveCurrentMonthBudgetProvider,
                )(amount);

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child:
              const Text('Lock Budget'),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 24,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}