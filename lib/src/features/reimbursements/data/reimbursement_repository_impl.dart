import 'package:expense_tracker_app/src/features/reimbursements/data/datasources/reimbursement_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/reimbursements/data/models/reimbursement_model.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/reimbursement_repository.dart';

class ReimbursementRepositoryImpl
    implements ReimbursementRepository {
  const ReimbursementRepositoryImpl(
      this._remote,
      );

  final ReimbursementRemoteDataSource
  _remote;

  @override
  Stream<List<Reimbursement>>
  watchReimbursements(
      String userId,
      ) =>
      _remote.watchReimbursements(
        userId,
      );

  @override
  Future<void> addReimbursement(
      Reimbursement reimbursement,
      ) {
    return _remote.addReimbursement(
      reimbursement
      as ReimbursementModel,
    );
  }

  @override
  Future<void> updateReimbursement(
      Reimbursement reimbursement,
      ) {
    return _remote.updateReimbursement(
      reimbursement
      as ReimbursementModel,
    );
  }

  @override
  Future<void> deleteReimbursement(
      String userId,
      String reimbursementId,
      ) {
    return _remote
        .deleteReimbursement(
      userId,
      reimbursementId,
    );
  }
}