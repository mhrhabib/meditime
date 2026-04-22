import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthUnauthenticated()) {
    _init();
  }

  final _client = Supabase.instance.client;

  void _init() {
    // Restore existing session on startup
    final session = _client.auth.currentSession;
    if (session != null) {
      final userId = session.user.id;
      emit(AuthAuthenticated(
        userId: userId,
        email: session.user.email ?? '',
      ));
      // Trigger sync on restore
      SyncService.instance.sync();
    }

    // Listen to future auth changes (token refresh, sign-out, etc.)
    _client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;
      
      if ((event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) && session != null) {
        final userId = session.user.id;
        
        // 1. Backfill local data with new accountId
        await AppDatabase.instance.backfillAccountId(userId);
        
        emit(AuthAuthenticated(
          userId: userId,
          email: session.user.email ?? '',
        ));

        // 2. Trigger initial sync
        SyncService.instance.sync();
      } else if (event == AuthChangeEvent.signedOut) {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthAuthenticating());
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      // State updated via onAuthStateChange listener above
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(const AuthAuthenticating());
    try {
      await _client.auth.signUp(email: email, password: password);
      // If email confirmation is off, the listener fires immediately.
      // If on, we stay unauthenticated until the link is clicked.
      final session = _client.auth.currentSession;
      if (session == null) {
        // Email verification required — resolve to unauthenticated + message
        emit(const AuthError(
            'Check your email to confirm your account, then sign in.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    emit(const AuthAuthenticating());
    try {
      await _client.auth.resetPasswordForEmail(email);
      emit(const AuthError('Password-reset email sent — check your inbox.'));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    // Listener handles the state transition to AuthUnauthenticated
  }

  String? get currentUserId => _client.auth.currentUser?.id;
}
