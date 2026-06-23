import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';

class ReimbursementModel extends Reimbursement {
  const ReimbursementModel({
    required super.id,
    required super.userId,
    required super.expenseId,
    required super.totalAmount,
    required super.receivedAmount,
    required super.status,
    required super.personName,
    required super.source,
    required super.monthKey,
    required super.createdAt,
    super.settledAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'expenseId': expenseId,
    'totalAmount': totalAmount,
    'receivedAmount': receivedAmount,
    'status': status.name,
    'personName': personName,
    'source': source.name,
    'monthKey': monthKey,
    'createdAt': Timestamp.fromDate(createdAt),
    'settledAt':
    settledAt == null
        ? null
        : Timestamp.fromDate(settledAt!),
  };

  factory ReimbursementModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return ReimbursementModel(
      id: doc.id,
      userId: data['userId'] as String,
      expenseId: data['expenseId'] as String,
      totalAmount:
      (data['totalAmount'] as num).toDouble(),
      receivedAmount:
      (data['receivedAmount'] as num).toDouble(),
      status: ReimbursementStatus.values.byName(
        data['status'] as String,
      ),
      personName:
      data['personName'] as String,
      source:
      ReimbursementSource.values.byName(
        data['source'] as String,
      ),
      monthKey:
      data['monthKey'] as String,
      createdAt:
      (data['createdAt'] as Timestamp)
          .toDate(),
      settledAt:
      (data['settledAt'] as Timestamp?)
          ?.toDate(),
    );
  }
}