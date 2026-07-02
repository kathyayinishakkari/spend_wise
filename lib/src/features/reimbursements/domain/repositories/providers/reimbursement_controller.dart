import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/features/reimbursements/data/models/reimbursement_model.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/src/core/services/notification_service.dart';

final reimbursementControllerProvider =
Provider(
      (ref) =>
      ReimbursementController(ref),
);

class ReimbursementController {
  ReimbursementController(this.ref);

  final Ref ref;

  Future<void> receivePayment({
    required Reimbursement reimbursement,
    required double amountReceived,
  }) async {
    final updatedReceived =
        reimbursement.receivedAmount +
            amountReceived;

    final status =
    updatedReceived >=
        reimbursement.totalAmount
        ? ReimbursementStatus.completed
        : ReimbursementStatus.partial;

    final updated =
    ReimbursementModel(
      id: reimbursement.id,
      userId: reimbursement.userId,
      expenseId: reimbursement.expenseId,
      totalAmount: reimbursement.totalAmount,
      receivedAmount: updatedReceived,
      status: status,
      personName: reimbursement.personName,
      source: reimbursement.source,
      monthKey: reimbursement.monthKey,
      createdAt: reimbursement.createdAt,
      settledAt: status ==
          ReimbursementStatus.completed
          ? DateTime.now()
          : null,
    );

    await ref
        .read(
      reimbursementRepositoryProvider,
    )
        .updateReimbursement(
      updated,
    );

    await NotificationService.instance.onPaybackReceived(reimbursement.personName, amountReceived);
  }

  Future<void> deleteReimbursement(
      Reimbursement reimbursement,
      ) async {
    await ref
        .read(
      reimbursementRepositoryProvider,
    )
        .deleteReimbursement(
      reimbursement.userId,
      reimbursement.id,
    );
  }
}