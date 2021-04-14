import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:news/src/models/user.dart';

class LogInWithEmailAndPasswordFailure implements Exception {}

class SignUpFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({firebase_auth.FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AppUser.empty : toUser(firebaseUser);
    });
  }

  bool isEmailVerified() => _firebaseAuth.currentUser != null
      ? _firebaseAuth.currentUser.emailVerified
      : false;

  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> resetPassword({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signUp({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
    @required String dateOfBirth,
    @required String gender,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  AppUser toUser(User firebaseUser) {
    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      emailVerified: firebaseUser.emailVerified,
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      gender: '',
    );
  }
}
