import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/reimbursements/data/datasources/reimbursement_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/reimbursements/data/reimbursement_repository_impl.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/reimbursement_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reimbursementRemoteDataSourceProvider =
Provider(
      (ref) =>
      ReimbursementRemoteDataSource(
        ref.watch(
          firestoreProvider,
        ),
      ),
);

final reimbursementRepositoryProvider =
Provider<ReimbursementRepository>(
      (ref) =>
      ReimbursementRepositoryImpl(
        ref.watch(
          reimbursementRemoteDataSourceProvider,
        ),
      ),
);

final reimbursementsProvider =
StreamProvider<List<Reimbursement>>(
      (ref) {
    final user =
    ref.watch(currentUserProvider);

    if (user == null) {
      return const Stream.empty();
    }

    return ref
        .watch(
      reimbursementRepositoryProvider,
    )
        .watchReimbursements(
      user.uid,
    );
  },
);