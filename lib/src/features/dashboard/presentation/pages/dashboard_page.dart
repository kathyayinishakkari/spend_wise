import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);

    return AppShell(
    currentIndex: 0,
    title: 'SpendWise',
    child: summary.when(
    data: (data) {
    return ListView(
    padding: const EdgeInsets.all(20),
    children: [
    Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(28),
    gradient: const LinearGradient(
    colors: [
    Color(0xFF4F46E5),
    Color(0xFF6366F1),
    ],
    ),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Total Spending',
    style: TextStyle(
    color: Colors.white70,
    fontSize: 16,
    ),
    ),
    const SizedBox(height: 12),
    Text(
    '₹${data.monthSpend.toStringAsFixed(0)}',
    style: const TextStyle(
    color: Colors.white,
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
    value:
    '₹${data.monthBudget.toStringAsFixed(0)}',
    icon: Icons.account_balance_wallet_rounded,
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: _MetricCard(
    title: 'Remaining',
    value:
    '₹${data.remainingBudget.toStringAsFixed(0)}',
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
    value:
    '₹${data.dailyAverage.toStringAsFixed(0)}',
    icon: Icons.trending_up_rounded,
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: _MetricCard(
    title: 'Pending',
    value:
    '₹${data.pendingReimbursements.toStringAsFixed(0)}',
    icon: Icons.payments_rounded,
    ),
    ),
    ],
    ),

    const SizedBox(height: 24),

    Card(
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    const Text(
    'Budget Utilization',
    style: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    ),
    ),
    const SizedBox(height: 16),

    ClipRRect(
    borderRadius:
    BorderRadius.circular(10),
    child: LinearProgressIndicator(
    minHeight: 12,
    value: data.utilization,
    ),
    ),

    const SizedBox(height: 12),

    Text(
    '${(data.utilization * 100).toStringAsFixed(0)}% Used',
    style: Theme.of(context)
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
    loading: () =>
    const Center(child: CircularProgressIndicator()),
    error: (e, _) =>
    Center(child: Text(e.toString())),
    ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
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
