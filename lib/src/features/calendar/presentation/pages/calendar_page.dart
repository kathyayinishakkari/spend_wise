import 'package:expense_tracker_app/src/core/provider/date_provider.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/pages/expenses_page.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    final selectedExpenses = expenses
        .where(
          (expense) =>
      _selectedDay != null &&
          isSameDay(expense.dateTime, _selectedDay),
    )
        .toList();

    return AppShell(
      currentIndex: 3,
      title: 'Calendar',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2100),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    isSameDay(_selectedDay, day),
                eventLoader: (day) => expenses
                    .where(
                      (expense) =>
                      isSameDay(expense.dateTime, day),
                )
                    .toList(),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (_) => ExpenseFormSheet(
                  initialDateTime:
                  _selectedDay ??
                      ref.watch(currentDateProvider),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Expense'),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text('Selected Date'),

                  const SizedBox(height: 8),
                  Text(
                    _selectedDay == null
                        ? ''
                        : DateFormat(
                      'dd MMM yyyy',
                    ).format(
                      _selectedDay!,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ...selectedExpenses.map(
                (expense) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.receipt_long_rounded,
                ),
                title: Text(
                  expense.category.name,
                ),
                subtitle: Text(
                  expense.description ?? '',
                ),
                trailing: Text(
                  '₹${expense.amount.toStringAsFixed(0)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}