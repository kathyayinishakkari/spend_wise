import 'package:expense_tracker_app/src/core/constants/app_enums.dart';

class Reimbursement {
  const Reimbursement({
    required this.id,
    required this.userId,
    required this.expenseId,
    required this.totalAmount,
    required this.receivedAmount,
    required this.status,
    required this.personName,
    required this.source,
    required this.createdAt,
    this.settledAt,
  });

  final String id;
  final String userId;
  final String expenseId;
  final double totalAmount;
  final double receivedAmount;

  final ReimbursementStatus status;

  final String personName;

  final ReimbursementSource source;

  final DateTime createdAt;

  final DateTime? settledAt;

  double get pendingAmount =>
      totalAmount - receivedAmount;
}