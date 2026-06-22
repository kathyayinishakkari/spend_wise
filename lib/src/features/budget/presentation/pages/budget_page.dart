import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/budget/presentation/providers/budget_providers.dart';
import 'package:expense_tracker_app/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync =
    ref.watch(currentMonthBudgetProvider);

    final dashboardAsync =
    ref.watch(dashboardSummaryProvider);

    return AppShell(
      currentIndex: 3,
      title: 'Budget',
      child: budgetAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (budget) {
          if (budget == null) {
            return const Center(
              child: Text(
                'No budget found for this month.',
              ),
            );
          }

          return dashboardAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              child: Text(error.toString()),
            ),
            data: (summary) {
              final budgetAmount =
                  budget.amount;

              final spent =
                  summary.monthSpend;

              final remaining =
                  budgetAmount - spent;

              final progress =
              budgetAmount <= 0
                  ? 0.0
                  : (spent / budgetAmount)
                  .clamp(0.0, 1.0);

              return ListView(
                padding:
                const EdgeInsets.all(20),
                children: [
                  Container(
                    padding:
                    const EdgeInsets.all(
                      24,
                    ),
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius
                          .circular(
                        28,
                      ),
                      gradient:
                      const LinearGradient(
                        colors: [
                          Color(
                            0xFF1E3A8A,
                          ),
                          Color(
                            0xFF1E293B,
                          ),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        const Text(
                          'Monthly Budget',
                          style:
                          TextStyle(
                            color: Colors
                                .white70,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '₹${budgetAmount.toStringAsFixed(0)}',
                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize: 34,
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Card(
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .all(20),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'Budget Utilization',
                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          LinearProgressIndicator(
                            value:
                            progress,
                            minHeight:
                            12,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}% used',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title:
                          'Spent',
                          value:
                          '₹${spent.toStringAsFixed(0)}',
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: _StatCard(
                          title:
                          'Remaining',
                          value:
                          '₹${remaining.toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Card(
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .all(20),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'Current Month',
                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                              fontSize:
                              18,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ListTile(
                            contentPadding:
                            EdgeInsets
                                .zero,
                            leading:
                            const Icon(
                              Icons
                                  .calendar_month_rounded,
                            ),
                            title: Text(
                              budget
                                  .monthKey,
                            ),
                            subtitle:
                            const Text(
                               'Expected budget for current month',
                            ),
                            trailing:
                            Text(
                              '₹${budgetAmount.toStringAsFixed(0)}',
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(title),
            const SizedBox(
              height: 8,
            ),
            Text(
              value,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}