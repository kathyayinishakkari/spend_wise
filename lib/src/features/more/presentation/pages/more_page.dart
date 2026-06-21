import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 3,
      title: 'More',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _MenuCard(
            title: 'Calendar',
            icon: Icons.calendar_month_rounded,
            onTap: () => context.push('/calendar'),
          ),

          const SizedBox(height: 12),

          _MenuCard(
            title: 'Budget',
            icon: Icons.account_balance_wallet_rounded,
            onTap: () => context.push('/budget'),
          ),

          const SizedBox(height: 12),

          _MenuCard(
            title: 'Reimbursements',
            icon: Icons.payments_rounded,
            onTap: () => context.push('/reimbursements'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}