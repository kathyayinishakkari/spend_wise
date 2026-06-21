// auth_repository_impl.dart
import 'package:expense_tracker_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_tracker_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  @override
  Stream<User?> authStateChanges() => _remote.authStateChanges();

  @override
  User? get currentUser => _remote.currentUser;

  @override
  Future<void> signInAnonymously() async => _remote.signInAnonymously();

  @override
  Future<void> signOut() => _remote.signOut();
}