// expense_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';

class ExpenseRemoteDataSource {
  const ExpenseRemoteDataSource(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('expenses');

  Stream<List<ExpenseModel>> watchExpenses(String userId) {
    return _collection(userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ExpenseModel.fromFirestore).toList());
  }

  Future<void> addExpense(ExpenseModel expense) =>
      _collection(expense.userId).doc(expense.id).set(expense.toMap());

  Future<void> updateExpense(ExpenseModel expense) =>
      _collection(expense.userId).doc(expense.id).update(expense.toMap());

  Future<void> deleteExpense(String userId, String expenseId) =>
      _collection(userId).doc(expenseId).delete();
}