import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/src/features/reimbursements/data/models/reimbursement_model.dart';

class ReimbursementRemoteDataSource {
  const ReimbursementRemoteDataSource(
      this._firestore,
      );

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
  _collection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('reimbursements');
  }

  Stream<List<ReimbursementModel>>
  watchReimbursements(
      String userId,
      ) {
    return _collection(userId)
        .orderBy(
      'createdAt',
      descending: true,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
        ReimbursementModel
            .fromFirestore,
      )
          .toList(),
    );
  }

  Future<void> addReimbursement(
      ReimbursementModel reimbursement,
      ) {
    return _collection(
      reimbursement.userId,
    )
        .doc(reimbursement.id)
        .set(
      reimbursement.toMap(),
    );
  }

  Future<void> updateReimbursement(
      ReimbursementModel reimbursement,
      ) {
    return _collection(
      reimbursement.userId,
    )
        .doc(reimbursement.id)
        .update(
      reimbursement.toMap(),
    );
  }

  Future<void> deleteReimbursement(
      String userId,
      String reimbursementId,
      ) {
    return _collection(userId)
        .doc(reimbursementId)
        .delete();
  }
}