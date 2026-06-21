// auth_providers.dart
import 'package:expense_tracker_app/src/core/services/firebase_providers.dart';
import 'package:expense_tracker_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider =
Provider<AuthRemoteDataSource>((ref) => AuthRemoteDataSource(ref.watch(firebaseAuthProvider)));

final authRepositoryProvider =
Provider<AuthRepository>((ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)));

final currentUserProvider = Provider<User?>((ref) => ref.watch(authRepositoryProvider).currentUser);

final ensureAnonymousLoginProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  if (repo.currentUser == null) {
    await repo.signInAnonymously();
  }
});