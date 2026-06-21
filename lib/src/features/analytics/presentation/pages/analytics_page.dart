import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
    case 'food':
    return const Color(0xFF06B6D4);
    case 'transport':
    return const Color(0xFF0EA5E9);

    case 'shopping':
    return const Color(0xFF8B5CF6);

    case 'bills':
    return const Color(0xFFF97316);

    case 'health':
    return const Color(0xFF22C55E);

    case 'travel':
    return const Color(0xFF14B8A6);

    case 'entertainment':
    return const Color(0xFFEC4899);

    case 'education':
    return const Color(0xFF6366F1);

    default:
    return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(
      analyticsSummaryProvider,
    );
    return AppShell(
    currentIndex: 2,
    title: 'Analytics',
    child: analytics.when(
    data: (data) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
    Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    borderRadius:
    BorderRadius.circular(24),
    gradient:
    const LinearGradient(
    colors: [
    Color(0xFF06B6D4),
    Color(0xFF22D3EE),
    ],
    ),
    ),
    child: Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    const Text(
    'Top Category',
    style: TextStyle(
    color: Colors.white70,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    data.highestCategory
        .toUpperCase(),
    style: const TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight:
    FontWeight.bold,
    ),
    ),
    ],
    ),
    ),

    const SizedBox(height: 24),

    Text(
    'Category Breakdown',
    style: Theme.of(context)
        .textTheme
        .titleLarge,
    ),

    const SizedBox(height: 12),

    Card(
    child: SizedBox(
    height: 300,
    child: PieChart(
    PieChartData(
    sectionsSpace: 4,
    centerSpaceRadius: 50,
    sections: data
        .byCategory.entries
        .map(
    (e) =>
    PieChartSectionData(
    value: e.value,
    title: e.key,
    radius: 90,
    color:
    getCategoryColor(
    e.key,
    ),
    titleStyle:
    const TextStyle(
    color:
    Colors.white,
    fontWeight:
    FontWeight
        .bold,
    fontSize: 11,
    ),
    ),
    )
        .toList(),
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),

    Wrap(
    spacing: 12,
    runSpacing: 10,
    children: data
        .byCategory.keys
        .map(
    (category) => Row(
    mainAxisSize:
    MainAxisSize.min,
    children: [
    Container(
    width: 12,
    height: 12,
    decoration:
    BoxDecoration(
    shape:
    BoxShape.circle,
    color:
    getCategoryColor(
    category,
    ),
    ),
    ),
    const SizedBox(
    width: 6,
    ),
    Text(category),
    ],
    ),
    )
        .toList(),
    ),

    const SizedBox(height: 24),

    Text(
    'Monthly Spending',
    style: Theme.of(context)
        .textTheme
        .titleLarge,
    ),

    const SizedBox(height: 12),

    Card(
    child: SizedBox(
    height: 300,
    child: Padding(
    padding:
    const EdgeInsets.all(
    12,
    ),
    child: BarChart(
    BarChartData(
    gridData:
    const FlGridData(
    show: false,
    ),
    borderData:
    FlBorderData(
    show: false,
    ),
    barGroups: data
        .byMonth.entries
        .toList()
        .asMap()
        .entries
        .map(
    (entry) =>
    BarChartGroupData(
    x: entry.key,
    barRods: [
    BarChartRodData(
    toY: entry
        .value
        .value,
    color:
    const Color(
    0xFF06B6D4,
    ),
    width: 20,
    borderRadius:
    BorderRadius
        .circular(
    8,
    ),
    ),
    ],
    ),
    )
        .toList(),
    ),
    ),
    ),
    ),
    ),

    const SizedBox(height: 20),

    Row(
    children: [
    Expanded(
    child: Card(
    child: Padding(
    padding:
    const EdgeInsets.all(
    18,
    ),
    child: Column(
    children: [
    const Icon(
    Icons
        .trending_up_rounded,
    color: Color(
    0xFF06B6D4,
    ),
    ),
    const SizedBox(
    height: 10,
    ),
    const Text(
    'Top Category',
    ),
    Text(
    data
        .highestCategory,
    style:
    const TextStyle(
    fontWeight:
    FontWeight
        .bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Card(
    child: Padding(
    padding:
    const EdgeInsets.all(
    18,
    ),
    child: Column(
    children: [
    const Icon(
    Icons
        .calendar_month_rounded,
    color: Color(
    0xFF06B6D4,
    ),
    ),
    const SizedBox(
    height: 10,
    ),
    const Text(
    'Top Month',
    ),
    Text(
    data.highestMonth,
    style:
    const TextStyle(
    fontWeight:
    FontWeight
        .bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    loading: () => const Center(
    child:
    CircularProgressIndicator(),
    ),
    error: (error, _) => Center(
    child: Text(error.toString()),
    ),
    ),
    );
    }
}
