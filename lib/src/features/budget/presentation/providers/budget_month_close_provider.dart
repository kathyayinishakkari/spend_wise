import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/core/provider/date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final closePastMonthsProvider =
FutureProvider<void>((ref) async {
  final user =
  ref.watch(currentUserProvider);

  if (user == null) {
    return;
  }

  final firestore =
  ref.watch(firestoreProvider);

  final now = ref.watch(currentDateProvider);
  //final now = DateTime(2026, 7, 3);

  final currentMonthKey =
      '${now.year}-${now.month.toString().padLeft(2, '0')}';

  final budgets =
  await firestore
      .collection('users')
      .doc(user.uid)
      .collection('budgets')
      .get();

  for (final budgetDoc in budgets.docs) {
    final data = budgetDoc.data();

    final monthKey =
    data['monthKey'] as String;

    final monthClosed =
        data['monthClosed'] ?? false;

    if (
    monthClosed ||
        monthKey == currentMonthKey
    ) {
      continue;
    }

    final expenses =
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('expenses')
        .get();

    double totalSpent = 0;

    for (final expenseDoc in expenses.docs) {
      final expenseData =
      expenseDoc.data();

      final timestamp =
      expenseData['dateTime']
      as Timestamp;

      final expenseDate =
      timestamp.toDate();

      final expenseMonth =
          '${expenseDate.year}-${expenseDate.month.toString().padLeft(2, '0')}';

      if (expenseMonth == monthKey) {
        totalSpent +=
            (expenseData['amount']
            as num)
                .toDouble();
      }
    }

    await budgetDoc.reference.update({
      'finalSpent': totalSpent,
      'monthClosed': true,
    });
  }
});