// expense_repository_impl.dart
import 'package:expense_tracker_app/src/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._remote);
  final ExpenseRemoteDataSource _remote;

  @override
  Stream<List<Expense>> watchExpenses(String userId) => _remote.watchExpenses(userId);

  @override
  Future<void> addExpense(Expense expense) => _remote.addExpense(expense as ExpenseModel);

  @override
  Future<void> updateExpense(Expense expense) => _remote.updateExpense(expense as ExpenseModel);

  @override
  Future<void> deleteExpense(String userId, String expenseId) => _remote.deleteExpense(userId, expenseId);
}