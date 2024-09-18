import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../domain/repository/user_local_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserLocalRepository _userRepository;

  AuthBloc(this._firebaseAuth, this._googleSignIn, this._userRepository)
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
      await _userRepository.saveUser(userCredential.user!);
      await saveUserData(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  void _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
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
      await _userRepository.saveUser(user!);

      await saveUserData(user);
      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  void _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _userRepository.deleteUser();
      emit(AuthInitial());
    } catch (e) {
      emit(const AuthFailure('An unknown error occurred try again'));
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    var mydata = _userRepository.getUser();
    print(mydata);
    return _userRepository.getUser();
  }

  void _onAuthAuthenticated(AuthAuthenticated event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  void _onAuthUnauthenticated(
      AuthUnauthenticated event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<void> saveUserData(User user) async {
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');

    await userCollection.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    });
  }

  // Future<List<Map<String, dynamic>>> fetchUsers() async {
  //   final firestore = FirebaseFirestore.instance;
  //   final userCollection = firestore.collection('users');
  //
  //   final querySnapshot = await userCollection.get();
  //   final userList = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   return userList;
  // }
  Stream<List<Map<String, dynamic>>> fetchUsersStream() {
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');

    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
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
