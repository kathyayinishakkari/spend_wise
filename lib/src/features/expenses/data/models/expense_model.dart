import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.category,
    required super.paymentMethod,
    required super.dateTime,
    required super.expenseType,
    super.description,
    super.myShare,
    super.personName,
    super.reimbursementId,
    super.createdAt,
    super.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'amount': amount,
    'category': category.name,
    'description': description,
    'paymentMethod': paymentMethod.name,
    'dateTime': Timestamp.fromDate(dateTime),
    'expenseType': expenseType.name,
    'personName': personName,
    'myShare': myShare,
    'reimbursementId': reimbursementId,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory ExpenseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ExpenseModel(
      id: doc.id,
      userId: data['userId'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: ExpenseCategory.values.byName(data['category'] as String),
      description: data['description'] as String?,
      paymentMethod: PaymentMethod.values.byName(data['paymentMethod'] as String),
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      expenseType: ExpenseType.values.byName(data['expenseType'] as String),
      personName:data['personName'] as String?,
      myShare:(data['myShare'] as num?)?.toDouble(),
      reimbursementId: data['reimbursementId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}