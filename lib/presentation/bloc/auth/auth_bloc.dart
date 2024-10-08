import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../domain/repository/user_local_repository.dart';
import '../../../helpers/firebase_crashlytics_catch/firebase_crashlytics_catch.dart';
import '../../../helpers/notifiaction_helper/notification_helper.dart';
import '../home_screen/home_screen_bloc.dart';
import '../home_screen/home_screen_event.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserLocalRepository _userRepository;
  final HomeScreenBloc _homeScreenBloc;

  AuthBloc(this._firebaseAuth, this._googleSignIn, this._userRepository,
      this._homeScreenBloc)
      : super(AuthInitial()) {
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
    on<AuthAuthenticated>(_onAuthAuthenticated);
    on<AuthUnauthenticated>(_onAuthUnauthenticated);

    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthAuthenticated(user));
      } else {
        add(AuthUnauthenticated());
      }
    });
  }

  void _onSignInWithEmail(
      SignInWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: event.email, password: event.password);
      await _userRepository.saveUser(userCredential.user!, "");
      _homeScreenBloc.add(SaveUserData(userCredential.user!, ""));
    } on FirebaseAuthException catch (e, s) {
      FireBaseCrashlyticsCatch().onErrorCatch(
          error: e.toString(),
          stackTrace: s,
          reason: "An unknown error occurred");
      emit(AuthFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  void _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      String token = await getToken();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure('Google sign-in aborted'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      await _userRepository.saveUser(user!, token);

      _homeScreenBloc.add(SaveUserData(user, token));
      // await saveUserData(user);
      emit(Authenticated(user));
    } on FirebaseAuthException catch (e, s) {
      FireBaseCrashlyticsCatch().onErrorCatch(
          error: e.toString(),
          stackTrace: s,
          reason: "An unknown error occurred");
      emit(AuthFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  void _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _userRepository.deleteUser();
      emit(AuthInitial());
    } catch (e, s) {
      FireBaseCrashlyticsCatch().onErrorCatch(
          error: e.toString(),
          stackTrace: s,
          reason: "An unknown error occurred");
      emit(const AuthFailure('An unknown error occurred try again'));
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      isLoggedIn = true;
      return _userRepository.getUser();
    } catch (e, s) {
      FireBaseCrashlyticsCatch().onErrorCatch(
          error: e.toString(),
          stackTrace: s,
          reason: "An unknown error occurred");
      isLoggedIn = false;
      return null;
    }
  }

  void _onAuthAuthenticated(AuthAuthenticated event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  void _onAuthUnauthenticated(
      AuthUnauthenticated event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<String> getToken() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? token = await _firebaseMessaging.getToken();

      print("FCM Token: $token");
      return token!;
    } catch (e, s) {
      FireBaseCrashlyticsCatch().onErrorCatch(
          error: e.toString(),
          stackTrace: s,
          reason: "An unknown error occurred");
      return '';
    }
  }
}

class AuthAuthenticated extends AuthEvent {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthEvent {
  @override
  List<Object?> get props => [];
}
