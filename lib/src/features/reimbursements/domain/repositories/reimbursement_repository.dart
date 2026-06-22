import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';

abstract class ReimbursementRepository {
  Stream<List<Reimbursement>>
  watchReimbursements(      String userId,      );

  Future<void> addReimbursement(      Reimbursement reimbursement,      );

  Future<void> updateReimbursement(      Reimbursement reimbursement,      );

  Future<void> deleteReimbursement(      String userId,      String reimbursementId,      );
}