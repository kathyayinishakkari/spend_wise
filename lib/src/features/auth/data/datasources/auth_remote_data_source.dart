import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();
  Future<void> signOut() => _auth.signOut();
}