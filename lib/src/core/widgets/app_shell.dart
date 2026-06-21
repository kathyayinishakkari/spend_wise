import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.currentIndex, required this.title, required this.child});
  final int currentIndex;
  final String title;
  final Widget child;

  static const _items = [
    ('Dashboard', '/dashboard', Icons.dashboard_outlined),
    ('Expenses', '/expenses', Icons.receipt_long_outlined),
    ('Calendar', '/calendar', Icons.calendar_month_outlined),
    ('Budget', '/budget', Icons.account_balance_wallet_outlined),
    ('Reimburse', '/reimbursements', Icons.payments_outlined),
    ('Analytics', '/analytics', Icons.bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => context.go(_items[index].$2),
        destinations: _items.map((item) => NavigationDestination(icon: Icon(item.$3), label: item.$1)).toList(),
      ),
    );
  }
}