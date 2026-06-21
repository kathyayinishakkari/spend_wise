import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/budget/data/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final currentMonthBudgetProvider =
FutureProvider<BudgetModel?>((ref) async {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return null;
  }

  final firestore =
  ref.watch(firestoreProvider);

  final now = DateTime.now();

  final monthKey =
      '${now.year}-${now.month.toString().padLeft(2, '0')}';

  final query =
    await firestore
      .collection('users')
      .doc(user.uid)
      .collection('budgets')
      .where(
    'userId',
    isEqualTo: user.uid,
  )
      .where(
    'monthKey',
    isEqualTo: monthKey,
  )
      .limit(1)
      .get();

  if (query.docs.isEmpty) {
    return null;
  }

  return BudgetModel.fromFirestore(
    query.docs.first,
  );
});

final saveCurrentMonthBudgetProvider =
Provider((ref) {
  return (
      double amount,
      ) async {
    final user =
    ref.read(currentUserProvider);

    if (user == null) return;

    final firestore =
    ref.read(firestoreProvider);

    final now = DateTime.now();

    final monthKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final budget = BudgetModel(
      id: const Uuid().v4(),
      userId: user.uid,
      monthKey: monthKey,
      amount: amount,
      createdAt: now,
    );

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .doc(budget.id)
        .set(
      budget.toMap(),
    );

    ref.invalidate(
      currentMonthBudgetProvider,
    );
  };
});