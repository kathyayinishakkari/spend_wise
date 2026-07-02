import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseFormSheet extends ConsumerStatefulWidget {
  const ExpenseFormSheet({
    super.key,
    this.initialDateTime,
    this.expense,
  });

  final DateTime? initialDateTime;
  final ExpenseModel? expense;

  @override
  ConsumerState<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends ConsumerState<ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _personController;
  late final TextEditingController _myShareController;

  late ExpenseCategory _category;
  late PaymentMethod _paymentMethod;
  late ExpenseType _expenseType;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense?.amount.toString());
    _descriptionController = TextEditingController(text: widget.expense?.description);
    _personController = TextEditingController(text: widget.expense?.personName);
    _myShareController = TextEditingController(text: widget.expense?.myShare?.toString());

    _category = widget.expense?.category ?? ExpenseCategory.food;
    _paymentMethod = widget.expense?.paymentMethod ?? PaymentMethod.upi;
    _expenseType = widget.expense?.expenseType ?? ExpenseType.personal;
    _selectedDateTime = widget.expense?.dateTime ?? widget.initialDateTime ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _personController.dispose();
    _myShareController.dispose();
    super.dispose();
  }

  // ... rest of the helper methods ...

  InputDecoration _getInputDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              letterSpacing: 1.1,
            ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
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

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  static const _categoryIcons = {
    ExpenseCategory.food: Icons.restaurant_rounded,
    ExpenseCategory.transport: Icons.directions_car_rounded,
    ExpenseCategory.shopping: Icons.shopping_bag_rounded,
    ExpenseCategory.bills: Icons.receipt_long_rounded,
    ExpenseCategory.health: Icons.favorite_rounded,
    ExpenseCategory.travel: Icons.flight_rounded,
    ExpenseCategory.entertainment: Icons.movie_rounded,
    ExpenseCategory.education: Icons.school_rounded,
    ExpenseCategory.other: Icons.category_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.expense != null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 56,
              child: FilledButton.icon(
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text(
                  'Save Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final user = ref.read(currentUserProvider);
                  if (user == null) return;

                  final controller = ref.read(expenseFormControllerProvider);
                  final totalAmount = double.parse(_amountController.text);

                  final isEditing = widget.expense != null;
                  final expense = ExpenseModel(
                    id: isEditing ? widget.expense!.id : controller.generateId(),
                    userId: user.uid,
                    amount: totalAmount,
                    category: _category,
                    paymentMethod: _paymentMethod,
                    expenseType: _expenseType,
                    dateTime: _selectedDateTime,
                    personName: _personController.text.trim().isEmpty
                        ? null
                        : _personController.text.trim(),
                    myShare: _expenseType == ExpenseType.shared
                        ? double.parse(_myShareController.text)
                        : null,
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    createdAt: isEditing ? widget.expense!.createdAt : DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  final navigator = Navigator.of(context);
                  if (isEditing) {
                    await ref.read(expenseRepositoryProvider).updateExpense(expense);
                  } else {
                    await controller.saveExpense(expense);
                  }
                  
                  if (mounted) navigator.pop();
                },
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_note_rounded : Icons.add_card_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isEditing ? 'Edit Expense' : 'Add New Expense',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SegmentedButton<ExpenseType>(
                showSelectedIcon: false,
                selected: {_expenseType},
                style: const ButtonStyle(
                  visualDensity: VisualDensity.standard,
                ),
                onSelectionChanged: (value) {
                  setState(() {
                    _expenseType = value.first;
                  });
                },
                segments: const [
                  ButtonSegment(
                    value: ExpenseType.personal,
                    icon: Icon(Icons.person_outline_rounded),
                    label: Text('Personal'),
                  ),
                  ButtonSegment(
                    value: ExpenseType.shared,
                    icon: Icon(Icons.groups_outlined),
                    label: Text('Shared'),
                  ),
                  ButtonSegment(
                    value: ExpenseType.reimbursement,
                    icon: Icon(Icons.handshake_outlined),
                    label: Text('Payback'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle('BASIC DETAILS'),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                decoration: _getInputDecoration(
                  label: 'Total Amount',
                  hint: '0.00',
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExpenseCategory>(
                value: _category,
                isExpanded: true,
                decoration: _getInputDecoration(
                  label: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: ExpenseCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_categoryIcons[category]!, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          category.name[0].toUpperCase() + category.name.substring(1),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                value: _paymentMethod,
                decoration: _getInputDecoration(
                  label: 'Payment Method',
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                ),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 8),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuart,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_expenseType != ExpenseType.personal) ...[
                      const SizedBox(height: 16),
                      _sectionTitle('EXTRA DETAILS'),
                      TextFormField(
                        controller: _personController,
                        decoration: _getInputDecoration(
                          label: _expenseType == ExpenseType.shared
                              ? 'Paid with'
                              : 'Payback from',
                          hint: 'Rahul, Mom...',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          if (_expenseType == ExpenseType.personal) return null;
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                      if (_expenseType == ExpenseType.shared) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _myShareController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _getInputDecoration(
                            label: 'Your Share',
                            hint: 'How much you spent',
                            prefixIcon: const Icon(Icons.face_retouching_natural_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter your share';
                            final total = double.tryParse(_amountController.text);
                            final share = double.tryParse(value);
                            if (share == null) return 'Invalid';
                            if (total != null && share > total) return 'Cannot exceed total';
                            return null;
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('ADDITIONAL INFO'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                minLines: 1,
                decoration: _getInputDecoration(
                  label: 'Description (Optional)',
                  hint: 'Add a note...',
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('DATE & TIME'),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Date & Time',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE, dd MMM yyyy • hh:mm a').format(_selectedDateTime),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
