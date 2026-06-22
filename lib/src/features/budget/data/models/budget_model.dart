import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/features/budget/domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.monthKey,
    required super.amount,
    required super.createdAt,
    super.finalSpent,
    super.monthClosed = false,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'monthKey': monthKey,
    'amount': amount,
    'createdAt': Timestamp.fromDate(createdAt),
    'finalSpent': finalSpent,
    'monthClosed': monthClosed,
  };

  factory BudgetModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BudgetModel(
      id: doc.id,
      userId: data['userId'] as String,
      monthKey: data['monthKey'] as String,
      amount: (data['amount'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      finalSpent:      (data['finalSpent'] as num?)
          ?.toDouble(),
      monthClosed:
      data['monthClosed'] ?? false,
    );
  }
}