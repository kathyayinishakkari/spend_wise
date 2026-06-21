import 'package:expense_tracker_app/src/core/constants/app_enums.dart';

class Expense {
  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.dateTime,
    required this.expenseType,
    this.description,
    this.owedBy,
    this.reimbursementId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final double amount;
  final ExpenseCategory category;
  final String? description;
  final PaymentMethod paymentMethod;
  final DateTime dateTime;
  final ExpenseType expenseType;
  final OwedBy? owedBy;
  final String? reimbursementId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}