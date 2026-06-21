import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentIndex,
    required this.title,
    required this.child,
  });

  final int currentIndex;
  final String title;
  final Widget child;

  static const _items = [
    ('Dashboard', '/dashboard', Icons.dashboard_rounded),
    ('Expenses', '/expenses', Icons.receipt_long_rounded),
    ('Calendar', '/calendar', Icons.calendar_month_rounded),
    ('Budget', '/budget', Icons.account_balance_wallet_rounded),
    ('Reimburse', '/reimbursements', Icons.payments_rounded),
    ('Analytics', '/analytics', Icons.pie_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),

    body: child,

    bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        labelBehavior:
        NavigationDestinationLabelBehavior.onlyShowSelected,

        onDestinationSelected: (index) {
      context.go(_items[index].$2);
    },

    destinations: _items
        .map(
    (item) => NavigationDestination(
    icon: Icon(item.$3),
    label: item.$1,
    ),
    )
        .toList(),
    ),
    );

  }
}
