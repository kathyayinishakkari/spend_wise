import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 3,
      title: 'Budget',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Current month budget'),
              subtitle: const Text('35000.00'),
              trailing: FilledButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Budget history', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...const [
            ('2026-06', '35000.00'),
            ('2026-05', '32000.00'),
            ('2026-04', '30000.00'),
          ].map(
                (item) => Card(
              child: ListTile(
                title: Text(item.$1),
                trailing: Text(item.$2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Budget vs actual spending'),
              subtitle: const Text('Budget: 35000.00 • Actual: 18450.00 • Remaining: 16550.00'),
            ),
          ),
        ],
      ),
    );
  }
}