import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker_app/src/core/theme/theme_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerWidget {
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
    (
    'Dashboard',
    '/dashboard',
    LucideIcons.layoutDashboard,
    ),
    (
    'Expenses',
    '/expenses',
    LucideIcons.receipt,
    ),
    (
    'Analytics',
    '/analytics',
    LucideIcons.chartPie,
    ),
    (
    'More',
    '/more',
    LucideIcons.menu,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref,) {
    final isDark =Theme.of(context).brightness ==Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Theme',
            onPressed: () {
              final notifier =
              ProviderScope.containerOf(
                context,
              ).read(
                themeModeProvider.notifier,
              );

              notifier.state =
              isDark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
            icon: Icon(
              isDark
                  ? LucideIcons.sun
                  : LucideIcons.moon,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: child,

      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(
          12,
          0,
          12,
          12,
        ),
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: currentIndex,
              labelBehavior:NavigationDestinationLabelBehavior.alwaysShow,

            onDestinationSelected: (index) {
              context.go(
                _items[index].$2,
              );
            },

            destinations: _items
                .map(
                  (item) =>
                  NavigationDestination(
                    icon: Icon(
                      item.$3,
                      color: Colors.grey,
                    ),
                    selectedIcon: Icon(
                      item.$3,
                      color: Colors.white,
                    ),
                    label: item.$1,
                  ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}