import 'package:expense_tracker_app/src/features/analytics/presentation/pages/analytics_page.dart';
import 'package:expense_tracker_app/src/features/budget/presentation/pages/budget_page.dart';
import 'package:expense_tracker_app/src/features/calendar/presentation/pages/calendar_page.dart';
import 'package:expense_tracker_app/src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/pages/expenses_page.dart';
import 'package:expense_tracker_app/src/features/reimbursements/presentation/pages/reimbursements_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/src/features/more/presentation/pages/more_page.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/expenses', builder: (_, __) => const ExpensesPage()),
      GoRoute(path: '/calendar', builder: (_, __) => const CalendarPage()),
      GoRoute(path: '/budget', builder: (_, __) => const BudgetPage()),
      GoRoute(path: '/reimbursements', builder: (_, __) => const ReimbursementsPage()),
      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsPage()),
      GoRoute(path: '/more', builder: (_, __) => const MorePage()),
    ],
  );
});