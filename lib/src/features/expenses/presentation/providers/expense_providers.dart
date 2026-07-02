// expense_providers.dart
import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_app/src/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_app/src/features/expenses/domain/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/services/notification_service.dart';

import 'package:expense_tracker_app/src/features/reimbursements/data/models/reimbursement_model.dart';

import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> saveExpense(ExpenseModel expense,) async {

    // PERSONAL EXPENSE
    if (expense.expenseType == ExpenseType.personal) {
      await ref
          .read(expenseRepositoryProvider)
          .addExpense(expense);

      await NotificationService.instance.checkBudgetNotifications(ref);

      return;
    }

    // SHARED EXPENSE
    if (expense.expenseType == ExpenseType.shared) {

      final sharedExpense = ExpenseModel(
        id: expense.id,
        userId: expense.userId,
        amount: expense.myShare ?? 0,
        category: expense.category,
        paymentMethod: expense.paymentMethod,
        dateTime: expense.dateTime,
        expenseType: expense.expenseType,
        personName: expense.personName,
        myShare: expense.myShare,
        description: expense.description,
        createdAt: expense.createdAt,
        updatedAt: expense.updatedAt,
      );

      await ref
          .read(expenseRepositoryProvider)
          .addExpense(sharedExpense);

      await NotificationService.instance.checkBudgetNotifications(ref);

      final reimbursementAmount =
          expense.amount - (expense.myShare ?? 0);

      final reimbursement = ReimbursementModel(
        id: const Uuid().v4(),
        userId: expense.userId,
        expenseId: expense.id,
        totalAmount: reimbursementAmount,
        receivedAmount: 0,
        status: ReimbursementStatus.pending,
        personName: expense.personName!,
        source: ReimbursementSource.shared,
        monthKey:
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}',
        createdAt: DateTime.now(),
      );

      await ref
          .read(reimbursementRepositoryProvider)
          .addReimbursement(reimbursement);

      return;
    }

    // REIMBURSEMENT EXPENSE
    if (expense.expenseType == ExpenseType.reimbursement) {

      final reimbursement = ReimbursementModel(
        id: const Uuid().v4(),
        userId: expense.userId,
        expenseId: expense.id,
        totalAmount: expense.amount,
        receivedAmount: 0,
        status: ReimbursementStatus.pending,
        personName: expense.personName!,
        source: ReimbursementSource.reimbursement,
        monthKey:
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}',
        createdAt: DateTime.now(),
      );

      await ref
          .read(reimbursementRepositoryProvider)
          .addReimbursement(reimbursement);

      return;
    }
  }

  String generateId() => const Uuid().v4();
}