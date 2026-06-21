import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:flutter/material.dart';

class ReimbursementsPage extends StatelessWidget {
  const ReimbursementsPage({super.key});

  List<Reimbursement> _sampleData() => const [
    Reimbursement(
      id: 'r1',
      userId: 'demo-user',
      expenseId: 'e1',
      totalAmount: 1800,
      receivedAmount: 600,
      status: ReimbursementStatus.partial,
      owedBy: OwedBy.friend,
      createdAt: DateTime(2026, 6, 5),
    ),
    Reimbursement(
      id: 'r2',
      userId: 'demo-user',
      expenseId: 'e2',
      totalAmount: 950,
      receivedAmount: 0,
      status: ReimbursementStatus.pending,
      owedBy: OwedBy.mom,
      createdAt: DateTime(2026, 6, 10),
    ),
    Reimbursement(
      id: 'r3',
      userId: 'demo-user',
      expenseId: 'e3',
      totalAmount: 1200,
      receivedAmount: 1200,
      status: ReimbursementStatus.completed,
      owedBy: OwedBy.sis,
      createdAt: DateTime(2026, 6, 2),
      settledAt: DateTime(2026, 6, 12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _sampleData();
    final pending = items.where((e) => e.status == ReimbursementStatus.pending).toList();
    final partial = items.where((e) => e.status == ReimbursementStatus.partial).toList();
    final completed = items.where((e) => e.status == ReimbursementStatus.completed).toList();

    return AppShell(
      currentIndex: 4,
      title: 'Reimbursements',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(
            title: 'Pending amount',
            value: items.fold<double>(0, (sum, item) => sum + item.pendingAmount).toStringAsFixed(2),
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: 16),
          _StatusSection(title: 'Pending', items: pending),
          const SizedBox(height: 16),
          _StatusSection(title: 'Partial', items: partial),
          const SizedBox(height: 16),
          _StatusSection(title: 'Completed & settlements', items: completed),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.title, required this.items});

  final String title;
  final List<Reimbursement> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Card(child: ListTile(title: Text('No records')))
        else
          ...items.map(
                (item) => Card(
              child: ListTile(
                title: Text(item.owedBy.name.toUpperCase()),
                subtitle: Text('Total: ${item.totalAmount.toStringAsFixed(2)} • Received: ${item.receivedAmount.toStringAsFixed(2)}'),
                trailing: Text(item.pendingAmount.toStringAsFixed(2)),
              ),
            ),
          ),
      ],
    );
  }
}