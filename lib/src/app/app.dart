import 'package:expense_tracker_app/src/core/router/app_router.dart';
import 'package:expense_tracker_app/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/src/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseApp extends ConsumerWidget {
  const ExpenseApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}