import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesPage extends ConsumerWidget {
const ExpensesPage({super.key});

IconData _categoryIcon(ExpenseCategory category) {
switch (category) {
case ExpenseCategory.food:
return Icons.restaurant_rounded;

case ExpenseCategory.transport:
return Icons.directions_car_rounded;

case ExpenseCategory.shopping:
return Icons.shopping_bag_rounded;

case ExpenseCategory.bills:
return Icons.receipt_long_rounded;

case ExpenseCategory.health:
return Icons.favorite_rounded;

case ExpenseCategory.travel:
return Icons.flight_takeoff_rounded;

case ExpenseCategory.entertainment:
return Icons.movie_rounded;

case ExpenseCategory.education:
return Icons.school_rounded;

case ExpenseCategory.other:
return Icons.category_rounded;
}
}

@override
Widget build(BuildContext context, WidgetRef ref) {
final expenses = ref.watch(expensesProvider);

return AppShell(
currentIndex: 1,
title: 'Expenses',
child: Scaffold(
backgroundColor: Colors.transparent,

body: expenses.when(
data: (items) {
final totalSpent =
items.fold<double>(0, (sum, e) => sum + e.amount);

return ListView(
padding: const EdgeInsets.all(20),
children: [
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(28),
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF4F46E5),
Color(0xFF6366F1),
],
),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const Text(
'Total Expenses',
style: TextStyle(
color: Colors.white70,
fontSize: 14,
),
),

const SizedBox(height: 10),

Text(
'₹${totalSpent.toStringAsFixed(0)}',
style: const TextStyle(
color: Colors.white,
fontSize: 34,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 6),

Text(
'${items.length} transactions',
style: const TextStyle(
color: Colors.white70,
),
),
],
),
),

const SizedBox(height: 24),

const Text(
'Recent Expenses',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 12),

if (items.isEmpty)
Card(
child: Padding(
padding: const EdgeInsets.all(32),
child: Column(
children: const [
Icon(
Icons.receipt_long_outlined,
size: 48,
),
SizedBox(height: 12),
Text(
'No expenses yet',
),
],
),
),
),

...items.map(
(expense) => Container(
margin:
const EdgeInsets.only(bottom: 12),
child: Card(
child: ListTile(
contentPadding:
const EdgeInsets.all(14),
  leading: Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .primaryContainer,
      borderRadius:
      BorderRadius.circular(16),
    ),
    child: Icon(
      _categoryIcon(
        expense.category,
      ),
    ),
  ),

  title: Text(
    expense.category.name
        .toUpperCase(),
    style: const TextStyle(
      fontWeight:
      FontWeight.w600,
    ),
  ),

  subtitle: Column(
    crossAxisAlignment:
    CrossAxisAlignment
        .start,
    children: [
      const SizedBox(
        height: 4,
      ),

      Text(
        expense.description ??
            'No description',
        maxLines: 1,
        overflow:
        TextOverflow
            .ellipsis,
      ),

      const SizedBox(
        height: 6,
      ),

      Text(
        '${expense.dateTime.day}/${expense.dateTime.month}/${expense.dateTime.year}',
        style:
        TextStyle(
          fontSize: 12,
          color: Theme.of(
              context)
              .colorScheme
              .outline,
        ),
      ),
    ],
  ),

  trailing: Column(
    mainAxisAlignment:
    MainAxisAlignment
        .center,
    crossAxisAlignment:
    CrossAxisAlignment
        .end,
    children: [
      Text(
        '₹${expense.amount.toStringAsFixed(0)}',
        style:
        const TextStyle(
          fontSize: 18,
          fontWeight:
          FontWeight
              .bold,
        ),
      ),

      const SizedBox(
        height: 4,
      ),

      Container(
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration:
        BoxDecoration(
          borderRadius:
          BorderRadius
              .circular(
            12,
          ),
          color: Theme.of(
              context)
              .colorScheme
              .secondaryContainer,
        ),
        child: Text(
          expense
              .paymentMethod
              .name
              .toUpperCase(),
          style:
          const TextStyle(
            fontSize:
            10,
            fontWeight:
            FontWeight
                .w600,
          ),
        ),
      ),
    ],
  ),
),
),
),
),
],
);
},

  loading: () => const Center(
    child:
    CircularProgressIndicator(),
  ),

  error: (e, _) => Center(
    child: Text(e.toString()),
  ),
),

  floatingActionButton:
  FloatingActionButton.extended(
    onPressed: () =>
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) =>
          const ExpenseFormSheet(),
        ),
    icon: const Icon(Icons.add),
    label: const Text(
      'Add Expense',
    ),
  ),
),
);
}
}

class ExpenseFormSheet
    extends ConsumerStatefulWidget {
  const ExpenseFormSheet({
    super.key,
  });

  @override
  ConsumerState<ExpenseFormSheet>
  createState() =>
      _ExpenseFormSheetState();
}

