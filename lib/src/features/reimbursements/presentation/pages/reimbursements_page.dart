import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:flutter/material.dart';

class ReimbursementsPage extends StatelessWidget {
  const ReimbursementsPage({super.key});

  List<Reimbursement> _sampleData() => [
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
      currentIndex: 3,
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

// Keep your sample data exactly the same.
// Only replace the UI widgets.

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF10B981),
            Color(0xFFFBBF24),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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
                    leading: CircleAvatar(
                      child: Text(
                        item.owedBy.name[0]
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(
                      item.owedBy.name.toUpperCase(),
                    ),
                    subtitle: Text(
                      'Received ₹${item.receivedAmount.toStringAsFixed(0)}',
                    ),
                    trailing: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(12),
                            color:
                            item.status ==
                                ReimbursementStatus
                                    .completed
                                ? Colors.green
                                .withOpacity(.2)
                                : item.status ==
                                ReimbursementStatus
                                    .partial
                                ? Colors.orange
                                .withOpacity(.2)
                                : Colors.red
                                .withOpacity(.2),
                          ),
                          child: Text(
                            item.status.name
                                .toUpperCase(),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${item.pendingAmount.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                )
          ),
      ],
    );
  }
}