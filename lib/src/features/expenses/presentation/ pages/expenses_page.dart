import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    return AppShell(
      currentIndex: 1,
      title: 'Expenses',
      child: Scaffold(
        body: expenses.when(
          data: (items) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final e = items[index];
              return Card(
                child: ListTile(
                  title: Text(e.category.name),
                  subtitle: Text(e.description ?? 'No description'),
                  trailing: Text(e.amount.toStringAsFixed(2)),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const ExpenseFormSheet(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add expense'),
        ),
      ),
    );
  }
}

class ExpenseFormSheet extends ConsumerStatefulWidget {
  const ExpenseFormSheet({super.key});

  @override
  ConsumerState<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends ConsumerState<ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  PaymentMethod _paymentMethod = PaymentMethod.upi;
  ExpenseType _expenseType = ExpenseType.personal;
  OwedBy? _owedBy;
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('New expense', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) => (value == null || value.isEmpty) ? 'Amount is required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _category,
              items: ExpenseCategory.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _paymentMethod,
              items: PaymentMethod.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _expenseType,
              items: ExpenseType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              onChanged: (v) => setState(() => _expenseType = v!),
            ),
            if (_expenseType != ExpenseType.personal) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<OwedBy>(
                value: _owedBy,
                hint: const Text('Owed by'),
                items: OwedBy.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                onChanged: (v) => setState(() => _owedBy = v),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description (optional)')),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date and time'),
              subtitle: Text(_selectedDateTime.toString()),
              trailing: const Icon(Icons.schedule),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: _selectedDateTime,
                );
                if (date == null || !mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                );
                if (time == null) return;
                setState(() => _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute));
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final user = ref.read(currentUserProvider)!;
                final controller = ref.read(expenseFormControllerProvider);
                final expense = ExpenseModel(
                  id: controller.generateId(),
                  userId: user.uid,
                  amount: double.parse(_amountController.text),
                  category: _category,
                  paymentMethod: _paymentMethod,
                  dateTime: _selectedDateTime,
                  expenseType: _expenseType,
                  owedBy: _owedBy,
                  description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await controller.saveExpense(expense);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save expense'),
            ),
          ],
        ),
      ),
    );
  }
}
