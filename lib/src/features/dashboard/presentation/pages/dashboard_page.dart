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
      title: 'Dashboard',
      child: summary.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricCard(title: 'Month spending', value: data.monthSpend.toStringAsFixed(2)),
                _MetricCard(title: 'Month budget', value: data.monthBudget.toStringAsFixed(2)),
                _MetricCard(title: 'Remaining', value: data.remainingBudget.toStringAsFixed(2)),
                _MetricCard(title: 'Daily average', value: data.dailyAverage.toStringAsFixed(2)),
                _MetricCard(title: 'Pending reimbursements', value: data.pendingReimbursements.toStringAsFixed(2)),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Budget utilization'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: data.utilization),
                    const SizedBox(height: 8),
                    Text('${(data.utilization * 100).toStringAsFixed(0)}% used'),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(title), const SizedBox(height: 8), Text(value, style: Theme.of(context).textTheme.headlineSmall)],
          ),
        ),
      ),
    );
  }
}