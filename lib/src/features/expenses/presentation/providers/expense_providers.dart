// expense_providers.dart
import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final expenseRemoteDataSourceProvider =
Provider<ExpenseRemoteDataSource>((ref) => ExpenseRemoteDataSource(ref.watch(firestoreProvider)));

final expenseRepositoryProvider =
Provider<ExpenseRepository>((ref) => ExpenseRepositoryImpl(ref.watch(expenseRemoteDataSourceProvider)));

final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(expenseRepositoryProvider).watchExpenses(user.uid);
});

final expenseFormControllerProvider = Provider((ref) => ExpenseFormController(ref));

class ExpenseFormController {
  ExpenseFormController(this.ref);
  final Ref ref;

  Future<void> saveExpense(ExpenseModel expense) async {
    await ref.read(expenseRepositoryProvider).addExpense(expense);
  }

  String generateId() => const Uuid().v4();
}