class _ExpenseFormSheetState
    extends ConsumerState<
        ExpenseFormSheet> {
final _formKey =
GlobalKey<FormState>();

final _amountController =
TextEditingController();

final _descriptionController =
TextEditingController();

ExpenseCategory _category =
ExpenseCategory.food;

PaymentMethod _paymentMethod =
PaymentMethod.upi;

ExpenseType _expenseType =
ExpenseType.personal;

OwedBy? _owedBy;

DateTime _selectedDateTime =
DateTime.now();

@override
Widget build(BuildContext context) {
return Padding(
padding: EdgeInsets.only(
left: 20,
right: 20,
top: 20,
bottom:
MediaQuery.of(context)
.viewInsets
.bottom +
20,
),

child: Form(
key: _formKey,

child: ListView(
shrinkWrap: true,

children: [
Text(
'New Expense',
style: Theme.of(context)
.textTheme
.headlineSmall,
),

const SizedBox(
height: 20,
),
  TextFormField(
    controller: _amountController,
    keyboardType:
    TextInputType.number,
    decoration:
    const InputDecoration(
      labelText: 'Amount',
      prefixIcon: Icon(
        Icons.currency_rupee,
      ),
    ),
    validator: (value) {
      if (value == null ||
          value.isEmpty) {
        return 'Amount is required';
      }
      return null;
    },
  ),

  const SizedBox(
    height: 12,
  ),

  DropdownButtonFormField<
      ExpenseCategory>(
    value: _category,
    decoration:
    const InputDecoration(
      labelText: 'Category',
    ),
    items:
    ExpenseCategory.values
        .map(
          (e) =>
          DropdownMenuItem(
            value: e,
            child: Text(
              e.name,
            ),
          ),
    )
        .toList(),
    onChanged: (v) =>
        setState(
              () => _category = v!,
        ),
  ),

  const SizedBox(
    height: 12,
  ),

  DropdownButtonFormField<
      PaymentMethod>(
    value: _paymentMethod,
    decoration:
    const InputDecoration(
      labelText:
      'Payment Method',
    ),
    items:
    PaymentMethod.values
        .map(
          (e) =>
          DropdownMenuItem(
            value: e,
            child: Text(
              e.name,
            ),
          ),
    )
        .toList(),
    onChanged: (v) =>
        setState(
              () => _paymentMethod =
          v!,
        ),
  ),

  const SizedBox(
    height: 12,
  ),

  DropdownButtonFormField<
      ExpenseType>(
    value: _expenseType,
    decoration:
    const InputDecoration(
      labelText:
      'Expense Type',
    ),
    items:
    ExpenseType.values
        .map(
          (e) =>
          DropdownMenuItem(
            value: e,
            child: Text(
              e.name,
            ),
          ),
    )
        .toList(),
    onChanged: (v) =>
        setState(
              () => _expenseType =
          v!,
        ),
  ),

  if (_expenseType !=
      ExpenseType.personal) ...[
    const SizedBox(
      height: 12,
    ),

    DropdownButtonFormField<
        OwedBy>(
      value: _owedBy,
      decoration:
      const InputDecoration(
        labelText:
        'Owed By',
      ),
      items: OwedBy.values
          .map(
            (e) =>
            DropdownMenuItem(
              value: e,
              child: Text(
                e.name,
              ),
            ),
      )
          .toList(),
      onChanged: (v) =>
          setState(
                () => _owedBy = v,
          ),
    ),
  ],

  const SizedBox(
    height: 12,
  ),

  TextFormField(
    controller:
    _descriptionController,
    decoration:
    const InputDecoration(
      labelText:
      'Description (Optional)',
    ),
  ),

  const SizedBox(
    height: 16,
  ),

  ListTile(
    shape:
    RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(
        18,
      ),
    ),
    tileColor: Theme.of(
        context)
        .colorScheme
        .surfaceContainerLow,
    leading: const Icon(
      Icons.schedule_rounded,
    ),
    title: const Text(
      'Date & Time',
    ),
    subtitle: Text(
      _selectedDateTime
          .toString(),
    ),
    onTap: () async {
      final date =
      await showDatePicker(
        context: context,
        firstDate:
        DateTime(2020),
        lastDate:
        DateTime(2100),
        initialDate:
        _selectedDateTime,
      );

      if (date == null ||
          !mounted) {
        return;
      }

      final time =
      await showTimePicker(
        context: context,
        initialTime:
        TimeOfDay
            .fromDateTime(
          _selectedDateTime,
        ),
      );

      if (time == null) {
        return;
      }

      setState(() {
        _selectedDateTime =
            DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
      });
    },
  ),

  const SizedBox(
    height: 24,
  ),

  FilledButton.icon(
    onPressed: () async {
      if (!_formKey
          .currentState!
          .validate()) {
        return;
      }

      final user = ref.read(
        currentUserProvider,
      )!;

      final controller =
      ref.read(
        expenseFormControllerProvider,
      );

      final expense =
      ExpenseModel(
        id: controller
            .generateId(),
        userId: user.uid,
        amount: double.parse(
          _amountController
              .text,
        ),
        category: _category,
        paymentMethod:
        _paymentMethod,
        dateTime:
        _selectedDateTime,
        expenseType:
        _expenseType,
        owedBy: _owedBy,
        description:
        _descriptionController
            .text
            .isEmpty
            ? null
            : _descriptionController
            .text,
        createdAt:
        DateTime.now(),
        updatedAt:
        DateTime.now(),
      );

      await controller
          .saveExpense(
        expense,
      );

      if (context.mounted) {
        Navigator.pop(
          context,
        );
      }
    },
    icon: const Icon(
      Icons.save_rounded,
    ),
    label: const Text(
      'Save Expense',
    ),
  ),

  const SizedBox(
    height: 12,
  ),
],
),
),
);
}
}