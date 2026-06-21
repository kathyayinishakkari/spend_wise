import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsSummaryProvider);
    return AppShell(
      currentIndex: 5,
      title: 'Analytics',
      child: analytics.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Category breakdown', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: SizedBox(
                height: 260,
                child: PieChart(
                  PieChartData(
                    sections: data.byCategory.entries
                        .map(
                          (e) => PieChartSectionData(
                        value: e.value,
                        title: e.key,
                        radius: 90,
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Monthly spending', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(show: true),
                    barGroups: data.byMonth.entries.toList().asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [BarChartRodData(toY: entry.value.value, width: 18)],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Highest spending category'),
                subtitle: Text(data.highestCategory),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Highest spending month'),
                subtitle: Text(data.highestMonth),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}