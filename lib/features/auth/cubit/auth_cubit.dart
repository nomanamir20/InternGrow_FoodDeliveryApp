import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/auth_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user.uid];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthInitial());

  User? get currentUser => _authService.currentUser;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final credential = await _authService.signInWithEmail(email: email, password: password);
      emit(AuthAuthenticated(credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_authService.friendlyErrorMessage(e)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      await _authService.signUpWithEmail(email: email, password: password);
      await _authService.updateDisplayName(fullName);
      // Sign back out so the user logs in fresh with their new credentials,
      // rather than being auto-signed-in by account creation
      await _authService.signOut();
      emit(const AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_authService.friendlyErrorMessage(e)));
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(const AuthUnauthenticated());
  }
}