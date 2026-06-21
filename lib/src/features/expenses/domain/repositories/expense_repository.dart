// expense_repository.dart
import 'package:expense_tracker_app/src/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses(String userId);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String userId, String expenseId);
}