import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/pages/expenses_page.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesProvider).value ?? const [];
    final selectedExpenses = expenses.where((e) => _selectedDay != null && isSameDay(e.dateTime, _selectedDay)).toList();

    return AppShell(
      currentIndex: 2,
      title: 'Calendar',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2100),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) => expenses.where((e) => isSameDay(e.dateTime, day)).toList(),
              onDaySelected: (selected, focused) => setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              }),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ExpenseFormSheet(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add expense for selected date'),
          ),
          const SizedBox(height: 12),
          ...selectedExpenses.map(
                (e) => Card(
              child: ListTile(
                title: Text(e.category.name),
                subtitle: Text(e.description ?? ''),
                trailing: Text(e.amount.toStringAsFixed(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}